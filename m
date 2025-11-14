Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFF6286412;
	Fri, 14 Nov 2025 05:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763099582; cv=none; b=QWjxQta1z8Hu2+7vaHUaXkch+KPvLOM3EVccrXearaJYhTs9se7pTXTu2yKqxJTb3c1FrQVB7dO1Z5Y2n5IwZN5m9EGT9GpLVrvlcJoJlEfezWZXB5qjw2RNxIG35Bfu74uiAGzpn05UPXPdSiw+YHFlkdGZbrRAeFa0emcFaqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763099582; c=relaxed/simple;
	bh=ofBQcBpH9Od9G2iUSgGvQFUUxuTMcGnDwIbZxY0+YMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOO9d3Vj23N2EK8LFSe15PcjBFmqH5QLQxdawshsr6eNMHrTmTYZ0PeiGJeXDOzd/clEYx/V5P55aj2e9Ykrj1HCcuTil63c5ZPzqbb5p6/AqfmEoM2s1tyb6/7uGOpYuoYNxuDnw1Ka0BIvBRRYpFvcZtN+150o5Mn7QVpO03Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OahjdW49; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OahjdW49"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=++7oq+djmXlDsW2yepDV3U7sQXaUHqfcwhU4CQZpezg=; b=OahjdW4992y7+oryx0naW3XQEb
	qR/rsjN+s8Ui7ItT7NlYBY74S70s0b8Zf4Si9mxcLddd0OGAwVu2snihEOQ2Xh2grtWTIB2WsDqxI
	OpG3zkynwvnbpNvqVBiXREfDjBX+j9gYfX+UKZ+HNEJQ2FZOdt2/sejxBPd+CDlIqV8E2njq8/hNZ
	xfbBP2v6jlY2zR6YR5PgioXtDkFBvdA99VD1TgFSkXN7uyvmSQSJbt3qr8XGNxCszW7tKWlKPOCLH
	wvoecC1Sd72HwUVd6SGdAFf+LOR126xVP8+LOMjFXxHcqRbJPXMfD3hiYd9xtM70loHR9W+u9vMfN
	AxzfycJQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJmjz-0000000Bc2m-0BPo;
	Fri, 14 Nov 2025 05:53:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Luc Van Oostenryck" <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	linux-sparse@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] lockref: add a __cond_lock annotation for lockref_put_or_lock
Date: Fri, 14 Nov 2025 06:52:23 +0100
Message-ID: <20251114055249.1517520-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114055249.1517520-1-hch@lst.de>
References: <20251114055249.1517520-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a cond_lock annotation for lockref_put_or_lock to make sparse
happy with using it.  Note that for this the return value has to be
double-inverted as the return value convention of lockref_put_or_lock
is inverted compared to _trylock conventions expected by __cond_lock,
as lockref_put_or_lock returns true when it did not need to take the
lock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/lockref.h | 4 +++-
 lib/lockref.c           | 4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/lockref.h b/include/linux/lockref.h
index 676721ee878d..7b4bb67db216 100644
--- a/include/linux/lockref.h
+++ b/include/linux/lockref.h
@@ -49,7 +49,9 @@ static inline void lockref_init(struct lockref *lockref)
 void lockref_get(struct lockref *lockref);
 int lockref_put_return(struct lockref *lockref);
 bool lockref_get_not_zero(struct lockref *lockref);
-bool lockref_put_or_lock(struct lockref *lockref);
+bool _lockref_put_or_lock(struct lockref *lockref);
+#define lockref_put_or_lock(_lockref) \
+	(!__cond_lock((_lockref)->lock, !_lockref_put_or_lock(_lockref)))
 
 void lockref_mark_dead(struct lockref *lockref);
 bool lockref_get_not_dead(struct lockref *lockref);
diff --git a/lib/lockref.c b/lib/lockref.c
index 5d8e3ef3860e..667f0c30c867 100644
--- a/lib/lockref.c
+++ b/lib/lockref.c
@@ -105,7 +105,7 @@ EXPORT_SYMBOL(lockref_put_return);
  * @lockref: pointer to lockref structure
  * Return: 1 if count updated successfully or 0 if count <= 1 and lock taken
  */
-bool lockref_put_or_lock(struct lockref *lockref)
+bool _lockref_put_or_lock(struct lockref *lockref)
 {
 	CMPXCHG_LOOP(
 		new.count--;
@@ -122,7 +122,7 @@ bool lockref_put_or_lock(struct lockref *lockref)
 	spin_unlock(&lockref->lock);
 	return true;
 }
-EXPORT_SYMBOL(lockref_put_or_lock);
+EXPORT_SYMBOL(_lockref_put_or_lock);
 
 /**
  * lockref_mark_dead - mark lockref dead
-- 
2.47.3

