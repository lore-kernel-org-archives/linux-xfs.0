Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E32DDECAAD5
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 14:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiILOdE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 10:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiILOdD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 10:33:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8758222BF6
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 07:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662993181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QH+ypmzBJGdI+45hsrQt+riV4bAWX3Cma3ocQxF/Iic=;
        b=ibBn/jTHhP5THFgbSb68U8/Xu9ad2xtxpfqIDVhGmn9ETUkq0IUOv0qA7mrVI8CipVAlDd
        7qHdX+Muni2wyyidU0DMe5Zau8FdiQd7hCBb9icZ8AzhIGfqLJVjbn7TmBTpbEN639nbr3
        kaHRrb+Xa7xwbTC70b/wKTMfcX4yG4Q=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-520-KJfRgfmHO1uWWtVW2Mg4OQ-1; Mon, 12 Sep 2022 10:33:00 -0400
X-MC-Unique: KJfRgfmHO1uWWtVW2Mg4OQ-1
Received: by mail-ej1-f72.google.com with SMTP id gb9-20020a170907960900b0077d89030bb2so1067408ejc.18
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 07:32:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=QH+ypmzBJGdI+45hsrQt+riV4bAWX3Cma3ocQxF/Iic=;
        b=gag6NlIvlLrfiyn2oM4t7jNV/t+AQ5Au1nzh+KgfNgl2c3xNeZXTCbNLWU9TF8dScF
         pQ/AFRX4Yrr16XBgO+lOBxazcuvy8Ays8xuv+xIbQjIF+d3fBj3vzvavnxp37XC8JD+a
         k5jP26StY7b2VO4gpShdmmz/gJzBXqxlawhkn7/A+H/K1a6I/Cqzjze04bd5OF+uywQa
         FphNjvrlobq/gtmfVbwbeywIMR6J2hg1Gc1hdnNJheQ16jitXCr45Njv7QihhEePiDru
         IIENDlRdiV7lU+/vQqNHru65NHN7qHNbHD1nUCyXOqIHU/A+/vJCKaWQ88A63CihFrST
         NUIg==
X-Gm-Message-State: ACgBeo2N8ymor9daCVSDF1wVaTG80PENJfv2y8CDSiLH3InGPDUGs9pD
        NdtnXCOBLqdOVIiDpkGlxvvx19/OjyDagGK2L8WhTMdPJhisPXTMRQgvWz2/maAH2GENWj0Z4V+
        trh1bltTJFTcSD4o0v9RcU+B/q0y7wKIYYjRTY51WXeRpaSgKbtpKhju86vaJCRqDRhFTZ3E=
X-Received: by 2002:a17:906:9c82:b0:6df:baa2:9f75 with SMTP id fj2-20020a1709069c8200b006dfbaa29f75mr19277085ejc.762.1662993178761;
        Mon, 12 Sep 2022 07:32:58 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5dKuUPO9EAxMBhfgTyOFPZMPr1sl2+1Vli5MaK27l1ppw5H7SEMCxHCnGfgZs893RzC2NeFA==
X-Received: by 2002:a17:906:9c82:b0:6df:baa2:9f75 with SMTP id fj2-20020a1709069c8200b006dfbaa29f75mr19277069ejc.762.1662993178449;
        Mon, 12 Sep 2022 07:32:58 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id g22-20020a170906539600b0076fa6d9d891sm4500765ejo.46.2022.09.12.07.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 07:32:58 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     cmaiolino@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [RESEND PATCH v3 2/5] xfs_quota: separate get_dquot() and dump_file()
Date:   Mon, 12 Sep 2022 16:32:37 +0200
Message-Id: <20220912143240.31574-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220912143240.31574-1-aalbersh@redhat.com>
References: <20220912142823.30865-1-aalbersh@redhat.com>
 <20220912143240.31574-1-aalbersh@redhat.com>
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

