Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Mar 2008 22:02:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2Q524GB013496
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 22:02:06 -0700
Date: Wed, 26 Mar 2008 16:02:08 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [opensuse] nfs_update_inode: inode X mode changed, Y to Z
Message-ID: <20080326050208.GH108924158@sgi.com>
References: <9a8748490803121516u36395872i70cc88b0439adc74@mail.gmail.com> <18394.1501.991087.80264@notabene.brown> <47DAEFD0.9020407@m2000.com> <47E92F8E.7030504@m2000.com> <20080325190943.GF2237@fieldses.org> <32953.192.168.1.70.1206477121.squirrel@neil.brown.name> <20080325212425.GA20257@josefsipek.net> <34178.192.168.1.70.1206481102.squirrel@neil.brown.name> <20080325221321.GC20257@josefsipek.net> <20080326033738.GX103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326033738.GX103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, NeilBrown <neilb@suse.de>, "J. Bruce Fields" <bfields@fieldses.org>, xfs@oss.sgi.com, Adam Schrotenboer <adam@m2000.com>, Jesper Juhl <jesper.juhl@gmail.com>, Trond Myklebust <trond.myklebust@netapp.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, Thomas Daniel <tdaniel@m2000.com>, Frederic Revenu <frevenu@m2000.com>, Jeff Doan <jdoan@m2000.com>

On Wed, Mar 26, 2008 at 02:37:38PM +1100, David Chinner wrote:
> Given this state of affairs (i.e. HSM using ikeep), I guess we can do
> anything we want for the noikeep case. I'll cook up a patch that does
> something similar to ext3 generation numbers for the initial seeding....

Patch below for comments. It passes xfsqa, but there's no userspace
support for it yet. 2.6.26 is the likely target for this change.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---

Don't initialise new inode generation numbers to zero

When we allocation new inode chunks, we initialise the generation
numbers to zero. This works fine until we delete a chunk and then
reallocate it, resulting in the same inode numbers but with a
reset generation count. This can result in inode/generation
pairs of different inodes occurring relatively close together.

Given that the inode/gen pair makes up the "unique" portion of
an NFS filehandle on XFS, this can result in file handles cached
on clients being seen on the wire from the server but refer to
a different file. This causes .... issues for NFS clients.

Hence we need a unique generation number initialisation for
each inode to prevent reuse of a small portion of the generation
number space. Make this initialiser per-allocation group so
that it is not a single point of contention in the filesystem,
and increment it on every allocation within an AG to reduce the
chance that a generation number is reused for a given inode number
if the inode chunk is deleted and reallocated immediately
afterwards.

It is safe to add the agi_newinogen field to the AGI without
using a feature bit. If an older kernel is used, it simply
will not update the field on allocation. If the kernel is
updated and the field has garbage in it, then it's like having a
random seed to the generation number....

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_ag.h     |    4 +++-
 fs/xfs/xfs_ialloc.c |   30 ++++++++++++++++++++++--------
 2 files changed, 25 insertions(+), 9 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_ag.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ag.h	2008-01-18 18:30:06.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_ag.h	2008-03-26 13:03:41.122918236 +1100
@@ -121,6 +121,7 @@ typedef struct xfs_agi {
 	 * still being referenced.
 	 */
 	__be32		agi_unlinked[XFS_AGI_UNLINKED_BUCKETS];
+	__be32		agi_newinogen;	/* inode cluster generation */
 } xfs_agi_t;
 
 #define	XFS_AGI_MAGICNUM	0x00000001
@@ -134,7 +135,8 @@ typedef struct xfs_agi {
 #define	XFS_AGI_NEWINO		0x00000100
 #define	XFS_AGI_DIRINO		0x00000200
 #define	XFS_AGI_UNLINKED	0x00000400
-#define	XFS_AGI_NUM_BITS	11
+#define	XFS_AGI_NEWINOGEN	0x00000800
+#define	XFS_AGI_NUM_BITS	12
 #define	XFS_AGI_ALL_BITS	((1 << XFS_AGI_NUM_BITS) - 1)
 
 /* disk block (xfs_daddr_t) in the AG */
Index: 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ialloc.c	2008-03-25 15:41:27.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c	2008-03-26 14:29:47.998554368 +1100
@@ -309,6 +309,8 @@ xfs_ialloc_ag_alloc(
 			free = XFS_MAKE_IPTR(args.mp, fbuf, i);
 			free->di_core.di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 			free->di_core.di_version = version;
+			free->di_core.di_gen = agi->agi_newinogen;
+			be32_add_cpu(&agi->agi_newinogen, 1);
 			free->di_next_unlinked = cpu_to_be32(NULLAGINO);
 			xfs_ialloc_log_di(tp, fbuf, i,
 				XFS_DI_CORE_BITS | XFS_DI_NEXT_UNLINKED);
@@ -347,7 +349,8 @@ xfs_ialloc_ag_alloc(
 	 * Log allocation group header fields
 	 */
 	xfs_ialloc_log_agi(tp, agbp,
-		XFS_AGI_COUNT | XFS_AGI_FREECOUNT | XFS_AGI_NEWINO);
+		XFS_AGI_COUNT | XFS_AGI_FREECOUNT |
+		XFS_AGI_NEWINO | XFS_AGI_NEWINOGEN);
 	/*
 	 * Modify/log superblock values for inode count and inode free count.
 	 */
@@ -896,11 +899,12 @@ nextag:
 	ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino + offset);
 	XFS_INOBT_CLR_FREE(&rec, offset);
 	rec.ir_freecount--;
+	be32_add_cpu(&agi->agi_newinogen, 1);
 	if ((error = xfs_inobt_update(cur, rec.ir_startino, rec.ir_freecount,
 			rec.ir_free)))
 		goto error0;
 	be32_add(&agi->agi_freecount, -1);
-	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
+	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT | XFS_AGI_NEWINOGEN);
 	down_read(&mp->m_peraglock);
 	mp->m_perag[tagno].pagi_freecount--;
 	up_read(&mp->m_peraglock);
@@ -1320,6 +1324,11 @@ xfs_ialloc_compute_maxlevels(
 
 /*
  * Log specified fields for the ag hdr (inode section)
+ *
+ * We don't log the unlinked inode fields through here; they
+ * get logged directly to the buffer. Hence we have a discontinuity
+ * in the fields we are logging and we need two calls to map all
+ * the dirtied parts of the agi....
  */
 void
 xfs_ialloc_log_agi(
@@ -1342,22 +1351,27 @@ xfs_ialloc_log_agi(
 		offsetof(xfs_agi_t, agi_newino),
 		offsetof(xfs_agi_t, agi_dirino),
 		offsetof(xfs_agi_t, agi_unlinked),
+		offsetof(xfs_agi_t, agi_newinogen),
 		sizeof(xfs_agi_t)
 	};
+	int			log_newino = fields & XFS_AGI_NEWINOGEN;
+
 #ifdef DEBUG
 	xfs_agi_t		*agi;	/* allocation group header */
 
 	agi = XFS_BUF_TO_AGI(bp);
 	ASSERT(be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC);
 #endif
-	/*
-	 * Compute byte offsets for the first and last fields.
-	 */
+	fields &= ~XFS_AGI_NEWINOGEN;
+
+	/* Compute byte offsets for the first and last fields.  */
 	xfs_btree_offsets(fields, offsets, XFS_AGI_NUM_BITS, &first, &last);
-	/*
-	 * Log the allocation group inode header buffer.
-	 */
 	xfs_trans_log_buf(tp, bp, first, last);
+	if (log_newino) {
+		xfs_btree_offsets(XFS_AGI_NEWINOGEN, offsets, XFS_AGI_NUM_BITS,
+					&first, &last);
+		xfs_trans_log_buf(tp, bp, first, last);
+	}
 }
 
 /*
