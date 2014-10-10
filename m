Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8B52B7F5A
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7ADD8304053
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:10 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id jRHBfW57l8kSII6A (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:09 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH for 3.14-stable] fanotify: fix double free of pending
	permission events
Date: Fri, 10 Oct 2014 16:23:21 +0200
Message-Id: <1412951028-4085-17-git-send-email-jack@suse.cz>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, stable@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

commit 5838d4442bd5971687b72221736222637e03140d upstream.

Commit 85816794240b ("fanotify: Fix use after free for permission
events") introduced a double free issue for permission events which are
pending in group's notification queue while group is being destroyed.
These events are freed from fanotify_handle_event() but they are not
removed from groups notification queue and thus they get freed again
from fsnotify_flush_notify().

Fix the problem by removing permission events from notification queue
before freeing them if we skip processing access response.  Also expand
comments in fanotify_release() to explain group shutdown in detail.

Fixes: 85816794240b9659e66e4d9b0df7c6e814e5f603
Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Douglas Leeder <douglas.leeder@sophos.com>
Tested-by: Douglas Leeder <douglas.leeder@sophos.com>
Reported-by: Heinrich Schuchard <xypron.glpk@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/notify/fanotify/fanotify.c      |  9 ++++++++-
 fs/notify/fanotify/fanotify_user.c | 12 ++++++++++++
 fs/notify/notification.c           | 18 +++++++++++++++++-
 include/linux/fsnotify_backend.h   |  2 ++
 4 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index dc638f786d5c..aadf397be4d9 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -70,8 +70,15 @@ static int fanotify_get_response_from_access(struct fsnotify_group *group,
 	wait_event(group->fanotify_data.access_waitq, event->response ||
 				atomic_read(&group->fanotify_data.bypass_perm));
 
-	if (!event->response) /* bypass_perm set */
+	if (!event->response) {	/* bypass_perm set */
+		/*
+		 * Event was canceled because group is being destroyed. Remove
+		 * it from group's event list because we are responsible for
+		 * freeing the permission event.
+		 */
+		fsnotify_remove_event(group, &event->fse);
 		return 0;
+	}
 
 	/* userspace responded, convert to something usable */
 	switch (event->response) {
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 287a22c04149..ceb130dd3ac8 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -385,6 +385,11 @@ static int fanotify_release(struct inode *ignored, struct file *file)
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	struct fanotify_response_event *re, *lre;
 
+	/*
+	 * There may be still new events arriving in the notification queue
+	 * but since userspace cannot use fanotify fd anymore, no event can
+	 * enter or leave access_list by now.
+	 */
 	mutex_lock(&group->fanotify_data.access_mutex);
 
 	atomic_inc(&group->fanotify_data.bypass_perm);
@@ -400,6 +405,13 @@ static int fanotify_release(struct inode *ignored, struct file *file)
 	}
 	mutex_unlock(&group->fanotify_data.access_mutex);
 
+	/*
+	 * Since bypass_perm is set, newly queued events will not wait for
+	 * access response. Wake up the already sleeping ones now.
+	 * synchronize_srcu() in fsnotify_destroy_group() will wait for all
+	 * processes sleeping in fanotify_handle_event() waiting for access
+	 * response and thus also for all permission events to be freed.
+	 */
 	wake_up(&group->fanotify_data.access_waitq);
 #endif
 
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 1e58402171a5..25a07c70f1c9 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -73,7 +73,8 @@ void fsnotify_destroy_event(struct fsnotify_group *group,
 	/* Overflow events are per-group and we don't want to free them */
 	if (!event || event->mask == FS_Q_OVERFLOW)
 		return;
-
+	/* If the event is still queued, we have a problem... */
+	WARN_ON(!list_empty(&event->list));
 	group->ops->free_event(event);
 }
 
@@ -125,6 +126,21 @@ queue:
 }
 
 /*
+ * Remove @event from group's notification queue. It is the responsibility of
+ * the caller to destroy the event.
+ */
+void fsnotify_remove_event(struct fsnotify_group *group,
+			   struct fsnotify_event *event)
+{
+	mutex_lock(&group->notification_mutex);
+	if (!list_empty(&event->list)) {
+		list_del_init(&event->list);
+		group->q_len--;
+	}
+	mutex_unlock(&group->notification_mutex);
+}
+
+/*
  * Remove and return the first event from the notification list.  It is the
  * responsibility of the caller to destroy the obtained event
  */
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 64cf3ef50696..6191c2edb8c7 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -326,6 +326,8 @@ extern int fsnotify_add_notify_event(struct fsnotify_group *group,
 				     struct fsnotify_event *event,
 				     int (*merge)(struct list_head *,
 						  struct fsnotify_event *));
+/* Remove passed event from groups notification queue */
+extern void fsnotify_remove_event(struct fsnotify_group *group, struct fsnotify_event *event);
 /* true if the group notification queue is empty */
 extern bool fsnotify_notify_queue_is_empty(struct fsnotify_group *group);
 /* return, but do not dequeue the first event on the notification queue */
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
