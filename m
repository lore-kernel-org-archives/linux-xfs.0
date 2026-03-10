Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7990331A065;
	Tue, 10 Mar 2026 18:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.26.1.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773167935; cv=none; b=jhdyr72mCUI5cmNyqTgPygMfZlv4xWtBDst9fiEsiqTgKJmrwINfn80Btbxuh0ysI2OblQoGrpvYiu60uVhNHmvduZJrw72xQaOv2S2rjEoamhvIItfpA48X7lUVLENPVjZjigSb2IBj0g7XEVHMrPVFzfJ0WzvmOxWDkagGBv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773167935; c=relaxed/simple;
	bh=HeqsfeBcTBt4ArfKV32ZtW3E86s8D5Uxvo1ghrvN2zo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ACOTyln0zeIBL4S3dNRDLeDwRbIdoW1k77AJyCY1Ee0/7rXeCtkHjhKoxekqTymd5GAMqef1+Cs7/gmU/nX3hXkXuSA6PM5tp73KIrEOur6oRrymyWjOKZqkHLla4scgQCz+NLI7G8+Tj3ZD32SXsZmQSnOsWmg+8A+JrxDl58E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=Lg/wj79U; arc=none smtp.client-ip=52.26.1.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="Lg/wj79U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1773167934; x=1804703934;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JtOydYU3WqE8Z2TOBVP6syGAXK8byl5NV2hYUJzJtXk=;
  b=Lg/wj79UAHpAX+ITMKjZb/Jzsfm537R7rg2pMX2XJmsL0gox1ds0t9sk
   I/m58Ww/YaT7WnSYvfcx81smDawVXb5GP4aziC0wEydeZRWzTaIo3LedI
   Bufy7bKWrGGcHKVN41Vldps/dD6UXJGAE1h28vGnkE/8Zi0ipVM11Hb+u
   /AeSfYl5HWXC2Lg7MxrDfrruNCZ+O+tq3n3F/FruU2G0aG17l4Q4kbXWE
   qb1AU2HC8kC54aAshr3q/eqvg0dE7znbtQfW6DFPcL63VwuOKqLtPX8k3
   gS2sUIXnopB6I+7F+THyZ4Kh8evLJpL9v6ineDhoLy2O+AsC7zO8MubSM
   w==;
X-CSE-ConnectionGUID: oeo/sL4gQqWEEvSO1v0gOQ==
X-CSE-MsgGUID: bkRKWOB/QDGgDahUeXi26Q==
X-IronPort-AV: E=Sophos;i="6.23,112,1770595200"; 
   d="scan'208";a="14738389"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 18:38:50 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:3067]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.33.152:2525] with esmtp (Farcaster)
 id 08a1a1eb-2d27-4c44-9dbf-ad6240b37571; Tue, 10 Mar 2026 18:38:50 +0000 (UTC)
X-Farcaster-Flow-ID: 08a1a1eb-2d27-4c44-9dbf-ad6240b37571
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 10 Mar 2026 18:38:50 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.15) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 10 Mar 2026 18:38:48 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>
CC: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster
	<bfoster@redhat.com>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yuto Ohnuki <ytohnuki@amazon.com>,
	<syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH v4 1/4] xfs: stop reclaim before pushing AIL during unmount
Date: Tue, 10 Mar 2026 18:38:37 +0000
Message-ID: <20260310183835.89827-7-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260310183835.89827-6-ytohnuki@amazon.com>
References: <20260310183835.89827-6-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D036UWC002.ant.amazon.com (10.13.139.242) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The unmount sequence in xfs_unmount_flush_inodes() pushed the AIL while
background reclaim and inodegc are still running. This is broken
independently of any use-after-free issues - background reclaim and
inodegc should not be running while the AIL is being pushed during
unmount, as inodegc can dirty and insert inodes into the AIL during the
flush, and background reclaim can race to abort and free dirty inodes.

Reorder xfs_unmount_flush_inodes() to stop inodegc and cancel background
reclaim before pushing the AIL. Stop inodegc before cancelling
m_reclaim_work because the inodegc worker can re-queue m_reclaim_work
via xfs_inodegc_set_reclaimable.

Reported-by: syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=652af2b3c5569c4ab63c
Fixes: 90c60e164012 ("xfs: xfs_iflush() is no longer necessary")
Cc: <stable@vger.kernel.org> # v5.9
Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
 fs/xfs/xfs_mount.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 9c295abd0a0a..ef1ea8a1238c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -608,8 +608,9 @@ xfs_unmount_check(
  * have been retrying in the background.  This will prevent never-ending
  * retries in AIL pushing from hanging the unmount.
  *
- * Finally, we can push the AIL to clean all the remaining dirty objects, then
- * reclaim the remaining inodes that are still in memory at this point in time.
+ * Stop inodegc and background reclaim before pushing the AIL so that they
+ * are not running while the AIL is being flushed. Then push the AIL to
+ * clean all the remaining dirty objects and reclaim the remaining inodes.
  */
 static void
 xfs_unmount_flush_inodes(
@@ -621,9 +622,9 @@ xfs_unmount_flush_inodes(
 
 	xfs_set_unmounting(mp);
 
-	xfs_ail_push_all_sync(mp->m_ail);
 	xfs_inodegc_stop(mp);
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	xfs_ail_push_all_sync(mp->m_ail);
 	xfs_reclaim_inodes(mp);
 	xfs_health_unmount(mp);
 	xfs_healthmon_unmount(mp);
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



