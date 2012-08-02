Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q72NUVIY254700 for <xfs@oss.sgi.com>; Thu, 2 Aug 2012 18:30:31 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	FuTovKo7Cis7AcGZ for <xfs@oss.sgi.com>;
	Thu, 02 Aug 2012 16:30:29 -0700 (PDT)
Date: Fri, 3 Aug 2012 09:30:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_db: bug in bmap command?
Message-ID: <20120802233025.GP2877@dastard>
References: <CAH4wwdGbecJ42ONkk3WQRhqUuLUALaSHP-+Ran0Lu8aofW5M8A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAH4wwdGbecJ42ONkk3WQRhqUuLUALaSHP-+Ran0Lu8aofW5M8A@mail.gmail.com>
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
To: Peter Watkins <treestem@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 01, 2012 at 11:17:13AM -0400, Peter Watkins wrote:
> Hello,
> 
> If you have a moment would you be kind enough to review the test case
> and patch below?
> 
> I ran into this while using xfs_db to dump extents for a large,
> fragmented file. The extents were stored in btree form.
> 
> -Peter
> 
> -- 
> This message has been scanned for viruses and
> dangerous content by MailScanner, and is
> believed to be clean.
> 

> From a66128fd25639c04de366c492fe2f1ce6cf8dba4 Mon Sep 17 00:00:00 2001
> From: Peter Watkins <treestem@gmail.com>
> Date: Tue, 31 Jul 2012 14:07:04 -0400
> Subject: [PATCH] xfstests: add test 287 for xfs_db bmap
> 
> Test dumping a file bmap large enough to be in btree form.
> 
> Signed-off-by: Peter Watkins <treestem@gmail.com>
> ---
>  287     |  108 ++
>  287.out | 4101 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  group   |    1 +
>  3 files changed, 4210 insertions(+), 0 deletions(-)
>  create mode 100755 287
>  create mode 100644 287.out
> 
> diff --git a/287 b/287
> new file mode 100755
> index 0000000..3e82a89
> --- /dev/null
> +++ b/287
> @@ -0,0 +1,108 @@
> +#! /bin/bash
> +# FS QA Test No. 301

Test 301? You have another 15 or tests before this one?

> +_do_frag()
> +{
> +	num_bytes=$(($1*1024*1024))
> +	hole=$((64*1024))

Why select a hole of only 64k?

> +	cycle=$((2*$hole))
> +	cycles=$(($num_bytes/$cycle))
> +
> +	$XFS_IO_PROG -f -c "resvsp 0 $num_bytes" $work_file
> +
> +	i=0
> +	for cc in `seq 1 $cycles` ; do
> +    	  $XFS_IO_PROG -c "unresvsp $i $hole" $work_file
> +    	  i=$(($i+$cycle))

Indents are 8 space tabs...

> +	done

All you are trying to create is a fragmented file with lots of
extents, right? Then just doing:

	for i in `seq 1 $num`; do
		$XFS_IO_PROG -c "resvsp $(($i * 128))k 4k" $workfile
	done

should create a block every 128k. That will work on filesystems up
to the maximum supported block size of 64k. Allocating space then
punching holes out of it is not necessary, as the hole between each
block is all that is necessary to create separate extents.

There doesn't appear to be a need for a fixed size file, as btree
format occurs once the number of extents exceeds what can fit in in
the inode.

i.e. there are 3 forms:
	- local: data fits in inode literal area
	- extent: extent records in inode literal area
	- btree: extent btree root in inode literal area.

Given that an extent record is 16 bytes, the maximum that can be
stored in any inode is roughly 120 (2k inodes with no attributes).
Hence creating thousands of extents is not necessary to move the
inode into btree format.

But, just creating a btree format extent tree with 120 extents (i.e.
single leaf block btree) doesn't hang. Nor does a 2 leaf block
tree.... Ok, so the problem isn't as obvious as the description
makes it seem.

Ah, It doesn't hang until a root split occurs when we move to a
2-level tree (root->node->leaf). That's worth documenting in the
test. i.e. it's not testing single level btree formats as such, it's
testing node format btrees....

> +rm -f $seq.full
> +
> +_scratch_mkfs -i attr=2,size=256 -l lazy-count=1 >/dev/null 2>&1

They are all mkfs defaults, so no need to specify them.

> new file mode 100644
> index 0000000..91bed13
> --- /dev/null
> +++ b/287.out
> @@ -0,0 +1,4101 @@
> +QA output created by 301
> +u.bmbt.level = 2
> +u.bmbt.numrecs = 1
> +u.bmbt.keys[1] = [startoff] 1:[16]

This fails right here on my test machines - it doesn't allocate
blocks in the same place. The filtering is not correct - they should
be nothing that is dependent on block size, filesytsem layout, etc
in the golden output. e.g. this should read:

data offset 3696 startblock 3708 (0/3708) count 16 flag 1

something like

data offset OFF startblock SBLK (AG/BNO) count CNT flag 1

if it is correctly filtered. As soon as the filesytem size, mkfs or
mount options change, you can't rely on any of these being correct -
no even that allocation occurs in the same AG on an empty
filesystem....

FWIW, if this is just a hang/pass test, then this output should be
in $seq.full, not $seq.out as it is not necessary for verifying the
correct operation of the xfs_db command. That also gets around the
problem of needing massive amounts of output in the $seq.out file.

> diff --git a/group b/group
> index cbe9101..2f2ae9f 100644
> --- a/group
> +++ b/group
> @@ -405,3 +405,4 @@ deprecated
>  284 auto
>  285 auto rw
>  286 other
> +287 db

And auto group, as well, otherwise it will never get run....

> Subject: [PATCH] xfs_db: bmap dump uses wrong btree key/ptr macro

One patch per email, please.

> When dumping the bmap with extents in btree form, the traversal
> code should use XFS_BMBT_ macros instead of XFS_BMDR_ macros to
> access the key and pointer fields below the root node.
> 
> Signed-off-by: Peter Watkins <treestem@gmail.com>
> ---
>  db/bmap.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/db/bmap.c b/db/bmap.c
> index ddad49c..0ef7a62 100644
> --- a/db/bmap.c
> +++ b/db/bmap.c
> @@ -101,9 +101,9 @@ bmap(
>  			block = (struct xfs_btree_block *)iocur_top->data;
>  			if (be16_to_cpu(block->bb_level) == 0)
>  				break;
> -			pp = XFS_BMDR_PTR_ADDR(block, 1,
> +			pp = XFS_BMBT_PTR_ADDR(mp, block, 1,
>  				xfs_bmbt_maxrecs(mp, mp->m_sb.sb_blocksize, 0));
> -			kp = XFS_BMDR_KEY_ADDR(block, 1);
> +			kp = XFS_BMBT_KEY_ADDR(mp, block, 1);

That, I'm pretty sure, is wrong, too, because the root block is a
different format to the tree blocks. IOWs,the old code parses
tree node blocks with the root block format macro, while your code
parses the root node with tree block format macros. Both are wrong.
The original was also wrong in that it used xfs_bmbt_maxrecs()
instead of xfs_bmdr_maxrecs() for the number of records in the inode
root block.

I think the correct fix is to use the correct macro depending on the
level of the block being processed. i.e.

		if (block->bb_level == rblock->bb_level) {
			/* root block in inode */
			sz = whichfork = XFS_DATA_FORK ?
					XFS_BMDR_SPACE_CALC(MINDBTPTRS) :
					XFS_BMDR_SPACE_CALC(MINABTPTRS);
			pp = XFS_BMDR_PTR_ADDR(block, 1,
					xfs_bmdr_maxrecs(mp, sz, 0));
			kp = XFS_BMDR_KEY_ADDR(block, 1);
		} else {
			/* node block in tree */
			pp = XFS_BMBT_PTR_ADDR(mp, block, 1,
				xfs_bmbt_maxrecs(mp, mp->m_sb.sb_blocksize, 0));
			kp = XFS_BMBT_KEY_ADDR(mp, block, 1);
		}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
