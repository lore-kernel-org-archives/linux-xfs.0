Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3845C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Mar 2022 22:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiC1W2s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Mar 2022 18:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiC1W2r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 18:28:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B911317179C
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 15:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648506422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tAPum9oxybC3m47gadHNTQn3SDhHD9LpfsI3k5MtpPo=;
        b=B7EvXzO6R6OVCo1XoVpvCCGIgzc05gmmG+8KM+PYhvYRxj7LtBwycSf3cmmOag3ogte3mj
        LFGkZvJ3LMOJa3nC08WG20HF+3n3koSgekM8+65HFW8YhL3UNp3qHFF02yA8X58LQ8xCVG
        vmFGqLG5fiGBtujlKJWh7JASguQJdyY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580--g1SEXviOmugkzom0IjqLg-1; Mon, 28 Mar 2022 18:27:01 -0400
X-MC-Unique: -g1SEXviOmugkzom0IjqLg-1
Received: by mail-ed1-f71.google.com with SMTP id c22-20020a50f616000000b004196649d144so9765514edn.10
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 15:27:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tAPum9oxybC3m47gadHNTQn3SDhHD9LpfsI3k5MtpPo=;
        b=3sjGvm7m3qz9Vy/X4qca+fYPGlx9A1V8vLRStoxVCXie0od3F5XfAqVY8hEhThZDd1
         xdJkWRZl9Xe2gUjrCHB6BMVudMya8O0CXwNqLaJwQh3qCKjmRZmR241Q60a+8+9yULBV
         CwpV2z405I/VUBeV3bbpc5u5hKYlC0ZMhHWnLaej5Ol/8/eRCbsdihsFeSNXNuaS1vg6
         79XT4tQLRW4joYhJZYf9/zlUxy+lMH0m/qObGR/Nf4+4zSvNQUaAEHqvtqSWjIQh6Ar6
         UickIigQi6g39LMFLx6QSbfWJHfAeI8rEzkbGZou5M5c8Uflw9H0bGX5uOvyJobkNmqL
         qMkg==
X-Gm-Message-State: AOAM533kkkmHTHYxisc3wYvgiuYC8XIMykX0BMQ3zpXYTC9rNnlYnD7N
        X46o3z7XwxOcwio/zsv1FQKm3MPpcDm16Y5wMDlwQKq+GXpWscwsEOTPWQZoctsferV9c/uuzaq
        yCJlN0M8lEu5JPS6tCrvaCz12kzZTglubIhPdxapGw3cCO1uGpITb6J9JMadI4mMc+RPYQi4=
X-Received: by 2002:a05:6402:1941:b0:413:2b7e:676e with SMTP id f1-20020a056402194100b004132b7e676emr168860edz.114.1648506419076;
        Mon, 28 Mar 2022 15:26:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEoZcpZCW2lQUfjvWtNyyzSZywjeDDlvujcSH3HVulDTd7cgDnSlQYJhLWvFTqoGKoQjANkg==
X-Received: by 2002:a05:6402:1941:b0:413:2b7e:676e with SMTP id f1-20020a056402194100b004132b7e676emr168838edz.114.1648506418840;
        Mon, 28 Mar 2022 15:26:58 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id t19-20020a056402525300b0041952a1a764sm7722360edd.33.2022.03.28.15.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 15:26:57 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 3/5] xfs_quota: split get_quota() and report_mount()/dump_file()
Date:   Tue, 29 Mar 2022 00:25:01 +0200
Message-Id: <20220328222503.146496-4-aalbersh@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220328222503.146496-1-aalbersh@redhat.com>
References: <20220328222503.146496-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 quota/report.c | 134 ++++++++++++++++++++++++++++---------------------
 1 file changed, 78 insertions(+), 56 deletions(-)

diff --git a/quota/report.c b/quota/report.c
index 0462ce97..14b7f458 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -97,15 +97,8 @@ static int
 dump_file(
 	FILE		*fp,
 	fs_disk_quota_t *d,
-	uint		id,
-	uint		*oid,
-	uint		type,
-	char		*dev,
-	int		flags)
+	char		*dev)
 {
-	if	(!get_quota(d, id, oid, type, dev, flags))
-		return 0;
-
 	if (!d->d_blk_softlimit && !d->d_blk_hardlimit &&
 	    !d->d_ino_softlimit && !d->d_ino_hardlimit &&
 	    !d->d_rtb_softlimit && !d->d_rtb_hardlimit)
@@ -153,46 +146,54 @@ dump_limits_any_type(
 
 	/* Range was specified; query everything in it */
 	if (upper) {
-		for (id = lower; id <= upper; id++)
-			dump_file(fp, &d, id, NULL, type, mount->fs_name, 0);
+		for (id = lower; id <= upper; id++) {
+			get_quota(&d, id, &oid, type, mount->fs_name, 0);
+			dump_file(fp, &d, mount->fs_name);
+		}
 		return;
 	}
 
 	/* Use GETNEXTQUOTA if it's available */
-	if (dump_file(fp, &d, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {
+	if (get_quota(&d, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {
+		dump_file(fp, &d, mount->fs_name);
 		id = oid + 1;
-		while (dump_file(fp, &d, id, &oid, type, mount->fs_name,
-				 GETNEXTQUOTA_FLAG))
+		while (get_quota(&d, id, &oid, type, mount->fs_name,
+					GETNEXTQUOTA_FLAG)) {
+			dump_file(fp, &d, mount->fs_name);
 			id = oid + 1;
+		}
 		return;
-        }
+	}
 
 	/* Otherwise fall back to iterating over each uid/gid/prjid */
 	switch (type) {
 	case XFS_GROUP_QUOTA: {
 			struct group *g;
 			setgrent();
-			while ((g = getgrent()) != NULL)
-				dump_file(fp, &d, g->gr_gid, NULL, type,
-					  mount->fs_name, 0);
+			while ((g = getgrent()) != NULL) {
+				get_quota(&d, g->gr_gid, NULL, type, mount->fs_name, 0);
+				dump_file(fp, &d, mount->fs_name);
+			}
 			endgrent();
 			break;
 		}
 	case XFS_PROJ_QUOTA: {
 			struct fs_project *p;
 			setprent();
-			while ((p = getprent()) != NULL)
-				dump_file(fp, &d, p->pr_prid, NULL, type,
-					  mount->fs_name, 0);
+			while ((p = getprent()) != NULL) {
+				get_quota(&d, p->pr_prid, NULL, type, mount->fs_name, 0);
+				dump_file(fp, &d, mount->fs_name);
+			}
 			endprent();
 			break;
 		}
 	case XFS_USER_QUOTA: {
 			struct passwd *u;
 			setpwent();
-			while ((u = getpwent()) != NULL)
-				dump_file(fp, &d, u->pw_uid, NULL, type,
-					  mount->fs_name, 0);
+			while ((u = getpwent()) != NULL) {
+				get_quota(&d, u->pw_uid, NULL, type, mount->fs_name, 0);
+				dump_file(fp, &d, mount->fs_name);
+			}
 			endpwent();
 			break;
 		}
@@ -336,9 +337,7 @@ static int
 report_mount(
 	FILE		*fp,
 	fs_disk_quota_t *d,
-	uint32_t	id,
 	char		*name,
-	uint32_t	*oid,
 	uint		form,
 	uint		type,
 	fs_path_t	*mount,
@@ -349,9 +348,6 @@ report_mount(
 	uint		qflags;
 	int		count;
 
-	if	(!get_quota(d, id, oid, type, mount->fs_name, flags))
-		return 0;
-
 	if (flags & TERSE_FLAG) {
 		count = 0;
 		if ((form & XFS_BLOCK_QUOTA) && d->d_bcount)
@@ -477,26 +473,35 @@ report_user_mount(
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
-			if (report_mount(fp, &d, id, NULL, NULL,
-					form, XFS_USER_QUOTA, mount, flags))
+			if (get_quota(&d, id, NULL, XFS_USER_QUOTA,
+						mount->fs_name, flags)) {
+				report_mount(fp, &d, NULL, form, XFS_USER_QUOTA, mount,
+						flags);
 				flags |= NO_HEADER_FLAG;
+			}
 		}
-	} else if (report_mount(fp, &d, id, NULL, &oid, form,
-				XFS_USER_QUOTA, mount,
+	} else if (get_quota(&d, id, &oid, XFS_USER_QUOTA, mount->fs_name,
 				flags|GETNEXTQUOTA_FLAG)) {
+		report_mount(fp, &d, NULL, form, XFS_USER_QUOTA, mount,
+			flags|GETNEXTQUOTA_FLAG);
 		id = oid + 1;
 		flags |= GETNEXTQUOTA_FLAG;
 		flags |= NO_HEADER_FLAG;
-		while (report_mount(fp, &d, id, NULL, &oid, form, XFS_USER_QUOTA,
-				    mount, flags)) {
+		while (get_quota(&d, id, &oid, XFS_USER_QUOTA, mount->fs_name,
+				flags)) {
+			report_mount(fp, &d, NULL, form, XFS_USER_QUOTA,
+				mount, flags);
 			id = oid + 1;
 		}
 	} else {
 		setpwent();
 		while ((u = getpwent()) != NULL) {
-			if (report_mount(fp, &d, u->pw_uid, u->pw_name, NULL,
-					form, XFS_USER_QUOTA, mount, flags))
+			if (get_quota(&d, u->pw_uid, NULL, XFS_USER_QUOTA, mount->fs_name,
+					flags)) {
+				report_mount(fp, &d, u->pw_name, form, XFS_USER_QUOTA, mount,
+						flags);
 				flags |= NO_HEADER_FLAG;
+			}
 		}
 		endpwent();
 	}
@@ -520,26 +525,34 @@ report_group_mount(
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
-			if (report_mount(fp, &d, id, NULL, NULL,
-					form, XFS_GROUP_QUOTA, mount, flags))
+			if (get_quota(&d, id, NULL, XFS_GROUP_QUOTA,
+						mount->fs_name, flags)) {
+				report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount, flags);
 				flags |= NO_HEADER_FLAG;
+			}
 		}
-	} else if (report_mount(fp, &d, id, NULL, &oid, form,
-				XFS_GROUP_QUOTA, mount,
-				flags|GETNEXTQUOTA_FLAG)) {
+	} else if (get_quota(&d, id, &oid, XFS_GROUP_QUOTA,
+				mount->fs_name, flags|GETNEXTQUOTA_FLAG)) {
+		report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount,
+				flags|GETNEXTQUOTA_FLAG);
 		id = oid + 1;
 		flags |= GETNEXTQUOTA_FLAG;
 		flags |= NO_HEADER_FLAG;
-		while (report_mount(fp, &d, id, NULL, &oid, form, XFS_GROUP_QUOTA,
-				    mount, flags)) {
+		while (get_quota(&d, id, &oid, XFS_GROUP_QUOTA,
+					mount->fs_name, flags)) {
+			report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount,
+					flags);
 			id = oid + 1;
 		}
 	} else {
 		setgrent();
 		while ((g = getgrent()) != NULL) {
-			if (report_mount(fp, &d, g->gr_gid, g->gr_name, NULL,
-					form, XFS_GROUP_QUOTA, mount, flags))
+			if (get_quota(&d, g->gr_gid, NULL, XFS_GROUP_QUOTA,
+						mount->fs_name, flags)) {
+				report_mount(fp, &d, g->gr_name, form,
+						XFS_GROUP_QUOTA, mount, flags);
 				flags |= NO_HEADER_FLAG;
+			}
 		}
 	}
 	if (flags & NO_HEADER_FLAG)
@@ -562,18 +575,22 @@ report_project_mount(
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
-			if (report_mount(fp, &d, id, NULL, NULL,
-					form, XFS_PROJ_QUOTA, mount, flags))
+			if (get_quota(&d, id, NULL, XFS_PROJ_QUOTA,
+						mount->fs_name, flags)) {
+				report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount, flags);
 				flags |= NO_HEADER_FLAG;
+			}
 		}
-	} else if (report_mount(fp, &d, id, NULL, &oid, form,
-				XFS_PROJ_QUOTA, mount,
-				flags|GETNEXTQUOTA_FLAG)) {
+	} else if (get_quota(&d, id, &oid, XFS_PROJ_QUOTA,
+				mount->fs_name, flags|GETNEXTQUOTA_FLAG)) {
+		report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount,
+				flags|GETNEXTQUOTA_FLAG);
 		id = oid + 1;
 		flags |= GETNEXTQUOTA_FLAG;
 		flags |= NO_HEADER_FLAG;
-		while (report_mount(fp, &d, id, NULL, &oid, form, XFS_PROJ_QUOTA,
-				    mount, flags)) {
+		while (get_quota(&d, id, &oid, XFS_PROJ_QUOTA,
+					mount->fs_name, flags)) {
+			report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount, flags);
 			id = oid + 1;
 		}
 	} else {
@@ -582,16 +599,21 @@ report_project_mount(
 			 * Print default project quota, even if projid 0
 			 * isn't defined
 			 */
-			if (report_mount(fp, &d, 0, NULL, NULL,
-					form, XFS_PROJ_QUOTA, mount, flags))
+			if (get_quota(&d, 0, NULL, XFS_PROJ_QUOTA,
+						mount->fs_name, flags)) {
+				report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount, flags);
 				flags |= NO_HEADER_FLAG;
+			}
 		}
 
 		setprent();
 		while ((p = getprent()) != NULL) {
-			if (report_mount(fp, &d, p->pr_prid, p->pr_name, NULL,
-					form, XFS_PROJ_QUOTA, mount, flags))
+			if (get_quota(&d, p->pr_prid, NULL, XFS_PROJ_QUOTA,
+						mount->fs_name, flags)) {
+				report_mount(fp, &d, p->pr_name, form, XFS_PROJ_QUOTA, mount,
+						flags);
 				flags |= NO_HEADER_FLAG;
+			}
 		}
 		endprent();
 	}
-- 
2.27.0

