Received: from forward101b.mail.yandex.net (forward101b.mail.yandex.net [178.154.239.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA40B3B71B1;
	Fri,  5 Jun 2026 09:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780651956; cv=none; b=QfzSEgcjO5RzV07eq9hMzNrUlBWKHzGW1aDuW37NvdXjqHUMEMPBSQN25UjQUSv74Lg/81QsbxtmdYRIfW/gH76evWXekHVgxY3meREJCja+Nn8296QQt54lrl+jfGLULf2y43RYoUofJFvc1hCVvMb3UnH1509ZJYP1iqaCbBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780651956; c=relaxed/simple;
	bh=YMPIb3Wqbn6oFZKeRGkStfSdljScs8OuAeqJ88oHCbw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LasHY3px9SQWYTd1LT+1kr58AFI74SN8Fi1etH1KtmdogGzflF8dKGOUO3ZG7uDSOsboyrQKBnGyGOD8pEn5jAtOAmfF32BSWYTVGWLnRabNrUQJ9bnFvNHJzDkXFQ6/g6JkpFU5mm/TII6p7umIaNS/4+k5E0OKChzDFmWraQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru; spf=pass smtp.mailfrom=rosa.ru; dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b=aAfgppsw; arc=none smtp.client-ip=178.154.239.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rosa.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b="aAfgppsw"
Received: from mail-nwsmtp-smtp-production-main-89.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-89.sas.yp-c.yandex.net [IPv6:2a02:6b8:c11:2281:0:640:870e:0])
	by forward101b.mail.yandex.net (Yandex) with ESMTPS id B6975C0074;
	Fri, 05 Jun 2026 12:32:26 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-89.sas.yp-c.yandex.net (smtp) with ESMTPSA id MWeqWPKg7eA0-ZUIdjwp2;
	Fri, 05 Jun 2026 12:32:25 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rosa.ru; s=mail;
	t=1780651945; bh=Bqwg2k+EIq2Oc3zzFvIOmt0U1aaUxHYWf4rCTj43P+A=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=aAfgppswN0ezvLiBRRs+Yin3Y8u9D9Zlnt2gTjDDgOMiZ7+aZx4vrJV60TTRFcKx0
	 LW/qaPp3mLEb3Qkz0cALxHl4ey8IOxrrTgr6HkTCstne4+Iz7duRon7CbJReW7RFns
	 eXXTepV4/SmF9+5nQlCb5vrS9fMh8ajkYQCcwax8=
Authentication-Results: mail-nwsmtp-smtp-production-main-89.sas.yp-c.yandex.net; dkim=pass header.i=@rosa.ru
From: Mikhail Lobanov <m.lobanov@rosa.ru>
To: cem@kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@infradead.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	m.lobanov@rosa.ru
Subject: [PATCH v3 1/2] xfs: skip inode inactivation on a shut down mount
Date: Fri,  5 Jun 2026 12:32:21 +0300
Message-Id: <20260605093222.8555-1-m.lobanov@rosa.ru>
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
v3: split out of the v2 single patch as a prep patch, and additionally
    drop the attached dquots in the shutdown branch to avoid leaking
    references when an inode queued while the mount was live is processed
    after a (normal) shutdown - spotted in review of v2.

v2: https://lore.kernel.org/linux-xfs/aiKA7vVQ_RxT_YOr@infradead.org/T/#t
v1: https://lore.kernel.org/linux-xfs/ah6BIsvEitNW5Edb@infradead.org/

 fs/xfs/xfs_icache.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 2040a9292ee6..1f725804be17 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1940,10 +1940,25 @@ static int
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
+	if (!xfs_is_shutdown(ip->i_mount))
+		error = xfs_inactive(ip);
+	else
+		/* Going straight to reclaim, so drop the dquots. */
+		xfs_qm_dqdetach(ip);
 	xfs_inodegc_set_reclaimable(ip);
 	return error;

--
2.43.0
