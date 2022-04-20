Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC91C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 14:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379676AbiDTOyQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 10:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379699AbiDTOyP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 10:54:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B1FA91ADAA
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 07:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650466287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/uyfSYGn+DQ8CsNfujmb0lR/RPOQpdgnTXEfLJbkuDg=;
        b=GL7Qxxhc3H+9ZFaSIGsxMnBShHxmGDV1AWYxC6O0hsqfY0H9A9GO1VOg/rnyGm+2D0eXW+
        swVif+2LWbT+u7Yt3TcB3uo55EqmGUIEhAdsxmqkpq7dwufgWl0UG/UIW5WEo+PjhJma4B
        d+tpquRSqwA5cMAxfqLl8wjc4SL0Dms=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-Zp_OM31NOZ6zhsEtDfPhtQ-1; Wed, 20 Apr 2022 10:51:26 -0400
X-MC-Unique: Zp_OM31NOZ6zhsEtDfPhtQ-1
Received: by mail-ed1-f71.google.com with SMTP id h27-20020a056402095b00b00424269f9580so571732edz.8
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 07:51:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/uyfSYGn+DQ8CsNfujmb0lR/RPOQpdgnTXEfLJbkuDg=;
        b=pvZ5o+lrhEiG5rSjg6dGkQMP7PH46cNlV9vvXVhlAyYNoNks/tVfDQIy/bENWnklHX
         kYCyBuJz9GoPKa9h8A6dbkiO/5pzlqEwAW/s+/8Ndwjb8YQyW914DSIpfmmAGsEeThw/
         /t8O4Qcy2jUTzkPPck+IZomPDKRAo1uOc8Zl9yzzNz0TUydOEJ+56K2pWSnRWODNSK/2
         H6D+ByYRv/pqXKHgP/kTUoPc1l05Cl7yGE1Ez2SpYtaUKVYjZwpcAAn1oD6DF+ErAeKj
         +JAycorNdS8PajF0ibtsqb6SdhAtOoPqnkUPHznCfueWkV50VE+Hd+DY/ljevQQcJWSV
         UUDQ==
X-Gm-Message-State: AOAM531zgQAC61jdLB+p3tPwhkq8Y/9h3Hshtpj1y08FscwbUsAuSS1v
        BEdpD32rx+3AzVVLoBkW8DdynYrfhjqCBL72r3hK4umopsFM4BEVkMKdgwxTBwFvY/CCiDIYrcx
        vYPvHEyXrP3drN5F/xNR9Alh2y0QqLngRIGQPQTcbOv/Vi3gjmQlAdM92GaJDwoI9Hcuk4nc=
X-Received: by 2002:a50:d613:0:b0:41d:71bb:4af3 with SMTP id x19-20020a50d613000000b0041d71bb4af3mr23771361edi.99.1650466284895;
        Wed, 20 Apr 2022 07:51:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSblLWXKBx/cBILnMliyPjbgKvu/s67IrT5/NLcanSibVDN54kDZNl2DlfXme3QO+nAwXSUQ==
X-Received: by 2002:a50:d613:0:b0:41d:71bb:4af3 with SMTP id x19-20020a50d613000000b0041d71bb4af3mr23771348edi.99.1650466284651;
        Wed, 20 Apr 2022 07:51:24 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id s14-20020aa7cb0e000000b00410bf015567sm9935622edt.92.2022.04.20.07.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 07:51:24 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 4/5] xfs_quota: utilize XFS_GETNEXTQUOTA for ranged calls in report/dump
Date:   Wed, 20 Apr 2022 16:45:07 +0200
Message-Id: <20220420144507.269754-5-aalbersh@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220420144507.269754-1-aalbersh@redhat.com>
References: <20220420144507.269754-1-aalbersh@redhat.com>
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
 quota/report.c | 116 +++++++++++++++----------------------------------
 1 file changed, 35 insertions(+), 81 deletions(-)

diff --git a/quota/report.c b/quota/report.c
index 8ca154f0..65d931f3 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -135,7 +135,7 @@ dump_limits_any_type(
 {
 	fs_path_t	*mount;
 	struct fs_disk_quota d;
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
-			get_dquot(&d, id, &oid, type, mount->fs_name, 0);
-			dump_file(fp, &d, mount->fs_name);
-		}
-		return;
-	}
-
-	/* Use GETNEXTQUOTA if it's available */
-	if (get_dquot(&d, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {
+	while (get_dquot(&d, id, &oid, type,
+				mount->fs_name, flags | GETNEXTQUOTA_FLAG) &&
+			!(upper && (d.d_id > upper))) {
 		dump_file(fp, &d, mount->fs_name);
 		id = oid + 1;
-		while (get_dquot(&d, id, &oid, type, mount->fs_name,
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
@@ -472,31 +462,19 @@ report_user_mount(
 {
 	struct passwd	*u;
 	struct fs_disk_quota	d;
-	uint		id = 0, oid;
+	uint		id = lower, oid;
 
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
+	while (get_dquot(&d, id, &oid, XFS_USER_QUOTA,
+				mount->fs_name, flags | GETNEXTQUOTA_FLAG) &&
+			!(upper && (d.d_id > upper))) {
+		report_mount(fp, &d, NULL, form, XFS_USER_QUOTA, mount, flags);
 		id = oid + 1;
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
 			if (get_dquot(&d, u->pw_uid, NULL, XFS_USER_QUOTA,
@@ -524,31 +502,19 @@ report_group_mount(
 {
 	struct group	*g;
 	struct fs_disk_quota	d;
-	uint		id = 0, oid;
+	uint		id = lower, oid;
 
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
+	while (get_dquot(&d, id, &oid, XFS_GROUP_QUOTA,
+				mount->fs_name, flags | GETNEXTQUOTA_FLAG) &&
+			!(upper && (oid > upper))) {
+		report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount, flags);
 		id = oid + 1;
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
 			if (get_dquot(&d, g->gr_gid, NULL, XFS_GROUP_QUOTA,
@@ -575,31 +541,19 @@ report_project_mount(
 {
 	fs_project_t	*p;
 	struct fs_disk_quota	d;
-	uint		id = 0, oid;
+	uint		id = lower, oid;
 
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
+	while (get_dquot(&d, id, &oid, XFS_PROJ_QUOTA,
+				mount->fs_name, flags | GETNEXTQUOTA_FLAG) &&
+			!(upper && (d.d_id > upper))) {
+		report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount, flags);
 		id = oid + 1;
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
-- 
2.27.0

