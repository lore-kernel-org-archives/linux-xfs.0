Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B864215E81B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 22:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712095896; cv=none; b=uj+DpH3c/9UGxBbABWzZl2mQJJOM17c4S2KM0m5m3qjqpXrTj847ITWwzTxrmY769aoDej5qb3d3QN+3Bwjfzg+fVMOsocyJqL6zy+Tn8z3K2t0zScUlXNS9vFIEwcW3DNsos86pTtHiFuHl/235Oflv9P9585Y9XBdUWr0FkHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712095896; c=relaxed/simple;
	bh=HcjJiwlP2Icp+Ts+7mLBtwnYY49nymX/lCITPZf5FJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Du4dL/boemKFvygoWf/etBnyzY85WaAswd/gZYKaNFlUwIqQRxHSmFxEqPkxlA099cBECY74n3LWZOIuN0MJH0V9dVjFqow9quVgHlQsy7XDBbZlRwgeUnSfyTKWNTOaBXR5866SF20xRCvJbZlwBxMJnL1Qqcl1oHdqs9JUyLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=LnBXN3w+; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="LnBXN3w+"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-369ec1fbadfso1994895ab.2
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 15:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712095894; x=1712700694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0wGe9FkHq7t73ONNEv5qhDbVjRyupAteviCCDpmj/4U=;
        b=LnBXN3w+kRek+4NCyBgdTcD33pG8aPb3llxfKTrcwbwuE6YKc1dShGolOf0cH2n4H/
         eSRUzpVY05ftBbud0T2dMZRG15ROW24AmmhH28+kByKno39EkuslzgeLGKFzShtQro12
         wEGw4s0h1BX43bBnc/D2/XxA6pKf1c9Be8mf2yJP7c/V95De9is26W2B7HZCc1Rx+jjU
         85T2qZE7zWxHS4MMZ0Y0FMD/+A8+tyoVBYcu/dRArJxbngHH031up85yggjaqC/6zEuC
         HQwpOa4gKFTiuI7FVDGvxvjVR2ezXh7+6zhJdN9CkNexX/mle74WGGcBD7Bci0wZsRgD
         0sBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712095894; x=1712700694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0wGe9FkHq7t73ONNEv5qhDbVjRyupAteviCCDpmj/4U=;
        b=YRtNoRNpHYCAio1/ti3FKXLtK1WUjc07jtwKCJ61lkLWgWjAQ7eA4e1gsoN7ppzxxr
         fH28otmwEW5+l2Ai6fSIqDXiYZAC4a1MJjGEFa/CEL2Cy/AohDGOBgnrO06ax6ZNfAbO
         8ZcOEb6FTwOFbrjMZ2IWhw801pm1NraPCzs835MnfUXNGd1IZ+DxzQKUYskWOOcSpKoV
         1XttJAbsK54EoSfSWzwIVn4pp6R53D8IDfFp+Vhq335i7w5FSMAmk5ozDn8oIEtBjeJx
         Cz8TFrWrlcRE3meqvLwKhj+TIRI6TohY2HOEEokHxq4BOW0w8ArGniL2XeMxWvA4+aCz
         61mA==
X-Gm-Message-State: AOJu0YyeMrLQPj3sZlhIaReuWPM4S7QCT5qdVq60GrNS+nPh/+kaJWtz
	ZN47EzWaFecFR+fleOCfph1q2VlN3zLTrABmwZZPXgOq14lcGrEO8vhY3YDgRD4MbsZTe/XK8Jr
	E
X-Google-Smtp-Source: AGHT+IGYV8UpO5hXy9ZCdyZqsPfYm+0tw7PleagJoJdBXcXHxMl6GCgG3E12Gfwrkb8qx/T6U5BzHg==
X-Received: by 2002:a05:6e02:1c0c:b0:365:def:c5cb with SMTP id l12-20020a056e021c0c00b003650defc5cbmr15237272ilh.30.1712095893590;
        Tue, 02 Apr 2024 15:11:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id p66-20020a634245000000b005dc9ab425c2sm10185269pga.35.2024.04.02.15.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 15:11:33 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rrmLp-001osJ-38;
	Wed, 03 Apr 2024 09:11:29 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rrmLp-000000052qs-27y4;
	Wed, 03 Apr 2024 09:11:29 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: chandanbabu@kernel.org
Subject: [PATCH 1/4] xfs: use kvmalloc for xattr buffers
Date: Wed,  3 Apr 2024 08:38:16 +1100
Message-ID: <20240402221127.1200501-2-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240402221127.1200501-1-david@fromorbit.com>
References: <20240402221127.1200501-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Pankaj Raghav reported that when filesystem block size is larger
than page size, the xattr code can use kmalloc() for high order
allocations. This triggers a useless warning in the allocator as it
is a __GFP_NOFAIL allocation here:

static inline
struct page *rmqueue(struct zone *preferred_zone,
                        struct zone *zone, unsigned int order,
                        gfp_t gfp_flags, unsigned int alloc_flags,
                        int migratetype)
{
        struct page *page;

        /*
         * We most definitely don't want callers attempting to
         * allocate greater than order-1 page units with __GFP_NOFAIL.
         */
>>>>    WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
...

Fix this by changing all these call sites to use kvmalloc(), which
will strip the NOFAIL from the kmalloc attempt and if that fails
will do a __GFP_NOFAIL vmalloc().

This is not an issue that productions systems will see as
filesystems with block size > page size cannot be mounted by the
kernel; Pankaj is developing this functionality right now.

Reported-by: Pankaj Raghav <kernel@pankajraghav.com>
Fixes: f078d4ea8276 ("xfs: convert kmem_alloc() to kmalloc()")
Signed-off-be: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index ac904cc1a97b..969abc6efd70 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1059,10 +1059,7 @@ xfs_attr3_leaf_to_shortform(
 
 	trace_xfs_attr_leaf_to_sf(args);
 
-	tmpbuffer = kmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
-	if (!tmpbuffer)
-		return -ENOMEM;
-
+	tmpbuffer = kvmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
 	memcpy(tmpbuffer, bp->b_addr, args->geo->blksize);
 
 	leaf = (xfs_attr_leafblock_t *)tmpbuffer;
@@ -1125,7 +1122,7 @@ xfs_attr3_leaf_to_shortform(
 	error = 0;
 
 out:
-	kfree(tmpbuffer);
+	kvfree(tmpbuffer);
 	return error;
 }
 
@@ -1533,7 +1530,7 @@ xfs_attr3_leaf_compact(
 
 	trace_xfs_attr_leaf_compact(args);
 
-	tmpbuffer = kmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
+	tmpbuffer = kvmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
 	memcpy(tmpbuffer, bp->b_addr, args->geo->blksize);
 	memset(bp->b_addr, 0, args->geo->blksize);
 	leaf_src = (xfs_attr_leafblock_t *)tmpbuffer;
@@ -1571,7 +1568,7 @@ xfs_attr3_leaf_compact(
 	 */
 	xfs_trans_log_buf(trans, bp, 0, args->geo->blksize - 1);
 
-	kfree(tmpbuffer);
+	kvfree(tmpbuffer);
 }
 
 /*
@@ -2250,7 +2247,7 @@ xfs_attr3_leaf_unbalance(
 		struct xfs_attr_leafblock *tmp_leaf;
 		struct xfs_attr3_icleaf_hdr tmphdr;
 
-		tmp_leaf = kzalloc(state->args->geo->blksize,
+		tmp_leaf = kvzalloc(state->args->geo->blksize,
 				GFP_KERNEL | __GFP_NOFAIL);
 
 		/*
@@ -2291,7 +2288,7 @@ xfs_attr3_leaf_unbalance(
 		}
 		memcpy(save_leaf, tmp_leaf, state->args->geo->blksize);
 		savehdr = tmphdr; /* struct copy */
-		kfree(tmp_leaf);
+		kvfree(tmp_leaf);
 	}
 
 	xfs_attr3_leaf_hdr_to_disk(state->args->geo, save_leaf, &savehdr);
-- 
2.43.0

