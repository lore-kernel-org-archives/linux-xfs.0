Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81B823535E
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 01:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779067935; cv=none; b=uTpfytkjbBmHMiKiW+/ff6N1ny36a/ZNu6Lz24eDEnPvVHUfM1GpqwCvdzRRq/bP8J4tis48+Nr9PzLd9g0ig/ruGFsIcvO26LjkNt/xgvdTIhoVpIiQQcxpZi2m6bJ+gIGEg6vKwx4o5qWEYS3vCIY6gGA5pPD4+LfzkL+Bs1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779067935; c=relaxed/simple;
	bh=uSxBVG9L5IPEBZomtFI9GNRnEycBuFk/DSraLxzhB6s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hdlVHc+hpOje3oKGsQnKFCndfdYoC0Mrrs8x9gofCzXZBzqLZBqUC/fCVPssq7NcAMYhbQvjWbTyuPvaZYVaeeQq1ZBTtoRIaxQ/099L1xjSEHT1R+5Fwg4/vqeRdm43gqYoWBIzX1kK6edyLrMHNMxIW0Yezc5pkQ/rH5Gx4PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lGcZUUgR; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lGcZUUgR"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8b8e98fd885so27329206d6.0
        for <linux-xfs@vger.kernel.org>; Sun, 17 May 2026 18:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779067933; x=1779672733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=H9l9VOx9k1v+Q7n7JIO0+MFTnyUBN8tJgLVov8FuifQ=;
        b=lGcZUUgRYCMmVTAiyIPJjzUHm4JOSYy0ttFT/a7sNUK1MIgl9zo1onPoiK60po1n33
         mdsiMixUw35lv1auXmI6/rC+jUtpYK1t84vOdYphiw9rHo+pqkjqZqcZFT8G4HUgoso0
         PQA++icEU1vVOm9iMsYb0TOrsKE87tGGvqqVFmSqRnq3MJfi4jbLouJKFZV2/EPmQ47C
         /0ptbstYkixldxoVGxWHIVgMpPJ1UmERvfiVDV/xYO4MGW+B0qIQFbk1ZCl5d9Uk8A43
         +HBx7Fgfa0yo84dG5qBwkg/WYdI0ues9L2Ka+HpVvwLyouZkBm+QvZ0xrbSF/nevaeEU
         GbVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779067933; x=1779672733;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H9l9VOx9k1v+Q7n7JIO0+MFTnyUBN8tJgLVov8FuifQ=;
        b=YyP7IXIzfA9kS0i5b2gmP0k748BzgYCl+gNMPZRuLGDWIrdBLQQOsNUK9qpRlRZ9rZ
         0PlV2sJntB0DNhC3h1dEzxSihq+QiZiIHz4XMqltJ86TXwJAcOEnyAfpK/rqpBOHD8ur
         aPtox3rCkogUeR4eC+7RpUODtKSCHLWDoJNPJwFazIalUVPzxRDcb/jNkCbaEAN9K23r
         GhSjRnQsPBo1I0+1sU3j4URq66/37RrMrHLWheVKODlySy+RaIRjIhmTspKzvG1GLf0u
         zpPfw0BVjUYw2Ck5LCcFhsAdejnc4OGUKC3gK7H4FaU5mkWC4aTldcNjFQCdvDQF4Z4K
         UrnA==
X-Forwarded-Encrypted: i=1; AFNElJ//Xyc/IYlX4f0sNEefNFLr1RYsYhXfjx/kzxqQcIRhptc3w2jyyRi74nDNosIDZrulfUQosYlhe4I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0eNalt8DgRHlEslG7OLkhqrzOQlayanZOnIZWvjHIvyK2iBit
	HIqwNzIKrkHyGPEZW4R2km9A+A5LMLY7qM1rWnRxN6k6wcPbwd5S2CdK
X-Gm-Gg: Acq92OHV8/hpXPCMasVdJ3phN12oSEB1WryKMU/qGYijoMWVLrKYzc/aG7ncZxtPbrU
	ZRvzAQBXzAtCrQLO/6FLTl3sz+9dWShzlqBR0Ax60Tw4CZe9OWuyqi1pYKOAhHoPXqbWe3ejHSb
	E3Pf04K+WZT7PXFRlxTebTtm9DlhGsQqd7D6C6kLj9kmDWQeBkK+WOOeTjzWvNSzo8nJkcCfXRV
	/TF0MsPMEtNS+41yvf7CVRXOZT7CEgv4pb4iMi1NHg7E5aojS+7iNCdD0hWh7qCsWXnyilhGE1V
	HxuLDMDnMk1ZZ6si5qay2rW81h7Ei7WBgtY2ZQ1zKyH+bWsfPaXHW5ebztJOih6aQR8GRs4XS1d
	zmi1pEObjC5l64TyPP2sYvpU+yhaqJFegeM+xNLEi8bbinssC0wPjEn0IP3pJGfDk1U9RYkHLQN
	+QOwS15GJiNwdVM0a424AvzlgRl7z/INh4xHE/N/E0Ynrtw0v0i4YbpFhlpATv+SsLc2qimSQPa
	28VDgfbom/KrrLva32sBnvH/DPpP3Nf2WSwPr4/LWg=
X-Received: by 2002:ad4:4eeb:0:b0:89c:d424:aceb with SMTP id 6a1803df08f44-8ca0f6d639dmr218710626d6.31.1779067932625;
        Sun, 17 May 2026 18:32:12 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ca36086b95sm39111266d6.5.2026.05.17.18.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 18:32:11 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: detect cycles in recovered unlinked inode lists
Date: Sun, 17 May 2026 21:31:43 -0400
Message-ID: <20260518013143.1532327-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two XFS walkers follow on-disk AGI unlinked bucket lists until the
NULLAGINO sentinel and trust the links unconditionally:

  xlog_recover_iunlink_bucket(), reached at mount time when the log
  needs recovery, via xlog_recover_finish() ->
  xlog_recover_process_iunlinks().

  xfs_inode_reload_unlinked_bucket(), reached post-mount via
  xfs_bulkstat_one_int() and other inode-reload paths.

A crafted image with an AGI bucket head pointing into a cycle traps
either walker forever. With the mount-time walker, the mount(8)
syscall itself never returns; the kernel thread is uninterruptible
inside the loop, so SIGKILL on the mount process is queued but never
delivered. With the bulkstat walker, an XFS_IOC_BULKSTAT call hangs
the same way.

Reject invalid AG inode numbers, bucket mismatches, and repeated AG
inode numbers in both walkers. Mark the AGI sick and return
-EFSCORRUPTED so callers handle the corrupt metadata instead of
walking the same on-disk list forever.

Reproduced on a crafted image whose AGI bucket holds a self-cycle and
whose on-disk log is dirty: a stock kernel hangs in the mount syscall
indefinitely, while the patched kernel completes log recovery,
reports the corruption, and the filesystem shuts down with
-EFSCORRUPTED.

Fixes: 04755d2e5821b3afbaadd09fe5df58d04de36484 ("xfs: refactor xlog_recover_process_iunlinks()")
Fixes: 83771c50e42b92de6740a63e152c96c052d37736 ("xfs: reload entire unlinked bucket lists")
Assisted-by: Codex:gpt-5-5-xhigh
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 fs/xfs/xfs_inode.c       | 29 +++++++++++++++++++++++++++++
 fs/xfs/xfs_log_recover.c | 26 +++++++++++++++++++++++++-
 2 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index beaa26ec62da4..f930d5c823c77 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -4,6 +4,7 @@
  * All Rights Reserved.
  */
 #include <linux/iversion.h>
+#include <linux/xarray.h>
 
 #include "xfs_platform.h"
 #include "xfs_fs.h"
@@ -2859,6 +2860,7 @@ xfs_inode_reload_unlinked_bucket(
 	struct xfs_buf		*agibp;
 	struct xfs_agi		*agi;
 	struct xfs_perag	*pag;
+	struct xarray		seen_aginos;
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agino_t		prev_agino, next_agino;
@@ -2873,6 +2875,8 @@ xfs_inode_reload_unlinked_bucket(
 	if (error)
 		return error;
 
+	xa_init(&seen_aginos);
+
 	/*
 	 * We've taken ILOCK_SHARED and the AGI buffer lock to stabilize the
 	 * incore unlinked list pointers for this inode.  Check once more to
@@ -2897,6 +2901,30 @@ xfs_inode_reload_unlinked_bucket(
 	while (next_agino != NULLAGINO) {
 		struct xfs_inode	*next_ip = NULL;
 
+		/*
+		 * The on-disk unlinked list is corrupt if it points outside this
+		 * AG, into another bucket, or back to an inode that we already
+		 * saw during this reload walk.
+		 */
+		if (!xfs_verify_agino(pag, next_agino) ||
+		    next_agino % XFS_AGI_UNLINKED_BUCKETS != bucket) {
+			xfs_buf_mark_corrupt(agibp);
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+			error = -EFSCORRUPTED;
+			break;
+		}
+
+		if (xa_load(&seen_aginos, next_agino)) {
+			xfs_buf_mark_corrupt(agibp);
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+			error = -EFSCORRUPTED;
+			break;
+		}
+		error = xa_err(xa_store(&seen_aginos, next_agino,
+					xa_mk_value(1), GFP_NOFS));
+		if (error)
+			break;
+
 		/* Found this caller's inode, set its backlink. */
 		if (next_agino == agino) {
 			next_ip = ip;
@@ -2931,6 +2959,7 @@ xfs_inode_reload_unlinked_bucket(
 	}
 
 out_agibp:
+	xa_destroy(&seen_aginos);
 	xfs_trans_brelse(tp, agibp);
 	/* Should have found this inode somewhere in the iunlinked bucket. */
 	if (!error && !foundit)
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 09e6678ca4878..8ca70bbbfac81 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3,6 +3,8 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
+#include <linux/xarray.h>
+
 #include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
@@ -28,6 +30,7 @@
 #include "xfs_ag.h"
 #include "xfs_quota.h"
 #include "xfs_reflink.h"
+#include "xfs_health.h"
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 
@@ -2726,11 +2729,31 @@ xlog_recover_iunlink_bucket(
 	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_inode	*prev_ip = NULL;
 	struct xfs_inode	*ip;
+	struct xarray		seen_aginos;
 	xfs_agino_t		prev_agino, agino;
 	int			error = 0;
 
+	xa_init(&seen_aginos);
+
 	agino = be32_to_cpu(agi->agi_unlinked[bucket]);
 	while (agino != NULLAGINO) {
+		if (!xfs_verify_agino(pag, agino) ||
+		    agino % XFS_AGI_UNLINKED_BUCKETS != bucket) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+			error = -EFSCORRUPTED;
+			break;
+		}
+
+		if (xa_load(&seen_aginos, agino)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+			error = -EFSCORRUPTED;
+			break;
+		}
+		error = xa_err(xa_store(&seen_aginos, agino, xa_mk_value(1),
+					GFP_NOFS));
+		if (error)
+			break;
+
 		error = xfs_iget(mp, NULL, xfs_agino_to_ino(pag, agino), 0, 0,
 				&ip);
 		if (error)
@@ -2771,8 +2794,9 @@ xlog_recover_iunlink_bucket(
 
 		error2 = xfs_inodegc_flush(mp);
 		if (error2 && !error)
-			return error2;
+			error = error2;
 	}
+	xa_destroy(&seen_aginos);
 	return error;
 }
 
-- 
2.53.0

