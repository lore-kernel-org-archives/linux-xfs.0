Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE1B5C6FA83
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 14:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiILOdX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 10:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiILOdV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 10:33:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6570132DBE
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 07:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662993198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=btQRdyjwNzFDMoNLa+4mHqbTHYKo52NLSoEhfE4Q9u4=;
        b=fXKU3PxOlkULuvFSjgYDqAMSVe//n4QTy9tUvuA36FekJ0mBgnE1VGOxwpfa/x/HDRChUW
        DHk8YEjuJHl1ml6At5hjlpDVj+0aek2qEWJY5RIK+p0ICIJYNM+mDlqFVq7b1XhMkovRgm
        TPme3BJAR6Vqpal5TY30466ZDfPhUuo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-538-u7DXK-hROOGErlkYuXhLBA-1; Mon, 12 Sep 2022 10:33:17 -0400
X-MC-Unique: u7DXK-hROOGErlkYuXhLBA-1
Received: by mail-ej1-f70.google.com with SMTP id ho13-20020a1709070e8d00b00730a655e173so3293184ejc.8
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 07:33:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=btQRdyjwNzFDMoNLa+4mHqbTHYKo52NLSoEhfE4Q9u4=;
        b=k9deNHsP3BaThG/rdT3UflElvzPuKMJBDjL8ww63qPWwyahwfA/2jZbyLyDnkurvlN
         0cOVCKCnI6R3V8uvLygEG7E/cb+eck/qhVbtwgr1T4ZtSjOnbhXytfGLnot7Ejs416o+
         nxIJstxER7/70RGyoD2akuU9l53ZDiraf0SQ7zZNL3j5TFllfZv6GMAtl72t9kw9QFDi
         3kYbatcLZkDenJnWB82bnUb8CMobqvM7IEGdZO8RSOK26HgDeNkyX2GGGQycRoZRKCiY
         QNNsry5+Fs7YKSMcBgTONy2ixpz2RGBUx/S/VeJpDW5G/1+s444njSGqBPUt5foZ+gsl
         EzCw==
X-Gm-Message-State: ACgBeo0FRSSLxydt9BFOs5nVNgnuu08M53xz4xTIdMRJq0CZj2PFR1FU
        cSRutac3yT64nI0qet064ZiBodwIRrgkv3n9yMbH1edHW1BigwocMksZ0B9yvdYbzZ8R4gdjMTR
        42bZcisRHgu5tS0hp06WVkq2zrMyUVHo3urTRsCjtoGMQ8ftWHmAJxLcpswCrzK5kW8eZdzs=
X-Received: by 2002:a50:ef03:0:b0:44e:82bf:28e6 with SMTP id m3-20020a50ef03000000b0044e82bf28e6mr21189029eds.270.1662993195912;
        Mon, 12 Sep 2022 07:33:15 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4rK4AzAJDdhRPsOeO57IRqJHz8mjYeLpPWal+j7ww8WsbBb8JDPr1kXz5BTzMtQ9lOTk79Pg==
X-Received: by 2002:a50:ef03:0:b0:44e:82bf:28e6 with SMTP id m3-20020a50ef03000000b0044e82bf28e6mr21189007eds.270.1662993195612;
        Mon, 12 Sep 2022 07:33:15 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id g22-20020a170906539600b0076fa6d9d891sm4500765ejo.46.2022.09.12.07.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 07:33:15 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     cmaiolino@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [RESEND PATCH v3 3/5] xfs_quota: separate get_dquot() and report_mount()
Date:   Mon, 12 Sep 2022 16:32:38 +0200
Message-Id: <20220912143240.31574-3-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220912143240.31574-1-aalbersh@redhat.com>
References: <20220912142823.30865-1-aalbersh@redhat.com>
 <20220912143240.31574-1-aalbersh@redhat.com>
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

