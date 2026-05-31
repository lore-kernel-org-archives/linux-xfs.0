Received: from forward206b.mail.yandex.net (forward206b.mail.yandex.net [178.154.239.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C145391836;
	Sun, 31 May 2026 15:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780243082; cv=none; b=lMuy2MrbxpiDroMnvEtS0gFdjbBp6QWBMG9V13u4/8DHS+FN432EQLmuJt1CKQpU263Scbl3CsB4gjsAY0PfDlHIIoXqI4zcG6ydEigTFQtW2gDbma5B14lyQpXVVEzf8Vvk2+rjUMCj3dDunwHsiznRApJTXLcE+Or5ZsnK+S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780243082; c=relaxed/simple;
	bh=yppqme6e5Zv5odIm6cO9g2ozB+/xHnwMRgwaZCbfJmk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SYd8MipGZ/AXn1ZQJg3iUeJKzkolOJ0NrBdl1nJTTWukYi/shvv277zUrM0CP8YSaOqua/8rVp3WROYFKxpnXLng1AjtqLYAVhSKhLMaMKHf6EjWVPmb6oxIR7Ji/I0ldlxcDujcOfzWEd66wimhAR7OLFtB0Srtl6CzlQQnFks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru; spf=pass smtp.mailfrom=rosa.ru; dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b=bOXzBK3E; arc=none smtp.client-ip=178.154.239.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rosa.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b="bOXzBK3E"
Received: from forward100b.mail.yandex.net (forward100b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d100])
	by forward206b.mail.yandex.net (Yandex) with ESMTPS id F0B3381204;
	Sun, 31 May 2026 18:52:23 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-58.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-58.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:2911:0:640:8872:0])
	by forward100b.mail.yandex.net (Yandex) with ESMTPS id 9D59D80D83;
	Sun, 31 May 2026 18:52:15 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-58.iva.yp-c.yandex.net (smtp) with ESMTPSA id CqfMx5jdN8c0-JlxSuwJA;
	Sun, 31 May 2026 18:52:14 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rosa.ru; s=mail;
	t=1780242735; bh=daUm0xrQPoXo8eTbueFXY/fD+e0TH+OyliEDJSHpcU0=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=bOXzBK3ESRDc12popLYDj5L7KzEVu7DAjguw1Gxe1yegUR17Ruq6V3JtQta+Kwm0z
	 SxQ943zyDShGPUN1r/i+zyA+JBxh+pfA/7F5TNd8QLICT55pvuauID14WJPxqNzVmn
	 Rq+6q8XC7vMxrZbOEsd7DPBQFz91aV8tRITJsaSA=
Authentication-Results: mail-nwsmtp-smtp-production-main-58.iva.yp-c.yandex.net; dkim=pass header.i=@rosa.ru
From: Mikhail Lobanov <m.lobanov@rosa.ru>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	m.lobanov@rosa.ru
Subject: [PATCH] xfs: skip dquot attach when m_quotainfo is not set up
Date: Sun, 31 May 2026 18:52:11 +0300
Message-Id: <20260531155211.43803-1-m.lobanov@rosa.ru>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

XFS quota accounting flags (XFS_*QUOTA_ACCT in mp->m_qflags) are parsed
from the mount options before xfs_mountfs() runs, but the quota
subsystem itself (mp->m_quotainfo) is only allocated later, in
xfs_qm_mount_quotas().  Background inode inactivation (inodegc) is
enabled earlier still, in xfs_mountfs() right after log recovery.

As a result there is a window during mount where XFS_IS_QUOTA_ON() is
already true while mp->m_quotainfo is still NULL.  The same inconsistency
exists during teardown, when m_quotainfo is freed before the quota flags
are cleared.  If a background xfs_inodegc_worker inactivates an inode in
that window -- easily triggered by mounting a crafted/corrupt image where
the mount aborts after inodegc has been enabled (e.g. xfs_rtmount_inodes()
failing with "failed to read RT inodes") -- xfs_inactive() calls
xfs_qm_dqattach(), which trusts XFS_IS_QUOTA_ON() and goes on to
dereference the NULL mp->m_quotainfo in xfs_qm_dqget_inode():

  XFS (loop0): failed to read RT inodes
  Oops: general protection fault, probably for non-canonical address
        0xdffffc000000002a: 0000 [#1] PREEMPT SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000150-0x0000000000000157]
  Workqueue: xfs-inodegc/loop0 xfs_inodegc_worker
  RIP: 0010:__mutex_lock+0xfe/0x930
  Call Trace:
   xfs_qm_dqget_cache_lookup+0x63/0x7f0
   xfs_qm_dqget_inode+0x336/0x860
   xfs_qm_dqattach_one+0x232/0x4e0
   xfs_qm_dqattach_locked+0x2c6/0x470
   xfs_qm_dqattach+0x46/0x70
   xfs_inactive+0x988/0xe80
   xfs_inodegc_worker+0x27c/0x730

mutex_lock() faults on &qi->qi_tree_lock (offset 0x150) with qi == NULL.

When mp->m_quotainfo is NULL there are no in-core dquots to attach, so
the attach must simply be skipped.  Guard xfs_qm_need_dqattach() -- the
single gate every xfs_qm_dqattach()/xfs_qm_dqattach_locked() caller
passes through before reaching xfs_qm_dqget_inode() -- with an explicit
mp->m_quotainfo check.  Once quotas are fully set up m_quotainfo stays
non-NULL until quotas are turned off (which also clears the quota flags),
so the new check is a no-op for a normally mounted quota filesystem;
quota accounting and enforcement are unaffected.

The existing xfs_inodegc_flush() added by commit 0c7273e494dd ("xfs:
quotacheck failure can race with background inode inactivation") only
covers tearing down quotas after a failed quotacheck and does not help
here, because in this case quotacheck is never reached.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller. 

Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
Signed-off-by: Mikhail Lobanov <m.lobanov@rosa.ru>
---
 fs/xfs/xfs_qm.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ee2530fabeeb..6a4e8d6fb806 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -310,6 +310,19 @@ xfs_qm_need_dqattach(

 	if (!XFS_IS_QUOTA_ON(mp))
 		return false;
+	/*
+	 * The quota accounting flags in m_qflags are set from the mount options
+	 * before xfs_mountfs() runs, but the quota subsystem (mp->m_quotainfo)
+	 * is only initialised later in xfs_qm_mount_quotas(); it is also torn
+	 * down (and m_quotainfo set to NULL) before those flags are cleared when
+	 * quotas are turned off.  During those windows a background inodegc
+	 * worker inactivating an inode can reach here with XFS_IS_QUOTA_ON()
+	 * true but no quotainfo to look dquots up in, which would lead to a NULL
+	 * pointer dereference of mp->m_quotainfo in xfs_qm_dqget_inode().  There
+	 * are no dquots to attach in that state, so skip the attach.
+	 */
+	if (!mp->m_quotainfo)
+		return false;
 	if (!XFS_NOT_DQATTACHED(mp, ip))
 		return false;
 	if (xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
--
2.43.0
