Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69057C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  2 May 2022 15:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385657AbiEBPIQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 May 2022 11:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385654AbiEBPIO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 May 2022 11:08:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 91C191115A
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 08:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651503884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r1roQNSgZ/cGG5GoQxXHtuTdQP3YTb266+f3AZ7Q8UE=;
        b=MlCjivZpUMcfAp8F/YJIvP8jpkBX9O51JHyMK4Z9UAfr+15LtOdpEkBlBZRLOzACiXz5sF
        1/289pvG4IFygQwb2RUjCv/3o6vWrawjzZXjSqJyDw+rxQIFAlGlBZImdiPZhWb7Bn45s3
        VZMRT8GxXSbdAvcRyDQTS2xf7Ndt+GM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-lIoZOQuiOh-TGNviJjaowA-1; Mon, 02 May 2022 11:04:43 -0400
X-MC-Unique: lIoZOQuiOh-TGNviJjaowA-1
Received: by mail-wr1-f72.google.com with SMTP id b10-20020adfc74a000000b0020ab029d5edso5363632wrh.18
        for <linux-xfs@vger.kernel.org>; Mon, 02 May 2022 08:04:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r1roQNSgZ/cGG5GoQxXHtuTdQP3YTb266+f3AZ7Q8UE=;
        b=56+d8qsqdyvwMzM2BYOtiSxErZrviIoEWUPCiorH3Fsa3QRH4bdJz0eSMKv98lVJ05
         8n77h4YqmvDXNaKe1ow4Zdc0rMiWLMTEwG2NktMBGvXQK/5IJEN1jkGlKLWnWhszmGx8
         lbfTuP1iDWqNYXCr0rPgleQvR4NNYicGecPTq63cYAGmUBL1cl81xwnJHOzO/FunCsoc
         xJhAeLr47DWKymhFWck3P0ll314BZ3f/j0ILDMho7yEjm4iQIIPQiybfVxfYLBHMZcko
         NmJa/hC//Ro6od0IkbPjKOql/q5N27HRXNZ4yCXTc2x4erjDEMECkiYM7JM81b3/kQDM
         7RgA==
X-Gm-Message-State: AOAM5338UGS9px/gOJ+r7eTRC8qoDx6s7bI7/tUtkaj3YhWG272KtVVi
        KmyCtE/vZLMuTlTB+efj/PgQHWuZLt3woirSvDJ39mvVm2sOZOS0QNVkWcEZD43E2o34QfGftFL
        daiYLQdXvqNv0KrJaP340X9bCXHzq2QNca8h8Em9uJaLiD5M20XQ+7HqCHfYPD+6k2kWmgos=
X-Received: by 2002:a1c:2942:0:b0:392:3aff:4fcd with SMTP id p63-20020a1c2942000000b003923aff4fcdmr11228495wmp.0.1651503882046;
        Mon, 02 May 2022 08:04:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzECIjWoKPu8DMgTlVbCqT6SiqFQPwMrbqHxcMxJ2VDAfHMUeLn5nVhQHR7EUup8Ebzff8LPg==
X-Received: by 2002:a1c:2942:0:b0:392:3aff:4fcd with SMTP id p63-20020a1c2942000000b003923aff4fcdmr11228466wmp.0.1651503881665;
        Mon, 02 May 2022 08:04:41 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id m6-20020a05600c3b0600b0039429bfebeasm198794wms.2.2022.05.02.08.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 08:04:41 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 4/5] xfs_quota: utilize XFS_GETNEXTQUOTA for ranged calls in report/dump
Date:   Mon,  2 May 2022 17:02:10 +0200
Message-Id: <20220502150207.117112-5-aalbersh@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220502150207.117112-1-aalbersh@redhat.com>
References: <20220502150207.117112-1-aalbersh@redhat.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 quota/report.c | 148 ++++++++++++++++---------------------------------
 1 file changed, 49 insertions(+), 99 deletions(-)

diff --git a/quota/report.c b/quota/report.c
index 8ca154f0..2b9577a5 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -63,7 +63,6 @@ static int
 get_dquot(
 	struct fs_disk_quota *d,
 	uint		id,
-	uint		*oid,
 	uint		type,
 	char		*dev,
 	int		flags)
@@ -83,12 +82,9 @@ get_dquot(
 		return 0;
 	}
 
-	if (oid) {
-		*oid = d->d_id;
-		/* Did kernelspace wrap? */
-		if (*oid < id)
-			return 0;
-	}
+	/* Did kernelspace wrap? */
+	if (d->d_id < id)
+		return 0;
 
 	return 1;
 }
@@ -135,7 +131,7 @@ dump_limits_any_type(
 {
 	fs_path_t	*mount;
 	struct fs_disk_quota d;
-	uint		id = 0, oid;
+	uint		id = lower, flags = 0;
 
 	if ((mount = fs_table_lookup(dir, FS_MOUNT_POINT)) == NULL) {
 		exitcode = 1;
@@ -144,26 +140,16 @@ dump_limits_any_type(
 		return;
 	}
 
-	/* Range was specified; query everything in it */
-	if (upper) {
-		for (id = lower; id <= upper; id++) {
-			get_dquot(&d, id, &oid, type, mount->fs_name, 0);
-			dump_file(fp, &d, mount->fs_name);
-		}
-		return;
+	while (get_dquot(&d, id, type, mount->fs_name,
+				flags | GETNEXTQUOTA_FLAG) &&
+			!(upper && (d.d_id > upper))) {
+		dump_file(fp, &d, mount->fs_name);
+		id = d.d_id + 1;
+		flags |= GETNEXTQUOTA_FLAG;
 	}
 
-	/* Use GETNEXTQUOTA if it's available */
-	if (get_dquot(&d, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {
-		dump_file(fp, &d, mount->fs_name);
-		id = oid + 1;
-		while (get_dquot(&d, id, &oid, type, mount->fs_name,
-					GETNEXTQUOTA_FLAG)) {
-			dump_file(fp, &d, mount->fs_name);
-			id = oid + 1;
-		}
+	if (flags & GETNEXTQUOTA_FLAG)
 		return;
-	}
 
 	/* Otherwise fall back to iterating over each uid/gid/prjid */
 	switch (type) {
@@ -171,7 +157,7 @@ dump_limits_any_type(
 			struct group *g;
 			setgrent();
 			while ((g = getgrent()) != NULL) {
-				get_dquot(&d, g->gr_gid, NULL, type,
+				get_dquot(&d, g->gr_gid, type,
 						mount->fs_name, 0);
 				dump_file(fp, &d, mount->fs_name);
 			}
@@ -182,7 +168,7 @@ dump_limits_any_type(
 			struct fs_project *p;
 			setprent();
 			while ((p = getprent()) != NULL) {
-				get_dquot(&d, p->pr_prid, NULL, type,
+				get_dquot(&d, p->pr_prid, type,
 						mount->fs_name, 0);
 				dump_file(fp, &d, mount->fs_name);
 			}
@@ -193,7 +179,7 @@ dump_limits_any_type(
 			struct passwd *u;
 			setpwent();
 			while ((u = getpwent()) != NULL) {
-				get_dquot(&d, u->pw_uid, NULL, type,
+				get_dquot(&d, u->pw_uid, type,
 						mount->fs_name, 0);
 				dump_file(fp, &d, mount->fs_name);
 			}
@@ -472,34 +458,22 @@ report_user_mount(
 {
 	struct passwd	*u;
 	struct fs_disk_quota	d;
-	uint		id = 0, oid;
+	uint		id = lower;
 
-	if (upper) {	/* identifier range specified */
-		for (id = lower; id <= upper; id++) {
-			if (get_dquot(&d, id, NULL, XFS_USER_QUOTA,
-						mount->fs_name, flags)) {
-				report_mount(fp, &d, NULL, form, XFS_USER_QUOTA,
-						mount, flags);
-				flags |= NO_HEADER_FLAG;
-			}
-		}
-	} else if (get_dquot(&d, id, &oid, XFS_USER_QUOTA, mount->fs_name,
-				flags|GETNEXTQUOTA_FLAG)) {
-		report_mount(fp, &d, NULL, form, XFS_USER_QUOTA, mount,
-			flags|GETNEXTQUOTA_FLAG);
-		id = oid + 1;
+	while (get_dquot(&d, id, XFS_USER_QUOTA, mount->fs_name,
+				flags | GETNEXTQUOTA_FLAG) &&
+			!(upper && (d.d_id > upper))) {
+		report_mount(fp, &d, NULL, form, XFS_USER_QUOTA, mount, flags);
+		id = d.d_id + 1;
 		flags |= GETNEXTQUOTA_FLAG;
 		flags |= NO_HEADER_FLAG;
-		while (get_dquot(&d, id, &oid, XFS_USER_QUOTA, mount->fs_name,
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
-			if (get_dquot(&d, u->pw_uid, NULL, XFS_USER_QUOTA,
+			if (get_dquot(&d, u->pw_uid, XFS_USER_QUOTA,
 						mount->fs_name, flags)) {
 				report_mount(fp, &d, u->pw_name, form,
 						XFS_USER_QUOTA, mount, flags);
@@ -524,34 +498,22 @@ report_group_mount(
 {
 	struct group	*g;
 	struct fs_disk_quota	d;
-	uint		id = 0, oid;
+	uint		id = lower;
 
-	if (upper) {	/* identifier range specified */
-		for (id = lower; id <= upper; id++) {
-			if (get_dquot(&d, id, NULL, XFS_GROUP_QUOTA,
-						mount->fs_name, flags)) {
-				report_mount(fp, &d, NULL, form,
-						XFS_GROUP_QUOTA, mount, flags);
-				flags |= NO_HEADER_FLAG;
-			}
-		}
-	} else if (get_dquot(&d, id, &oid, XFS_GROUP_QUOTA,
-				mount->fs_name, flags|GETNEXTQUOTA_FLAG)) {
-		report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount,
-				flags|GETNEXTQUOTA_FLAG);
-		id = oid + 1;
+	while (get_dquot(&d, id, XFS_GROUP_QUOTA, mount->fs_name,
+				flags | GETNEXTQUOTA_FLAG) &&
+			!(upper && (d.d_id > upper))) {
+		report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount, flags);
+		id = d.d_id + 1;
 		flags |= GETNEXTQUOTA_FLAG;
 		flags |= NO_HEADER_FLAG;
-		while (get_dquot(&d, id, &oid, XFS_GROUP_QUOTA,
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
-			if (get_dquot(&d, g->gr_gid, NULL, XFS_GROUP_QUOTA,
+			if (get_dquot(&d, g->gr_gid, XFS_GROUP_QUOTA,
 						mount->fs_name, flags)) {
 				report_mount(fp, &d, g->gr_name, form,
 						XFS_GROUP_QUOTA, mount, flags);
@@ -575,38 +537,26 @@ report_project_mount(
 {
 	fs_project_t	*p;
 	struct fs_disk_quota	d;
-	uint		id = 0, oid;
+	uint		id = lower;
 
-	if (upper) {	/* identifier range specified */
-		for (id = lower; id <= upper; id++) {
-			if (get_dquot(&d, id, NULL, XFS_PROJ_QUOTA,
-						mount->fs_name, flags)) {
-				report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA,
-						mount, flags);
-				flags |= NO_HEADER_FLAG;
-			}
-		}
-	} else if (get_dquot(&d, id, &oid, XFS_PROJ_QUOTA,
-				mount->fs_name, flags|GETNEXTQUOTA_FLAG)) {
-		report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount,
-				flags|GETNEXTQUOTA_FLAG);
-		id = oid + 1;
+	while (get_dquot(&d, id, XFS_PROJ_QUOTA, mount->fs_name,
+				flags | GETNEXTQUOTA_FLAG) &&
+			!(upper && (d.d_id > upper))) {
+		report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount, flags);
+		id = d.d_id + 1;
 		flags |= GETNEXTQUOTA_FLAG;
 		flags |= NO_HEADER_FLAG;
-		while (get_dquot(&d, id, &oid, XFS_PROJ_QUOTA,
-					mount->fs_name, flags)) {
-			report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount,
-					flags);
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
 			 * isn't defined
 			 */
-			if (get_dquot(&d, 0, NULL, XFS_PROJ_QUOTA,
-						mount->fs_name, flags)) {
+			if (get_dquot(&d, 0, XFS_PROJ_QUOTA, mount->fs_name,
+						flags)) {
 				report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA,
 						mount, flags);
 				flags |= NO_HEADER_FLAG;
@@ -615,7 +565,7 @@ report_project_mount(
 
 		setprent();
 		while ((p = getprent()) != NULL) {
-			if (get_dquot(&d, p->pr_prid, NULL, XFS_PROJ_QUOTA,
+			if (get_dquot(&d, p->pr_prid, XFS_PROJ_QUOTA,
 						mount->fs_name, flags)) {
 				report_mount(fp, &d, p->pr_name, form,
 						XFS_PROJ_QUOTA, mount, flags);
-- 
2.27.0

