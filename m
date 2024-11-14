Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB13016BE3A
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 15:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731598088; cv=none; b=ENBzR5h0Sh65/ZG9qDi1QI31pxN0LClBBw6timgFwk3zjovl7HbW+3oJ9/vnQ54s/V+/PGxarauFa0OexiIbp3KX81cURhzfasMXExeL+MAgV6m0yNQO4pWE2Bzgh2WWhqKp/EdoqYVPZm4k/wPzX+T+Jq+x4yZZj8z80UHmzo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731598088; c=relaxed/simple;
	bh=klEANlDo0QcivFe1NIYDNiOFa1lRCa2wf9JjLv/2My8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKsefGbFy3sxyWmhLpvoO/5hQVsjTCy8CL5kz81NCDuLyiEPjRxKY1/I5a+40kJBOoHaghtq7VK6BfdN+RpQdj1gFw+G3RJzcjUkm9pI9FBSJalO2nRE6cXZGkYClCtqJCMrA/rhmvtBbJ4jEvfSuWbcMcLUgN7LQaHXG17MJlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KoxCnn/F; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KoxCnn/F"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5ebc05007daso325398eaf.1
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 07:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731598086; x=1732202886; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9QDQ8u+XOjRX6rdX1KxWEpFxXqQ9HPCp5iTXnKjwIis=;
        b=KoxCnn/FfZycku2PMA2bkOnRGL+7wMjFuUNW399IDi7AkgoaONHvIcoqxIm4Mc618f
         n+G2NlDxEQyTBhHyTF1Q7icxPcS2tk6UMfe1IJ5BoLwNdx8zT+6d2TvipJAMQ91PT2by
         5PmpYJyfO790CzxMQMtRgHw0GKGF90BzFMMuLRj55vzXkeaXrCSz3NBUbHcIp6AMikoC
         wVcwvVgAfmZV/vOeQx+NFcy1y3JIBsqKElVuysSQV3shkBRrrmAGt3+SiD8d45XaAIAJ
         5xLmUmtMTlQWn8fnHj4rR4HIUCF4yCCKqzxBUy9N42SWgTb+nWXuaFowTV5FelV/QNKL
         6Stg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731598086; x=1732202886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9QDQ8u+XOjRX6rdX1KxWEpFxXqQ9HPCp5iTXnKjwIis=;
        b=SQtyvK1kFSJdgy30aWpV+snDsz4FKvZTwTXUjVy8ZTNwq0AMngBIgzpSOc1tAKtKtj
         kj5HQnELto2kn6nQMV5mSiucwpbP0PogYLJIeW6kLeONujevEdz3FTd0ewmWb/ewX1dQ
         ZJOtv9mPnBWscW8RZiXPZyh5q0VHQDdPF8MFM16MOVDNwRB6ayLtAzL6xnoYjrShvAm7
         Fp2SaRu+CsogRoEkFvabKPPKSh2wsLtUH9TFYO9H+JrHmPooECaXYx9S3ABl64wfIczg
         JQez86V26f0TK+AfwOzmrjglhRHSbGGdUxHYDAfGEvq6b1oOMCaw0rdYHCCjXh1PLrqP
         E5pQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrBO72QVL/eu0PRYTS9e5SEEw91Ed8sqrAUaLZr1ih148pgWcGqSEsXUmN+7FP6Z7UniLLeHdi+KQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEPrpXkMKl+wp6OgwD67ehzwcTO7J89GKJHMwf7UH1j8ICI37p
	AzZzUXir+T6hWnZEl4njrQufzb9xyiCUYdD4ENtkoKDglBNglNX5muTMsN29Ito=
X-Google-Smtp-Source: AGHT+IHYfzNU9jsYZVqq6BubIUmPINzkrBJpOzUKZ5nbA/vQYGCWpQqOD4e90GxHDczr5rmeIPTulQ==
X-Received: by 2002:a05:6820:3088:b0:5e5:7086:ebe8 with SMTP id 006d021491bc7-5ee91feb02cmr6995384eaf.0.1731598085665;
        Thu, 14 Nov 2024 07:28:05 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5eea026eb41sm368250eaf.39.2024.11.14.07.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 07:28:05 -0800 (PST)
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
Subject: [PATCH 03/17] mm: add PG_uncached page flag
Date: Thu, 14 Nov 2024 08:25:07 -0700
Message-ID: <20241114152743.2381672-5-axboe@kernel.dk>
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

