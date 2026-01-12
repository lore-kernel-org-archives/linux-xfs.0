Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0362D061C
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229492; cv=none; b=Sy7l7JwJSL0rgFlIeWZlLOb6O4b/cXhbyHoZLVpSSOmbovcDrV8DrYQ9BWCPA8yivcSTEElPzWwgx9fyxDXO4B30EhYWrY3Or26oybVAJQ/KZYw+Ypn6kAw03vxle4n5kSghVTLnl1QLMDeqTjQtZhBgm47L76WlJOuIC3hVkTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229492; c=relaxed/simple;
	bh=G0tanH7Ti+k9Untiwo28pq9nTnDMDuydjlfNBKCMaYI=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RKYM9x65NWHQbCu8r3SPyZfBDvvCpAXQJnvR06vWP718pZgruAbyL+u7EKTs4vFzs0RaijlR8lGdxCHDbMqjX/38yEZAY1J0OZf7t/rYT/cRjXRMjqGXuCxQQ/QQnXdO8BoBfa4tMR0WiiwTF7NVaN8liQizL8kZvbR65waEpMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EejVCpM1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rAx8cLJa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EejVCpM1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rAx8cLJa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768229490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dq6aVc2SBP1ULPYVZkGBkgSZtTVfOp/X5bD2Y/FWtBU=;
	b=EejVCpM1DttRCo0lZI0vjL6p+0uFBgNOi9CJaIsh1Z4UssWd+A6e9WQYOnH5agRsa4hyBg
	mfH2HD4kEsumju5f47rWYfIkk3fSPuSevH+DNk+rKKPFbhPNWPWPYgcEar+C5KH7KkHHjg
	EJcMzXPjvQydun3F29LJpIZQDtdK3Iw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-c-gqLe9UMJacU2iZGeTDWg-1; Mon, 12 Jan 2026 09:51:28 -0500
X-MC-Unique: c-gqLe9UMJacU2iZGeTDWg-1
X-Mimecast-MFC-AGG-ID: c-gqLe9UMJacU2iZGeTDWg_1768229487
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-64ba13b492aso8033687a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768229487; x=1768834287; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dq6aVc2SBP1ULPYVZkGBkgSZtTVfOp/X5bD2Y/FWtBU=;
        b=rAx8cLJavccIY1kk9PRM9Lb6TuVaQ6b+Tgqe5vFOEO2U3jmA5WV3mSnrZFQnmudnaC
         DrLnlH7lTLVRMn797BBtcDdIcUOe7jjQmhAYKEd1sDF1Gue5rkshxAMUGacTL3Xbv7Xu
         biZUExEatzFJl4Yno+uiY6hl6OBuKOW4V/RnJkfw+NcZsFKrhNX6G0LBeZTbs3fWwSxt
         BTjf827KfkH3/Oi9JmFzLtpqEX0ovlLCDc4yD2ooHfhZkJo51g0RhMAmJERTF6ePioLc
         rJfnrTiFY6YVQ6mh1CqsOXmDYhvShAMnbZI26uvOSas6ZOrZnWa9ZL2aVGr6j3//Rj5c
         Bt6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229487; x=1768834287;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dq6aVc2SBP1ULPYVZkGBkgSZtTVfOp/X5bD2Y/FWtBU=;
        b=YvEjHSL6YbdVvCIYJyqaoKnYJSlZ+8OqHv8p5FeelXCNdCmUSNWOpTiH1tZ3GUawYN
         BGEpFBArBLhwcYyg5FLrmNrGVhEVdIo1DIo85vBOTBlOAxbzP7JcRDZ4Hmc8Sccw5i3y
         N+TdgDjygznMhP4bRw1rLxokbKJxICAgsszsuTDV/p5fe2cZJ3vdgcsJU30D2UPwNRZl
         1dh6ZmSlUyQI/Cde8zrzqBdK6oM0+uclWFJ6EzwOhwg1CL7a/SsV3mbq9upQKXhZDASI
         LYaE7Seh+rA1YuibaFXTGakVBZFWRP+E75ATpyUo+sYZ6Qr0u/NJPA51CTlFpmYHmoDl
         ztAQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+1fT8VDzaSnkdd4qZVNk/UVI0i+hX725Rma0RaAmrkJroaPsef8EldfnF7lwOjCf7tt3EVPv6Scg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl1sP/R3udq7O5We5YX6Qk9bh0KIML9qMxfWM9JMyPyH0zlGC5
	dI7EH5Vd2Lrh21vIf7dKJuHwGR9M8xB08JmkH36FWcc8R6/tqqcw2EHO3V3umxCFfD/PdsOxjji
	fA3Kql8m/KMpGLY0C3sdLAdNBynme48QzbiBWZ+GJ6+jLRFa5HAhutUrdcbdG8mDsC/J8
X-Gm-Gg: AY/fxX4oabPAld/kJwsbUakKGs1PWm1djE5sL5cUsvfmCWd5hXAHGO7aBSsngPdpoXU
	10p5Nx3TZfUV19rz5kENwflmtFbkh7eciGAozoiBoyrEB+U0vXg/5CoUa8zoZNc148R0/eODYP7
	/dtbtidh8xwJHuiWDFjhp9p9b9+RDm2sj37QQJ2GIz/otfGuoSnG9urbaxbEePzgT3sDhYlOOgL
	V8McBHvHXxInYLN79RqC+ajHN16Nm7ooESp/6sr3MHYhNTqUzAdck8ubcU1Xj6Clnv+ze7IR8r+
	KSXg6EkoaXiBCuPJSZCvsV7jmus2vxLoy2cghwkzexcOv44tqvJhvb/JCFXMhgl1o0VbYQESvgs
	=
X-Received: by 2002:a05:6402:358f:b0:651:1107:d3cb with SMTP id 4fb4d7f45d1cf-6511107d7acmr3282592a12.24.1768229487183;
        Mon, 12 Jan 2026 06:51:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHfxvOxfxzdEBvJzPLysHOh9QzRSHooaY9jamBd0ngvYg8b3UMPNPIM3r/hBbc0eI3X4Vj7fQ==
X-Received: by 2002:a05:6402:358f:b0:651:1107:d3cb with SMTP id 4fb4d7f45d1cf-6511107d7acmr3282573a12.24.1768229486750;
        Mon, 12 Jan 2026 06:51:26 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507b9d4c0asm17933810a12.9.2026.01.12.06.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:51:26 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 12 Jan 2026 15:51:25 +0100
To: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	aalbersh@redhat.com, djwong@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v2 13/22] xfs: introduce XFS_FSVERITY_REGION_START constant
Message-ID: <qwtd222f5dtszwvacl5ywnommg2xftdtunco2eq4sni4pyyps7@ritrh57jm2eg>
References: <cover.1768229271.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1768229271.patch-series@thinky>

This constant defines location of fsverity metadata in page cache of
an inode.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 12463ba766..b73458a7c2 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -1106,4 +1106,26 @@
 #define BBTOB(bbs)	((bbs) << BBSHIFT)
 #endif
 
+/* Merkle tree location in page cache. We take memory region from the inode's
+ * address space for Merkle tree.
+ *
+ * At maximum of 8 levels with 128 hashes per block (32 bytes SHA-256) maximum
+ * tree size is ((128^8 − 1)/(128 − 1)) = 567*10^12 blocks. This should fit in 53
+ * bits address space.
+ *
+ * At this Merkle tree size we can cover 295EB large file. This is much larger
+ * than the currently supported file size.
+ *
+ * For sha512 the largest file we can cover ends at 1 << 50 offset, this is also
+ * good.
+ *
+ * The metadata is stored on disk as follows:
+ *
+ *	[merkle tree...][descriptor.............desc_size]
+ *	^ (1 << 53)     ^ (block border)                 ^ (end of the block)
+ *	                ^--------------------------------^
+ *	                Can be FS_VERITY_MAX_DESCRIPTOR_SIZE
+ */
+#define XFS_FSVERITY_REGION_START (1ULL << 53)
+
 #endif	/* __XFS_FS_H__ */

-- 
- Andrey

