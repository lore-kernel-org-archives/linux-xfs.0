Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24116C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  2 May 2022 15:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbiEBPHe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 May 2022 11:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385654AbiEBPHe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 May 2022 11:07:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A59611154
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 08:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651503843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=btQRdyjwNzFDMoNLa+4mHqbTHYKo52NLSoEhfE4Q9u4=;
        b=OurdBZb+pwDYpp6sQqx23e5do7HMyHUZta4BDrYm0AN0y9ZnpF1RS3acvPb2siq1Ej43r8
        XrlLGQUqyW2+e652oC76uSGHsiRQrESOmNs7HwiVmCzVwm/vjz7ckHALuS1P0/6DSbhYin
        5PqbNPzKRdzI8HmEpm483Fs301b1CKg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-6wOhvOiLN8StkXZWwSTLwQ-1; Mon, 02 May 2022 11:04:02 -0400
X-MC-Unique: 6wOhvOiLN8StkXZWwSTLwQ-1
Received: by mail-wm1-f70.google.com with SMTP id v184-20020a1cacc1000000b00393e492a398so10081373wme.5
        for <linux-xfs@vger.kernel.org>; Mon, 02 May 2022 08:04:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=btQRdyjwNzFDMoNLa+4mHqbTHYKo52NLSoEhfE4Q9u4=;
        b=ymQ4S4FcYevp/LiTYjKKC/eGLYk+ZtQ0ErMlqAA36PJJJp4FdhABAyRwMd8bkGQlnC
         lE6gF0p2YK7Y8p07lOEoiLfp9oDPlGj6mdSUb8ALGTfOv3ZIjBj9XKBAR7badweq3KsT
         cC5DLgxXdLmsD6E7RSejLas2iDOfThoxhNNhq6QjSGTB3e/WAI/viX7Uwpmt7EG72WJL
         dAiX3pqGy7LMsIcjj3Zasij/8j4hioM3CZAubx1AWkTcDwnqBD1/zPoXJRBoRYqf7Fcq
         qAdAEowlhladAKc3HcE18X6njYiZQVt5+3/5jqJic9zRYDcyHUuS1j/NN6vjdTxm09o/
         /w2Q==
X-Gm-Message-State: AOAM531QhbZEWO4SQKQCdjiahatmvtgeZmok29B6R1Dwoe7LzCVLSXCI
        4zXr4uZmZ3sA5OZ72iirrGTsFmz1sT5+YFsmBFRxjGhnz23MQ1Sd14Vs7xC7gSiG1jDmFLpbK0u
        rKPSppl4YkHP7JY1rwO+vbw7uGH+5oAIwLCrD4FgpV0wHGp73FiAT11F3KqVj7fIa0IMSdN0=
X-Received: by 2002:a1c:7414:0:b0:394:1d5d:27f2 with SMTP id p20-20020a1c7414000000b003941d5d27f2mr11415544wmc.37.1651503841047;
        Mon, 02 May 2022 08:04:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyt0P2ZF5fqPa9Qs5gxbbgWsUBPUCK+qi+Fq+UnnvpKnX754r5qNS38UI7LqSSpMFeU7oFeFQ==
X-Received: by 2002:a1c:7414:0:b0:394:1d5d:27f2 with SMTP id p20-20020a1c7414000000b003941d5d27f2mr11415519wmc.37.1651503840722;
        Mon, 02 May 2022 08:04:00 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id m6-20020a05600c3b0600b0039429bfebeasm198794wms.2.2022.05.02.08.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 08:04:00 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v3 3/5] xfs_quota: separate get_dquot() and report_mount()
Date:   Mon,  2 May 2022 17:02:08 +0200
Message-Id: <20220502150207.117112-4-aalbersh@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220502150207.117112-1-aalbersh@redhat.com>
References: <20220502150207.117112-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Separate quota info acquisition from outputting. This allows upper
functions to filter obtained info (e.g. within specific ID range).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 quota/report.c | 178 ++++++++++++++++++++++++++++---------------------
 1 file changed, 103 insertions(+), 75 deletions(-)

diff --git a/quota/report.c b/quota/report.c
index d5c6f84f..8ca154f0 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -339,30 +339,25 @@ report_header(
 static int
 report_mount(
 	FILE		*fp,
-	uint32_t	id,
+	struct fs_disk_quota *d,
 	char		*name,
-	uint32_t	*oid,
 	uint		form,
 	uint		type,
 	fs_path_t	*mount,
 	uint		flags)
 {
-	fs_disk_quota_t	d;
 	time64_t	timer;
 	char		c[8], h[8], s[8];
 	uint		qflags;
 	int		count;
 
-	if (!get_dquot(&d, id, oid, type, mount->fs_name, flags))
-		return 0;
-
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
@@ -372,19 +367,19 @@ report_mount(
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
@@ -393,73 +388,73 @@ report_mount(
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
@@ -476,30 +471,40 @@ report_user_mount(
 	uint		flags)
 {
 	struct passwd	*u;
+	struct fs_disk_quota	d;
 	uint		id = 0, oid;
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
-			if (report_mount(fp, id, NULL, NULL,
-					form, XFS_USER_QUOTA, mount, flags))
+			if (get_dquot(&d, id, NULL, XFS_USER_QUOTA,
+						mount->fs_name, flags)) {
+				report_mount(fp, &d, NULL, form, XFS_USER_QUOTA,
+						mount, flags);
 				flags |= NO_HEADER_FLAG;
+			}
 		}
-	} else if (report_mount(fp, id, NULL, &oid, form,
-				XFS_USER_QUOTA, mount,
+	} else if (get_dquot(&d, id, &oid, XFS_USER_QUOTA, mount->fs_name,
 				flags|GETNEXTQUOTA_FLAG)) {
+		report_mount(fp, &d, NULL, form, XFS_USER_QUOTA, mount,
+			flags|GETNEXTQUOTA_FLAG);
 		id = oid + 1;
 		flags |= GETNEXTQUOTA_FLAG;
 		flags |= NO_HEADER_FLAG;
-		while (report_mount(fp, id, NULL, &oid, form, XFS_USER_QUOTA,
-				    mount, flags)) {
+		while (get_dquot(&d, id, &oid, XFS_USER_QUOTA, mount->fs_name,
+				flags)) {
+			report_mount(fp, &d, NULL, form, XFS_USER_QUOTA,
+				mount, flags);
 			id = oid + 1;
 		}
 	} else {
 		setpwent();
 		while ((u = getpwent()) != NULL) {
-			if (report_mount(fp, u->pw_uid, u->pw_name, NULL,
-					form, XFS_USER_QUOTA, mount, flags))
+			if (get_dquot(&d, u->pw_uid, NULL, XFS_USER_QUOTA,
+						mount->fs_name, flags)) {
+				report_mount(fp, &d, u->pw_name, form,
+						XFS_USER_QUOTA, mount, flags);
 				flags |= NO_HEADER_FLAG;
+			}
 		}
 		endpwent();
 	}
@@ -518,30 +523,40 @@ report_group_mount(
 	uint		flags)
 {
 	struct group	*g;
+	struct fs_disk_quota	d;
 	uint		id = 0, oid;
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
-			if (report_mount(fp, id, NULL, NULL,
-					form, XFS_GROUP_QUOTA, mount, flags))
+			if (get_dquot(&d, id, NULL, XFS_GROUP_QUOTA,
+						mount->fs_name, flags)) {
+				report_mount(fp, &d, NULL, form,
+						XFS_GROUP_QUOTA, mount, flags);
 				flags |= NO_HEADER_FLAG;
+			}
 		}
-	} else if (report_mount(fp, id, NULL, &oid, form,
-				XFS_GROUP_QUOTA, mount,
-				flags|GETNEXTQUOTA_FLAG)) {
+	} else if (get_dquot(&d, id, &oid, XFS_GROUP_QUOTA,
+				mount->fs_name, flags|GETNEXTQUOTA_FLAG)) {
+		report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount,
+				flags|GETNEXTQUOTA_FLAG);
 		id = oid + 1;
 		flags |= GETNEXTQUOTA_FLAG;
 		flags |= NO_HEADER_FLAG;
-		while (report_mount(fp, id, NULL, &oid, form, XFS_GROUP_QUOTA,
-				    mount, flags)) {
+		while (get_dquot(&d, id, &oid, XFS_GROUP_QUOTA,
+					mount->fs_name, flags)) {
+			report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount,
+					flags);
 			id = oid + 1;
 		}
 	} else {
 		setgrent();
 		while ((g = getgrent()) != NULL) {
-			if (report_mount(fp, g->gr_gid, g->gr_name, NULL,
-					form, XFS_GROUP_QUOTA, mount, flags))
+			if (get_dquot(&d, g->gr_gid, NULL, XFS_GROUP_QUOTA,
+						mount->fs_name, flags)) {
+				report_mount(fp, &d, g->gr_name, form,
+						XFS_GROUP_QUOTA, mount, flags);
 				flags |= NO_HEADER_FLAG;
+			}
 		}
 	}
 	if (flags & NO_HEADER_FLAG)
@@ -559,22 +574,29 @@ report_project_mount(
 	uint		flags)
 {
 	fs_project_t	*p;
+	struct fs_disk_quota	d;
 	uint		id = 0, oid;
 
 	if (upper) {	/* identifier range specified */
 		for (id = lower; id <= upper; id++) {
-			if (report_mount(fp, id, NULL, NULL,
-					form, XFS_PROJ_QUOTA, mount, flags))
+			if (get_dquot(&d, id, NULL, XFS_PROJ_QUOTA,
+						mount->fs_name, flags)) {
+				report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA,
+						mount, flags);
 				flags |= NO_HEADER_FLAG;
+			}
 		}
-	} else if (report_mount(fp, id, NULL, &oid, form,
-				XFS_PROJ_QUOTA, mount,
-				flags|GETNEXTQUOTA_FLAG)) {
+	} else if (get_dquot(&d, id, &oid, XFS_PROJ_QUOTA,
+				mount->fs_name, flags|GETNEXTQUOTA_FLAG)) {
+		report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount,
+				flags|GETNEXTQUOTA_FLAG);
 		id = oid + 1;
 		flags |= GETNEXTQUOTA_FLAG;
 		flags |= NO_HEADER_FLAG;
-		while (report_mount(fp, id, NULL, &oid, form, XFS_PROJ_QUOTA,
-				    mount, flags)) {
+		while (get_dquot(&d, id, &oid, XFS_PROJ_QUOTA,
+					mount->fs_name, flags)) {
+			report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount,
+					flags);
 			id = oid + 1;
 		}
 	} else {
@@ -583,16 +605,22 @@ report_project_mount(
 			 * Print default project quota, even if projid 0
 			 * isn't defined
 			 */
-			if (report_mount(fp, 0, NULL, NULL,
-					form, XFS_PROJ_QUOTA, mount, flags))
+			if (get_dquot(&d, 0, NULL, XFS_PROJ_QUOTA,
+						mount->fs_name, flags)) {
+				report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA,
+						mount, flags);
 				flags |= NO_HEADER_FLAG;
+			}
 		}
 
 		setprent();
 		while ((p = getprent()) != NULL) {
-			if (report_mount(fp, p->pr_prid, p->pr_name, NULL,
-					form, XFS_PROJ_QUOTA, mount, flags))
+			if (get_dquot(&d, p->pr_prid, NULL, XFS_PROJ_QUOTA,
+						mount->fs_name, flags)) {
+				report_mount(fp, &d, p->pr_name, form,
+						XFS_PROJ_QUOTA, mount, flags);
 				flags |= NO_HEADER_FLAG;
+			}
 		}
 		endprent();
 	}
-- 
2.27.0

