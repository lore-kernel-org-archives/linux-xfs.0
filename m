Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9559638D7C1
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807651; cv=none; b=hr01jXeSTq5GGHBNo3cIdC7nGtGVtvJdXwFns8dBxsrkYMB/exFTt8BCtjHbsZ1XoX8c2kYeZpKNgmSFvaPeKaLzxQvBrP2O1nxRZqopBf49bzLypuwbilF/WWQ8CeJrzzj6j4BG+BDvH1xwWwYAmvdwQAIWv+oIIMuFJjHr+/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807651; c=relaxed/simple;
	bh=QDCTsMl47vNCm4pEABV38JgQSqrXPVXZ8WOdWXUjr7E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmyvrNVKRpuwXWJC2MXSE2ERyYqNI+AKuTPpr11lDNlqZIRgem1ofMk1GzChN+S3SVKZCWAaoVymiTW4XU/E5lCwj/C73MQo2ZClt/WVsxcOrDip3rKx/K5wTF3DeXBEmQWUr2OcWfnF6B+1rOvbU/F80LOx01DpPYA7XeKQkK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=iEQUrkg9; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="iEQUrkg9"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-71d605a70bdso10013677b3.3
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807648; x=1756412448; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RPlcwVE6H0J7lPhjU7xhzvHl7lwTdtHL6DFVeSS7hKM=;
        b=iEQUrkg9gVl84ttehK6DWSMBd/CBNBiNqxHvlznvZ0tDZndP/QMkXPSXXrKEXe+4t4
         zqmvP022CCqJtShbRkl1f4/M9Jk/08sZ6RYtteC1tJFQrrFiBx1rsRcgiTozBLnYo6/U
         kkuXVQUO8s+YInEbMIqenJnPVcbIIILfFO2M61+lKZFi/7OnZ20nXSiuoQQMgPYdE9JT
         xoQvFxfUIvzx64OMWkRGIr1DSQO1BBeiQNYEgkqsbgCeP/bKsTMMEP0bXDMbTBQ/gT7a
         RSiKkEv3WreR1q0OjO6IxpuTfUynCJFSWK+Wx+o6gbyQBX10pFoemCVhp+fVzIVLYjMo
         i2ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807648; x=1756412448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RPlcwVE6H0J7lPhjU7xhzvHl7lwTdtHL6DFVeSS7hKM=;
        b=m4Ir1pa05q/r9/c+No6blOFF9xnIzlnk7N775L/+OBQN2z/aM7TbORoNoGWbT/GZP0
         Cemk+fjYz8vtVQ+/NfQMBQJeoKEwgJTbKlUbKcmqMy4I7M3tRIWZd23AtUyoVb5w2i6h
         s0tWAs+Lc+OPEav0e7oDW1rqMFD1XdfTASgyThbueqIIHukCLi90+Z4VDgGEb4s8HvZY
         2pBia8KZKzsjhIugMEECgRZ7r4r610Xx0ArfTstOb8+cslYjc2+0im7jyrxWS+CsZ4nj
         e+3bn9o0LCWMNr1wdJ9jITnW4wVSBCGleQH88r99FWByyT2KEOBuiskuFDIouxoY+OKt
         iwxQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7oKU8oAugrSVk6dZK3jqzrEjYn/LKhOtgS9KeOyfnAojokf/NlYZTKGCFggFkJ+Gsp6TQqlSPNYU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4IbtrJexV+ePM3MxanR9OqwTgR9+OuYOmDGe3/B3eQhhQJb15
	oHTL4wn+PGn2GayOiCyQZ2/6v2/y1ACTMJ/8DXazs5Nx7mej2Mdnt36XFXrZuXvweBd0XEwNEMH
	h4NtwEI1Hmw==
X-Gm-Gg: ASbGncvYOKOlld2p9ykZ5RLcT/NWfQ4MAfkVDVXQ6bm58T8ei6cypQUFWcTUP4j3QGP
	+qYN6R1CKHW+rlWaUV+IkJL2vebJ8bM6xCKDaNYKuqjhpqDrZRQ3FXG5sjR9kOv2ANo7X+u5gvo
	sEzUtOJ2na5sNhNsg6mw7KDEefPJ8kT+NzgOxNqIWLaT4t9rAqkuA7N6bxBb3DZ9JtphKxp45TZ
	XXtP7kuUPRVI7uqmTAXPv0TaauSO9/lz2Pqc1/Sj7a2YvtbJLf1zMwLLbaDOdzg1zXZg7tV+NFG
	BOxEYFXDS1Nc4yN80CDOAdSdS5WL7tVV9dfyiRHcJHIyOJHYR/3L/frooXRE9jLPMzVxp3e/sqk
	0P0qngtprpIl1r5LpWqcp6CSa4awxoZ4xFEY0CZQV+20yaqam6ArS1u01Hm/MpJviq99/Tg==
X-Google-Smtp-Source: AGHT+IGw5PNNsEWsBJ7M5Vz46WMQ8XvSWM1DvaLtn7uGKcRIEygyel+PAyOdDJrJ1R2bbH5CNEKGeg==
X-Received: by 2002:a05:690c:6601:b0:71f:9a36:d340 with SMTP id 00721157ae682-71fdc536729mr5987577b3.50.1755807648474;
        Thu, 21 Aug 2025 13:20:48 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71e830843e9sm35039647b3.73.2025.08.21.13.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:47 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 22/50] fs: use inode_tryget in find_inode*
Date: Thu, 21 Aug 2025 16:18:33 -0400
Message-ID: <0fca9386c2eca65e7fa5a39faca34ebf42d71cd0.1755806649.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755806649.git.josef@toxicpanda.com>
References: <cover.1755806649.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that we never drop the i_count to 0 for valid objects, rework the
logic in the find_inode* helpers to use inode_tryget() to see if they
have a live inode.  If this fails we can wait for the inode to be freed
as we know it's currently being evicted.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index b9122c1eee1d..893ac902268b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1109,6 +1109,7 @@ long prune_icache_sb(struct super_block *sb, struct shrink_control *sc)
 }
 
 static void __wait_on_freeing_inode(struct inode *inode, bool is_inode_hash_locked);
+
 /*
  * Called with the inode lock held.
  */
@@ -1132,16 +1133,15 @@ static struct inode *find_inode(struct super_block *sb,
 		if (!test(inode, data))
 			continue;
 		spin_lock(&inode->i_lock);
-		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
-			__wait_on_freeing_inode(inode, is_inode_hash_locked);
-			goto repeat;
-		}
 		if (unlikely(inode->i_state & I_CREATING)) {
 			spin_unlock(&inode->i_lock);
 			rcu_read_unlock();
 			return ERR_PTR(-ESTALE);
 		}
-		__iget(inode);
+		if (!inode_tryget(inode)) {
+			__wait_on_freeing_inode(inode, is_inode_hash_locked);
+			goto repeat;
+		}
 		inode_lru_list_del(inode);
 		spin_unlock(&inode->i_lock);
 		rcu_read_unlock();
@@ -1174,16 +1174,15 @@ static struct inode *find_inode_fast(struct super_block *sb,
 		if (inode->i_sb != sb)
 			continue;
 		spin_lock(&inode->i_lock);
-		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
-			__wait_on_freeing_inode(inode, is_inode_hash_locked);
-			goto repeat;
-		}
 		if (unlikely(inode->i_state & I_CREATING)) {
 			spin_unlock(&inode->i_lock);
 			rcu_read_unlock();
 			return ERR_PTR(-ESTALE);
 		}
-		__iget(inode);
+		if (!inode_tryget(inode)) {
+			__wait_on_freeing_inode(inode, is_inode_hash_locked);
+			goto repeat;
+		}
 		inode_lru_list_del(inode);
 		spin_unlock(&inode->i_lock);
 		rcu_read_unlock();
-- 
2.49.0

