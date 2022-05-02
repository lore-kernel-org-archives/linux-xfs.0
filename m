Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F96C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  2 May 2022 15:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385638AbiEBPHT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 May 2022 11:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235195AbiEBPHS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 May 2022 11:07:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0770310FFC
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 08:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651503829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QH+ypmzBJGdI+45hsrQt+riV4bAWX3Cma3ocQxF/Iic=;
        b=M+3aQJ5OScaYTyRr4KTBUm3bB2zihCie27JrFNSuPPkBVv7XnxGegmmdQhfQPRlh0tQ1sx
        1DJ7K292e3Trc5jseyJWQtAMDPbw8C2lhRhOvsCmvlEvQCxEsptj4Ag48FLfQB+goP/Xtt
        zJ6PG5VQQEjsLDfjwn/NRviVEyPm3lQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-U-FiWBm0NlaqO7R-THyhiw-1; Mon, 02 May 2022 11:03:48 -0400
X-MC-Unique: U-FiWBm0NlaqO7R-THyhiw-1
Received: by mail-wr1-f69.google.com with SMTP id s8-20020adf9788000000b0020adb01dc25so5384301wrb.20
        for <linux-xfs@vger.kernel.org>; Mon, 02 May 2022 08:03:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QH+ypmzBJGdI+45hsrQt+riV4bAWX3Cma3ocQxF/Iic=;
        b=OPMHnI8j2U4/DUx37KIq9EuaCaLwRJT4/7idsH+w9jVYxnzbMxuzwhXDdVFeiIkHSD
         GqkVurg4CmZU6qDAEwgvWV7KDo/BzmHghCfjGPKOpugUi9vE3XKtJffxHL6iiiySJUG/
         D2HI5R/sVc0t0RpjqoO6vg+u/ABZGGqi94qOxATPGPodVbUIRdoRauJCGkSsEZXk1gCW
         ueWljm3uGq3PsB0+edc1VE4Pitze0FA0KMkKcby58UHtfceoW/V3SeN8v/hino4v6Ndz
         r0MDE66EllUuTbeKTUwkd/Ibo9O8bH4sHw5qhYSWfZoh6APNkvSPeIbg1LDltwtA85ph
         pX7A==
X-Gm-Message-State: AOAM531UzMyWNdKpaOPzE1Cb/cYdz/FY1Ii2ijmzcb+ZCixMD6j1BMiZ
        GAVuZdsJsyOx/siO46iJJzyKNg6ihd5U5Xiso/uEI5CK1Oe/ijHlkJ+Hsi2jQmcFkEwo6U38jAF
        evfjMOV8vvQbeYoxHW0sTGT8vgHfAutDFiIkDgObKeNji5aE8kbMZyKC3M4ekyvMIuPp1Yj8=
X-Received: by 2002:a5d:6dd1:0:b0:207:92c4:eaef with SMTP id d17-20020a5d6dd1000000b0020792c4eaefmr9631570wrz.498.1651503826625;
        Mon, 02 May 2022 08:03:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwdWUgSOjX4FQFZ3jJ6HSCRLNJCkMEO1yk0dUKoHwiPHoJH6UjXL4dg+BWxroGajMPHnuW0Gw==
X-Received: by 2002:a5d:6dd1:0:b0:207:92c4:eaef with SMTP id d17-20020a5d6dd1000000b0020792c4eaefmr9631548wrz.498.1651503826326;
        Mon, 02 May 2022 08:03:46 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id m6-20020a05600c3b0600b0039429bfebeasm198794wms.2.2022.05.02.08.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 08:03:46 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v3 2/5] xfs_quota: separate get_dquot() and dump_file()
Date:   Mon,  2 May 2022 17:02:07 +0200
Message-Id: <20220502150207.117112-3-aalbersh@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220502150207.117112-1-aalbersh@redhat.com>
References: <20220502150207.117112-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Separate quota info acquisition from outputting it to file. This
allows upper functions to filter obtained info (e.g. within specific
ID range).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 quota/report.c | 86 ++++++++++++++++++++++++++------------------------
 1 file changed, 45 insertions(+), 41 deletions(-)

diff --git a/quota/report.c b/quota/report.c
index 6994cba6..d5c6f84f 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -96,39 +96,31 @@ get_dquot(
 static int
 dump_file(
 	FILE		*fp,
-	uint		id,
-	uint		*oid,
-	uint		type,
-	char		*dev,
-	int		flags)
+	struct fs_disk_quota *d,
+	char		*dev)
 {
-	struct fs_disk_quota d;
-
-	if (!get_dquot(&d, id, oid, type, dev, flags))
-		return 0;
-
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
@@ -142,6 +134,7 @@ dump_limits_any_type(
 	uint		upper)
 {
 	fs_path_t	*mount;
+	struct fs_disk_quota d;
 	uint		id = 0, oid;
 
 	if ((mount = fs_table_lookup(dir, FS_MOUNT_POINT)) == NULL) {
@@ -153,46 +146,57 @@ dump_limits_any_type(
 
 	/* Range was specified; query everything in it */
 	if (upper) {
-		for (id = lower; id <= upper; id++)
-			dump_file(fp, id, NULL, type, mount->fs_name, 0);
+		for (id = lower; id <= upper; id++) {
+			get_dquot(&d, id, &oid, type, mount->fs_name, 0);
+			dump_file(fp, &d, mount->fs_name);
+		}
 		return;
 	}
 
 	/* Use GETNEXTQUOTA if it's available */
-	if (dump_file(fp, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {
+	if (get_dquot(&d, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {
+		dump_file(fp, &d, mount->fs_name);
 		id = oid + 1;
-		while (dump_file(fp, id, &oid, type, mount->fs_name,
-				 GETNEXTQUOTA_FLAG))
+		while (get_dquot(&d, id, &oid, type, mount->fs_name,
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
-				dump_file(fp, g->gr_gid, NULL, type,
-					  mount->fs_name, 0);
+			while ((g = getgrent()) != NULL) {
+				get_dquot(&d, g->gr_gid, NULL, type,
+						mount->fs_name, 0);
+				dump_file(fp, &d, mount->fs_name);
+			}
 			endgrent();
 			break;
 		}
 	case XFS_PROJ_QUOTA: {
 			struct fs_project *p;
 			setprent();
-			while ((p = getprent()) != NULL)
-				dump_file(fp, p->pr_prid, NULL, type,
-					  mount->fs_name, 0);
+			while ((p = getprent()) != NULL) {
+				get_dquot(&d, p->pr_prid, NULL, type,
+						mount->fs_name, 0);
+				dump_file(fp, &d, mount->fs_name);
+			}
 			endprent();
 			break;
 		}
 	case XFS_USER_QUOTA: {
 			struct passwd *u;
 			setpwent();
-			while ((u = getpwent()) != NULL)
-				dump_file(fp, u->pw_uid, NULL, type,
-					  mount->fs_name, 0);
+			while ((u = getpwent()) != NULL) {
+				get_dquot(&d, u->pw_uid, NULL, type,
+						mount->fs_name, 0);
+				dump_file(fp, &d, mount->fs_name);
+			}
 			endpwent();
 			break;
 		}
-- 
2.27.0

