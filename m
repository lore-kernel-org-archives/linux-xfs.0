Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 131E5C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Nov 2021 01:58:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7B7461181
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Nov 2021 01:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhKJCBY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Nov 2021 21:01:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229445AbhKJCBY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Nov 2021 21:01:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636509517;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iVu/6miw6cZ+EK4STE8/3twDZU+GI6Ly37ampa/WIFs=;
        b=XA8egWcw/dYGjcUBVsiJXYg4iZF3mnilro09mbcgfK45ZSVC/pN8Dpwl22yUgSN56wSctA
        VK+SnIh16iPriIqVfzS8p9T1mowObKRweZSDkbN08pKJAbsyKHCWK4xcpDPtMPaNRZ6bEI
        iU1IdaEwNAMgilaL6DtGh+OqTzcrn8w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-qQXwL_tiNJCzdAvb8CgYbQ-1; Tue, 09 Nov 2021 20:58:36 -0500
X-MC-Unique: qQXwL_tiNJCzdAvb8CgYbQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D6A51808308
        for <linux-xfs@vger.kernel.org>; Wed, 10 Nov 2021 01:58:35 +0000 (UTC)
Received: from [127.0.0.1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 352745C1C5
        for <linux-xfs@vger.kernel.org>; Wed, 10 Nov 2021 01:58:35 +0000 (UTC)
Message-ID: <7e8a7998-5915-a9a4-e3db-50932781aee3@redhat.com>
Date:   Tue, 9 Nov 2021 19:58:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Content-Language: en-US
From:   Eric Sandeen <esandeen@redhat.com>
To:     xfs <linux-xfs@vger.kernel.org>
References: <a98ed48b-7297-34af-2a2a-795b15b35f12@redhat.com>
Reply-To: sandeen@redhat.com
Subject: [PATCH 1/3] libxfs: #ifdef out perag code for userspace
In-Reply-To: <a98ed48b-7297-34af-2a2a-795b15b35f12@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The xfs_perag structure and initialization is unused in userspace,
so #ifdef it out with __KERNEL__ to facilitate the xfsprogs sync
and build.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 005abfd9fd34..ecfb213d8fa3 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -248,6 +248,7 @@ xfs_initialize_perag(
  		spin_unlock(&mp->m_perag_lock);
  		radix_tree_preload_end();
  
+#ifdef __KERNEL__
  		/* Place kernel structure only init below this point. */
  		spin_lock_init(&pag->pag_ici_lock);
  		spin_lock_init(&pag->pagb_lock);
@@ -257,6 +258,7 @@ xfs_initialize_perag(
  		init_waitqueue_head(&pag->pagb_wait);
  		pag->pagb_count = 0;
  		pag->pagb_tree = RB_ROOT;
+#endif	/* __KERNEL_ */
  
  		error = xfs_buf_hash_init(pag);
  		if (error)
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 4c6f9045baca..01c36cfe6909 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -64,6 +64,10 @@ struct xfs_perag {
  	/* Blocks reserved for the reverse mapping btree. */
  	struct xfs_ag_resv	pag_rmapbt_resv;
  
+	/* for rcu-safe freeing */
+	struct rcu_head	rcu_head;
+
+#ifdef __KERNEL__
  	/* -- kernel only structures below this line -- */
  
  	/*
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

