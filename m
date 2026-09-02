Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7041C33263B
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 05:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328049; cv=none; b=Ed1vQiXlageemaHn3so5b2FsXexdk1Y54KianQzr9PjiLrDBSEeTzTe7qVsHgfWafnnu5jGYOHZTzUNe5K0aoMJX7gm+A6DX2Xn8u8wfqd8PO5IIceshHbCSdEUNXLAo815g5ZVzSfgy0Yo1OHfKbAa+nnV0vIBhwHd9+32yTYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328049; c=relaxed/simple;
	bh=377gKBhp4+A0UO5X72b9yt7oGUlfqRHs4biMYmUn9ic=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H0Fa84V3zjj0NeqRUzcxCWJ9XONXQLEs0T9QG4keavZ2GC61hy0J4GaIgcpzfF4s75Oc3qlQPXw4f+mJysBnuPFYXlV8moBYpiD9KIpKJA2YHnfXFKZBdV7SPVM1IdJq1x7rIHl8bpsqUp5vbxJ4zW/aJomuMaD532lxZU2lchM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WU6tQSE/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WU6tQSE/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4ABC21F000E9;
	Wed,  2 Sep 2026 05:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328048;
	bh=RtjkPLZ3pnXkUgz9wBFlD3jwjnQhUUbIN/U1GevqQhs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=WU6tQSE/zWY2tcHr9ZwtLa0yskRGMH8gK94y4lQltRfNlVqH92YiIdhpYQ0vI5SZU
	 L4C9HKn4OKRVUbVJYlUAHRJjB88pSDllMquZ6611NEkB1sMO4ryDMhPmzRgcHjdFi8
	 UKjZoMnCt63TbE0sqh7MiTPW52LUGfmloR38ef10PoXUo5Ag7Bzka1exBQ6XOqDSZZ
	 OUJxc2BPluSAxHsUmZQjpQvi2E0/mzPMV3vxXq8LC5/jUvQ6IWjPy5asAGXKTde7Zr
	 Fy+FOLKYqf+TDtpPLoiWmeKxFn+WUIcSEvo31CY+/pCb+NeSibkKfLEkohrIbKqu38
	 HypgrdwnGPw3w==
Date: Tue, 01 Sep 2026 22:47:28 -0700
Subject: [PATCH 4/8] xfs: merge healthmon insert/push helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178832750351.3507776.9697837519652649402.stgit@frogsfrogsfrogs>
In-Reply-To: <178832750217.3507776.15975397025387963886.stgit@frogsfrogsfrogs>
References: <178832750217.3507776.15975397025387963886.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

These functions are basically the same except for where in the queue the
new event is added.  Refactor them as a single function that takes an
action verb to tell us where; and rename the tracepoints to describe
directly what happens.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trace.h     |    4 ++--
 fs/xfs/xfs_healthmon.c |   46 +++++++++++++++++++++-------------------------
 2 files changed, 23 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f333c938fbd935..6aa379c2cf0cd1 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -6139,8 +6139,8 @@ DEFINE_EVENT(xfs_healthmon_event_class, name, \
 	TP_PROTO(const struct xfs_healthmon *hm, \
 		 const struct xfs_healthmon_event *event), \
 	TP_ARGS(hm, event))
-DEFINE_HEALTHMONEVENT_EVENT(xfs_healthmon_insert);
-DEFINE_HEALTHMONEVENT_EVENT(xfs_healthmon_push);
+DEFINE_HEALTHMONEVENT_EVENT(xfs_healthmon_insert_head);
+DEFINE_HEALTHMONEVENT_EVENT(xfs_healthmon_insert_tail);
 DEFINE_HEALTHMONEVENT_EVENT(xfs_healthmon_pop);
 DEFINE_HEALTHMONEVENT_EVENT(xfs_healthmon_format);
 DEFINE_HEALTHMONEVENT_EVENT(xfs_healthmon_format_overflow);
diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index fa3f77e2ef1398..5b7ae194a6e602 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -270,10 +270,16 @@ xfs_healthmon_merge_events(
 	return true;
 }
 
-/* Insert an event onto the start of the queue. */
+enum insert_where {
+	INSERT_HEAD,
+	INSERT_TAIL,
+};
+
+/* Add an event onto the start or the end of the queue. */
 static inline void
 __xfs_healthmon_insert(
 	struct xfs_healthmon		*hm,
+	enum insert_where		where,
 	struct xfs_healthmon_event	*event)
 {
 	struct timespec64		now;
@@ -283,31 +289,21 @@ __xfs_healthmon_insert(
 	ktime_get_coarse_real_ts64(&now);
 	event->time_ns = (now.tv_sec * NSEC_PER_SEC) + now.tv_nsec;
 
-	list_add(&event->entry, &hm->event_list);
-	xfs_healthmon_bump_events(hm);
-	wake_up(&hm->wait);
+	switch (where) {
+	case INSERT_HEAD:
+		trace_xfs_healthmon_insert_head(hm, event);
 
-	trace_xfs_healthmon_insert(hm, event);
-}
+		list_add(&event->entry, &hm->event_list);
+		break;
+	case INSERT_TAIL:
+		trace_xfs_healthmon_insert_tail(hm, event);
 
-/* Push an event onto the end of the queue. */
-static inline void
-__xfs_healthmon_push(
-	struct xfs_healthmon		*hm,
-	struct xfs_healthmon_event	*event)
-{
-	struct timespec64		now;
+		list_add_tail(&event->entry, &hm->event_list);
+		break;
+	}
 
-	lockdep_assert_held(&hm->lock);
-
-	ktime_get_coarse_real_ts64(&now);
-	event->time_ns = (now.tv_sec * NSEC_PER_SEC) + now.tv_nsec;
-
-	list_add_tail(&event->entry, &hm->event_list);
 	xfs_healthmon_bump_events(hm);
 	wake_up(&hm->wait);
-
-	trace_xfs_healthmon_push(hm, event);
 }
 
 /* Deal with any previously lost events */
@@ -333,7 +329,7 @@ xfs_healthmon_clear_lost_prev(
 	if (!event)
 		return -ENOMEM;
 
-	__xfs_healthmon_push(hm, event);
+	__xfs_healthmon_insert(hm, INSERT_TAIL, event);
 cleared:
 	hm->lost_prev_event = 0;
 	return 0;
@@ -386,7 +382,7 @@ xfs_healthmon_push(
 		goto out_unlock;
 	}
 
-	__xfs_healthmon_push(hm, event);
+	__xfs_healthmon_insert(hm, INSERT_TAIL, event);
 
 out_unlock:
 	mutex_unlock(&hm->lock);
@@ -415,7 +411,7 @@ xfs_healthmon_unmount(
 	 * we've inserted the unmount event, hm no longer owns that event.
 	 */
 	mutex_lock(&hm->lock);
-	__xfs_healthmon_insert(hm, hm->unmount_event);
+	__xfs_healthmon_insert(hm, INSERT_HEAD, hm->unmount_event);
 	hm->unmount_event = NULL;
 	mutex_unlock(&hm->lock);
 
@@ -1214,7 +1210,7 @@ xfs_ioc_health_monitor(
 	}
 	running_event->type = XFS_HEALTHMON_RUNNING;
 	running_event->domain = XFS_HEALTHMON_MOUNT;
-	__xfs_healthmon_insert(hm, running_event);
+	__xfs_healthmon_insert(hm, INSERT_HEAD, running_event);
 
 	/*
 	 * Preallocate the unmount event so that we can't fail to notify the

