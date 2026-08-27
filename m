Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64A92FE074
	for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2026 05:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787808812; cv=none; b=KJCcilHByrIALwc9LOG8/aRWwu5k9lp5O5i4ksKOEC4QE13AJ8wQcvEIDYCIvZ8tOvkR6rpZExhT6d5lp1LO+VROWLu5CvMJUQpp4FX1VTYQJa7U/MB5pjpxy6zJlgdZKdn5rDEmw8E6K3aqiI7zsQCf18GV1ZuAHQ5K+avQylQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787808812; c=relaxed/simple;
	bh=2jd6kapy70W/w4VnQmZTP7HYaSjbXmBYXjnJqBb1qxU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sQEAOjftTawxviMV1T/i/gIv2LYxToYaD0eP0pyvXvOb0XIR0jcJATH46Qwuj+jiUtOpK9zXT+Q2lJPHno0bNiQBONciRei3W3xvBlqjrZYLmQlGHY1T86F5BuzUaWwknxB/iBKeX9IH9yl0h32LwFN4njgmRTk1LGkCKQtwWfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W1utXoip; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W1utXoip"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 652F61F000E9;
	Thu, 27 Aug 2026 05:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787808810;
	bh=qNV5IZcX/NR1XO2ffHGadKfg+OrR3FVhJo3nQX7v+T0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=W1utXoiptHJjiOXvddGGxtc6E8DWnz5wr7ctHaV1Vm/mgQUwTarEt0uqQ0LFTqCCI
	 R/yO1P3zq+xajSwZvsarVvIam4Gm78qZR7eK0XyDAGQ+LV473E13WgRQJljJrOYXPz
	 ZXou4DEenpsDy/0MGkhblu3yI6PpgvVlii99OIKMSpHWF/xP4OeIU2U/au4hFr+znO
	 G7OGacPwYtyb7PtSb0Z/RcIDV3sCxyvbJzw6GRsNSozyR0SbIh3swSor/v1/BoYsJ2
	 jlIDfwu5goANFBYwPloMBY+bLIJ+L2pSAoW6rycgd7mBD8lxFCJ8t/JLCYP29wZqhu
	 UZtZhIjUuvBww==
Date: Wed, 26 Aug 2026 22:33:30 -0700
Subject: [PATCH 4/7] xfs: merge healthmon insert/push helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <178780640668.3528467.13347610952808276371.stgit@frogsfrogsfrogs>
In-Reply-To: <178780640541.3528467.13867917797753503580.stgit@frogsfrogsfrogs>
References: <178780640541.3528467.13867917797753503580.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/xfs_trace.h     |    4 ++--
 fs/xfs/xfs_healthmon.c |   46 +++++++++++++++++++++-------------------------
 2 files changed, 23 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index aeb89ac53bf190..02f54bc5aa91c6 100644
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
index d0e0ecc6fc0c8f..190779f2e13655 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -266,10 +266,16 @@ xfs_healthmon_merge_events(
 	return false;
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
@@ -279,31 +285,21 @@ __xfs_healthmon_insert(
 	ktime_get_coarse_real_ts64(&now);
 	event->time_ns = (now.tv_sec * NSEC_PER_SEC) + now.tv_nsec;
 
-	list_add(&event->list, &hm->event_list);
-	xfs_healthmon_bump_events(hm);
-	wake_up(&hm->wait);
+	switch (where) {
+	case INSERT_HEAD:
+		trace_xfs_healthmon_insert_head(hm, event);
 
-	trace_xfs_healthmon_insert(hm, event);
-}
+		list_add(&event->list, &hm->event_list);
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
+		list_add_tail(&event->list, &hm->event_list);
+		break;
+	}
 
-	lockdep_assert_held(&hm->lock);
-
-	ktime_get_coarse_real_ts64(&now);
-	event->time_ns = (now.tv_sec * NSEC_PER_SEC) + now.tv_nsec;
-
-	list_add_tail(&event->list, &hm->event_list);
 	xfs_healthmon_bump_events(hm);
 	wake_up(&hm->wait);
-
-	trace_xfs_healthmon_push(hm, event);
 }
 
 static inline struct xfs_healthmon_event *xfs_healthmon_alloc_event(void)
@@ -352,7 +348,7 @@ xfs_healthmon_clear_lost_prev(
 	if (!event)
 		return -ENOMEM;
 
-	__xfs_healthmon_push(hm, event);
+	__xfs_healthmon_insert(hm, INSERT_TAIL, event);
 cleared:
 	hm->lost_prev_event = 0;
 	return 0;
@@ -405,7 +401,7 @@ xfs_healthmon_push(
 		goto out_unlock;
 	}
 
-	__xfs_healthmon_push(hm, event);
+	__xfs_healthmon_insert(hm, INSERT_TAIL, event);
 
 out_unlock:
 	mutex_unlock(&hm->lock);
@@ -434,7 +430,7 @@ xfs_healthmon_unmount(
 	 * we've inserted the unmount event, hm no longer owns that event.
 	 */
 	mutex_lock(&hm->lock);
-	__xfs_healthmon_insert(hm, hm->unmount_event);
+	__xfs_healthmon_insert(hm, INSERT_HEAD, hm->unmount_event);
 	hm->unmount_event = NULL;
 	mutex_unlock(&hm->lock);
 
@@ -1244,7 +1240,7 @@ xfs_ioc_health_monitor(
 	}
 	running_event->type = XFS_HEALTHMON_RUNNING;
 	running_event->domain = XFS_HEALTHMON_MOUNT;
-	__xfs_healthmon_insert(hm, running_event);
+	__xfs_healthmon_insert(hm, INSERT_HEAD, running_event);
 
 	/*
 	 * Preallocate the unmount event so that we can't fail to notify the

