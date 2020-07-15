Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA11C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 20:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DF582065D
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 20:13:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZcaXyp7k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgGOUNM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 16:13:12 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22874 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726780AbgGOUNL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 16:13:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594843989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wIwMqWILJ+v4fswH5Jt1hU3CL4KYa/Sadu45p8aQ0Lg=;
        b=ZcaXyp7kG1SWME7nxwqYsXOc+TNl/L7+eey4ZCjiLpYdZj4WTm0bBIiLtVyzacs8xP+dpg
        wbxJGAniKWU59JNCx4rPDNOixrOVRUvJS8/VpLVqHoaSva9+EF6wvFbDRaNcOKx9OPUnUK
        IeYcgMvi4p7p/EPRn8SERaEI1EPsWcs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-KIZKHzXdOSGDofRz7tC9IQ-1; Wed, 15 Jul 2020 16:13:05 -0400
X-MC-Unique: KIZKHzXdOSGDofRz7tC9IQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6C861085;
        Wed, 15 Jul 2020 20:13:04 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-87.rdu2.redhat.com [10.10.116.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 711CE60BF1;
        Wed, 15 Jul 2020 20:13:04 +0000 (UTC)
From:   Bill O'Donnell <billodo@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     sandeen@sandeen.net, darrick.wong@oracle.com
Subject: [PATCH 3/3] xfsprogs: xfs_quota state command should report ugp grace times
Date:   Wed, 15 Jul 2020 15:12:53 -0500
Message-Id: <20200715201253.171356-4-billodo@redhat.com>
In-Reply-To: <20200715201253.171356-1-billodo@redhat.com>
References: <20200715201253.171356-1-billodo@redhat.com>
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
 quota/state.c | 108 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 80 insertions(+), 28 deletions(-)

diff --git a/quota/state.c b/quota/state.c
index 1627181d..5aadcca2 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -190,6 +190,39 @@ state_stat_to_statv(
 	}
 }
 
+static void
+state_quotafile_stat(
+	FILE			*fp,
+	uint			type,
+	struct fs_path		*mount,
+	struct fs_quota_statv	*sv)
+{
+	switch(type) {
+	case XFS_USER_QUOTA:
+		state_qfilestat(fp, mount, XFS_USER_QUOTA, &sv->qs_uquota,
+				sv->qs_flags & XFS_QUOTA_UDQ_ACCT,
+				sv->qs_flags & XFS_QUOTA_UDQ_ENFD);
+		break;
+	case XFS_GROUP_QUOTA:
+		state_qfilestat(fp, mount, XFS_GROUP_QUOTA, &sv->qs_gquota,
+				sv->qs_flags & XFS_QUOTA_GDQ_ACCT,
+				sv->qs_flags & XFS_QUOTA_GDQ_ENFD);
+		break;
+	case XFS_PROJ_QUOTA:
+		state_qfilestat(fp, mount, XFS_PROJ_QUOTA, &sv->qs_pquota,
+				sv->qs_flags & XFS_QUOTA_PDQ_ACCT,
+				sv->qs_flags & XFS_QUOTA_PDQ_ENFD);
+		break;
+	}
+	state_timelimit(fp, XFS_BLOCK_QUOTA, sv->qs_btimelimit);
+	state_warnlimit(fp, XFS_BLOCK_QUOTA, sv->qs_bwarnlimit);
+
+	state_timelimit(fp, XFS_INODE_QUOTA, sv->qs_itimelimit);
+	state_warnlimit(fp, XFS_INODE_QUOTA, sv->qs_iwarnlimit);
+
+	state_timelimit(fp, XFS_RTBLOCK_QUOTA, sv->qs_rtbtimelimit);
+}
+
 static void
 state_quotafile_mount(
 	FILE			*fp,
@@ -203,37 +236,56 @@ state_quotafile_mount(
 
 	sv.qs_version = FS_QSTATV_VERSION1;
 
-	if (xfsquotactl(XFS_GETQSTATV, dev, type, 0, (void *)&sv) < 0) {
-		if (xfsquotactl(XFS_GETQSTAT, dev, type, 0, (void *)&s) < 0) {
-			if (flags & VERBOSE_FLAG)
-				fprintf(fp,
-					_("%s quota are not enabled on %s\n"),
-					type_to_string(type), dev);
-			return;
+	if (type & XFS_USER_QUOTA) {
+		if (xfsquotactl(XFS_GETQSTATV, dev, XFS_USER_QUOTA,
+				0, (void *)&sv) < 0) {
+			if (xfsquotactl(XFS_GETQSTAT, dev, XFS_USER_QUOTA,
+					0, (void *)&s) < 0) {
+				if (flags & VERBOSE_FLAG)
+					fprintf(fp,
+						_("%s quota are not enabled on %s\n"),
+						type_to_string(XFS_USER_QUOTA),
+						dev);
+				return;
+			}
+			state_stat_to_statv(&s, &sv);
 		}
-		state_stat_to_statv(&s, &sv);
+		state_quotafile_stat(fp, XFS_USER_QUOTA, mount, &sv);
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
+	if (type & XFS_GROUP_QUOTA) {
+		if (xfsquotactl(XFS_GETQSTATV, dev, XFS_GROUP_QUOTA,
+				0, (void *)&sv) < 0) {
+			if (xfsquotactl(XFS_GETQSTAT, dev, XFS_GROUP_QUOTA,
+					0, (void *)&s) < 0) {
+				if (flags & VERBOSE_FLAG)
+					fprintf(fp,
+						_("%s quota are not enabled on %s\n"),
+						type_to_string(XFS_GROUP_QUOTA),
+						dev);
+				return;
+			}
+			state_stat_to_statv(&s, &sv);
+		}
+		state_quotafile_stat(fp, XFS_GROUP_QUOTA, mount, &sv);
+	}
+
+	if (type & XFS_PROJ_QUOTA) {
+		if (xfsquotactl(XFS_GETQSTATV, dev, XFS_PROJ_QUOTA,
+				0, (void *)&sv) < 0) {
+			if (xfsquotactl(XFS_GETQSTAT, dev, XFS_PROJ_QUOTA,
+					0, (void *)&s) < 0) {
+				if (flags & VERBOSE_FLAG)
+					fprintf(fp,
+						_("%s quota are not enabled on %s\n"),
+						type_to_string(XFS_PROJ_QUOTA),
+						dev);
+				return;
+			}
+			state_stat_to_statv(&s, &sv);
+		}
+		state_quotafile_stat(fp, XFS_PROJ_QUOTA, mount, &sv);
+	}
 }
 
 static void
-- 
2.26.2

