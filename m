Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q72MJVMm245126 for <xfs@oss.sgi.com>; Thu, 2 Aug 2012 17:19:31 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id y7ItIzyrq6akIwfF for <xfs@oss.sgi.com>;
	Thu, 02 Aug 2012 15:19:30 -0700 (PDT)
Message-ID: <501AFCF1.70804@sandeen.net>
Date: Thu, 02 Aug 2012 17:19:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_db: bug in bmap command?
References: <CAH4wwdGbecJ42ONkk3WQRhqUuLUALaSHP-+Ran0Lu8aofW5M8A@mail.gmail.com>
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

On 8/1/12 10:17 AM, Peter Watkins wrote:
> Hello,
> 
> If you have a moment would you be kind enough to review the test case
> and patch below?
> 
> I ran into this while using xfs_db to dump extents for a large,
> fragmented file. The extents were stored in btree form.

The xfs_db change looks right.  Way back when, commit
b3563c19992d0453db1826ffdbf0be6039998023 did this:

@@ -91,29 +91,27 @@ bmap(
                bno = NULLFSBLOCK;
                rblock = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
                fsize = XFS_DFORK_SIZE(dip, mp, whichfork);
-               pp = XFS_BTREE_PTR_ADDR(xfs_bmdr, rblock, 1,
-                       XFS_BTREE_BLOCK_MAXRECS(fsize, xfs_bmdr, 0));
-               kp = XFS_BTREE_KEY_ADDR(xfs_bmdr, rblock, 1);
+               pp = XFS_BMDR_PTR_ADDR(rblock, 1, xfs_bmdr_maxrecs(mp, fsize, 0));
+               kp = XFS_BMDR_KEY_ADDR(rblock, 1);
                bno = select_child(curoffset, kp, pp, 
                                        be16_to_cpu(rblock->bb_numrecs));
                for (;;) {
                        set_cur(&typtab[typ], XFS_FSB_TO_DADDR(mp, bno),
                                blkbb, DB_RING_IGN, NULL);
-                       block = (xfs_bmbt_block_t *)iocur_top->data;
+                       block = (struct xfs_btree_block *)iocur_top->data;
                        if (be16_to_cpu(block->bb_level) == 0)
                                break;
-                       pp = XFS_BTREE_PTR_ADDR(xfs_bmbt, block, 1,
-                               XFS_BTREE_BLOCK_MAXRECS(mp->m_sb.sb_blocksize,
-                                       xfs_bmbt, 0));
-                       kp = XFS_BTREE_KEY_ADDR(xfs_bmbt, block, 1);
+                       pp = XFS_BMDR_PTR_ADDR(block, 1,
+                               xfs_bmbt_maxrecs(mp, mp->m_sb.sb_blocksize, 0));
+                       kp = XFS_BMDR_KEY_ADDR(block, 1);


as part of a kernel<->userspace syncup.  But you can see that some "bmdt's"
turned into "bmdr's" along the way.  Surprised that hasn't been found sooner!

I wonder if there's a way to make to make a testcase which a) doesn't require
256k of "good" output, and b) more robust to failure (a timeout & kill might
let it proceed...)

-Eric

> -Peter
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
