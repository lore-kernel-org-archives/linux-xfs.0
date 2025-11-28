Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3535E2FD686
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 08:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318806; cv=none; b=oz6IJnFIbXqo65i+rHqdaIROapk6fNW963VhYbJxUnmZ+1oea7IuNgWmWspRDOqVx3ITrh2nDk8+LIvwMTWPirqB16T2ph3sA5+I4cXah52DAhHvqPLNV0UGtDHEPKchslEMpmjASVRWuJ3NW2JYABrWMu3hRGXt7KkqOrKbs54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318806; c=relaxed/simple;
	bh=FvdW5UGbfZbg4/JUFTbGCNNccxPDUjVX1PnGr5SdWKY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y0OpKWo1PR15f/I9qIOYGdrcMOspWpD/wQ5JrzXTl0FQmjz/YffV5zkYyw9LQqmAIJfdpjNSI159dT1KvHSFAlLhggtdiZtUHDKV5gHnibb4iuRa7gtcGI4l66VPbudonLmk6pfIAG1gkWcChkCB8vqSkxCcy3lPH+zNTF8kuRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j6Xjpoll; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j6Xjpoll"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b99bfb451e5so1098389a12.2
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 00:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318803; x=1764923603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fqwLZMa4ASc5Rs++C65X8rlK3EmN43I2MLDa5i9050U=;
        b=j6XjpollDF9Iut3S1/uQErW/2sxW+N8CcUuDQzoQmuMybl717nTrXj6cfh71xPIO1w
         cGg8gj6xtBy2Ha1Ja4mMXDmjmI7QzWx9DM8uwwKGdOHgnR0FX74S3KCkjjWoKza/s5/p
         HpFHgxXY2jPJW0EPQL5Uq2BqUB62xBYhJ7bT6voop8KXn8iT4Q9H95YS0g5VyWeYL5VU
         sHSMB4UDkm0SEwN8SZoAptZVrTACvmWXwzyOUb8r2sITYgQQXgy15E+fR5gP/fsgWg7t
         2zITSEaQcTvwmuF04dJhuLJC2Qralkm5ouuqwz4FN6aTisgmPHPNHCtNwaAoytwmClQg
         Z2/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318803; x=1764923603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fqwLZMa4ASc5Rs++C65X8rlK3EmN43I2MLDa5i9050U=;
        b=SnM3GnDDZ7U9uiCefUI4Iw2AbQAPyeuirKCpWkk8xnzT5vpFj+xz7K93St0RtyPRyz
         xB5ZAU/xJU+QYE6qyyyg24OnmWucHCzDV+KubULd8Dfr0zlw/H2cpPdVFg22NBExqChT
         juPxvPKcGpLBZwlc4T51cK0qtogh0o5xHNxuzsqk6NwEVYZF+OAvQQj8VK8JYjZk+gQj
         y/xOEjuhthGtvdU7TnfjcC0z2hTIXjmI4MYoRV/yg1WFWA/Q2aIyhpStohhGH2QdhmU3
         z7kq3wJIxoIOGhn+3R+hzikcPvA+RLoUSFLiYqx5ORU8TC+YkLHGRf1fpgSVyl9Blj7z
         YQWg==
X-Forwarded-Encrypted: i=1; AJvYcCUfOvmB8HqdgHo5LfbaWwwZ+8w7NR1rlz2BFG7tsO1bGxySaPyaWt4M5jucMyYrrNWkyy/DnKNfFIE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxnvgJuWSj7ABKRNBJl0SNRgibmf1INj8mmDTTBlTzmadqQDtR
	15C693iTsaKdrMyFqx/esmQDBH5iVDx6m2WLtYcXOrYo3HSaSbZdJAht
X-Gm-Gg: ASbGncsexVIlPAM9rBBbY9uxxxz2n977U0sw1sdJUZOJT37NiTj5oCOKvKrGEBFkuyj
	DsZqCYq4D5XAPZRHGfgEmWIexq/YPfHgK9jk/AgPW6raoxcfsMVBZI7IFDr64aDqYKVCGFRnpig
	FKPRCsrKUaObV4Xgf7Aecifnjfo/M/pYubDwJazMzgpQMrfda0r0W5JaAIk+YLli8Ln5pbycRxs
	MaySqur7WlEMtJueN32x3RQOE45Hv3NF1nmG5+/ekTjFWJYhJEhP+qX/qz55lk3Qcl6QUhqYv6L
	UFpdg73k3BTyDZHsnGkTcB/ps6wfNNavbpHcfIDqiplaAGB2g8W9bnVV3ljuUf8cIZKAUkTlFhN
	7QT3gsG3omw0UOEat4RAVct1HFOtM0A/iSV+lFCXVOKdIGZhDjtMoEhDMhDXLK7a5pVzjp9fAk8
	lve7V5bUZpIQLulpkUWAIbZOiB9A==
X-Google-Smtp-Source: AGHT+IHfWqQfXtBplCGUlpvV4df9l3L0Dj70ayVkP4asUXlu5VvYmL6fwPY6gq5t6aD4a2b+6FhgOg==
X-Received: by 2002:a05:7022:2487:b0:119:e56b:98a1 with SMTP id a92af1059eb24-11cb3ecc3f2mr9865235c88.8.1764318803303;
        Fri, 28 Nov 2025 00:33:23 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:23 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	gruenba@redhat.com,
	ming.lei@redhat.com,
	siangkao@linux.alibaba.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v2 09/12] fs/ntfs3: Replace the repetitive bio chaining code patterns
Date: Fri, 28 Nov 2025 16:32:16 +0800
Message-Id: <20251128083219.2332407-10-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251128083219.2332407-1-zhangshida@kylinos.cn>
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Replace duplicate bio chaining logic with the common
bio_chain_and_submit helper function.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/ntfs3/fsntfs.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index c7a2f191254..35685ee4ed2 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -1514,11 +1514,7 @@ int ntfs_bio_pages(struct ntfs_sb_info *sbi, const struct runs_tree *run,
 		len = ((u64)clen << cluster_bits) - off;
 new_bio:
 		new = bio_alloc(bdev, nr_pages - page_idx, op, GFP_NOFS);
-		if (bio) {
-			bio_chain(bio, new);
-			submit_bio(bio);
-		}
-		bio = new;
+		bio = bio_chain_and_submit(bio, new);
 		bio->bi_iter.bi_sector = lbo >> 9;
 
 		while (len) {
@@ -1611,11 +1607,7 @@ int ntfs_bio_fill_1(struct ntfs_sb_info *sbi, const struct runs_tree *run)
 		len = (u64)clen << cluster_bits;
 new_bio:
 		new = bio_alloc(bdev, BIO_MAX_VECS, REQ_OP_WRITE, GFP_NOFS);
-		if (bio) {
-			bio_chain(bio, new);
-			submit_bio(bio);
-		}
-		bio = new;
+		bio = bio_chain_and_submit(bio, new);
 		bio->bi_iter.bi_sector = lbo >> 9;
 
 		for (;;) {
-- 
2.34.1

