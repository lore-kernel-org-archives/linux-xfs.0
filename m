Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:64894
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751268AbdINWon (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Sep 2017 18:44:43 -0400
Date: Fri, 15 Sep 2017 08:44:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: Uninitialized memory read at xlog_write
Message-ID: <20170914224431.GA10621@dastard>
References: <20170911150157.GA13400@bfoster.bfoster>
 <201709131614.FAG69217.MSHFFVOFLJtQOO@I-love.SAKURA.ne.jp>
 <20170913094335.GV17782@dastard>
 <201709131859.AHB43227.SOFFOHJVMLFtOQ@I-love.SAKURA.ne.jp>
 <20170913214028.GX17782@dastard>
 <201709141915.HAD04123.FQOSHJtVOLFMFO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201709141915.HAD04123.FQOSHJtVOLFMFO@I-love.SAKURA.ne.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: bfoster@redhat.com, sandeen@redhat.com, dchinner@redhat.com, linux-xfs@vger.kernel.org

On Thu, Sep 14, 2017 at 07:15:38PM +0900, Tetsuo Handa wrote:
> Dave Chinner wrote:
> > On Wed, Sep 13, 2017 at 06:59:38PM +0900, Tetsuo Handa wrote:
> > > Dave Chinner wrote:
> > > > On Wed, Sep 13, 2017 at 04:14:37PM +0900, Tetsuo Handa wrote:
> > > > > [  OK  ] Stopped target Switch Root.
> > > > > 
> > > > > [  OK  ] Stopped target Initrd File Systems.[ 1054.691505] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (ffff880135396660)
> > > > > [ 1054.691506] 000000000000000093050a200000000000000000000000000000000000000000
> > > > > [ 1054.691511]  u u u u u u u u i i i i i i i i u u u u u u u u u u u u u u u u
> > > > > [ 1054.691515]  ^
> > > > > [ 1054.691519] RIP: 0010:xlog_write+0x344/0x6b0
> > > > 
> > > > What line of code does this correspond to?
> > > > 
> > > 
> > >                         /*
> > >                          * Copy region.
> > >                          *
> > >                          * Unmount records just log an opheader, so can have
> > >                          * empty payloads with no data region to copy. Hence we
> > >                          * only copy the payload if the vector says it has data
> > >                          * to copy.
> > >                          */
> > >                         ASSERT(copy_len >= 0);
> > >                         if (copy_len > 0) {
> > >                                 memcpy(ptr, reg->i_addr + copy_off, copy_len); // <= xlog_write+0x344/0x6b0
> > >                                 xlog_write_adv_cnt(&ptr, &len, &log_offset,
> > >                                                    copy_len);
> > >                         }
> > > 
> > 
> > Ok, that's what I suspected. The region being copied is set up
> > in xlog_cil_insert_format_items(), so problem is in one of the
> > ->iop_format methods it calls to format the dirty metadata into the
> > region.
> > 
> > And given that the address is ...6660, it's likely the offset into
> > the structure being copied is 96 bytes.
> > 
> > $ pahole...
> > .....
> > struct xfs_log_dinode {
> > .....
> >        xfs_agino_t                di_next_unlinked;     /*    96     4 */
> > .....
> > 
> > Try the patch below.
> 
> That patch did not help.
> 
> I checked values passed to memcpy() using below patch.

ok....

> 
> ----------
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index c5107c7..f91c4c7 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2476,6 +2476,8 @@
>  			 */
>  			ASSERT(copy_len >= 0);
>  			if (copy_len > 0) {
> +				printk(KERN_INFO "ptr=%p reg->i_addr=%p copy_off=%u copy_len=%u\n",
> +				       ptr, reg->i_addr, copy_off, copy_len);

You need to print out the reg->i_type here. Then we'll know exactly
where it came from.

>  				memcpy(ptr, reg->i_addr + copy_off, copy_len);
>  				xlog_write_adv_cnt(&ptr, &len, &log_offset,
>  						   copy_len);
> ----------
> 
> The copy_len was not multiple of sizeof(struct xfs_log_dinode).
> Thus, I guess we can't assume this is "struct xfs_log_dinode".

It still could be - we don't always log the entire structure.

static inline uint xfs_log_dinode_size(int version)
{
        if (version == 3)
		return sizeof(struct xfs_log_dinode);
	return offsetof(struct xfs_log_dinode, di_next_unlinked);
}

i.e. If it's v2 inode, the logged region is 96 bytes in length, not
176.

> 
> ----------
>          Starting Load/Save Random Seed...
> 
>          Starting Configure read-only root support...
> 
> [ 1106.927991] ptr=ffffc90001c08218 reg->i_addr=ffff880134c7fda8 copy_off=0 copy_len=16
> [ 1106.928022] ptr=ffffc90001c08234 reg->i_addr=ffff88013395f858 copy_off=0 copy_len=56
> [ 1106.928100] ptr=ffffc90001c08278 reg->i_addr=ffff88013395f890 copy_off=0 copy_len=96
> [ 1106.932354] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (ffff88013395f860)

Hold on- that warning has come from the /prior/ region copy, not
the current region!

i.e. 2nd last copy region was ffff88013395f858 for 0x38 bytes, and
this spans address that failed ffff88013395f860. i.e. it's 8 bytes
into that region. It's 48 bytes before the region that we were
copying when kmemcheck triggered!

I'm going to guess that we've got a log op header, followed by
a inode format header, follow by something like a v2 inode core.
i.e. log op headers are 16 bytes, xfs_inode_log_format are 56 bytes,
and a v2 inode core is 96 bytes.

So, the inode log format header:

struct xfs_inode_log_format {
        uint16_t                   ilf_type;             /*     0     2 */
        uint16_t                   ilf_size;             /*     2     2 */
        uint32_t                   ilf_fields;           /*     4     4 */
        uint16_t                   ilf_asize;            /*     8     2 */
        uint16_t                   ilf_dsize;            /*    10     2 */

        /* XXX 4 bytes hole, try to pack */

        uint64_t                   ilf_ino;              /*    16     8 */
        union {
                uint32_t           ilfu_rdev;            /*           4 */
                uuid_t             ilfu_uuid;            /*          16 */
        } ilf_u;                                         /*    24    16 */
        int64_t                    ilf_blkno;            /*    40     8 */
        int32_t                    ilf_len;              /*    48     4 */
        int32_t                    ilf_boffset;          /*    52     4 */

        /* size: 56, cachelines: 1, members: 10 */
        /* sum members: 52, holes: 1, sum holes: 4 */
        /* last cacheline: 56 bytes */
};

Oh, that's right. Someone, a long, long time ago, screwed up the on
disk inode log structure but nobody noticed it due to the Irix MIPS
compilers padding the structure identically on 32 and 64 bit
systems. Port to linux, and i386/x86-64 padded it differently. The
fix at the time was to make it right in recovery and continue to
use the native structure at runtime. Ok, let's fix that properly
now.

Try the patch below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: Don't log uninitialised fields in inode structures

From: Dave Chinner <dchinner@redhat.com>

Prevent kmemcheck from throwing warnings about reading uninitialised
memory when formatting inodes into the incore log buffer. There are
several issues here - we don't always log all the fields in the
inode log format item, and we never log the inode the
di_next_unlinked field.

In the case of the inode log format item, this is aused b cerbated
by the old xfs_inode_log_format structure padding issue. Hence make
the padded, 64 bit aligned version of the structure the one we always
use for formatting the log and get rid of the 64 bit variant. This
means we'll always log the 64-bit version and so recovery only needs
to convert from the unpadded 32 bit version from older 32 bit
kernels.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_log_format.h | 27 +++++----------
 fs/xfs/xfs_inode_item.c        | 79 ++++++++++++++++++++++--------------------
 fs/xfs/xfs_ondisk.h            |  2 +-
 3 files changed, 50 insertions(+), 58 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 8372e9bcd7b6..71de185735e0 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -270,6 +270,7 @@ typedef struct xfs_inode_log_format {
 	uint32_t		ilf_fields;	/* flags for fields logged */
 	uint16_t		ilf_asize;	/* size of attr d/ext/root */
 	uint16_t		ilf_dsize;	/* size of data/ext/root */
+	uint32_t		ilf_pad;	/* pad for 64 bit boundary */
 	uint64_t		ilf_ino;	/* inode number */
 	union {
 		uint32_t	ilfu_rdev;	/* rdev value for dev inode*/
@@ -280,29 +281,17 @@ typedef struct xfs_inode_log_format {
 	int32_t			ilf_boffset;	/* off of inode in buffer */
 } xfs_inode_log_format_t;
 
-typedef struct xfs_inode_log_format_32 {
-	uint16_t		ilf_type;	/* inode log item type */
-	uint16_t		ilf_size;	/* size of this item */
-	uint32_t		ilf_fields;	/* flags for fields logged */
-	uint16_t		ilf_asize;	/* size of attr d/ext/root */
-	uint16_t		ilf_dsize;	/* size of data/ext/root */
-	uint64_t		ilf_ino;	/* inode number */
-	union {
-		uint32_t	ilfu_rdev;	/* rdev value for dev inode*/
-		uuid_t		ilfu_uuid;	/* mount point value */
-	} ilf_u;
-	int64_t			ilf_blkno;	/* blkno of inode buffer */
-	int32_t			ilf_len;	/* len of inode buffer */
-	int32_t			ilf_boffset;	/* off of inode in buffer */
-} __attribute__((packed)) xfs_inode_log_format_32_t;
-
-typedef struct xfs_inode_log_format_64 {
+/*
+ * Old 32 bit systems will log in this format without the 64 bit
+ * alignment padding. Recovery will detect this and convert it to the
+ * correct format.
+ */
+struct xfs_inode_log_format_32 {
 	uint16_t		ilf_type;	/* inode log item type */
 	uint16_t		ilf_size;	/* size of this item */
 	uint32_t		ilf_fields;	/* flags for fields logged */
 	uint16_t		ilf_asize;	/* size of attr d/ext/root */
 	uint16_t		ilf_dsize;	/* size of data/ext/root */
-	uint32_t		ilf_pad;	/* pad for 64 bit boundary */
 	uint64_t		ilf_ino;	/* inode number */
 	union {
 		uint32_t	ilfu_rdev;	/* rdev value for dev inode*/
@@ -311,7 +300,7 @@ typedef struct xfs_inode_log_format_64 {
 	int64_t			ilf_blkno;	/* blkno of inode buffer */
 	int32_t			ilf_len;	/* len of inode buffer */
 	int32_t			ilf_boffset;	/* off of inode in buffer */
-} xfs_inode_log_format_64_t;
+} __attribute__((packed));
 
 
 /*
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 6d0f74ec31e8..aec9cf36b5b7 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -364,6 +364,9 @@ xfs_inode_to_log_dinode(
 	to->di_dmstate = from->di_dmstate;
 	to->di_flags = from->di_flags;
 
+	/* log a dummy value to ensure log structure is fully initialised */
+	to->di_next_unlinked = NULLAGINO;
+
 	if (from->di_version == 3) {
 		to->di_changecount = inode->i_version;
 		to->di_crtime.t_sec = from->di_crtime.t_sec;
@@ -404,6 +407,11 @@ xfs_inode_item_format_core(
  * the second with the on-disk inode structure, and a possible third and/or
  * fourth with the inode data/extents/b-tree root and inode attributes
  * data/extents/b-tree root.
+ *
+ * Note: Always use the 64 bit inode log format structure so we don't
+ * leave an uninitialised hole in the format item on 64 bit systems. Log
+ * recovery on 32 bit systems handles this just fine, so there's no reason
+ * for not using an initialising the properly padded structure all the time.
  */
 STATIC void
 xfs_inode_item_format(
@@ -412,8 +420,8 @@ xfs_inode_item_format(
 {
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
-	struct xfs_inode_log_format *ilf;
 	struct xfs_log_iovec	*vecp = NULL;
+	struct xfs_inode_log_format *ilf;
 
 	ASSERT(ip->i_d.di_version > 1);
 
@@ -425,7 +433,17 @@ xfs_inode_item_format(
 	ilf->ilf_boffset = ip->i_imap.im_boffset;
 	ilf->ilf_fields = XFS_ILOG_CORE;
 	ilf->ilf_size = 2; /* format + core */
-	xlog_finish_iovec(lv, vecp, sizeof(struct xfs_inode_log_format));
+
+	/*
+	 * make sure we don't leak uninitialised data into the log in the case
+	 * when we don't log every field in the inode.
+	 */
+	ilf->ilf_dsize = 0;
+	ilf->ilf_asize = 0;
+	ilf->ilf_pad = 0;
+	uuid_copy(&ilf->ilf_u.ilfu_uuid, &uuid_null);
+
+	xlog_finish_iovec(lv, vecp, sizeof(*ilf));
 
 	xfs_inode_item_format_core(ip, lv, &vecp);
 	xfs_inode_item_format_data_fork(iip, ilf, lv, &vecp);
@@ -855,44 +873,29 @@ xfs_istale_done(
 }
 
 /*
- * convert an xfs_inode_log_format struct from either 32 or 64 bit versions
- * (which can have different field alignments) to the native version
+ * convert an xfs_inode_log_format struct from the old 32 bit version
+ * (which can have different field alignments) to the native 64 bit version
  */
 int
 xfs_inode_item_format_convert(
-	xfs_log_iovec_t		*buf,
-	xfs_inode_log_format_t	*in_f)
+	struct xfs_log_iovec		*buf,
+	struct xfs_inode_log_format	*in_f)
 {
-	if (buf->i_len == sizeof(xfs_inode_log_format_32_t)) {
-		xfs_inode_log_format_32_t *in_f32 = buf->i_addr;
-
-		in_f->ilf_type = in_f32->ilf_type;
-		in_f->ilf_size = in_f32->ilf_size;
-		in_f->ilf_fields = in_f32->ilf_fields;
-		in_f->ilf_asize = in_f32->ilf_asize;
-		in_f->ilf_dsize = in_f32->ilf_dsize;
-		in_f->ilf_ino = in_f32->ilf_ino;
-		/* copy biggest field of ilf_u */
-		uuid_copy(&in_f->ilf_u.ilfu_uuid, &in_f32->ilf_u.ilfu_uuid);
-		in_f->ilf_blkno = in_f32->ilf_blkno;
-		in_f->ilf_len = in_f32->ilf_len;
-		in_f->ilf_boffset = in_f32->ilf_boffset;
-		return 0;
-	} else if (buf->i_len == sizeof(xfs_inode_log_format_64_t)){
-		xfs_inode_log_format_64_t *in_f64 = buf->i_addr;
-
-		in_f->ilf_type = in_f64->ilf_type;
-		in_f->ilf_size = in_f64->ilf_size;
-		in_f->ilf_fields = in_f64->ilf_fields;
-		in_f->ilf_asize = in_f64->ilf_asize;
-		in_f->ilf_dsize = in_f64->ilf_dsize;
-		in_f->ilf_ino = in_f64->ilf_ino;
-		/* copy biggest field of ilf_u */
-		uuid_copy(&in_f->ilf_u.ilfu_uuid, &in_f64->ilf_u.ilfu_uuid);
-		in_f->ilf_blkno = in_f64->ilf_blkno;
-		in_f->ilf_len = in_f64->ilf_len;
-		in_f->ilf_boffset = in_f64->ilf_boffset;
-		return 0;
-	}
-	return -EFSCORRUPTED;
+	struct xfs_inode_log_format_32	*in_f32 = buf->i_addr;
+
+	if (buf->i_len != sizeof(*in_f32))
+		return -EFSCORRUPTED;
+
+	in_f->ilf_type = in_f32->ilf_type;
+	in_f->ilf_size = in_f32->ilf_size;
+	in_f->ilf_fields = in_f32->ilf_fields;
+	in_f->ilf_asize = in_f32->ilf_asize;
+	in_f->ilf_dsize = in_f32->ilf_dsize;
+	in_f->ilf_ino = in_f32->ilf_ino;
+	/* copy biggest field of ilf_u */
+	uuid_copy(&in_f->ilf_u.ilfu_uuid, &in_f32->ilf_u.ilfu_uuid);
+	in_f->ilf_blkno = in_f32->ilf_blkno;
+	in_f->ilf_len = in_f32->ilf_len;
+	in_f->ilf_boffset = in_f32->ilf_boffset;
+	return 0;
 }
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 0c381d71b242..0492436a053f 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -134,7 +134,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_icreate_log,		28);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_ictimestamp,		8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format_32,	52);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format_64,	56);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
 }
