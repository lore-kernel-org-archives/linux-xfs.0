Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B3E4C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Nov 2021 16:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CF2C61252
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Nov 2021 16:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbhKEQni (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Nov 2021 12:43:38 -0400
Received: from sandeen.net ([63.231.237.45]:56392 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233079AbhKEQni (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Nov 2021 12:43:38 -0400
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7C7AE33D5;
        Fri,  5 Nov 2021 11:39:16 -0500 (CDT)
Message-ID: <0123f094-a073-0ba8-7cac-27394193d277@sandeen.net>
Date:   Fri, 5 Nov 2021 11:40:57 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>, sandeen@redhat.com
Cc:     xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
References: <389722a5-4b02-c76d-a5ac-d92d1e642b21@redhat.com>
 <fa2fe2c5-645b-6263-3493-b59b4d096488@redhat.com>
 <20211104223823.GF449541@dread.disaster.area>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH V3 RFC] xfsprogs: remove stubbed-out kernel functions out
 from xfs_shared.h
In-Reply-To: <20211104223823.GF449541@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/4/21 5:38 PM, Dave Chinner wrote:

> With those changes, we end up with some new stubs in libxfs_priv.h
> and two places where we need #ifdef __KERNEL__ in xfs_ag.[ch]. Most
> of the mess in this patch goes away....
> 
> Cheers,
> 
> Dave.
Ok.

I will split this up into the right patch granularity, but is this the
endpoint you're looking for?  One #ifdef in each of xfs_ag.[ch], two total.

The delayed work init/cancel assymmetry is a little odd, but I'll
get over it.

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 15bae1ff..2ca3b9b2 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -673,6 +673,9 @@ static inline void xfs_iunlink_destroy(struct xfs_perag *pag) { }
  xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *mp,
  		xfs_agnumber_t agcount);
  
+/* Faked up kernel bits */
+#define cancel_delayed_work_sync(work) do { } while(0)
+
  /* Keep static checkers quiet about nonstatic functions by exporting */
  int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
  		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 9eda6eba..149f9857 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -246,6 +246,7 @@ xfs_initialize_perag(
  		spin_unlock(&mp->m_perag_lock);
  		radix_tree_preload_end();
  
+#ifdef __KERNEL__
  		/* Place kernel structure only init below this point. */
  		spin_lock_init(&pag->pag_ici_lock);
  		spin_lock_init(&pag->pagb_lock);
@@ -255,6 +256,7 @@ xfs_initialize_perag(
  		init_waitqueue_head(&pag->pagb_wait);
  		pag->pagb_count = 0;
  		pag->pagb_tree = RB_ROOT;
+#endif	/* __KERNEL_ */
  
  		error = xfs_buf_hash_init(pag);
  		if (error)
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 4c6f9045..ef04a537 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -64,8 +64,11 @@ struct xfs_perag {
  	/* Blocks reserved for the reverse mapping btree. */
  	struct xfs_ag_resv	pag_rmapbt_resv;
  
-	/* -- kernel only structures below this line -- */
+	/* for rcu-safe freeing */
+	struct rcu_head	rcu_head;
  
+#ifdef __KERNEL__
+	/* -- kernel only structures below this line -- */
  	/*
  	 * Bitsets of per-ag metadata that have been checked and/or are sick.
  	 * Callers should hold pag_state_lock before accessing this field.
@@ -90,9 +93,6 @@ struct xfs_perag {
  	spinlock_t	pag_buf_lock;	/* lock for pag_buf_hash */
  	struct rhashtable pag_buf_hash;
  
-	/* for rcu-safe freeing */
-	struct rcu_head	rcu_head;
-
  	/* background prealloc block trimming */
  	struct delayed_work	pag_blockgc_work;
  
@@ -102,6 +102,7 @@ struct xfs_perag {
  	 * or have some other means to control concurrency.
  	 */
  	struct rhashtable	pagi_unlinked_hash;
+#endif	/* __KERNEL__ */
  };
  
  int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index bafee48c..25c4cab5 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -180,24 +180,4 @@ struct xfs_ino_geometry {
  
  };
  
-/* Faked up kernel bits */
-struct rb_root {
-};
-
-#define RB_ROOT 		(struct rb_root) { }
-
-typedef struct wait_queue_head {
-} wait_queue_head_t;
-
-#define init_waitqueue_head(wqh)	do { } while(0)
-
-struct rhashtable {
-};
-
-struct delayed_work {
-};
-
-#define INIT_DELAYED_WORK(work, func)	do { } while(0)
-#define cancel_delayed_work_sync(work)	do { } while(0)
-
  #endif /* __XFS_SHARED_H__ */
