Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE634746C1
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 11:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521360; cv=none; b=KYJmJLM/FaQsy61oF1sv6Tzzdt0roHwoCyJBMhmrufQ/f0LhC4kWoHUARna1qwZKtMeHusR4cFSA4k41eLAlk4ZOq52ascGKSw58T3ybmAFzNUtye3PtRTvWXVzMKPJOJKhm8Z2fmXaJq0atc0mzdJil5BSqGZQPOjzp/qevMco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521360; c=relaxed/simple;
	bh=KXC/47lyfU6Fd+iI58P2dXNlPaGiEdTE+UkO1h9fEqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9kVI8SeYgE+huYFGDDiRGx7doAUBzJMNBNvX+KcFwxcHcWCln0wcQbDRntAXo7cYzxO64mOununeSknbSbQZC4j77aob2XhmOCq4DskgcQaNniDNZNBIdC0QV873xXHA6FPWAAJb4YHpo0VqzRKuMTTzcpHeuRAkezAn2JELNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Da8VEQbm; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Da8VEQbm"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-6b1c75f0049so662987eaf.3
        for <linux-xfs@vger.kernel.org>; Fri, 04 Sep 2026 04:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788521358; x=1789126158; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=donC4cVxpSvViWFIHyYJ5B8ZHRJStvZlBU6xIf4stOU=;
        b=Da8VEQbmY1sV2XQE27OcKCb1gs8+O3C6qVmrmhUBlrp49U9vQb89da1qXNMdIPxgdI
         9fpo4jb2EhITlCA+WNhHE9haYL3hYh2pqeijf/MiZNGXE/fkbvWlWUeZ5Dc9i2H9R+J0
         myTvNJe0bI58mnKoOEz2D7FEKlCAOcOjKIDe0KF7A9B2ehy79tz3UG0cjP+k+yFWHi3B
         wouJWFXFynyABkGhjjhIuo1X68LIw5o0fSUB9rP9YfCBhenFk45is86vlAMXE+/tYGEZ
         pAdLyDSN3WZJ+L1PInU1a5aEEgWAou88u/rcLN4HbrR2rT0cBUauOaaE8JgDcQEP0diC
         Txgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788521358; x=1789126158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=donC4cVxpSvViWFIHyYJ5B8ZHRJStvZlBU6xIf4stOU=;
        b=KKvgpV7PmZ9VZhbPztlV6NDQnCnSdZCIMd7SrdYmANwBtp9MQpxKNcfpzelhB8pPpV
         z/jjcYnOHcKV/g2vXRDZCupBCshHbwhp+sIi/CYKT0ky5MT8MQVU/OLyRtEwPOpL9n9I
         khz+sEUuK39TEjxe/dKd+36F0ayZZpVXcUE1vLcOtIPeZQhCm0P26r1OrFazNmhqWATn
         VFME7KzIPta/dCtnpIxb13FSCWlVVSSZn8KIyaeWX5IJhBNAKTs4DQux64Ff5MgenR6u
         mfixw0FsheJi7i2HEFXKgjwpv9POWTiuF43AkMxyn+datFVDBgYQiKrwic2Ek5KNBjfs
         SUIg==
X-Forwarded-Encrypted: i=1; AKwUvBxurqwagMgWa8B99yDJ9qmvZish3rlcak/5NK7Zcju0scWIbCqF1uo+2jzNHe/3tmFYkGu7HpnP1TE=@vger.kernel.org
X-Gm-Message-State: AFuF++l0evnRTu+Jnx9Ji5ZFVMSSHob2C9MVO3OkVpWLN2q4sqBOuTaO
	/EoE/Pc6Rx2yOeSXd9YNqd0eYyceA1Q2MpWlOZKK1VvBOdAUaSffOg9sip+CGLtsO4M=
X-Gm-Gg: AYBFou0sAFYUHlJgTpS+Gr7uRq2DLRj0YopNOeJOq1jIupQHOiD4QNn68qD2nPtZz2b
	r5HixdKM+mEsIO/sURhE4WQXWj9xQl682N6J4f55zbsdtQ/f4v8jBjCZgUi6MOGK0p3mlpIaOHd
	PMKLvARlxj5er7X5SVEIjKheXyj5WE67ZwutwsRIPRdsgI5vj0J9aVqjO14SjxYMdhsDjpHvbZR
	mfYA1Nl3HM9jVQrFSZe0I09TbFB1XQGfvLPYQJG2T6KTjFs/cndkhd7MJWWiFzWEcn6CoPsebvF
	hstBdYcH+q29Oe5nq5kJwVSWt24GwxBoKAN0QRtxOsBikO482YHykDlDU1q913f7RUidfQFtVJx
	9wF8xcqPu5t3hLBGPJhyO5LMHnPwG4cwDQzyH9V5c+TSbw04BaD95h8FlaLIncet5SPOZ11yuw5
	EQk93vrUmNB8HuppylYQRU+OaM3ICVP6HhUbQesA2t69k8DpzZkaATZ3OHqGVynQUhgE5EbUjne
	9zkx2fBZwo46HM=
X-Received: by 2002:a05:6820:616:b0:6b1:bdd9:45d with SMTP id 006d021491bc7-6b6fcbdeb26mr3935249eaf.21.1788521357738;
        Fri, 04 Sep 2026 04:29:17 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1432435648esm7443259c88.5.2026.09.04.04.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 04:29:17 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: fix typos in comments
Date: Fri,  4 Sep 2026 16:59:03 +0530
Message-ID: <20260904112909.8197-2-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904112909.8197-1-hemanth.selam@gmail.com>
References: <20260904112909.8197-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 fs/xfs/libxfs/xfs_ag.h        | 2 +-
 fs/xfs/libxfs/xfs_alloc.c     | 4 ++--
 fs/xfs/libxfs/xfs_attr_leaf.c | 2 +-
 fs/xfs/libxfs/xfs_errortag.h  | 2 +-
 fs/xfs/libxfs/xfs_format.h    | 2 +-
 fs/xfs/scrub/dirtree.c        | 2 +-
 fs/xfs/xfs_inode.c            | 2 +-
 fs/xfs/xfs_log_cil.c          | 2 +-
 fs/xfs/xfs_platform.h         | 2 +-
 9 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index fd22fe598931..ee636b66a72f 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -207,7 +207,7 @@ xfs_perag_next(
 }
 
 /*
- * Per-ag geometry infomation and validation
+ * Per-ag geometry information and validation
  */
 xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, xfs_agnumber_t agno);
 void xfs_agino_range(struct xfs_mount *mp, xfs_agnumber_t agno,
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d99602bcc16f..f762dcce8d13 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3487,7 +3487,7 @@ xfs_alloc_read_agf(
 }
 
 /*
- * Pre-proces allocation arguments to set initial state that we don't require
+ * Pre-process allocation arguments to set initial state that we don't require
  * callers to set up correctly, as well as bounds check the allocation args
  * that are set up.
  */
@@ -3608,7 +3608,7 @@ xfs_alloc_vextent_finish(
 	 * ABBA AGF deadlocks because a future allocation attempt in this
 	 * transaction may attempt to lock a lower number AGF.
 	 *
-	 * We can't release the AGF until the transaction is commited, so at
+	 * We can't release the AGF until the transaction is committed, so at
 	 * this point we must update the "first allocation" tracker to point at
 	 * this AG if the tracker is empty or points to a lower AG. This allows
 	 * the next allocation attempt to be modified appropriately to avoid
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index b6288395f853..2c80f4fd0b78 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1715,7 +1715,7 @@ xfs_attr3_leaf_add_work(
 			/*
 			 * This freemap entry starts at the old end of the
 			 * leaf entry array, so we need to adjust its base
-			 * upward to accomodate the larger array.
+			 * upward to accommodate the larger array.
 			 */
 			diff = sizeof(struct xfs_attr_leaf_entry);
 		} else if (ichdr->freemap[i].size > 0 &&
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 6de207fed2d8..f0c83f1f0b3b 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -83,7 +83,7 @@
 #define XFS_RANDOM_DEFAULT				100
 
 /*
- * Table of errror injection knobs.  The parameters to the XFS_ERRTAG macro are:
+ * Table of error injection knobs.  The parameters to the XFS_ERRTAG macro are:
  *   1. The XFS_ERRTAG_ flag but without the prefix;
  *   2. The name of the sysfs knob; and
  *   3. The default value for the knob.
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index dd0ed046fbe9..1a7a7e60a170 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1051,7 +1051,7 @@ enum xfs_dinode_fmt {
  * block is 1KB in size.
  *
  * With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and
- * with 1KB sized blocks, a file can reach upto,
+ * with 1KB sized blocks, a file can reach up to,
  * 1KB * (2^31) = 2TB
  *
  * This is much larger than the theoretical maximum size of a directory
diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index b2cf6e5439d9..469ba30670f0 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -994,7 +994,7 @@ xchk_dirtree(
 	return error;
 }
 
-/* Does the directory targetted by this scrub have no parents? */
+/* Does the directory targeted by this scrub have no parents? */
 bool
 xchk_dirtree_parentless(const struct xchk_dirtree *dl)
 {
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 030a7c8f2c12..621513d7215e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2669,7 +2669,7 @@ xfs_irele(
 }
 
 /*
- * Ensure all commited transactions touching the inode are written to the log.
+ * Ensure all committed transactions touching the inode are written to the log.
  */
 int
 xfs_log_force_inode(
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 639f875a8fb2..defd121690f5 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1369,7 +1369,7 @@ xlog_cil_cleanup_whiteouts(
  * allocation context. However, we do not want to block on memory reclaim
  * recursing back into the filesystem because this push may have been triggered
  * by memory reclaim itself. Hence we really need to run under full GFP_NOFS
- * contraints here.
+ * constraints here.
  */
 static void
 xlog_cil_push_work(
diff --git a/fs/xfs/xfs_platform.h b/fs/xfs/xfs_platform.h
index 5d542e95fe44..745d715b4c64 100644
--- a/fs/xfs/xfs_platform.h
+++ b/fs/xfs/xfs_platform.h
@@ -153,7 +153,7 @@ static inline void delay(long ticks)
 /*
  * XFS wrapper structure for sysfs support. It depends on external data
  * structures and is embedded in various internal data structures to implement
- * the XFS sysfs object heirarchy. Define it here for broad access throughout
+ * the XFS sysfs object hierarchy. Define it here for broad access throughout
  * the codebase.
  */
 struct xfs_kobj {
-- 
2.48.1

