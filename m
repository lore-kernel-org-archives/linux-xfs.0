Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086973254A0
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788838; cv=none; b=T15liZ7drFkZx9jBzDqBEbjYdwO1Yx1SrrBTlK8oWbvQ0K3lb2O8iLv1+vLedoYLs7l3pOlpxHfjWVsVR61fy5wa4KTHp1EzyV78YohLQnjtWWwvHBWlXIPp61iW2fcch/Q9mTAgmNNuSsEFdnoDvxmg4vSH+VZw7J9scA8a2pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788838; c=relaxed/simple;
	bh=V8pj4WdR7NwKIHGw6Yw/D8fPiPQHyxAG60nKVBqSTUQ=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uq8SRVr8MwjbXxPVUTSpzlKdeb8gfNEhQSWTyHJJHyzQUN5r/g8Cx22Vw3PNUYgKOaMYX4gbFlw/yB9CH5XrCN30wAxdS93UoAB3s2GxFCAuwj/jZEvR2RCeunjKCSoFSxlpeOlELC4QpBed2eYvp1BNX2XSRdP2BUt5ENsv/Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UXFSskln; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gCsEhXLi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UXFSskln";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gCsEhXLi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z0Jvh59CNfeKr17+KvGlm2pqM+qLb+GwH5O+86/O/XQ=;
	b=UXFSsklnbKHCJeciDA6oHSvoK6Nnq2nJ7CJLj5zANcb+PHP998wWIX7NHe7Ue1Hujl7kMz
	9l7+noGKHQNxbH6cR9x7ZUNLCulqfbku40q4uVO4xSRf9r/yW0VHiv1C/w9EuzioL3/tLt
	TIKa9CfARRLggr/NOdZcOkPRSoHY0vI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-2B2jkP1hNp6F9q5jBMCxXA-1; Wed, 03 Dec 2025 14:07:12 -0500
X-MC-Unique: 2B2jkP1hNp6F9q5jBMCxXA-1
X-Mimecast-MFC-AGG-ID: 2B2jkP1hNp6F9q5jBMCxXA_1764788831
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47921784b97so576265e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788831; x=1765393631; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z0Jvh59CNfeKr17+KvGlm2pqM+qLb+GwH5O+86/O/XQ=;
        b=gCsEhXLid0oUDrbOK/H7zRP+OhrNIzzXnJ8+i8VL2Ue30ONPdd4PISX82p9vtAIGPP
         YAnKsrJgAZqdgecwD/8MArFkBRHDI43RtNtHn7LSLo6Mf6UB7hc3gxX4wi5YbPjiMl2X
         GGNBgdOnDtbaARM2R6NRYPgxAF4cZjcEq/G/VUcaR8nWgsiNTO72oA+tXe7ouF/eYYNX
         8hGsV28W7kuqMrAsJ9mrQLfUVc3gauaMiRNGiKCucDYMAb7g/x+5nyhpu0b5NJdSdoPW
         FFdiN5UhHivNezOqRYTviDUyzInaxZjVAyXpaY0vG1+WTQz4Y0VHe3Qmrl2Ud1x7US60
         HZug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788831; x=1765393631;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z0Jvh59CNfeKr17+KvGlm2pqM+qLb+GwH5O+86/O/XQ=;
        b=NR9lKzPrprppFHsDPalhNVvKOEm0bdYT7ngaiXwA6ChFTc95+qlk4ju4+jN1Upx0cQ
         s0B72cEt1/IAeNjpej3XX7m0GpUL4yG6Z3/uexIfakv0L0E9yd+JvY7YfgDGPFmpC+yx
         s08bwyNAIiTbd/m6Q17T0Q7V6ab3qbJ+tS2aebUrRQa+nOY853wjrD0O+5TlK3jwhsfU
         qoapHjcCz2+/UPtSG5+Bbte/WHdRvw79Nl9rBcXGJhuriaK4aoX7Q8doxwE/us/RLQBn
         dAIROc980FJ+PDJsi1znLaRDHW9ZiMJ5nGGJm+n8ZN9d6WQR5hDQtfC4FiuBGEAoHtH3
         baVw==
X-Gm-Message-State: AOJu0YwOokmd8dONptWxVXxmXO1XGnMVVXELeOFaJdyq+zrpYovx+8DK
	aDWLziyvPK5PZNclRkICobopgO7rhkc+FYk1d0ZZLZoy6WjEBqsZYqInydXgYrw09gSFfaFNBnW
	6FKdwi0pSVb0w79t1EVPYK5NXGTl0n7j5JY+92WguGhRyI2gyevxWwBlefn+m/qe8UiA5pP0m7c
	PXj3RVhy+85NlXUuXu2ynOfknNl7M9UHNg4BKBVOJFHfhp
X-Gm-Gg: ASbGncvI5vCB3NmrgdkAo6ag6PnpRPR3lTO84I1KRSzQz3JBD/PNMA4SdZZQJKwhc2i
	0OYdRSwZ8jU3kSW9fs0rGzxzsLoozQmOB5aFuE4vortvOUZ9wKfBHv00tAO2EbtMhezRknRHVzt
	GAekW4B3PBHcN8NBXu2HRXQpLm4SJF7kTsKHYY3kqC3N+xvY+Hrz6Q4NjHR3fclrNwTWgjfBdU8
	Ip16e9DyDWRqq+fYhJeecb0kdScmpQ3Ry58mII/YZpyJOSmbuXcUi/sXiuoS70qC/Z6onwfTP/V
	u7fwcWaNl+QVe4MFfS8xqNmw920iQhUcWfm8xznFefXTBS6dKm8UoMaqJnEMwn+9pdTfFTOYfKM
	=
X-Received: by 2002:a05:600c:4f82:b0:477:1ae1:fa5d with SMTP id 5b1f17b1804b1-4792af1b2c3mr35982735e9.20.1764788830705;
        Wed, 03 Dec 2025 11:07:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFh/s3XukD6h2FfOTklKau8ClxlyP6vyt9m99yXuV/hMyBEtCsrBSff+5sVV7ckKPLCEFE27A==
X-Received: by 2002:a05:600c:4f82:b0:477:1ae1:fa5d with SMTP id 5b1f17b1804b1-4792af1b2c3mr35982345e9.20.1764788830231;
        Wed, 03 Dec 2025 11:07:10 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5c3016sm40463777f8f.1.2025.12.03.11.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:07:09 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:07:09 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 7/33] xfs: remove the xfs_extent64_t typedef
Message-ID: <rigrqcinvpwzvwnwoselsigod7m74swtrrafkp22k7u6ubucmk@unyxdyz5oyqf>
References: <cover.1764788517.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764788517.patch-series@thinky>

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 72628b6f459ea4fed3003db8161b52ee746442d0

There are almost no users of the typedef left, kill it and switch the
remaining users to use the underlying struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index f11ba20a16..2b270912e5 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -622,11 +622,11 @@
 	uint32_t	ext_len;
 } __attribute__((packed));
 
-typedef struct xfs_extent_64 {
+struct xfs_extent_64 {
 	uint64_t	ext_start;
 	uint32_t	ext_len;
 	uint32_t	ext_pad;
-} xfs_extent_64_t;
+};
 
 /*
  * This is the structure used to lay out an efi log item in the
@@ -670,7 +670,7 @@
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
-	xfs_extent_64_t		efi_extents[];	/* array of extents to free */
+	struct xfs_extent_64	efi_extents[];	/* array of extents to free */
 } xfs_efi_log_format_64_t;
 
 static inline size_t
@@ -723,7 +723,7 @@
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
-	xfs_extent_64_t		efd_extents[];	/* array of extents freed */
+	struct xfs_extent_64	efd_extents[];	/* array of extents freed */
 } xfs_efd_log_format_64_t;
 
 static inline size_t

