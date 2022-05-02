Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB2CC433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  2 May 2022 15:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241330AbiEBPHG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 May 2022 11:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235195AbiEBPHG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 May 2022 11:07:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6801410FFC
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 08:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651503816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5n9LB+TgutgWaIDwPqNAtAcvVuSlBy1Wq3hDaWCM2k0=;
        b=LggJjnGtZH1f7hLbIPVq+ZO5+Bv1eL+3O6CzIaOWKEvW2y+WLNQBV+4mj9PS/6E04Ul9sD
        M3yn5HxDcpGRNqyeLAVq6tYKc2GLEqGCoVw8FYW/2+WlG8lz7oJ8C6fBPjPanE2UpJe6Cp
        JwRjZaQULH1VADkIWzk1X2Em1kbrCNM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-qeJmO7zWMFeJce1t9q6Kcg-1; Mon, 02 May 2022 11:03:27 -0400
X-MC-Unique: qeJmO7zWMFeJce1t9q6Kcg-1
Received: by mail-wm1-f69.google.com with SMTP id i131-20020a1c3b89000000b00393fbb0718bso8941638wma.0
        for <linux-xfs@vger.kernel.org>; Mon, 02 May 2022 08:03:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5n9LB+TgutgWaIDwPqNAtAcvVuSlBy1Wq3hDaWCM2k0=;
        b=x0s2H1ipqkfCqtB6WTBz33umU59s6h/Q5sq/4SDf2l6pbe43M6GUo5yvZpBoJSAIP6
         Q6anPbie8qNF9c2XcnDSVriNCqUXw4oBxJ1ZIxWg9DyF8m31Szsvxl5GnbIdeBGJv0fN
         e3gkdRIlflS+lsq0YTtAkVk1jXx+v4ul8oGE0hZ6wQc/YJX2wGQCqwHOrUOGScCP9yUW
         uEL1e+TBqb7sIr9cmXtZ+EaiJJFBKlm5ZlK7OmzujT07+tcrUkt/26zoxZLLXidJwtpm
         kSmMmVGjFtr/+aiWGsTe3nES2upRzNKASiYdmGVx8n6lZdEjkxfVJ+3n0i4x/rOMZiZu
         lhbQ==
X-Gm-Message-State: AOAM531hLjy06mFN4q6bbVvOIUsHcispLReeBCVYSPCRFVIjU69XoPMY
        RFwFD4oNUncQd83B9EU5/XjUFkvfvM2SxINHnrwM7/GGhTdu4WZSeFhNgCj0kOYaRG7Md5xSmLT
        u8O00YeEQbQgnQpEiog9LFuxQuHAcmRz9NDy+1xPtbrpPKpkGnlMCz4zxYaMQOBu3icOIGuQ=
X-Received: by 2002:adf:e108:0:b0:1ef:97ad:5372 with SMTP id t8-20020adfe108000000b001ef97ad5372mr9349826wrz.658.1651503806468;
        Mon, 02 May 2022 08:03:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5LHatRCugAiWXj2LyF33Tveun1K/7kzW3tBip/VL3S2vpVeNqc5H8RuLqrApIYsw3S2mZrw==
X-Received: by 2002:adf:e108:0:b0:1ef:97ad:5372 with SMTP id t8-20020adfe108000000b001ef97ad5372mr9349812wrz.658.1651503806184;
        Mon, 02 May 2022 08:03:26 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id m6-20020a05600c3b0600b0039429bfebeasm198794wms.2.2022.05.02.08.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 08:03:25 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v3 1/5] xfs_quota: separate quota info acquisition into get_dquot()
Date:   Mon,  2 May 2022 17:02:05 +0200
Message-Id: <20220502150207.117112-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220502150207.117112-1-aalbersh@redhat.com>
References: <20220502150207.117112-1-aalbersh@redhat.com>
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

