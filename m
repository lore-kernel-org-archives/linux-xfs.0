Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3779FC433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Apr 2022 23:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241936AbiDDXSD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Apr 2022 19:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242361AbiDDXRt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Apr 2022 19:17:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9FF1EAE6F
        for <linux-xfs@vger.kernel.org>; Mon,  4 Apr 2022 16:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649113715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VINO85focsV5N5Bc+IlPM1cKcyyYcY/+6j4BOLtecYA=;
        b=Ba9/G4AuI4rQsugS7/JgcS0amna/3t31l7m+QrRMYSQLkXudZhl25dInAnlMw0KzukNHxg
        rfOuothjX33MaEEWH45fTpyqEmEiF1zyaht7vyFVVD1t76I5lpelMGdPWsKkdDOP1a9o//
        SNWtsqXSGmoDn/JVfJ7gGagbjSrwT58=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-183-ZS-J0fOLMEGMMEYkImLUNA-1; Mon, 04 Apr 2022 19:08:31 -0400
X-MC-Unique: ZS-J0fOLMEGMMEYkImLUNA-1
Received: by mail-il1-f197.google.com with SMTP id y8-20020a056e020f4800b002ca498c9655so1956333ilj.20
        for <linux-xfs@vger.kernel.org>; Mon, 04 Apr 2022 16:08:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :content-language:to:cc:subject:content-transfer-encoding;
        bh=VINO85focsV5N5Bc+IlPM1cKcyyYcY/+6j4BOLtecYA=;
        b=hNq5G42s12Zj9jndm41PQ6xLMsc66vYhvgetPfKqJZN3eU0yuNE8usNi3Etf2INPPn
         AeeN4IKcNopASQlcgmwWE3CwXupNOCZ/HDKmhnIuDIeZy2kaVXjiWxkQX+9llfTEaBLE
         RN5yc98un2qh7PTk7UA7JXY2Oft38WHchOw6Pc9eZx3AqsCxgHMgihwiCtDUR5s8Aunb
         majB9Cuy6mp17Iv1uTmAU+IJNK7q3Yx7FSWG11sUkD/SfuuaPFGENwKoesm5I727mIBc
         1wvlCmwimqgCp7K+yNk+yuSi+CGSXw/zsootKNGc6h6hZgAyzi6h4VKTB3XlHRpzJ9Yq
         KIOw==
X-Gm-Message-State: AOAM532mobZe9pdC/qIrIEPjV+x0F1rMp6Bj6voPZ99uzVkyqF6THPZX
        7G0O1+0bk7EqCoKANrMPrP7QCYOrp6OxbeQS5kOUjtr9x7spHxDJ2Ux3grK41fBcnSHo+Ixj2XE
        VX9WLG5aps37WX6y+ggxamvm8mqp911io+7y6+PjpsOTZEcd/b4yg74V5NJq/Bue3zZCUu1Ja
X-Received: by 2002:a05:6638:3588:b0:323:bf36:4624 with SMTP id v8-20020a056638358800b00323bf364624mr404309jal.8.1649113710014;
        Mon, 04 Apr 2022 16:08:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKJeQgqyIRgLppJIt+fUTg9JzCHkVXijmqiGzmLDElDsMbrzd2vRdFZik9m6/WaG+g0Vpoyg==
X-Received: by 2002:a05:6638:3588:b0:323:bf36:4624 with SMTP id v8-20020a056638358800b00323bf364624mr404293jal.8.1649113709615;
        Mon, 04 Apr 2022 16:08:29 -0700 (PDT)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id s5-20020a056602168500b0064c82210ce4sm7407329iow.13.2022.04.04.16.08.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Apr 2022 16:08:29 -0700 (PDT)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <a8bc42f2-98db-2f16-2879-9ed62415ba01@redhat.com>
Date:   Mon, 4 Apr 2022 18:08:28 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH V2] mkfs: increase the minimum log size to 64MB when possible
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Recently, the upstream maintainers have been taking a lot of heat on
account of writer threads encountering high latency when asking for log
grant space when the log is small.  The reported use case is a heavily
threaded indexing product logging trace information to a filesystem
ranging in size between 20 and 250GB.  The meetings that result from the
complaints about latency and stall warnings in dmesg both from this use
case and also a large well known cloud product are now consuming 25% of
the maintainer's weekly time and have been for months.

For small filesystems, the log is small by default because we have
defaulted to a ratio of 1:2048 (or even less).  For grown filesystems,
this is even worse, because big filesystems generate big metadata.
However, the log size is still insufficient even if it is formatted at
the larger size.

On a 220GB filesystem, the 99.95% latencies observed with a 200-writer
file synchronous append workload running on a 44-AG filesystem (with 44
CPUs) spread across 4 hard disks showed:

	99.5%
Log(MB)	Latency(ms)	BW (MB/s)	xlog_grant_head_wait
10	520		243		1875
20	220		308		540
40	140		360		6
80	92		363		0
160	86		364		0

For 4 NVME, the results were:

10	201		409		898
20	177		488		144
40	122		550		0
80	120		549		0
160	121		545		0

This shows pretty clearly that we could reduce the amount of time that
threads spend waiting on the XFS log by increasing the log size to at
least 40MB regardless of size.  We then repeated the benchmark with a
cloud system and an old machine to see if there were any ill effects on
less stable hardware.

For cloudy iscsi block storage, the results were:

10	390		176		2584
20	173		186		357
40	37		187		0
80	40		183		0
160	37		183		0

A decade-old machine w/ 24 CPUs and a giant spinning disk RAID6 array
produced this:

10	55		5.4		0
20	40		5.9		0
40	62		5.7		0
80	66		5.7		0
160	25		5.4		0

From the first three scenarios, it is clear that there are gains to be
had by sizing the log somewhere between 40 and 80MB -- the long tail
latency drops quite a bit, and programs are no longer blocking on the
log's transaction space grant heads.  Split the difference and set the
log size floor to 64MB.

Inspired-by: Darrick J. Wong <djwong@kernel.org>
Commit-log-stolen-from: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

This is reworked, with dependencies on other patches removed; details in
followup emails.

diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
index a16a9fe2..ef4443b0 100644
--- a/include/xfs_multidisk.h
+++ b/include/xfs_multidisk.h
@@ -17,8 +17,6 @@
 #define	XFS_MIN_INODE_PERBLOCK	2		/* min inodes per block */
 #define	XFS_DFL_IMAXIMUM_PCT	25		/* max % of space for inodes */
 #define	XFS_MIN_REC_DIRSIZE	12		/* 4096 byte dirblocks (V2) */
-#define	XFS_DFL_LOG_FACTOR	5		/* default log size, factor */
-						/* with max trans reservation */
 #define XFS_MAX_INODE_SIG_BITS	32		/* most significant bits in an
 						 * inode number that we'll
 						 * accept w/o warnings
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 96682f9a..e36c1083 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -18,6 +18,14 @@
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
 #define MEGABYTES(count, blog)	((uint64_t)(count) << (20 - (blog)))
 
+/*
+ * Realistically, the log should never be smaller than 64MB.  Studies by the
+ * kernel maintainer in early 2022 have shown a dramatic reduction in long tail
+ * latency of the xlog grant head waitqueue when running a heavy metadata
+ * update workload when the log size is at least 64MB.
+ */
+#define XFS_MIN_REALISTIC_LOG_BLOCKS(blog)	(MEGABYTES(64, (blog)))
+
 /*
  * Use this macro before we have superblock and mount structure to
  * convert from basic blocks to filesystem blocks.
@@ -3266,7 +3274,7 @@ calculate_log_size(
 	struct xfs_mount	*mp)
 {
 	struct xfs_sb		*sbp = &mp->m_sb;
-	int			min_logblocks;
+	int			min_logblocks;	/* absolute minimum */
 	struct xfs_mount	mount;
 
 	/* we need a temporary mount to calculate the minimum log size. */
@@ -3308,28 +3316,17 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
 
 	/* internal log - if no size specified, calculate automatically */
 	if (!cfg->logblocks) {
-		if (cfg->dblocks < GIGABYTES(1, cfg->blocklog)) {
-			/* tiny filesystems get minimum sized logs. */
-			cfg->logblocks = min_logblocks;
-		} else if (cfg->dblocks < GIGABYTES(16, cfg->blocklog)) {
+		/* Use a 2048:1 fs:log ratio for most filesystems */
+		cfg->logblocks = (cfg->dblocks << cfg->blocklog) / 2048;
+		cfg->logblocks = cfg->logblocks >> cfg->blocklog;
 
-			/*
-			 * For small filesystems, we want to use the
-			 * XFS_MIN_LOG_BYTES for filesystems smaller than 16G if
-			 * at all possible, ramping up to 128MB at 256GB.
-			 */
-			cfg->logblocks = min(XFS_MIN_LOG_BYTES >> cfg->blocklog,
-					min_logblocks * XFS_DFL_LOG_FACTOR);
-		} else {
-			/*
-			 * With a 2GB max log size, default to maximum size
-			 * at 4TB. This keeps the same ratio from the older
-			 * max log size of 128M at 256GB fs size. IOWs,
-			 * the ratio of fs size to log size is 2048:1.
-			 */
-			cfg->logblocks = (cfg->dblocks << cfg->blocklog) / 2048;
-			cfg->logblocks = cfg->logblocks >> cfg->blocklog;
-		}
+		/* But don't go below a reasonable size */
+		cfg->logblocks = max(cfg->logblocks,
+				XFS_MIN_REALISTIC_LOG_BLOCKS(cfg->blocklog));
+
+		/* And for a tiny filesystem, use the absolute minimum size */
+		if (cfg->dblocks < MEGABYTES(512, cfg->blocklog))
+			cfg->logblocks = min_logblocks;
 
 		/* Ensure the chosen size meets minimum log size requirements */
 		cfg->logblocks = max(min_logblocks, cfg->logblocks);

