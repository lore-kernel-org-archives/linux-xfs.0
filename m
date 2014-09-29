Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CC99A7FCB
	for <xfs@oss.sgi.com>; Sun, 28 Sep 2014 22:32:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BB23E304032
	for <xfs@oss.sgi.com>; Sun, 28 Sep 2014 20:32:51 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	urg40SXqCY4iEwY8 for <xfs@oss.sgi.com>;
	Sun, 28 Sep 2014 20:32:46 -0700 (PDT)
Date: Mon, 29 Sep 2014 13:32:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs/053: test for stale data exposure via
	falloc/writeback interaction
Message-ID: <20140929033244.GL4758@dastard>
References: <1411756349-4537-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411756349-4537-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Fri, Sep 26, 2014 at 02:32:29PM -0400, Brian Foster wrote:
> XFS buffered I/O writeback has a subtle race condition that leads to
> stale data exposure if the filesystem happens to crash after delayed
> allocation blocks are converted on disk and before data is written back
> to said blocks.
> 
> Use file allocation commands to attempt to reproduce a related, but
> slightly different variant of this problem. The associated falloc
> commands can lead to partial writeback that converts an extent larger
> than the range affected by falloc. If the filesystem crashes after the
> extent conversion but before all other cached data is written to the
> extent, stale data can be exposed.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> This fell out of a combination of a conversation with Dave about XFS
> writeback and buffer/cache coherency and some hacking I'm doing on the
> XFS zero range implementation. Note that fpunch currently fails the
> test. Also, this test is XFS specific primarily due to the use of
> godown.
.....
> +_crashtest()
> +{
> +	cmd=$1
> +	img=$SCRATCH_MNT/$seq.img
> +	mnt=$SCRATCH_MNT/$seq.mnt
> +	file=$mnt/file
> +
> +	# Create an fs on a small, initialized image. The pattern is written to
> +	# the image to detect stale data exposure.
> +	$XFS_IO_PROG -f -c "truncate 0" -c "pwrite 0 25M" $img \
> +		>> $seqres.full 2>&1
> +	$MKFS_XFS_PROG $MKFS_OPTIONS $img >> $seqres.full 2>&1
> +
> +	mkdir -p $mnt
> +	mount $img $mnt
> +
> +	echo $cmd
> +
> +	# write, run the test command and shutdown the fs
> +	$XFS_IO_PROG -f -c "pwrite -S 1 0 64k" -c "$cmd 60k 4k" $file | \
> +		_filter_xfs_io

So at this point the file is correctly 64k in size in memory.

> +	./src/godown -f $mnt

And here you tell godown to flush the log, so if there's a
transaction in the that sets the inode size to 64k.

> +	umount $mnt
> +	mount $img $mnt

Then log recovery will set the file size to 64k, and:

> +
> +	# we generally expect a zero-sized file (this should be silent)
> +	hexdump $file

This comment is not actually correct. I'm actually seeing 64k length
files after recovery in 2 of 3 cases being tested, so I don't think
this is a correct observation.

Some clarification of what is actually being tested is needed
here. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
