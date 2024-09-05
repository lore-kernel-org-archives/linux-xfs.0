Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DD214F125
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560532; cv=none; b=qI+PtTelV/e+93c3K7IiW0iNyZq1btm/6VGbrnPlKCqbEPG1YMCGmbedcJDdRHkbRNkNLr/aN+3Ip2hJMsEPGHf/nv9pA9DDaZ+aIN4pSBVgGE8+ibU4wMvOLWNKGnCB8yd0y9zxiwLqXLebFa1JMMDXMk1bqmhWkHhyf4ekl/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560532; c=relaxed/simple;
	bh=KqYz84tmSCy/z6xkkil2O4E6expuu5CUt8rD6eBjTkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2a7vQG8qNXLwXigq3LZL3K1weBBKTv3dD4hXzhFMV6BPZJ/jF6kdKTuI25h7ANVyyCZWFxMMu0TtMpRmdXCRnCSitQXDI9TSHv2QB6R5R1d7xEDvl2J0q/gsHCXFj/qIC7BJf6nM3njYC6zuMbTWbc3JSTSZa+wiN9XrYgWrOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SZb8JRrQ; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SZb8JRrQ"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2054feabfc3so11511795ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560530; x=1726165330; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RXzf8GYMsUYplRQbR78A5sW8oXfJhyD/P6ow/XfogSA=;
        b=SZb8JRrQ6ZxTEWqIfERYdRoNLitqmADGmc8hT0WEobhq9nRmbWF19C5bKvfXnsWdLN
         fxqVqjm/6bikHcFctgqlO8XCZMZZwb9dpZWgY6XjmOHFw+SMHPSLbQ9PRCW7TEyMjYtk
         rCkwlQacCFkoUPWLTdYzBrEMAtrNgO3+TfNs15uc1DmTE+u0o1xGeoHaxy6aqjyD+tQM
         YybWpthKl6uvNtmxceNq49a7FnyWi0TDHs3Fnfj/UKdZMzJ0LJ3vhjHVBdsCvzr/gmWs
         khgiJTQyTyGejYmRcK8f4Lnb20uHbZyMP7DSeNfMimoJ0LeLVgShnUuhURraZLbgerFQ
         vulg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560530; x=1726165330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RXzf8GYMsUYplRQbR78A5sW8oXfJhyD/P6ow/XfogSA=;
        b=L08usn/mbxCOeIjjpX/g091EO3+bypTU/Pei54ByJXhcqs7WM+AELMHxTE5FrrzMNj
         GRLnyAfKESrCJiWkNtpPuimwz1CHaBuO/jnSrG91RXLhdzhRufNoHjqt6l+4rtc2ch3l
         ymHV0CTXiFMaY67f9QKCdWFqi1H6wzRqSsM6P/NO2TYtAwJbunUf/+Rn7/pbSz1zOgK5
         pUtzmVumCGlTIhaUEqMVXvG9EgEFPcDHswTNnFyVcyFX7c0qXvJ6PlbKr2YNCul+FGJ1
         6TqbInpe6z9NOs0zpqQjxRCnyNaoY6Ogjq7vTH2FW3nWcdvy3XncWjS05HLTyixOJGRa
         A8qw==
X-Gm-Message-State: AOJu0YwOc4RUrdRzprq7Gch3v2pgTX0XWzBF8W4CxM+gt2IK3G17lor2
	4RcW9Uj7qcR8GZPxbe+rSVldEekW5yZ9wqX7s+Xt2S7iv59KuKxVv4lYzBJd
X-Google-Smtp-Source: AGHT+IGclMqWI6gBJOUZoYTsmLNJWXCA7Qu70UTn/e+66hTamoUpcjHizcLjz1BjpGA0l4cVUsqI7w==
X-Received: by 2002:a17:902:e804:b0:201:f6e8:637f with SMTP id d9443c01a7336-205443de91emr225080975ad.11.1725560530023;
        Thu, 05 Sep 2024 11:22:10 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:22:09 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	shrikanth hegde <sshegde@linux.vnet.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 18/26] xfs: load uncached unlinked inodes into memory on demand
Date: Thu,  5 Sep 2024 11:21:35 -0700
Message-ID: <20240905182144.2691920-19-leah.rumancik@gmail.com>
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
2.46.0.598.g6f2099f65c-goog

