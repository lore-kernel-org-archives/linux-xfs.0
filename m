Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 071F8C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Dec 2021 12:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237428AbhLIMpr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Dec 2021 07:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234578AbhLIMpr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Dec 2021 07:45:47 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95DAC061746
        for <linux-xfs@vger.kernel.org>; Thu,  9 Dec 2021 04:42:13 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id a37so7692204ljq.13
        for <linux-xfs@vger.kernel.org>; Thu, 09 Dec 2021 04:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:references
         :content-language:to:from:in-reply-to:content-transfer-encoding;
        bh=QGQWma2uEzDNIdt+r3u6ciostCHK2Om3GcZZD9LLSKQ=;
        b=KYp937/IxYhwdFPV1keQTp3DfsUx7BS5VJwgeOD7nbCi8TQItveCacWOhjZ1jeaNEi
         60+c+WKtuxpEL8aqsj5DfmHMRjXJpA+MNXOWO8CPPNYFD/FTHtxWMV9RgPbNWst0PVvK
         aA1H/4JSBcXG3+pyuOxL9CUUiZmbh0mXuZuPepWHdSmCFlSMTEuMITr6A1P1zbmOW26i
         oWtTtHScXotREjtsKQeLjuPMmx8yr/ktSX8tydaXckM+p4o3JiAOQw0q1pGxTO/disSd
         tpxTBq1h9JEBxTyEQyfn53EH6viYLhPZkCLk9WeFCQRTFHc+EzD6I/R88XN9lHYRdnLh
         agfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :references:content-language:to:from:in-reply-to
         :content-transfer-encoding;
        bh=QGQWma2uEzDNIdt+r3u6ciostCHK2Om3GcZZD9LLSKQ=;
        b=aKiepYCpDHKh85EwQAYH3fDhc44txJyCCieI8HqjGxzrj9mu0v/gYOybaw7UBOFlx4
         TINVsaQbG4x/SWTXisERg2B61fzNIJfTE0MvfrJP+1V82CGFmSxzy3BZTXATlmk0HKxD
         MdSd1TMxJ3Mx2bEVwGvTi9/kMvWr83CfMJI8vc7nGDfztwaCTHZ6hnyb24EC+8KMd1Do
         ZM99BYyD3fCigpKGpPYyRhvo3rvzM5ML21M4TkYSFLXZEvrFcL6JEe7V/o+i474rzRxf
         Gd6hFH6tOfWEZiGjiA0ewQfbWGOVjkC3s1MPLiAaIWppQPq5kvalyT2FoHCISY6JwwlR
         43VQ==
X-Gm-Message-State: AOAM53371FvfB6PWgPn2J+jd2nyoo8yiQHE0KfihL7WLD3GJ4dmY+tRf
        gT7g/Lto69w8MXQb/NwzSMvIjgxDaeE=
X-Google-Smtp-Source: ABdhPJyxVx7SffmFMU9ZJPTutkyY2/suu0rDtGxMQNGc6wpkOnLRbq7IVc+CqczgsvzmbKodDYE9nQ==
X-Received: by 2002:a05:651c:12c9:: with SMTP id 9mr6080832lje.474.1639053731617;
        Thu, 09 Dec 2021 04:42:11 -0800 (PST)
Received: from [192.168.68.135] (user-94-254-232-26.play-internet.pl. [94.254.232.26])
        by smtp.gmail.com with ESMTPSA id x3sm519500lfq.238.2021.12.09.04.42.10
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 04:42:10 -0800 (PST)
Message-ID: <fbd06eb0-5d01-a01b-fb5a-af1f8a1ba053@gmail.com>
Date:   Thu, 9 Dec 2021 13:42:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Fwd: [PATCH] xfs_quota: Support XFS_GETNEXTQUOTA in range calls
References: <20211209123934.736295-1-arekm@maven.pl>
Content-Language: pl
To:     linux-xfs@vger.kernel.org
From:   =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
In-Reply-To: <20211209123934.736295-1-arekm@maven.pl>
X-Forwarded-Message-Id: <20211209123934.736295-1-arekm@maven.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


vger still blocks my default domain, so I hope this forward via
thundebird from another domain will get thru and patch won't get corrupted.


--- Treść przekazanej wiadomości ---
Temat: [PATCH] xfs_quota: Support XFS_GETNEXTQUOTA in range calls
Data: Thu,  9 Dec 2021 13:39:34 +0100
Nadawca: Arkadiusz Miśkiewicz <arekm@maven.pl>
Adresat: linux-xfs@vger.kernel.org
Kopia: Arkadiusz Miśkiewicz <arekm@maven.pl>

Use XFS_GETNEXTQUOTA in range call with -L/-U limits. This makes them
perform very fast comparing to current iteration over each (existing
and not existing) ID.

dump_file() and report_mount() take upper agrument which is taken
into account only when GETNEXTQUOTA_MATCH_FLAG is requested and don't
print anything if upper limit is crossed.

Signed-off-by: Arkadiusz Miśkiewicz <arekm@maven.pl>
---
 quota/quota.h  |   1 +
 quota/report.c | 118 ++++++++++++++++++++++++++++++-------------------
 2 files changed, 74 insertions(+), 45 deletions(-)

diff --git a/quota/quota.h b/quota/quota.h
index 78b0d66d..310812f4 100644
--- a/quota/quota.h
+++ b/quota/quota.h
@@ -65,6 +65,7 @@ enum {
 	ABSOLUTE_FLAG =		0x0200, /* absolute time, not related to now */
 	NO_LOOKUP_FLAG =	0x0400, /* skip name lookups, just report ID */
 	GETNEXTQUOTA_FLAG =	0x0800, /* use getnextquota quotactl */
+	GETNEXTQUOTA_MATCH_FLAG =	0x1000,	/* report only if matches range */
 };
  /*
diff --git a/quota/report.c b/quota/report.c
index 6ac55490..39b5286b 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -65,6 +65,7 @@ static int
 dump_file(
 	FILE		*fp,
 	uint		id,
+	uint		upper,
 	uint		*oid,
 	uint		type,
 	char		*dev,
@@ -91,6 +92,9 @@ dump_file(
 		/* Did kernelspace wrap? */
 		if (*oid < id)
 			return 0;
+		/* Range limit was requested */
+		if (flags & GETNEXTQUOTA_MATCH_FLAG && *oid > upper)
+			return 0;
 	}
  	if (!d.d_blk_softlimit && !d.d_blk_hardlimit &&
@@ -137,29 +141,36 @@ dump_limits_any_type(
 		return;
 	}
 -	/* Range was specified; query everything in it */
-	if (upper) {
-		for (id = lower; id <= upper; id++)
-			dump_file(fp, id, NULL, type, mount->fs_name, 0);
-		return;
-	}
+	/* Range was specified */
+	if (lower)
+		id = lower;
  	/* Use GETNEXTQUOTA if it's available */
-	if (dump_file(fp, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {
+	if (dump_file(fp, id, upper, &oid, type, mount->fs_name,
+				GETNEXTQUOTA_FLAG|GETNEXTQUOTA_MATCH_FLAG)) {
 		id = oid + 1;
-		while (dump_file(fp, id, &oid, type, mount->fs_name,
-				 GETNEXTQUOTA_FLAG))
+		while (dump_file(fp, id, upper, &oid, type, mount->fs_name,
+				 GETNEXTQUOTA_FLAG|GETNEXTQUOTA_MATCH_FLAG))
 			id = oid + 1;
 		return;
         }
  	/* Otherwise fall back to iterating over each uid/gid/prjid */
+
+	/* Range was specified; query everything in it */
+	if (upper) {
+		for (id = lower; id <= upper; id++)
+			dump_file(fp, id, 0, NULL, type, mount->fs_name, 0);
+		return;
+	}
+
+	/* No range */
 	switch (type) {
 	case XFS_GROUP_QUOTA: {
 			struct group *g;
 			setgrent();
 			while ((g = getgrent()) != NULL)
-				dump_file(fp, g->gr_gid, NULL, type,
+				dump_file(fp, 0, g->gr_gid, NULL, type,
 					  mount->fs_name, 0);
 			endgrent();
 			break;
@@ -168,7 +179,7 @@ dump_limits_any_type(
 			struct fs_project *p;
 			setprent();
 			while ((p = getprent()) != NULL)
-				dump_file(fp, p->pr_prid, NULL, type,
+				dump_file(fp, 0, p->pr_prid, NULL, type,
 					  mount->fs_name, 0);
 			endprent();
 			break;
@@ -177,7 +188,7 @@ dump_limits_any_type(
 			struct passwd *u;
 			setpwent();
 			while ((u = getpwent()) != NULL)
-				dump_file(fp, u->pw_uid, NULL, type,
+				dump_file(fp, 0, u->pw_uid, NULL, type,
 					  mount->fs_name, 0);
 			endpwent();
 			break;
@@ -322,6 +333,7 @@ static int
 report_mount(
 	FILE		*fp,
 	uint32_t	id,
+	uint32_t	upper,
 	char		*name,
 	uint32_t	*oid,
 	uint		form,
@@ -355,6 +367,9 @@ report_mount(
 		/* Did kernelspace wrap? */
 		if (* oid < id)
 			return 0;
+		 /* Upper range was specified */
+		if (upper && * oid > upper)
+			return 0;
 	}
  	if (flags & TERSE_FLAG) {
@@ -479,26 +494,31 @@ report_user_mount(
 	struct passwd	*u;
 	uint		id = 0, oid;
 -	if (upper) {	/* identifier range specified */
-		for (id = lower; id <= upper; id++) {
-			if (report_mount(fp, id, NULL, NULL,
-					form, XFS_USER_QUOTA, mount, flags))
-				flags |= NO_HEADER_FLAG;
-		}
-	} else if (report_mount(fp, id, NULL, &oid, form,
+	/* Range was specified */
+	if (lower)
+		id = lower;
+	if (upper)
+		flags |= GETNEXTQUOTA_MATCH_FLAG;
+
+	if (report_mount(fp, id, upper, NULL, &oid, form,
 				XFS_USER_QUOTA, mount,
 				flags|GETNEXTQUOTA_FLAG)) {
 		id = oid + 1;
 		flags |= GETNEXTQUOTA_FLAG;
 		flags |= NO_HEADER_FLAG;
-		while (report_mount(fp, id, NULL, &oid, form, XFS_USER_QUOTA,
-				    mount, flags)) {
+		while (report_mount(fp, id, upper, NULL, &oid, form, XFS_USER_QUOTA,
+				    mount, flags))
 			id = oid + 1;
+	} else if (upper) {	/* identifier range specified */
+		for (id = lower; id <= upper; id++) {
+			if (report_mount(fp, id, upper, NULL, NULL,
+					form, XFS_USER_QUOTA, mount, flags))
+				flags |= NO_HEADER_FLAG;
 		}
 	} else {
 		setpwent();
 		while ((u = getpwent()) != NULL) {
-			if (report_mount(fp, u->pw_uid, u->pw_name, NULL,
+			if (report_mount(fp, u->pw_uid, 0, u->pw_name, NULL,
 					form, XFS_USER_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
@@ -521,26 +541,30 @@ report_group_mount(
 	struct group	*g;
 	uint		id = 0, oid;
 -	if (upper) {	/* identifier range specified */
-		for (id = lower; id <= upper; id++) {
-			if (report_mount(fp, id, NULL, NULL,
-					form, XFS_GROUP_QUOTA, mount, flags))
-				flags |= NO_HEADER_FLAG;
-		}
-	} else if (report_mount(fp, id, NULL, &oid, form,
-				XFS_GROUP_QUOTA, mount,
+	/* Range was specified */
+	if (lower)
+		id = lower;
+	if (upper)
+		flags |= GETNEXTQUOTA_MATCH_FLAG;
+
+	if (report_mount(fp, id, upper, NULL, &oid, form, XFS_GROUP_QUOTA, mount,
 				flags|GETNEXTQUOTA_FLAG)) {
 		id = oid + 1;
 		flags |= GETNEXTQUOTA_FLAG;
 		flags |= NO_HEADER_FLAG;
-		while (report_mount(fp, id, NULL, &oid, form, XFS_GROUP_QUOTA,
-				    mount, flags)) {
+		while (report_mount(fp, id, upper, NULL, &oid, form, XFS_GROUP_QUOTA,
+				    mount, flags))
 			id = oid + 1;
+	}  else if (upper) {	/* identifier range specified */
+		for (id = lower; id <= upper; id++) {
+			if (report_mount(fp, id, upper, NULL, NULL,
+					form, XFS_GROUP_QUOTA, mount, flags))
+				flags |= NO_HEADER_FLAG;
 		}
 	} else {
 		setgrent();
 		while ((g = getgrent()) != NULL) {
-			if (report_mount(fp, g->gr_gid, g->gr_name, NULL,
+			if (report_mount(fp, g->gr_gid, 0, g->gr_name, NULL,
 					form, XFS_GROUP_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
@@ -562,21 +586,25 @@ report_project_mount(
 	fs_project_t	*p;
 	uint		id = 0, oid;
 -	if (upper) {	/* identifier range specified */
-		for (id = lower; id <= upper; id++) {
-			if (report_mount(fp, id, NULL, NULL,
-					form, XFS_PROJ_QUOTA, mount, flags))
-				flags |= NO_HEADER_FLAG;
-		}
-	} else if (report_mount(fp, id, NULL, &oid, form,
-				XFS_PROJ_QUOTA, mount,
+	/* Range was specified */
+	if (lower)
+		id = lower;
+	if (upper)
+		flags |= GETNEXTQUOTA_MATCH_FLAG;
+
+	if (report_mount(fp, id, upper, NULL, &oid, form, XFS_PROJ_QUOTA, mount,
 				flags|GETNEXTQUOTA_FLAG)) {
 		id = oid + 1;
 		flags |= GETNEXTQUOTA_FLAG;
 		flags |= NO_HEADER_FLAG;
-		while (report_mount(fp, id, NULL, &oid, form, XFS_PROJ_QUOTA,
-				    mount, flags)) {
+		while (report_mount(fp, id, upper, NULL, &oid, form, XFS_PROJ_QUOTA,
+				    mount, flags))
 			id = oid + 1;
+	} else if (upper) {	/* identifier range specified */
+		for (id = lower; id <= upper; id++) {
+			if (report_mount(fp, id, upper, NULL, NULL,
+					form, XFS_PROJ_QUOTA, mount, flags))
+				flags |= NO_HEADER_FLAG;
 		}
 	} else {
 		if (!getprprid(0)) {
@@ -584,14 +612,14 @@ report_project_mount(
 			 * Print default project quota, even if projid 0
 			 * isn't defined
 			 */
-			if (report_mount(fp, 0, NULL, NULL,
+			if (report_mount(fp, 0, 0, NULL, NULL,
 					form, XFS_PROJ_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
  		setprent();
 		while ((p = getprent()) != NULL) {
-			if (report_mount(fp, p->pr_prid, p->pr_name, NULL,
+			if (report_mount(fp, p->pr_prid, 0, p->pr_name, NULL,
 					form, XFS_PROJ_QUOTA, mount, flags))
 				flags |= NO_HEADER_FLAG;
 		}
-- 
2.33.1

