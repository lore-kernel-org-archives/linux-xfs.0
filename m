Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5139EC83000
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 17:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A45120787
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 17:22:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SAD7C22/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgD2RWI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 13:22:08 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24601 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726869AbgD2RWH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 13:22:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588180926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mfemXV+L67J29eQ8gxOefH3jnpUvuNGdf8W/IJPxLaY=;
        b=SAD7C22/+6zyTHMfKjxB+BE6JkeV3DpcFb4ut7n+897SE5AXziNor1bw5+ZD5voxB/B5NN
        B6PRybeOxXV+M7i5ihu5BHf17u2Th7Em2EVBqdSg9GLDH5boxnXgteljqKsO50/iunj2pn
        VxW5I+1gE/9TDJllpWlk+crr39MqdNk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-fTuKwygFOlyEpcTLMljyew-1; Wed, 29 Apr 2020 13:22:04 -0400
X-MC-Unique: fTuKwygFOlyEpcTLMljyew-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD182107ACF6
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:22:03 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67F525C220
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:22:03 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 17/17] xfs: remove unused iget_flags param from xfs_imap_to_bp()
Date:   Wed, 29 Apr 2020 13:21:53 -0400
Message-Id: <20200429172153.41680-18-bfoster@redhat.com>
In-Reply-To: <20200429172153.41680-1-bfoster@redhat.com>
References: <20200429172153.41680-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

iget_flags is unused in xfs_imap_to_bp(). Remove the parameter and
fix up the callers.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 5 ++---
 fs/xfs/libxfs/xfs_inode_buf.h | 2 +-
 fs/xfs/scrub/ialloc.c         | 3 +--
 fs/xfs/xfs_inode.c            | 7 +++----
 fs/xfs/xfs_log_recover.c      | 2 +-
 5 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.=
c
index b102e611bf54..81a010422bea 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -161,8 +161,7 @@ xfs_imap_to_bp(
 	struct xfs_imap		*imap,
 	struct xfs_dinode       **dipp,
 	struct xfs_buf		**bpp,
-	uint			buf_flags,
-	uint			iget_flags)
+	uint			buf_flags)
 {
 	struct xfs_buf		*bp;
 	int			error;
@@ -621,7 +620,7 @@ xfs_iread(
 	/*
 	 * Get pointers to the on-disk inode and the buffer containing it.
 	 */
-	error =3D xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &bp, 0, iget_flags)=
;
+	error =3D xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &bp, 0);
 	if (error)
 		return error;
=20
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.=
h
index 9b373dcf9e34..d9b4781ac9fd 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -48,7 +48,7 @@ struct xfs_imap {
=20
 int	xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
 		       struct xfs_imap *, struct xfs_dinode **,
-		       struct xfs_buf **, uint, uint);
+		       struct xfs_buf **, uint);
 int	xfs_iread(struct xfs_mount *, struct xfs_trans *,
 		  struct xfs_inode *, uint);
 void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 64c217eb06a7..6517d67e8d51 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -278,8 +278,7 @@ xchk_iallocbt_check_cluster(
 			&XFS_RMAP_OINFO_INODES);
=20
 	/* Grab the inode cluster buffer. */
-	error =3D xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap, &dip, &cluster_bp,
-			0, 0);
+	error =3D xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap, &dip, &cluster_bp, =
0);
 	if (!xchk_btree_xref_process_error(bs->sc, bs->cur, 0, &error))
 		return error;
=20
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e0d9a5bf7507..4f915b91b9fd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2172,7 +2172,7 @@ xfs_iunlink_update_inode(
=20
 	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
=20
-	error =3D xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp, 0, 0);
+	error =3D xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp, 0);
 	if (error)
 		return error;
=20
@@ -2302,7 +2302,7 @@ xfs_iunlink_map_ino(
 		return error;
 	}
=20
-	error =3D xfs_imap_to_bp(mp, tp, imap, dipp, bpp, 0, 0);
+	error =3D xfs_imap_to_bp(mp, tp, imap, dipp, bpp, 0);
 	if (error) {
 		xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
 				__func__, error);
@@ -3665,8 +3665,7 @@ xfs_iflush(
 	 * If we get any other error, we effectively have a corruption situatio=
n
 	 * and we cannot flush the inode. Abort the flush and shut down.
 	 */
-	error =3D xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp, XBF_TRYLOCK,
-			       0);
+	error =3D xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp, XBF_TRYLOCK)=
;
 	if (error =3D=3D -EAGAIN) {
 		xfs_ifunlock(ip);
 		return error;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 11c3502b07b1..6a98fd9f00b3 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4987,7 +4987,7 @@ xlog_recover_process_one_iunlink(
 	/*
 	 * Get the on disk inode to find the next inode in the bucket.
 	 */
-	error =3D xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &ibp, 0, 0);
+	error =3D xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &ibp, 0);
 	if (error)
 		goto fail_iput;
=20
--=20
2.21.1

