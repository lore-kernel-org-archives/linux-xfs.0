Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24FFDC433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  2 May 2022 15:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350736AbiEBPIX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 May 2022 11:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385654AbiEBPIW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 May 2022 11:08:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C33C01115A
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 08:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651503892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H0xOQ0r9Bdz4I/zPUnX0Avp3akxJlCRk8jxAhIe8i5Q=;
        b=IPVnPeG0X/g3Yb39oXSzqvoD4AC4ZH9j1mOhgXZ04IXDvloYvg8h0l4um5IAfprNhyfRkk
        VEj1C+A7wErmmNcNoqWE5jhScsOiBNMb77FIkYtm7DPTmIaLar1o2En0oxDfT8QSFJTQ4B
        EKicevkwbHgyriiFBk5ty4OHzfQjZoY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-fZSGfjyCNKW7ulWNdMLdqQ-1; Mon, 02 May 2022 11:04:50 -0400
X-MC-Unique: fZSGfjyCNKW7ulWNdMLdqQ-1
Received: by mail-wm1-f71.google.com with SMTP id k16-20020a7bc310000000b0038e6cf00439so4675310wmj.0
        for <linux-xfs@vger.kernel.org>; Mon, 02 May 2022 08:04:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H0xOQ0r9Bdz4I/zPUnX0Avp3akxJlCRk8jxAhIe8i5Q=;
        b=KKgSrxieq3j40A7FoeJSJx53YfuPC58bTYBS9xZRzlHBKy3pIzOtSs9WwuD01yxXNW
         Nxcf6FsLK7Y68d1IpSHEMRidLBnGaJd1MoDUDqAgyJNz5zcZs7WsKEFg7Y05RqsB9d5u
         hu0b+9mH5lXC4KcZdYY2sgVgDKPwINtGBXBgbevKGFbKIoOrjKvEhsGF2rR0qokcjPLo
         Dv1FmlrqLA1z2DWkUNrFftLW1LZFYeMZ0rQgzmZACbYbNfCyEc2925EG4LKTdkxcrvke
         7HZBzxLOGDmgcnbU5R981v/wVybxmQmmjBCvXjgIg8CRZBCAT10wc1tiv/Z+vI1WD933
         s/xg==
X-Gm-Message-State: AOAM533AsMEGaC54Xs5fH79yGvw+KjBh8fCVPyK4ul5OEX144WbycS/t
        y8M5M1AVyx1W5U3gxR1F+4S4PeFI/lLkyZ4O8CMbzuklMATGyH4EohK6bH4slfiMZa5VHPcfmY3
        Ci+C+Di0TRcJ6MYuNdfSlGJ+RaO4y9fQIzsOp7z4XX/YUWRGsnrXQZ1znFddxvfPKCcMt3ms=
X-Received: by 2002:a1c:7414:0:b0:394:1d5d:27f2 with SMTP id p20-20020a1c7414000000b003941d5d27f2mr11418471wmc.37.1651503889172;
        Mon, 02 May 2022 08:04:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpuF+MNNG2+DJcALbR2tp/v5gLIoHsYozADLCQ+JgzgiLJ8/nRArItHFDpaZOR9eob2Iyqtg==
X-Received: by 2002:a1c:7414:0:b0:394:1d5d:27f2 with SMTP id p20-20020a1c7414000000b003941d5d27f2mr11418456wmc.37.1651503888907;
        Mon, 02 May 2022 08:04:48 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id m6-20020a05600c3b0600b0039429bfebeasm198794wms.2.2022.05.02.08.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 08:04:48 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v3 5/5] xfs_quota: apply -L/-U range limits in uid/gid/pid loops
Date:   Mon,  2 May 2022 17:02:11 +0200
Message-Id: <20220502150207.117112-6-aalbersh@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220502150207.117112-1-aalbersh@redhat.com>
References: <20220502150207.117112-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In case kernel doesn't support XFS_GETNEXTQUOTA the report/dump
command will fallback to iterating over all known uid/gid/pid.
However, currently it won't take -L/-U range limits into account
(all entities with non-zero qoutas will be outputted). This applies
those limits for fallback case.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 quota/report.c | 40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/quota/report.c b/quota/report.c
index 2b9577a5..2acf81b8 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -157,9 +157,11 @@ dump_limits_any_type(
 			struct group *g;
 			setgrent();
 			while ((g = getgrent()) != NULL) {
-				get_dquot(&d, g->gr_gid, type,
-						mount->fs_name, 0);
-				dump_file(fp, &d, mount->fs_name);
+				if (get_dquot(&d, g->gr_gid, type,
+							mount->fs_name, 0) &&
+						!(lower && (d.d_id < lower)) &&
+						!(upper && (d.d_id > upper)))
+					dump_file(fp, &d, mount->fs_name);
 			}
 			endgrent();
 			break;
@@ -168,9 +170,11 @@ dump_limits_any_type(
 			struct fs_project *p;
 			setprent();
 			while ((p = getprent()) != NULL) {
-				get_dquot(&d, p->pr_prid, type,
-						mount->fs_name, 0);
-				dump_file(fp, &d, mount->fs_name);
+				if (get_dquot(&d, p->pr_prid, type,
+							mount->fs_name, 0) &&
+						!(lower && (d.d_id < lower)) &&
+						!(upper && (d.d_id > upper)))
+					dump_file(fp, &d, mount->fs_name);
 			}
 			endprent();
 			break;
@@ -179,9 +183,11 @@ dump_limits_any_type(
 			struct passwd *u;
 			setpwent();
 			while ((u = getpwent()) != NULL) {
-				get_dquot(&d, u->pw_uid, type,
-						mount->fs_name, 0);
-				dump_file(fp, &d, mount->fs_name);
+				if (get_dquot(&d, u->pw_uid, type,
+							mount->fs_name, 0) &&
+						!(lower && (d.d_id < lower)) &&
+						!(upper && (d.d_id > upper)))
+					dump_file(fp, &d, mount->fs_name);
 			}
 			endpwent();
 			break;
@@ -474,7 +480,9 @@ report_user_mount(
 		setpwent();
 		while ((u = getpwent()) != NULL) {
 			if (get_dquot(&d, u->pw_uid, XFS_USER_QUOTA,
-						mount->fs_name, flags)) {
+						mount->fs_name, flags) &&
+					!(lower && (d.d_id < lower)) &&
+					!(upper && (d.d_id > upper))) {
 				report_mount(fp, &d, u->pw_name, form,
 						XFS_USER_QUOTA, mount, flags);
 				flags |= NO_HEADER_FLAG;
@@ -514,7 +522,9 @@ report_group_mount(
 		setgrent();
 		while ((g = getgrent()) != NULL) {
 			if (get_dquot(&d, g->gr_gid, XFS_GROUP_QUOTA,
-						mount->fs_name, flags)) {
+						mount->fs_name, flags) &&
+					!(lower && (d.d_id < lower)) &&
+					!(upper && (d.d_id > upper))) {
 				report_mount(fp, &d, g->gr_name, form,
 						XFS_GROUP_QUOTA, mount, flags);
 				flags |= NO_HEADER_FLAG;
@@ -556,7 +566,9 @@ report_project_mount(
 			 * isn't defined
 			 */
 			if (get_dquot(&d, 0, XFS_PROJ_QUOTA, mount->fs_name,
-						flags)) {
+						flags) &&
+					!(lower && (d.d_id < lower)) &&
+					!(upper && (d.d_id > upper))) {
 				report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA,
 						mount, flags);
 				flags |= NO_HEADER_FLAG;
@@ -566,7 +578,9 @@ report_project_mount(
 		setprent();
 		while ((p = getprent()) != NULL) {
 			if (get_dquot(&d, p->pr_prid, XFS_PROJ_QUOTA,
-						mount->fs_name, flags)) {
+						mount->fs_name, flags) &&
+					!(lower && (d.d_id < lower)) &&
+					!(upper && (d.d_id > upper))) {
 				report_mount(fp, &d, p->pr_name, form,
 						XFS_PROJ_QUOTA, mount, flags);
 				flags |= NO_HEADER_FLAG;
-- 
2.27.0

