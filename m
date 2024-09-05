Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA271865FD
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560539; cv=none; b=ho0ILJ5BV+Nx5vEA21J5qnuya3/sYijdPz5W9HBSwVZ1hmeK5tTEFWBpGG6l1S0zjOPyj/DxAIhVuoNMuG7QJQXKSKLAT7CZHFKKDkeFxKjPFcPzZLO9TCHiWoewrE1flFkrskyB23MGggVbOF1087XGx4TBiY/zGVfyF/d3Ces=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560539; c=relaxed/simple;
	bh=DE33W2lACSLqnBxC0KOo+jaY7ChgXD+BTwIU/dYGiq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBNtn5qygJlqlR7o5L/sR9OhVkwL4U9ZhfEDKdZkC3+9MXJWWDfrz3qql5uCAeenXbmS2v3LF417KgdSzlyhr4b/dyVm2Z5aktr2QYa7t84WBQtMPnX/GJsvj4/eJfzHQ2/WBWEHn9QpxwNkUN2wxK0pfqwuI19Nqe/GtiH0tVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JFgGI+Vk; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JFgGI+Vk"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7142e002aceso882265b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560537; x=1726165337; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XJXUjYs4PDv5CRJo9yYsxX66rUy+LfcpfqB8jNGeelo=;
        b=JFgGI+VkqgVoHm6Uj3+Rn/Z0X+SRS8oGQX5R6O7leQFfjxdAiJCkM4ziHZAF5AxO4y
         8+J2kHbt3owC4wHI5hS+zAxy1VRV7WTno9QqZJyvg8ihDf/o0FzultWkyNeVGYwIkAxd
         9SHJKjPdkg64Wiez4BNtH1sNnGX7FPA9QKdY78DvQtg54AaZLTLFtdHGL0B5gcguTwl9
         RHwTNrMWjTsQoZt70jZc3kz7dl7gMkNWHj82sSUMPqn6GOZdT1zTgvmPsBV32i4xIuIA
         JjldFiP2pSyND7xf1ZsU4EypqSPSDLwF91v4YmInDASKCkch47ETgIH3RxSLgx8HzHKU
         jERw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560537; x=1726165337;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XJXUjYs4PDv5CRJo9yYsxX66rUy+LfcpfqB8jNGeelo=;
        b=YdHgo86VwMOLe8nAMDfKxKrw/sdyNyawqehE256j3wZ7rerG8WWFtTBTLihix+MFup
         13iRzxNmtaHiw9lKWZqUnIgQK+5oMhA/4TEjSD2wT+InXNOvthBa6v4mRsId7waN+f4J
         lHXgLFUkhEx4C2jpnOYWlmZdxlX9+GiLmK+DlVF/CrxJu1YpFCa08k0LFwsKC4jSWnjg
         5vBHCP9o8KIBNoHeyQyPfBvYrbC6hxFLSJh6LXpm3CCWx9wvPM9S+7S92cEivMEH5L1I
         J1JAUX5z3MoWPmSR6hLVDUEAKdZTGT9hVP29US/2U0lTjvaGVMwPX6FTe+buaHI752H2
         bpyA==
X-Gm-Message-State: AOJu0Yxm+RRdu9OaIyQgwS018sK0VofvIsAaExMiZN3xySAfGfLg98ac
	Ej3CiLQfv6++3kHHqRBr6GSQJJcTMXUJ0hwgP8ZM0MP7E+gxN7jJDk1JG16B
X-Google-Smtp-Source: AGHT+IFW8foc47K1zsuAbH99wQRiayPg1z1xYVPi7qEb4zbOX+EixvofL6JoHJCjmpJS+mIPxxFUEg==
X-Received: by 2002:a17:902:e74e:b0:206:bbaa:84e7 with SMTP id d9443c01a7336-206bbaa92afmr77695215ad.40.1725560537156;
        Thu, 05 Sep 2024 11:22:17 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:22:16 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 25/26] xfs: fix reloading entire unlinked bucket lists
Date: Thu,  5 Sep 2024 11:21:42 -0700
Message-ID: <20240905182144.2691920-26-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905182144.2691920-1-leah.rumancik@gmail.com>
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
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
2.46.0.598.g6f2099f65c-goog

