Received: from mail-pj1-f65.google.com (mail-pj1-f65.google.com [209.85.216.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD55078F26
	for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 05:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779946562; cv=none; b=MDklQze7J/IQrlaSQW1MvsLjOn0zucawBPAS7N6Jwi7/Xe45SJe+q1m6y7vTz5GIhPz7JjrvS4oftCeRH1PM9H9nEYXf/8CmtkElJ5Euh2ixa8CzNrHmT/QKSHMvUO23kl7kZGeqvm/+bg2KjN8BLpKzE2q5cS224ahkVWOlRTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779946562; c=relaxed/simple;
	bh=PmMBSSQOwrY3wTAPMf/51qrLvIqEO7uPriuBMkyldYY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mHngW6+9j5a0I/5WgUiuytZt5/Iex0dLAhosKELTsqfwUeCFeTTQkSjeMhjXVt1xHG345JFF8ljWyfgfsPBUtWZg2o6H1F0W8tMgdm1PcNcp+Lvtoa6Nf9fhvz7FJcYs/pO9TABKfRnrS/WRijUu1Z7uha0u6IaO92GY2v8XXuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BFlXWRDc; arc=none smtp.client-ip=209.85.216.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BFlXWRDc"
Received: by mail-pj1-f65.google.com with SMTP id 98e67ed59e1d1-36ab8816a35so2612459a91.1
        for <linux-xfs@vger.kernel.org>; Wed, 27 May 2026 22:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779946559; x=1780551359; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jEcLv72SgXWCsu9Ow9ZF5fDTMQLKci6Ciiyqk71jcRE=;
        b=BFlXWRDcwDIKAcVVCwra6Vmt32P2MClVIDvC5zJfmnq7kCGWBvrRCgA4b1tOBzasCG
         TuujjjAP203qHQYvrmCK04/JbGhWUeAJCtUvFtVjZna5ODdgpvzuzAQKqkZguXJ2oylH
         782c2xZobdxseFm12n6IoXghAavE09Dn6zPZniyez6I9wonCJ1R2Lb8BXsJ4xxye1OVj
         kCH4G2e92vDpTnhPxDv+pOL0MLBtIF0X84TAK/rVweXevZ/j+LpVX68//YAMBIdyosSw
         jj54Wb7SFA8k3b0G5Aran+Vya5Qwh5hRNoJevvT4kZ2ReTiUrS1bch8dM4yBe4/HhwyH
         hUYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779946559; x=1780551359;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jEcLv72SgXWCsu9Ow9ZF5fDTMQLKci6Ciiyqk71jcRE=;
        b=hJn+xu02SD0ElqhzcPislkeZriVBx0LIZySOX2dTir3qdW7gcO2QhhGqGLQR69waa5
         KOeU5abH7jJWbrG3+fZq2lzaoLwTBG5Y8hQC2nIRmwL/oTx9YS1P36hmMEGv3ia9zccY
         37N2Swu8s26mvypDpltk2tBJ3+IGNCQ7PMDFIodm00+h1VIyFssjLIYQx5itv9gTZuwA
         Cb70+sMfWeA6WZjbKLV/4lBbzzMEkFyb6zQ2Lg8GojoGQK4adVivfJUdM2l3kDrGeqNb
         3e8kyi27FQK39EpckYGnitPlFpogG+0knj4ygiVAahqRgaZ/wWIyvOPwbEE0b22gCtgE
         aBKA==
X-Gm-Message-State: AOJu0Yw+k1lqmf+Z4OZivqzGFBKr/fbynjSD2mc3ZL4kZTJYynr6I2hL
	TKzHt9PUI1Z6EpjjAb3G7i6ZK0ktzsLBjmX1081LP9oBMPVbyZGYNKkm
X-Gm-Gg: Acq92OHTX0Ehtq4tyGMqyCAPCv5FO2KCiEkt3JLyjdBsSWOOrr2687/Rxq5haHPZk2H
	VIKaxo4y6MMLU8DOW79CmmecGeliQV/XclqcwD0FteoT79CMrEwnchBTxdgCkQra4V8uj6wqSPU
	t3Bsd0GRgQ/LZoYPR/QBgw71ykPxMJ68JKRVqsXD/WcNqudNkicLZUoL35tDXNq5MQiC+ctmutH
	0oBoi2/tgZF0JS4UhtWqIrZY+x/7JDOhdYnupJRfcaS6H2BCdqoRJ4S8VjK4I9t5+C5wK0Q4Ihx
	EGe7H872mXfzJZWmtZ2Ji2xgwMJtFYfxeWqbI2WVocT4mO/uCyr0FjhAJAt9QU8ZVhWIkb//Kc6
	2+Ud0h8RVMJR49xcxGDfJI4fp0gXh9QXcEgI8IzTSAwtiyW87VdxzdA2ORxm0OtdcplVx2iPrEh
	5mcx+/JYe1myDV9sxcOfef2attp8xoiyBSWyWc/Nd4EQ==
X-Received: by 2002:a17:90b:4c50:b0:369:d704:d944 with SMTP id 98e67ed59e1d1-36a6741f011mr24463407a91.4.1779946559118;
        Wed, 27 May 2026 22:35:59 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36b7e7f99basm355720a91.3.2026.05.27.22.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 22:35:58 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH v2] xfs: drain inodegc before quota teardown on mount failure
Date: Thu, 28 May 2026 13:35:54 +0800
Message-Id: <20260528053554.3047829-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_mountfs() starts background inodegc before mount completion. If a
later setup step fails after quota setup, the failure unwind can destroy
quota state while an inodegc worker is still able to resume
xfs_inactive().

There are two related windows. First, out_agresv can still call
xfs_qm_unmount_quotas() while m_qflags allow dqattach, so dqget can
still need quota inodes that are being released. Second, failures after
xfs_qm_newmount() can destroy mp->m_quotainfo before inodegc has been
drained, while xfs_qm_dqattach() can still follow m_qflags into the
quota cache.

Normal unmount and the quotacheck abort path already drain inodegc before
quota teardown. Do the same for mount failure. Drain inodegc at out_agresv
before dropping AG reservations and quota inodes. Add an out_qm_unmount
label above out_rtunmount so failures after xfs_qm_newmount() drain
inodegc before xfs_qm_unmount() destroys quotainfo.

This was reproduced in a KASAN QEMU setup that forced a late
xfs_mountfs() failure after quota setup and widened the inodegc/dqattach
window. The failure reported a general protection fault in
xfs_qm_dqget_cache_lookup() from the inodegc worker path:

  xfs_qm_dqget_cache_lookup()
  xfs_qm_dqget_inode()
  xfs_qm_dqattach_locked()
  xfs_qm_dqattach()
  xfs_free_eofblocks()
  xfs_inactive()
  xfs_inodegc_worker()

Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
---
v2:
- Add an out_qm_unmount label above out_rtunmount, as Christoph suggested.
- Keep the out_agresv inodegc drain before xfs_qm_unmount_quotas().
- Describe the KASAN/QEMU validation setup and fix trailer spacing.

 fs/xfs/xfs_mount.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b24195f570cd8..39ce56e866060 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1156,7 +1156,7 @@ xfs_mountfs(
 	xfs_fs_unreserve_ag_blocks(mp);
 	if (error) {
 		xfs_warn(mp, "log mount finish failed");
-		goto out_rtunmount;
+		goto out_qm_unmount;
 	}
 
 	/*
@@ -1174,7 +1174,7 @@ xfs_mountfs(
 	if (xfs_has_zoned(mp)) {
 		error = xfs_mount_zones(mp);
 		if (error)
-			goto out_rtunmount;
+			goto out_qm_unmount;
 	}
 
 	/*
@@ -1228,16 +1228,29 @@ xfs_mountfs(
 	return 0;
 
  out_agresv:
+	/*
+	 * Drain ordinary inodegc before we drop per-AG reservations or tear
+	 * down quota state.  Background inactivation can still attach dquots
+	 * here, and dqget can still need the quota inodes.
+	 */
+	xfs_inodegc_flush(mp);
 	xfs_fs_unreserve_ag_blocks(mp);
 	xfs_qm_unmount_quotas(mp);
 	if (xfs_has_zoned(mp))
 		xfs_unmount_zones(mp);
+ out_qm_unmount:
+	/*
+	 * xfs_qm_newmount() can bring quota inodes into the mount.  Drain
+	 * inodegc before destroying quotainfo because background inactivation
+	 * can still attach dquots.
+	 */
+	xfs_inodegc_flush(mp);
+	/* Clean out dquots that might be in memory after quotacheck. */
+	xfs_qm_unmount(mp);
  out_rtunmount:
 	xfs_rtunmount_inodes(mp);
  out_rele_rip:
 	xfs_irele(rip);
-	/* Clean out dquots that might be in memory after quotacheck. */
-	xfs_qm_unmount(mp);
  out_free_metadir:
 	if (mp->m_metadirip)
 		xfs_irele(mp->m_metadirip);

base-commit: eb3f4b7426cfd2b79d65b7d37155480b32259a11
-- 
2.43.0
