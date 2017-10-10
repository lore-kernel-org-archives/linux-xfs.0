Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54896 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750950AbdJJGuz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Oct 2017 02:50:55 -0400
Date: Tue, 10 Oct 2017 14:50:50 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] generic: test race when checking i_size on direct i/o
 read
Message-ID: <20171010065050.GJ10593@eguan.usersys.redhat.com>
References: <20170925101847.29539-1-eguan@redhat.com>
 <20171009163951.GB19847@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171009163951.GB19847@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>, Eric Sandeen <sandeen@redhat.com>

On Mon, Oct 09, 2017 at 12:39:52PM -0400, Brian Foster wrote:
> On Mon, Sep 25, 2017 at 06:18:47PM +0800, Eryu Guan wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > In this commit a new test case is added to test that i_size races
> > don't occur under dio reads/writes.  We add a program in /src dir,
> > which has a writer to issue some append dio writes.  Meanwhile it
> > has a reader in this test to do some dio reads.  As we expect,
> > reader should read nothing or data with 'a'. But it might read some
> > data with '0'.
> > 
> > The bug can be reproduced by this test case [1].
> > 
> > 1.  http://patchwork.ozlabs.org/patch/311761/
> > 
> > This ostensibly tests commit:
> > 9fe55eea7 Fix race when checking i_size on direct i/o read
> > 
> > Update by Eric Sandeen:
> > - update to recent xfstests
> > - update commit log
> > 
> > Update by Eryu Guan:
> > - add aio-dio support to the test and add 'aio' group
> > - add ability to test different alignments
> > - move test from src/ to src/aio-dio-regress/
> > - add .gitignore entry
> > - rebase against latest xfstests with various minor fixes & cleanups
> > - update commit log
> > 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > ---
> > This test fails on XFS, the following patch fixed the XFS failure
> > https://www.spinics.net/lists/linux-xfs/msg10865.html
> > 
> > btrfs also fails when io alignment is not 4k, perhaps a btrfs bug?
> > 
> > Eric's original post
> > http://www.spinics.net/lists/fstests/msg06978.html
> > 
> >  .gitignore                                         |   1 +
> >  .../aio-dio-append-write-read-race.c               | 214 +++++++++++++++++++++
> >  tests/generic/462                                  |  75 ++++++++
> >  tests/generic/462.out                              |   3 +
> >  tests/generic/group                                |   1 +
> >  5 files changed, 294 insertions(+)
> >  create mode 100644 src/aio-dio-regress/aio-dio-append-write-read-race.c
> >  create mode 100755 tests/generic/462
> >  create mode 100644 tests/generic/462.out
> > 
> ...
> > diff --git a/src/aio-dio-regress/aio-dio-append-write-read-race.c b/src/aio-dio-regress/aio-dio-append-write-read-race.c
> > new file mode 100644
> > index 000000000000..dce2ab743f11
> > --- /dev/null
> > +++ b/src/aio-dio-regress/aio-dio-append-write-read-race.c
> > @@ -0,0 +1,214 @@
> ...
> > +
> > +int main(int argc, char *argv[])
> > +{
> ...
> > +	for (i = 0; i < max_blocks; i++) {
> > +		wdata.offset = i * blksize;
> > +		if (use_aio)
> > +			ret = pthread_create(&tid, NULL, aio_writer, &wdata);
> > +		else
> > +			ret = pthread_create(&tid, NULL, dio_writer, &wdata);
> > +		if (ret) {
> > +			fprintf(stderr, "create thread failed: %s\n",
> > +				strerror(ret));
> > +			ret = 1;
> > +			goto err;
> > +		}
> > +
> > +		memset(rbuf, 'b', blksize);
> > +		do {
> > +			ret = pread(rfd, rbuf, blksize, i * blksize);
> > +			if (ret < 0)
> > +				perror("read file");
> > +		} while (ret <= 0);
> 
> Hmm, so IIUC the objective is to kick off a writer thread then issue
> reads in a loop to try and guarantee that the first valid read returns
> valid data. By kicking off the writer first, aren't we risking the test
> could be silently ineffective if the writer thread happens to run early
> enough to miss the conversion? I'm wondering if it might be more
> reliable to start the reader in a background thread first and signal a
> condition once it starts issuing reads. Then wait for the condition here
> and invoke the appropriate writer func directly.

Makes sense, I'll convert it to run reader in a thread and only start
writer after reader is ready. Thanks for the review!

Eryu

> 
> Brian
> 
> > +
> > +		ret = pthread_join(tid, NULL);
> > +		if (ret) {
> > +			fprintf(stderr, "pthread join failed: %s\n",
> > +				strerror(ret));
> > +			ret = 1;
> > +			goto err;
> > +		}
> > +
> > +		for (j = 0; j < blksize; j++) {
> > +			if (rbuf[j] != 'a') {
> > +				fprintf(stderr, "encounter an error: "
> > +					"block %d offset %d, content %x\n",
> > +					i, j, rbuf[j]);
> > +				ret = 1;
> > +				goto err;
> > +			}
> > +		}
> > +	}
> > +
> > +err:
> > +	if (rfd)
> > +		close(rfd);
> > +	if (wfd)
> > +		close(wfd);
> > +	if (rbuf)
> > +		free(rbuf);
> > +	if (wbuf)
> > +		free(wbuf);
> > +
> > +	exit(ret);
> > +}
> > diff --git a/tests/generic/462 b/tests/generic/462
> > new file mode 100755
> > index 000000000000..7abadcb11921
> > --- /dev/null
> > +++ b/tests/generic/462
> > @@ -0,0 +1,75 @@
> > +#! /bin/bash
> > +# FS QA Test No. 462
> > +#
> > +# Test i_size is updated properly under dio read/write
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2013 Alibaba Group.  All Rights Reserved.
> > +# Copyright (c) 2017 Red Hat Inc. All Rights Reserved.
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#-----------------------------------------------------------------------
> > +#
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.* $testfile.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_supported_os Linux
> > +
> > +_require_aiodio aio-dio-append-write-read-race
> > +_require_test_program "feature"
> > +
> > +testfile=$TEST_DIR/$seq.$$
> > +min_dio_align=`_min_dio_alignment $TEST_DEV`
> > +page_size=`$here/src/feature -s`
> > +
> > +rm -f $seqres.full
> > +
> > +echo "non-aio dio test"
> > +align=$min_dio_align
> > +while [ $align -le $page_size ]; do
> > +	echo "$AIO_TEST -a $align -d $testfile.$align" >> $seqres.full
> > +	$AIO_TEST -a $align -d $testfile.$align 2>&1 | tee -a $seqres.full
> > +	align=$((align * 2))
> > +done
> > +
> > +echo "aio-dio test"
> > +align=$min_dio_align
> > +while [ $align -le $page_size ]; do
> > +	echo "$AIO_TEST -a $align $testfile.$align" >> $seqres.full
> > +	$AIO_TEST -a $align $testfile.$align 2>&1 | tee -a $seqres.full
> > +	align=$((align * 2))
> > +done
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/462.out b/tests/generic/462.out
> > new file mode 100644
> > index 000000000000..9a368005af49
> > --- /dev/null
> > +++ b/tests/generic/462.out
> > @@ -0,0 +1,3 @@
> > +QA output created by 462
> > +non-aio dio test
> > +aio-dio test
> > diff --git a/tests/generic/group b/tests/generic/group
> > index dfa86edc4a93..c65058976f1e 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -464,3 +464,4 @@
> >  459 auto dangerous
> >  460 auto quick rw
> >  461 auto rw
> > +462 auto rw quick aio
> > -- 
> > 2.13.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
