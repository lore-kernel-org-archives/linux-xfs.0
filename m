Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C485C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 11:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B2FA24954
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 11:13:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CeSA8QDe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgEILNw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 07:13:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26775 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725920AbgEILNw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 07:13:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589022829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SimvooRSQ3Fo0HkJD2vEsBLpY/nLosVvFokOtyN7gMs=;
        b=CeSA8QDeoRn0FPM33HFYBwYV7zRrAHd5+78kDfevPaR2gjKg0tsImo6Y51JodoW21pILOl
        tujNelhT3OLkl6tT8kM3MdZr825K+Re7kb0a7YiTrBuJB4MbCEhjWBc4NvZ4Vqb2J9froO
        EX0jtAjpLURAwMC8n1HY2s15da9fcsU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-hH5Tw1hVP3GJCY27h3UApA-1; Sat, 09 May 2020 07:13:47 -0400
X-MC-Unique: hH5Tw1hVP3GJCY27h3UApA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8B2E18FF660;
        Sat,  9 May 2020 11:13:46 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EAE11C9;
        Sat,  9 May 2020 11:13:46 +0000 (UTC)
Date:   Sat, 9 May 2020 07:13:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: remove xfs_ifork_ops
Message-ID: <20200509111344.GA32702@bfoster>
References: <20200508063423.482370-1-hch@lst.de>
 <20200508063423.482370-9-hch@lst.de>
 <20200508150543.GF27577@bfoster>
 <20200509081715.GA21748@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509081715.GA21748@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 10:17:15AM +0200, Christoph Hellwig wrote:
> On Fri, May 08, 2020 at 11:05:43AM -0400, Brian Foster wrote:
> > On Fri, May 08, 2020 at 08:34:19AM +0200, Christoph Hellwig wrote:
> > > xfs_ifork_ops add up to two indirect calls per inode read and flush,
> > > despite just having a single instance in the kernel.  In xfsprogs
> > > phase6 in xfs_repair overrides the verify_dir method to deal with inodes
> > > that do not have a valid parent, but that can be fixed pretty easily
> > > by ensuring they always have a valid looking parent.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > 
> > Code looks fine, but I assume we'll want a repair fix completed and
> > merged before wiping this out:
> 
> With the xfsprogs merge delays I'm not sure merged will work, but I'll
> happily take your patch and get it in shape for submission.
> 

The critical bit is that repair is fixed before this lands in xfsprogs,
otherwise we just reintroduce the regression the callback mechanism was
designed to fix. The repair change is not huge, but it's not necessarily
trivial so it's probably worth making sure the repair change is at least
reviewed before putting this into the kernel pipeline.

BTW, I played with this a bit more yesterday and made some tweaks that I
think make it a little cleaner. Namely instead of processing the parent
bits in phases 3 and 4 and setting the parent in the internal structures
in phase 4, to do everything in phase 3 and skip the repeat checks in
phase 4. This has the side effect of eliminating some duplicate error
messages where repair complains about the original bogus value in phase
3, sets it to zero, and then complains about the zero value again in
phase 4. This still needs some auditing to assess whether we're losing
any extra verification by setting the parent in phase 3, however. It
also might be worth looking at giving the other dir formats the same
treatment. Squashed diff of my local tree below...

Brian

diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 6685a4d2..96ed6a5b 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -859,14 +859,7 @@ next_readbuf:
 		 */
 		if (isa_dir)  {
 			set_inode_isadir(ino_rec, irec_offset);
-			/*
-			 * we always set the parent but
-			 * we may as well wait until
-			 * phase 4 (no inode discovery)
-			 * because the parent info will
-			 * be solid then.
-			 */
-			if (!ino_discovery)  {
+			if (ino_discovery)  {
 				ASSERT(parent != 0);
 				set_inode_parent(ino_rec, irec_offset, parent);
 				ASSERT(parent ==
diff --git a/repair/dir2.c b/repair/dir2.c
index cbbce601..9c789b4a 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -165,7 +165,6 @@ process_sf_dir2(
 	int			tmp_elen;
 	int			tmp_len;
 	xfs_dir2_sf_entry_t	*tmp_sfep;
-	xfs_ino_t		zero = 0;
 
 	sfp = (struct xfs_dir2_sf_hdr *)XFS_DFORK_DPTR(dip);
 	max_size = XFS_DFORK_DSIZE(dip, mp);
@@ -480,6 +479,9 @@ _("corrected entry offsets in directory %" PRIu64 "\n"),
 	 * check parent (..) entry
 	 */
 	*parent = libxfs_dir2_sf_get_parent_ino(sfp);
+	if (!ino_discovery)
+		return 0;
+
 
 	/*
 	 * if parent entry is bogus, null it out.  we'll fix it later .
@@ -494,7 +496,7 @@ _("bogus .. inode number (%" PRIu64 ") in directory inode %" PRIu64 ", "),
 		if (!no_modify)  {
 			do_warn(_("clearing inode number\n"));
 
-			libxfs_dir2_sf_put_parent_ino(sfp, zero);
+			libxfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
 			*dino_dirty = 1;
 			*repair = 1;
 		} else  {
@@ -529,7 +531,7 @@ _("bad .. entry in directory inode %" PRIu64 ", points to self, "),
 		if (!no_modify)  {
 			do_warn(_("clearing inode number\n"));
 
-			libxfs_dir2_sf_put_parent_ino(sfp, zero);
+			libxfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
 			*dino_dirty = 1;
 			*repair = 1;
 		} else  {
diff --git a/repair/phase6.c b/repair/phase6.c
index beceea9a..43bcea50 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -26,58 +26,6 @@ static struct xfs_name		xfs_name_dot = {(unsigned char *)".",
 						1,
 						XFS_DIR3_FT_DIR};
 
-/*
- * When we're checking directory inodes, we're allowed to set a directory's
- * dotdot entry to zero to signal that the parent needs to be reconnected
- * during phase 6.  If we're handling a shortform directory the ifork
- * verifiers will fail, so temporarily patch out this canary so that we can
- * verify the rest of the fork and move on to fixing the dir.
- */
-static xfs_failaddr_t
-phase6_verify_dir(
-	struct xfs_inode		*ip)
-{
-	struct xfs_mount		*mp = ip->i_mount;
-	struct xfs_ifork		*ifp;
-	struct xfs_dir2_sf_hdr		*sfp;
-	xfs_failaddr_t			fa;
-	xfs_ino_t			old_parent;
-	bool				parent_bypass = false;
-	int				size;
-
-	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-	sfp = (struct xfs_dir2_sf_hdr *)ifp->if_u1.if_data;
-	size = ifp->if_bytes;
-
-	/*
-	 * If this is a shortform directory, phase4 may have set the parent
-	 * inode to zero to indicate that it must be fixed.  Temporarily
-	 * set a valid parent so that the directory verifier will pass.
-	 */
-	if (size > offsetof(struct xfs_dir2_sf_hdr, parent) &&
-	    size >= xfs_dir2_sf_hdr_size(sfp->i8count)) {
-		old_parent = libxfs_dir2_sf_get_parent_ino(sfp);
-		if (old_parent == 0) {
-			libxfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
-			parent_bypass = true;
-		}
-	}
-
-	fa = libxfs_default_ifork_ops.verify_dir(ip);
-
-	/* Put it back. */
-	if (parent_bypass)
-		libxfs_dir2_sf_put_parent_ino(sfp, old_parent);
-
-	return fa;
-}
-
-static struct xfs_ifork_ops phase6_ifork_ops = {
-	.verify_attr	= xfs_attr_shortform_verify,
-	.verify_dir	= phase6_verify_dir,
-	.verify_symlink	= xfs_symlink_shortform_verify,
-};
-
 /*
  * Data structures used to keep track of directories where the ".."
  * entries are updated. These must be rebuilt after the initial pass
@@ -1104,7 +1052,7 @@ mv_orphanage(
 					(unsigned long long)ino, ++incr);
 
 	/* Orphans may not have a proper parent, so use custom ops here */
-	err = -libxfs_iget(mp, NULL, ino, 0, &ino_p, &phase6_ifork_ops);
+	err = -libxfs_iget(mp, NULL, ino, 0, &ino_p, &xfs_default_ifork_ops);
 	if (err)
 		do_error(_("%d - couldn't iget disconnected inode\n"), err);
 
@@ -2875,7 +2823,7 @@ process_dir_inode(
 
 	ASSERT(!is_inode_refchecked(irec, ino_offset) || dotdot_update);
 
-	error = -libxfs_iget(mp, NULL, ino, 0, &ip, &phase6_ifork_ops);
+	error = -libxfs_iget(mp, NULL, ino, 0, &ip, &xfs_default_ifork_ops);
 	if (error) {
 		if (!no_modify)
 			do_error(

