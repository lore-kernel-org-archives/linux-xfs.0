Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408EF352081
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222863; cv=none; b=sfSWt3MDAqmIAoJyqFy3wdU3aX00qLrrPnm0gmKJ8oobjLK5SfzaeUhgEoCIvTk3srOqyp8xiWhsqO9k22mLQUS5u5G0T6cPb0xgEswzvVUZFUcwNw2SJqwVgL8i5bixDyeoLwrT1/L5OOslMm+aAK9/G8HNvQNc7afFYvy+2OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222863; c=relaxed/simple;
	bh=vb3lgatLL22BxERk9/b+lCqLtXz3W8a2P/7Gr1XM4H4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/setnTsw1cOm31PaytK7k5hKUfvclbbgO80JEcs1v4JIM8AJzCTDCGjbrOFL9gF1AlDJwSDgA0spcha35dXChQJih0641YPSfUh0ujTe8WoOQs+lRBGLCUTQz9Gd6/EDTwew/dBr8rDLPGEjapVKqy7Y4+lk6LWfEeFwi69GhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=Qx7xDk2Z; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="Qx7xDk2Z"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-71fab75fc97so49033727b3.3
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222860; x=1756827660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TgvK09Ne5Aq6jRiEthgDjLIcJNkO/NakbksX6k8jf14=;
        b=Qx7xDk2ZZPH1b2wholEdBMKOO4Ugu9Bjzye6rSVT7PbRbJhUDERheM1oMAZR0k/jb/
         5/Ibffdz2WOiGrC1l3dKTc90rfmIvV16iXNw4tariDYGqhLaFGiq1ncqlrMYhPstSKMn
         8uHzstew7KMfdNxZUpzdGP/NKJ/b632/2eOdAN+cjiZIEkIDzorxXRMpjkz3wAAbkxFk
         v7Enw8MxdFr3Z6m/qKrTGIJ0yacWeiLBz6n3rchwtE3PiPZDqsW8msDwatxNMAEBNcsF
         G7MJv/v29W1PMa6Y3gg0MSmN1x3vnPgKWv0KUs/LE0rrjU9/jkwmxvkBiAWEE32429m4
         FtQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222860; x=1756827660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TgvK09Ne5Aq6jRiEthgDjLIcJNkO/NakbksX6k8jf14=;
        b=WcXkEQdhhyY73xGqQ2BBL40BbGv0TNtrbvp3weIa0bATQMYAanAGdWWWNHUU1hmYSi
         wQ8iUKpt9Ph4zEk7o5sTI6milt1cnY/4HTsEK1a/SC0e3nuKB3sUnolKnpLZuD5pL95+
         g8hWhNMD+yYIbPjlFQMzoSYoY+14GJAtehrzzTNqpOpzhJ4+O6RGJnvP9I7OOni0Dyc4
         34ybC+2ufL4DOld6EyFz2iMK61nd++1tbPbvzlDyaEFElLxkfAIJkTwn2kwliOahs4D7
         M4gTAf2h4dYHMm0tEjmcELsmX+zHn+4sJkCXNuE1IJk3JIvRIe/LQPlnUWwp6mm/eoNw
         /g6g==
X-Forwarded-Encrypted: i=1; AJvYcCXVwLPG2q4j3I1m0t1C3pIjZrWW+3qIU/AqPPpo2gakIwZMqX0ceX3iSwOB7a/pSjTGrpY3bTl2dC8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yww89hoQglr4yrpALMLLKXHc681YOynj48Q9GELAJhk1ZBoWB8U
	/aDdXnR11NfcALUtBG5gixqHl/gce+Jy24Ps3vel4eSUVuw+puXfzELDYvrKyLXGBOqZFLybd1A
	0/n6S
X-Gm-Gg: ASbGncs/6cz3AzhiIbFd1laqvzZAoBeBL4zNrNx3Xm1a7sHqxQ42scx6BBmzKBMBVwZ
	MhnLoJJxIe0iMXOp9fw64trK/bB9HqN//D64f/K46KDCxf8uKWC0P8/llFyYOQX7Pkp5QLivQCc
	mtfEtyEyi9hwllf4t4lrLeQu+T6EKo+Q5InxsjUvHCov4bJg0hm5dhUN8fzMKrLC2B/GltyWzEu
	3Bx6DZqlQRzinAe79M+LHs7AEZJtI373aafGCxQemDk1nWwpX4022gOJ8Hvp1fbBpDd9729VINR
	CILYpSAFgpGFnQ+FosJ5jflCrlyfW6f0ejJIhfFwo5LIZND8TdkRO5ogCg7GuzBwATltt30GYzd
	RdHuiITQnJuyillyIGfmpl9ZyATqeeykxzn9CmVDSbZRRUakAVI7tw9f6oRs=
X-Google-Smtp-Source: AGHT+IFHc0cd1vBL1NZ56pvHPXho4UE/Yj/BshipiSC1BWzt1LmJ0zTyz+AzopKHLGkL4tZhqzzqxw==
X-Received: by 2002:a05:690c:6108:b0:720:2af3:fad6 with SMTP id 00721157ae682-7202af3fbebmr100372157b3.17.1756222860145;
        Tue, 26 Aug 2025 08:41:00 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff17339fdsm25180647b3.21.2025.08.26.08.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:40:59 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 08/54] fs: hold an i_obj_count reference in writeback_sb_inodes
Date: Tue, 26 Aug 2025 11:39:08 -0400
Message-ID: <1e555c73564393129833d550965e3175c142bb84.1756222465.git.josef@toxicpanda.com>
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

We drop the wb list_lock while writing back inodes, and we could
manipulate the i_io_list while this is happening and drop our reference
for the inode. Protect this by holding the i_obj_count reference during
the writeback.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/fs-writeback.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index cf7fab59e4d5..773b276328ec 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1977,6 +1977,7 @@ static long writeback_sb_inodes(struct super_block *sb,
 			trace_writeback_sb_inodes_requeue(inode);
 			continue;
 		}
+		iobj_get(inode);
 		spin_unlock(&wb->list_lock);
 
 		/*
@@ -1987,6 +1988,7 @@ static long writeback_sb_inodes(struct super_block *sb,
 		if (inode->i_state & I_SYNC) {
 			/* Wait for I_SYNC. This function drops i_lock... */
 			inode_sleep_on_writeback(inode);
+			iobj_put(inode);
 			/* Inode may be gone, start again */
 			spin_lock(&wb->list_lock);
 			continue;
@@ -2035,10 +2037,9 @@ static long writeback_sb_inodes(struct super_block *sb,
 		inode_sync_complete(inode);
 		spin_unlock(&inode->i_lock);
 
-		if (unlikely(tmp_wb != wb)) {
-			spin_unlock(&tmp_wb->list_lock);
-			spin_lock(&wb->list_lock);
-		}
+		spin_unlock(&tmp_wb->list_lock);
+		iobj_put(inode);
+		spin_lock(&wb->list_lock);
 
 		/*
 		 * bail out to wb_writeback() often enough to check
-- 
2.49.0

