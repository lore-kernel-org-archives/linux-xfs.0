Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0D51AE850;
	Tue, 24 Sep 2024 18:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203172; cv=none; b=GBVuznR7LlY2tzQLt2A2FnaiRrat/+hcLN6SLx9it+D3Xzc3I9bGjxb2n+EI99/IAFHR8Gd7fx+5kvYOkDT6pd1y6MVrJ52OPSBthpj5RHGFeuEMAghEy4K4RHXT+8VW7uCRIE6heA03zHNSG4IO2Z//+1kkpfTsteGOwYDiqrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203172; c=relaxed/simple;
	bh=MJ6LUi4hISTd8UZRPe2I8Sknsxu1sivFQVTG5DDtNI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHbVMM+VmjW9UbnpYM/0x44siB9RusN3iK/ObpHC7Xez9lzLPNSaqcjS+VliC4QuO4Iezyxe+CebyPM4SohFLOliQP8Mwqpf6UH2ADo+qWpTuKdu0PgS5AyvjGi04KFSdn5c/q5CZCuSHtbCAO5JXXlpRt2Vgr1YbMwx9Jt6B7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PrTkBXjK; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PrTkBXjK"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2d88c0f8e79so4688787a91.3;
        Tue, 24 Sep 2024 11:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203170; x=1727807970; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GwHenpa9G1DzD4VLD9ZfYSVIPY3k6s5QJDZYwbzAJLQ=;
        b=PrTkBXjK9OjXvJfxzYDesdJoc6nEpvl/z09qjRKppGYmWqjPhPp4xzBOizvJgzlCCI
         JAda1KPG9pWXHgj5F3rGTEyfD8MDCGYjxHUIrTRjNFSgRRjWZBCrI9AjcvtzWw8MEiVd
         q+ZGV7uMMDgOgMcob6/y9WPfulZQt/YbRhLmlQhT8fz6D1uSSRKa7c/gA1JiNvBLA3qx
         rUVPI7+FO3f8Rh7imYIZu2MoOg6uB7qoKuAd/IaJOQ6TMnvF/B6nkBBG0Ipb/Cvj6SQk
         KyhvqdEAd7KGU5ajGH8Q/Y1uhKcP4idgERg0UkYSqpp2GARKp1p6dV+reUizd7wp+VuR
         phcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203170; x=1727807970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GwHenpa9G1DzD4VLD9ZfYSVIPY3k6s5QJDZYwbzAJLQ=;
        b=YCWcFKjSmz8wNX6rgFhnqmiide59Z/6BWwmsBc37vXiOO/UPW2Fb47cZI6Bo0JhaFn
         ApOw+Tie1hRv8Y9XKGjR5fpGYXX45bgzFnZxbwatbw17vt4rQWuNSoI0oXJGgBNcaxoK
         /eLkO9tGzyBc9lXHipWcj0eRXqiWd+9iIcFzGZpoEcpuNx5XroXbL0hsVlXW7+jEm3Hc
         Sw2deAPwaM0X30F+mvk9BuN2fpdjOcwcQAlvYkk3bmvivmtX5NyMehFf2kgg1CUhFgoc
         vmbh8NFaPRGOnpnN16QBsPvz6JxOP3Bs7TqeGjmkMh+7jllaWuw1WTLzXpNoYF5uV3db
         KdFg==
X-Gm-Message-State: AOJu0YwhnfnrYP3J8ippXiRgMaxXMDGUOojm4djWCPJTWFdzOMEbLFsW
	+yyr94M60sRlrL5VBfkpqJX6Q9ugawfTAPSxkFT7uR25Z3+S9LAeO/3UkqI3
X-Google-Smtp-Source: AGHT+IGCY0k8VvBMPabQgk6LNQvv0O1qgN4RR2JAcnG5TJGmr95yd90Qsv8G+9neTsSlbVWe4CfERQ==
X-Received: by 2002:a17:90b:96:b0:2d8:a672:186d with SMTP id 98e67ed59e1d1-2e06ae7896fmr122247a91.20.1727203170220;
        Tue, 24 Sep 2024 11:39:30 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:29 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 25/26] xfs: fix reloading entire unlinked bucket lists
Date: Tue, 24 Sep 2024 11:38:50 -0700
Message-ID: <20240924183851.1901667-26-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 537c013b140d373d1ffe6290b841dc00e67effaa ]

During review of the patcheset that provided reloading of the incore
iunlink list, Dave made a few suggestions, and I updated the copy in my
dev tree.  Unfortunately, I then got distracted by ... who even knows
what ... and forgot to backport those changes from my dev tree to my
release candidate branch.  I then sent multiple pull requests with stale
patches, and that's what was merged into -rc3.

So.

This patch re-adds the use of an unlocked iunlink list check to
determine if we want to allocate the resources to recreate the incore
list.  Since lost iunlinked inodes are supposed to be rare, this change
helps us avoid paying the transaction and AGF locking costs every time
we open any inode.

This also re-adds the shutdowns on failure, and re-applies the
restructuring of the inner loop in xfs_inode_reload_unlinked_bucket, and
re-adds a requested comment about the quotachecking code.

Retain the original RVB tag from Dave since there's no code change from
the last submission.

Fixes: 68b957f64fca1 ("xfs: load uncached unlinked inodes into memory on demand")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_export.c | 16 +++++++++++----
 fs/xfs/xfs_inode.c  | 48 +++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_itable.c |  2 ++
 fs/xfs/xfs_qm.c     | 15 +++++++++++---
 4 files changed, 61 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index f71ea786a6d2..7cd09c3a82cb 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -146,10 +146,18 @@ xfs_nfs_get_inode(
 		return ERR_PTR(error);
 	}
 
-	error = xfs_inode_reload_unlinked(ip);
-	if (error) {
-		xfs_irele(ip);
-		return ERR_PTR(error);
+	/*
+	 * Reload the incore unlinked list to avoid failure in inodegc.
+	 * Use an unlocked check here because unrecovered unlinked inodes
+	 * should be somewhat rare.
+	 */
+	if (xfs_inode_unlinked_incomplete(ip)) {
+		error = xfs_inode_reload_unlinked(ip);
+		if (error) {
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			xfs_irele(ip);
+			return ERR_PTR(error);
+		}
 	}
 
 	if (VFS_I(ip)->i_generation != generation) {
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 00f41bc76bd7..909085269227 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1744,6 +1744,14 @@ xfs_inactive(
 		truncate = 1;
 
 	if (xfs_iflags_test(ip, XFS_IQUOTAUNCHECKED)) {
+		/*
+		 * If this inode is being inactivated during a quotacheck and
+		 * has not yet been scanned by quotacheck, we /must/ remove
+		 * the dquots from the inode before inactivation changes the
+		 * block and inode counts.  Most probably this is a result of
+		 * reloading the incore iunlinked list to purge unrecovered
+		 * unlinked inodes.
+		 */
 		xfs_qm_dqdetach(ip);
 	} else {
 		error = xfs_qm_dqattach(ip);
@@ -3657,6 +3665,16 @@ xfs_inode_reload_unlinked_bucket(
 	if (error)
 		return error;
 
+	/*
+	 * We've taken ILOCK_SHARED and the AGI buffer lock to stabilize the
+	 * incore unlinked list pointers for this inode.  Check once more to
+	 * see if we raced with anyone else to reload the unlinked list.
+	 */
+	if (!xfs_inode_unlinked_incomplete(ip)) {
+		foundit = true;
+		goto out_agibp;
+	}
+
 	bucket = agino % XFS_AGI_UNLINKED_BUCKETS;
 	agi = agibp->b_addr;
 
@@ -3671,25 +3689,27 @@ xfs_inode_reload_unlinked_bucket(
 	while (next_agino != NULLAGINO) {
 		struct xfs_inode	*next_ip = NULL;
 
+		/* Found this caller's inode, set its backlink. */
 		if (next_agino == agino) {
-			/* Found this inode, set its backlink. */
 			next_ip = ip;
 			next_ip->i_prev_unlinked = prev_agino;
 			foundit = true;
+			goto next_inode;
 		}
-		if (!next_ip) {
-			/* Inode already in memory. */
-			next_ip = xfs_iunlink_lookup(pag, next_agino);
-		}
-		if (!next_ip) {
-			/* Inode not in memory, reload. */
-			error = xfs_iunlink_reload_next(tp, agibp, prev_agino,
-					next_agino);
-			if (error)
-				break;
 
-			next_ip = xfs_iunlink_lookup(pag, next_agino);
-		}
+		/* Try in-memory lookup first. */
+		next_ip = xfs_iunlink_lookup(pag, next_agino);
+		if (next_ip)
+			goto next_inode;
+
+		/* Inode not in memory, try reloading it. */
+		error = xfs_iunlink_reload_next(tp, agibp, prev_agino,
+				next_agino);
+		if (error)
+			break;
+
+		/* Grab the reloaded inode. */
+		next_ip = xfs_iunlink_lookup(pag, next_agino);
 		if (!next_ip) {
 			/* No incore inode at all?  We reloaded it... */
 			ASSERT(next_ip != NULL);
@@ -3697,10 +3717,12 @@ xfs_inode_reload_unlinked_bucket(
 			break;
 		}
 
+next_inode:
 		prev_agino = next_agino;
 		next_agino = next_ip->i_next_unlinked;
 	}
 
+out_agibp:
 	xfs_trans_brelse(tp, agibp);
 	/* Should have found this inode somewhere in the iunlinked bucket. */
 	if (!error && !foundit)
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index ee3eb3181e3e..44d603364d5a 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -80,10 +80,12 @@ xfs_bulkstat_one_int(
 	if (error)
 		goto out;
 
+	/* Reload the incore unlinked list to avoid failure in inodegc. */
 	if (xfs_inode_unlinked_incomplete(ip)) {
 		error = xfs_inode_reload_unlinked_bucket(tp, ip);
 		if (error) {
 			xfs_iunlock(ip, XFS_ILOCK_SHARED);
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 			xfs_irele(ip);
 			return error;
 		}
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index bbd0805fa94e..bd907bbc389c 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1160,9 +1160,18 @@ xfs_qm_dqusage_adjust(
 	if (error)
 		return error;
 
-	error = xfs_inode_reload_unlinked(ip);
-	if (error)
-		goto error0;
+	/*
+	 * Reload the incore unlinked list to avoid failure in inodegc.
+	 * Use an unlocked check here because unrecovered unlinked inodes
+	 * should be somewhat rare.
+	 */
+	if (xfs_inode_unlinked_incomplete(ip)) {
+		error = xfs_inode_reload_unlinked(ip);
+		if (error) {
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			goto error0;
+		}
+	}
 
 	ASSERT(ip->i_delayed_blks == 0);
 
-- 
2.46.0.792.g87dc391469-goog

