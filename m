Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC7D1ABED8
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 15:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731598103; cv=none; b=COmKtWdvvD/K/hYmdl+qo8o13ccsGdFlO0Nd/UtSC/V0vCXd0HpM7rYFSs/pUCbOKug9C+Zabsbs70fm3Iz0QdbEjsasbzCIVVtK0j+VjhtE0saKDVY9NdSJjGaJIM4dg7+lCUZGsrVv40GyH0pGS2JV9vUzzeb59744NlJE8Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731598103; c=relaxed/simple;
	bh=lNhwCmzwFphLkSB9taIvs4WJ/6CHD1yuvvg662y7/aU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTWB/ZTG5QsqfBdmerrmwlrR2qTSwGxYmdtvh9rmTX9HRNADZAnjekg12z8yOwrUyJn82nAV030oNcyilVukCCvh+r0kWBx8w6VXrs+Mbllw4Y97ZEAEpvEfZICnFFmkRHaVhbKvcZgNwtVXaU66UqtlDNWBA2Cf+jtfygkH9OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SVrMbxI5; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SVrMbxI5"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5ebc1af9137so297687eaf.2
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 07:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731598098; x=1732202898; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bh4vHLcSKYCCRkbDjlhjn1EJt3wp9QgKXbTvV2Vr6u0=;
        b=SVrMbxI5HUdJ+oGYj469+T374H88/9gwfszmBpWundKS7Y43s6hygEFdIBbqJzVbbl
         SbQu0RNUsOk/eju4spW3OuP2ZOiOFKEJBKgaUppYsVUy3IAhsR/qnzoXWClNIJWMbr6l
         KNM84FWUZYttbT0yYFVwyE3DaFda1vz+18ywpMEpT3mNcEZrrwP6oC2UbW84l4cOuhlz
         76nMmzfJ67XOHJ8TvfSKs7x8gaqc7pg+eU4MJhKPp7gGQvO/gNiwLHFAZZV1kSRfBt6o
         AADvjhk/iSnKTkXutc/JyULDFSc1N4QnVNkFNWDcw3OHGy/qxG6aEEXb1O93Jkdi26zm
         RNIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731598098; x=1732202898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bh4vHLcSKYCCRkbDjlhjn1EJt3wp9QgKXbTvV2Vr6u0=;
        b=QCdmLKLJ0lz++gGln6a3hV7hdcDi5/M0Q8HhbBMRhcxzgK7kfk2uzj2OKO7wa1wPT1
         SoLa2OdThNk3UhGbUIfHoDCMXEWWEe+ffNfqWt8C3TZwhbd/2ExwG3LmbICH0MUaHAra
         oYsoLIvgj7Bph9DCOPHdbgmYkb2FcDKrtI7/ZYWLGWmXYyOmeVlmH5ZhPdSkrwcR3Fmw
         00ql6KM/OreAjmguRPV+7nqrP+pLVv8H5lsluZQBSTiTRll/qf5meDvGcZNXhoy/dheU
         3uppI1OyLj8xYbVaWoJxbbD3XiqzPW7zfRsufXw1Hx0oVgn9zC5kmIb79+cZFspPEnCZ
         E2Bw==
X-Forwarded-Encrypted: i=1; AJvYcCXuR1hix0T6Ns/+ht64iveA+XWV21pP78OjZQtQuDuctJ3l/mb/t6pzpG8luWoDgoBEVru7Cf1wrIA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw11Ryt0Au7T8y66TpbCHTkqHRPk+8H5fnACnE5Vw/ESVflCllN
	Y6dDrW/E+EPKLAMSZKTlkT7urgAJ/e/lkBvBd1iWEq9oOJssIdUjRvA3xlcpm7E=
X-Google-Smtp-Source: AGHT+IECtJqHxvsDZk559Jqz444iSDToPVSz/2QlEeAwby3Gwu7O3Iv2UCv4dhdd6n28ENyvjODyaw==
X-Received: by 2002:a05:6820:1e0c:b0:5e3:b7a6:834 with SMTP id 006d021491bc7-5ee57b9c8e0mr20035625eaf.1.1731598098551;
        Thu, 14 Nov 2024 07:28:18 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5eea026eb41sm368250eaf.39.2024.11.14.07.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 07:28:17 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: hannes@cmpxchg.org,
	clm@meta.com,
	linux-kernel@vger.kernel.org,
	willy@infradead.org,
	kirill@shutemov.name,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	bfoster@redhat.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 12/17] mm: add FGP_UNCACHED folio creation flag
Date: Thu, 14 Nov 2024 08:25:16 -0700
Message-ID: <20241114152743.2381672-14-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241114152743.2381672-2-axboe@kernel.dk>
References: <20241114152743.2381672-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Callers can pass this in for uncached folio creation, in which case if
a folio is newly created it gets marked as uncached. If a folio exists
for this index and lookup succeeds, then it will not get marked as
uncached. If an !uncached lookup finds a cached folio, clear the flag.
For that case, there are competeting uncached and cached users of the
folio, and it should not get pruned.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/pagemap.h | 2 ++
 mm/filemap.c            | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index cc02518d338d..860807e34b8c 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -721,6 +721,7 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
  * * %FGP_NOFS - __GFP_FS will get cleared in gfp.
  * * %FGP_NOWAIT - Don't block on the folio lock.
  * * %FGP_STABLE - Wait for the folio to be stable (finished writeback)
+ * * %FGP_UNCACHED - Uncached buffered IO
  * * %FGP_WRITEBEGIN - The flags to use in a filesystem write_begin()
  *   implementation.
  */
@@ -734,6 +735,7 @@ typedef unsigned int __bitwise fgf_t;
 #define FGP_NOWAIT		((__force fgf_t)0x00000020)
 #define FGP_FOR_MMAP		((__force fgf_t)0x00000040)
 #define FGP_STABLE		((__force fgf_t)0x00000080)
+#define FGP_UNCACHED		((__force fgf_t)0x00000100)
 #define FGF_GET_ORDER(fgf)	(((__force unsigned)fgf) >> 26)	/* top 6 bits */
 
 #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
diff --git a/mm/filemap.c b/mm/filemap.c
index a8a9fb986d2d..dbc3fa975ad1 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2002,6 +2002,8 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
 			/* Init accessed so avoid atomic mark_page_accessed later */
 			if (fgp_flags & FGP_ACCESSED)
 				__folio_set_referenced(folio);
+			if (fgp_flags & FGP_UNCACHED)
+				__folio_set_uncached(folio);
 
 			err = filemap_add_folio(mapping, folio, index, gfp);
 			if (!err)
@@ -2024,6 +2026,9 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
 
 	if (!folio)
 		return ERR_PTR(-ENOENT);
+	/* not an uncached lookup, clear uncached if set */
+	if (folio_test_uncached(folio) && !(fgp_flags & FGP_UNCACHED))
+		folio_clear_uncached(folio);
 	return folio;
 }
 EXPORT_SYMBOL(__filemap_get_folio);
-- 
2.45.2

