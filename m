Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFEB15CD74
	for <linux-xfs@vger.kernel.org>; Thu,  9 Oct 2025 12:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760011817; cv=none; b=aqWc1es5DncUah1P/AqVhhLQ794ImxnWRqEkorFJG6h6orrub3dRI1WgzRKKBQOShXbmmMWAnFpEMRPqRKLASXDjor8WUktmv3MlOEVE2F0KBRsp9YAt0woJDu+jJzvfEUlSkCO/vDui1q7NC1W2wpaZLOEC8KujB0PmAtMDLaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760011817; c=relaxed/simple;
	bh=yx7g7/W9Lf5JnZwQYWcEEVEDgcQBzE4NbBC6GYPGV2I=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TLQcJkCw+lC+s/fCg7W5WQyvCeju+EOLJmd7Px1xH4tF/S8nN5GqaspejRZAUuYMW53tyiNcDFEu39VNCRvoMdqk22EAqXr+n4CdKT0KEgWu7G3Ggwex05dt9AJCnfpUkSHvz8MX7oUiDEEbbmQ7Ge6v4PruV1jspnS83wSKuj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YPk3sutd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YPk3sutd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760011814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mAYQIc1TWplmsDz5f8tb14Cs1Pa97KHsoASQjLVr/P0=;
	b=YPk3sutd8NG2ZzVwiLGecn/MidK4kb9lZf0vamRTgEfLY/52UGmCxbpWbRaaZC/3L1XLv4
	M0sRm1eYw//uPrHBBHnEr9m5QECsX0zEa/yZZpCcNIz9vTtiZIIts2dfxl0QPGYg6RNdza
	SP4DCSLnk8JQ2GLXDqn+dH09FUqHNtE=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-cwfK7huTOnGFWtU6yizIvQ-1; Thu, 09 Oct 2025 08:10:13 -0400
X-MC-Unique: cwfK7huTOnGFWtU6yizIvQ-1
X-Mimecast-MFC-AGG-ID: cwfK7huTOnGFWtU6yizIvQ_1760011812
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-36b57abe6d0so4884831fa.3
        for <linux-xfs@vger.kernel.org>; Thu, 09 Oct 2025 05:10:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760011812; x=1760616612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mAYQIc1TWplmsDz5f8tb14Cs1Pa97KHsoASQjLVr/P0=;
        b=JtqMhKFqpfIYGnBXJFjkFl98YFX43lkzoytylcHMGRLS98zDUQ8CPavs8cLlzGUm82
         +YLytodRPiIHAwfMJXRq0RwppOy6ZazGekrP3My+B6PsDWkE3CN9CIcf6EJ532lCqua4
         rFpu4qgMKBrBgVxSyJH3cwlK1NlJuOLK8VoWmcFu7DovPx0DZMRZlmF/6qcEozVBQANc
         PXzEJDcZdF2vGeldDOQ31oKGkkWQ5H8aLGycGacq1obdauC1I9wWmSEbQphE6s8jSIbf
         OwBGyHQDXx/M81QyFztk8e8x/3CzuSw4SkkdGxXxBRBFWe6x6ZznQdF+B9LOlGjb7MK5
         sWGA==
X-Gm-Message-State: AOJu0YxZoOPCc6fKaqiyqHADi89ajE+X+EGxx9o4miBN+dzroekMrh+S
	nrmWLyPqSkeqlEOGalaFaGi4/1/mIEyCH/Jzrm28pqyR1hluc3c7GQBEW6pZbZlw0MijyK9JjVA
	77d62faeiSypmwQshjV4Ue13aY6bKMt4/llwoicWswyBctSXn2tEO7h5xmgOptcgOS5MnHcWM0/
	N1Q05vSQ1k0o/qB0L9JnB8HIIU7t/4dXO3N9mULmVa6GZT
X-Gm-Gg: ASbGncsfTC2OG2BnCrDkftt8dtnL1elrUGzZfDNCcO2KO5xafGaqO2aCa0oT3tC6jhC
	UXakZCzUBIA/zWkd9VFT8BcKUab4rFhlWE/qLPsNj6swswqI0qjQDTJvrvgEmj9vDsgsJkfXlr2
	Vl4I1ZpzYraie0d8QXtEqWAtPOIBfEz6Dep+Vc4202RQ71Xw5iVpr7gtkEV1/axy5GdFjmGi6aw
	f1o/k4lMgnyxHCbs3Y54JDWhEw96lSCG8ogmwDzXN3fyj8VQbLTk3Yrucq6UHLwA7YZsK9sRTSj
	93SpXTJyZxPTow/RcrmpJF+NcgH6pe2fRHwRBylz+NJOxbeqw7lwDL3KTstMdrZu2juEwXMw
X-Received: by 2002:a05:6512:1329:b0:57c:2474:3722 with SMTP id 2adb3069b0e04-5906dd6bd22mr1887656e87.40.1760011811712;
        Thu, 09 Oct 2025 05:10:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF/ACroz1QdKXMesn6c6kvamoRrhcvhy72zzlN5UViQPck3VrEYKLFr6vg2rPGq9R9QZcoCvw==
X-Received: by 2002:a05:6512:1329:b0:57c:2474:3722 with SMTP id 2adb3069b0e04-5906dd6bd22mr1887639e87.40.1760011811177;
        Thu, 09 Oct 2025 05:10:11 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5907adb2829sm982219e87.99.2025.10.09.05.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 05:10:10 -0700 (PDT)
From: Pranav Tyagi <aalbersh@redhat.com>
X-Google-Original-From: Pranav Tyagi <pranav.tyagi03@gmail.com>
Date: Thu, 9 Oct 2025 14:10:09 +0200
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, pchelkin@ispras.ru, 
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [PATCH v2 9/11] fs/xfs: replace strncpy with memtostr_pad()
Message-ID: <g2fe3ykh2zmvf6c2yf6ulqsvebe3ctfjahydeg5zpurrmkv4wz@tvvqurwmbiop>
References: <cover.1760011614.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1760011614.patch-series@thinky>

Source kernel commit: f4a3f01e8e451fb3cb444a95a59964f4bc746902

Replace the deprecated strncpy() with memtostr_pad(). This also avoids
the need for separate zeroing using memset(). Mark sb_fname buffer with
__nonstring as its size is XFSLABEL_MAX and so no terminating NULL for
sb_fname.

Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/metadump.c           | 2 +-
 include/platform_defs.h | 6 ++++++
 libxfs/xfs_format.h     | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 34f2d61700..24eb99da17 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2989,7 +2989,7 @@
 		if (metadump.obfuscate) {
 			struct xfs_sb *sb = iocur_top->data;
 			memset(sb->sb_fname, 'L',
-			       min(strlen(sb->sb_fname), sizeof(sb->sb_fname)));
+			       strnlen(sb->sb_fname, sizeof(sb->sb_fname)));
 			iocur_top->need_crc = 1;
 		}
 		if (write_buf(iocur_top))
diff --git a/include/platform_defs.h b/include/platform_defs.h
index fa66551d99..7b4a1a6255 100644
--- a/include/platform_defs.h
+++ b/include/platform_defs.h
@@ -296,4 +296,10 @@
 
 #define cmp_int(l, r)		((l > r) - (l < r))
 
+#if __has_attribute(__nonstring__)
+# define __nonstring                    __attribute__((__nonstring__))
+#else
+# define __nonstring
+#endif
+
 #endif	/* __XFS_PLATFORM_DEFS_H__ */
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 9566a76233..779dac59b1 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -112,7 +112,7 @@
 	uint16_t	sb_sectsize;	/* volume sector size, bytes */
 	uint16_t	sb_inodesize;	/* inode size, bytes */
 	uint16_t	sb_inopblock;	/* inodes per block */
-	char		sb_fname[XFSLABEL_MAX]; /* file system name */
+	char		sb_fname[XFSLABEL_MAX] __nonstring; /* file system name */
 	uint8_t		sb_blocklog;	/* log2 of sb_blocksize */
 	uint8_t		sb_sectlog;	/* log2 of sb_sectsize */
 	uint8_t		sb_inodelog;	/* log2 of sb_inodesize */

-- 
- Andrey

