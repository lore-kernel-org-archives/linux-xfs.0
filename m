Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE94638AC85
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 19:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784316273; cv=none; b=CJYf2gtlrOQ2Ur+6DQqYn4jo7kBVQ4adx2bZ2RPZ5lVWBR9ubIDJnO1SiemMtiX/HGTNt5fBLgONFNezEVVWZWhuC6lIiABkhWgyovD/U5/2cr3CzQZGU/ObBmCfZgobW09HhnJ0yE17wEIeqY/V016EVBPTQfTjtKpp5pE3ZVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784316273; c=relaxed/simple;
	bh=EG69EPkO7N62BjoL+8oQ9HiwnjhLDWKjuYf3qchcwVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NB7XWqTw7fqIGC2K229juHjq9P9HczIoD1q3nu4aoSx6f2njEL3jCYWR924JIIq4nZxoywyU1CyMaLwB63xb5YgiJjZG55jLMPrDlYUiACsIuG+sUwQpJaGf13s+XPMoyLwkmlVgGJu2zgLzpHwo7WrtVfu9S6Kv6BIhsbcoMeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G0jR1IdH; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G0jR1IdH"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38e58034d05so416082a91.2
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 12:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784316269; x=1784921069; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DuWe98bSxDVP2YNkxgoDo5czOZmzPaVlyD3OHz/X3MY=;
        b=G0jR1IdHWs8zsjNPNtmZJj2davz4nQv3DKJgMTU/wr7jrspIaJvNtia2pcejcmGW25
         6P+vEAuOdT94pks/ooVzmxZIaTTXQ42M7lHqJZeB486mz8VfugwuriUqO84AIbzAh51O
         v6W4tYx9CaZf9DdUQDGklr1FMZoWsq9d+9zvyFtT5DzWw29/eLLU7hMUt4YEnsuSFZDf
         Ou18qDY6fh296z5bdUwD7hbBzcbDl8lNzvj5BRTHFYf9YQDRBZ9j7OxBUqjFd01NC35a
         ip5P6MTmn4wYwZrUTb0GDsSBdh9zW7W3zLqwPP8fFAZ9LI/jW5gofN77rHAn05y243PV
         8lgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784316269; x=1784921069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DuWe98bSxDVP2YNkxgoDo5czOZmzPaVlyD3OHz/X3MY=;
        b=fEPhiZSJohZRcAJubtkGAZ/dRQSAFtBtT2Wy3g6T6SboijmoCf9zDKEzrHYXGt6igE
         yk0CXWdpTUMVGpzPzNZaLWYrYXqhzI5fucmKTIKSSyV7X4sGhAt51crXB1nl0kRGu6H/
         vD+x1cWGFfBYmmBqCv9tBtx8/XfqbWlKj498flq6+lfWDJA9nWHF2lmclUfLTAWaf0yd
         Aa4WCVhTxzTX2UDM3R7JzGSMcO76YW3sSGckbACPbcFI/pAmEsiPAw78wr9nh5m1mOx+
         VEjgoVq/ahlOjnMn6xgR9CBlh1JUDe9JafSG2ceALjHvFlJak0uxMiIHItr7gAhf/3tY
         JL6g==
X-Gm-Message-State: AOJu0YxD91xlVw6I3NiY9Vi/HARkFNeZ10V26JH7p1eOahQHh7hX+/x0
	DP4dfm24/gJxt+bhmlwG5hmwqpxXQUjRdC/W5/WuvSLcsx0NGafT1zKPBzBfxEqsXfU=
X-Gm-Gg: AfdE7cmwbve/RddrblgGg6K9YjN4F4khfOErckq6jMYiMbcT9u8Ub0ye0bgPxyJv6Gx
	5TV0wPYScE5c8V5kxc9Bb+CLyIkaeYpcuPF54Ee8a9SEk+MZETmMNpWuQ/EO+rTLWErTucZRZBu
	GamywtDhLdCnRy6WZSKqCSOF62D/I2OqZC6DUAqHS7JvdocwThoo1nYfTd3FIg/IfM2seeyBoRN
	XIdcP2VNoxdxpnV3xCGKOLlBHhPBBfR9z5eT0kj1Mk6DJzA+jzFY7TIDWRWsTAoIKvhvBgmlOhT
	H8j0S8kvaTIZMGV95ZZ56hbCdFKT57PR0iFQ2NlcRGiq4AluEKFofR/mKC8/tUcNB3LRRVLqpDJ
	xWbmFvne1MCYrcKq/t5cNHgUdaLKsE2FQKSQEh4p0PVgrP4BM969jS/XM2LgkmkAZahxAB8tFHc
	uHdIUmXaAIbrjd04Pj3JpuINXImAWLQ6ouTo91LdAm5UlaO/M=
X-Received: by 2002:a17:90a:dfcc:b0:366:3517:1aa2 with SMTP id 98e67ed59e1d1-38e4b24d8ddmr4182562a91.0.1784316269321;
        Fri, 17 Jul 2026 12:24:29 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1dde81sm18648783eec.21.2026.07.17.12.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 12:24:28 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xmei5@asu.edu,
	Weiming Shi <bestswngs@gmail.com>,
	Dave Chinner <dgc@kernel.org>
Subject: [PATCH v2 2/2] xfs: verify recovered inode log items in pass1
Date: Fri, 17 Jul 2026 12:24:08 -0700
Message-ID: <20260717192408.109168-3-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260717192408.109168-1-bestswngs@gmail.com>
References: <20260717192408.109168-1-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Log recovery mixes validation of a recovered inode item's formatted
structures into the pass2 decode and replay code, one open-coded check at
a time. That is hard to read and audit for what is still unchecked, and it
runs after the item has already been sorted and read ahead in earlier
passes.

Add a verifier layer to journal recovery: a new
xlog_recover_item_ops->verify() method that validates an item's formatted
log structures, called in pass1 for every item after the generic region
checks. Add the first verifier, for inode items:
xlog_recover_inode_verify() checks in one place that the core and each fork
region implied by ilf_fields is declared, that the log dinode is present
and large enough, that its version matches the mount, that di_forkoff is
within the literal area, and that the verbatim-copied fork regions fit
their destination fork.

Because those log dinode checks now run in pass1, drop the equivalent
open-coded checks (the log dinode magic and the dead di_forkoff bound) from
xlog_recover_inode_commit_pass2(). The checks that need the on-disk inode
buffer (its magic, the LSN and di_flushiter replay-ordering decisions, the
di_mode/di_format consistency, and the final xfs_dinode_verify()) cannot be
hoisted and stay in pass2.

This only covers the self-contained log dinode structure. The btree-root
fork formats are converted from a larger in-core form on replay and their
record count is not yet bounded here; clamping xfs_bmbt_to_bmdr() and the
rt btree converters against the destination fork is left as follow-up.
Further item types can grow their own verify() method the same way.

Suggested-by: Dave Chinner <dgc@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |  3 ++
 fs/xfs/xfs_inode_item_recover.c | 87 +++++++++++++++++++++++++++------
 fs/xfs/xfs_log_recover.c        |  5 ++
 3 files changed, 79 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 9e712e62369c..327a4a9c5fbe 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -33,6 +33,9 @@ struct xlog_recover_item_ops {
 	 */
 	enum xlog_recover_reorder (*reorder)(struct xlog_recover_item *item);
 
+	/* Validate the item's log structures in pass1, if provided. */
+	int (*verify)(struct xlog *log, struct xlog_recover_item *item);
+
 	/* Start readahead for pass2, if provided. */
 	void (*ra_pass2)(struct xlog *log, struct xlog_recover_item *item);
 
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 169a8fe3bf0a..277267f722aa 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -367,13 +367,6 @@ xlog_recover_inode_commit_pass2(
 		goto out_release;
 	}
 	ldip = item->ri_buf[1].iov_base;
-	if (XFS_IS_CORRUPT(mp, ldip->di_magic != XFS_DINODE_MAGIC)) {
-		xfs_alert(mp,
-			"%s: Bad inode log record, rec ptr "PTR_FMT", ino %lld",
-			__func__, item, in_f->ilf_ino);
-		error = -EFSCORRUPTED;
-		goto out_release;
-	}
 
 	/*
 	 * If the inode has an LSN in it, recover the inode only if the on-disk
@@ -462,15 +455,6 @@ xlog_recover_inode_commit_pass2(
 	if (error)
 		goto out_release;
 
-	if (unlikely(ldip->di_forkoff > mp->m_sb.sb_inodesize)) {
-		XFS_CORRUPTION_ERROR("Bad log dinode fork offset",
-				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
-		xfs_alert(mp,
-			"Bad inode 0x%llx, di_forkoff 0x%x",
-			in_f->ilf_ino, ldip->di_forkoff);
-		error = -EFSCORRUPTED;
-		goto out_release;
-	}
 	isize = xfs_log_dinode_size(mp);
 	if (unlikely(item->ri_buf[1].iov_len > isize)) {
 		XFS_CORRUPTION_ERROR("Bad log dinode size", XFS_ERRLEVEL_LOW,
@@ -597,8 +581,79 @@ xlog_recover_inode_commit_pass2(
 	return error;
 }
 
+/*
+ * Validate an inode log item's log dinode structure in pass1 so pass2 need
+ * not re-check it; buffer-dependent checks stay in pass2.
+ */
+STATIC int
+xlog_recover_inode_verify(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_inode_log_format	*in_f;
+	struct xfs_inode_log_format	in_f_buf;
+	struct xfs_log_dinode		*ldip;
+	unsigned int			litino = XFS_LITINO(mp);
+	unsigned int			dsize, asize;
+	int				attr_index;
+	int				error;
+
+	if (item->ri_buf[0].iov_len == sizeof(struct xfs_inode_log_format)) {
+		in_f = item->ri_buf[0].iov_base;
+	} else {
+		in_f = &in_f_buf;
+		error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
+		if (error)
+			return error;
+	}
+
+	/* The inode core is always logged as the log dinode in ri_buf[1]. */
+	if (XFS_IS_CORRUPT(mp, in_f->ilf_size < 2) ||
+	    XFS_IS_CORRUPT(mp,
+			   item->ri_buf[1].iov_len < xfs_log_dinode_size(mp)))
+		return -EFSCORRUPTED;
+
+	ldip = item->ri_buf[1].iov_base;
+	if (XFS_IS_CORRUPT(mp, ldip->di_magic != XFS_DINODE_MAGIC) ||
+	    XFS_IS_CORRUPT(mp, !xfs_dinode_good_version(mp, ldip->di_version)) ||
+	    XFS_IS_CORRUPT(mp, ldip->di_forkoff >= (litino >> 3)))
+		return -EFSCORRUPTED;
+
+	if (ldip->di_forkoff) {
+		dsize = ldip->di_forkoff << 3;
+		asize = litino - (ldip->di_forkoff << 3);
+	} else {
+		dsize = litino;
+		asize = 0;
+	}
+
+	/*
+	 * Btree-root forks are logged in a larger in-core form and converted on
+	 * replay, so their region is not bounded by the on-disk fork size here.
+	 */
+	if (in_f->ilf_fields & XFS_ILOG_DFORK) {
+		if (XFS_IS_CORRUPT(mp, in_f->ilf_size < 3))
+			return -EFSCORRUPTED;
+		if ((in_f->ilf_fields & XFS_ILOG_DFORK) != XFS_ILOG_DBROOT &&
+		    XFS_IS_CORRUPT(mp, item->ri_buf[2].iov_len > dsize))
+			return -EFSCORRUPTED;
+	}
+	if (in_f->ilf_fields & XFS_ILOG_AFORK) {
+		attr_index = (in_f->ilf_fields & XFS_ILOG_DFORK) ? 3 : 2;
+		if (XFS_IS_CORRUPT(mp, in_f->ilf_size < attr_index + 1))
+			return -EFSCORRUPTED;
+		if ((in_f->ilf_fields & XFS_ILOG_AFORK) != XFS_ILOG_ABROOT &&
+		    XFS_IS_CORRUPT(mp, item->ri_buf[attr_index].iov_len > asize))
+			return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
 const struct xlog_recover_item_ops xlog_inode_item_ops = {
 	.item_type		= XFS_LI_INODE,
+	.verify			= xlog_recover_inode_verify,
 	.ra_pass2		= xlog_recover_inode_ra_pass2,
 	.commit_pass2		= xlog_recover_inode_commit_pass2,
 };
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5250d512a392..252e7f5cbd47 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2059,6 +2059,11 @@ xlog_recover_commit_trans(
 
 		switch (pass) {
 		case XLOG_RECOVER_PASS1:
+			if (item->ri_ops->verify) {
+				error = item->ri_ops->verify(log, item);
+				if (error)
+					break;
+			}
 			if (item->ri_ops->commit_pass1)
 				error = item->ri_ops->commit_pass1(log, item);
 			break;
-- 
2.43.0

