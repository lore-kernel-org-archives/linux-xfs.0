Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D451A6817
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 00:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782864738; cv=none; b=dyf9koiIIllOe1XduUT+YplsmcPZ01UqM3LTeB7h7D35DKfiz8JqeMhW57kzhqYKoK7PWqhASc5yAYd0w0YAjjpWy1Z05ubsVxxjmSRUX6ng0yVZIrKbsZ9rD5mb8r1WMIWLN+OCX0eZj3h7W/sXpPi8FFndZs/v/Vbq2Ja3dxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782864738; c=relaxed/simple;
	bh=8T/d74ERA6AaCGM4cvzp+ExTmXzK0rpUXpvgoIg5y/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujJi//O8Wh+Hl1U3ecrMQVAt2IjJUxHICwv8l2l88AhbEtW2A4oZBf51ENiD6iB4F0RESq0JCYLoPXPUfulcyQhcRdY2szf+95EjYrLVkeMXjCnL+9gYG/xflAv3sNMcQZ9KiwFcVaa/4dxGQtBdEMLwyRC4jOYL4ykJeIlWWnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XGB8YJsF; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XGB8YJsF"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-4896ae35be9so59904b6e.0
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 17:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782864736; x=1783469536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wmKA1vAG4G3zbLqRzYjs4WI66ubpxbJgQ7xE4kIKrFg=;
        b=XGB8YJsFAcOLjMAanJPQH/z/lgzJIdNJe4cldhDavZWo4mDEdV8Qi+cxay3xBnnET+
         KoKkJTjqsfMSl4HXAgM6NEINIDzR/V/OzXwzd/U/AvcIp1SvBna7o+uSGUclFoIdUX/U
         wncZ1NABcdwSnkfgEnzYOIsu2HaN+ww0hiId9hkUBCgaLeKgO8QFeT8biWTPNZyioeow
         yICQJ93yEEeVmUBEBTsN00JiiDP5ukl1Cm+mbgzvnom/HV/lWQlE+rfVGg+sM2ogrebK
         IZc8FnGv7mpCq3ADbn0jOCiUSiaWaGWYYJA/wynliv5jk+AHF5Fg6j5vVNa0pa/2cmSY
         VS/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782864736; x=1783469536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wmKA1vAG4G3zbLqRzYjs4WI66ubpxbJgQ7xE4kIKrFg=;
        b=V+WItM8505LvDbnAwIqlKII031qGBQu5n11cI89UoUjOa+bFJzY070ILFQxF8n8KzV
         qgCQKi3dN1lbhlRq04Jg8mdkZ8tgGMiPE8dEBfTQZVEBHXE/IGZtEZwSCVkNBKuIluBd
         uiGiufkIBc0zzjDguC9xvCHlb7KqQnwLd7HRqAQTpX12Pq2wR0bzZ9eNilKF8AFw7KZ/
         +haylxYjtY7gQzCpx4UWO4XD4O/3DbJ++QJxLC8GeoEzYgA5AsQ/F9ckoxb4qOuhqY7K
         qg6a3L7pVWK3xuF72FYx7JvwhLITOD3bKjvSbhkcFrXcYE00BnJ049xiwx0Cn/d+jsHR
         AcvQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Dmd+m47yF+sQ3uygbKm/E4UmKXkKW2gcUdE0hwUiiCtCaf2rYALnIS1Pj36/UGNWWDwDPS+7wz2A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi//3rXjPnYiSStdkEDLIsDlFZ8vPZ3j8U/TcFU0j30k35n1KW
	Qi1R1Jo64rmXgiwGhOP/J/ITCYigwBUDgrXgRQBjIJcEhhXRq7tCoEup
X-Gm-Gg: AfdE7cnh6ZvRz/foeLelZ8niGlmGcy8GR4ohY7whSlq9zvYQ5nyJewSpqMSI2lyE/oc
	VrGIEh67uexmLRLD13HaEKZPw4EIcgNHfJazTOgGDkPpu6wAFPbaLu91bjB38rhz8osU5JgPxFo
	6QGGn9QtxmfBBFkb7U9v8WCorOThqAk32Oz2tPkY5n7ESLTK5ySbG78V8/MftC0P9zlIwp7VwtY
	7C188VNCc+7fcWhuPgnpOf1k3C2MnCe3cCH6iERi8KEQsnuFSx4BOz59roB1s1UkxOknoFCafEo
	juBuU7UL8aa7Cc8AuiP68xDcfgw0TD0zS8G4m1JFghT1z8aYntH9mmZEi7lsmcicBL7OVJRtj/H
	LPeHbRXOjAAt6JQu1o39rAXN+diK4UIxavVBE8QMZ/gDT4G5vjFCve1IQJur2+1P4W1mGtSE0JS
	+zgVM9D9P0nQIEA3KFAI0ooMWlqVaT4EH6W8s8fHP0jKSMloWEZ5CguLePPs6tPpg=
X-Received: by 2002:a05:6808:4f0e:b0:489:5c86:ba9a with SMTP id 5614622812f47-495fd6520b5mr2332473b6e.19.1782864736060;
        Tue, 30 Jun 2026 17:12:16 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:9::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-49606ad46c4sm250409b6e.10.2026.06.30.17.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 17:12:14 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	hch@lst.de
Cc: djwong@kernel.org,
	willy@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 16/18] iomap: remove ->iomap_begin()/->iomap_end() legacy path
Date: Tue, 30 Jun 2026 17:09:31 -0700
Message-ID: <20260701000949.1666714-17-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260701000949.1666714-1-joannelkoong@gmail.com>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With all in-tree filesystems implementing ->iomap_next(), drop the
->iomap_begin()/->iomap_end() path.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/iomap/iter.c       | 87 +++++--------------------------------------
 include/linux/iomap.h |  4 +-
 2 files changed, 11 insertions(+), 80 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index 1062e4e34c38..466c491bdef6 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -39,81 +39,6 @@ static inline void iomap_iter_done(struct iomap_iter *iter)
 		trace_iomap_iter_srcmap(iter->inode, &iter->srcmap);
 }
 
-static int iomap_iter_legacy(struct iomap_iter *iter, const struct iomap_ops *ops)
-{
-	bool stale = iter->iomap.flags & IOMAP_F_STALE;
-	ssize_t advanced;
-	u64 olen;
-	int ret;
-
-	trace_iomap_iter(iter, ops, _RET_IP_);
-
-	if (!iter->iomap.length)
-		goto begin;
-
-	/*
-	 * Calculate how far the iter was advanced and the original length bytes
-	 * for ->iomap_end().
-	 */
-	advanced = iter->pos - iter->iter_start_pos;
-	olen = iter->len + advanced;
-
-	if (ops->iomap_end) {
-		ret = ops->iomap_end(iter->inode, iter->iter_start_pos,
-				iomap_length_trim(iter, iter->iter_start_pos,
-						  olen),
-				advanced, iter->flags, &iter->iomap);
-		if (ret < 0 && !advanced)
-			return ret;
-	}
-
-	/* detect old return semantics where this would advance */
-	if (WARN_ON_ONCE(iter->status > 0))
-		iter->status = -EIO;
-
-	/*
-	 * Use iter->len to determine whether to continue onto the next mapping.
-	 * Explicitly terminate on error status or if the current iter has not
-	 * advanced at all (i.e. no work was done for some reason) unless the
-	 * mapping has been marked stale and needs to be reprocessed.
-	 */
-	if (iter->status < 0)
-		ret = iter->status;
-	else if (iter->len == 0 || (!advanced && !stale))
-		ret = 0;
-	else
-		ret = 1;
-	iomap_iter_clean_fbatch(iter);
-	iter->status = 0;
-	if (ret <= 0)
-		return ret;
-
-	memset(&iter->iomap, 0, sizeof(iter->iomap));
-	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
-
-begin:
-	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
-			       &iter->iomap, &iter->srcmap);
-	if (ret < 0)
-		return ret;
-	iomap_iter_done(iter);
-	return 1;
-}
-
-static int iomap_iter_next(struct iomap_iter *iter, const struct iomap_ops *ops)
-{
-	int ret;
-
-	trace_iomap_iter(iter, ops, _RET_IP_);
-
-	ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
-	iter->status = 0;
-	if (ret > 0)
-		iomap_iter_done(iter);
-
-	return ret;
-}
-
 /**
  * iomap_iter - iterate over a ranges in a file
  * @iter: iteration structue
@@ -131,10 +56,16 @@ static int iomap_iter_next(struct iomap_iter *iter, const struct iomap_ops *ops)
  */
 int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 {
-	if (ops->iomap_next)
-		return iomap_iter_next(iter, ops);
+	int ret;
+
+	trace_iomap_iter(iter, ops, _RET_IP_);
 
-	return iomap_iter_legacy(iter, ops);
+	ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
+	iter->status = 0;
+	if (ret > 0)
+		iomap_iter_done(iter);
+
+	return ret;
 }
 
 /**
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 8a78f47c557b..52d6f585b941 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -194,7 +194,7 @@ struct iomap_write_ops {
 };
 
 /*
- * Flags for iomap_begin / iomap_end.  No flag implies a read.
+ * Flags for iomap_next.  No flag implies a read.
  */
 #define IOMAP_WRITE		(1 << 0) /* writing, must allocate blocks */
 #define IOMAP_ZERO		(1 << 1) /* zeroing operation, may skip holes */
@@ -254,7 +254,7 @@ struct iomap_ops {
  *	incremental iter advance.
  * @status: Status of the most recent iteration. Zero on success or a negative
  *	errno on error.
- * @flags: Zero or more of the iomap_begin flags above.
+ * @flags: Zero or more of the iomap_next flags above.
  * @iomap: Map describing the I/O iteration
  * @srcmap: Source map for COW operations
  */
-- 
2.52.0

