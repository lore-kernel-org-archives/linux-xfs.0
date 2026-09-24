Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E6649B5CC
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 15:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790263010; cv=none; b=guUPU7m8QhJUQfjdrk8J1yHb31bjnG/O7EIsALaJ4AS1EIkJdodu/pUEIIRZuwyI4GtYvUNPfj8waCr4cRpaVcCSpIAEdFJ2seumnrV7TOnKUcA7k/+d2FKOnqwameMEif4RjCwgL6yNGeNRI43YjlpwQRdFUYT2zOBb+sOLGB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790263010; c=relaxed/simple;
	bh=bovkaLwDonl5aCDuv1IZGQYE2PIO82UsvxPPcOy3NTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPv5HjrUyWSx89VtnG5h5aqv98g+S0grVZSV3DZYe0nCJGcEPJu38bpUo0Ld3IzKtMDW6os7B6iXOskj8PssRd07eiifP4tn2RUa4Rj15UYcMRm3Z5yq8B8vAcW/lxaGC6WeNb7NPmzM59FYsZ3pKbWC22ntaV3Oh9iZL+nRnk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SYN1guI3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SYN1guI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D741F000FF;
	Thu, 24 Sep 2026 15:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790263009;
	bh=Obr0RXWOCTQobOYR11uNBV1bvLw5rBHtAMzMw0jzR0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SYN1guI3XZ/lV5vV0wUUA9lch0i5Lg9vBqifGGEn+Educ44V8Xi9XZLasuCCNjuCF
	 Dfdg3/SBNF2wZ7jtQsP3WP6YNHxuYXhH0Q7zp4hGh7GHkuFLIpSL32ANIq3fGNufUn
	 0FGCd/5P4VjYlvUFRUFb2DT0wd4Y7+F6YN2+nAcVLmWjQbQT9D3UJlDp9tCKkAYD3f
	 aE/fT1eLBUzg2489OmXyFSkvyx4U/gLRisIVtoAKxgvu1jxYnogackSVREEyAXEJxA
	 hLZzttYVGeyIddfGeytUUL8PJvyNMQ2WEFvDGnkIVg3BKSqnkz/iDse6zqYh1IKW6p
	 F1SlKcyKxpg9A==
From: cem@kernel.org
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@lst.de,
	djwong@kernel.org,
	sandeen@sandeen.net
Subject: [PATCH v4 2/3] xfs: introduce xfs_trans_cancel_error()
Date: Thu, 24 Sep 2026 17:16:29 +0200
Message-ID: <20260924151638.38535-3-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924151638.38535-1-cem@kernel.org>
References: <20260924151638.38535-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Once in a while it's useful to know exactly what kind of error caused a
transaction to be cancelled. Currently xfs_trans_cancel() is unable to
print out this information. So rename old xfs_trans_cancel to
xfs_trans_cancel_error() which will accept an error code to be printed
and add a new inline xfs_trans_cancel() to be used on places where an
error number report is not explicitly needed (and also avoid dozens of
file modifications to the new API).

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
V4:
	- Remove macros in lieu of an inline function
	- Rename patch to a better description
V3:
	- Kill typedef from __xfs_trans_cancel
	- Remove uneeded wrap of parameter 0

 fs/xfs/xfs_trans.c | 8 +++++---
 fs/xfs/xfs_trans.h | 9 ++++++++-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 5c522790e5be..8f0c308f312f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -943,8 +943,9 @@ xfs_trans_commit(
  * xfs_trans_commit().
  */
 void
-xfs_trans_cancel(
-	struct xfs_trans	*tp)
+xfs_trans_cancel_error(
+	struct xfs_trans	*tp,
+	int			error)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xlog		*log = mp->m_log;
@@ -971,7 +972,8 @@ xfs_trans_cancel(
 	 * here.
 	 */
 	if (dirty && !xfs_is_shutdown(mp)) {
-		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, 0, mp);
+		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW,
+				 error, mp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	}
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index eb83c5dac032..edb0cfff4d3c 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -237,7 +237,7 @@ void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
 int		xfs_trans_commit(struct xfs_trans *);
 int		xfs_trans_roll(struct xfs_trans **);
 int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
-void		xfs_trans_cancel(xfs_trans_t *);
+void		xfs_trans_cancel_error(struct xfs_trans *, int);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
 
@@ -280,4 +280,11 @@ xfs_trans_clear_context(
 	memalloc_nofs_restore(tp->t_pflags);
 }
 
+static inline void
+xfs_trans_cancel(
+	struct xfs_trans	*tp)
+{
+	return xfs_trans_cancel_error(tp, 0);
+}
+
 #endif	/* __XFS_TRANS_H__ */
-- 
2.55.0

