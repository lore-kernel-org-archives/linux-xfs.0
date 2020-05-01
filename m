Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08AF1C47253
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 16:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E284A24953
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 16:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729634AbgEAQiM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 12:38:12 -0400
Received: from verein.lst.de ([213.95.11.211]:47725 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728443AbgEAQiM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 May 2020 12:38:12 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0B9C668BFE; Fri,  1 May 2020 18:38:10 +0200 (CEST)
Date:   Fri, 1 May 2020 18:38:09 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: remove xfs_ifork_ops
Message-ID: <20200501163809.GA18426@lst.de>
References: <20200501081424.2598914-1-hch@lst.de> <20200501081424.2598914-9-hch@lst.de> <20200501155649.GO40250@bfoster> <20200501160809.GT6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501160809.GT6742@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 09:08:09AM -0700, Darrick J. Wong wrote:
> > I'm not sure the cleanup is worth the kludge of including repair code in
> > the kernel like this. It might be better to reduce or replace ifork_ops
> > to a single directory function pointer until there's a reason for this
> > to become common. I dunno, maybe others have thoughts...

The whole point is trying to avoid calling function pointers and
keeping that cruft around.

> 
> One of the online repair gaps I haven't figured out how to close yet is
> what to do when there's a short format directory that fails validation
> (such that iget fails).  The inode repairer gets stuck with the job of
> fixing the sf dir, but the (future) directory repair code will have all
> the expertise in fixing directories.  Regrettably, it also requires a
> working xfs_inode.
> 
> So I could just set the sf parent to some obviously garbage value (like
> repair does) to make the verifiers pass and then trip the directory
> repair, and then this hunk would be useful to have in the kernel.  OTOH
> that means more special case flags and other junk, just to end up with
> this kludge that sucks even for xfs_repair.

That being said my approach here was a little too dumb.  Once we are
all in the same code base we can stop the stupid patching of the
parent and just handle the case directly.  Something like this
incremental diff on top of the sent out version (not actually tested).

Total diffstate with the original patch is:

 4 files changed, 37 insertions(+), 35 deletions(-)

and this should also help with online repair while killing a horrible
kludge.


diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 1f6c30b68917c..b4195fafe2172 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -704,9 +704,17 @@ xfs_dir2_sf_check(
 }
 #endif	/* DEBUG */
 
+/*
+ * Allow xfs_repair to enable the parent bypass mode.  For now this is entirely
+ * unused in the kernel, but might come in useful for online repair eventually.
+ */
+#ifndef xfs_inode_parent_bypass
+#define xfs_inode_parent_bypass(ip)	0
+#endif
+
 /* Verify the consistency of an inline directory. */
-static xfs_failaddr_t
-__xfs_dir2_sf_verify(
+xfs_failaddr_t
+xfs_dir2_sf_verify(
 	struct xfs_inode		*ip)
 {
 	struct xfs_mount		*mp = ip->i_mount;
@@ -738,12 +746,26 @@ __xfs_dir2_sf_verify(
 
 	endp = (char *)sfp + size;
 
-	/* Check .. entry */
-	ino = xfs_dir2_sf_get_parent_ino(sfp);
-	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
-	error = xfs_dir_ino_validate(mp, ino);
-	if (error)
-		return __this_address;
+	/*
+	 * Check the .. entry.
+	 *
+	 * If we are running a repair, phase4 may have set the parent inode to
+	 * zero to indicate that it must be fixed.  Skip validating the parent
+	 * in that case.
+	 */
+	if (likely(!xfs_inode_parent_bypass(ip))) {
+		ino = xfs_dir2_sf_get_parent_ino(sfp);
+		i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
+		error = xfs_dir_ino_validate(mp, ino);
+		if (error)
+			return __this_address;
+	} else {
+		/*
+		 * Ensure we account the missing parent as in the right format.
+		 */
+		if (sfp->i8count)
+			i8count++;
+	}
 	offset = mp->m_dir_geo->data_first_offset;
 
 	/* Check all reported entries */
@@ -804,66 +826,6 @@ __xfs_dir2_sf_verify(
 	return NULL;
 }
 
-/*
- * When we're checking directory inodes, we're allowed to set a directory's
- * dotdot entry to zero to signal that the parent needs to be reconnected
- * during xfs_repair phase 6.  If we're handling a shortform directory the ifork
- * verifiers will fail, so temporarily patch out this canary so that we can
- * verify the rest of the fork and move on to fixing the dir.
- */
-static xfs_failaddr_t
-xfs_dir2_sf_verify_dir_check(
-	struct xfs_inode		*ip)
-{
-	struct xfs_mount		*mp = ip->i_mount;
-	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-	struct xfs_dir2_sf_hdr		*sfp =
-		(struct xfs_dir2_sf_hdr *)ifp->if_u1.if_data;
-	int				size = ifp->if_bytes;
-	bool				parent_bypass = false;
-	xfs_ino_t			old_parent;
-	xfs_failaddr_t			fa;
-
-	/*
-	 * If this is a shortform directory, phase4 in xfs_repair may have set
-	 * the parent inode to zero to indicate that it must be fixed.
-	 * Temporarily set a valid parent so that the directory verifier will
-	 * pass.
-	 */
-	if (size > offsetof(struct xfs_dir2_sf_hdr, parent) &&
-	    size >= xfs_dir2_sf_hdr_size(sfp->i8count)) {
-		old_parent = xfs_dir2_sf_get_parent_ino(sfp);
-		if (!old_parent) {
-			xfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
-			parent_bypass = true;
-		}
-	}
-
-	fa = __xfs_dir2_sf_verify(ip);
-
-	/* Put it back. */
-	if (parent_bypass)
-		xfs_dir2_sf_put_parent_ino(sfp, old_parent);
-	return fa;
-}
-
-/*
- * Allow xfs_repair to enable the parent bypass mode.  For now this is entirely
- * unused in the kernel, but might come in useful for online repair eventually.
- */
-#ifndef xfs_inode_parent_bypass
-#define xfs_inode_parent_bypass(ip)	0
-#endif
-
-xfs_failaddr_t
-xfs_dir2_sf_verify(
-	struct xfs_inode		*ip)
-{
-	if (xfs_inode_parent_bypass(ip))
-		return xfs_dir2_sf_verify_dir_check(ip);
-	return __xfs_dir2_sf_verify(ip);
-}
-
 /*
  * Create a new (shortform) directory.
  */
