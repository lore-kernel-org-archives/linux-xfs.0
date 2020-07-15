Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B662CC433E3
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 14:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90516205CB
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 14:08:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bnFlEiRC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgGOOIo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 10:08:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52136 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728326AbgGOOIn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 10:08:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594822122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Dw0z6O6QXEgK0niDqL3RqJpXzkt+pv5pmR2jmtl+6U=;
        b=bnFlEiRCL8hh+hTTb4zP0dCjZlWpDypwTfOddKzu2ko0ssNwR7IncxX6VkWNKeh9rm3PLw
        flVLQoRFcYTXgu79iNAEMN0H/0xpP0CjtrGi/C4IoB1YFK/PYLCxdxDEue0eJ9livGxzbd
        /WSPSopsSwwqKrh3uV3x4PJLFfZk7y8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-rCqdajDKMSm5-12WTh_lkA-1; Wed, 15 Jul 2020 10:08:39 -0400
X-MC-Unique: rCqdajDKMSm5-12WTh_lkA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B633C1090
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 14:08:38 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-214.rdu2.redhat.com [10.10.113.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7904F5D9C5
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 14:08:38 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] repair: remove custom dir2 sf fork verifier from phase6
Date:   Wed, 15 Jul 2020 10:08:36 -0400
Message-Id: <20200715140836.10197-5-bfoster@redhat.com>
In-Reply-To: <20200715140836.10197-1-bfoster@redhat.com>
References: <20200715140836.10197-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The custom verifier exists to catch the case of repair setting a
dummy parent value of zero on directory inodes and temporarily
replace it with a valid inode number so the rest of the directory
verification can proceed. The custom verifier is no longer needed
now that the rootino is used as a dummy value for invalid on-disk
parent values.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/phase6.c | 56 ++-----------------------------------------------
 1 file changed, 2 insertions(+), 54 deletions(-)

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
-- 
2.21.3

