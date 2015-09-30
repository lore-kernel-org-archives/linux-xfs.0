Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1D2667F37
	for <xfs@oss.sgi.com>; Wed, 30 Sep 2015 11:53:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0DE09304059
	for <xfs@oss.sgi.com>; Wed, 30 Sep 2015 09:53:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IiUZxbMNopCnUfiP (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 30 Sep 2015 09:53:40 -0700 (PDT)
Date: Wed, 30 Sep 2015 12:53:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] test extending sub-block AIO writes for races
Message-ID: <20150930165337.GB16725@bfoster.bfoster>
References: <560B34E3.4080107@sandeen.net>
 <560C06E3.4090708@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <560C06E3.4090708@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: fstests <fstests@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Sep 30, 2015 at 10:59:31AM -0500, Eric Sandeen wrote:
> This tests bfoster's
> [PATCH 1/2] xfs: always drain dio before extending aio write submission
> patch; it launches four adjacent 1k IOs past EOF, then reads back
> to see if we have 4k worth of the data we wrote, or something else - 
> possibly zeros from sub-block zeroing and eof racing.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2:
> 	do 4x512 IOs to get as much sub-block goodness as possible
> 	fix up comments & typos
> 
> diff --git a/src/aio-dio-regress/aio-dio-eof-race.c b/src/aio-dio-regress/aio-dio-eof-race.c
> new file mode 100644
> index 0000000..ce5d715
> --- /dev/null
> +++ b/src/aio-dio-regress/aio-dio-eof-race.c
> @@ -0,0 +1,173 @@
...
> +void
> +dump_buffer(
> +	void	*buf,
> +	off64_t	offset,
> +	ssize_t	len)
> +{
> +	int	i, j;
> +	char	*p;
> +	int	new;
> +	

Whitespace damage on the line above...

> +	for (i = 0, p = (char *)buf; i < len; i += 16) {
> +		char    *s = p;
> +
...
> +
> +	}
> +	printf("%08llx\n", (unsigned long long)offset + i);
> +}
> +
> +int main(int argc, char *argv[])
> +{
...
> +		/*
> +		 * Split the buffer into multiple I/Os to send a mix of block
> +		 * aligned/unaligned writes as well as writes that start beyond
> +		 * the current EOF. This stresses things like inode size
> +		 * management and stale block zeroing for races and can lead to
> +		 * data corruption when not handled properly.
> +		 */
> +		io_prep_pwrite(&iocb1, fd, buf, BUF_SIZE/4, eof + 0*BUF_SIZE/4);
> +		io_prep_pwrite(&iocb2, fd, buf, BUF_SIZE/4, eof + 1*BUF_SIZE/4);
> +		io_prep_pwrite(&iocb3, fd, buf, BUF_SIZE/4, eof + 2*BUF_SIZE/4);
> +		io_prep_pwrite(&iocb4, fd, buf, BUF_SIZE/4, eof + 3*BUF_SIZE/4);
> +	

... and above here as well. Otherwise looks good to me. Thanks again!

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +		err = io_submit(ctx, 4, iocbs);
> +		if (err != 4) {
> +			fprintf(stderr, "error %s during %s\n",
> +				strerror(err),
> +				"io_submit");
> +			return 1;
> +		}
> +
> +		err = io_getevents(ctx, 4, 4, evs, NULL);
> +		if (err != 4) {
> +			fprintf(stderr, "error %s during %s\n",
> +				strerror(err),
> +				"io_getevents");
> +			return 1;
> +		}
> +
> +		/*
> +		 * And then read it back.
> +		 *
> +		 * Using pread to keep it simple, but AIO has the same effect.
> +		 * eof is the prior eof; we just wrote BUF_SIZE more.
> +		 */
> +		if (pread(fd, buf, BUF_SIZE, eof) != BUF_SIZE) {
> +			perror("pread");
> +			return 1;
> +		}
> +
> +		/*
> +		 * We launched 4 AIOs which, stitched together, should write
> +		 * a seamless BUF_SIZE worth of IO_PATTERN to the last block.
> +		 */
> +		if (memcmp(buf, cmp_buf, BUF_SIZE)) {
> +			printf("corruption while extending from %ld\n", eof);
> +			dump_buffer(buf, 0, BUF_SIZE);
> +			return 1;
> +		}
> +	}
> +
> +	printf("Success, all done.\n");
> +	return 0;
> +}
> diff --git a/tests/generic/326 b/tests/generic/326
> new file mode 100755
> index 0000000..f20375a
> --- /dev/null
> +++ b/tests/generic/326
> @@ -0,0 +1,65 @@
> +#! /bin/bash
> +# FS QA Test No. 326
> +#
> +# Test races while extending past EOF via sub-block AIO writes
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2015 Red Hat, Inc.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
> +    rm -f $TEST_DIR/tst-aio-dio-eof-race
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +_supported_fs generic
> +_supported_os Linux
> +
> +_require_test
> +_require_sparse_files
> +_require_aiodio aio-dio-eof-race
> +
> +# Test does 512 byte DIO, so make sure that'll work
> +logical_block_size=`_min_dio_alignment $TEST_DEV`
> +
> +if [ "$logical_block_size" -gt "512" ]; then
> +	_notrun "device block size: $logical_block_size greater than 512"
> +fi
> +
> +# We don't mind 512-byte fs blocks; the IOs won't be sub-block,
> +# but the test should still pass, even if it doesn't stress the code
> +# we're targeting.
> +
> +# Note, this test does several extending loops internally
> +$AIO_TEST $TEST_DIR/tst-aio-dio-eof-race
> +
> +status=$?
> +exit
> diff --git a/tests/generic/326.out b/tests/generic/326.out
> new file mode 100644
> index 0000000..22a3e78
> --- /dev/null
> +++ b/tests/generic/326.out
> @@ -0,0 +1,2 @@
> +QA output created by 326
> +Success, all done.
> diff --git a/tests/generic/group b/tests/generic/group
> index 4ae256f..a5f3008 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -207,3 +207,4 @@
>  323 auto aio stress
>  324 auto fsr quick
>  325 auto quick data log
> +326 auto quick aio
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
