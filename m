Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CC018754D
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560523; cv=none; b=m8unn4gD8bBYkxNY2aljmMD86GeJMnRj1aulY73tLn/3ojKsLjkfvXan7t/a61fYKb1uBcwkM+orGOe6gCDoyseASijYFDhajrHQCAjcqlirFE4PZTGGAN/tpIk+OYdVH8Q2p01Ul3B9GQRBnr4PUWYMKZJmw9O2xpZa4OrG+Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560523; c=relaxed/simple;
	bh=ex+Z0N7afk0rOd6e7S5yztxz371+3w1tO7GgrvQk9Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxVRh3DfbjE/BtflkT66bKGr46ulBgbAWFhgi8C725lQTUW/t+2hTshF7OjKASTq85sE/QpcM4cdlDHMbhg18271xGnfYkhD6YpdUXv9912FnLo9YKkEzb7cXsRdPKZloGxmBiIUYZWUEUCjHoiLDDarMlboOaRhl1sS7Co+Cwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SEj51Wcb; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SEj51Wcb"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-7d50e865b7aso549019a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560521; x=1726165321; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hZU7Bfd5lbjk+/RmdOLvGCY4sbjakLLt4Vz3JSDRaUc=;
        b=SEj51WcbdgPyz8Q8Q0Bfx9TdGxMgmyG07KTAy08dWgPMl/MB7FxII/XD2fSe3i90qK
         dc0b7U8yavRxJhZRFzAG45v0JHQPgQStSt5NN0ott5YIUw9vqJZk0xN7BEE4fqyuOsWe
         pRfOXTThi008rw1edSJTHRSCcXD9AiwHANWS2n4QJdCZF2stnoRKcSctn/1do8upC6OA
         NH/km6fxUEOZ2pVsWTXmygm9MlOxdIJNd5kfObZf3GQE6RJv75ZPtx/574HC2cOosTbR
         QDvWwykxqP5Pb+JftGzcHHs61xpOSJAh4+KnGdGYQCGqrnAnvk4wPJN4HzpFvwgku7wX
         RLJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560521; x=1726165321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hZU7Bfd5lbjk+/RmdOLvGCY4sbjakLLt4Vz3JSDRaUc=;
        b=SqtQPJPC/kP5oXiZ0W8+OKG64i9kkDUPpA3VOI++eGwVrCgJ5nLEzITt53GzvTXLC0
         679JXgV/B/6jYEDBFZYylZJ8DSJxvNvf2kMFIk9qBT6Hkv/6nbf76HjixvWVo0w+xrK6
         2kYvj9+yxbCA1uxpIxblBG4M2nJuR1KtlIFVbUgWyEk6U4jXqwWMIJAH4Tvz0e9QCbkQ
         HUsOdB/DcEzrq82F9FNfFtp8xcrSmgSVsOdVZVLF8LnC9mlth+z7XSYOkY/+2DUkYxgt
         316LJ2wX1t6C6m0elMguQaKB5MWaIkeV1MoRLgxXk6o4tqEY3b9RtKGvXS+qRwczCdbi
         HLqQ==
X-Gm-Message-State: AOJu0Yx3nk8LIxOLlq4EVUVfwWVvmgPETvX6VCL/hp25CcdxK18H9Wr5
	+s46o1wrkB7Mf6nggDu+d6uAM2xSbnbxtaSFETIqo+eL0jPMvpGfV9Enwm23
X-Google-Smtp-Source: AGHT+IHRpFiZVEo7/K7PgHPQrfJ5NsN0ylYQoOjTFWcy608rBctTB3D9jbsBOaY5j+ZCMyITx+wXZQ==
X-Received: by 2002:a17:902:e804:b0:202:4b65:65af with SMTP id d9443c01a7336-20546b35a4cmr232258135ad.52.1725560520735;
        Thu, 05 Sep 2024 11:22:00 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:22:00 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	Dave Chinner <dchinner@redhat.com>,
	Pengfei Xu <pengfei.xu@intel.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 09/26] xfs: quotacheck failure can race with background inode inactivation
Date: Thu,  5 Sep 2024 11:21:26 -0700
Message-ID: <20240905182144.2691920-10-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905182144.2691920-1-leah.rumancik@gmail.com>
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 0c7273e494dd5121e20e160cb2f047a593ee14a8 ]

The background inode inactivation can attached dquots to inodes, but
this can race with a foreground quotacheck failure that leads to
disabling quotas and freeing the mp->m_quotainfo structure. The
background inode inactivation then tries to allocate a quota, tries
to dereference mp->m_quotainfo, and crashes like so:

XFS (loop1): Quotacheck: Unsuccessful (Error -5): Disabling quotas.
xfs filesystem being mounted at /root/syzkaller.qCVHXV/0/file0 supports timestamps until 2038 (0x7fffffff)
BUG: kernel NULL pointer dereference, address: 00000000000002a8
....
CPU: 0 PID: 161 Comm: kworker/0:4 Not tainted 6.2.0-c9c3395d5e3d #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
Workqueue: xfs-inodegc/loop1 xfs_inodegc_worker
RIP: 0010:xfs_dquot_alloc+0x95/0x1e0
....
Call Trace:
 <TASK>
 xfs_qm_dqread+0x46/0x440
 xfs_qm_dqget_inode+0x154/0x500
 xfs_qm_dqattach_one+0x142/0x3c0
 xfs_qm_dqattach_locked+0x14a/0x170
 xfs_qm_dqattach+0x52/0x80
 xfs_inactive+0x186/0x340
 xfs_inodegc_worker+0xd3/0x430
 process_one_work+0x3b1/0x960
 worker_thread+0x52/0x660
 kthread+0x161/0x1a0
 ret_from_fork+0x29/0x50
 </TASK>
....

Prevent this race by flushing all the queued background inode
inactivations pending before purging all the cached dquots when
quotacheck fails.

Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_qm.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ff53d40a2dae..f51960d7dcbd 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1321,15 +1321,14 @@ xfs_qm_quotacheck(
 
 	error = xfs_iwalk_threaded(mp, 0, 0, xfs_qm_dqusage_adjust, 0, true,
 			NULL);
-	if (error) {
-		/*
-		 * The inode walk may have partially populated the dquot
-		 * caches.  We must purge them before disabling quota and
-		 * tearing down the quotainfo, or else the dquots will leak.
-		 */
-		xfs_qm_dqpurge_all(mp);
-		goto error_return;
-	}
+
+	/*
+	 * On error, the inode walk may have partially populated the dquot
+	 * caches.  We must purge them before disabling quota and tearing down
+	 * the quotainfo, or else the dquots will leak.
+	 */
+	if (error)
+		goto error_purge;
 
 	/*
 	 * We've made all the changes that we need to make incore.  Flush them
@@ -1363,10 +1362,8 @@ xfs_qm_quotacheck(
 	 * and turn quotaoff. The dquots won't be attached to any of the inodes
 	 * at this point (because we intentionally didn't in dqget_noattach).
 	 */
-	if (error) {
-		xfs_qm_dqpurge_all(mp);
-		goto error_return;
-	}
+	if (error)
+		goto error_purge;
 
 	/*
 	 * If one type of quotas is off, then it will lose its
@@ -1376,7 +1373,7 @@ xfs_qm_quotacheck(
 	mp->m_qflags &= ~XFS_ALL_QUOTA_CHKD;
 	mp->m_qflags |= flags;
 
- error_return:
+error_return:
 	xfs_buf_delwri_cancel(&buffer_list);
 
 	if (error) {
@@ -1395,6 +1392,21 @@ xfs_qm_quotacheck(
 	} else
 		xfs_notice(mp, "Quotacheck: Done.");
 	return error;
+
+error_purge:
+	/*
+	 * On error, we may have inodes queued for inactivation. This may try
+	 * to attach dquots to the inode before running cleanup operations on
+	 * the inode and this can race with the xfs_qm_destroy_quotainfo() call
+	 * below that frees mp->m_quotainfo. To avoid this race, flush all the
+	 * pending inodegc operations before we purge the dquots from memory,
+	 * ensuring that background inactivation is idle whilst we turn off
+	 * quotas.
+	 */
+	xfs_inodegc_flush(mp);
+	xfs_qm_dqpurge_all(mp);
+	goto error_return;
+
 }
 
 /*
-- 
2.46.0.598.g6f2099f65c-goog

