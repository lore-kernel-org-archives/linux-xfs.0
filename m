Received: from forward200d.mail.yandex.net (forward200d.mail.yandex.net [178.154.239.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F92328635;
	Sun,  7 Jun 2026 18:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780857410; cv=none; b=c3gkDtpNYST3hfBJtmwZXvcK8oezmwOegumPwmFHRLIgxkjFYCEa3qn6tvTRFO81236AQnSqr7LMKqgSI9W8bskOHB59FXHjVK0ckR5P0eampyX7qas0Z9d5Jgq2Yylqa4fOUxYG7uU8+d8Ph+u/RONZE+GdqRuiOC6V0xp4/Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780857410; c=relaxed/simple;
	bh=lFG+z1nGjpHX1ZGDU1xuzzSo/ovUV9kfB8zIz74tk4A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Mkc9hyR8a4ftrCRcXQQulqf1Xme2bnyG5M9HzZ5rGmjuBm8I194pol5KBF/bNrhar4oeifOF1C1DrZCnTKQqsOLv9wz6VLsnh+5qpO8MMnziAAtPfqWpSmJx4lyyVDQlQBoUztjDqPsPF67qULmrdpJHjCecafFL7A98TDzOC2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru; spf=pass smtp.mailfrom=rosa.ru; dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b=mDIZ5BAK; arc=none smtp.client-ip=178.154.239.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rosa.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b="mDIZ5BAK"
Received: from forward100d.mail.yandex.net (forward100d.mail.yandex.net [IPv6:2a02:6b8:c41:1300:1:45:d181:d100])
	by forward200d.mail.yandex.net (Yandex) with ESMTPS id 7C0BF81C50;
	Sun, 07 Jun 2026 21:30:39 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-99.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-99.klg.yp-c.yandex.net [IPv6:2a02:6b8:c43:da5:0:640:db94:0])
	by forward100d.mail.yandex.net (Yandex) with ESMTPS id 00A4DC0067;
	Sun, 07 Jun 2026 21:30:30 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-99.klg.yp-c.yandex.net (smtp) with ESMTPSA id RUMHNYleJuQ0-gw55lWUg;
	Sun, 07 Jun 2026 21:30:29 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rosa.ru; s=mail;
	t=1780857029; bh=hR7YxN+Uvt/i4XyEMU4DPcgVK3ILs/z9yJBPeHAkTVc=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=mDIZ5BAKNeolrU+m0uHudYUlCBrgoj6Hn962UFZZ0HC8Tjx1ec0mikiEh6liiyXxi
	 Az6d4QZ8FNH1Ci5Qy6wb+lW8VJP9lsnlK9FNVQyFLeF2mMgVXJJNaTQeH9hakgQGcn
	 TLqCj+ziDM6zOY7gINdrLuoNiKeLOdo4l3hdePmQ=
Authentication-Results: mail-nwsmtp-smtp-production-main-99.klg.yp-c.yandex.net; dkim=pass header.i=@rosa.ru
From: Mikhail Lobanov <m.lobanov@rosa.ru>
To: cem@kernel.org
Cc: m.lobanov@rosa.ru,
	djwong@kernel.org,
	david@fromorbit.com,
	hch@infradead.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH v4 1/2] xfs: skip inode inactivation on a shut down mount
Date: Sun,  7 Jun 2026 21:30:25 +0300
Message-Id: <20260607183026.37700-1-m.lobanov@rosa.ru>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

XFS already declines to inactivate inodes on a shut down mount, but only
at queue time: xfs_inode_mark_reclaimable() calls
xfs_inode_needs_inactive(), which returns false when the mount is shut
down ("If the log isn't running, push inodes straight to reclaim"), and
then drops the dquots and marks the inode reclaimable directly.

An inode that was queued for background inactivation while the mount was
still live is not covered by that check: the inodegc worker still calls
xfs_inactive() on it even after the mount has been shut down in the
meantime.  Inactivation modifies persistent metadata and runs
transactions that cannot complete on a shut down mount, and it relies on
subsystems (e.g. quota) that a torn down, or never fully set up, mount
may not have available.

Honour the same invariant at gc time.  In xfs_inodegc_inactivate(), skip
xfs_inactive() when the mount is shut down and just make the inode
reclaimable.  As the inode then goes straight to reclaim, drop its dquots
in that case too - exactly as the straight-to-reclaim path in
xfs_inode_mark_reclaimable() already does - so the dquot references are
not leaked.  xfs_qm_dqdetach() is a no-op when no dquots are attached.

On its own this is a consistency fix with the existing queue-time
behaviour; it is also a prerequisite for shutting the mount down in the
xfs_mountfs() failure path in the following patch.

Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
Signed-off-by: Mikhail Lobanov <m.lobanov@rosa.ru>
---
v4: brace both branches of the if/else.  Without CONFIG_XFS_QUOTA
    xfs_qm_dqdetach() expands to nothing, leaving the else with an empty
    body, which trips -Wempty-body on a W=1 build (i386-allnoconfig,
    reported by the kernel test robot).

v3: split out of the v2 single patch as a prep patch, and additionally
    drop the attached dquots in the shutdown branch to avoid leaking
    references when an inode queued while the mount was live is processed
    after a (normal) shutdown - spotted in review of v2.

v2: https://lore.kernel.org/linux-xfs/aiKA7vVQ_RxT_YOr@infradead.org/T/#t
v1: https://lore.kernel.org/linux-xfs/ah6BIsvEitNW5Edb@infradead.org/

 fs/xfs/xfs_icache.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 2040a9292ee6..1f725804be17 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1940,10 +1940,26 @@ static int
 xfs_inodegc_inactivate(
 	struct xfs_inode	*ip)
 {
-	int			error;
+	int			error = 0;

 	trace_xfs_inode_inactivating(ip);
-	error = xfs_inactive(ip);
+
+	/*
+	 * If the filesystem has been shut down - for example a mount that
+	 * failed after background inactivation was enabled - do not
+	 * inactivate the inode.  Inactivation modifies persistent metadata,
+	 * its transactions cannot complete on a shut down mount, and the
+	 * subsystems it relies on (e.g. quota, mp->m_quotainfo) may not be
+	 * set up.  Drop any attached dquots and make the inode reclaimable,
+	 * the same way xfs_inode_mark_reclaimable() does when it sends an
+	 * inode straight to reclaim.
+	 */
+	if (!xfs_is_shutdown(ip->i_mount)) {
+		error = xfs_inactive(ip);
+	} else {
+		/* Going straight to reclaim, so drop the dquots. */
+		xfs_qm_dqdetach(ip);
+	}
 	xfs_inodegc_set_reclaimable(ip);
 	return error;

--
2.43.0
