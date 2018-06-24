Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57764 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751593AbeFXTY3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jun 2018 15:24:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5OJOTVm119917
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:29 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2jt7mp8hp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:29 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJORTW020122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:28 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJOR0m031691
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:27 GMT
Subject: [PATCH 09/21] xfs: finish our set of inode get/put tracepoints for
 scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 24 Jun 2018 12:24:26 -0700
Message-ID: <152986826640.3155.4987566125495724086.stgit@magnolia>
In-Reply-To: <152986820984.3155.16417868536016544528.stgit@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Finish setting up tracepoints to track inode get/put operations when
running them through the scrub code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/common.c |    2 ++
 fs/xfs/scrub/dir.c    |    1 +
 fs/xfs/scrub/parent.c |    1 +
 fs/xfs/scrub/scrub.c  |    1 +
 fs/xfs/scrub/trace.h  |    3 +++
 5 files changed, 8 insertions(+)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 9740c28384b6..6dcd83944ab6 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -717,7 +717,9 @@ xfs_scrub_get_inode(
 				error, __return_address);
 		return error;
 	}
+	trace_xfs_scrub_iget_target(ip, __this_address);
 	if (VFS_I(ip)->i_generation != sc->sm->sm_gen) {
+		trace_xfs_scrub_iput_target(ip, __this_address);
 		iput(VFS_I(ip));
 		return -ENOENT;
 	}
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 5cb371576732..a11dde63535c 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -81,6 +81,7 @@ xfs_scrub_dir_check_ftype(
 	if (!xfs_scrub_fblock_xref_process_error(sdc->sc, XFS_DATA_FORK, offset,
 			&error))
 		goto out;
+	trace_xfs_scrub_iget(ip, __this_address);
 
 	/* Convert mode to the DT_* values that dir_emit uses. */
 	ino_dtype = xfs_dir3_get_dtype(mp,
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index fd0b2bfb8f18..c5ce6622d4f9 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -170,6 +170,7 @@ xfs_scrub_parent_validate(
 	}
 	if (!xfs_scrub_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out;
+	trace_xfs_scrub_iget(dp, __this_address);
 	if (dp == sc->ip || !S_ISDIR(VFS_I(dp)->i_mode)) {
 		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		goto out_rele;
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index b66cfbc56a34..b24b37b34d85 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -191,6 +191,7 @@ xfs_scrub_teardown(
 		sc->tp = NULL;
 	}
 	if (sc->ip) {
+		trace_xfs_scrub_iput_target(sc->ip, __this_address);
 		if (sc->ilock_flags)
 			xfs_iunlock(sc->ip, sc->ilock_flags);
 		if (sc->ip != ip_in &&
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index a050a00fc258..2a561689cecb 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -509,6 +509,9 @@ DEFINE_EVENT(xfs_scrub_iref_class, name, \
 DEFINE_SCRUB_IREF_EVENT(xfs_scrub_iput_deferred);
 DEFINE_SCRUB_IREF_EVENT(xfs_scrub_iput_defer);
 DEFINE_SCRUB_IREF_EVENT(xfs_scrub_iput_now);
+DEFINE_SCRUB_IREF_EVENT(xfs_scrub_iget);
+DEFINE_SCRUB_IREF_EVENT(xfs_scrub_iget_target);
+DEFINE_SCRUB_IREF_EVENT(xfs_scrub_iput_target);
 
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)

