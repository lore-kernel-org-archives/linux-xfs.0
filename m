Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C996C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 23:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344631AbiCOXZA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 19:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352569AbiCOXYz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 19:24:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5731EB12
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 16:23:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 097F9B8190D
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 23:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7AC6C340ED;
        Tue, 15 Mar 2022 23:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647386619;
        bh=fizv68vb1e0pZfh0whY41T0EmaYDuy578pw+OLPyZzc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=I6U5+pjWwIDYrf1zZgYJsD4vsTzPdJaZKhkgVBslwpvWRXCLvJ7OJE7ZInL4Qxqup
         4b65s8kawUVSVfsu2UdoKcxOakWFRo4fgvJ2S7pIdC+BMMngJ2+fp+nnn5s5FVdICk
         ipzs64SbJVz0iiBigtlLHYF865TF88cXVkw1xlVgiHFIgKOjMqsW89ATZMEvA4cDb6
         qOSbSTe+cnYz5n2Z6dfO8JuQxHw6EabRr5ya3qVfms8J5XlrCkqF9EGmbw/tdGG8d4
         3VV5sFw4GLfueA0CnxokkWiB2i7+4OyT6D1xx2KiOElSXP2sRTGgirxxjTGclgQ8q4
         O+vOZ+UZfEdgQ==
Subject: [PATCH 3/5] mkfs: increase the minimum log size to 64MB when possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Tue, 15 Mar 2022 16:23:39 -0700
Message-ID: <164738661924.3191861.13544747266285023363.stgit@magnolia>
In-Reply-To: <164738660248.3191861.2400129607830047696.stgit@magnolia>
References: <164738660248.3191861.2400129607830047696.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index ad776492..84dbb799 100644
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
@@ -3259,6 +3267,28 @@ validate_log_size(uint64_t logblocks, int blocklog, int min_logblocks)
 	}
 }
 
+/*
+ * Ensure that the log is large enough to provide reasonable performance on a
+ * modern system.
+ */
+static void
+calc_realistic_log_size(
+	struct mkfs_params	*cfg)
+{
+	unsigned int		realistic_log_blocks;
+
+	realistic_log_blocks = XFS_MIN_REALISTIC_LOG_BLOCKS(cfg->blocklog);
+
+	/*
+	 * If the "realistic" size is more than 7/8 of the AG, this is a tiny
+	 * filesystem and we don't care.
+	 */
+	if (realistic_log_blocks > (cfg->agsize * 7 / 8))
+		return;
+
+	cfg->logblocks = max(cfg->logblocks, realistic_log_blocks);
+}
+
 static void
 clamp_internal_log_size(
 	struct mkfs_params	*cfg,
@@ -3362,6 +3392,8 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
 			cfg->logblocks = cfg->logblocks >> cfg->blocklog;
 		}
 
+		calc_realistic_log_size(cfg);
+
 		clamp_internal_log_size(cfg, mp, min_logblocks);
 
 		validate_log_size(cfg->logblocks, cfg->blocklog, min_logblocks);

