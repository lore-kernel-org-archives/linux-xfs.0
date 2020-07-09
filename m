Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21093C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 21:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9B9A206E2
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 21:27:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FCoRxw+O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgGIV1L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 17:27:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56361 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726222AbgGIV1L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 17:27:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594330029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aYn611BrcaRJdZY99xyDsQ0+u6HuUgnnl7vQV1IXocU=;
        b=FCoRxw+Oes5ZberRpBhBQiOIwXbmROZgVEgLMgv4wCS95yRXxCs3I4Lpx7aX9PJXZDCRV9
        XFFAZ+0hXdqZomur/P54fnD4A4X6jbaxTSWQMGCHnHIL0sBKujwgQCb1kU/wpmsuDVLlKE
        hhL3EFrw3j4Ym+QJCkRypxVa9Ep0I7I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-NM7u9qfSOF2vQ2uy0rLdfQ-1; Thu, 09 Jul 2020 17:27:07 -0400
X-MC-Unique: NM7u9qfSOF2vQ2uy0rLdfQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2B62107ACCA;
        Thu,  9 Jul 2020 21:27:06 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-115-154.rdu2.redhat.com [10.10.115.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F2E310013C2;
        Thu,  9 Jul 2020 21:27:03 +0000 (UTC)
From:   Bill O'Donnell <billodo@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     sandeen@redhat.com, darrick.wong@oracle.com
Subject: [PATCH] xfsprogs: xfs_quota state command should report ugp grace times
Date:   Thu,  9 Jul 2020 16:26:57 -0500
Message-Id: <20200709212657.216923-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since grace periods are now supported for three quota types (ugp),
modify xfs_quota state command to report times for all three.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 quota/state.c | 71 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 56 insertions(+), 15 deletions(-)

diff --git a/quota/state.c b/quota/state.c
index 7a595fc6..32ccfa42 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -193,33 +193,74 @@ state_quotafile_mount(
 
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
-	}
 
-	if (type & XFS_USER_QUOTA)
 		state_qfilestat(fp, mount, XFS_USER_QUOTA, &sv.qs_uquota,
 				sv.qs_flags & XFS_QUOTA_UDQ_ACCT,
 				sv.qs_flags & XFS_QUOTA_UDQ_ENFD);
-	if (type & XFS_GROUP_QUOTA)
+		state_timelimit(fp, XFS_BLOCK_QUOTA, sv.qs_btimelimit);
+		state_timelimit(fp, XFS_INODE_QUOTA, sv.qs_itimelimit);
+		state_timelimit(fp, XFS_RTBLOCK_QUOTA, sv.qs_rtbtimelimit);
+	}
+
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
 		state_qfilestat(fp, mount, XFS_GROUP_QUOTA, &sv.qs_gquota,
 				sv.qs_flags & XFS_QUOTA_GDQ_ACCT,
 				sv.qs_flags & XFS_QUOTA_GDQ_ENFD);
-	if (type & XFS_PROJ_QUOTA)
+
+		state_timelimit(fp, XFS_BLOCK_QUOTA, sv.qs_btimelimit);
+		state_timelimit(fp, XFS_INODE_QUOTA, sv.qs_itimelimit);
+		state_timelimit(fp, XFS_RTBLOCK_QUOTA, sv.qs_rtbtimelimit);
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
 		state_qfilestat(fp, mount, XFS_PROJ_QUOTA, &sv.qs_pquota,
 				sv.qs_flags & XFS_QUOTA_PDQ_ACCT,
 				sv.qs_flags & XFS_QUOTA_PDQ_ENFD);
 
-	state_timelimit(fp, XFS_BLOCK_QUOTA, sv.qs_btimelimit);
-	state_timelimit(fp, XFS_INODE_QUOTA, sv.qs_itimelimit);
-	state_timelimit(fp, XFS_RTBLOCK_QUOTA, sv.qs_rtbtimelimit);
+		state_timelimit(fp, XFS_BLOCK_QUOTA, sv.qs_btimelimit);
+		state_timelimit(fp, XFS_INODE_QUOTA, sv.qs_itimelimit);
+		state_timelimit(fp, XFS_RTBLOCK_QUOTA, sv.qs_rtbtimelimit);
+	}
 }
 
 static void
-- 
2.26.2

