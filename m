Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71D832F764
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 05:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328034; cv=none; b=lJsqhlBMDuk3B6RD9BDeK91mWCdbYLfn8q8gxKzQUnUaS2sskoemhFUNHFKNmnKB/Z3O+9OG9fg/KzIMz2rIcEbiHIJPfUjrziVFTP4gRLBdVsHueIKOmKfL35+5c1zc7SKa8iNRp2NZKaDO7C25/DZ04TqAm9VOxpQ6qoGdrlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328034; c=relaxed/simple;
	bh=Rwnjw9dW0qPaC+K5f7uHxmf74bfZXyhkEo4PuyGUnds=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YnxC+vB9oOGC28Vw41Siy6jr6FWi+Z535m/AyESaW6IGYgU695GHPSxW0fex9Tyo0No9Fpvg3REdkaIRG9/UrqIxGj7rmefs0vMbZV3/ERrhanA2yvilcwZRWFBWmObIINyDRFT0gebCF4XfFqBnra5efSd5xvL/SXoaUMEEBdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eyaHlUQt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eyaHlUQt"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C3CC41F00A3D;
	Wed,  2 Sep 2026 05:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328032;
	bh=TbKndJvD40FQKfNZGAyd8hPzdG4WSOyPV4UbX3CytdE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=eyaHlUQtJI+N9wkpVJklln8EheuPPWusXbf9BVaKxnexyx3y9zWbkcnakQbEhE0Mj
	 4QxDntwMUf7A0CfBpXXrsLMcENsD3pipLaAv2xg+MVSidXl92IM6Jh383gTKOR2Ah9
	 OFwPdsC7/bHwqxc/PKqZextbLEJxFlvtVRMd42PFOL3j6wdAnXyXA+V/5cWQsct6OQ
	 1FrsjOk6to5qAWgLb/1k0rXgaNMcqBJzIOCBTcKS9xCc3rvcL3e6B2ZOXcNeGF9OgM
	 quT3lJvRgug1/Kad7cQpU7G3hMTrXkU8/SOpdYkM3/hZOpWK4UMfqtBh2RjwD+DMyC
	 qFRH8VTOonB1g==
Date: Tue, 01 Sep 2026 22:47:12 -0700
Subject: [PATCH 3/8] xfs: port healthmon event list to list_head
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178832750329.3507776.9204574745538598139.stgit@frogsfrogsfrogs>
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

Simplify the healthmon codebase by porting the single-link event list to
a standard list_head.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_healthmon.h |    5 ++---
 fs/xfs/xfs_healthmon.c |   36 +++++++++++++++---------------------
 2 files changed, 17 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/xfs_healthmon.h b/fs/xfs/xfs_healthmon.h
index 0e936507037fda..fa3deb187a2b31 100644
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
+	struct list_head		entry;
 
 	enum xfs_healthmon_type		type;
 	enum xfs_healthmon_domain	domain;
diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 2f7853b9277aca..fa3f77e2ef1398 100644
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
+		list_for_each_entry_safe(event, s, &hm->event_list, entry) {
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
+				xfs_healthmon_event, entry);
+
 	if (!existing)
 		return false;
 
@@ -281,10 +283,7 @@ __xfs_healthmon_insert(
 	ktime_get_coarse_real_ts64(&now);
 	event->time_ns = (now.tv_sec * NSEC_PER_SEC) + now.tv_nsec;
 
-	event->next = hm->first_event;
-	hm->first_event = event;
-	if (!hm->last_event)
-		hm->last_event = event;
+	list_add(&event->entry, &hm->event_list);
 	xfs_healthmon_bump_events(hm);
 	wake_up(&hm->wait);
 
@@ -304,12 +303,7 @@ __xfs_healthmon_push(
 	ktime_get_coarse_real_ts64(&now);
 	event->time_ns = (now.tv_sec * NSEC_PER_SEC) + now.tv_nsec;
 
-	if (!hm->first_event)
-		hm->first_event = event;
-	if (hm->last_event)
-		hm->last_event->next = event;
-	hm->last_event = event;
-	event->next = NULL;
+	list_add_tail(&event->entry, &hm->event_list);
 	xfs_healthmon_bump_events(hm);
 	wake_up(&hm->wait);
 
@@ -328,7 +322,7 @@ xfs_healthmon_clear_lost_prev(
 	};
 	struct xfs_healthmon_event	*event = NULL;
 
-	if (xfs_healthmon_merge_events(hm->last_event, &lost_event)) {
+	if (xfs_healthmon_merge_events(hm, &lost_event)) {
 		wake_up(&hm->wait);
 		goto cleared;
 	}
@@ -375,7 +369,7 @@ xfs_healthmon_push(
 	}
 
 	/* Try to merge with the newest event */
-	if (xfs_healthmon_merge_events(hm->last_event, template)) {
+	if (xfs_healthmon_merge_events(hm, template)) {
 		wake_up(&hm->wait);
 		goto out_unlock;
 	}
@@ -901,11 +895,10 @@ xfs_healthmon_format_pop(
 		return NULL;
 
 	mutex_lock(&hm->lock);
-	event = hm->first_event;
+	event = list_first_entry_or_null(&hm->event_list,
+			struct xfs_healthmon_event, entry);
 	if (event) {
-		if (hm->last_event == event)
-			hm->last_event = NULL;
-		hm->first_event = event->next;
+		list_del_init(&event->entry);
 		hm->events--;
 
 		trace_xfs_healthmon_pop(hm, event);
@@ -1205,6 +1198,7 @@ xfs_ioc_health_monitor(
 		return -ENOMEM;
 	hm->dev = mp->m_super->s_dev;
 	refcount_set(&hm->ref, 1);
+	INIT_LIST_HEAD(&hm->event_list);
 
 	mutex_init(&hm->lock);
 	init_waitqueue_head(&hm->wait);

