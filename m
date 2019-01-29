Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49826 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbfA2OBj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Jan 2019 09:01:39 -0500
Date: Tue, 29 Jan 2019 09:01:36 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC v2 2/3] xfs: distinguish between inobt and finobt
 magic values
Message-ID: <20190129140136.GC24998@bfoster>
References: <20190128152034.21080-1-bfoster@redhat.com>
 <20190128152034.21080-3-bfoster@redhat.com>
 <20190128225426.GU4205@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128225426.GU4205@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 29, 2019 at 09:54:26AM +1100, Dave Chinner wrote:
> On Mon, Jan 28, 2019 at 10:20:33AM -0500, Brian Foster wrote:
> > The inode btree verifier code is shared between the inode btree and
> > free inode btree because the underlying metadata formats are
> > essentially equivalent. A side effect of this is that the verifier
> > cannot determine whether a particular btree block should have an
> > inobt or finobt magic value.
> > 
> > This logic allows an unfortunate xfs_repair bug to escape detection
> > where certain level > 0 nodes of the finobt are stamped with inobt
> > magic by xfs_repair finobt reconstruction. This is fortunately not a
> > severe problem since the inode btree magic values do not contribute
> > to any changes in kernel behavior, but we do need a means to detect
> > and prevent this problem in the future.
> > 
> > Add a field to xfs_buf_ops to store the v4 and v5 superblock magic
> > values expected by a particular verifier. Add a helper to check an
> > on-disk magic value against the value expected by the verifier. Call
> > the helper from the shared [f]inobt verifier code for magic value
> > verification. This ensures that the inode btree blocks each have the
> > appropriate magic value based on specific tree type and superblock
> > version.
> 
> I still really don't like this code :(
> 

Enough to explain why, perhaps?

> > @@ -387,4 +388,22 @@ extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int);
> >  
> >  int xfs_buf_ensure_ops(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
> >  
> > +/*
> > + * Verify an on-disk magic value against the magic value specified in the
> > + * verifier structure.
> > + */
> > +static inline bool
> > +xfs_buf_ops_verify_magic(
> > +	struct xfs_buf		*bp,
> > +	__be32			dmagic,
> > +	bool			crc)
> > +{
> > +	if (unlikely(WARN_ON(!bp->b_ops || !bp->b_ops->magic[crc])))
> > +		return false;
> > +	return dmagic == cpu_to_be32(bp->b_ops->magic[crc]);
> > +}
> > +#define xfs_verify_magic(bp, dmagic)		\
> > +	xfs_buf_ops_verify_magic(bp, dmagic,	\
> > +			xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
> 
> That, IMO, is even worse....
> 

Worse than what and why?

Note that I've removed the endian conversion from here. Otherwise, this
is basically just a wrapper to factor out the sb version lookup and
provide some common error checking.

> Ok, here's a different option. Store all the magic numbers in a pair
> of tables - one for v4, one for v5. They can be static const and
> in on-disk format.
> 
> Then use some simple 1-line wrappers for the verifier definitions to
> specify the table index for the magic numbers. e.g:
> 
> __be32 xfs_disk_magic(mp, idx)
> {
> 	if (xfs_sb_version_hascrc(&mp->m_sb))
> 		return xfs_v5_disk_magic[idx];
> 	return xfs_v4_disk_magic[idx];
> }
> 

Seems reasonable enough... but where/how is the index encoded?

> [.....]
> 
> __xfs_inobt_read_verify(bp, magic_idx)
> {
> 	magic = xfs_disk_magic(mp, magic_idx);
> 	.....
> }
> 
> __xfs_inobt_write_verify(bp, magic_idx)
> {
> 	magic = xfs_disk_magic(mp, magic_idx);
> 	.....
> }
> 
> __xfs_inobt_struct_verify(bp, magic_idx)
> {
> 	magic = xfs_disk_magic(mp, magic_idx);
> 	.....
> }
> 
> [ or drive the magic number resolution further inwards to where it
> is actually needed. ]
> 
> xfs_inobt_read_verify(bp)
> {
> 	return __xfs_inobt_read_verify(bp, INOBT);
> }
> 
> xfs_inobt_write_verify(bp)
> {
> 	return __xfs_inobt_write_verify(bp, INOBT);
> }
> 
> xfs_inobt_struct_verify(bp)
> {
> 	return __xfs_inobt_struct_verify(bp, INOBT);
> }
> 
> xfs_finobt_read_verify(bp)
> {
> 	return __xfs_inobt_read_verify(bp, FINOBT);
> }
> 
> xfs_finobt_write_verify(bp)
> {
> 	return __xfs_inobt_write_verify(bp, FINOBT);
> }
> 
> xfs_finobt_struct_verify(bp)
> {
> 	return __xfs_inobt_struct_verify(bp, FINOBT);
> }
> 
> And this can be extended to all the verifiers - it handles crc and
> non CRC variants transparently, and can be used for the cnt/bno free
> space btrees, too.
> 
> Yes, it's a bit more boiler plate code, but IMO it is easier to
> follow and understand than encoding multiple magic numbers into the
> verifier and adding a dependency on the buffer having an ops
> structure attached to be able to check the magic number...
> 

This code duplication is what I was hoping to avoid. We already have
similar proliferation of boilerplate code in some of the verifiers that
handle multiple object types. See the appended hunk related to the dir
leaf verifier code, for example.

I agree that the magic value itself is a bit obfuscated with this
change, but that's still the case with a lookup table. I disagree that
an indirected magic value is more difficult to read than nearly a screen
full of similarly named verifier functions. The magic value is a simple
data value, the code above makes it unnecessarily more confusing (at a
glance) to grok which verifiers run which checks. That's just my
experience from folding the code below, fwiw.

Another angle to this is that we don't necessarily have to use the
xfs_buf_ops->magic field for every verifier. I could just add it to the
finobt case, perhaps the directory case below, and leave the rest alone
until we come up with something more agreeable. Then it basically just
supports a couple corner cases and is easy enough to remove down the
road.

Brian

--- 8< ---

diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 1728a3e6f5cf..f602307d2fa0 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -142,41 +142,32 @@ xfs_dir3_leaf_check_int(
  */
 static xfs_failaddr_t
 xfs_dir3_leaf_verify(
-	struct xfs_buf		*bp,
-	uint16_t		magic)
+	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_dir2_leaf	*leaf = bp->b_addr;
 
-	ASSERT(magic == XFS_DIR2_LEAF1_MAGIC || magic == XFS_DIR2_LEAFN_MAGIC);
+	if (!xfs_verify_magic(bp, be16_to_cpu(leaf->hdr.info.magic)))
+		return __this_address;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
-		uint16_t		magic3;
 
-		magic3 = (magic == XFS_DIR2_LEAF1_MAGIC) ? XFS_DIR3_LEAF1_MAGIC
-							 : XFS_DIR3_LEAFN_MAGIC;
-
-		if (leaf3->info.hdr.magic != cpu_to_be16(magic3))
-			return __this_address;
+		ASSERT(leaf3->info.hdr.magic == leaf->hdr.info.magic);
 		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
 			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(leaf3->info.lsn)))
 			return __this_address;
-	} else {
-		if (leaf->hdr.info.magic != cpu_to_be16(magic))
-			return __this_address;
 	}
 
 	return xfs_dir3_leaf_check_int(mp, NULL, NULL, leaf);
 }
 
 static void
-__read_verify(
-	struct xfs_buf  *bp,
-	uint16_t	magic)
+xfs_dir3_leaf_read_verify(
+	struct xfs_buf  *bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	xfs_failaddr_t		fa;
@@ -185,23 +176,22 @@ __read_verify(
 	     !xfs_buf_verify_cksum(bp, XFS_DIR3_LEAF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
-		fa = xfs_dir3_leaf_verify(bp, magic);
+		fa = xfs_dir3_leaf_verify(bp);
 		if (fa)
 			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 	}
 }
 
 static void
-__write_verify(
-	struct xfs_buf  *bp,
-	uint16_t	magic)
+xfs_dir3_leaf_write_verify(
+	struct xfs_buf  *bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_dir3_leaf_hdr *hdr3 = bp->b_addr;
 	xfs_failaddr_t		fa;
 
-	fa = xfs_dir3_leaf_verify(bp, magic);
+	fa = xfs_dir3_leaf_verify(bp);
 	if (fa) {
 		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
@@ -216,60 +206,20 @@ __write_verify(
 	xfs_buf_update_cksum(bp, XFS_DIR3_LEAF_CRC_OFF);
 }
 
-static xfs_failaddr_t
-xfs_dir3_leaf1_verify(
-	struct xfs_buf	*bp)
-{
-	return xfs_dir3_leaf_verify(bp, XFS_DIR2_LEAF1_MAGIC);
-}
-
-static void
-xfs_dir3_leaf1_read_verify(
-	struct xfs_buf	*bp)
-{
-	__read_verify(bp, XFS_DIR2_LEAF1_MAGIC);
-}
-
-static void
-xfs_dir3_leaf1_write_verify(
-	struct xfs_buf	*bp)
-{
-	__write_verify(bp, XFS_DIR2_LEAF1_MAGIC);
-}
-
-static xfs_failaddr_t
-xfs_dir3_leafn_verify(
-	struct xfs_buf	*bp)
-{
-	return xfs_dir3_leaf_verify(bp, XFS_DIR2_LEAFN_MAGIC);
-}
-
-static void
-xfs_dir3_leafn_read_verify(
-	struct xfs_buf	*bp)
-{
-	__read_verify(bp, XFS_DIR2_LEAFN_MAGIC);
-}
-
-static void
-xfs_dir3_leafn_write_verify(
-	struct xfs_buf	*bp)
-{
-	__write_verify(bp, XFS_DIR2_LEAFN_MAGIC);
-}
-
 const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops = {
 	.name = "xfs_dir3_leaf1",
-	.verify_read = xfs_dir3_leaf1_read_verify,
-	.verify_write = xfs_dir3_leaf1_write_verify,
-	.verify_struct = xfs_dir3_leaf1_verify,
+	.magic = { XFS_DIR2_LEAF1_MAGIC, XFS_DIR3_LEAF1_MAGIC },
+	.verify_read = xfs_dir3_leaf_read_verify,
+	.verify_write = xfs_dir3_leaf_write_verify,
+	.verify_struct = xfs_dir3_leaf_verify,
 };
 
 const struct xfs_buf_ops xfs_dir3_leafn_buf_ops = {
 	.name = "xfs_dir3_leafn",
-	.verify_read = xfs_dir3_leafn_read_verify,
-	.verify_write = xfs_dir3_leafn_write_verify,
-	.verify_struct = xfs_dir3_leafn_verify,
+	.magic = { XFS_DIR2_LEAFN_MAGIC, XFS_DIR3_LEAFN_MAGIC },
+	.verify_read = xfs_dir3_leaf_read_verify,
+	.verify_write = xfs_dir3_leaf_write_verify,
+	.verify_struct = xfs_dir3_leaf_verify,
 };
 
 int
