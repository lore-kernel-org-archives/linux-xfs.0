Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD79E2D29D9
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 05:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556676; cv=none; b=UeOnfaGc4DRHBJsOMq7VZSyuY18xiy/wWAZ3u7FFNQIKVbqKqgGGci5EYIK6SFH7ibdJouorecu9yUISw1PHJFUvc7XXVJRiFAjU/XB0QUW3LnnLIwmVX1MxJBrE/8aWN28xf3K8aKuhhBNJPJTyGA/ERdNJkrRHvEYfq5v+4z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556676; c=relaxed/simple;
	bh=x0mXkzApIRemcwU4JsdvQp7Lr61IIMj1PfQ3IefuoUM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PQVvFgFxDHVFsFz695gOnVBpW96kfjoLas+5gYq3XtSCTW3mqoe/3ebxWAndrtFW4PNCKeZeNSZ5mCwRK//+1yzwrvPTSrK38B9Icwm3daA/Nk7SXShlevjboik9vNnPhbJjrzZlJ3FNL4bm768h+nuaKhNIERZ78IKPytk+0gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K5ZyD7vK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K5ZyD7vK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A841C4CEE3;
	Tue, 15 Jul 2025 05:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752556676;
	bh=x0mXkzApIRemcwU4JsdvQp7Lr61IIMj1PfQ3IefuoUM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K5ZyD7vKGOGeUyL4S1hQyjGtCIt+9eYRUFEKwYsQlLz6UJz6niBUrqPu01MOJCVqV
	 lNe7I1fvrf/0vTPmHf6JzSVCTi7gMqXJ7QWufrex0MUw7s7wAYHeC7kDq4vtBjUY6d
	 35dLy7r3EFTxrMqPlyJaBZqWzpzUfYsEhU1G+S07jjl5GMg0Q3rq4DLkSSuJMcAi76
	 ALy4D/dt3cl1LAvdt4K9dcjgOSk7P8iS5pd0wmfqiBk40JlZ1fjvQn5ZmBaQjLMmIm
	 VtLI9CQulxJ7FaYgIxzVX/jZ74c+uTnznO40TlD55WBiyk5djEVlHXbElX0pb703HL
	 ZkomsIevFXTug==
Date: Mon, 14 Jul 2025 22:17:56 -0700
Subject: [PATCH 6/6] xfs: allow sysadmins to specify a maximum atomic write
 limit at mount time
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: john.g.garry@oracle.com, catherine.hoang@oracle.com,
 john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <175255652222.1830720.7476448038808234165.stgit@frogsfrogsfrogs>
In-Reply-To: <175255652087.1830720.17606543077660806130.stgit@frogsfrogsfrogs>
References: <175255652087.1830720.17606543077660806130.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 4528b9052731f14c1a9be16b98e33c9401e6d1bc

Introduce a mount option to allow sysadmins to specify the maximum size
of an atomic write.  If the filesystem can work with the supplied value,
that becomes the new guaranteed maximum.

The value mustn't be too big for the existing filesystem geometry (max
write size, max AG/rtgroup size).  We dynamically recompute the
tr_atomic_write transaction reservation based on the given block size,
check that the current log size isn't less than the new minimum log size
constraints, and set a new maximum.

The actual software atomic write max is still computed based off of
tr_atomic_ioend the same way it has for the past few commits.  Note also
that xfs_calc_atomic_write_log_geometry is non-static because mkfs will
need that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 include/platform_defs.h |   14 ++++++++++
 include/xfs_trace.h     |    1 +
 libxfs/xfs_trans_resv.h |    4 +++
 libxfs/xfs_trans_resv.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 88 insertions(+)


diff --git a/include/platform_defs.h b/include/platform_defs.h
index 9af7b4318f8917..74a00583ebd6cb 100644
--- a/include/platform_defs.h
+++ b/include/platform_defs.h
@@ -261,6 +261,20 @@ static inline bool __must_check __must_check_overflow(bool overflow)
 	__builtin_add_overflow(__a, __b, __d);	\
 }))
 
+/**
+ * check_mul_overflow() - Calculate multiplication with overflow checking
+ * @a: first factor
+ * @b: second factor
+ * @d: pointer to store product
+ *
+ * Returns true on wrap-around, false otherwise.
+ *
+ * *@d holds the results of the attempted multiplication, regardless of whether
+ * wrap-around occurred.
+ */
+#define check_mul_overflow(a, b, d)	\
+	__must_check_overflow(__builtin_mul_overflow(a, b, d))
+
 /**
  * abs_diff - return absolute value of the difference between the arguments
  * @a: the first argument
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 965c109cc1941a..6bbf4007cbbbd9 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -65,6 +65,7 @@
 #define trace_xfs_attr_rmtval_remove_return(...) ((void) 0)
 
 #define trace_xfs_calc_max_atomic_write_fsblocks(...) ((void) 0)
+#define trace_xfs_calc_max_atomic_write_log_geometry(...) ((void) 0)
 
 #define trace_xfs_log_recover_item_add_cont(a,b,c,d)	((void) 0)
 #define trace_xfs_log_recover_item_add(a,b,c,d)	((void) 0)
diff --git a/libxfs/xfs_trans_resv.h b/libxfs/xfs_trans_resv.h
index a6d303b836883f..336279e0fc6137 100644
--- a/libxfs/xfs_trans_resv.h
+++ b/libxfs/xfs_trans_resv.h
@@ -122,5 +122,9 @@ unsigned int xfs_calc_write_reservation_minlogsize(struct xfs_mount *mp);
 unsigned int xfs_calc_qm_dqalloc_reservation_minlogsize(struct xfs_mount *mp);
 
 xfs_extlen_t xfs_calc_max_atomic_write_fsblocks(struct xfs_mount *mp);
+xfs_extlen_t xfs_calc_atomic_write_log_geometry(struct xfs_mount *mp,
+		xfs_extlen_t blockcount, unsigned int *new_logres);
+int xfs_calc_atomic_write_reservation(struct xfs_mount *mp,
+		xfs_extlen_t blockcount);
 
 #endif	/* __XFS_TRANS_RESV_H__ */
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index ec61ddfba44601..b3b9d22b54515d 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -1481,3 +1481,72 @@ xfs_calc_max_atomic_write_fsblocks(
 
 	return ret;
 }
+
+/*
+ * Compute the log blocks and transaction reservation needed to complete an
+ * atomic write of a given number of blocks.  Worst case, each block requires
+ * separate handling.  A return value of 0 means something went wrong.
+ */
+xfs_extlen_t
+xfs_calc_atomic_write_log_geometry(
+	struct xfs_mount	*mp,
+	xfs_extlen_t		blockcount,
+	unsigned int		*new_logres)
+{
+	struct xfs_trans_res	*curr_res = &M_RES(mp)->tr_atomic_ioend;
+	uint			old_logres = curr_res->tr_logres;
+	unsigned int		per_intent, step_size;
+	unsigned int		logres;
+	xfs_extlen_t		min_logblocks;
+
+	ASSERT(blockcount > 0);
+
+	xfs_calc_default_atomic_ioend_reservation(mp, M_RES(mp));
+
+	per_intent = xfs_calc_atomic_write_ioend_geometry(mp, &step_size);
+
+	/* Check for overflows */
+	if (check_mul_overflow(blockcount, per_intent, &logres) ||
+	    check_add_overflow(logres, step_size, &logres))
+		return 0;
+
+	curr_res->tr_logres = logres;
+	min_logblocks = xfs_log_calc_minimum_size(mp);
+	curr_res->tr_logres = old_logres;
+
+	trace_xfs_calc_max_atomic_write_log_geometry(mp, per_intent, step_size,
+			blockcount, min_logblocks, logres);
+
+	*new_logres = logres;
+	return min_logblocks;
+}
+
+/*
+ * Compute the transaction reservation needed to complete an out of place
+ * atomic write of a given number of blocks.
+ */
+int
+xfs_calc_atomic_write_reservation(
+	struct xfs_mount	*mp,
+	xfs_extlen_t		blockcount)
+{
+	unsigned int		new_logres;
+	xfs_extlen_t		min_logblocks;
+
+	/*
+	 * If the caller doesn't ask for a specific atomic write size, then
+	 * use the defaults.
+	 */
+	if (blockcount == 0) {
+		xfs_calc_default_atomic_ioend_reservation(mp, M_RES(mp));
+		return 0;
+	}
+
+	min_logblocks = xfs_calc_atomic_write_log_geometry(mp, blockcount,
+			&new_logres);
+	if (!min_logblocks || min_logblocks > mp->m_sb.sb_logblocks)
+		return -EINVAL;
+
+	M_RES(mp)->tr_atomic_ioend.tr_logres = new_logres;
+	return 0;
+}

