Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60524 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757170AbcJGVCm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Oct 2016 17:02:42 -0400
Subject: Re: [PATCH 2/1] xfs: Remove more unused tracepoints
References: <1475788713-3415-1-git-send-email-agruenba@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ce8bd269-4717-681f-be30-b6e8d9e68eba@sandeen.net>
Date: Fri, 7 Oct 2016 16:02:38 -0500
MIME-Version: 1.0
In-Reply-To: <1475788713-3415-1-git-send-email-agruenba@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org

There are several old, stale, unused tracepoints.  Remove them.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

trace_xfs_inode_item_push is also unused, but probably should be used?

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 2586c9c..a3e9e71 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -355,7 +355,6 @@ DEFINE_BUF_EVENT(xfs_buf_rele);
 DEFINE_BUF_EVENT(xfs_buf_iodone);
 DEFINE_BUF_EVENT(xfs_buf_submit);
 DEFINE_BUF_EVENT(xfs_buf_submit_wait);
-DEFINE_BUF_EVENT(xfs_buf_bawrite);
 DEFINE_BUF_EVENT(xfs_buf_lock);
 DEFINE_BUF_EVENT(xfs_buf_lock_done);
 DEFINE_BUF_EVENT(xfs_buf_trylock_fail);
@@ -367,17 +366,14 @@ DEFINE_BUF_EVENT(xfs_buf_delwri_queue);
 DEFINE_BUF_EVENT(xfs_buf_delwri_queued);
 DEFINE_BUF_EVENT(xfs_buf_delwri_split);
 DEFINE_BUF_EVENT(xfs_buf_get_uncached);
-DEFINE_BUF_EVENT(xfs_bdstrat_shut);
 DEFINE_BUF_EVENT(xfs_buf_item_relse);
 DEFINE_BUF_EVENT(xfs_buf_item_iodone_async);
 DEFINE_BUF_EVENT(xfs_buf_error_relse);
 DEFINE_BUF_EVENT(xfs_buf_wait_buftarg);
-DEFINE_BUF_EVENT(xfs_trans_read_buf_io);
 DEFINE_BUF_EVENT(xfs_trans_read_buf_shut);
 
 /* not really buffer traces, but the buf provides useful information */
 DEFINE_BUF_EVENT(xfs_btree_corrupt);
-DEFINE_BUF_EVENT(xfs_da_btree_corrupt);
 DEFINE_BUF_EVENT(xfs_reset_dqcounts);
 DEFINE_BUF_EVENT(xfs_inode_item_push);
 
@@ -541,7 +537,6 @@ DEFINE_BUF_ITEM_EVENT(xfs_trans_bjoin);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold_release);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_binval);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_buf_ordered);
 
 DECLARE_EVENT_CLASS(xfs_filestream_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_agnumber_t agno),
@@ -939,7 +934,6 @@ DEFINE_DQUOT_EVENT(xfs_dqget_miss);
 DEFINE_DQUOT_EVENT(xfs_dqget_freeing);
 DEFINE_DQUOT_EVENT(xfs_dqget_dup);
 DEFINE_DQUOT_EVENT(xfs_dqput);
-DEFINE_DQUOT_EVENT(xfs_dqput_wait);
 DEFINE_DQUOT_EVENT(xfs_dqput_free);
 DEFINE_DQUOT_EVENT(xfs_dqrele);
 DEFINE_DQUOT_EVENT(xfs_dqflush);
@@ -1816,7 +1810,6 @@ DEFINE_ATTR_EVENT(xfs_attr_sf_addname);
 DEFINE_ATTR_EVENT(xfs_attr_sf_create);
 DEFINE_ATTR_EVENT(xfs_attr_sf_lookup);
 DEFINE_ATTR_EVENT(xfs_attr_sf_remove);
-DEFINE_ATTR_EVENT(xfs_attr_sf_removename);
 DEFINE_ATTR_EVENT(xfs_attr_sf_to_leaf);
 
 DEFINE_ATTR_EVENT(xfs_attr_leaf_add);
@@ -1845,7 +1838,6 @@ DEFINE_ATTR_EVENT(xfs_attr_leaf_toosmall);
 
 DEFINE_ATTR_EVENT(xfs_attr_node_addname);
 DEFINE_ATTR_EVENT(xfs_attr_node_get);
-DEFINE_ATTR_EVENT(xfs_attr_node_lookup);
 DEFINE_ATTR_EVENT(xfs_attr_node_replace);
 DEFINE_ATTR_EVENT(xfs_attr_node_removename);
 
@@ -2441,11 +2433,9 @@ DEFINE_DEFER_EVENT(xfs_defer_finish_done);
 
 DEFINE_DEFER_ERROR_EVENT(xfs_defer_trans_roll_error);
 DEFINE_DEFER_ERROR_EVENT(xfs_defer_finish_error);
-DEFINE_DEFER_ERROR_EVENT(xfs_defer_op_finish_error);
 
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_intake_work);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_intake_cancel);
-DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_commit);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_cancel);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_finish);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_abort);

