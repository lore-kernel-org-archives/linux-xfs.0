Received: from forward103b.mail.yandex.net (forward103b.mail.yandex.net [178.154.239.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE9236B07E;
	Wed, 10 Jun 2026 19:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781119166; cv=none; b=p9BsEEb3G1U4gHahuhsc/6JtjdwOsRcmNJtexJgrQIYTrhZS+yOlSdIBWq1O65W3OSQ/FBv10zMAKeYDbP8ctUv0aTFUE8EaVUvZ2uFPtuYhX2U3WFwwCTlx2alz2/oiKN0xzElFRpGmKfnFZthgRTM0Wheas37HF0byemo/QYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781119166; c=relaxed/simple;
	bh=14KyMoGcFsOxHdwPxM42rmKp14WJVn+yR9WBJ0g96RM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Oth4ntCAlfBr3uB963NxuT3YyHCWGdWjtIt89pHl66ejwQkXmJeo17TcP3RBvCAHnkG47Pa3jGdo265xGnc3dCHd/Rl5DOI2dyBYfUgKF1YpV/EO/YjHtQ6whnLJi2zRf6miShvud6R7HXkjbiZPZ80v6v7Ff7ASHEGQCerb9Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru; spf=pass smtp.mailfrom=rosa.ru; dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b=n7VksOwr; arc=none smtp.client-ip=178.154.239.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rosa.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b="n7VksOwr"
Received: from mail-nwsmtp-smtp-production-main-89.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-89.sas.yp-c.yandex.net [IPv6:2a02:6b8:c11:2281:0:640:870e:0])
	by forward103b.mail.yandex.net (Yandex) with ESMTPS id AF7EAC0066;
	Wed, 10 Jun 2026 22:19:09 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-89.sas.yp-c.yandex.net (smtp) with ESMTPSA id 5JQxdFPgKqM0-soub5Dfv;
	Wed, 10 Jun 2026 22:19:08 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rosa.ru; s=mail;
	t=1781119149; bh=AP1aDcep4EMBeZMz8/BUBTQ40jZ9pzdiZkNh4rtA26I=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=n7VksOwrP4laGO/90sAsKNWHL4R+dPNcla5tYhqypw2UNWEc8eGQ2pwB86Z7rGS7n
	 z9mmhETnzD3tPNGxpDPpAi8dtzbAiW/xA4wpUgUdrRw3n1mk6fCrNpYeIDG+uYkdwp
	 xf/T+/lpe3ZxymfoNU8kdrdr0qom2TqKSpRss4Tg=
Authentication-Results: mail-nwsmtp-smtp-production-main-89.sas.yp-c.yandex.net; dkim=pass header.i=@rosa.ru
From: Mikhail Lobanov <m.lobanov@rosa.ru>
To: cem@kernel.org
Cc: m.lobanov@rosa.ru,
	djwong@kernel.org,
	david@fromorbit.com,
	hch@infradead.org,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH v5 1/2] xfs: skip inode inactivation on a shut down mount
Date: Wed, 10 Jun 2026 22:19:03 +0300
Message-Id: <20260610191904.12533-1-m.lobanov@rosa.ru>
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

Honour the same invariant in xfs_inactive() itself: if the mount is shut
down, return early before doing any inactivation work.  The dquots
attached to the inode are released by the existing xfs_qm_dqdetach() at
the out: label, so references are not leaked, and the caller then makes
the inode reclaimable exactly as before.

On its own this is a consistency fix with the existing queue-time
behaviour; it is also a prerequisite for shutting the mount down in the
xfs_mountfs() failure path in the following patch.

Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
Signed-off-by: Mikhail Lobanov <m.lobanov@rosa.ru>
---
v5: per Christoph's review of v4, move the shutdown check into
    xfs_inactive() itself - an early "goto out" after initialising mp at
    declaration - instead of guarding the call in
    xfs_inodegc_inactivate().  The attached dquots are then released by
    the existing xfs_qm_dqdetach() at the out: label, which also removes
    the empty else branch that v4 had to brace to silence -Wempty-body
    without CONFIG_XFS_QUOTA.  Christoph's other comment - a potential
    NULL deref in xfs_qm_dqdetach() when the quota subsystem is gone - is
    discussed separately in-thread; I could not find a path that reaches
    it in the current tree, so it is not folded into this series.

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

 fs/xfs/xfs_inode.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index beaa26ec62da..658da1e5fd42 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1386,7 +1386,7 @@ int
 xfs_inactive(
 	xfs_inode_t	*ip)
 {
-	struct xfs_mount	*mp;
+	struct xfs_mount	*mp = ip->i_mount;
 	int			error = 0;
 	int			truncate = 0;
 
@@ -1399,7 +1399,20 @@ xfs_inactive(
 		goto out;
 	}
 
-	mp = ip->i_mount;
+	/*
+	 * If the filesystem has been shut down - for example a mount that
+	 * failed after background inactivation was enabled - do not
+	 * inactivate the inode.  Inactivation modifies persistent metadata,
+	 * its transactions cannot complete on a shut down mount, and the
+	 * subsystems it relies on (e.g. quota, mp->m_quotainfo) may not be
+	 * set up.  The attached dquots are dropped at the out: label and the
+	 * inode then goes straight to reclaim, the same way
+	 * xfs_inode_needs_inactive() already declines to inactivate on a shut
+	 * down mount at queue time.
+	 */
+	if (xfs_is_shutdown(mp))
+		goto out;
+
 	ASSERT(!xfs_iflags_test(ip, XFS_IRECOVERY));
 
 	xfs_inactive_health(ip);
--
2.43.0

