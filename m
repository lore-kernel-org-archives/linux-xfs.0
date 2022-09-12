Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A1D5C6FA82
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 14:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiILOdc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 10:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiILOdc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 10:33:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0955C22514
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 07:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662993210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z04fjp7haQtvo/r1SoGCcfpNf+DH759/aHtMn3b2XfM=;
        b=OwUbgy46t1lNvwbssS9AUr+TxHnGSVW4YZU8ndbMX/g8xuct0VDYb7F0ZphA7ctFRuVn2P
        88ygretIPu0fv0qKD33PpgQtC+bRGsIBvTuQgMBiI9ka+B5JkEoPOXNhiTY5PuBjLTSCqe
        DA23huZXaz0wtH/gM2Q78qbtTMy+i3w=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-483-Y_AabRwkPYy9KQ5qm1YDdg-1; Mon, 12 Sep 2022 10:33:28 -0400
X-MC-Unique: Y_AabRwkPYy9KQ5qm1YDdg-1
Received: by mail-ed1-f72.google.com with SMTP id dz21-20020a0564021d5500b0045217702048so974929edb.5
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 07:33:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Z04fjp7haQtvo/r1SoGCcfpNf+DH759/aHtMn3b2XfM=;
        b=BDxGDLkY+h9VBaLymbjr6ivKRGvtQxmJzzcUqEc5KdU3M6cBBuuqPEf3mbE1efq6iA
         83PH2YUYD5Fiid6jkB3eNySZrW+kgQ6hC+cr9oX1ZrEIxGeCyoR4a6VIJC1ESfeQqSWH
         PFFdzTAN04HkofxuOwKeEfsuZuzjqxVYxibrCLgaQUDruBMf/nLQAVMmIg8cTHpHW6J+
         m5IPNJPSyF44sfJk9eVrSFLbj3p1mqdle+K00LNplchyAeqzciWgKUl42p75vnoCM4+I
         fS6IHlUI/1jNLfe4eb/ONnrlCiPzAsq22RgCWNOWNX6WxNC476hFr7wVBQ9WgPH5q71a
         msaA==
X-Gm-Message-State: ACgBeo2lyT4VNPGA3A+6Ch8pw/XOWXEdzcgazTd+fB/Xhiom8/N5Abqg
        xj3qdsTOCqmwEGIp1TRo5T96vljy/xl8F5rjIugW/0vGcyrmILWE4iExP43arVEj2OgQ8w2ugxO
        NtNaJabOLQ7Qj/87aQrQExrIJ1NjMNQSrdv5E8F7hKS6q7588ZBo38bELGmWIwp0QZbc5RnA=
X-Received: by 2002:a17:906:9c82:b0:6df:baa2:9f75 with SMTP id fj2-20020a1709069c8200b006dfbaa29f75mr19278604ejc.762.1662993206907;
        Mon, 12 Sep 2022 07:33:26 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6PdGf5balnkvRgoSHWGhVunKoUt8iiRcLBAV5hTWvB6E1c+eSi+w1JuC7NbAsgxc3QXOvFyA==
X-Received: by 2002:a17:906:9c82:b0:6df:baa2:9f75 with SMTP id fj2-20020a1709069c8200b006dfbaa29f75mr19278576ejc.762.1662993206557;
        Mon, 12 Sep 2022 07:33:26 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id g22-20020a170906539600b0076fa6d9d891sm4500765ejo.46.2022.09.12.07.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 07:33:26 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     cmaiolino@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [RESEND PATCH v3 4/5] xfs_quota: utilize XFS_GETNEXTQUOTA for ranged calls in report/dump
Date:   Mon, 12 Sep 2022 16:32:39 +0200
Message-Id: <20220912143240.31574-4-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220912143240.31574-1-aalbersh@redhat.com>
References: <20220912142823.30865-1-aalbersh@redhat.com>
 <20220912143240.31574-1-aalbersh@redhat.com>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

