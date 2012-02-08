Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q188uDLX052035 for <xfs@oss.sgi.com>; Wed, 8 Feb 2012 02:56:13 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	CDv5zAGXjEmtBfkW for <xfs@oss.sgi.com>;
	Wed, 08 Feb 2012 00:56:11 -0800 (PST)
Date: Wed, 8 Feb 2012 19:55:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/2] xfstests: introduce 280 for SEEK_DATA/SEEK_HOLE
	copy check
Message-ID: <20120208085557.GI20305@dastard>
References: <4F2FE410.2040508@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F2FE410.2040508@oracle.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Mon, Feb 06, 2012 at 10:30:40PM +0800, Jeff Liu wrote:
> Introduce 280 for SEEK_DATA/SEEK_HOLE copy check.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

This has the same problems with $seq.out as 279, so I won't repeat
them here.

.....
> +_cleanup()
> +{
> +	rm -f $src $dest
> +}
> +
> +# seek_copy_test_01()
> +# create a 100Mytes file in preallocation mode.
> +# fallocate offset start from 0.
> +# the first data extent offset start from 80991, write 4Kbytes,
> +# and then skip 195001 bytes for next write.

Oh, man, you didn't write a program to do this, do you? This is what
xfs_io is for - to create arbitary file configurations as quickly as
you can type them.  Then all you need is a simple program that
copies the extents, and the test can check everything else.

> +# this is intended to test data buffer lookup for DIRTY pages.
> +# verify results:
> +# 1. file size is identical.
> +# 2. perform cmp(1) to compare SRC and DEST file byte by byte.
> +test01()
> +{
> +	rm -f $src $dest
> +
> +	$here/src/seek_copy_tester -P -O 0 -L 100m -s 80991 -k 195001 -l 4k $src $dest
> +
> +	test $(stat --printf "%s" $src) = $(stat --printf "%s" $dest) ||
> +		echo "TEST01: file size check failed" >> $seq.out
> +
> +	cmp $src $dest						      ||
> +		echo "TEST01: file bytes check failed" >> $seq.out

A quick hack (untested) to replace this file creation with xfs_io
would be:

test01()
{
	write_cmd="-c \"truncate 0\" -c \"falloc 0 100m\""
	for i in `seq 0 1 100`; do
		offset=$((80991 + $i * 195001))
		write_cmd="$write_cmd -c \"pwrite $offset 4k\""
	done
	xfs_io -F -f $write_cmd $src

	$here/scr/sparse_cp $src $dst
	stat --printf "%s\n" $src $dst
	cmp $src $dst >> $seq.out || _fail "file bytes check failed"
}


> +}
> +
> +# seek_copy_test_02()
> +# create a 100Mytes file in preallocation mode.
> +# fallocate offset start from 0.
> +# the first data extent offset start from 0, write 16Kbytes,
> +# and then skip 8Mbytes for next write.
> +# Try flushing DIRTY pages to WRITEBACK mode, this is intended to
> +# test data buffer lookup in WRITEBACK pages.

There's no guarantee that that the seeks will occur while the pages
are in the writeback. It's entirely dependent on IO latency -
writing 16k of data to a disk cache will take less time than it
takes to go back up into userspace and start the sparse copy.
Indeed, i suspect that the 16x16k IOs that this tes does will fit
all into that category even on basic SATA configs....

Also, you could the fadvise command in xfs_io to do this, as
POSIX_FADV_DONTNEED will trigger async writeback -it will then skip
invalidation of pages under writeback so they will remain in the
cache. i.e. '-c "fadvise -d 0 100m"'

Ideally, we should add all the different sync methods to an xfs_io
command...

> +# the first data extent offset start from 512, write 4Kbytes,
> +# and then skip 1Mbytes for next write.
> +# don't make holes at the end of file.

I'm not sure what this means - you always write zeros at the end of
file, and the only difference is that "make holes at EOF" does an
ftruncate to the total size before writing zeros up to it. It
appears to me like you end up with the same file size and shape
either way....

> --- /dev/null
> +++ b/280.out
> @@ -0,0 +1 @@
> +QA output created by 280

Normally we echo "silence is golden" to the output
file in this case of no real output to indicate that this empty
output file is intentional.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
