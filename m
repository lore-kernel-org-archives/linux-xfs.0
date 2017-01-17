Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40180 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751026AbdAQWoh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:44:37 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9488A61B8A
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2017 22:44:38 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v0HMibM2027384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2017 17:44:38 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH (TRIVIAL)] xfs: remove unused struct declarations
Message-ID: <e0a94cb5-3283-eaba-346d-eff3a3e9c047@redhat.com>
Date: Tue, 17 Jan 2017 16:44:36 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

After scratching my head looking for "xfs_busy_extent" I realized
it's not used; it's xfs_extent_busy, and the declaration for the
other name is bogus.  Remove that and a few others as well.

(struct xfs_log_callback is used, but the 2nd declaration is
unnecessary).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index d9f65e2..29a01ec 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -42,7 +42,6 @@
 	xfs_log_iovec_t		*ri_buf;	/* ptr to regions buffer */
 } xlog_recover_item_t;
 
-struct xlog_tid;
 typedef struct xlog_recover {
 	struct hlist_node	r_list;
 	xlog_tid_t		r_log_tid;	/* log's transaction id */
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index b5e7107..cc5a9f1 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -124,7 +124,6 @@ static inline xfs_lsn_t	_lsn_cmp(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
 struct xfs_log_item;
 struct xfs_item_ops;
 struct xfs_trans;
-struct xfs_log_callback;
 
 xfs_lsn_t xfs_log_done(struct xfs_mount *mp,
 		       struct xlog_ticket *ticket,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 69c5bcd..6432227 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2245,7 +2245,6 @@
 
 /* deferred ops */
 struct xfs_defer_pending;
-struct xfs_defer_intake;
 struct xfs_defer_ops;
 
 DECLARE_EVENT_CLASS(xfs_defer_class,
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 61b7fbd..1646f65 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -32,7 +32,6 @@
 struct xfs_trans;
 struct xfs_trans_res;
 struct xfs_dquot_acct;
-struct xfs_busy_extent;
 struct xfs_rud_log_item;
 struct xfs_rui_log_item;
 struct xfs_btree_cur;

