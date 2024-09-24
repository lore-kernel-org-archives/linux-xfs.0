Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B935C11CA0;
	Tue, 24 Sep 2024 18:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203170; cv=none; b=T5aoLaaSV8nz8BSPs8+oyLmoSKI1AOLyLA95rTV780+Dba66s0pH/tBfW3aGCZtaFFS8ekl+KE2/KR37clVmzTvSq4FxIl1DVrwp8Y2UKFrrQQWeU+ogDJpu5MbZF0kxPuH1jqhHeg5iTbzauXVlExOPPoNt1mtXE7Jck8lsg/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203170; c=relaxed/simple;
	bh=q+UPFJGYT8nxbelhuMllsIqBuCBZNZmx9ZwJftIMsOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7eHUEevgCNhEYj3dklyteyA/UVsgZBbWjBblmCNca1uRa6bmHaRGKvrsJGzBGtN6lPqV3GHxVEQbVa0uwmVUTW3NHnT5EqoH56cb/88iqZCHazD+qkDkgbDXgtnK7jHJFVwYo+xnfNXk0iP7oLkXjeiKgABMJZsX+diByHKIJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aRZZRiWs; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aRZZRiWs"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2d8b68bddeaso4672450a91.1;
        Tue, 24 Sep 2024 11:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203168; x=1727807968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ebsEMFRoJLREm1Uxmlgwzjc+nX6q5GCxsem7KjM+c2E=;
        b=aRZZRiWsbdNRxTeW7a+HPSzaDMxbO7eJToUjgeJe0gdxP8PWo+4+O61yGwffPS8dXi
         6hgXDesD6A3mQaspUh+BH8JoQ/KOzxBQm3Ozz6WJxl+45wl6Uc/VWmEqFrySQlzMv7+1
         FtosiMid/Ojpnu0vAuk1a/EoWgR8WdALaIwXV9zQ/WHKbpVAe1/x3JHoXRwWBFf2P7C1
         sFoSBqBb7xBRFMnOHGDFeyuXb2p4/ODj4lTiDvxeHRS/DA+9p+lHtORaDdTLCprYcOHw
         cbpszaKrxTwGbdfO/s/oci02NSqg62uYM0SWbblEaqfUeJH9CNyKAW2GTJX4lS8n+opu
         8gnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203168; x=1727807968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ebsEMFRoJLREm1Uxmlgwzjc+nX6q5GCxsem7KjM+c2E=;
        b=HpjA9sPkO5UYTCSjL/42rdZX3XELSKnZwe/USddj+pRKDjhckcXwVybXmpc1AmSzmm
         enJZttDXhorkjMUIpQMzzs7zEtGlmzxHCkoAW5qTvFRT9CD4WItVNYkYjLqm2EeIlejY
         rPynoMLs1Bj+ESM+XwtmsZtLcBUqO1/42BgTtgWGoyN7v9yaolHlWqWrJNy856WpF6nb
         oRRV21Gl99E4L/klJln6G0e6OVMo3njqnVrWyN+yyQkayVIbDwD273FCEcSX4c2Qwjvx
         kOCuyI+R+ESryPHVAtct63GIhIRhvNd/rP7VKqUsNqI8gSBu/HAoJQvddf0LnS+aIMlD
         hJlQ==
X-Gm-Message-State: AOJu0YznVVsQr309TACAgjXe7oZb1z6a0Cga1qQzSxxJGof3Cabn3kXk
	ZHEg4Hh+qjW/xjZGMICldlJlKRnwmNmUtpYC89Ik9Y0KM5GaD5rp4XhNbPAr
X-Google-Smtp-Source: AGHT+IGiKY4bWh1IYhcQaSSPGyGqCzXDsmMEl8qM8+jN6owT06xTsNH/nsHQScgb/BZgHbs6xdjOeA==
X-Received: by 2002:a17:90b:1651:b0:2d8:8ab3:2889 with SMTP id 98e67ed59e1d1-2e06ae53a33mr111268a91.11.1727203167788;
        Tue, 24 Sep 2024 11:39:27 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:27 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 23/26] xfs: reload entire unlinked bucket lists
Date: Tue, 24 Sep 2024 11:38:48 -0700
Message-ID: <20240924183851.1901667-24-leah.rumancik@gmail.com>
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

[ Upstream commit 83771c50e42b92de6740a63e152c96c052d37736 ]

The previous patch to reload unrecovered unlinked inodes when adding a
newly created inode to the unlinked list is missing a key piece of
functionality.  It doesn't handle the case that someone calls xfs_iget
on an inode that is not the last item in the incore list.  For example,
if at mount time the ondisk iunlink bucket looks like this:

AGI -> 7 -> 22 -> 3 -> NULL

None of these three inodes are cached in memory.  Now let's say that
someone tries to open inode 3 by handle.  We need to walk the list to
make sure that inodes 7 and 22 get loaded cold, and that the
i_prev_unlinked of inode 3 gets set to 22.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_export.c |   6 +++
 fs/xfs/xfs_inode.c  | 100 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h  |   9 ++++
 fs/xfs/xfs_itable.c |   9 ++++
 fs/xfs/xfs_trace.h  |  20 +++++++++
 5 files changed, 144 insertions(+)

diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 1064c2342876..f71ea786a6d2 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -146,6 +146,12 @@ xfs_nfs_get_inode(
 		return ERR_PTR(error);
 	}
 
+	error = xfs_inode_reload_unlinked(ip);
+	if (error) {
+		xfs_irele(ip);
+		return ERR_PTR(error);
+	}
+
 	if (VFS_I(ip)->i_generation != generation) {
 		xfs_irele(ip);
 		return ERR_PTR(-ESTALE);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8c1782a72487..06cdf5dd88af 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3622,3 +3622,103 @@ xfs_iunlock2_io_mmap(
 	if (ip1 != ip2)
 		inode_unlock(VFS_I(ip1));
 }
+
+/*
+ * Reload the incore inode list for this inode.  Caller should ensure that
+ * the link count cannot change, either by taking ILOCK_SHARED or otherwise
+ * preventing other threads from executing.
+ */
+int
+xfs_inode_reload_unlinked_bucket(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_buf		*agibp;
+	struct xfs_agi		*agi;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	xfs_agino_t		prev_agino, next_agino;
+	unsigned int		bucket;
+	bool			foundit = false;
+	int			error;
+
+	/* Grab the first inode in the list */
+	pag = xfs_perag_get(mp, agno);
+	error = xfs_ialloc_read_agi(pag, tp, &agibp);
+	xfs_perag_put(pag);
+	if (error)
+		return error;
+
+	bucket = agino % XFS_AGI_UNLINKED_BUCKETS;
+	agi = agibp->b_addr;
+
+	trace_xfs_inode_reload_unlinked_bucket(ip);
+
+	xfs_info_ratelimited(mp,
+ "Found unrecovered unlinked inode 0x%x in AG 0x%x.  Initiating list recovery.",
+			agino, agno);
+
+	prev_agino = NULLAGINO;
+	next_agino = be32_to_cpu(agi->agi_unlinked[bucket]);
+	while (next_agino != NULLAGINO) {
+		struct xfs_inode	*next_ip = NULL;
+
+		if (next_agino == agino) {
+			/* Found this inode, set its backlink. */
+			next_ip = ip;
+			next_ip->i_prev_unlinked = prev_agino;
+			foundit = true;
+		}
+		if (!next_ip) {
+			/* Inode already in memory. */
+			next_ip = xfs_iunlink_lookup(pag, next_agino);
+		}
+		if (!next_ip) {
+			/* Inode not in memory, reload. */
+			error = xfs_iunlink_reload_next(tp, agibp, prev_agino,
+					next_agino);
+			if (error)
+				break;
+
+			next_ip = xfs_iunlink_lookup(pag, next_agino);
+		}
+		if (!next_ip) {
+			/* No incore inode at all?  We reloaded it... */
+			ASSERT(next_ip != NULL);
+			error = -EFSCORRUPTED;
+			break;
+		}
+
+		prev_agino = next_agino;
+		next_agino = next_ip->i_next_unlinked;
+	}
+
+	xfs_trans_brelse(tp, agibp);
+	/* Should have found this inode somewhere in the iunlinked bucket. */
+	if (!error && !foundit)
+		error = -EFSCORRUPTED;
+	return error;
+}
+
+/* Decide if this inode is missing its unlinked list and reload it. */
+int
+xfs_inode_reload_unlinked(
+	struct xfs_inode	*ip)
+{
+	struct xfs_trans	*tp;
+	int			error;
+
+	error = xfs_trans_alloc_empty(ip->i_mount, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	if (xfs_inode_unlinked_incomplete(ip))
+		error = xfs_inode_reload_unlinked_bucket(tp, ip);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	xfs_trans_cancel(tp);
+
+	return error;
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c0211ff2874e..0467d297531e 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -593,4 +593,13 @@ void xfs_end_io(struct work_struct *work);
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 
+static inline bool
+xfs_inode_unlinked_incomplete(
+	struct xfs_inode	*ip)
+{
+	return VFS_I(ip)->i_nlink == 0 && !xfs_inode_on_unlinked_list(ip);
+}
+int xfs_inode_reload_unlinked_bucket(struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_inode_reload_unlinked(struct xfs_inode *ip);
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index a1c2bcf65d37..ee3eb3181e3e 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -80,6 +80,15 @@ xfs_bulkstat_one_int(
 	if (error)
 		goto out;
 
+	if (xfs_inode_unlinked_incomplete(ip)) {
+		error = xfs_inode_reload_unlinked_bucket(tp, ip);
+		if (error) {
+			xfs_iunlock(ip, XFS_ILOCK_SHARED);
+			xfs_irele(ip);
+			return error;
+		}
+	}
+
 	ASSERT(ip != NULL);
 	ASSERT(ip->i_imap.im_blkno != 0);
 	inode = VFS_I(ip);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d713e10dff8a..0cd62031e53f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3704,6 +3704,26 @@ TRACE_EVENT(xfs_iunlink_reload_next,
 		  __entry->next_agino)
 );
 
+TRACE_EVENT(xfs_inode_reload_unlinked_bucket,
+	TP_PROTO(struct xfs_inode *ip),
+	TP_ARGS(ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, agino)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
+	),
+	TP_printk("dev %d:%d agno 0x%x agino 0x%x bucket %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agino,
+		  __entry->agino % XFS_AGI_UNLINKED_BUCKETS)
+);
+
 DECLARE_EVENT_CLASS(xfs_ag_inode_class,
 	TP_PROTO(struct xfs_inode *ip),
 	TP_ARGS(ip),
-- 
2.46.0.792.g87dc391469-goog

