Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871067;
	b=vvh+6YermAhjieWJCMzFeocUGKPYqxnmH245zHjXRhCffKRY4gpX80O/73bJrSY7deej
	 1TNE9IogsRNtHnVjIPUQjvSdLuznzjeXlGo1CK/ooizpxldcH4xQLLgTgo6yn5dlIPgZ2
	 lXf8q/cnOWV4iNZku0XkRkWvVL43/Y9E6CSCYInDrIz2QZ+YHE9ufPd77lKPtjAqjMizp
	 ZUPPtwynHe4JIRRfxYUA+fEVXA/jXia68Eh80BTdpvGWDRcXsjCTVilXY3Lcu70RWg/m6
	 RNK0aiHei4LSwt93AmxAWY2XgQclVBBIRpIvU+lXJEXOKwXaW8iPm0/AK7EZt9liLQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=cvO8Hr8GE7NYjG/AbcDVpb+FWSBtY9puIt4jNx60IXU=;
	b=LR+GKPWLccjtGW9bleXSTy2eRmOlzCsoNhpqUyXP6+wZt1Yt0EogRB+nspWa2HOZrYiu
	 95/3ilGY6yEJ5Wx4MMECfN8P7lB/wmVgy2cqrxaFLyGAztoujlclxt6gwsCdQ/pGVk+Vk
	 FYShel+USHcgjEzWdchS3Z1RT3O4G6EfPbrkefyWjMdAJO9ZUXyok3xYHudCDsn+c0oLw
	 gntsZE8BJ2Do4CKnjMLgYTb+becH395LOlyk5fvkHn5LJSsf6LWVRGHAzSkc4rdSZrXKL
	 rDYRRtsq2DAQnfyQNhn6Bk6bKWJp0MSbZtMUXc1u3vS5Sqnu+AIBfrJQj0JjHrXdvZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GXYJ8vU2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D999606A329
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GXYJ8vU2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F53B1F000C4;
	Mon, 16 Nov 2026 23:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871067;
	bh=cvO8Hr8GE7NYjG/AbcDVpb+FWSBtY9puIt4jNx60IXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GXYJ8vU2zQeOUEqQEnrhWCIi0eBjCloROlXnwY6vZ0mR9c7jO4IVThdlv0WrTU1UC
	 4h2IWohlKFRvIVasSfdGDos/1TMv11fohxblqZsi91aJvxymU4MpUtSqIptq8Vi9F0
	 6MMS7gGJX0LG/HLLgsYd8FwCLtdWOx09r5ouXrfbMxx56fDL53oHm1hybWsEy2+6tU
	 S7Ik8PPEnXFUW7H8wqlcYDmec5nu3UlQztjhANIeTApY4OnOhEAS1dT8fmCdv1rCMZ
	 fbPF7u2PMkB14zw0SpTRFQ4Tyt9d/yZ+Ah5ZDJO/0BK34cGdMK0HuKrvZ2zyj03cRZ
	 pJk239X/HUm7Q==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 26/59] xfs: bound the assembled region size during recovery
Date: Tue, 17 Nov 2026 10:14:43 +1100
Message-ID: <20261116231707.3625263-27-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A region split across continuation op headers is grown one fragment at a time
with no limit on the total size, so a corrupt continuation stream can drive an
unbounded allocation during recovery.

Add XLOG_MAX_REGION_SIZE - the largest object logged in a single region - as a
format level bound usable by both the log write and recovery paths, and reject
a continuation once the assembled region would exceed it. Use the same constant
for the existing per-op-header length check.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_log_format.h |  8 ++++++++
 fs/xfs/xfs_log_recover.c       | 21 ++++++++++++---------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 6e620380d5dc..6d49cb831d73 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -38,6 +38,14 @@ typedef uint32_t xlog_tid_t;
 
 #define XLOG_HEADER_SIZE	512
 
+/*
+ * The largest object that is logged in a single region: a whole buffer in a
+ * buffer log item, or a remote attribute value. This bounds the size of any
+ * single log region both when writing the log and when reassembling regions
+ * during recovery.
+ */
+#define XLOG_MAX_REGION_SIZE	max(XFS_MAX_BLOCKSIZE, XFS_XATTR_SIZE_MAX)
+
 /* Minimum number of transactions that must fit in the log (defined by mkfs) */
 #define XFS_MIN_LOG_FACTOR	3
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index aea6f5404cec..374de5d21da6 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2415,6 +2415,16 @@ xlog_recover_add_to_cont_trans(
 	old_ptr = item->ri_buf[item->ri_cnt-1].iov_base;
 	old_len = item->ri_buf[item->ri_cnt-1].iov_len;
 
+	/*
+	 * Bound the assembled region size before growing the buffer so a corrupt
+	 * continuation stream cannot drive an unbounded allocation.
+	 */
+	if (old_len + len > XLOG_MAX_REGION_SIZE) {
+		xfs_warn(log->l_mp, "%s: region too large (0x%x)",
+			__func__, old_len + len);
+		return -EFSCORRUPTED;
+	}
+
 	ptr = kvrealloc(old_ptr, len + old_len, GFP_KERNEL);
 	if (!ptr)
 		return -ENOMEM;
@@ -2836,15 +2846,8 @@ xlog_recover_validate_ophdr(
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
-	/*
-	 * A single region cannot be larger than the largest object we log in
-	 * one region. That is a whole buffer in a buffer log item (up to
-	 * XFS_MAX_BLOCKSIZE, e.g. a 64k directory block on a 4k block size
-	 * filesystem) or a remote attribute value (up to XFS_XATTR_SIZE_MAX,
-	 * logged in its own region); both are 64k.
-	 */
-	BUILD_BUG_ON(XFS_XATTR_SIZE_MAX > XFS_MAX_BLOCKSIZE);
-	if (len > XFS_MAX_BLOCKSIZE) {
+	/* A single region cannot be larger than the largest object we log. */
+	if (len > XLOG_MAX_REGION_SIZE) {
 		if (!quiet)
 			xfs_warn(log->l_mp, "%s: length 0x%x too large",
 				__func__, len);
-- 
2.55.0

