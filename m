Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718671FD7
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 00:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706748745; cv=none; b=WG2toxPIUtAWSWHTVj3NFo/96eAjIlKRu7x9Q2I2r/1WNDSURv9Sk0pTqvt3CDcDbUfcdXCjSjcItbaXCUuiiSU+vjC69IFN7eCrLvQmj+4ze3zbSTQ4IJHFXigv3JZeF6TgFtB+j8p0zGnUgRljvxEfWnKpLVhZBzjaJdGkPb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706748745; c=relaxed/simple;
	bh=sz4EaZbQhqERQgcHTiUuciivQPOk5svWDmppcz39W4o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+WbZJQCoiccy/au9xt4kaGgY4h0++0YRY0/pbstxQp7duOjst591s78E2UEKDPdyaOJXG4HtZbGMj65XWmn2B4SsodPOeUOTaYoVNzwQE/kpeyImIbF+YcE0suE1wHFHpBdG3I25glQthpDVxCtiIAhy7Dk4nS1f2lqRwD/DVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=AfXuJy+s; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="AfXuJy+s"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-295ecd6a198so820884a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 31 Jan 2024 16:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1706748742; x=1707353542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G7Cwnz63UMZXbU7/9fd1yvwFP+VmCnFrwi1tGKUyV1E=;
        b=AfXuJy+s/uJ63H6rkoXma7ijLFxO32UbOmY8fNORliKtU8k7JJDsBUku7Wbuhfbpua
         uj1uAibOjyyobggHQ+iXrkQK4Rl5aAgLtJzZx6/ejcsBbYNFHWdu86Lvfc3Ex/Ylv3Dk
         ShSJdEbATk+G+hbtp+C7kuczmC/ZRDz7beJ2R47kMTGxT3UnoB25lpnOzVkk89jgBWfh
         2ipKliV77v+WaFMJBYNTudaYA0buLAIpLfkwkp+L9AHc/DE8G6sTpo1U8ofebDGrN2uk
         AfyjF3EgHTh3naIRrtkmtE4XX+zUMzNmL0lHeYb8z9/COW00kdFVrrjYFxkqWB7j71tN
         N+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706748742; x=1707353542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G7Cwnz63UMZXbU7/9fd1yvwFP+VmCnFrwi1tGKUyV1E=;
        b=A5pZRK0T6YeJ1OHnaxoxGBI2XcvDQtPtg3HndXeXvIB5C/Lan8nknRz691ULxf9k6o
         xNK92u9I5uhcBEHx0dulxGG4ZhY0hoZtObZf2O0N5X8Fmjs2PjPkxAzIuNVjYkpsizCJ
         NJeCS1GYm9o7xFyDWlBiVSnlO28mNwcKHRUtIVOOv3xjqwFg068wQRbVM5cNqpOoN0Rg
         VFpGjXkRr27/MXmLqY6j9pv7O9WmOJtRzutY+MSo5h67tRuL6zTGjqJK5+++uAHA1ku/
         5Iapz2m550X2cH4a16lJ5R4XecLOZPeF2e8vLNM3Zc15gElDN6n11Hu+K1DZOA9WKwS7
         zBuA==
X-Gm-Message-State: AOJu0YzxPwYgp2uiMDf52r/43GjvqwU70D7t+g/AHWbkAvnkn1ipGu50
	w8E9oC96lfXPFnNkt8X8JdpFfdnemsFCxd/WKbFrdJ8WJ2kCk5+7eCdhK2JktrFs7rm3y79tOTZ
	E
X-Google-Smtp-Source: AGHT+IHvhxY5TqHox7Jk4ZIgllnFyqnOiUuMhe1Yb3MjF+gJmQxEsk4duDULdkj1JYjxfcOoVmuPYw==
X-Received: by 2002:a17:90b:3447:b0:296:c3e:ff5 with SMTP id lj7-20020a17090b344700b002960c3e0ff5mr951343pjb.8.1706748742624;
        Wed, 31 Jan 2024 16:52:22 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id dw18-20020a17090b095200b0028b845f2890sm2161663pjb.33.2024.01.31.16.52.21
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 16:52:21 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rVLJT-000O7c-2t
	for linux-xfs@vger.kernel.org;
	Thu, 01 Feb 2024 11:52:19 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rVLJT-00000004WR1-1dCr
	for linux-xfs@vger.kernel.org;
	Thu, 01 Feb 2024 11:52:19 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] xfs: prepare inode for i_gclist detection
Date: Thu,  1 Feb 2024 11:30:14 +1100
Message-ID: <20240201005217.1011010-3-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240201005217.1011010-1-david@fromorbit.com>
References: <20240201005217.1011010-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

We currently don't initialise the inode->i_gclist member because it
it not necessary for a pure llist_add/llist_del_all producer-
consumer usage pattern.  However, for lazy removal from the inodegc
list, we need to be able to determine if the inode is already on an
inodegc list before we queue it.

We can do this detection by using llist_on_list(), but this requires
that we initialise the llist_node before we use it, and we
re-initialise it when we remove it from the llist.

Because we already serialise the inodegc list add with inode state
changes under the ip->i_flags_lock, we can do the initialisation on
list removal atomically with the state change. We can also do the
check of whether the inode is already on a inodegc list inside the
state change region on insert.

This gives us the ability to use llist_on_list(ip->i_gclist) to
determine if the inode needs to be queued for inactivation without
having to depend on inode state flags.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 425b55526386..2dd1559aade2 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -114,6 +114,7 @@ xfs_inode_alloc(
 	spin_lock_init(&ip->i_ioend_lock);
 	ip->i_next_unlinked = NULLAGINO;
 	ip->i_prev_unlinked = 0;
+	init_llist_node(&ip->i_gclist);
 
 	return ip;
 }
@@ -1875,10 +1876,16 @@ xfs_inodegc_worker(
 	llist_for_each_entry_safe(ip, n, node, i_gclist) {
 		int	error;
 
-		/* Switch state to inactivating. */
+		/*
+		 * Switch state to inactivating and remove the inode from the
+		 * gclist. This allows the use of llist_on_list() in the queuing
+		 * code to determine if the inode is already on an inodegc
+		 * queue.
+		 */
 		spin_lock(&ip->i_flags_lock);
 		ip->i_flags |= XFS_INACTIVATING;
 		ip->i_flags &= ~XFS_NEED_INACTIVE;
+		init_llist_node(&ip->i_gclist);
 		spin_unlock(&ip->i_flags_lock);
 
 		error = xfs_inodegc_inactivate(ip);
@@ -2075,11 +2082,20 @@ xfs_inodegc_queue(
 	trace_xfs_inode_set_need_inactive(ip);
 
 	/*
-	 * Put the addition of the inode to the gc list under the
+	 * The addition of the inode to the gc list is done under the
 	 * ip->i_flags_lock so that the state change and list addition are
 	 * atomic w.r.t. lookup operations under the ip->i_flags_lock.
+	 * The removal is also done under the ip->i_flags_lock and so this
+	 * allows us to safely use llist_on_list() here to determine if the
+	 * inode is already queued on an inactivation queue.
 	 */
 	spin_lock(&ip->i_flags_lock);
+	ip->i_flags |= XFS_NEED_INACTIVE;
+
+	if (llist_on_list(&ip->i_gclist)) {
+		spin_unlock(&ip->i_flags_lock);
+		return;
+	}
 
 	cpu_nr = get_cpu();
 	gc = this_cpu_ptr(mp->m_inodegc);
@@ -2088,7 +2104,6 @@ xfs_inodegc_queue(
 	WRITE_ONCE(gc->items, items + 1);
 	shrinker_hits = READ_ONCE(gc->shrinker_hits);
 
-	ip->i_flags |= XFS_NEED_INACTIVE;
 	spin_unlock(&ip->i_flags_lock);
 
 	/*
-- 
2.43.0

