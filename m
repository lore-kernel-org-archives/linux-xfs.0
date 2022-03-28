Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3018FC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Mar 2022 22:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiC1W2u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Mar 2022 18:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiC1W2s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 18:28:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 60E18171EDD
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 15:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648506423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+EKfEVzXllFlN1G2PH4iLz38gpFp6iSOljzKO+cJiKc=;
        b=TJJJ2uUfT3DSU/wu9mD8lLoj0p62imxCwaIoF4Eu7kb5V3rclRpEB8Ezjt04I9z82AdqAN
        gZ5cfcno+++S0wrkHUwmqtReCX1JswHE+Q1Cu2NT8MZ4QXINqUMPmZHBnyO5N5XAzprrhu
        ZM8mrapHmxs5ae/svBtsDfsZZKr/kn4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-YfLwJ2zXPcW_XbLLGfDMUA-1; Mon, 28 Mar 2022 18:26:59 -0400
X-MC-Unique: YfLwJ2zXPcW_XbLLGfDMUA-1
Received: by mail-ed1-f70.google.com with SMTP id o20-20020aa7dd54000000b00413bc19ad08so9776261edw.7
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 15:26:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+EKfEVzXllFlN1G2PH4iLz38gpFp6iSOljzKO+cJiKc=;
        b=stvhb04Ka0neB6RpjvqK77AjAmM1AyqrUfgiMqbXT+THT24a2sHN3RX/T1keWDTfzu
         BGAzBaV9tsxGtRFP5RJT6jntt6otZD/Pyd68MWK7I1sCJSafp7D7lMiYoENhWm1Jpujj
         0n0TAElbpbiLYghB7vKXE40xokte3PBOooTOYux+hrts4U0NMAp7YGwKBK2ISPDFlvOK
         nhxh1R554vFhiNfXtHSGuOa6tzutkHRz/Z0CZIxchT8wAQuFFqFm4O/MMuRLWOSEO3IE
         bn4bv9iWUBbjEBj1PMESkTmcAxpemv2QsKJHsxYLpz8G/sSg3pSo38ez1pcLARfTIs1q
         x8oQ==
X-Gm-Message-State: AOAM5329PXltx/UiQzx14klw4Y7L2cZjOow1zSQkjj4GlSbLA2f210Ae
        efGgyPRimwmeD6YJntJ2jGzQ6pH37+84AeApWTBgYB7Bqt+6AqUBW0XRVSAkHM5lN8535grn5rt
        OnHS9SrPJROiXNGslp2lVDxi/JYG6ELSgs6TSD58sUVgLym8xQWtx8poidByTJHXzyrPaABs=
X-Received: by 2002:a05:6402:4414:b0:419:28bc:55dc with SMTP id y20-20020a056402441400b0041928bc55dcmr160951eda.130.1648506417630;
        Mon, 28 Mar 2022 15:26:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwff5pDNvXXLuwuSAtcdbzw5GuntRlLwWHtLVuy8oLWZy+eB0w2aPzL93tbMxaL1IKlVZXyng==
X-Received: by 2002:a05:6402:4414:b0:419:28bc:55dc with SMTP id y20-20020a056402441400b0041928bc55dcmr160929eda.130.1648506417357;
        Mon, 28 Mar 2022 15:26:57 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id t19-20020a056402525300b0041952a1a764sm7722360edd.33.2022.03.28.15.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 15:26:56 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 2/5] xfs_quota: create fs_disk_quota_t on upper level
Date:   Tue, 29 Mar 2022 00:25:00 +0200
Message-Id: <20220328222503.146496-3-aalbersh@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220328222503.146496-1-aalbersh@redhat.com>
References: <20220328222503.146496-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

For further splitting of get_quota() and dump_file()/report_mount().

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 quota/report.c | 165 +++++++++++++++++++++++++------------------------
 1 file changed, 84 insertions(+), 81 deletions(-)

diff --git a/quota/report.c b/quota/report.c
index 97a89a92..0462ce97 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -96,39 +96,38 @@ get_quota(
 static int
 dump_file(
 	FILE		*fp,
+	fs_disk_quota_t *d,
 	uint		id,
 	uint		*oid,
 	uint		type,
 	char		*dev,
 	int		flags)
 {
-	fs_disk_quota_t	d;
-
-	if	(!get_quota(&d, id, oid, type, dev, flags))
+	if	(!get_quota(d, id, oid, type, dev, flags))
 		return 0;
 
-	if (!d.d_blk_softlimit && !d.d_blk_hardlimit &&
-	    !d.d_ino_softlimit && !d.d_ino_hardlimit &&
-	    !d.d_rtb_softlimit && !d.d_rtb_hardlimit)
+	if (!d->d_blk_softlimit && !d->d_blk_hardlimit &&
+	    !d->d_ino_softlimit && !d->d_ino_hardlimit &&
+	    !d->d_rtb_softlimit && !d->d_rtb_hardlimit)
 		return 1;
 	fprintf(fp, "fs = %s\n", dev);
 	/* this branch is for backward compatibility reasons */
-	if (d.d_rtb_softlimit || d.d_rtb_hardlimit)
+	if (d->d_rtb_softlimit || d->d_rtb_hardlimit)
 		fprintf(fp, "%-10d %7llu %7llu %7llu %7llu %7llu %7llu\n",
-			d.d_id,
-			(unsigned long long)d.d_blk_softlimit,
-			(unsigned long long)d.d_blk_hardlimit,
-			(unsigned long long)d.d_ino_softlimit,
-			(unsigned long long)d.d_ino_hardlimit,
-			(unsigned long long)d.d_rtb_softlimit,
-			(unsigned long long)d.d_rtb_hardlimit);
+			d->d_id,
+			(unsigned long long)d->d_blk_softlimit,
+			(unsigned long long)d->d_blk_hardlimit,
+			(unsigned long long)d->d_ino_softlimit,
+			(unsigned long long)d->d_ino_hardlimit,
+			(unsigned long long)d->d_rtb_softlimit,
+			(unsigned long long)d->d_rtb_hardlimit);
 	else
 		fprintf(fp, "%-10d %7llu %7llu %7llu %7llu\n",
-			d.d_id,
-			(unsigned long long)d.d_blk_softlimit,
-			(unsigned long long)d.d_blk_hardlimit,
-			(unsigned long long)d.d_ino_softlimit,
-			(unsigned long long)d.d_ino_hardlimit);
+			d->d_id,
+			(unsigned long long)d->d_blk_softlimit,
+			(unsigned long long)d->d_blk_hardlimit,
+			(unsigned long long)d->d_ino_softlimit,
+			(unsigned long long)d->d_ino_hardlimit);
 
 	return 1;
 }
@@ -142,6 +141,7 @@ dump_limits_any_type(
 	uint		upper)
 {
 	fs_path_t	*mount;
+	fs_disk_quota_t d;
 	uint		id = 0, oid;
 
 	if ((mount = fs_table_lookup(dir, FS_MOUNT_POINT)) == NULL) {
@@ -154,14 +154,14 @@ dump_limits_any_type(
 	/* Range was specified; query everything in it */
 	if (upper) {
 		for (id = lower; id <= upper; id++)
-			dump_file(fp, id, NULL, type, mount->fs_name, 0);
+			dump_file(fp, &d, id, NULL, type, mount->fs_name, 0);
 		return;
 	}
 
 	/* Use GETNEXTQUOTA if it's available */
-	if (dump_file(fp, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {
+	if (dump_file(fp, &d, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {
 		id = oid + 1;
-		while (dump_file(fp, id, &oid, type, mount->fs_name,
+		while (dump_file(fp, &d, id, &oid, type, mount->fs_name,
 				 GETNEXTQUOTA_FLAG))
 			id = oid + 1;
 		return;
@@ -173,7 +173,7 @@ dump_limits_any_type(
 			struct group *g;
 			setgrent();
 			while ((g = getgrent()) != NULL)
-				dump_file(fp, g->gr_gid, NULL, type,
+				dump_file(fp, &d, g->gr_gid, NULL, type,
 					  mount->fs_name, 0);
 			endgrent();
 			break;
@@ -182,7 +182,7 @@ dump_limits_any_type(
 			struct fs_project *p;
 			setprent();
 			while ((p = getprent()) != NULL)
-				dump_file(fp, p->pr_prid, NULL, type,
+				dump_file(fp, &d, p->pr_prid, NULL, type,
 					  mount->fs_name, 0);
 			endprent();
 			break;
@@ -191,7 +191,7 @@ dump_limits_any_type(
 			struct passwd *u;
 			setpwent();
 			while ((u = getpwent()) != NULL)
-				dump_file(fp, u->pw_uid, NULL, type,
+				dump_file(fp, &d, u->pw_uid, NULL, type,
 					  mount->fs_name, 0);
 			endpwent();
 			break;
@@ -335,6 +335,7 @@ report_header(
 static int
 report_mount(
 	FILE		*fp,
+	fs_disk_quota_t *d,
 	uint32_t	id,
 	char		*name,
 	uint32_t	*oid,
@@ -343,22 +344,21 @@ report_mount(
 	fs_path_t	*mount,
 	uint		flags)
 {
-	fs_disk_quota_t	d;
 	time64_t	timer;
 	char		c[8], h[8], s[8];
 	uint		qflags;
 	int		count;
 
-	if	(!get_quota(&d, id, oid, type, mount->fs_name, flags))
+	if	(!get_quota(d, id, oid, type, mount->fs_name, flags))
 		return 0;
 
 	if (flags & TERSE_FLAG) {
 		count = 0;
-		if ((form & XFS_BLOCK_QUOTA) && d.d_bcount)
+		if ((form & XFS_BLOCK_QUOTA) && d->d_bcount)
 			count++;
-		if ((form & XFS_INODE_QUOTA) && d.d_icount)
+		if ((form & XFS_INODE_QUOTA) && d->d_icount)
 			count++;
-		if ((form & XFS_RTBLOCK_QUOTA) && d.d_rtbcount)
+		if ((form & XFS_RTBLOCK_QUOTA) && d->d_rtbcount)
 			count++;
 		if (!count)
 			return 0;
@@ -368,19 +368,19 @@ report_mount(
 		report_header(fp, form, type, mount, flags);
 
 	if (flags & NO_LOOKUP_FLAG) {
-		fprintf(fp, "#%-10u", d.d_id);
+		fprintf(fp, "#%-10u", d->d_id);
 	} else {
 		if (name == NULL) {
 			if (type == XFS_USER_QUOTA) {
-				struct passwd	*u = getpwuid(d.d_id);
+				struct passwd	*u = getpwuid(d->d_id);
 				if (u)
 					name = u->pw_name;
 			} else if (type == XFS_GROUP_QUOTA) {
-				struct group	*g = getgrgid(d.d_id);
+				struct group	*g = getgrgid(d->d_id);
 				if (g)
 					name = g->gr_name;
 			} else if (type == XFS_PROJ_QUOTA) {
-				fs_project_t	*p = getprprid(d.d_id);
+				fs_project_t	*p = getprprid(d->d_id);
 				if (p)
 					name = p->pr_name;
 			}
@@ -389,73 +389,73 @@ report_mount(
 		if (name != NULL)
 			fprintf(fp, "%-10s", name);
 		else
-			fprintf(fp, "#%-9u", d.d_id);
+			fprintf(fp, "#%-9u", d->d_id);
 	}
 
 	if (form & XFS_BLOCK_QUOTA) {
-		timer = decode_timer(&d, d.d_btimer, d.d_btimer_hi);
+		timer = decode_timer(d, d->d_btimer, d->d_btimer_hi);
 		qflags = (flags & HUMAN_FLAG);
-		if (d.d_blk_hardlimit && d.d_bcount > d.d_blk_hardlimit)
+		if (d->d_blk_hardlimit && d->d_bcount > d->d_blk_hardlimit)
 			qflags |= LIMIT_FLAG;
-		if (d.d_blk_softlimit && d.d_bcount > d.d_blk_softlimit)
+		if (d->d_blk_softlimit && d->d_bcount > d->d_blk_softlimit)
 			qflags |= QUOTA_FLAG;
 		if (flags & HUMAN_FLAG)
 			fprintf(fp, " %6s %6s %6s  %02d %8s",
-				bbs_to_string(d.d_bcount, c, sizeof(c)),
-				bbs_to_string(d.d_blk_softlimit, s, sizeof(s)),
-				bbs_to_string(d.d_blk_hardlimit, h, sizeof(h)),
-				d.d_bwarns,
+				bbs_to_string(d->d_bcount, c, sizeof(c)),
+				bbs_to_string(d->d_blk_softlimit, s, sizeof(s)),
+				bbs_to_string(d->d_blk_hardlimit, h, sizeof(h)),
+				d->d_bwarns,
 				time_to_string(timer, qflags));
 		else
 			fprintf(fp, " %10llu %10llu %10llu     %02d %9s",
-				(unsigned long long)d.d_bcount >> 1,
-				(unsigned long long)d.d_blk_softlimit >> 1,
-				(unsigned long long)d.d_blk_hardlimit >> 1,
-				d.d_bwarns,
+				(unsigned long long)d->d_bcount >> 1,
+				(unsigned long long)d->d_blk_softlimit >> 1,
+				(unsigned long long)d->d_blk_hardlimit >> 1,
+				d->d_bwarns,
 				time_to_string(timer, qflags));
 	}
 	if (form & XFS_INODE_QUOTA) {
-		timer = decode_timer(&d, d.d_itimer, d.d_itimer_hi);
+		timer = decode_timer(d, d->d_itimer, d->d_itimer_hi);
 		qflags = (flags & HUMAN_FLAG);
-		if (d.d_ino_hardlimit && d.d_icount > d.d_ino_hardlimit)
+		if (d->d_ino_hardlimit && d->d_icount > d->d_ino_hardlimit)
 			qflags |= LIMIT_FLAG;
-		if (d.d_ino_softlimit && d.d_icount > d.d_ino_softlimit)
+		if (d->d_ino_softlimit && d->d_icount > d->d_ino_softlimit)
 			qflags |= QUOTA_FLAG;
 		if (flags & HUMAN_FLAG)
 			fprintf(fp, " %6s %6s %6s  %02d %8s",
-				num_to_string(d.d_icount, c, sizeof(c)),
-				num_to_string(d.d_ino_softlimit, s, sizeof(s)),
-				num_to_string(d.d_ino_hardlimit, h, sizeof(h)),
-				d.d_iwarns,
+				num_to_string(d->d_icount, c, sizeof(c)),
+				num_to_string(d->d_ino_softlimit, s, sizeof(s)),
+				num_to_string(d->d_ino_hardlimit, h, sizeof(h)),
+				d->d_iwarns,
 				time_to_string(timer, qflags));
 		else
 			fprintf(fp, " %10llu %10llu %10llu     %02d %9s",
-				(unsigned long long)d.d_icount,
-				(unsigned long long)d.d_ino_softlimit,
-				(unsigned long long)d.d_ino_hardlimit,
-				d.d_iwarns,
+				(unsigned long long)d->d_icount,
+				(unsigned long long)d->d_ino_softlimit,
+				(unsigned long long)d->d_ino_hardlimit,
+				d->d_iwarns,
 				time_to_string(timer, qflags));
 	}
 	if (form & XFS_RTBLOCK_QUOTA) {
-		timer = decode_timer(&d, d.d_rtbtimer, d.d_rtbtimer_hi);
+		timer = decode_timer(d, d->d_rtbtimer, d->d_rtbtimer_hi);
 		qflags = (flags & HUMAN_FLAG);
-		if (d.d_rtb_hardlimit && d.d_rtbcount > d.d_rtb_hardlimit)
+		if (d->d_rtb_hardlimit && d->d_rtbcount > d->d_rtb_hardlimit)
 			qflags |= LIMIT_FLAG;
-		if (d.d_rtb_softlimit && d.d_rtbcount > d.d_rtb_softlimit)
+		if (d->d_rtb_softlimit && d->d_rtbcount > d->d_rtb_softlimit)
 			qflags |= QUOTA_FLAG;
 		if (flags & HUMAN_FLAG)
 			fprintf(fp, " %6s %6s %6s  %02d %8s",
-				bbs_to_string(d.d_rtbcount, c, sizeof(c)),
-				bbs_to_string(d.d_rtb_softlimit, s, sizeof(s)),
-				bbs_to_string(d.d_rtb_hardlimit, h, sizeof(h)),
-				d.d_rtbwarns,
+				bbs_to_string(d->d_rtbcount, c, sizeof(c)),
+				bbs_to_string(d->d_rtb_softlimit, s, sizeof(s)),
+				bbs_to_string(d->d_rtb_hardlimit, h, sizeof(h)),
+				d->d_rtbwarns,
 				time_to_string(timer, qflags));
 		else
 			fprintf(fp, " %10llu %10llu %10llu     %02d %9s",
-				(unsigned long long)d.d_rtbcount >> 1,
-				(unsigned long long)d.d_rtb_softlimit >> 1,
-				(unsigned long long)d.d_rtb_hardlimit >> 1,
-				d.d_rtbwarns,
+				(unsigned long long)d->d_rtbcount >> 1,
+				(unsigned long long)d->d_rtb_softlimit >> 1,
+				(unsigned long long)d->d_rtb_hardlimit >> 1,
+				d->d_rtbwarns,
 				time_to_string(timer, qflags));
 	}
 	fputc('\n', fp);
@@ -472,28 +472,29 @@ report_user_mount(
 	uint		flags)
 {
 	struct passwd	*u;
+	fs_disk_quota_t	d;
 	uint		id = 0, oid;
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
-			if (report_mount(fp, id, NULL, NULL,
+			if (report_mount(fp, &d, id, NULL, NULL,
 					form, XFS_USER_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
-	} else if (report_mount(fp, id, NULL, &oid, form,
+	} else if (report_mount(fp, &d, id, NULL, &oid, form,
 				XFS_USER_QUOTA, mount,
 				flags|GETNEXTQUOTA_FLAG)) {
 		id = oid + 1;
 		flags |= GETNEXTQUOTA_FLAG;
 		flags |= NO_HEADER_FLAG;
-		while (report_mount(fp, id, NULL, &oid, form, XFS_USER_QUOTA,
+		while (report_mount(fp, &d, id, NULL, &oid, form, XFS_USER_QUOTA,
 				    mount, flags)) {
 			id = oid + 1;
 		}
 	} else {
 		setpwent();
 		while ((u = getpwent()) != NULL) {
-			if (report_mount(fp, u->pw_uid, u->pw_name, NULL,
+			if (report_mount(fp, &d, u->pw_uid, u->pw_name, NULL,
 					form, XFS_USER_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
@@ -514,28 +515,29 @@ report_group_mount(
 	uint		flags)
 {
 	struct group	*g;
+	fs_disk_quota_t	d;
 	uint		id = 0, oid;
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
-			if (report_mount(fp, id, NULL, NULL,
+			if (report_mount(fp, &d, id, NULL, NULL,
 					form, XFS_GROUP_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
-	} else if (report_mount(fp, id, NULL, &oid, form,
+	} else if (report_mount(fp, &d, id, NULL, &oid, form,
 				XFS_GROUP_QUOTA, mount,
 				flags|GETNEXTQUOTA_FLAG)) {
 		id = oid + 1;
 		flags |= GETNEXTQUOTA_FLAG;
 		flags |= NO_HEADER_FLAG;
-		while (report_mount(fp, id, NULL, &oid, form, XFS_GROUP_QUOTA,
+		while (report_mount(fp, &d, id, NULL, &oid, form, XFS_GROUP_QUOTA,
 				    mount, flags)) {
 			id = oid + 1;
 		}
 	} else {
 		setgrent();
 		while ((g = getgrent()) != NULL) {
-			if (report_mount(fp, g->gr_gid, g->gr_name, NULL,
+			if (report_mount(fp, &d, g->gr_gid, g->gr_name, NULL,
 					form, XFS_GROUP_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
@@ -555,21 +557,22 @@ report_project_mount(
 	uint		flags)
 {
 	fs_project_t	*p;
+	fs_disk_quota_t	d;
 	uint		id = 0, oid;
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
-			if (report_mount(fp, id, NULL, NULL,
+			if (report_mount(fp, &d, id, NULL, NULL,
 					form, XFS_PROJ_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
-	} else if (report_mount(fp, id, NULL, &oid, form,
+	} else if (report_mount(fp, &d, id, NULL, &oid, form,
 				XFS_PROJ_QUOTA, mount,
 				flags|GETNEXTQUOTA_FLAG)) {
 		id = oid + 1;
 		flags |= GETNEXTQUOTA_FLAG;
 		flags |= NO_HEADER_FLAG;
-		while (report_mount(fp, id, NULL, &oid, form, XFS_PROJ_QUOTA,
+		while (report_mount(fp, &d, id, NULL, &oid, form, XFS_PROJ_QUOTA,
 				    mount, flags)) {
 			id = oid + 1;
 		}
@@ -579,14 +582,14 @@ report_project_mount(
 			 * Print default project quota, even if projid 0
 			 * isn't defined
 			 */
-			if (report_mount(fp, 0, NULL, NULL,
+			if (report_mount(fp, &d, 0, NULL, NULL,
 					form, XFS_PROJ_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
 
 		setprent();
 		while ((p = getprent()) != NULL) {
-			if (report_mount(fp, p->pr_prid, p->pr_name, NULL,
+			if (report_mount(fp, &d, p->pr_prid, p->pr_name, NULL,
 					form, XFS_PROJ_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
-- 
2.27.0

