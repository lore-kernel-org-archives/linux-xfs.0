Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF051D5ACE
	for <linux-xfs@vger.kernel.org>; Fri, 26 Sep 2025 00:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758846583; cv=none; b=P/wqfZ9iLQpFg0LYib8Lr09o4XUiW9F0dpq3U/ExUZOU003nATEvJRoY0BuHUHb4IKvlXQ3RsBBaav/r8sKNLelSnVqkmjU29Cy+QzS/GCUtAH2v0a35C8695ycm5tdaFAHzQdBjOMXh2qpGcHnXREkGixx6U8HsWgGiOWiPbrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758846583; c=relaxed/simple;
	bh=ZJKn2aUxwVXrXo21+pZx6cBCh+fmZr2QcyaMhglPP5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbjdpIsDdofXqDvPDhZllnlva4uZUEPnQ8sy8JIPEAf3oogrgmwtk1tVdNy653OyCLcqkEeLAa226Ni3pRziAU7eZ/3RgRcrjjQUUDx2pUlog20xrF7xnuLVSb/LPXh7YFHXl/XSSceWt+2pmym7bHm6dM1lgAIbTdghMaQGB6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E6X+FMtn; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E6X+FMtn"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-27d69771e3eso13616355ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 25 Sep 2025 17:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758846582; x=1759451382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cfpa58E21gi9e/RAKTk39wwAnWAES7lJ4fXxRAP7/fA=;
        b=E6X+FMtnWLfGdD87MYCUgtYFZjE3zqbtYDcgYbH3CRPmFvbyanYQU657FEQFv88noW
         F20yLDpYiV1n39fCL9p2NPB9r+Q3xV0Ro/zv9jvwWSgeVqN6zxTQxcuy6NPOGL4dn8Zy
         gFySXlXBJB42W+qrt+nft0juLEIvtqwcYlo7KmwsXXNk08ZhCqzz3KHduVe11p4KTR9y
         s/MkzsLHxwgzDEKRyFG4Hzb3RA5no639i4v/z+n8nio8zOMsX+iD9ht9bZwhJnwShFUq
         5l69L/tXfgU1qwmUeoCLofYA6vkwlRCME7H9fT9jyw5u87pHhWmQNY6uaY/R1pjVDgC/
         XSIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758846582; x=1759451382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cfpa58E21gi9e/RAKTk39wwAnWAES7lJ4fXxRAP7/fA=;
        b=dVf1KOe1aPYFFVADy2Tm/HX0+8r3AOmPTXv2ju1k0mlcmz7qP6F7rAiYgBdDc5iiTi
         Ck7jFx6l4D14pRChFD9SOjGgt5bGDABYQPi0YC+nEJW81UyMTcGYCPTEjNpRVbeR0/yy
         2qvF9ZJ6W4w50AsWFL7VvKy9T3xQY132A0huK3kYSPVJF7dEQsHvWhFSjDsRcugIOSJF
         kNelJ2xiC10LmgVXpqR8mXiejeXglpsbeQMSH+4FnQlB1iJruFxA7ulsRECQKmO19bmc
         KpX5vk4N5JQnmorJohEvIqvdau3ufBh6SRd4xVFF5vjwIbNML7k5QRyZmpviv2ZG+wLK
         nnvw==
X-Forwarded-Encrypted: i=1; AJvYcCV6ONO7U+CV6VpR6QyQffJePd8czDSQCjnW4neBccLTmIuyA+MNNjSrtjntmu5BmFfED6bCkJa8+Dc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxs+8ayIhRICo2QEVIeMXYHnDEoZg+PyQaeb017EJbJQRefAfRq
	7fa4i7DSQG4JnY0+6wfT/18qljk08emx0jNCenBtTHjeoU7cx5MAbWsE
X-Gm-Gg: ASbGnct0YZKDCEk9Q4jKfZnq2DTHZ2MaHfByChmkoYM1hUFBv3Nvh6qG29L91GUdqy2
	HcSnwvRhgKJowXustmOluCG5fFo9vdfUCRRgvRYMGMh/vq15OVhouE4oNcujlXv/8hZCHbizLCI
	0elVwbq1Yr7Ovc4ry9PBSFPafbfU/+CBiW7AHjCr7EvZIncvmj3DN1hXj1R74Sq7ed5OMlpAgKM
	KJ+Dd1hQ32mQ9g5evQfFGH9P1h34i2bisnh7dTUoYZxKSDZeNm4QmjVu71a7Zgvm8JVNyg6HA5o
	D1TMaUiZ3cgLQJlKjDexQ9KL+ucEwdJm90EdxfumufAAYGfqnO5NAwiUgKLbn2k5aVI8EH4HKr5
	vg2/nz8u+5gH4KxnWf9qOP7Pt1PoGQDZx2iGagUUHgEsx7dr35AKRasZo8vE=
X-Google-Smtp-Source: AGHT+IEkvHARpHr6lASCpYYJKhWtkl83Q5YPMtQqvQsOsQI6v9aOaa5WPfigq1o+4kPYb7qTz8Gvvw==
X-Received: by 2002:a17:903:b06:b0:276:d3e:6844 with SMTP id d9443c01a7336-27ed4a7e7d9mr49611825ad.33.1758846581629;
        Thu, 25 Sep 2025 17:29:41 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6716240sm36366015ad.54.2025.09.25.17.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 17:29:41 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	miklos@szeredi.hu
Cc: djwong@kernel.org,
	hch@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-block@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH v5 11/14] iomap: make iomap_read_folio() a void return
Date: Thu, 25 Sep 2025 17:26:06 -0700
Message-ID: <20250926002609.1302233-12-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250926002609.1302233-1-joannelkoong@gmail.com>
References: <20250926002609.1302233-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No errors are propagated in iomap_read_folio(). Change
iomap_read_folio() to a void return to make this clearer to callers.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 9 +--------
 include/linux/iomap.h  | 2 +-
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 86c8094e5cc8..f9ae72713f74 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -459,7 +459,7 @@ static int iomap_read_folio_iter(struct iomap_iter *iter,
 	return 0;
 }
 
-int iomap_read_folio(const struct iomap_ops *ops,
+void iomap_read_folio(const struct iomap_ops *ops,
 		struct iomap_read_folio_ctx *ctx)
 {
 	struct folio *folio = ctx->cur_folio;
@@ -480,13 +480,6 @@ int iomap_read_folio(const struct iomap_ops *ops,
 		ctx->ops->submit_read(ctx);
 
 	iomap_read_end(folio, bytes_pending);
-
-	/*
-	 * Just like mpage_readahead and block_read_full_folio, we always
-	 * return 0 and just set the folio error flag on errors.  This
-	 * should be cleaned up throughout the stack eventually.
-	 */
-	return 0;
 }
 EXPORT_SYMBOL_GPL(iomap_read_folio);
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 37435b912755..6d864b446b6e 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -338,7 +338,7 @@ static inline bool iomap_want_unshare_iter(const struct iomap_iter *iter)
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 		const struct iomap_ops *ops,
 		const struct iomap_write_ops *write_ops, void *private);
-int iomap_read_folio(const struct iomap_ops *ops,
+void iomap_read_folio(const struct iomap_ops *ops,
 		struct iomap_read_folio_ctx *ctx);
 void iomap_readahead(const struct iomap_ops *ops,
 		struct iomap_read_folio_ctx *ctx);
-- 
2.47.3

