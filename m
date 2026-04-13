Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6986D46B5
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 00:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776041407; cv=none; b=XFZEsytIJzEIiHBt0zl0p6hj0nZeK6Ji0zXBB9ZlyG6CWJHkXkK2vq1Cee0mOlttryQAhJ3FfhswLHOGhu52iQ81K+/niK7kudgNAkbbZD4dDMtF+vZOzw4iQZoLAvEUZNR7ThWCE/cVUl3gweJ8e4BUTSAbGmAPOluJBLlWW9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776041407; c=relaxed/simple;
	bh=moH/FhTu87BhDmsNeejoeAXde8Y7UsMAmP5wlb4u8qc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lrzwSLg9vFXxhUIAsiP+dV0VQY92VSPhFjyQyB5DlWd0h93S2wIgY6qpSGY6sRpWQcv7m33JtWI/m6VTH+/uKrBNYfqssDb4pVhm2VJ71gfp6mlkJ7obJ/mOW3u/hYzdcW7YIESrvnoFSVv2VjD+g3h1dzPnbVBKFDEsqICimxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AZOI2NiW; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AZOI2NiW"
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-56f6afbd205so53605e0c.0
        for <linux-xfs@vger.kernel.org>; Sun, 12 Apr 2026 17:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776041405; x=1776646205; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=k1PKW8bdPT8ttTA8fucfaUlnFMI6KsFgwTJyGwNaGxc=;
        b=AZOI2NiW8sEAF+nrWOf54crPnF1baCUGg2pyJURsBC7DdlUyLy2y0oC9qPOmW63CNa
         hiHplyRJgPjao5L9sotkM+VycjcowNXjxNqu2xNMO3GNm5ScbK+misdJmwHyTABKvyVz
         nG+44lyCYrYTOe41Bq6NO2ihx1yeWoZ9AcKn5cHZl22FicfDcVtdCMEfrnjPPjMrgpN0
         Lf26XKb1VR2PUgnpFB0p5pbCJsqDB+hgX2gERYNCK+YYM/44lYDac3w43PvPkd7TL4a3
         bHSSQBZsQcUZR3jj1rmw6dAaUFkhdYJPUCYkCIcV4PxQINU//1c0tUqt0duCfSl6cmwz
         eE0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776041405; x=1776646205;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1PKW8bdPT8ttTA8fucfaUlnFMI6KsFgwTJyGwNaGxc=;
        b=h7eACe9TpSSI0LtgG4H2g61qwGz7S8wKtz0HSCQpUuIs5VXUmbN3m33C5eJfKAEBVD
         jlQ6dZn6GhxBVHoUQiKoY0X0+0UMRle+hi9rR0O7s7RWIpApjrsHfr4Llegql7gLIKGK
         tdl+3vpqatVdvHhO30DGAs1+Dj+mjcSVNVpILFfGpaql4z0CHh7iNSQWAN1siNYamBcC
         MKWAoGjTzCmVqOuxRsjuKZzSALGBnbfoZ5yIgwzpaNiTbtvFGnTnln8vUh3L2Yuwf29v
         jL0wqzzV81xGged0kAK7Lnuu3LqGCQOI0iiWERaDIxm7M/cRuPO8YVXAsMT3kiIv1ng7
         Ye8g==
X-Gm-Message-State: AOJu0YxR7YksErLw2RmFav+2woQCxR1C7lrgopNbqHYMDoC8tm9rXMTe
	lkVIxqEFb/Mywo6EP3jzTvxEZRRdazvvN9HzsXijw2jbw9q0kL9P9AJN
X-Gm-Gg: AeBDieuy3Y8um+b/TwjQsMDsNx2wv6Uhp3W/uWBVrZyzmIGuK+lmWsJbXUjtbfWIoZO
	oVGiPEVkRcUUUqqwViOA4zBbLmmh1OFU90Esj0ooABMFTEBKIjEhfoRhXR2busPC/UaZ7SnjW+J
	D4YbAuFX8MLw1E6mQr/tJJ8a5hMfkBT8mYTLWGJ7Au77lrl4kGBE/ccTu+d/CXu0dhNOET5XUcl
	k33TWmrLpin7ukYLiUTWhsdd0spefEFTImWZF5pt7zkWSlY0v2Zq8DLNOVfGEyGXbtVlbZgOiQb
	cbKlVulk+cL54u9TXMxpD1hPvDnhzlSpaomJBE0d5NBEAOZb8wOQ16fU9/sMtYYqokjrzKqCMey
	iKX6n7rWkCEbGDG4xVNKcqp5CaNg9+1J8a9LRJzNOGRzzh9Mgp8j421nqS70/G1nnmw9IXIpSU5
	sJO9jw6rklEzZvEgHTKPTd0ImvmvEuN7XptDwIkUMi4PFmcrT8rKZKDTbjp+SUuU1zsrqtaQ==
X-Received: by 2002:a05:6122:d19:b0:559:6788:7b55 with SMTP id 71dfb90a1353d-56f59038c7dmr1317195e0c.3.1776041405331;
        Sun, 12 Apr 2026 17:50:05 -0700 (PDT)
Received: from ryzoh.168.0.127 ([2804:14c:5fc8:80a3:83c5:f43c:3db5:fcde])
        by smtp.googlemail.com with ESMTPSA id 71dfb90a1353d-56f3b9b003asm6042657e0c.16.2026.04.12.17.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 17:50:05 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH] xfs: start inodegc after quota initialization
Date: Sun, 12 Apr 2026 21:49:25 -0300
Message-ID: <20260413004925.84518-1-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When mounting a xfs filesystem with quotas, if an error occurs in xfs_mount
after calling xfs_inodegc_start and before m_quotainfo initialization, the
error path will call xfs_inodegc_flush assuming that m_quotainfo was already
initialized, causing the following error:

[   82.411853][   T23] ==================================================================
[   82.412678][   T23] BUG: KASAN: null-ptr-deref in mutex_lock (./include/linux/instrumented.h:55 ./include/linux/atomic/atomic-instrumented.h:4457 kernel/locking/mutex.c:159 kernel/locking/mutex.c:289)
[   82.413383][   T23] Write of size 8 at addr 0000000000000030 by task kworker/1:0/23
[   82.414187][   T23]
[   82.414450][   T23] CPU: 1 UID: 0 PID: 23 Comm: kworker/1:0 Not tainted 7.0.0-rc5-00051-gbbeb83d3182a #35 PREEMPT(
[   82.414458][   T23] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
[   82.414463][   T23] Workqueue: xfs-inodegc/loop0 xfs_inodegc_worker
[   82.414478][   T23] Call Trace:
[   82.414481][   T23]  <TASK>
[   82.414484][   T23]  dump_stack_lvl (lib/dump_stack.c:122)
[   82.414494][   T23]  print_report (mm/kasan/report.c:487)
[   82.414518][   T23]  kasan_report (mm/kasan/report.c:597)
[   82.414541][   T23]  kasan_check_range (mm/kasan/generic.c:? mm/kasan/generic.c:200)
[   82.414549][   T23]  mutex_lock (./include/linux/instrumented.h:55 ./include/linux/atomic/atomic-instrumented.h:4457 kernel/locking/mutex.c:159 kernel/locking/mutex.c:289)
[   82.414601][   T23]  xfs_qm_dqget_cache_lookup (fs/xfs/xfs_dquot.c:813)
[   82.414609][   T23]  xfs_qm_dqget_inode (fs/xfs/xfs_dquot.c:1017)
[   82.414678][   T23]  xfs_qm_dqattach_locked (fs/xfs/xfs_qm.c:331)
[   82.414688][   T23]  xfs_qm_dqattach (fs/xfs/xfs_qm.c:371)
[   82.414696][   T23]  xfs_inactive (fs/xfs/xfs_inode.c:1453)
[   82.414733][   T23]  xfs_inodegc_worker (fs/xfs/xfs_icache.c:1946 fs/xfs/xfs_icache.c:1992)
[   82.414743][   T23]  process_scheduled_works (kernel/workqueue.c:3281 kernel/workqueue.c:3359)
[   82.414755][   T23]  worker_thread (kernel/workqueue.c:?)
[   82.414775][   T23]  kthread (kernel/kthread.c:437)
[   82.414787][   T23]  ret_from_fork (arch/x86/kernel/process.c:164)
[   82.414822][   T23]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
[   82.414834][   T23]  </TASK>

To avoid this, call xfs_inodegc_start after quota initialization.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Closes: https://lore.kernel.org/all/DDC07F0C-05D2-46B4-9815-E010749FB3DC@gmail.com/
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 fs/xfs/xfs_mount.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ef1ea8a1238c..d6f75ab41337 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1057,7 +1057,6 @@ xfs_mountfs(
 		xfs_clear_using_logged_xattrs(mp);
 
 	/* Enable background inode inactivation workers. */
-	xfs_inodegc_start(mp);
 	xfs_blockgc_start(mp);
 
 	if (xfs_has_metadir(mp)) {
@@ -1143,6 +1142,8 @@ xfs_mountfs(
 		}
 	}
 
+	xfs_inodegc_start(mp);
+
 	/*
 	 * Finish recovering the file system.  This part needed to be delayed
 	 * until after the root and real-time bitmap inodes were consistently
-- 
2.47.3

