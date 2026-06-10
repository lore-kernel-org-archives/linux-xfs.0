Received: from forward205b.mail.yandex.net (forward205b.mail.yandex.net [178.154.239.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BE81A6839;
	Wed, 10 Jun 2026 19:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781119509; cv=none; b=kmEEYqeNlwQChOeAEVXzasVJunHWmXLS9b8Q6MsxVvgL6ZY+2iPMHMkTsrkX5tG6A57qg4re95DbLvOmSeZgMiZRDzNiV/5UE/ZHRHcqmVEKTt2VTWWtQDOqvcpprSvWeHwcQuV9QngtIvg+1U2sLK3am35cPHyKGa9B70jVj7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781119509; c=relaxed/simple;
	bh=wxDnZCZGHlG1GEppln0HUiURU2hosGEbFE9XudL80Gs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nIm/opaRyTUSG6RL+WBhGeRpTyeIL9ga4vn9bHNsvk9HUZHypWJx+Ck33BQJnnJvW9F8K7LmesTl/PjkR28UqiTvQv4T+z0PD7TzGnaIJr3mOvG++0/rvIN4UDX0OSGKuSvQr5WVrwBCXHUFnSJCpQYskdVP8ENEeCk2gNUO4JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru; spf=pass smtp.mailfrom=rosa.ru; dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b=MEgnTpfd; arc=none smtp.client-ip=178.154.239.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rosa.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b="MEgnTpfd"
Received: from forward100b.mail.yandex.net (forward100b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d100])
	by forward205b.mail.yandex.net (Yandex) with ESMTPS id 40E1E89416;
	Wed, 10 Jun 2026 22:19:19 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-89.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-89.sas.yp-c.yandex.net [IPv6:2a02:6b8:c11:2281:0:640:870e:0])
	by forward100b.mail.yandex.net (Yandex) with ESMTPS id 2BD1580B44;
	Wed, 10 Jun 2026 22:19:11 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-89.sas.yp-c.yandex.net (smtp) with ESMTPSA id 5JQxdFPgKqM0-hgX5xI4t;
	Wed, 10 Jun 2026 22:19:10 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rosa.ru; s=mail;
	t=1781119150; bh=/Ke8p5qH52rh6EA5mXHEXMqIt0FdRBEVcMDShnWyTds=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=MEgnTpfdSl2VbfD8wjvPTL7WtwBdUgxSoKIoVHKRpbZBN1HZOEyfwliHIA03VhN9n
	 20bfRe+RmRF6op44tBBDu11liA21WNwctXNYStMhLLvuyFuXNCWUspq2h7Tg6lBZVi
	 44EvSBTL0avLFa91Urt+FThz8jEQaxbQRrSeYhVE=
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
Subject: [PATCH v5 2/2] xfs: shut down the filesystem on a failed mount
Date: Wed, 10 Jun 2026 22:19:04 +0300
Message-Id: <20260610191904.12533-2-m.lobanov@rosa.ru>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260610191904.12533-1-m.lobanov@rosa.ru>
References: <20260610191904.12533-1-m.lobanov@rosa.ru>
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
with "failed to read RT inodes" - the unwind path flushes the inodegc
queue, which inactivates the inodes that are still queued, and
xfs_inactive() calls xfs_qm_dqattach().  That path trusts
XFS_IS_QUOTA_ON() (the flag is set) and dereferences the not yet
allocated mp->m_quotainfo:

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
that a failed mount should not be inactivating inodes at all: it must
not write to the (possibly corrupt, only partially set up) persistent
metadata of a filesystem we just refused to mount, and the subsystems
inactivation relies on may not be initialised.

Mark the filesystem shut down before flushing the inodegc queue in the
xfs_mountfs() failure path.  With the preceding patch a shut down mount
no longer inactivates the queued inodes: xfs_inactive() returns early so
they are dropped straight to reclaim instead.  They are still pulled down
so reclaim can free them (which is why the flush was added in commit
ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")), but
without touching the on-disk structures - matching that comment's own
"pull down all the state and flee" intent.

Use SHUTDOWN_META_IO_ERROR for the shutdown: it is the generic "cannot
safely touch metadata" reason already used elsewhere in this file and in
the xfs_ifree() failure path, and unlike SHUTDOWN_FORCE_UMOUNT it does
not log a misleading "User initiated shutdown received".  A failed mount
is not necessarily on-disk corruption (it can be a transient I/O or
resource error), so SHUTDOWN_CORRUPT_ONDISK would not be accurate either.

Found by fuzzing XFS with syzkaller (corrupt image mount); reproduced and
verified under QEMU/KASAN.

Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
Signed-off-by: Mikhail Lobanov <m.lobanov@rosa.ru>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v5: no change to this patch's diff; carry Christoph's Reviewed-by.  v5 of
    patch 1/2 moves the shutdown check into xfs_inactive(), so the body
    here now refers to xfs_inactive() returning early rather than to
    xfs_inodegc_inactivate().

v4: no change to this patch; resent as part of the series.  v4 of patch
    1/2 braces the if/else to silence a -Wempty-body W=1 warning.

v3: depend on the preceding "skip inode inactivation on a shut down
    mount" prep patch instead of doing both changes in one patch; use
    SHUTDOWN_META_IO_ERROR instead of SHUTDOWN_FORCE_UMOUNT (no
    misleading "User initiated shutdown" message, no message special
    casing); reflow the comment to stay within 80 columns.

v2: https://lore.kernel.org/linux-xfs/aiKA7vVQ_RxT_YOr@infradead.org/T/#t
v1: https://lore.kernel.org/linux-xfs/ah6BIsvEitNW5Edb@infradead.org/

 fs/xfs/xfs_mount.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b24195f570cd..37fb69165502 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1243,11 +1243,19 @@ xfs_mountfs(
 		xfs_irele(mp->m_metadirip);

 	/*
-	 * Inactivate all inodes that might still be in memory after a log
-	 * intent recovery failure so that reclaim can free them.  Metadata
-	 * inodes and the root directory shouldn't need inactivation, but the
-	 * mount failed for some reason, so pull down all the state and flee.
+	 * The mount has failed.  Mark the filesystem shut down so that any
+	 * inodes still queued for background inactivation are dropped
+	 * straight to reclaim instead of being inactivated: a failed mount
+	 * must not write to the (possibly corrupt, only partially set up)
+	 * persistent metadata, and parts of the mount it would need - e.g.
+	 * the quota subsystem (mp->m_quotainfo) - may never have been
+	 * initialised.
+	 *
+	 * Flush the queue so that those inodes are pulled down and reclaim
+	 * can free them; with the fs shut down xfs_inodegc_inactivate()
+	 * turns each one reclaimable without touching the on-disk structures.
 	 */
+	xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
 	xfs_inodegc_flush(mp);

 	/*
--
2.43.0

