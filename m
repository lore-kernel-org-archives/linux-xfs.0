Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8020BC4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Mar 2022 22:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiC1W2u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Mar 2022 18:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiC1W2r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 18:28:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0668B171EF0
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 15:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648506423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yLorVpU4OmrorCzSCw7oTgCr/F/sLwSWRUU9OL3LPR4=;
        b=a4kOmb4dG6tLftHGf9QeLOfGOKRMu55rGmk07NGGTtt4X/+f3In5+AhWTDZSXZ3onrEVMN
        5kZhyBRhIDXyG8soPfcXEC4R/3AVSOdYe27edFkRwZIOw9cGBxfApF5bXY/A40KL8O/BEN
        lkWV/E8suCVy2OYQf84tJ53JN2FzsDM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-ccVNxmZFOluBcNkabAtgUQ-1; Mon, 28 Mar 2022 18:27:02 -0400
X-MC-Unique: ccVNxmZFOluBcNkabAtgUQ-1
Received: by mail-ej1-f69.google.com with SMTP id i14-20020a17090639ce00b006dabe6a112fso7303446eje.13
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 15:27:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yLorVpU4OmrorCzSCw7oTgCr/F/sLwSWRUU9OL3LPR4=;
        b=zxDdUYLD3tbjMW84ZArjGJ46l9QzhfmRZHbxFYCQ+B304BFV+FyVPU8FaxYd+Mz1ME
         3ANR2r5NTQS1MPiu+N/5A8XajjPVirsneIFHLAMMFC0EkH4ZJ5v2boLUQRFQ3Pc/5hX8
         44QvGuiww5vYNCrcv9jyaTzI02FKNVC1DIPcC5mK3dN0q97fy+2p42fLXkTLI39e9s84
         dnqFwn7KcxACrQe79G5CedQIzDXNH0orTLv5vh4lpD2n3SIT1lGXPqMaOAxsC2HE9vWm
         bx45UvxcEyXWqCl4lHxh8Y2r+/g49CW1bsZwxL+IvUsMKVyNrZtOL4ATWhs77e7DKqca
         IsTA==
X-Gm-Message-State: AOAM531Z48egr8cQ/j3FkcjtzHkmZDxuYcfRHSP1Xm/bOqW+LeS00h/F
        2Sjs+twNlGaLiu+TbE3klxmUMr0O3NVbLPtDzmVor10LTi+mNl5IW9f1K3QTXEWUH/RY9mWjRUF
        d+W3iYKilp/Mb/to0N+jfuJgIjOa6k1BiZIc53+jtTuJ89/XmJiXBZaMFy1vA9uQ4zzvPQF8=
X-Received: by 2002:a05:6402:3495:b0:419:1ff6:95d9 with SMTP id v21-20020a056402349500b004191ff695d9mr91463edc.249.1648506420355;
        Mon, 28 Mar 2022 15:27:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLYQI31VpXRJhcebdK5CMDmmPBja5XLRXoXbx6Z5867Jkv3BOAaopR7LJ+hjdB6qmzHN9plA==
X-Received: by 2002:a05:6402:3495:b0:419:1ff6:95d9 with SMTP id v21-20020a056402349500b004191ff695d9mr91436edc.249.1648506420050;
        Mon, 28 Mar 2022 15:27:00 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id t19-20020a056402525300b0041952a1a764sm7722360edd.33.2022.03.28.15.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 15:26:59 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 4/5] xfs_quota: utilize XFS_GETNEXTQUOTA for ranged calls in report/dump
Date:   Tue, 29 Mar 2022 00:25:02 +0200
Message-Id: <20220328222503.146496-5-aalbersh@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220328222503.146496-1-aalbersh@redhat.com>
References: <20220328222503.146496-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The implementation based on XFS_GETQUOTA call for each ID in range,
specified with -L/-U, is quite slow for wider ranges.

If kernel supports XFS_GETNEXTQUOTA, report_*_mount/dump_any_file
will use that to obtain quota list for the mount. XFS_GETNEXTQUOTA
returns quota of the requested ID and next ID with non-empty quota.

Otherwise, XFS_GETQUOTA will be used for each user/group/project ID
known from password/group/project database.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 quota/report.c | 113 +++++++++++++++----------------------------------
 1 file changed, 35 insertions(+), 78 deletions(-)

diff --git a/quota/report.c b/quota/report.c
index 14b7f458..074abbc1 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -135,7 +135,7 @@ dump_limits_any_type(
 {
 	fs_path_t	*mount;
 	fs_disk_quota_t d;
-	uint		id = 0, oid;
+	uint		id = lower, oid, flags = 0;
 
 	if ((mount = fs_table_lookup(dir, FS_MOUNT_POINT)) == NULL) {
 		exitcode = 1;
@@ -144,27 +144,17 @@ dump_limits_any_type(
 		return;
 	}
 
-	/* Range was specified; query everything in it */
-	if (upper) {
-		for (id = lower; id <= upper; id++) {
-			get_quota(&d, id, &oid, type, mount->fs_name, 0);
-			dump_file(fp, &d, mount->fs_name);
-		}
-		return;
-	}
-
-	/* Use GETNEXTQUOTA if it's available */
-	if (get_quota(&d, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {
+	while (get_quota(&d, id, &oid, type,
+				mount->fs_name, flags|GETNEXTQUOTA_FLAG) &&
+			!(upper && (d.d_id > upper))) {
 		dump_file(fp, &d, mount->fs_name);
 		id = oid + 1;
-		while (get_quota(&d, id, &oid, type, mount->fs_name,
-					GETNEXTQUOTA_FLAG)) {
-			dump_file(fp, &d, mount->fs_name);
-			id = oid + 1;
-		}
-		return;
+		flags |= GETNEXTQUOTA_FLAG;
 	}
 
+	if (flags & GETNEXTQUOTA_FLAG)
+		return;
+
 	/* Otherwise fall back to iterating over each uid/gid/prjid */
 	switch (type) {
 	case XFS_GROUP_QUOTA: {
@@ -469,31 +459,19 @@ report_user_mount(
 {
 	struct passwd	*u;
 	fs_disk_quota_t	d;
-	uint		id = 0, oid;
+	uint		id = lower, oid;
 
-	if (upper) {	/* identifier range specified */
-		for (id = lower; id <= upper; id++) {
-			if (get_quota(&d, id, NULL, XFS_USER_QUOTA,
-						mount->fs_name, flags)) {
-				report_mount(fp, &d, NULL, form, XFS_USER_QUOTA, mount,
-						flags);
-				flags |= NO_HEADER_FLAG;
-			}
-		}
-	} else if (get_quota(&d, id, &oid, XFS_USER_QUOTA, mount->fs_name,
-				flags|GETNEXTQUOTA_FLAG)) {
-		report_mount(fp, &d, NULL, form, XFS_USER_QUOTA, mount,
-			flags|GETNEXTQUOTA_FLAG);
+	while (get_quota(&d, id, &oid, XFS_USER_QUOTA,
+				mount->fs_name, flags|GETNEXTQUOTA_FLAG) &&
+			!(upper && (d.d_id > upper))) {
+		report_mount(fp, &d, NULL, form, XFS_USER_QUOTA, mount, flags);
 		id = oid + 1;
 		flags |= GETNEXTQUOTA_FLAG;
 		flags |= NO_HEADER_FLAG;
-		while (get_quota(&d, id, &oid, XFS_USER_QUOTA, mount->fs_name,
-				flags)) {
-			report_mount(fp, &d, NULL, form, XFS_USER_QUOTA,
-				mount, flags);
-			id = oid + 1;
-		}
-	} else {
+	}
+
+	/* No GETNEXTQUOTA support, iterate over all from password file */
+	if (!(flags & GETNEXTQUOTA_FLAG)) {
 		setpwent();
 		while ((u = getpwent()) != NULL) {
 			if (get_quota(&d, u->pw_uid, NULL, XFS_USER_QUOTA, mount->fs_name,
@@ -521,30 +499,19 @@ report_group_mount(
 {
 	struct group	*g;
 	fs_disk_quota_t	d;
-	uint		id = 0, oid;
+	uint		id = lower, oid;
 
-	if (upper) {	/* identifier range specified */
-		for (id = lower; id <= upper; id++) {
-			if (get_quota(&d, id, NULL, XFS_GROUP_QUOTA,
-						mount->fs_name, flags)) {
-				report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount, flags);
-				flags |= NO_HEADER_FLAG;
-			}
-		}
-	} else if (get_quota(&d, id, &oid, XFS_GROUP_QUOTA,
-				mount->fs_name, flags|GETNEXTQUOTA_FLAG)) {
-		report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount,
-				flags|GETNEXTQUOTA_FLAG);
+	while (get_quota(&d, id, &oid, XFS_GROUP_QUOTA,
+				mount->fs_name, flags|GETNEXTQUOTA_FLAG) &&
+			!(upper && (oid > upper))) {
+		report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount, flags);
 		id = oid + 1;
 		flags |= GETNEXTQUOTA_FLAG;
 		flags |= NO_HEADER_FLAG;
-		while (get_quota(&d, id, &oid, XFS_GROUP_QUOTA,
-					mount->fs_name, flags)) {
-			report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount,
-					flags);
-			id = oid + 1;
-		}
-	} else {
+	}
+
+	/* No GETNEXTQUOTA support, iterate over all from password file */
+	if (!(flags & GETNEXTQUOTA_FLAG)) {
 		setgrent();
 		while ((g = getgrent()) != NULL) {
 			if (get_quota(&d, g->gr_gid, NULL, XFS_GROUP_QUOTA,
@@ -571,29 +538,19 @@ report_project_mount(
 {
 	fs_project_t	*p;
 	fs_disk_quota_t	d;
-	uint		id = 0, oid;
+	uint		id = lower, oid;
 
-	if (upper) {	/* identifier range specified */
-		for (id = lower; id <= upper; id++) {
-			if (get_quota(&d, id, NULL, XFS_PROJ_QUOTA,
-						mount->fs_name, flags)) {
-				report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount, flags);
-				flags |= NO_HEADER_FLAG;
-			}
-		}
-	} else if (get_quota(&d, id, &oid, XFS_PROJ_QUOTA,
-				mount->fs_name, flags|GETNEXTQUOTA_FLAG)) {
-		report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount,
-				flags|GETNEXTQUOTA_FLAG);
+	while (get_quota(&d, id, &oid, XFS_PROJ_QUOTA,
+				mount->fs_name, flags|GETNEXTQUOTA_FLAG) &&
+			!(upper && (d.d_id > upper))) {
+		report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount, flags);
 		id = oid + 1;
 		flags |= GETNEXTQUOTA_FLAG;
 		flags |= NO_HEADER_FLAG;
-		while (get_quota(&d, id, &oid, XFS_PROJ_QUOTA,
-					mount->fs_name, flags)) {
-			report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount, flags);
-			id = oid + 1;
-		}
-	} else {
+	}
+
+	/* No GETNEXTQUOTA support, iterate over all */
+	if (!(flags & GETNEXTQUOTA_FLAG)) {
 		if (!getprprid(0)) {
 			/*
 			 * Print default project quota, even if projid 0
-- 
2.27.0

