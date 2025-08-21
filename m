Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5EF372186
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807630; cv=none; b=KTU58/pwv1wDklV4v7riEA23v3q5LVGs7kG5BH8Fj3vN9IVavCTinkI5kSbPF72j3pJghm+ROht2iHtBOITMVUnRrgKgWvNS9F7OBsTgnq48tpmKzD/mEUaQjMIvttTx8B21TaYCGY6fF36nrwIWwzo8ZtWUSK2Qu/dWFzePoTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807630; c=relaxed/simple;
	bh=JqyAltqlHsDhxnWV26UFEbViQ/nho1N/pG6i6mXuWqY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TvEUtZY9exwG1rATAAPQ1QZow96lBs1ZJSUa+QVFPY7jg+w5u4IZnHtjxXdoZ5ghwi8nMHwf/oz+KKI39PyDUpomZDZim6KferaeKmXoyiAjYPltNYd7nLqh7Ozf4/GmsSFHGKIirk/lNr0bZHTExx8ewC1oFExva50CGQIwpzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=zI6kRgSf; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="zI6kRgSf"
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e951dfcbc5bso63530276.3
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807627; x=1756412427; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cb2V9k5PVP583r5lr+1rASUj/P55tkAhqxStui+NIFo=;
        b=zI6kRgSfIggsXgynOSYpwQgheZHPxE9zDKl56XoWVJlL7+8yc7XqTV/DMoTsB5JYiG
         JOm1NHV86TInnLQK3VauPw9cIgv9QIEJ1/E9HN8TthgjSuEn0ycFwNERlixjrvgyF8KL
         ZfEBpE0LQ9i9tO7rBtULHfH6XIyjUtOtjpx05nIA65T7p+hICIr46vB4XqOwZQLnoONB
         zD5vyoinQodbs1Nyry584tRUz81OLdmFVSEd6UscaP7STMVTh6TA7wMazQGwJbgzOokx
         GJMKyYOQe2aMN/oOIr9t0R5++hIoloQvJgx/WW03drSojf3TBFGN/ZSe23oCE7hTiivc
         SpUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807627; x=1756412427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cb2V9k5PVP583r5lr+1rASUj/P55tkAhqxStui+NIFo=;
        b=Kkv2c4wUzpa5/bF8bMr5GaivCmQrIdaJq0fmMuP/s4kH7hadTTVTfEtyaV/HTDPnVn
         7Fn+Kwg/yPuL7xuxVCv35sV0m5s7jBeA1J8FnkFNbFdL+wJHNMhqZWHXTv09x1GNdndy
         s7K12eQSQTIKRuVyDo15Gn6ZTYKfb73dE2bE/YFEamz0CMvrfBXsa22t4XzyGIv/2udc
         P48aAYGoHZ+qMD8kfAbpbWnW+/OIGY7gg3NcyCm6hKqHhf830FZGSBvBetdL2tyQUtmB
         rWuMxr4J+YYKiYlxnea9pBOUJxeNzJPB/AzMSiIvXBTEFcYsOfF6iFdip57kTDSp4DN8
         5XZg==
X-Forwarded-Encrypted: i=1; AJvYcCUt2pO2xLMuW8va/MV1B0WK2w5TIWoOmBk+l18h2ta2igOmjUqcAgR3fuf8eIjE2nsrBoj4A2p5m1A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2sgYAvRGaat3lQHt1QLPxDY2bIEDTzI++0d56KWm6PGQeSXdO
	IH2n67HbTeYH6ZTeWbmhcOgS8egcEFvYuZs8ADBe2+4Q/krXRPsrHKE2cV+lebWUHkQ=
X-Gm-Gg: ASbGncs2CIMEqXE7vQ9gd9iEA7ZY1ERowxmIQMJCvsJ5GLfD9BeNHRQV1ynlQ/5XDNX
	sxp/v1plx84grMqPoyhMrm1umj3k8djAFhh9OybGf3Q3uYvBrV4SdaR1lZ8MIMMozrvkqQMV/tz
	it2qZPXgRvcJFKw7wyorGAbOnAEp0GqEolTwKFhnnDETAXu5AUuG4PHNUScrXnFOUrmW86nMeOO
	etkdUfeJbwXaYWxQ6uKrgmTZkYjgBzD6bLHFxT3YfeEgiyvkSa7CY9tVJfEGDqecuD6hO0r7O/3
	UMvfZydStcCGyYCypD9s9/HIb2YegCYzN4nAC78FEMH++H5E5vQByXxjmgOa9e9hlLCY2asl7mI
	TjtydgpatLrusFWh+oY/8gKQ7gkkJOsS1vltWhEzwNcn3ujbEeUjVII8ksik=
X-Google-Smtp-Source: AGHT+IE87W5Ra788mXEaYg1x3BO4fJJ18wjL8kms/6rnsfpL0Qf/z0M6cHEdhh+NBNhq7o8SIEAtHA==
X-Received: by 2002:a05:6902:6c13:b0:e94:ffa6:177a with SMTP id 3f1490d57ef6-e951c2428f4mr1122255276.23.1755807627448;
        Thu, 21 Aug 2025 13:20:27 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e9519ef31c6sm374368276.23.2025.08.21.13.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:26 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 08/50] fs: hold an i_obj_count reference while on the LRU list
Date: Thu, 21 Aug 2025 16:18:19 -0400
Message-ID: <1e6c8bb039a6f1e76347b3214be78326b403c57d.1755806649.git.josef@toxicpanda.com>
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

While on the LRU list we need to make sure the object itself does not
disappear, so hold an i_obj_count reference.

This is a little wonky currently as we're dropping the reference before
we call evict(), because currently we drop the last reference right
before we free the inode.  This will be fixed in a future patch when the
freeing of the inode is moved under the control of the i_obj_count
reference.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 1ff46d9417de..7e506050a0bc 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -542,10 +542,12 @@ static void __inode_add_lru(struct inode *inode, bool rotate)
 	if (!mapping_shrinkable(&inode->i_data))
 		return;
 
-	if (list_lru_add_obj(&inode->i_sb->s_inode_lru, &inode->i_lru))
+	if (list_lru_add_obj(&inode->i_sb->s_inode_lru, &inode->i_lru)) {
+		iobj_get(inode);
 		this_cpu_inc(nr_unused);
-	else if (rotate)
+	} else if (rotate) {
 		inode->i_state |= I_REFERENCED;
+	}
 }
 
 struct wait_queue_head *inode_bit_waitqueue(struct wait_bit_queue_entry *wqe,
@@ -571,8 +573,10 @@ void inode_add_lru(struct inode *inode)
 
 static void inode_lru_list_del(struct inode *inode)
 {
-	if (list_lru_del_obj(&inode->i_sb->s_inode_lru, &inode->i_lru))
+	if (list_lru_del_obj(&inode->i_sb->s_inode_lru, &inode->i_lru)) {
+		iobj_put(inode);
 		this_cpu_dec(nr_unused);
+	}
 }
 
 static void inode_pin_lru_isolating(struct inode *inode)
@@ -861,6 +865,15 @@ static void dispose_list(struct list_head *head)
 		inode = list_first_entry(head, struct inode, i_lru);
 		list_del_init(&inode->i_lru);
 
+		/*
+		 * This is going right here for now only because we are
+		 * currently not using the i_obj_count reference for anything,
+		 * and it needs to hit 0 when we call evict().
+		 *
+		 * This will be moved when we change the lifetime rules in a
+		 * future patch.
+		 */
+		iobj_put(inode);
 		evict(inode);
 		cond_resched();
 	}
@@ -897,6 +910,7 @@ void evict_inodes(struct super_block *sb)
 		}
 
 		inode->i_state |= I_FREEING;
+		iobj_get(inode);
 		inode_lru_list_del(inode);
 		spin_unlock(&inode->i_lock);
 		list_add(&inode->i_lru, &dispose);
-- 
2.49.0

