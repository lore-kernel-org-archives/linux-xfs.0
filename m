Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6380C352FED
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222879; cv=none; b=eR9ka7pseou6jH4U4vZs1gGV/H3GEUXkOpGvOWRAo4g9JBBdSvnQb05l82UMzPYv57yrMCKt5lv+inYx6U71yT6oJkRu5Nw5jzwnfPG3FXHcjv3weQGhNyEjeZp9sgcAQpdQ40MyHv9regkvSovHOSKuzALkh7XivPTb1YL8JIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222879; c=relaxed/simple;
	bh=3EjK7e1wo9m6QIxNaE+tEjCwYN+DkEURl0dI7nbECcA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTujysNteNMRaxbh6/s5Q+SFjuUvalBJ0NWUZvFZ/e/hTfbX7Gjn5p3u/+uMy0BnKrVY+2zYXznMQriJENTT6/P+7qUi84wRXlFXcbRrtTkCaay7lL2Vkt9MTr+Hux3IssKUjRmDMkWpuhsmS/cF7dBEDAwtQAZ16n0MKsQ/j88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=Wr0maEcw; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="Wr0maEcw"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-71d605a70bdso37816427b3.3
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222875; x=1756827675; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ShFlqp5VOipOeM7qzYThb9TpsgG09sUanUCy1d9D4RI=;
        b=Wr0maEcwFRF6AKZxE59ULTSS8opjYy1ESQuAR6xP2rwpUAvHZMhx0gbecia4vGBMlw
         ZUdLkrAJ6JkvidItwaV/tfmZJWmZ2E0svXesR00FEXYHGvhMEnx9sUrSrMRrZF9J36Cw
         SRwx8BXsRx8d/p7O0TJNV5bzcwuzgG5CrQfCMGtJJrSOv4ffnjQiJQWkHIO8tJT1sRvs
         GJDdVwvQhhxXFoftGApjiJ8FLJH6BPrF2SCNNBr3y0Hx8KpB2eLznBa79Vl4fiQAzUpQ
         zzaWz7rM9ZrMsFPbgmy82cgV4SZSW4Y+dIBmMjDsTs+3Fp841dUo5C7vJeXJW7yEOSu5
         qPMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222875; x=1756827675;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ShFlqp5VOipOeM7qzYThb9TpsgG09sUanUCy1d9D4RI=;
        b=k414mSpWW7dKwNdyiy/6HrdkhijpWt9Qn/zJOLhtGxMOYgbWceCGivE5agU5g6JFiP
         KToKoXWT5fLNiwytY6Px2BFhRkC8b4hL099m+3jPGXaby8LxFYEv2ylr2MXxwLSgPpy0
         5x2cVI4EwlShdRg3buoInohpt9uJDtFJetIF2Fk8Xa25B3O/msI/MCJ3TSrvn0LYj8hT
         oj+objkY7W3AkM/SAD8huJSq1yx44lTpsFwUWAo6XW9IRqbOGUNd76vnuh3byuUp5dEd
         NRFiI80CMHFGduzlzDHOF3FOwq1kf8Coi4bZw8u038kw0934J1Z3dU82iYRYcRSLOgnl
         0OtA==
X-Forwarded-Encrypted: i=1; AJvYcCWVNUIlkTop9oyhA5cXzm5T0zlX5AlAUCrmEhIxL0U7QgwsXMKR29qDNF7zAYZnDkJZARk5xNWLZew=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxt3JEbjaBZgLnlTEvIDErg59IxYR/qLtwGo/EL83yFKkslP8+z
	XNlmhU0eiYCqx01lDrU1Zjv29mqe5g69Z/Mhgwarc/08Xwicn3l0OI8w3+0bOPYIX3I=
X-Gm-Gg: ASbGncskA0pr+13uY1jTzUQh/XsdqdPlftiKsRMi8Hw/vdUN72tyKY6LV6wEHTcT7OK
	oM/Xg0JDIJ0JgZqnjcz5MAp4+umHqzooaG/pEE6whkVdSB+3opIs7E7IeIeRS+E8GkVhAxEfT/v
	MNwukyBD5BSiZqzWerot04SYAHI+SVrd1TPpdVplOtJyeqBXpFMDiW9wUXmxMZcvhpZf2GYmJ1s
	Ld9T/q4UZf1fedaiPYPajEb1VMStFPi4ie6qmlKbXZbeKWjZuTRERKxcJLgsW/9AmykhEHaG8rO
	g4rYvMEYDqJ5zu2dzgQ9tDGjOvQhgWD/1q1SIp590B8se+s3FSCGbuqy9Dlz5RmtejMOucG3i+t
	iURKcy+7FSB+xTh7DVzH5ViILzu7C1jqQFPnhlpRka9KinM6mRYDjBni9DC8ikrfCT5MbEg==
X-Google-Smtp-Source: AGHT+IFxo/w7op/ge+NmnsNsGn77AjHcEkfsy56WOUb8EsB10dRusVpRuEuCR4A5mjkx2bVUh5AkJg==
X-Received: by 2002:a05:690c:6082:b0:721:10a3:6584 with SMTP id 00721157ae682-72110a36c63mr79058537b3.11.1756222874743;
        Tue, 26 Aug 2025 08:41:14 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff18af680sm25272777b3.58.2025.08.26.08.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:14 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 18/54] fs: change evict_inodes to use iput instead of evict directly
Date: Tue, 26 Aug 2025 11:39:18 -0400
Message-ID: <2e71234c109ee6a45a469022436cc5c3d31914ed.1756222465.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756222464.git.josef@toxicpanda.com>
References: <cover.1756222464.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At evict_inodes() time, we no longer have SB_ACTIVE set, so we can
easily go through the normal iput path to clear any inodes. Update
dispose_list() to check how we need to free the inode, and then grab a
full reference to the inode while we're looping through the remaining
inodes, and simply iput them at the end.

Since we're just calling iput we don't really care about the i_count on
the inode at the current time.  Remove the i_count checks and just call
iput on every inode we find.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 399598e90693..ede9118bb649 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -933,7 +933,7 @@ static void evict(struct inode *inode)
  * Dispose-list gets a local list with local inodes in it, so it doesn't
  * need to worry about list corruption and SMP locks.
  */
-static void dispose_list(struct list_head *head)
+static void dispose_list(struct list_head *head, bool for_lru)
 {
 	while (!list_empty(head)) {
 		struct inode *inode;
@@ -941,8 +941,12 @@ static void dispose_list(struct list_head *head)
 		inode = list_first_entry(head, struct inode, i_lru);
 		list_del_init(&inode->i_lru);
 
-		evict(inode);
-		iobj_put(inode);
+		if (for_lru) {
+			evict(inode);
+			iobj_put(inode);
+		} else {
+			iput(inode);
+		}
 		cond_resched();
 	}
 }
@@ -964,21 +968,13 @@ void evict_inodes(struct super_block *sb)
 again:
 	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (icount_read(inode))
-			continue;
-
 		spin_lock(&inode->i_lock);
-		if (icount_read(inode)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
 		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
 
-		inode->i_state |= I_FREEING;
-		iobj_get(inode);
+		__iget(inode);
 		inode_lru_list_del(inode);
 		spin_unlock(&inode->i_lock);
 		list_add(&inode->i_lru, &dispose);
@@ -991,13 +987,13 @@ void evict_inodes(struct super_block *sb)
 		if (need_resched()) {
 			spin_unlock(&sb->s_inode_list_lock);
 			cond_resched();
-			dispose_list(&dispose);
+			dispose_list(&dispose, false);
 			goto again;
 		}
 	}
 	spin_unlock(&sb->s_inode_list_lock);
 
-	dispose_list(&dispose);
+	dispose_list(&dispose, false);
 }
 EXPORT_SYMBOL_GPL(evict_inodes);
 
@@ -1108,7 +1104,7 @@ long prune_icache_sb(struct super_block *sb, struct shrink_control *sc)
 
 	freed = list_lru_shrink_walk(&sb->s_inode_lru, sc,
 				     inode_lru_isolate, &freeable);
-	dispose_list(&freeable);
+	dispose_list(&freeable, true);
 	return freed;
 }
 
-- 
2.49.0

