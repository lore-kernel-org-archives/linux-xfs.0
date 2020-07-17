Return-Path: <SRS0=+9Bg=A4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E81C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 20:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C93B92070E
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 20:43:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fgmUVLwo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgGQUnU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jul 2020 16:43:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27521 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726492AbgGQUnU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jul 2020 16:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595018598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KGONjK+Oo0EYc/VwHmXLXppjINSV3ySk+HAa0W/EUcI=;
        b=fgmUVLwoK4dcFY1gXOBKp1L8kZiJKiavJiJdSRPzoLXIrKeMIx+YOQ1gW6QjyPQj4hLtEt
        80qOlHXjx2XbO58B7pCp9LuLNuk60lvKOIPHCmS8keBXGbYhLGvy9sxKMQiDDNKZ5PRaQb
        uRxN1Wf+4GuELZyeogl64sLz9C3SUKw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-w518hMQFOU6vceMNNzrqgA-1; Fri, 17 Jul 2020 16:43:16 -0400
X-MC-Unique: w518hMQFOU6vceMNNzrqgA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3D9AE91A;
        Fri, 17 Jul 2020 20:43:15 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-113-112.rdu2.redhat.com [10.10.113.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 594FA61100;
        Fri, 17 Jul 2020 20:43:15 +0000 (UTC)
From:   Bill O'Donnell <billodo@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     sandeen@sandeen.net, darrick.wong@oracle.com
Subject: [PATCH v2 3/3] xfsprogs: xfs_quota state command should report ugp grace times
Date:   Fri, 17 Jul 2020 15:43:14 -0500
Message-Id: <20200717204314.309873-1-billodo@redhat.com>
In-Reply-To: <20200715201253.171356-4-billodo@redhat.com>
References: <20200715201253.171356-4-billodo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since grace periods are now supported for three quota types (ugp),
modify xfs_quota state command to report times for all three.
Add a helper function for stat reporting.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
v2: load-up helper function more, further reducing redundant LoC

 quota/state.c | 96 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 67 insertions(+), 29 deletions(-)

diff --git a/quota/state.c b/quota/state.c
index 1627181d..19d34ed0 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -191,49 +191,87 @@ state_stat_to_statv(
 }
 
 static void
-state_quotafile_mount(
+state_quotafile_stat(
 	FILE			*fp,
 	uint			type,
-	struct fs_path		*mount,
+	struct fs_path          *mount,
+	struct fs_quota_statv	*sv,
+	struct fs_quota_stat	*s,
 	uint			flags)
 {
-	struct fs_quota_stat	s;
-	struct fs_quota_statv	sv;
+	bool			accounting, enforcing;
+	struct fs_qfilestatv	*qsv;
 	char			*dev = mount->fs_name;
 
-	sv.qs_version = FS_QSTATV_VERSION1;
-
-	if (xfsquotactl(XFS_GETQSTATV, dev, type, 0, (void *)&sv) < 0) {
-		if (xfsquotactl(XFS_GETQSTAT, dev, type, 0, (void *)&s) < 0) {
+	if (xfsquotactl(XFS_GETQSTATV, dev, type, 0, (void *)sv) < 0) {
+		if (xfsquotactl(XFS_GETQSTAT, dev, type, 0, (void *)s) < 0) {
 			if (flags & VERBOSE_FLAG)
 				fprintf(fp,
 					_("%s quota are not enabled on %s\n"),
 					type_to_string(type), dev);
 			return;
 		}
-		state_stat_to_statv(&s, &sv);
+		state_stat_to_statv(s, sv);
+	}
+
+	switch(type) {
+	case XFS_USER_QUOTA:
+		qsv = &sv->qs_uquota;
+		accounting = sv->qs_flags & XFS_QUOTA_UDQ_ACCT;
+		enforcing = sv->qs_flags & XFS_QUOTA_UDQ_ENFD;
+		break;
+	case XFS_GROUP_QUOTA:
+		qsv = &sv->qs_gquota;
+		accounting = sv->qs_flags & XFS_QUOTA_GDQ_ACCT;
+		enforcing = sv->qs_flags & XFS_QUOTA_GDQ_ENFD;
+		break;
+	case XFS_PROJ_QUOTA:
+		qsv = &sv->qs_pquota;
+		accounting = sv->qs_flags & XFS_QUOTA_PDQ_ACCT;
+		enforcing = sv->qs_flags & XFS_QUOTA_PDQ_ENFD;
+		break;
+	default:
+		return;
 	}
 
-	if (type & XFS_USER_QUOTA)
-		state_qfilestat(fp, mount, XFS_USER_QUOTA, &sv.qs_uquota,
-				sv.qs_flags & XFS_QUOTA_UDQ_ACCT,
-				sv.qs_flags & XFS_QUOTA_UDQ_ENFD);
-	if (type & XFS_GROUP_QUOTA)
-		state_qfilestat(fp, mount, XFS_GROUP_QUOTA, &sv.qs_gquota,
-				sv.qs_flags & XFS_QUOTA_GDQ_ACCT,
-				sv.qs_flags & XFS_QUOTA_GDQ_ENFD);
-	if (type & XFS_PROJ_QUOTA)
-		state_qfilestat(fp, mount, XFS_PROJ_QUOTA, &sv.qs_pquota,
-				sv.qs_flags & XFS_QUOTA_PDQ_ACCT,
-				sv.qs_flags & XFS_QUOTA_PDQ_ENFD);
-
-	state_timelimit(fp, XFS_BLOCK_QUOTA, sv.qs_btimelimit);
-	state_warnlimit(fp, XFS_BLOCK_QUOTA, sv.qs_bwarnlimit);
-
-	state_timelimit(fp, XFS_INODE_QUOTA, sv.qs_itimelimit);
-	state_warnlimit(fp, XFS_INODE_QUOTA, sv.qs_iwarnlimit);
-
-	state_timelimit(fp, XFS_RTBLOCK_QUOTA, sv.qs_rtbtimelimit);
+
+	state_qfilestat(fp, mount, type, qsv, accounting, enforcing);
+
+	state_timelimit(fp, XFS_BLOCK_QUOTA, sv->qs_btimelimit);
+	state_warnlimit(fp, XFS_BLOCK_QUOTA, sv->qs_bwarnlimit);
+
+	state_timelimit(fp, XFS_INODE_QUOTA, sv->qs_itimelimit);
+	state_warnlimit(fp, XFS_INODE_QUOTA, sv->qs_iwarnlimit);
+
+	state_timelimit(fp, XFS_RTBLOCK_QUOTA, sv->qs_rtbtimelimit);
+}
+
+static void
+state_quotafile_mount(
+	FILE			*fp,
+	uint			type,
+	struct fs_path		*mount,
+	uint			flags)
+{
+	struct fs_quota_stat	s;
+	struct fs_quota_statv	sv;
+
+	sv.qs_version = FS_QSTATV_VERSION1;
+
+	if (type & XFS_USER_QUOTA) {
+		state_quotafile_stat(fp, XFS_USER_QUOTA, mount,
+				     &sv, &s, flags);
+	}
+
+	if (type & XFS_GROUP_QUOTA) {
+		state_quotafile_stat(fp, XFS_GROUP_QUOTA, mount,
+				     &sv, &s, flags);
+	}
+
+	if (type & XFS_PROJ_QUOTA) {
+		state_quotafile_stat(fp, XFS_PROJ_QUOTA, mount,
+				     &sv, &s, flags);
+	}
 }
 
 static void
-- 
2.26.2

