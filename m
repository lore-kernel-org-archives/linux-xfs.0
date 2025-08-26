Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D755635690E
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222874; cv=none; b=Q+f8IE+dItj9HAc8GCJFSN5xW/3deQ0j2ll1a3TuA+d76h7gs3kmjSwxK3O+bSDKmU19z/qLXZFcuUPkv6fFzX670ecNJ+UL0OhcrHUmZflBhHThYGRpCb5JH/O8NZEF0lOqLk5EEzOuIMqKlwZn9TUyZCgE/SXAjwS6Q2rPGpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222874; c=relaxed/simple;
	bh=FA4pnJGDj2WWMNOvHLCse6jtjaoFkVIeDGC7hvLCkWU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I97f8uSvOXc5BIFGH4wqEBIq6/p+sVfBT3Tu5lfRRMSrCJjrgWGej0nS0HUQRW3cGhuNkfwRs1tNqExyIqZdLrdafbu2dEnTL55YXsCC0L9wWSKVtCcgff57lPSLx09EobsgcWjE3tIYe0KkWvuNRhxn/TKgLTEibFuH/w5kV64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=XJ9/DEcN; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="XJ9/DEcN"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-71d6014810fso46760957b3.0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222869; x=1756827669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lLdcB47dkfNQdTeXRI/sI229k/Gfes/tUPt2j0scFsc=;
        b=XJ9/DEcNUEHQwOFIq/SM/WNqWBK1LldbFQf18UvrTfLDRHTqSMHqgM36WJQPU8qJij
         iUXTpLTeSwsLrYIAhL8OokEqeiWQfrHaysZ0gzCJanqZlmmLJJrLaRn3tVo+HSf77pOd
         Xy8PawTbcPp9L0G/T26aimhlIctgT6qQxRsvoDBpiXzHIERLO+JBC9nzskGSa5tMOK+3
         uenri5AcfE1dEdRnn90FJLLVNNiUeVI129Urpu2zKwJYssYG/pX5xJiZARmq8oR/QazE
         BA9zTBzeGakH6L7cOKnqMHvhUa4pTqbDig67KQZmnIMTTVaNW9zEuYA8Gnu5NTfwI2oo
         tGrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222869; x=1756827669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lLdcB47dkfNQdTeXRI/sI229k/Gfes/tUPt2j0scFsc=;
        b=dFCnDZjc+Xz41hQm6Eo6d8x1lOV8KyBqRx/pgFCyGSJpM4XSJ33wa1zKLAoW48lY3F
         AuAFixfpKysNV/EGtvffxoS6/69tfk4Ih41ISDgAa7xl6LboXtwZzCbGBVIsfQZjNNlv
         5Y5LYN1TD2CHb7qHJed3aeD83PibHJYZpVoQdhnIPp01TIboyk6LMZ93R3+jxnGjfKtJ
         aKTitzCxBugTF6I8qUaZ50zzdj8zVAnriGhvz1d2FtSNjwNVGz7GzZtVV2jEsS+bouOJ
         Rygruo7Gw9/qnMaILYpB1aqDWt+1KkRNMEmsfGuH20HkR0SjAqV8tQePmoFbOX8znq6e
         1dKA==
X-Forwarded-Encrypted: i=1; AJvYcCXpJZpWHktxp07rzsSD5KkLkNIlHKVEWDqm3FbLouoQRxOQkzv8XRWf8ucdgEgAi3qXgYF695Qk6H8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOzDVGnknsiohAkkV10fZvHP6Adg/fIA6acWAs+XLOwieejVKl
	npRV8BQl+AgvEQ9hOM/b74mX8oTH+hPyJVSftdhmaWQlsXhcbPlUfbmxzoHbQWdjIm0=
X-Gm-Gg: ASbGncvO81dPwbXbwZ+19fVLpltYhlZOQ+2TZBgXZpO9OotlU6ZeTmg0xA3Xf+bNf2Q
	SyHPAaKGQUYZHVzhtNOJioybjO6OY4boGRiPV52z/vTLZ6PymqXoTVFGuRBeWATa/OEQCR9YslL
	9y5PmtuEA1HogJqdfn4mhpWQFhZSTmYzqqWOncFsQARVVAlRMVef9lXLRG+GhGFQB1FTJ/3KuQe
	kekJk43DWerR9KymhCbVf5JMuxfIUU81IGEcoBsNg/ly2rgvAXwQvytMnDD2hCaEu+53gdJ61MV
	yBu7W8U/RnpFcllrbnMG51AopgWcMq27hvBbTIauaIVESaWCzbPtdzJUQW4V+mM0PQRCIiHsO/z
	4nTubT9YfJdSyghH6ZgBxO8wngEDkyONQMxI38z2VQ4+d8ESNQZJPEd82VSY=
X-Google-Smtp-Source: AGHT+IG7MZng2S3yfXz9RiSpcnEbolik5Fao0RvRUykpH7SsGkbQuT3EZKEQ9Q+IU3F6hJQRrb8W9g==
X-Received: by 2002:a05:690c:64c8:b0:720:c20:dc2e with SMTP id 00721157ae682-7200c20e228mr88571567b3.31.1756222868952;
        Tue, 26 Aug 2025 08:41:08 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff188b0f1sm25302847b3.42.2025.08.26.08.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:08 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 14/54] fs: add an I_LRU flag to the inode
Date: Tue, 26 Aug 2025 11:39:14 -0400
Message-ID: <be838041953ae727e4ae9629dc1fa55c3dd09f2a.1756222465.git.josef@toxicpanda.com>
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

We will be adding another list for the inode to keep track of inodes
that are being cached for other reasons. This is necessary to make sure
we know which list the inode is on, and to differentiate it from the
private dispose lists.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c                       | 7 +++++++
 include/linux/fs.h               | 8 +++++++-
 include/trace/events/writeback.h | 3 ++-
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index ddaf282f7c25..15ff3a0ff7ee 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -545,6 +545,7 @@ static void __inode_add_lru(struct inode *inode, bool rotate)
 
 	if (list_lru_add_obj(&inode->i_sb->s_inode_lru, &inode->i_lru)) {
 		iobj_get(inode);
+		inode->i_state |= I_LRU;
 		this_cpu_inc(nr_unused);
 	} else if (rotate) {
 		inode->i_state |= I_REFERENCED;
@@ -574,7 +575,11 @@ void inode_add_lru(struct inode *inode)
 
 static void inode_lru_list_del(struct inode *inode)
 {
+	if (!(inode->i_state & I_LRU))
+		return;
+
 	if (list_lru_del_obj(&inode->i_sb->s_inode_lru, &inode->i_lru)) {
+		inode->i_state &= ~I_LRU;
 		iobj_put(inode);
 		this_cpu_dec(nr_unused);
 	}
@@ -955,6 +960,7 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 	    (inode->i_state & ~I_REFERENCED) ||
 	    !mapping_shrinkable(&inode->i_data)) {
 		list_lru_isolate(lru, &inode->i_lru);
+		inode->i_state &= ~I_LRU;
 		spin_unlock(&inode->i_lock);
 		this_cpu_dec(nr_unused);
 		return LRU_REMOVED;
@@ -991,6 +997,7 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
+	inode->i_state &= ~I_LRU;
 	list_lru_isolate_move(lru, &inode->i_lru, freeable);
 	spin_unlock(&inode->i_lock);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 023ad47685be..e12c09b9fcaf 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -744,6 +744,11 @@ is_uncached_acl(struct posix_acl *acl)
  * I_LRU_ISOLATING	Inode is pinned being isolated from LRU without holding
  *			i_count.
  *
+ * I_LRU		Inode is on the LRU list and has an associated LRU
+ *			reference count. Used to distinguish inodes where
+ *			->i_lru is on the LRU and those that are using ->i_lru
+ *			for some other means.
+ *
  * Q: What is the difference between I_WILL_FREE and I_FREEING?
  *
  * __I_{SYNC,NEW,LRU_ISOLATING} are used to derive unique addresses to wait
@@ -774,7 +779,8 @@ enum inode_state_flags_t {
 	I_CREATING		= (1U << 14),
 	I_DONTCACHE		= (1U << 15),
 	I_SYNC_QUEUED		= (1U << 16),
-	I_PINNING_NETFS_WB	= (1U << 17)
+	I_PINNING_NETFS_WB	= (1U << 17),
+	I_LRU			= (1U << 18)
 };
 
 #define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 1e23919c0da9..486f85aca84d 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -28,7 +28,8 @@
 		{I_DONTCACHE,		"I_DONTCACHE"},		\
 		{I_SYNC_QUEUED,		"I_SYNC_QUEUED"},	\
 		{I_PINNING_NETFS_WB,	"I_PINNING_NETFS_WB"},	\
-		{I_LRU_ISOLATING,	"I_LRU_ISOLATING"}	\
+		{I_LRU_ISOLATING,	"I_LRU_ISOLATING"},	\
+		{I_LRU,			"I_LRU"}		\
 	)
 
 /* enums need to be exported to user space */
-- 
2.49.0

