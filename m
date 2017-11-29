Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36767 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752526AbdK2B1F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 20:27:05 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAT1R4SE022304
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:27:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAT1R4eD016053
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:27:04 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vAT1R3cc027739
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:27:03 GMT
Subject: [PATCH 16/16] xfs: abort scrubs if the oom killer fires
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 28 Nov 2017 17:27:02 -0800
Message-ID: <151191882279.8553.4374638698461727073.stgit@magnolia>
In-Reply-To: <151191872395.8553.15627872818207535470.stgit@magnolia>
References: <151191872395.8553.15627872818207535470.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

On a filesystem with a large amount of metadata, we can run the system
nearly out of memory while we process metadata.  If the OOM killer fires
anywhere in the system, ask the running scrub processes to abort with
ENOMEM and try again later.

(This will become more of a problem with online repair where we will
have to hold all of a reconstructed data structure in memory.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/common.h |    5 +++++
 fs/xfs/scrub/scrub.c  |   27 +++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h  |    4 ++++
 3 files changed, 36 insertions(+)


diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 6372456..16fa0b7 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -30,6 +30,11 @@ xfs_scrub_should_terminate(
 	struct xfs_scrub_context	*sc,
 	int				*error)
 {
+	if (sc->is_oom) {
+		if (*error == 0)
+			*error = -ENOMEM;
+		return true;
+	}
 	if (fatal_signal_pending(current)) {
 		if (*error == 0)
 			*error = -EAGAIN;
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index c4ad1b7..7edb26a 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -49,6 +49,8 @@
 #include "scrub/scrub.h"
 #include "scrub/btree.h"
 
+#include <linux/oom.h>
+
 /*
  * Online Scrub and Repair
  *
@@ -156,6 +158,9 @@ xfs_scrub_teardown(
 	struct xfs_inode		*ip_in,
 	int				error)
 {
+	if (sc->oom_notify.notifier_call)
+		unregister_oom_notifier(&sc->oom_notify);
+
 	xfs_scrub_ag_free(sc, &sc->sa);
 	if (sc->tp) {
 		xfs_trans_cancel(sc->tp);
@@ -295,6 +300,21 @@ xfs_scrub_experimental_warning(
 "EXPERIMENTAL online scrub feature in use. Use at your own risk!");
 }
 
+/* Uhoh, an OOM kill happened, try to kill any running scrubs. */
+static int
+xfs_scrub_oom_kill(
+	struct notifier_block		*notifier,
+	unsigned long			action,
+	void				*data)
+{
+	struct xfs_scrub_context	*sc;
+
+	sc = container_of(notifier, struct xfs_scrub_context, oom_notify);
+	sc->is_oom = true;
+
+	return NOTIFY_DONE;
+}
+
 /* Dispatch metadata scrubbing. */
 int
 xfs_scrub_metadata(
@@ -366,6 +386,13 @@ xfs_scrub_metadata(
 	sc.ops = ops;
 	sc.try_harder = try_harder;
 	sc.sa.agno = NULLAGNUMBER;
+	sc.oom_notify.notifier_call = xfs_scrub_oom_kill;
+	sc.oom_notify.priority = 1; /* call us first */
+	error = register_oom_notifier(&sc.oom_notify);
+	if (error) {
+		sc.oom_notify.notifier_call = NULL;
+		goto out_teardown;
+	}
 	error = sc.ops->setup(&sc, ip);
 	if (error)
 		goto out_teardown;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index a1cd43d..610b88d6 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -63,6 +63,10 @@ struct xfs_scrub_context {
 	uint				ilock_flags;
 	bool				try_harder;
 
+	/* Kill scrub/repair if we OOM. */
+	struct notifier_block		oom_notify;
+	bool				is_oom;
+
 	/* State tracking for single-AG operations. */
 	struct xfs_scrub_ag		sa;
 };

