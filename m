Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DFB405D8
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442696; cv=none; b=DaBYoy1w4GKxs8M8JThh/HKLl8t9NxhTS/Pk2lH0yMQArYafk+5ARl5XMef8jea9HCKgME7urvs7Cr/bvvaupnCByU+oXQ2H6oucJeUwZNhftGI0+lo/SKSKVZtfvajQk9CFBRRivAeui/dJFZhxetZrXJNc1eCXsmijidkl40o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442696; c=relaxed/simple;
	bh=Ndj7NBRzsbssyfwEqS+KjV5iCt7PHuzMq0I9Zxfi338=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p664ml7J/npaoHhXp8KYhfKeNRAuf6wdrlxhOAsBixLxlpAwA38j7NDyuNDXXZyvZAV5lvvrgJAqe8hcBka3YKpiX9YIJ4YnkDHfAXBXWhZufhTDZp5kc4FHOD1qg6PPfw6Z0FgZkptR0nDL/V8V4umjvVN5vrXlT5dDm+6kppI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AtKmlsTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AtKmlsTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01E2C2BD10;
	Mon,  3 Jun 2024 19:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442696;
	bh=Ndj7NBRzsbssyfwEqS+KjV5iCt7PHuzMq0I9Zxfi338=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AtKmlsTd6+pc0lnqG6W0NVdZ+4n46TDAk5egCVz5Vidlr5fEXMKtezXLmvLXenYdz
	 IlPWV7fFkSibX9pmmL6Hs4kC2W8S4UEapbyWP+YSLvTXChgJRfQ9Xou/LOaJD8aXqS
	 bCH6wJWmV1iYYlHtULDeItmRjVfvpXzaHBYyLH5Dd0Vx6OEHvTlE1V0OeNyuOJrGoI
	 s0NBWTnBEeFCPtVEdNFiHZndPDAzSVdU9PvyZG3GBKv9zbseafniF92by1xkcEw/hZ
	 EixDGyLUUM/jdm4AJSal8ynHhCNIqU9bPqjg3SGxK7B14aA/xT3myn7KPl1LcLychO
	 5zmmTP/7vbZPQ==
Date: Mon, 03 Jun 2024 12:24:55 -0700
Subject: [PATCH 1/6] libxfs: provide a kernel-compatible kasprintf
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744043087.1450153.6985494308531016652.stgit@frogsfrogsfrogs>
In-Reply-To: <171744043069.1450153.1345347577840777304.stgit@frogsfrogsfrogs>
References: <171744043069.1450153.1345347577840777304.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

The kernel-like kasprintf will be used by the new metadir code, as well
as the rmap data structures in xfs_repair.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: tweak commit message]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/kmem.h |    3 +++
 libxfs/kmem.c  |   13 +++++++++++++
 2 files changed, 16 insertions(+)


diff --git a/include/kmem.h b/include/kmem.h
index 386b4a6be..8dfb2fb0b 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -65,4 +65,7 @@ static inline void kfree(const void *ptr)
 	free((void *)ptr);
 }
 
+__attribute__((format(printf,2,3)))
+char *kasprintf(gfp_t gfp, const char *fmt, ...);
+
 #endif
diff --git a/libxfs/kmem.c b/libxfs/kmem.c
index a2a3935d0..2e2935180 100644
--- a/libxfs/kmem.c
+++ b/libxfs/kmem.c
@@ -104,3 +104,16 @@ krealloc(void *ptr, size_t new_size, int flags)
 	}
 	return ptr;
 }
+
+char *kasprintf(gfp_t gfp, const char *fmt, ...)
+{
+	va_list ap;
+	char *p;
+
+	va_start(ap, fmt);
+	if (vasprintf(&p, fmt, ap) < 0)
+		p = NULL;
+	va_end(ap);
+
+	return p;
+}

