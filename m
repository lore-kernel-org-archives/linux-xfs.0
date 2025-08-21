Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF13370580
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807627; cv=none; b=lKSP9TSFoJgIV4xgBoxlxVFNHgZ7Czs2h9Cce96PtEeVO17++hahu2tFV2Dp1eDpsLKUKU8RYHTe69plfpFKEoaTklUXlrJ0sSkdz8JOCbLXxyPdJPXO6Hs9CIAss5IbOwFiBJMkhdvuPeyrrn6bAHmHto0sBfaRlFyWVMqndhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807627; c=relaxed/simple;
	bh=VW5j9pCOlroZhl/lnWfntKbo6qQXfaDKec+FJlQf3TY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+Z8Ce/Jt8OFU8hZGVbDKNFm6aHY0tAm5R3FyNJoVKtr07oq7Syp7Xb1cdghHlaZ6fYL1hwHNGoSGUTuzjPTiaBRIEbUSFjJNZGdrjvbmFWxDhj1P+twNNJUsvB66oXCnBVslKgUBTJ6PZsei3TZTHaLpOEFj5gs3yuTdx9CwLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=H7FCKGiV; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="H7FCKGiV"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-71fab75fc97so13246697b3.3
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807625; x=1756412425; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VojWusNxgTfPnzlXh9Aw6r7SNSzmMD9Pubt2ZgZyin4=;
        b=H7FCKGiV9rPYtCdu1AbEOsJUd95oOwUHPt1VmyGHmjWdnwvzkiS2bRI1st3t+RaPEl
         3tlBu43SDBy9odOfNZaf4AOI6KR8fiL92bOuK2e3ZCzgbgXtMVRWWoW+snti4LeXgn7M
         nekQEGJnhGcExHdqIX5MM2qG4vHtigNNWlZA2sp4UIeY8ZgEvBfMN915r3q4dZfbOIGY
         Wv0jaxoLJApbEafnU76CRw39tUvjeYtb/1JvoZAu9tZxgbISevZCV+f5vM0MFUIghNrF
         coiLsBoF7bmf8F7HMD008zpv6aN+HQCEsiS0eutPQUyrGqZGWEhpEOL7ZuvhVU5QGMLl
         A1ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807625; x=1756412425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VojWusNxgTfPnzlXh9Aw6r7SNSzmMD9Pubt2ZgZyin4=;
        b=Jofgu1Mr4uHN5D3fANT6GYLhJtpdlSOn4GvT87w2FBzu2KyAZemEPAn2K176pVHwby
         3QlLkD9oO1Ccspfi/sojIbioy+dEg2rrhkU1B8IIOrB0/AJrPUBOhUJNzAkD3qO4TMmD
         7NSCFgaSJDD46ldeQoc06TD+SneAzwrbBmkNcV32LBRtyUUTuojFrkRj9qT/v95EJKnq
         tzPcdpq9q9lYQjAPv03Vt5qCseTidDWh4C1kQtw8DLUr9w/eC82SA4P0jycTr2AdNINQ
         L22a4ADeP/dL411pIipnF87+GS+2HPRRa5MeOijS7d7KoOEdTxwkFiEJhiQzGBglvaDI
         zW3g==
X-Forwarded-Encrypted: i=1; AJvYcCUt0KUEKw4O1cEpvSXl5p7JcYEp/OwtRMOSaFg6l5CN8zkgLAzXTAAD0tcn0wu54d68sV3xB0OqYvY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyBkXxHGU4J/uD3l3EJAbzVOfRR6gYBYwy97qO7qpw3jqeJMlO
	MQYsiEHOHS8DnGIaG34c97hx9X++hWEWZKZERvuQFCdk2/MiEW/6hgWFC7iBUgwUpX8=
X-Gm-Gg: ASbGnctcx1EB5McJaL5q5ErurV+44nb17IPMNKNm7IUZ9yEP1Gq4BKgJF290QKV4+r7
	46q2ytSbCrCxabGY4zoV4+R6o9vISl5Op2l1PwFiHtDi2vyVyjg83nktV8fgKRtZ2/qZAAKkwPS
	7G66yGfBATZCztoLVh3WTlOl/SiL3PRtiBxfMi4W67e2ryFM+Ty41mO7p1+pEnAicRGxIMjTRrg
	VLWn+zEolnDyZdk809hVkDBst6iHr9PBJc3qKwwr3mLuSeWxpy4ojbQPZjcW0x2NSp/ayFSnCsO
	jtLoweFbkFQboQl6IY9wj8HVwXaeOdAHTQJGzxDEIwPV+qUTpHJQDA2UjjHN5CY20W0vjIBg6JL
	wgMHkz8Sedokp/txEktVAgNUY3eC9wDmAtrqHoLwRwqo0rOxOWIVbUaSd6bM=
X-Google-Smtp-Source: AGHT+IF8JBW4Xh52SDVildob/BUomhJ9K4wuNU15xnoWWWlqqaOPm3Y7fskuJegwPAQeudlS8EK8SA==
X-Received: by 2002:a05:690c:680c:b0:71f:b944:1034 with SMTP id 00721157ae682-71fdc530ce2mr6839237b3.49.1755807624618;
        Thu, 21 Aug 2025 13:20:24 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71fdbedffd8sm1165897b3.5.2025.08.21.13.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:23 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 06/50] fs: hold an i_obj_count reference in writeback_sb_inodes
Date: Thu, 21 Aug 2025 16:18:17 -0400
Message-ID: <1a7d1025914b6840e9cc3f6e10c6e69af95452f5.1755806649.git.josef@toxicpanda.com>
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

We drop the wb list_lock while writing back inodes, and we could
manipulate the i_io_list while this is happening and drop our reference
for the inode. Protect this by holding the i_obj_count reference during
the writeback.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/fs-writeback.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 24fccb299de4..2b0d26a58a5a 100644
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

