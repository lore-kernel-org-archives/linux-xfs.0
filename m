Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039C413FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688598; cv=none; b=kbKmAvTHXiwGGf7yctEUJqtK6YUwpIXJSLuzFXUO6DxC4eFNHNX6pyvAbAz7RhNnGnviyk8McNa+2wvPB4vpn9ObRVjUryiaWz5Nlu2kd6kuqXCBSTTe//UBqMfn6HpQ6ByrA0gdKQ1BbhgkWRtqERoN7ic2voCOmeuXgpHf6Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688598; c=relaxed/simple;
	bh=XejIJj64lmGfHNYlrTNwSmR6+tSN/MpROhk+ivINfIg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y1ZMaCT44elDP2tNM5IUWTN6q3Ohtszzs9VMbetCHiEEtmMeVUzW1lRk0qi0U0Jb0mDIJ63mUK2Zu/4hQjBjRsB1lf11SH26fxXDnsqtBB9ALr6lN+41jaHMg+lq9CzN46db/BqUAiSuj65uxndBgVpgGLo/dGbJf16jtmjd9so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mFQU3PUQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mFQU3PUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73338C4CED2;
	Tue, 31 Dec 2024 23:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688597;
	bh=XejIJj64lmGfHNYlrTNwSmR6+tSN/MpROhk+ivINfIg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mFQU3PUQA3yn6zfbxNhqIO8IqcjkJRwmIZTe+koOTrs7vbjExpGLO2BXX3Dsd7+l7
	 JVWRSsZOJiiCDy/KeQltvr/CHpDO22e4zOGlj2geMvPN8MQsv1YhRf5YzI+B3hxcT0
	 uMPfXAPUtWO6gkE1S4IO7mJwte9jw1M/6NvyumnIl+7WEo93/P7iOvOR1d+Y02PZdD
	 S/mTF0XF7B+gKamWL6Me0ZPq+o5BvFfmv0TAB4S25LnWovsGxKaWw0SW808Qq6Cl2q
	 jKyuLaJ1bB20gC6+q1Z1U3h8QZvnFbX2SG/kEloyIc8F4Aje4fvRJ/faoS+GjA5w5x
	 02Dh+qEbTnODA==
Date: Tue, 31 Dec 2024 15:43:17 -0800
Subject: [PATCH 1/5] xfs: track deferred ops statistics
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568777023.2709441.15844314401526725196.stgit@frogsfrogsfrogs>
In-Reply-To: <173568777001.2709441.13781927144429990672.stgit@frogsfrogsfrogs>
References: <173568777001.2709441.13781927144429990672.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Track some basic statistics on how hard we're pushing the defer ops.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 include/xfs_trans.h |    4 ++++
 libxfs/xfs_defer.c  |   18 +++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 248064019a0ab5..64d73c36851b75 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -82,6 +82,10 @@ typedef struct xfs_trans {
 	long			t_frextents_delta;/* superblock freextents chg*/
 	struct list_head	t_items;	/* log item descriptors */
 	struct list_head	t_dfops;	/* deferred operations */
+
+	unsigned int	t_dfops_nr;
+	unsigned int	t_dfops_nr_max;
+	unsigned int	t_dfops_finished;
 } xfs_trans_t;
 
 void	xfs_trans_init(struct xfs_mount *);
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 8f6708c0f3bfcd..7e6167949f6509 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -611,6 +611,8 @@ xfs_defer_finish_one(
 	/* Done with the dfp, free it. */
 	list_del(&dfp->dfp_list);
 	kmem_cache_free(xfs_defer_pending_cache, dfp);
+	tp->t_dfops_nr--;
+	tp->t_dfops_finished++;
 out:
 	if (ops->finish_cleanup)
 		ops->finish_cleanup(tp, state, error);
@@ -673,6 +675,9 @@ xfs_defer_finish_noroll(
 
 		list_splice_init(&(*tp)->t_dfops, &dop_pending);
 
+		(*tp)->t_dfops_nr_max = max((*tp)->t_dfops_nr,
+					    (*tp)->t_dfops_nr_max);
+
 		if (has_intents < 0) {
 			error = has_intents;
 			goto out_shutdown;
@@ -714,6 +719,7 @@ xfs_defer_finish_noroll(
 	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
 	trace_xfs_defer_finish_error(*tp, error);
 	xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
+	(*tp)->t_dfops_nr = 0;
 	xfs_defer_cancel(*tp);
 	return error;
 }
@@ -761,6 +767,7 @@ xfs_defer_cancel(
 	trace_xfs_defer_cancel(tp, _RET_IP_);
 	xfs_defer_trans_abort(tp, &tp->t_dfops);
 	xfs_defer_cancel_list(mp, &tp->t_dfops);
+	tp->t_dfops_nr = 0;
 }
 
 /*
@@ -846,8 +853,10 @@ xfs_defer_add(
 	}
 
 	dfp = xfs_defer_find_last(tp, ops);
-	if (!dfp || !xfs_defer_can_append(dfp, ops))
+	if (!dfp || !xfs_defer_can_append(dfp, ops)) {
 		dfp = xfs_defer_alloc(&tp->t_dfops, ops);
+		tp->t_dfops_nr++;
+	}
 
 	xfs_defer_add_item(dfp, li);
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, li);
@@ -872,6 +881,7 @@ xfs_defer_add_barrier(
 		return;
 
 	xfs_defer_alloc(&tp->t_dfops, &xfs_barrier_defer_type);
+	tp->t_dfops_nr++;
 
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, NULL);
 }
@@ -932,6 +942,12 @@ xfs_defer_move(
 	struct xfs_trans	*stp)
 {
 	list_splice_init(&stp->t_dfops, &dtp->t_dfops);
+	dtp->t_dfops_nr += stp->t_dfops_nr;
+	dtp->t_dfops_nr_max = stp->t_dfops_nr_max;
+	dtp->t_dfops_finished = stp->t_dfops_finished;
+	stp->t_dfops_nr = 0;
+	stp->t_dfops_nr_max = 0;
+	stp->t_dfops_finished = 0;
 
 	/*
 	 * Low free space mode was historically controlled by a dfops field.

