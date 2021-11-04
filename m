Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF1B7C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 17:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9DFE610D0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 17:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbhKDRRu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Nov 2021 13:17:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60392 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233469AbhKDRRt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Nov 2021 13:17:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636046110;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a0eG0UYgUw6hU6QgUvij5trSn33iy8E4Vww1sxfGD0M=;
        b=ABUN6JSROn8tlwF4mcs3fr2nDtIPqmoRui7Y+kO9FV49Ag4FuA7WeEjXLGBwfX26KmFHEr
        Y86TSEw04s5j108iiS8PNKquo27hm2BxdNvnP2hcMHzVo0okwas4ZJDkxy7udT8fvrRSLu
        2d66ld7sNRvbTFYhFlhjkBz4crmU3vU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-lU8VwSQNPV-9QPpDo1a2pA-1; Thu, 04 Nov 2021 13:15:07 -0400
X-MC-Unique: lU8VwSQNPV-9QPpDo1a2pA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 964701923761;
        Thu,  4 Nov 2021 17:15:05 +0000 (UTC)
Received: from [127.0.0.1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C5ED19C79;
        Thu,  4 Nov 2021 17:15:05 +0000 (UTC)
Message-ID: <fa2fe2c5-645b-6263-3493-b59b4d096488@redhat.com>
Date:   Thu, 4 Nov 2021 12:15:04 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Content-Language: en-US
From:   Eric Sandeen <esandeen@redhat.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>
References: <389722a5-4b02-c76d-a5ac-d92d1e642b21@redhat.com>
Reply-To: sandeen@redhat.com
Subject: [PATCH V3 RFC] xfsprogs: remove stubbed-out kernel functions out from
 xfs_shared.h
In-Reply-To: <389722a5-4b02-c76d-a5ac-d92d1e642b21@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove these kernel stubs by #ifdeffing code instead.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Dave preferred #ifdefs over stubs, and this is what I came up with.

Honestly, I think this is worse, and will lead to more libxfs-sync pain
unless we're willing to scatter #ifdefs around the kernel code as well,
but I figured I'd put this out there for discussion.

diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 9eda6eba..c01986f7 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -170,7 +170,9 @@ __xfs_free_perag(
  {
  	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
  
+#ifdef __KERNEL__
  	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
+#endif	/* __KERNEL__ */
  	ASSERT(atomic_read(&pag->pag_ref) == 0);
  	kmem_free(pag);
  }
@@ -192,9 +194,11 @@ xfs_free_perag(
  		ASSERT(pag);
  		ASSERT(atomic_read(&pag->pag_ref) == 0);
  
+#ifdef __KERNEL__
  		cancel_delayed_work_sync(&pag->pag_blockgc_work);
  		xfs_iunlink_destroy(pag);
  		xfs_buf_hash_destroy(pag);
+#endif	/* __KERNEL__ */
  
  		call_rcu(&pag->rcu_head, __xfs_free_perag);
  	}
@@ -246,6 +250,7 @@ xfs_initialize_perag(
  		spin_unlock(&mp->m_perag_lock);
  		radix_tree_preload_end();
  
+#ifdef __KERNEL__
  		/* Place kernel structure only init below this point. */
  		spin_lock_init(&pag->pag_ici_lock);
  		spin_lock_init(&pag->pagb_lock);
@@ -267,6 +272,7 @@ xfs_initialize_perag(
  		/* first new pag is fully initialized */
  		if (first_initialised == NULLAGNUMBER)
  			first_initialised = index;
+#endif	/* __KERNEL__ */
  	}
  
  	index = xfs_set_inode_alloc(mp, agcount);
@@ -277,10 +283,12 @@ xfs_initialize_perag(
  	mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);
  	return 0;
  
+#ifdef __KERNEL__
  out_hash_destroy:
  	xfs_buf_hash_destroy(pag);
  out_remove_pag:
  	radix_tree_delete(&mp->m_perag_tree, index);
+#endif	/* __KERNEL__ */
  out_free_pag:
  	kmem_free(pag);
  out_unwind_new_pags:
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 4c6f9045..dda1303e 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -64,6 +64,9 @@ struct xfs_perag {
  	/* Blocks reserved for the reverse mapping btree. */
  	struct xfs_ag_resv	pag_rmapbt_resv;
  
+	/* for rcu-safe freeing */
+	struct rcu_head	rcu_head;
+
  	/* -- kernel only structures below this line -- */
  
  	/*
@@ -75,6 +78,7 @@ struct xfs_perag {
  	spinlock_t	pag_state_lock;
  
  	spinlock_t	pagb_lock;	/* lock for pagb_tree */
+#ifdef __KERNEL__
  	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
  	unsigned int	pagb_gen;	/* generation count for pagb_tree */
  	wait_queue_head_t pagb_wait;	/* woken when pagb_gen changes */
@@ -90,9 +94,6 @@ struct xfs_perag {
  	spinlock_t	pag_buf_lock;	/* lock for pag_buf_hash */
  	struct rhashtable pag_buf_hash;
  
-	/* for rcu-safe freeing */
-	struct rcu_head	rcu_head;
-
  	/* background prealloc block trimming */
  	struct delayed_work	pag_blockgc_work;
  
@@ -102,6 +103,7 @@ struct xfs_perag {
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

