Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2211C3F00
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 23:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731368933; cv=none; b=dN8m+BxoXDunik2Vq+CyE0y/p5APt0dFNBLwdkZtcTmLya4FhdSHXZgiKJawa+nn4KWINGd5ddADpdctbDlJKAC/2Fp9trn4HJuOHCj2Nc6p9W5dqY3sKfOpGqWsiclqrwsf6tEfdhV9TWA555T1pyNDhMuq16iKSCE5P88380c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731368933; c=relaxed/simple;
	bh=klEANlDo0QcivFe1NIYDNiOFa1lRCa2wf9JjLv/2My8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C43zazE0Wp7vSnBXFvYxgg6+2YrrhTPebU6R1oQvzWCc8S9cJfkDpKI36WbtwuuNP1YhEY0JVLR/qXhzPeArH2IHlX9AKt7Xf/Wn3sEfTuUdDvPXcA8pqzt1nP4xqH68awY3whonwq4/WTPcAyu3m9gqQ0fLjvQE3PBzRhbgxl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XyRfUh6B; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XyRfUh6B"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7240fa50694so3694655b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 15:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731368932; x=1731973732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9QDQ8u+XOjRX6rdX1KxWEpFxXqQ9HPCp5iTXnKjwIis=;
        b=XyRfUh6BYtZ2g14d7GAGy9wrJQ5P9sCjQKhoDrSVSCjvCANbFguvc/B9iUzDuFcGSZ
         0y1w5OnNvFsV7kTfG3zQFD9LNW8T1CKqN0UAzcSDyo4LFB/a6uXK7MDRih87Dp6LFIoW
         L0bjq0y7i6QPyIEpJ2hI/kzFkLJv8rz8l8V7WzWZqC+W9ecB0XKyA0Tj0UR303WAe2bu
         IXPnq/ZSCQHjNr+zuA7INYMMu7ZQH8x0/DZgB633RbzUNJAuJhQ1nRA3jeq0OtevjsSJ
         kpmSt6FHnrVV5DpS+nMnvASBxUrrZPwasuVxZgayILUGIUnXHVHYECS0QrLntiGFmcBN
         H9tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731368932; x=1731973732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9QDQ8u+XOjRX6rdX1KxWEpFxXqQ9HPCp5iTXnKjwIis=;
        b=aq8ngiqRD/MNVd7LFoiJXgwVffHCffmaknJoXmrRj6HLEVTrHDwnH2tTFmo0Mj8cF8
         gC09iBXEh0ydskQw8CT9uvLO88OBGDVAXGYg1GfjRTF27kycoWmJt8Y9jdSvnZx1Omj6
         j/lRfJQyv9bMOZtQ6fZ5jBWHi44hxJxM1gkbQWllrXEPeKo4nDHW90hARLlhXgyiwql8
         L+j0YbPhCGFhQisxTmO7aa3mWU8W3bLG8yL4zo0qDhvcCTUCRk6LdcwMql6kLDuZ8DlG
         julq9okQeDjGuZUgMN2ymjfxhy/HCzGVZv9jD9CeJmtH5HLEX8NdKK/Aj/Jda/VZyYQb
         A4qA==
X-Forwarded-Encrypted: i=1; AJvYcCWcXAGfk52XtR26NXTrniHyYq0T0PUe8Qbb9k3lTqPM2LhplHGAu507YCK04jiz5HNCYwiOCXfwnoI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxY4BRD9rFGTPAzbZSJPAJ5NTLCt2yinzMtVz2DJD1yEwSyRPVT
	3te1IyDQuQ7vTFgHK0iWZrSfRbqdJdB1BFX+GsIXG44F7syBA01RMKlpNhdvXnw=
X-Google-Smtp-Source: AGHT+IH9/1Olbxn3KTdIUuB7+y6iPc85Xc8pyUcg5cMVAU1yzHvt71d7cxX7HqTkOKWntgPA3yDsaw==
X-Received: by 2002:a05:6a00:2e99:b0:71e:4ee1:6d79 with SMTP id d2e1a72fcca58-724132749f9mr20118106b3a.2.1731368931568;
        Mon, 11 Nov 2024 15:48:51 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724078a7ee9sm10046057b3a.64.2024.11.11.15.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 15:48:50 -0800 (PST)
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
Subject: [PATCH 03/16] mm: add PG_uncached page flag
Date: Mon, 11 Nov 2024 16:37:30 -0700
Message-ID: <20241111234842.2024180-4-axboe@kernel.dk>
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

Add a page flag that file IO can use to indicate that the IO being done
is uncached, as in it should not persist in the page cache after the IO
has been completed.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/page-flags.h     | 5 +++++
 include/trace/events/mmflags.h | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index cc839e4365c1..3c4003495929 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -110,6 +110,7 @@ enum pageflags {
 	PG_reclaim,		/* To be reclaimed asap */
 	PG_swapbacked,		/* Page is backed by RAM/swap */
 	PG_unevictable,		/* Page is "unevictable"  */
+	PG_uncached,		/* uncached read/write IO */
 #ifdef CONFIG_MMU
 	PG_mlocked,		/* Page is vma mlocked */
 #endif
@@ -562,6 +563,10 @@ PAGEFLAG(Reclaim, reclaim, PF_NO_TAIL)
 FOLIO_FLAG(readahead, FOLIO_HEAD_PAGE)
 	FOLIO_TEST_CLEAR_FLAG(readahead, FOLIO_HEAD_PAGE)
 
+FOLIO_FLAG(uncached, FOLIO_HEAD_PAGE)
+	FOLIO_TEST_CLEAR_FLAG(uncached, FOLIO_HEAD_PAGE)
+	__FOLIO_SET_FLAG(uncached, FOLIO_HEAD_PAGE)
+
 #ifdef CONFIG_HIGHMEM
 /*
  * Must use a macro here due to header dependency issues. page_zone() is not
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index bb8a59c6caa2..b60057284102 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -116,7 +116,8 @@
 	DEF_PAGEFLAG_NAME(head),					\
 	DEF_PAGEFLAG_NAME(reclaim),					\
 	DEF_PAGEFLAG_NAME(swapbacked),					\
-	DEF_PAGEFLAG_NAME(unevictable)					\
+	DEF_PAGEFLAG_NAME(unevictable),					\
+	DEF_PAGEFLAG_NAME(uncached)					\
 IF_HAVE_PG_MLOCK(mlocked)						\
 IF_HAVE_PG_HWPOISON(hwpoison)						\
 IF_HAVE_PG_IDLE(idle)							\
-- 
2.45.2

