Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DD132F749
	for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2026 05:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787808780; cv=none; b=UK3reNwfiXQ+efs32Gv2GbfUFMdKRGsZusIjsNABCnUqdNTCpZqXXg+CFuYZlf5EkJwZQD7eQH7KCFy+o3SoTqMfIQRFj0xcspRAjZJPzYkN1TjGqn+rzrT2Ri7L6F7fNQ8uOAeVJ+ZaEPB5frhERN9b/wsGsVn9Y7jZY6AKNhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787808780; c=relaxed/simple;
	bh=D528minQ8RSe363jiwERxjvtvFYTC+y+l1ypUH3ecCI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DQVgflFo94MlQEIlNE6kejlVVXAt3lWp33jJYd4MFAGqVFSvyBPSWpf7saYBrNHc3pmKhwFyiUY/hU/HPO93uoXeDTiHxhlhSS4iEDcagLknwTPvfuP/BKArOnxB8M2NDXQP8tC9ZWv+su1CTr81/kR3HZT+brLWVOG/jjlZF5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KJGVbDah; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KJGVbDah"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5B5231F000E9;
	Thu, 27 Aug 2026 05:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787808779;
	bh=vWWZfvfhkFtWNzDdl3b3Aftsdu25xFyLkLyHgNkCZhM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=KJGVbDahl6s3wC60LY2fRe1fDsafTinoWwttRYekv7IhzIiYteWFlfEmOBwnzeTAM
	 EBAMkLfbfXhxlJ+B+emwNnqEHc3gozUdj9kF38n+0vZ4SlcBwtahRE0XsbsH1piHA5
	 FwP7noh1UI5B67+7e/d/p40OwVHiHV44iwln1W+qwT0OCfFfhEhrACt4cdX48nXkl9
	 N1MYGQLNGeW9JHjZWIDoy3/OfPgd05EQ1YYPfMI80CjnYPrqJpb7oeRJfnYN8S+pnB
	 La9WcYh6PCA81SUjBCHe7oiYFuQv3AIlHho8kL8Yiud6kXTVE7W1/nPwpEDgZV1xte
	 syIMuAG0EI8tQ==
Date: Wed, 26 Aug 2026 22:32:59 -0700
Subject: [PATCH 2/7] xfs: port healthmon event list to list_head
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <178780640625.3528467.15741375660976356976.stgit@frogsfrogsfrogs>
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

Simplify the healthmon codebase by porting the single-link event list to
a standard list_head.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_healthmon.h |    5 +--
 fs/xfs/xfs_healthmon.c |   73 +++++++++++++++++++++++++++++-------------------
 2 files changed, 46 insertions(+), 32 deletions(-)


diff --git a/fs/xfs/xfs_healthmon.h b/fs/xfs/xfs_healthmon.h
index 0e936507037fda..ef90ab03c2b399 100644
--- a/fs/xfs/xfs_healthmon.h
+++ b/fs/xfs/xfs_healthmon.h
@@ -31,8 +31,7 @@ struct xfs_healthmon {
 	struct mutex			lock;
 
 	/* list of event objects */
-	struct xfs_healthmon_event	*first_event;
-	struct xfs_healthmon_event	*last_event;
+	struct list_head		event_list;
 
 	/* preallocated event for unmount */
 	struct xfs_healthmon_event	*unmount_event;
@@ -110,7 +109,7 @@ enum xfs_healthmon_domain {
 };
 
 struct xfs_healthmon_event {
-	struct xfs_healthmon_event	*next;
+	struct list_head		list;
 
 	enum xfs_healthmon_type		type;
 	enum xfs_healthmon_domain	domain;
diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index a4efc084a8fc0b..ef2538a1ea6994 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -87,12 +87,10 @@ xfs_healthmon_put(
 	struct xfs_healthmon		*hm)
 {
 	if (refcount_dec_and_test(&hm->ref)) {
-		struct xfs_healthmon_event	*event;
-		struct xfs_healthmon_event	*next = hm->first_event;
+		struct xfs_healthmon_event	*event, *s;
 
-		while ((event = next) != NULL) {
+		list_for_each_entry_safe(event, s, &hm->event_list, list) {
 			trace_xfs_healthmon_drop(hm, event);
-			next = event->next;
 			kfree(event);
 		}
 
@@ -173,9 +171,13 @@ static inline void xfs_healthmon_bump_lost(struct xfs_healthmon *hm)
  */
 static bool
 xfs_healthmon_merge_events(
-	struct xfs_healthmon_event		*existing,
+	struct xfs_healthmon			*hm,
 	const struct xfs_healthmon_event	*new)
 {
+	struct xfs_healthmon_event		*existing =
+		list_last_entry_or_null(&hm->event_list, struct
+				xfs_healthmon_event, list);
+
 	if (!existing)
 		return false;
 
@@ -277,10 +279,7 @@ __xfs_healthmon_insert(
 	ktime_get_coarse_real_ts64(&now);
 	event->time_ns = (now.tv_sec * NSEC_PER_SEC) + now.tv_nsec;
 
-	event->next = hm->first_event;
-	hm->first_event = event;
-	if (!hm->last_event)
-		hm->last_event = event;
+	list_add(&event->list, &hm->event_list);
 	xfs_healthmon_bump_events(hm);
 	wake_up(&hm->wait);
 
@@ -300,18 +299,36 @@ __xfs_healthmon_push(
 	ktime_get_coarse_real_ts64(&now);
 	event->time_ns = (now.tv_sec * NSEC_PER_SEC) + now.tv_nsec;
 
-	if (!hm->first_event)
-		hm->first_event = event;
-	if (hm->last_event)
-		hm->last_event->next = event;
-	hm->last_event = event;
-	event->next = NULL;
+	list_add_tail(&event->list, &hm->event_list);
 	xfs_healthmon_bump_events(hm);
 	wake_up(&hm->wait);
 
 	trace_xfs_healthmon_push(hm, event);
 }
 
+static inline struct xfs_healthmon_event *xfs_healthmon_alloc_event(void)
+{
+	struct xfs_healthmon_event		*event =
+		kzalloc_obj(struct xfs_healthmon_event, GFP_NOFS);
+
+	if (event)
+		INIT_LIST_HEAD(&event->list);
+	return event;
+}
+
+static inline struct xfs_healthmon_event *
+xfs_healthmon_dup_event(
+	const struct xfs_healthmon_event	*template)
+{
+	struct xfs_healthmon_event		*event =
+		kmemdup(template, sizeof(struct xfs_healthmon_event),
+				GFP_NOFS);
+
+	if (event)
+		INIT_LIST_HEAD(&event->list);
+	return event;
+}
+
 /* Deal with any previously lost events */
 static int
 xfs_healthmon_clear_lost_prev(
@@ -324,15 +341,14 @@ xfs_healthmon_clear_lost_prev(
 	};
 	struct xfs_healthmon_event	*event = NULL;
 
-	if (xfs_healthmon_merge_events(hm->last_event, &lost_event)) {
-		trace_xfs_healthmon_merge(hm, hm->last_event);
+	if (xfs_healthmon_merge_events(hm, &lost_event)) {
+		trace_xfs_healthmon_merge(hm, &lost_event);
 		wake_up(&hm->wait);
 		goto cleared;
 	}
 
 	if (hm->events < XFS_HEALTHMON_MAX_EVENTS)
-		event = kmemdup(&lost_event, sizeof(struct xfs_healthmon_event),
-				GFP_NOFS);
+		event = xfs_healthmon_dup_event(&lost_event);
 	if (!event)
 		return -ENOMEM;
 
@@ -372,16 +388,15 @@ xfs_healthmon_push(
 	}
 
 	/* Try to merge with the newest event */
-	if (xfs_healthmon_merge_events(hm->last_event, template)) {
-		trace_xfs_healthmon_merge(hm, hm->last_event);
+	if (xfs_healthmon_merge_events(hm, template)) {
+		trace_xfs_healthmon_merge(hm, template);
 		wake_up(&hm->wait);
 		goto out_unlock;
 	}
 
 	/* Only create a heap event object if we're not already at capacity. */
 	if (hm->events < XFS_HEALTHMON_MAX_EVENTS)
-		event = kmemdup(template, sizeof(struct xfs_healthmon_event),
-				GFP_NOFS);
+		event = xfs_healthmon_dup_event(template);
 	if (!event) {
 		/* No memory means we lose the event */
 		trace_xfs_healthmon_lost_event(hm);
@@ -899,11 +914,10 @@ xfs_healthmon_format_pop(
 		return NULL;
 
 	mutex_lock(&hm->lock);
-	event = hm->first_event;
+	event = list_first_entry_or_null(&hm->event_list,
+			struct xfs_healthmon_event, list);
 	if (event) {
-		if (hm->last_event == event)
-			hm->last_event = NULL;
-		hm->first_event = event->next;
+		list_del_init(&event->list);
 		hm->events--;
 
 		trace_xfs_healthmon_pop(hm, event);
@@ -1203,6 +1217,7 @@ xfs_ioc_health_monitor(
 		return -ENOMEM;
 	hm->dev = mp->m_super->s_dev;
 	refcount_set(&hm->ref, 1);
+	INIT_LIST_HEAD(&hm->event_list);
 
 	mutex_init(&hm->lock);
 	init_waitqueue_head(&hm->wait);
@@ -1211,7 +1226,7 @@ xfs_ioc_health_monitor(
 		hm->verbose = true;
 
 	/* Queue up the first event that lets the client know we're running. */
-	running_event = kzalloc_obj(struct xfs_healthmon_event, GFP_NOFS);
+	running_event = xfs_healthmon_alloc_event();
 	if (!running_event) {
 		ret = -ENOMEM;
 		goto out_hm;
@@ -1225,7 +1240,7 @@ xfs_ioc_health_monitor(
 	 * filesystem later.  This is key for triggering fast exit of the
 	 * xfs_healer daemon.
 	 */
-	hm->unmount_event = kzalloc_obj(struct xfs_healthmon_event, GFP_NOFS);
+	hm->unmount_event = xfs_healthmon_alloc_event();
 	if (!hm->unmount_event) {
 		ret = -ENOMEM;
 		goto out_hm;

