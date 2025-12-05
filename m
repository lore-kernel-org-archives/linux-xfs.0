Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF8C33F8A2
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764947036; cv=none; b=OJfM3Rre/63Bx1Yl8HUaBmkACCSUzBue8+KdzBYddabGi043/66Sh3DkSdgUWjtykoPFg64lRk4JwolNYhGVGKzRJo4+THSrFwvc3wSrwZBh842BUXE0JqffxnpvSL1RQfspYSE0dq0kA6yEATn9SUsF8/Lvzt3flrEYuTUBQjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764947036; c=relaxed/simple;
	bh=GPDgXKkJpi9rXNEWM7i9Vv+v1poCd4BYTROtMkE7CVs=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sYPWeK60FQA7NHTptMmLMDpGmOfI4VnuqI9JkVEqiH3nw939GmpJ5BUntc/cjblOpXJogKqTU4lvsdCgctozM7DF/LCCQsZLw6xOQ94Kd1X06uRR4M++hlktLwEqBGJT+59O0+pw5Upf/3kTZWUVk7nMmWmAOIH8GJJ2M5yS3eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ac6JxguD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ONL+Dyr9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ac6JxguD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ONL+Dyr9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764947031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=queUjvHSXB3jMj1qYR2PSxNWe6TDDCpr5jIvFlenfTE=;
	b=Ac6JxguDY/KQORDSOa6UWN/mH23/z6aTedn9Hg89TyqwljpgcG0EkZLP5q9OYVh631KoT8
	fDU2eAbw2MZpqZifNSJqvMDe9NcY6ygRWt6Ccp4q02b1AH0WkyMdAO4M3tufQYaPkaJ9Ky
	kPPspV4TX8afGk427AKrbBfQv6YXurw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-sS2hGmbfOFqTShE2A1Ye6g-1; Fri, 05 Dec 2025 10:03:50 -0500
X-MC-Unique: sS2hGmbfOFqTShE2A1Ye6g-1
X-Mimecast-MFC-AGG-ID: sS2hGmbfOFqTShE2A1Ye6g_1764947029
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4779edba8f3so13777485e9.3
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764947029; x=1765551829; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=queUjvHSXB3jMj1qYR2PSxNWe6TDDCpr5jIvFlenfTE=;
        b=ONL+Dyr92BUT6cFkoT6WVCnuSzKfBsetT8j1EH2xdNhVZWel1yji6LjIpgQvDS4E9I
         PEnU8aaNW2bYeUqit2opbv5jLFgunGl2rqr3l8+vkvvIGHQbqH0Ryd35/e+VsmSD2iqz
         SxMDIe/NZO+Xr4nlkkXga2PrRS35x8iddICKHuI272wL2ItEaFeCIQQEH2G0l7yWWMGh
         3AJwPkv1sKHBacEnyGhgvNa805IyDvtcUyn8a0SU1RdcTMrZ8at5YV7a9SnA6MHs82yw
         ZTk60340R9QzWT7qKfs7pcQ+CJPj+ULgZxmOw3X6KtyaM1sEZfFdOp/5f5LXJZOpfy9X
         B1tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764947029; x=1765551829;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=queUjvHSXB3jMj1qYR2PSxNWe6TDDCpr5jIvFlenfTE=;
        b=LksulOCoqszT98wpri8G1hvDStAWbZbvvJu+nAA7sINxLVNR9wjCVkhjJ/NxheyEhK
         79vCzKCkPXyZT2tsBlKqJEcjS/qOLhnq1SZX27TJsrC5GWypGwELqGyfpcstsGn2/jSM
         M0eqp23UArFL8Xk8B5WrbxL7/lQ0A7687ttySQLjta22F1ZSIxF8h8rZ9IlCRzVMKdaS
         pfyFCf3JtJtyUnZ2dWInUv0BCmeyC//e/DgF4VYceXmaoeiiQFCsqTpQRx1yvhLDXHTy
         7K2dElPIalIY3zv5a2jO4E5KbCk0WI/B32qlE8+fFcQ9n4YkEPEVAyrUZ7MH5brNGAHZ
         59og==
X-Gm-Message-State: AOJu0YwXQor26GFdi6Fw275HtSoCg+DkmW3TQj0IfS/6cOwKktL1S7Vk
	YYtDp7vrH/Esg2eAiCifUbhAkMr8z2CkEYQTSQSLidY6WpubxSFO+AQVwIF2n+VGgbJVLogiJav
	YOaQi4JUw4F859J3MzK/Zfkj0h2ymiL7jFMHzBB5lZom8SSsMPeIStXFBKvfH+ap2z7rPLz+Ogh
	je4QXb/cOD3NiPeMk1TAzQkjrMCPivjrQfyc6oiAM9tywS
X-Gm-Gg: ASbGncuOFWZ/uB+N+LwVQ/G5GY3XRhl57TKK6Iy80HSqYnU5Vbe/AuOoK9u14Ng0oCY
	7hlbrn2eDFG0XrMzhOdneGFWwiya20YBfT8xg4hZwRmVRPfteafSjcY2fIMamqX4WyXVSvWxSWp
	OrfJuTLHFMxP3BDos8F5dNDI8V4VGdrDWkJJEokIP8lAr/YcxuXfI/CNM2DABtYjyd6J8cWY/tx
	qUXCGJPsee4ZR1YWWbyfYLBFkebvb633++eFRmUTfQgvFjRhJyfxRz17zuVZEpbBmmwAN7aaLSM
	+qTEyjyVhiFmQt4ZfErakj4B/J6jsz/krfOpyGxDAk3kgBwwT8i0/v2V0NZX4ByhMgCPbIHSn8I
	=
X-Received: by 2002:a05:600c:458d:b0:479:2a09:9262 with SMTP id 5b1f17b1804b1-4792aeea47amr90799785e9.9.1764947028841;
        Fri, 05 Dec 2025 07:03:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEw4a8VLtGaQ3HeXcyJmi45pT2OOXURv56Hm+dMFBZCbx/MCWqvO37LSQY9FAKLOE/5zHXUCg==
X-Received: by 2002:a05:600c:458d:b0:479:2a09:9262 with SMTP id 5b1f17b1804b1-4792aeea47amr90799065e9.9.1764947028140;
        Fri, 05 Dec 2025 07:03:48 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792b02e7fbsm59965555e9.2.2025.12.05.07.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:03:47 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:03:46 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 28/33] xfs: remove the unused xfs_log_iovec_t typedef
Message-ID: <axnx77pgahd5744xxw7h7ii2d4ysam2tkmj3nkjinqd353qomd@lj5dasskunrz>
References: <cover.1764946339.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764946339.patch-series@thinky>

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 3e5bdfe48e1f159de7ca3b23a6afa6c10f2a9ad2

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 49c4a33166..a42a832117 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -194,12 +194,11 @@
 } xlog_in_core_2_t;
 
 /* not an on-disk structure, but needed by log recovery in userspace */
-typedef struct xfs_log_iovec {
+struct xfs_log_iovec {
 	void		*i_addr;	/* beginning address of region */
 	int		i_len;		/* length in bytes of region */
 	uint		i_type;		/* type of region */
-} xfs_log_iovec_t;
-
+};
 
 /*
  * Transaction Header definitions.

-- 
- Andrey

