Received: from forward100b.mail.yandex.net (forward100b.mail.yandex.net [178.154.239.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FBE2C375E;
	Tue,  2 Jun 2026 14:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780411058; cv=none; b=hk39rBlSRjbt6LuR5QuhOX039oSEGScN7+Os2gOgGew/mci33deWkZVJSk1njgb5Q3Fl5PurncbX3Mu3SCGSDOYrIadvG2FA99V/n+X8AOWbOnzv23/Y1Otis9zjQuj/KdDyqHsnNvQLFTI5j7N+qYZd13tMo1ceTNqwQx0C4B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780411058; c=relaxed/simple;
	bh=CFzAlGJ5r+OZaMyDnnw7cff2/xZFFWLCbfIJAQj9PYQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pik2XZTT/ZGvrNP9/BRSL1sCuYY2PIz6yz4qiZ2n7vIdtpaJLGE2MzKGV3olvcFn4u3O0mmmmrNBTKYuLyFZUgQggfJJmjZM4rA8K5QI49L+mIkLsTFoVHRTcsV+2Cm4JPDelH1nuzpLsuKbJyEcHwRq0Kc9oGjqkq0vEAyOvcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru; spf=pass smtp.mailfrom=rosa.ru; dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b=QktEJTfQ; arc=none smtp.client-ip=178.154.239.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rosa.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b="QktEJTfQ"
Received: from mail-nwsmtp-smtp-production-main-55.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-55.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:1791:0:640:6f9:0])
	by forward100b.mail.yandex.net (Yandex) with ESMTPS id 95C8D80E8D;
	Tue, 02 Jun 2026 17:37:21 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-55.sas.yp-c.yandex.net (smtp) with ESMTPSA id HbgdVcIfEuQ0-al2iV39f;
	Tue, 02 Jun 2026 17:37:20 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rosa.ru; s=mail;
	t=1780411040; bh=tevjnZ09bAtLPc+i+T5L2OqEaDYGPcK6JDmOMRaFePY=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=QktEJTfQuPbgqfKGfTqxDqyz0jvMFPLUsTEalCYo8GU42rIFHYTnTykQt8EReC5d5
	 A7JY38ys3kg34/ZXLB0Ee/Jq+SxChYdWQ9mcuXo5zmI0pa0cOCq49IqmvzvmBFuQwu
	 Du2xuZSqtv2BCsA/Wu0/bqQQWAAqPLB3rXdBAStE=
Authentication-Results: mail-nwsmtp-smtp-production-main-55.sas.yp-c.yandex.net; dkim=pass header.i=@rosa.ru
From: Mikhail Lobanov <m.lobanov@rosa.ru>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	m.lobanov@rosa.ru,
	lvc-project@linuxtesting.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2] xfs: do not inactivate inodes on a failed mount
Date: Tue,  2 Jun 2026 17:37:17 +0300
Message-Id: <20260602143717.21976-1-m.lobanov@rosa.ru>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A corrupt/crafted XFS image can make mount fail after background inode
inactivation has already been enabled.  xfs_mountfs() turns on inodegc
(xfs_inodegc_start()) right after log recovery, but the quota subsystem
(mp->m_quotainfo) is only allocated much later, in xfs_qm_newmount() /
xfs_qm_mount_quotas().  The quota accounting flags in mp->m_qflags are
parsed from the mount options before xfs_mountfs() even runs.

If the mount then aborts in between - e.g. xfs_rtmount_inodes() failing
with "failed to read RT inodes" - the unwind path inactivates the inodes
that are still queued, and xfs_inactive() calls xfs_qm_dqattach().  That
path trusts XFS_IS_QUOTA_ON() (the flag is set) and dereferences the not
yet allocated mp->m_quotainfo:

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

The NULL m_quotainfo deref is only one symptom.  The deeper problem is
that a failed mount should not be inactivating inodes at all: it must not
write to the (possibly corrupt, only partially set up) persistent
metadata of a filesystem we just refused to mount, and the subsystems
inactivation relies on may not be initialised.

XFS already encodes this rule: xfs_inode_needs_inactive() returns false
when the mount is shut down ("If the log isn't running, push inodes
straight to reclaim"), so an inode destroyed on a shut down mount is
never queued for inactivation.  The gap is that this is only evaluated at
queue time; an inode queued while the mount was still live is then
inactivated by the worker even after the mount has been torn down.  Honour
the same invariant at gc time: in xfs_inodegc_inactivate(), skip
xfs_inactive() when the mount is shut down and just make the inode
reclaimable (xfs_inodegc_set_reclaimable() already handles the shutdown
case).  This is not a new policy, just consistency with the existing one.

Then, in the xfs_mountfs() failure path, shut the mount down before
flushing the inodegc queue, so the queued inodes are dropped to reclaim
instead of inactivated.  They are still pulled down so reclaim can free
them (which is why the flush was added in commit ab23a7768739 ("xfs:
per-cpu deferred inode inactivation queues")), but without touching the
on-disk structures - matching that comment's own "pull down all the state
and flee" intent.

Note that shutting down alone is not enough to stop the crash:
xfs_inactive() calls xfs_qm_dqattach() before any shutdown-sensitive
transaction, and neither xfs_qm_need_dqattach() nor xfs_qm_dqattach()
tests for shutdown - so the worker change is what actually closes it.

Found by fuzzing XFS with syzkaller (corrupt image mount); reproduced and
verified under QEMU/KASAN.

Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
Signed-off-by: Mikhail Lobanov <m.lobanov@rosa.ru>
---
v2: change approach after Christoph Hellwig's review of v1.  Instead of
    guarding xfs_qm_need_dqattach() in the quota code, do not inactivate
    inodes at all on a failed/shut-down mount: skip xfs_inactive() in the
    inodegc worker when the mount is shut down (consistent with
    xfs_inode_needs_inactive(), which already pushes inodes straight to
    reclaim on shutdown), and shut the mount down in the xfs_mountfs()
    failure path before flushing the inodegc queue.

Review of v1: https://lore.kernel.org/linux-xfs/ah6BIsvEitNW5Edb@infradead.org/

Open question: in the failure path I used xfs_force_shutdown(mp,
SHUTDOWN_FORCE_UMOUNT) to mark the fs down.  It logs "User initiated
shutdown received", which is a bit misleading for a mount failure (the tag
actually shown is "Metadata I/O Error (0x4)").  Would a different flag, or
just quietly setting the shutdown state, be preferable here?

 fs/xfs/xfs_icache.c | 14 ++++++++++++--
 fs/xfs/xfs_mount.c  | 15 +++++++++++----
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 2040a9292ee6..1f725804be17 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1940,10 +1940,20 @@ static int
 xfs_inodegc_inactivate(
 	struct xfs_inode	*ip)
 {
-	int			error;
+	int			error = 0;

 	trace_xfs_inode_inactivating(ip);
-	error = xfs_inactive(ip);
+
+	/*
+	 * If the filesystem has been shut down - for example a mount that failed
+	 * after background inactivation was enabled - do not inactivate the
+	 * inode.  Inactivation modifies the persistent metadata and its
+	 * transactions cannot complete on a shut down mount anyway, and the
+	 * subsystems it relies on (e.g. quota, mp->m_quotainfo) may not be set
+	 * up.  Just make the inode reclaimable so it can be freed.
+	 */
+	if (!xfs_is_shutdown(ip->i_mount))
+		error = xfs_inactive(ip);
 	xfs_inodegc_set_reclaimable(ip);
 	return error;

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b24195f570cd..37fb69165502 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1243,11 +1243,18 @@ xfs_mountfs(
 		xfs_irele(mp->m_metadirip);

 	/*
-	 * Inactivate all inodes that might still be in memory after a log
-	 * intent recovery failure so that reclaim can free them.  Metadata
-	 * inodes and the root directory shouldn't need inactivation, but the
-	 * mount failed for some reason, so pull down all the state and flee.
+	 * The mount has failed.  Mark the filesystem shut down so that any
+	 * inodes still queued for background inactivation are dropped straight
+	 * to reclaim instead of being inactivated: a failed mount must not write
+	 * to the (possibly corrupt, only partially set up) persistent metadata,
+	 * and parts of the mount it would need - e.g. the quota subsystem
+	 * (mp->m_quotainfo) - may never have been initialised.
+	 *
+	 * Flush the queue so that those inodes are pulled down and reclaim can
+	 * free them; with the fs shut down xfs_inodegc_inactivate() turns each
+	 * one reclaimable without touching the on-disk structures.
 	 */
+	xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
 	xfs_inodegc_flush(mp);

 	/*
--
2.43.0
