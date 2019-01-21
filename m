Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726040AbfAUSLy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jan 2019 13:11:54 -0500
Date: Mon, 21 Jan 2019 13:11:51 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Regular FS shutdown while rsync is running
Message-ID: <20190121181151.GD14281@bfoster>
References: <1543238989.2507.33.camel@pengutronix.de>
 <20181126153249.GC14585@bfoster>
 <1548067317.2465.7.camel@pengutronix.de>
 <20190121130121.GA4537@bfoster>
 <1548087824.2465.9.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1548087824.2465.9.camel@pengutronix.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lucas Stach <l.stach@pengutronix.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Jan 21, 2019 at 05:23:44PM +0100, Lucas Stach wrote:
> Am Montag, den 21.01.2019, 08:01 -0500 schrieb Brian Foster:
> [...]
> > > root@XXX:/mnt/metadump# xfs_repair  /dev/XXX
> > > Phase 1 - find and verify superblock...
> > >         - reporting progress in intervals of 15 minutes
> > > Phase 2 - using internal log
> > >         - zero log...
> > >         - scan filesystem freespace and inode maps...
> > > bad magic # 0x49414233 in inobt block 5/7831662
> > 
> > Hmm, so this looks like a very isolated corruption. It's complaining
> > about a magic number (internal filesystem value stamped to metadata
> > blocks for verification/sanity purposes) being wrong on a finobt block
> > and nothing else seems to be wrong in the fs. (I guess repair should
> > probably print out 'finobt' here instead of 'inobt,' but that's a
> > separate issue..).
> > 
> > The finobt uses a magic value of XFS_FIBT_CRC_MAGIC (0x46494233, 'FIB3')
> > whereas this block has a magic value of 0x49414233. The latter is
> > 'IAB3' (XFS_IBT_CRC_MAGIC), which is the magic value for regular inode
> > btree blocks.
> > 
> > >         - 23:06:50: scanning filesystem freespace - 33 of 33 allocation groups done
> > >         - found root inode chunk
> > > Phase 3 - for each AG...
> > 
> > ...
> > > Phase 7 - verify and correct link counts...
> > >         - 22:29:19: verify and correct link counts - 33 of 33 allocation groups done
> > > done
> > > 
> > > >  Would you be able to provide an xfs_metadump image
> > > > of this filesystem for closer inspection?
> > > 
> > > This filesystem is really metadata heavy, so an xfs_metadump ended up
> > > being around 400GB of data. Not sure if this is something you would be
> > > willing to look into?
> > > 
> > 
> > Ok, it might be difficult to get ahold of that. Does the image happen to
> > compress well?
> 
> I'll see how well it compresses, but this might take a while...
> 
> > In the meantime, given that the corruption appears to be so isolated you
> > might be able to provide enough information from the metadump without
> > having to transfer it. The first thing is probably to take a look at the
> > block in question..
> > 
> > First, restore the metadump somewhere:
> > 
> > xfs_mdrestore -g ./md.img <destination>
> > 
> > You'll need somewhere with enough space for that 400G or so. Note that
> > you can restore to a file and mount/inspect that file as if it were the
> > original fs. I'd also mount/unmount the restored metadump and run an
> > 'xfs_repair -n' on it just to double check that the corruption was
> > captured properly and there are no other issues with the metadump. -n is
> > important here as otherwise repair will fix the metadump and remove the
> > corruption.
> > 
> > Next, use xfs_db to dump the contents of the suspect block. Run 'xfs_db
> > <metadump image>' to open the fs and try the following sequence of
> > commands.
> > 
> > - Convert to a global fsb: 'convert agno 5 agbno 7831662 fsb'
> > - Jump to the fsb: 'fsb <output of prev cmd>'
> > - Set the block type: 'type finobt'
> > - Print the block: 'print'
> > 
> > ... and copy/paste the output.
> 
> So for the moment, here's the output of the above sequence.
> 
> xfs_db> convert agno 5 agbno 7831662 fsb
> 0x5077806e (1350008942)
> xfs_db> fsb 0x5077806e
> xfs_db> type finobt
> xfs_db> print
> magic = 0x49414233
> level = 1
> numrecs = 335
> leftsib = 7810856
> rightsib = null
> bno = 7387612016
> lsn = 0x6671003d9700
> uuid = 026711cc-25c7-44b9-89aa-0aac496edfec
> owner = 5
> crc = 0xe12b19b2 (correct)

As expected, we have the inobt magic. Interesting that this is a fairly
full intermediate (level > 0) node. There is no right sibling, which
means we're at the far right end of the tree. I wouldn't mind poking
around a bit more at the tree, but that might be easier with access to
the metadump. I also think that xfs_repair would have complained were
something more significant wrong with the tree.

Hmm, I wonder if the (lightly tested) diff below would help us catch
anything. It basically just splits up the currently combined inobt and
finobt I/O verifiers to expect the appropriate magic number (rather than
accepting either magic for both trees). Could you give that a try?
Unless we're doing something like using the wrong type of cursor for a
particular tree, I'd think this would catch wherever we happen to put a
bad magic on disk. Note that this assumes the underlying filesystem has
been repaired so as to try and detect the next time an on-disk
corruption is introduced.

You'll also need to turn up the XFS error level to make sure this prints
out a stack trace if/when a verifier failure triggers:

echo 5 > /proc/sys/fs/xfs/error_level

I guess we also shouldn't rule out hardware issues or whatnot. I did
notice you have a strange kernel version: 4.19.4-holodeck10. Is that a
distro kernel? Has it been modified from upstream in any way? If so, I'd
strongly suggest to try and confirm whether this is reproducible with an
upstream kernel.

Brian

--- 8< ---

diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 9b25e7a0df47..c493a37730cb 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -272,13 +272,11 @@ xfs_inobt_verify(
 	 */
 	switch (block->bb_magic) {
 	case cpu_to_be32(XFS_IBT_CRC_MAGIC):
-	case cpu_to_be32(XFS_FIBT_CRC_MAGIC):
 		fa = xfs_btree_sblock_v5hdr_verify(bp);
 		if (fa)
 			return fa;
 		/* fall through */
 	case cpu_to_be32(XFS_IBT_MAGIC):
-	case cpu_to_be32(XFS_FIBT_MAGIC):
 		break;
 	default:
 		return __this_address;
@@ -333,6 +331,86 @@ const struct xfs_buf_ops xfs_inobt_buf_ops = {
 	.verify_struct = xfs_inobt_verify,
 };
 
+static xfs_failaddr_t
+xfs_finobt_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	xfs_failaddr_t		fa;
+	unsigned int		level;
+
+	/*
+	 * During growfs operations, we can't verify the exact owner as the
+	 * perag is not fully initialised and hence not attached to the buffer.
+	 *
+	 * Similarly, during log recovery we will have a perag structure
+	 * attached, but the agi information will not yet have been initialised
+	 * from the on disk AGI. We don't currently use any of this information,
+	 * but beware of the landmine (i.e. need to check pag->pagi_init) if we
+	 * ever do.
+	 */
+	switch (block->bb_magic) {
+	case cpu_to_be32(XFS_FIBT_CRC_MAGIC):
+		fa = xfs_btree_sblock_v5hdr_verify(bp);
+		if (fa)
+			return fa;
+		/* fall through */
+	case cpu_to_be32(XFS_FIBT_MAGIC):
+		break;
+	default:
+		return __this_address;
+	}
+
+	/* level verification */
+	level = be16_to_cpu(block->bb_level);
+	if (level >= mp->m_in_maxlevels)
+		return __this_address;
+
+	return xfs_btree_sblock_verify(bp, mp->m_inobt_mxr[level != 0]);
+}
+
+static void
+xfs_finobt_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa;
+
+	if (!xfs_btree_sblock_verify_crc(bp))
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_finobt_verify(bp);
+		if (fa)
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
+
+	if (bp->b_error)
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+}
+
+static void
+xfs_finobt_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa;
+
+	fa = xfs_finobt_verify(bp);
+	if (fa) {
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		return;
+	}
+	xfs_btree_sblock_calc_crc(bp);
+
+}
+
+const struct xfs_buf_ops xfs_finobt_buf_ops = {
+	.name = "xfs_inobt",
+	.verify_read = xfs_finobt_read_verify,
+	.verify_write = xfs_finobt_write_verify,
+	.verify_struct = xfs_finobt_verify,
+};
+
 STATIC int
 xfs_inobt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -389,7 +467,7 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
 	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_finobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
-	.buf_ops		= &xfs_inobt_buf_ops,
+	.buf_ops		= &xfs_finobt_buf_ops,
 	.diff_two_keys		= xfs_inobt_diff_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
