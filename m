Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F058E1CACE7
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 23:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731368938; cv=none; b=YLxNDJmqiKYyS2m5fQMpkU63Uespv/I7+b5NXDeJ0ok0n0mDfrUZfuCy6QVOVkLaXeHXfU/GSfnaeAMZeCpcmMm/7PfqUvKuMBYuv4bb1HkytReYxQAh3h7FSmjbP1qdS9yr/vGFS7TigP+1GdzQFgWo9raodA+FRMU9Vt61IGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731368938; c=relaxed/simple;
	bh=9Ma4XXKwKrbfCmk8++0FMznuxKmPjzqiFxHZUZ9JUvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6WkUhzF/v5N/pEei0rFgvhZZMRvmiNLh0/U2oR8d0EUswOFD0Caj3I4EQAJsB5l0S5u/AQJMpkPPzqkOiffn4HAdbHsZwQJ3PB+FSonkG8stiBmVdPh1wLpUHlAhPqX6a1VSo0c58lq+ktLdlFJLqbkMkpnEQS8poh+EhjOsmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=R4aiaU9j; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="R4aiaU9j"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-71e625b00bcso4090756b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 15:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731368936; x=1731973736; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CL+fLnGK0BaMmMKm57rghb0D3nDN7TOwfaAxP5ktg80=;
        b=R4aiaU9jMdoXAa5LmgNMxyvFc/Uw4BX0xojgO8xFzGRanykKRWYDUDxa5zSd2FP+da
         2/d03PDDT7mnhyzNolWF8mXaubonK+n7vPkCmjhw5Q5nTBMgqWqKJpLSFITxoFofw7Km
         5bkWpUBbRX0UnN4AcqdLVnOCqscDu88xVBX/kYbwyfpp+nGwVyp3DuORQwedYFsxuAxf
         tJ76CARYeBEC+/KVXnkWi8pMKzdVicNjxFhmwbo6OPJgCa3gHhMLpQ87VKaS+rEuHMhB
         lToEni2gTX8sH3PRBY2+gSwr/RdQhyxPOogh4+g1caIeORHHruxmpnlqR3kSbFAW5Coy
         wRcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731368936; x=1731973736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CL+fLnGK0BaMmMKm57rghb0D3nDN7TOwfaAxP5ktg80=;
        b=BhipY1SemJoNXcGPLMXSNMg16TevTCgjzHc3M4p4rnLAEC5zrtaoapNGi7840pLXK7
         hINkGX2CjOv0uwXKDW2UB3KZFVIIicIWNhLo/08GmVTt6/7S2ZJBDdCpm+WAdqQVx+HZ
         Pvrud1CBT+KMV/filv9YghwC0W058OLl5Sz2IiRqShRw1gP7uOqW2xdaYEHcjUcKTWhs
         Yy3hrm73HPc+9/GJTUc2ZqdWly+V/pCofEWJjvA+BRKU/2PBq/oGgvv9uKcoINhb1riQ
         MhQFMuR9RBobs7sDCC358a5kfacBOOfB8l+5klpHlTvxeQeGoHmj2cbRMZ7PTBlH4HeZ
         5TQg==
X-Forwarded-Encrypted: i=1; AJvYcCVPbPfTC2ZVG0dyFYDqI4mMsnwZDjwyT7ZWl5EgOY6i8u1X2fXnjYWD7O2k7F9Sx9BYtWQCTKuVqlE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyskFu6YxzWVn1RxJUgTKyLKz5OndwBDY8kKgHqbM4RuTUrxSd/
	uDiA+vYnZ4kNsmsMPEuN7LG43UuRK/uKkt2mwBWwfoiE5nnbXw3qXUC5h0nybKw=
X-Google-Smtp-Source: AGHT+IGkT/vleDHQ8M3Hw8Ha2+EPGBpXcHS4Q/PdXfOEbEN6KEGRSFgIDbBBEJ7VgYq4tyZ3FLhGBg==
X-Received: by 2002:a05:6a00:3cd1:b0:71e:64fe:965f with SMTP id d2e1a72fcca58-72413350e9cmr19827356b3a.20.1731368936369;
        Mon, 11 Nov 2024 15:48:56 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724078a7ee9sm10046057b3a.64.2024.11.11.15.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 15:48:55 -0800 (PST)
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
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/16] mm/truncate: add folio_unmap_invalidate() helper
Date: Mon, 11 Nov 2024 16:37:33 -0700
Message-ID: <20241111234842.2024180-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241111234842.2024180-1-axboe@kernel.dk>
References: <20241111234842.2024180-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a folio_unmap_invalidate() helper, which unmaps and invalidates a
given folio. The caller must already have locked the folio. Use this
new helper in invalidate_inode_pages2_range(), rather than duplicate
the code there.

In preparation for using this elsewhere as well, have it take a gfp_t
mask rather than assume GFP_KERNEL is the right choice. This bubbles
back to invalidate_complete_folio2() as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/pagemap.h |  2 ++
 mm/truncate.c           | 33 ++++++++++++++++++++-------------
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 8afacb7520d4..d55bf995bd9e 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -34,6 +34,8 @@ int kiocb_invalidate_pages(struct kiocb *iocb, size_t count);
 void kiocb_invalidate_post_direct_write(struct kiocb *iocb, size_t count);
 int filemap_invalidate_pages(struct address_space *mapping,
 			     loff_t pos, loff_t end, bool nowait);
+int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
+			   gfp_t gfp);
 
 int write_inode_now(struct inode *, int sync);
 int filemap_fdatawrite(struct address_space *);
diff --git a/mm/truncate.c b/mm/truncate.c
index 0668cd340a46..5663c3f1d548 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -547,12 +547,12 @@ EXPORT_SYMBOL(invalidate_mapping_pages);
  * sitting in the folio_add_lru() caches.
  */
 static int invalidate_complete_folio2(struct address_space *mapping,
-					struct folio *folio)
+				      struct folio *folio, gfp_t gfp_mask)
 {
 	if (folio->mapping != mapping)
 		return 0;
 
-	if (!filemap_release_folio(folio, GFP_KERNEL))
+	if (!filemap_release_folio(folio, gfp_mask))
 		return 0;
 
 	spin_lock(&mapping->host->i_lock);
@@ -584,6 +584,23 @@ static int folio_launder(struct address_space *mapping, struct folio *folio)
 	return mapping->a_ops->launder_folio(folio);
 }
 
+int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
+			   gfp_t gfp)
+{
+	int ret;
+
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+
+	if (folio_mapped(folio))
+		unmap_mapping_folio(folio);
+	BUG_ON(folio_mapped(folio));
+
+	ret = folio_launder(mapping, folio);
+	if (!ret && !invalidate_complete_folio2(mapping, folio, gfp))
+		return -EBUSY;
+	return ret;
+}
+
 /**
  * invalidate_inode_pages2_range - remove range of pages from an address_space
  * @mapping: the address_space
@@ -641,18 +658,8 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 				folio_unlock(folio);
 				continue;
 			}
-			VM_BUG_ON_FOLIO(!folio_contains(folio, indices[i]), folio);
 			folio_wait_writeback(folio);
-
-			if (folio_mapped(folio))
-				unmap_mapping_folio(folio);
-			BUG_ON(folio_mapped(folio));
-
-			ret2 = folio_launder(mapping, folio);
-			if (ret2 == 0) {
-				if (!invalidate_complete_folio2(mapping, folio))
-					ret2 = -EBUSY;
-			}
+			ret2 = folio_unmap_invalidate(mapping, folio, GFP_KERNEL);
 			if (ret2 < 0)
 				ret = ret2;
 			folio_unlock(folio);
-- 
2.45.2

