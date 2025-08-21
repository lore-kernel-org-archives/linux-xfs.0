Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D44374270
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807682; cv=none; b=JQNDAfYmtMaSaj1k8POCm3ukwUWotmKS74kEWxOqfQ2UWzpxpk9DDDKZcX9usn02qpexxFkOYe7ycHw9h9c4aGxbV4c87b57ApTtVYLWK4dZWJqB4CVD9IIh2B/PmrPBTTnVFMV7QFGC7WrS8cE1D3UFb/lhIFgDKiVjjs3APM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807682; c=relaxed/simple;
	bh=x0LPojx9IQXc26jVCUZk/B2yhhxr/cir7ETQSThbsBI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdGUA0kzAUmhau08ApCF4AKEbtvWmJXHmy5Al4qORYEo2IpYv0KrR0AJDc+n/+kECqvAukGqsPzEkipt0vnaIc3E7+tcfFUChS9xs9gi9tmH+6HNKbzDSb6F8WTsRbouUlSBKMD1e5lvsOlubHykUcougyMEsfkwzcz7W6erQNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=gNRTtKkd; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="gNRTtKkd"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e93498d41a1so1456212276.2
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807680; x=1756412480; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tNYt8ttislOZxvkBkAGWr4O/dXYuvufQNUeuNOJLG/o=;
        b=gNRTtKkdMvkvxvuahbNvL3tjJvNdsEghXxKMzPuhKSWuvyDSi5gLeJ2CXTVhEm3Aae
         0XaQXGRZiTQHP2JD4R2r4D8XyGwqwfx2cbP1NFthqGxHRHDOaTlQWo7O2TPi0un7zFiQ
         yw2YgbOz+E7nrMioLhlpsbE/ZVFrf6sq+hDesa41SQJNztLdAhIAFs3H3gsvr26Q4eSO
         knwmYkJhjJX9FZlDHf3U6jJfai3yJLdyaCQNXqV/UQkK88hztEuKIuCF93KTe/xOm+x1
         1NhfuFnYqm/h96WDvmzstVrPHD/EaNjM43VRExbypaOYNu9Oo1Iq6mnFnGICz846JACf
         B43g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807680; x=1756412480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tNYt8ttislOZxvkBkAGWr4O/dXYuvufQNUeuNOJLG/o=;
        b=Sdc87sOIHYVde/lkjhahWabMwXm3B68VF6e8d6i+Qtb9uECLMommGZ7UCXWFdjcIJ/
         a5ViPqQCEQzeb6bw7Vq5Vz/KJaSuihf08eszp1xPknJyCxumvMJSzbj5xwrkWNWkwfyM
         krgS5raTqy1iINOLIWpGARSdrMXN4hMvqqpqunV83sERaurHvA+Hf0yGrod7zeoaiJlw
         LaINrfzQMl8uibaa9AraLL2DM6Y8jiFA3WYcJrn01UM4dexowWVAat24sZEfglyFXxKQ
         cHBOuuDDdVgaMcrmhqVapnVVztGu1Cznr1F+QdtIQjFNEx6PoU2g9qZXLl6Z+TVavgVv
         nTLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmEfvVrwrQ1VlQ/efgQARVDzLi036wq7x/vq0jxzgfPpO0p82FRcXkEsH3iIWjsBZn6yiv+xVR3y0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4YbKIjn1Kst4imBll+9DS6pSAXIVtF++p/cEytxXryEHUiU0v
	y4b3Yt6XUtTvMbq0q47buhA2bHD/jSd8prLT/MTzRmQZ3/M+d0u/GXVSiqEihvVkbNQ=
X-Gm-Gg: ASbGncvG+3oOEz1UBHgQfQGGoVL0UaSTwZdncAvx/IYYZHNSjSwmYYFlZfIB/aK7TTn
	l5bPo4rfe0IkUTilxVp3gZ/caElPW7AFaLlPEQuHizSKSY4hYNiqCtm5ZBO2w457nDxSmcRA9Qw
	DFIfChlUbLkEnMrMrwD1atQz5AFnyUj8cTrDjlFN7XGK1IKIGCCPo9vXz3OSsQTNwQOnaE4tnHV
	VbocJ8QXPJIcZuBRjVXbUAsQsbBKi7tNfUCI2qzNeUT9cRTScpC+iJpA9zPUWR//pHQ+tKjPqRX
	XC4J8wOfpwDCMdf0AXmMlI032TsmCRqwTY+ZvPQwk8i/9tcGBqtoc7drClFxQFSwrRjcJjjAdrG
	+xEGSJ5bOscWMGpUcVcqOYmavz9IM59c6QwXqbrTF7aLz7aLIgW1OSKjnaAth/qeqgszTHg==
X-Google-Smtp-Source: AGHT+IEdC0jxj0VQq2eeW7F/rssUiimWnvaXknuXhDlY2cRwdeuJW2P1Cj0gPVf99SnzHF6lzwYwTg==
X-Received: by 2002:a05:6902:f84:b0:e94:e1e7:fde with SMTP id 3f1490d57ef6-e951c42b49cmr876849276.52.1755807679876;
        Thu, 21 Aug 2025 13:21:19 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e93456fa756sm5217858276.30.2025.08.21.13.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:21:19 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 42/50] btrfs: remove references to I_FREEING
Date: Thu, 21 Aug 2025 16:18:53 -0400
Message-ID: <36185d8a18759d2ed86fa6a0d45ffc61bce82571.1755806649.git.josef@toxicpanda.com>
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

We do not need the BUG_ON in our evict truncate code, and in the
invalidate path we can simply check for the i_count == 0 to see if we're
evicting the inode.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 03fc3cbdb4af..191ded69ab38 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5338,7 +5338,6 @@ static void evict_inode_truncate_pages(struct inode *inode)
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct rb_node *node;
 
-	ASSERT(inode->i_state & I_FREEING);
 	truncate_inode_pages_final(&inode->i_data);
 
 	btrfs_drop_extent_map_range(BTRFS_I(inode), 0, (u64)-1, false);
@@ -7448,7 +7447,7 @@ static void btrfs_invalidate_folio(struct folio *folio, size_t offset,
 	u64 page_start = folio_pos(folio);
 	u64 page_end = page_start + folio_size(folio) - 1;
 	u64 cur;
-	int inode_evicting = inode->vfs_inode.i_state & I_FREEING;
+	int inode_evicting = refcount_read(&inode->vfs_inode.i_count) == 0;
 
 	/*
 	 * We have folio locked so no new ordered extent can be created on this
-- 
2.49.0

