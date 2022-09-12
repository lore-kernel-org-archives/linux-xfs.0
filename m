Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB3A9C6FA82
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 14:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiILOc7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 10:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiILOc6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 10:32:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA96832B85
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 07:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662993177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5n9LB+TgutgWaIDwPqNAtAcvVuSlBy1Wq3hDaWCM2k0=;
        b=Kwb8D8JNG+YGLsoNsUuw7PgbhHpOYAh9qfGMijgcE+A9L21L7zseirJ67rpTOh28yEJYuD
        /OZUUsb7yqoTUTW7WQ7xAuAQtojIZz3ttBTpNSNRmONJth0orKnTkMDzbYRQxXg3I945z9
        7bazOtSI9FWYubuNX08MLp369sX/26U=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-597-9e74-UCkM5a0Vt-1ZXPMRw-1; Mon, 12 Sep 2022 10:32:55 -0400
X-MC-Unique: 9e74-UCkM5a0Vt-1ZXPMRw-1
Received: by mail-ed1-f71.google.com with SMTP id f18-20020a056402355200b0045115517911so5986077edd.14
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 07:32:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=5n9LB+TgutgWaIDwPqNAtAcvVuSlBy1Wq3hDaWCM2k0=;
        b=tWb52wkFnnnbr5Y6jRAHnmCcbIXQgrStXu7jO913hR/cwdJ0aTOEWKO0ngNw2ajNHP
         i2BNqhfIL7AhrKmsIqxLYLy+AcknN3HNiO2uWc03sTei7ECbArLx99TmSrKZn43FHt1M
         6m4gNKSGgrxT0WIwYaad+vu4VQUGwZrN3DkspSFfh/v1DlgtgwshgUPERUMsdcfl5DXF
         KbPQXS3mGqea/9HLYv7K5KJ6GDIdIDjB7TFLV7NyW0HidyzNe6wDEk+ZWkd7wKbVdZL8
         NHFPfkNzq+rV+hOzRPqG6WeaIeYl7oDTPfhg1X2ccJjF7cVEt6D0oWByiqlPBFTfFwJ0
         iebQ==
X-Gm-Message-State: ACgBeo2nQVJ5GUKqz9IUjjzJDFqZ+nqop3NovuxVsl1FkBCjztHtz3pv
        vE1cZECxL4bc2gdCFAi8b57HpjPXVbBGOZWs389LE3BSGO7CIIQBMu+w3ikJdgx/jiPMVucTWNU
        sKv71hHe2GrDXBtWbEgOMx8vH1kuhN/YEmQ3wg4nDSctACr8l75f7ZUtrwljT8r8G2UGbLnI=
X-Received: by 2002:a05:6402:184:b0:442:fd54:2a21 with SMTP id r4-20020a056402018400b00442fd542a21mr22005297edv.129.1662993174618;
        Mon, 12 Sep 2022 07:32:54 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7Ni6PTxr3R+hRb9EEq8k9OJFe37emyopgOCPp4G3NAP6oTR01X/cKphqRoKpfvKYMXgUCxXA==
X-Received: by 2002:a05:6402:184:b0:442:fd54:2a21 with SMTP id r4-20020a056402018400b00442fd542a21mr22005278edv.129.1662993174429;
        Mon, 12 Sep 2022 07:32:54 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id g22-20020a170906539600b0076fa6d9d891sm4500765ejo.46.2022.09.12.07.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 07:32:54 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     cmaiolino@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [RESEND PATCH v3 1/5] xfs_quota: separate quota info acquisition into get_dquot()
Date:   Mon, 12 Sep 2022 16:32:36 +0200
Message-Id: <20220912143240.31574-1-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220912142823.30865-1-aalbersh@redhat.com>
References: <20220912142823.30865-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Both report_mount() and dump_file() have identical code to get quota
information. This could be used for further separation of the
functions.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 quota/report.c | 49 +++++++++++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/quota/report.c b/quota/report.c
index 2eb5b5a9..6994cba6 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -59,16 +59,15 @@ report_help(void)
 "\n"));
 }
 
-static int 
-dump_file(
-	FILE		*fp,
+static int
+get_dquot(
+	struct fs_disk_quota *d,
 	uint		id,
 	uint		*oid,
 	uint		type,
 	char		*dev,
 	int		flags)
 {
-	fs_disk_quota_t	d;
 	int		cmd;
 
 	if (flags & GETNEXTQUOTA_FLAG)
@@ -77,7 +76,7 @@ dump_file(
 		cmd = XFS_GETQUOTA;
 
 	/* Fall back silently if XFS_GETNEXTQUOTA fails, warn on XFS_GETQUOTA */
-	if (xfsquotactl(cmd, dev, type, id, (void *)&d) < 0) {
+	if (xfsquotactl(cmd, dev, type, id, (void *)d) < 0) {
 		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH &&
 		    cmd == XFS_GETQUOTA)
 			perror("XFS_GETQUOTA");
@@ -85,12 +84,29 @@ dump_file(
 	}
 
 	if (oid) {
-		*oid = d.d_id;
+		*oid = d->d_id;
 		/* Did kernelspace wrap? */
 		if (*oid < id)
 			return 0;
 	}
 
+	return 1;
+}
+
+static int
+dump_file(
+	FILE		*fp,
+	uint		id,
+	uint		*oid,
+	uint		type,
+	char		*dev,
+	int		flags)
+{
+	struct fs_disk_quota d;
+
+	if (!get_dquot(&d, id, oid, type, dev, flags))
+		return 0;
+
 	if (!d.d_blk_softlimit && !d.d_blk_hardlimit &&
 	    !d.d_ino_softlimit && !d.d_ino_hardlimit &&
 	    !d.d_rtb_softlimit && !d.d_rtb_hardlimit)
@@ -329,31 +345,12 @@ report_mount(
 {
 	fs_disk_quota_t	d;
 	time64_t	timer;
-	char		*dev = mount->fs_name;
 	char		c[8], h[8], s[8];
 	uint		qflags;
 	int		count;
-	int		cmd;
 
-	if (flags & GETNEXTQUOTA_FLAG)
-		cmd = XFS_GETNEXTQUOTA;
-	else
-		cmd = XFS_GETQUOTA;
-
-	/* Fall back silently if XFS_GETNEXTQUOTA fails, warn on XFS_GETQUOTA*/
-	if (xfsquotactl(cmd, dev, type, id, (void *)&d) < 0) {
-		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH &&
-		    cmd == XFS_GETQUOTA)
-			perror("XFS_GETQUOTA");
+	if (!get_dquot(&d, id, oid, type, mount->fs_name, flags))
 		return 0;
-	}
-
-	if (oid) {
-		*oid = d.d_id;
-		/* Did kernelspace wrap? */
-		if (* oid < id)
-			return 0;
-	}
 
 	if (flags & TERSE_FLAG) {
 		count = 0;
-- 
2.27.0

