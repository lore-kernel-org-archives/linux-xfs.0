Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB252F360B
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 23:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758066647; cv=none; b=cWTGXy1SjcQYJXaVV8fAuni2Bo3qrJ4PRob0lHgfqIiEAHfA7054NUZJJx6IihrM6PdmXBer3afA879lgKKtN+38iarzsDmEEu1grL1vwUm0tPv8OhkHcWcI3UHPu5OgUb/liY9+yZdtmvgeaUjzch/W6MZPeX0XmF60mAHg14w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758066647; c=relaxed/simple;
	bh=WvDk48cCQDjmhEgUA3H/dzeLiBWsntQn2o/liLF6Xnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aebCMQxe/AuepaRVfbrBRXDyOsIXpNV3W9kjZFrMCB/unpHToP+tnvx5HVFZ8I4PYpI8aTezUqGuBuJu1oKhGII8RBWUUEfa2qpZ0ZOd7slAgH7SHqEp2VFSYPLjU11cnj94cJft6X0OSEhOyPjNbhR9RRZfq9n2jbYcEIXytxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cP0VpIBQ; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cP0VpIBQ"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-772843b6057so5496938b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 16:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758066645; x=1758671445; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BHobEDbeY2DMEEr5x+JZY2wJlQRrUUUgIcR140CbiFE=;
        b=cP0VpIBQ8bSAm6pcXxfh5/LTWHp2uJR6AZTw0bEmn/Qg4U0ZP/IH2jVqER2t1SmN8r
         B3oyorgV8DINUgGl0Wy8uq39dek7maZOcd/rd1aiEg4mSylA6/i4XjTaVgTjInvEa+UI
         jAkcEMcXnIHqjxA4LWqsFJt9/rqVSAli+OKFfNn6KxKkG4ZRCGZAQKKbHnlyVZ4V/StV
         6rU63KwOcdZKjdUzLRNLCOjhzj/sbPj7yzO3uaJ9v7cAQQeLIlj55/Wbp29wCQKiKq20
         5OxMJPuVnbymHqsQvYx0GONvyAKEhx25O/VvCIMMusrrjMVQvCXJwKFvHsc89z4DEWNZ
         oPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758066645; x=1758671445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BHobEDbeY2DMEEr5x+JZY2wJlQRrUUUgIcR140CbiFE=;
        b=ajvTyl7DjwAgDtouP/st3QkjXBDtakryv5pqT5FlHILbEUktBuA9XuLayYTsrpJwQj
         +vKaqgU4Wze3OSLSLATQ3JKSwCGMTBdV1ERcrkyVID3ab0OO909+70uvvdbngJ1grV6T
         r/c8TeTKpwpZHb+zVUHq9IHM7adpYet9O2jo3g40Vu0nDfLzmN8GRHJD/1VgM/4I5H27
         UDuq41dc6gdTfPdu9qAwBEg22Dyijo8ohqtEueBjtkk2HC4R5lhW3z/uHL8RSdPVwrgt
         XxaDiz6GAXTQXjNqO37W+mGOA5ayBt8y/L3iubNTdINTDAaywi9ouMxNtxbf0QdRAqfJ
         lYXA==
X-Forwarded-Encrypted: i=1; AJvYcCXfZ9vIc8uTORB57sBttNICTshWzEO8mZSGHX3bj7xP3okutTAfPouPbo6AlAWXE8421N4XLv61+N0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHK0aG2WFZlssg5HGxuqWVdC/UPgBrjpEQY0bI7NVnoKCtiFKf
	IL2P2+au8ymKUNVK/5jMeB5t2G0OjTAYm7JQysMBDZjV1kjVIFPbF+T7
X-Gm-Gg: ASbGncsz5vEodccfpZAV0M2HVO8IL5EAnjyAAIe0LXSL8dPaCebAELj0+6EeEpWGF0L
	2cUbQj1l3WdV323o3OojRy3zZ3bPaH5vKvkEKhj2k6ms1zxnpigGFgywBLi5RfaqprgvXs9B5VQ
	oo9J66bPKBKrSIovaijrgwvAMGeYVrOHXoEfpKGgDpVSuIF12yELY7bQQlEnLzeQzCNqWcMEXCt
	uDSYL1IotM//C2KuoQhUIDxU5ZCvM51A2odal1pDAU6JWbHOZqNBFrj70gglmwonq8Wg5D7Mbmy
	LuEENVwrwsZvU40+tHQMKyqyXz0TZJnYS+pyywdZRBshDBRu99s96Y5R8WYEXLJnOjlyhdJm/pH
	e3JXe6c3GpNRIe3RQgn1WJL0Xxu82m2DiXKprQUUcKq+M0AMzag==
X-Google-Smtp-Source: AGHT+IHkRlLnCp0WU1FUde2gi6s/vcnbEIKk0ErpbS8ixCYe3+7N5XMnBohfRkdqaL85QNvZmgrsuQ==
X-Received: by 2002:a05:6a20:7d9c:b0:262:5689:b2b1 with SMTP id adf61e73a8af0-27a938d847dmr96465637.14.1758066645351;
        Tue, 16 Sep 2025 16:50:45 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:55::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607b331e4sm17001334b3a.70.2025.09.16.16.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 16:50:45 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	miklos@szeredi.hu
Cc: hch@infradead.org,
	djwong@kernel.org,
	hsiangkao@linux.alibaba.com,
	linux-block@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH v3 12/15] iomap: make iomap_read_folio() a void return
Date: Tue, 16 Sep 2025 16:44:22 -0700
Message-ID: <20250916234425.1274735-13-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250916234425.1274735-1-joannelkoong@gmail.com>
References: <20250916234425.1274735-1-joannelkoong@gmail.com>
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
---
 fs/iomap/buffered-io.c | 9 +--------
 include/linux/iomap.h  | 2 +-
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 72258b0109ec..be535bd3aeca 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -450,7 +450,7 @@ static int iomap_read_folio_iter(struct iomap_iter *iter,
 	return ret;
 }
 
-int iomap_read_folio(const struct iomap_ops *ops,
+void iomap_read_folio(const struct iomap_ops *ops,
 		struct iomap_read_folio_ctx *ctx)
 {
 	struct folio *folio = ctx->cur_folio;
@@ -477,13 +477,6 @@ int iomap_read_folio(const struct iomap_ops *ops,
 
 	if (!cur_folio_owned)
 		folio_unlock(folio);
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
index 4a168ebb40f5..fa55ec611fff 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -340,7 +340,7 @@ static inline bool iomap_want_unshare_iter(const struct iomap_iter *iter)
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

