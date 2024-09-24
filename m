Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDE51AD9C9;
	Tue, 24 Sep 2024 18:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203164; cv=none; b=l2wA/j8CXrDbGyZeR4lBzfpH2Rsfr5F7patvNI+mLPvu+OQs84g0dYhZs7UkxLKrTXlVqcnDHz2JUY0c+AIJiE/cGD+hvPFijlkjKlq6gZbEkpsgG8pT/5Jlk6aG8lVxa/PLt2Vqt361jdp2SV4r0/rAP+jU9pLKyxLeRB/1F6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203164; c=relaxed/simple;
	bh=pFrUX4LHWjx+Zz4VAmYop1W3UHAZUAJMRacVzDjvOec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meEyjYUkxg6gq78A+eUd3/RMiKVb1DqMkAmPu9efGLlkXt+ZsP/foWuTzpfp674ENyHESfQDyWQaM5xYXhxB86hcXX0o3urLogzHe719qSr5s+gOQJ6hK+U0vrqfduOLNlMkSJ7ZtGAV1zcjQlQxZDVkbJwFY3TfrUUaDI90Vrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KtBJ2QuV; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KtBJ2QuV"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-71b0722f221so451749b3a.3;
        Tue, 24 Sep 2024 11:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203162; x=1727807962; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6UkqPyulwqtKNbTTvS0V1pYpEDlaZdg76rYzAqGAq4Y=;
        b=KtBJ2QuVDkSmoISykVqwVqeTK4QbhXZ9LdAtAiu5GleSqqyqsswigvnvV7228f8plB
         u6SmcqS4YTh8b6/PATbOKbQK/qv9LGJNFgxtuybM0h/3h4abaPCgi4x/TFGwVbx8aBJA
         ZdLdSThpAPqSmmE3QWewewpQHWD7GPshv1PXIryfDwFMto9yR+jDh5wQwm46csfkWjqJ
         Py7sqBlIl9VsgbA1041Zunc47dY+5NjFH8HUsJY71cZnF+K+uFUBNz3HWPJsq2owfSex
         YsudzGjNODc6SIMYZJGOhtSa28E4K4GEQfRDeUNCm7lLuUjywjEKjPSZitWbKWV6kXAD
         4X1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203162; x=1727807962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6UkqPyulwqtKNbTTvS0V1pYpEDlaZdg76rYzAqGAq4Y=;
        b=WWWyiN847P+aWyLbpEGp0icozaQTlZri312z6yAfXEAWPPnuT9WnkkFuz98CNduX+J
         av1kUd65vornEVJMZz37sCOBR531ZkwnEwsQjehmhU0GW9Z1C1iC1x50mlpSy9uMPIPb
         zsxZzveNfxEO2eN9bM6EV8mmZn39tJU5/Kzemu+pcEZWLSmxNlFv9gbARjy71Hq+zeDA
         ygO/+c/U5E2B+TMIpkdYCfwhTODQShBveojgYILKodaDM6hVjdLyYVoIw5h8VC7RQOuy
         J+ErEe0uiYEnRdGRq/CcM6d3jPGAjMkm6fryL4Hx5aj2DYME7b41qNGw0cfgStDi9PQ0
         Amog==
X-Gm-Message-State: AOJu0YzxuOUZHpcxTB39T0HEoaqVZD/EiLALvgVRln0wsD5LLNaBN2HA
	YuMPOdPrYae6oVzBDBGJ7ehoIs+uGXat2h9HZ7axdvHpqRQqlu1q0Ut/SOE2
X-Google-Smtp-Source: AGHT+IHab9K6X7mdTZHgRs6zFjP1xCuGWsigZWi8qeF0s1NNNG7b4yJPZquS7IedzIvO32NmcEkX8A==
X-Received: by 2002:a05:6a21:1693:b0:1cf:4458:8b0d with SMTP id adf61e73a8af0-1d4d4aa962bmr133265637.11.1727203161809;
        Tue, 24 Sep 2024 11:39:21 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:21 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	shrikanth hegde <sshegde@linux.vnet.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 18/26] xfs: load uncached unlinked inodes into memory on demand
Date: Tue, 24 Sep 2024 11:38:43 -0700
Message-ID: <20240924183851.1901667-19-leah.rumancik@gmail.com>
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

[ Upstream commit 68b957f64fca1930164bfc6d6d379acdccd547d7 ]

shrikanth hegde reports that filesystems fail shortly after mount with
the following failure:

	WARNING: CPU: 56 PID: 12450 at fs/xfs/xfs_inode.c:1839 xfs_iunlink_lookup+0x58/0x80 [xfs]

This of course is the WARN_ON_ONCE in xfs_iunlink_lookup:

	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
	if (WARN_ON_ONCE(!ip || !ip->i_ino)) { ... }

From diagnostic data collected by the bug reporters, it would appear
that we cleanly mounted a filesystem that contained unlinked inodes.
Unlinked inodes are only processed as a final step of log recovery,
which means that clean mounts do not process the unlinked list at all.

Prior to the introduction of the incore unlinked lists, this wasn't a
problem because the unlink code would (very expensively) traverse the
entire ondisk metadata iunlink chain to keep things up to date.
However, the incore unlinked list code complains when it realizes that
it is out of sync with the ondisk metadata and shuts down the fs, which
is bad.

Ritesh proposed to solve this problem by unconditionally parsing the
unlinked lists at mount time, but this imposes a mount time cost for
every filesystem to catch something that should be very infrequent.
Instead, let's target the places where we can encounter a next_unlinked
pointer that refers to an inode that is not in cache, and load it into
cache.

Note: This patch does not address the problem of iget loading an inode
from the middle of the iunlink list and needing to set i_prev_unlinked
correctly.

Reported-by: shrikanth hegde <sshegde@linux.vnet.ibm.com>
Triaged-by: Ritesh Harjani <ritesh.list@gmail.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_inode.c | 80 +++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_trace.h | 25 +++++++++++++++
 2 files changed, 100 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b0b4f6ac2397..4e73dd4a4d82 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1829,12 +1829,17 @@ xfs_iunlink_lookup(
 
 	rcu_read_lock();
 	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
+	if (!ip) {
+		/* Caller can handle inode not being in memory. */
+		rcu_read_unlock();
+		return NULL;
+	}
 
 	/*
-	 * Inode not in memory or in RCU freeing limbo should not happen.
-	 * Warn about this and let the caller handle the failure.
+	 * Inode in RCU freeing limbo should not happen.  Warn about this and
+	 * let the caller handle the failure.
 	 */
-	if (WARN_ON_ONCE(!ip || !ip->i_ino)) {
+	if (WARN_ON_ONCE(!ip->i_ino)) {
 		rcu_read_unlock();
 		return NULL;
 	}
@@ -1843,7 +1848,10 @@ xfs_iunlink_lookup(
 	return ip;
 }
 
-/* Update the prev pointer of the next agino. */
+/*
+ * Update the prev pointer of the next agino.  Returns -ENOLINK if the inode
+ * is not in cache.
+ */
 static int
 xfs_iunlink_update_backref(
 	struct xfs_perag	*pag,
@@ -1858,7 +1866,8 @@ xfs_iunlink_update_backref(
 
 	ip = xfs_iunlink_lookup(pag, next_agino);
 	if (!ip)
-		return -EFSCORRUPTED;
+		return -ENOLINK;
+
 	ip->i_prev_unlinked = prev_agino;
 	return 0;
 }
@@ -1902,6 +1911,62 @@ xfs_iunlink_update_bucket(
 	return 0;
 }
 
+/*
+ * Load the inode @next_agino into the cache and set its prev_unlinked pointer
+ * to @prev_agino.  Caller must hold the AGI to synchronize with other changes
+ * to the unlinked list.
+ */
+STATIC int
+xfs_iunlink_reload_next(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agibp,
+	xfs_agino_t		prev_agino,
+	xfs_agino_t		next_agino)
+{
+	struct xfs_perag	*pag = agibp->b_pag;
+	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_inode	*next_ip = NULL;
+	xfs_ino_t		ino;
+	int			error;
+
+	ASSERT(next_agino != NULLAGINO);
+
+#ifdef DEBUG
+	rcu_read_lock();
+	next_ip = radix_tree_lookup(&pag->pag_ici_root, next_agino);
+	ASSERT(next_ip == NULL);
+	rcu_read_unlock();
+#endif
+
+	xfs_info_ratelimited(mp,
+ "Found unrecovered unlinked inode 0x%x in AG 0x%x.  Initiating recovery.",
+			next_agino, pag->pag_agno);
+
+	/*
+	 * Use an untrusted lookup just to be cautious in case the AGI has been
+	 * corrupted and now points at a free inode.  That shouldn't happen,
+	 * but we'd rather shut down now since we're already running in a weird
+	 * situation.
+	 */
+	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
+	error = xfs_iget(mp, tp, ino, XFS_IGET_UNTRUSTED, 0, &next_ip);
+	if (error)
+		return error;
+
+	/* If this is not an unlinked inode, something is very wrong. */
+	if (VFS_I(next_ip)->i_nlink != 0) {
+		error = -EFSCORRUPTED;
+		goto rele;
+	}
+
+	next_ip->i_prev_unlinked = prev_agino;
+	trace_xfs_iunlink_reload_next(next_ip);
+rele:
+	ASSERT(!(VFS_I(next_ip)->i_state & I_DONTCACHE));
+	xfs_irele(next_ip);
+	return error;
+}
+
 static int
 xfs_iunlink_insert_inode(
 	struct xfs_trans	*tp,
@@ -1933,6 +1998,8 @@ xfs_iunlink_insert_inode(
 	 * inode.
 	 */
 	error = xfs_iunlink_update_backref(pag, agino, next_agino);
+	if (error == -ENOLINK)
+		error = xfs_iunlink_reload_next(tp, agibp, agino, next_agino);
 	if (error)
 		return error;
 
@@ -2027,6 +2094,9 @@ xfs_iunlink_remove_inode(
 	 */
 	error = xfs_iunlink_update_backref(pag, ip->i_prev_unlinked,
 			ip->i_next_unlinked);
+	if (error == -ENOLINK)
+		error = xfs_iunlink_reload_next(tp, agibp, ip->i_prev_unlinked,
+				ip->i_next_unlinked);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 5587108d5678..d713e10dff8a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3679,6 +3679,31 @@ TRACE_EVENT(xfs_iunlink_update_dinode,
 		  __entry->new_ptr)
 );
 
+TRACE_EVENT(xfs_iunlink_reload_next,
+	TP_PROTO(struct xfs_inode *ip),
+	TP_ARGS(ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, agino)
+		__field(xfs_agino_t, prev_agino)
+		__field(xfs_agino_t, next_agino)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
+		__entry->prev_agino = ip->i_prev_unlinked;
+		__entry->next_agino = ip->i_next_unlinked;
+	),
+	TP_printk("dev %d:%d agno 0x%x agino 0x%x prev_unlinked 0x%x next_unlinked 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agino,
+		  __entry->prev_agino,
+		  __entry->next_agino)
+);
+
 DECLARE_EVENT_CLASS(xfs_ag_inode_class,
 	TP_PROTO(struct xfs_inode *ip),
 	TP_ARGS(ip),
-- 
2.46.0.792.g87dc391469-goog

