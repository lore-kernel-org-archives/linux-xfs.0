Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC48254841;
	Tue, 17 Feb 2026 23:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771370457; cv=none; b=ahm0+dtCj6IAI+XhmjdoG8rqtWgwiZiSIm+ZDpcAbvYRkC0c2lFmQxqqMxtmLMVBIXm5rxwjqiZUXglomUiBsE3bWg2EJUCaUUGd/T4jfdUkzKDXMZC3b1/2qFRu7qz1+4ZXLa+Z0xfwAirHbfF6FIRHhkyFhQ3f5tm3F1df0EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771370457; c=relaxed/simple;
	bh=gGTr2TjQZWlseMbQ/HJ/9ABk8EPWNeSwCgdUumJHH+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXr7h+EcSKPSqdTB3tBrJ59UZQJUIoh9TJTozRl8DlyjNXG5AxxWNp3h0M5Ykl+J5M4QkVgMPjcAaL4Cc2M5H8x0rX9AVHdE2ifvMQMasx0PfcmuhXh7QY5tj7E85k8j/tRAgjnhfb10cK+EOKbblZdblERJrx6kyZOP6AmFRSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U1iRCcKV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U1iRCcKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC89C4CEF7;
	Tue, 17 Feb 2026 23:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771370457;
	bh=gGTr2TjQZWlseMbQ/HJ/9ABk8EPWNeSwCgdUumJHH+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1iRCcKVECUcHYL2dreSbyxQfhMOeZXHYMOeXfp7TZ1eQ7sqs9Tup+CGkIf8qNd4S
	 FWwb0PXP+mUfRIZj57huD/udhmwmJBP2cgO8WeIX8diaYhH++qjnT8YqaRxoRR33Ci
	 Wt/BECioTxAoixUTjJrFLh4wHL5SJBAK1XK5iA4zu0Q6cQ/XTNcZeKHgkRXhkzipOi
	 RtsO3yMU+doOcid3qqBTQrFgrJCtPTxW9BZoLemfUdZYlF6B70AFpSKX97tCopwoPT
	 YKKJOeAEcrSrxshsab/RApG4pwwhXoshZB+2e57+6NxneVMwk6ERw7fFQSdorer7Q9
	 1rmC4nsPD1uQA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	djwong@kernel.org
Subject: [PATCH v3 11/35] iomap: allow filesystem to read fsverity metadata beyound EOF
Date: Wed, 18 Feb 2026 00:19:11 +0100
Message-ID: <20260217231937.1183679-12-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260217231937.1183679-1-aalbersh@kernel.org>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As fsverity metadata is not limited by EOF we also take the hole after
fsverity descriptor as metadata region end.

For filesystem which doesn't store merkle tree blocks full of hashes of
zeroed data blocks synthesize merkle blocks full of these hashes.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/iomap/buffered-io.c | 39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index bd3ab4e6b2bf..6ebf68fdc386 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -533,18 +533,45 @@ static int iomap_read_folio_iter(struct iomap_iter *iter,
 		if (plen == 0)
 			return 0;
 
+		/*
+		 * We hits this for two case:
+		 * 1. No need to go further, the hole after fsverity descriptor
+		 * is the end of the fsverity metadata. No ctx->vi means we are
+		 * reading folio with descriptor.
+		 * 2. This folio contains merkle tree blocks which need to be
+		 * synthesized and fsverity descriptor. Skip these blocks as we
+		 * don't know how to synthesize them yet.
+		 */
+		if ((iomap->flags & IOMAP_F_FSVERITY) &&
+		    (iomap->type == IOMAP_HOLE) &&
+		    !(ctx->vi)) {
+			iomap_set_range_uptodate(folio, poff, plen);
+			return iomap_iter_advance(iter, plen);
+		}
+
 		/* zero post-eof blocks as the page may be mapped */
 		if (iomap_block_needs_zeroing(iter, pos) &&
 		    !(iomap->flags & IOMAP_F_FSVERITY)) {
 			folio_zero_range(folio, poff, plen);
 			iomap_set_range_uptodate(folio, poff, plen);
 		} else {
-			if (!*bytes_submitted)
-				iomap_read_init(folio);
-			ret = ctx->ops->read_folio_range(iter, ctx, plen);
-			if (ret)
-				return ret;
-			*bytes_submitted += plen;
+			/*
+			 * Synthesize zero hash folio if we are reading merkle
+			 * tree blocks
+			 */
+			if ((iomap->flags & IOMAP_F_FSVERITY) &&
+			    (iomap->type == IOMAP_HOLE)) {
+				fsverity_folio_zero_hash(folio, poff, plen,
+							 ctx->vi);
+				iomap_set_range_uptodate(folio, poff, plen);
+			} else {
+				if (!*bytes_submitted)
+					iomap_read_init(folio);
+				ret = ctx->ops->read_folio_range(iter, ctx, plen);
+				if (ret)
+					return ret;
+				*bytes_submitted += plen;
+			}
 		}
 
 		ret = iomap_iter_advance(iter, plen);
-- 
2.51.2

