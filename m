Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A9331D723
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788914; cv=none; b=IxwlZG6+VZ+0s+cbga6+Bn6zJjwEMukMNljE8AVpdxLf//kL/bHFMiC+cTpRXwmwwqmInTZTfti4IDDlLin7QXsKKimPOeNxA8l30j/Jg/SbdV4Fb+Lz2c9RjYFs5SAOeysvsGxPOHlfKqHuozowvXIkLb0w4YHW5TAIeRkd04I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788914; c=relaxed/simple;
	bh=FOrIAOrLz45BLzgEl+6tW2WEgtZQ4tBT+6XxwzxLT94=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vFpNUXSnBf51e8O4OTZ89dE3pfCXbr9Odfbo/NZ0WsCLCPTbgiJAQh6CzUQQt0CTRZ4ICbdVt7pEFsmOM8e92pqB6Ivs5Yyv6tFcSuxUt50W8JI35Vlo3Fi0mAvY3EEqe51Bigtwnlwbnlor5G8fNNC8naIHk9iPGDSxOU+vlfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hJsI/l38; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zb4IP+dM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hJsI/l38";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zb4IP+dM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BXVQBIwIqraoeFL7pf0tgfou27V0cCgp3GuWoePCCHE=;
	b=hJsI/l38LQyEoo7PqrMf1RIEq7ytqrykifE+JpkikYtAD+kEFAe49BBaMsMfizftdC34Pw
	drbZzAoZWM59YWlwG0ePitcLmfH0POhx19NK0PjJa1TmlRXOA8Am6HIQsBLFnIpDmZyqvl
	Rcy0/ycRclARUCRzJjcnmiLnXBviJQs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-sJaJvvgYN5OGNSy2dhjecw-1; Wed, 03 Dec 2025 14:08:27 -0500
X-MC-Unique: sJaJvvgYN5OGNSy2dhjecw-1
X-Mimecast-MFC-AGG-ID: sJaJvvgYN5OGNSy2dhjecw_1764788906
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42b3b5ed793so80946f8f.2
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788906; x=1765393706; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BXVQBIwIqraoeFL7pf0tgfou27V0cCgp3GuWoePCCHE=;
        b=Zb4IP+dMw/hMqrGx44ncGiimIlN1jpstvmTAmYp2tNp62N1zeZEpu9p1gfzpHYo4FP
         Ms2xryp+vfDFxiZXGVPl3c+uZI9099PKF86L1yOUOn9XfHBPAVtew9R3FGLIjRWPH3JT
         hBf5g2/ta94VjyLNt6elnRUK8SC9cP09e0ngLH9rFu+feTVJFUkKD6N0cngPvrMRSLpW
         lrbM6iX46SmPzHCCBpTs8/HIHs1xtB8KS1POacCoWAUQ7RWpOOLYqNU5Hec5wg81z6Ph
         CErrI1+p97fgbui/90DCEq56rFE2JYoewDaJgn40U8n1Bg7nztFnm/4sZqGRFwGEBdax
         D5Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788906; x=1765393706;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BXVQBIwIqraoeFL7pf0tgfou27V0cCgp3GuWoePCCHE=;
        b=NFgRysOeQTZNJAiZwwIKE6HYV4Hn/wnoB80BZUrIRf2Xs+Bo3o7Kq0O74KJW6JYh5f
         Y38AkPQ2qyGQeKsHJZuZLO6S8SQVmjxs5OIQliPiYik03PmqUjp6mE91TsCP8mgHJl+Z
         uxT6aVo0gKYazHueTy5u+0meU5Xt/ynV14RaGMBeoEGTKmceUL+y0ae1Bj2EWGYeyDD5
         0QHJXruEPMXkiPXBXVWG7+8+HKp7yErg3JK46d/V+tpraxstrNWbIpccGftRzqib6adc
         rV50aOPH2XVXGcd9BECZXmxcABDT9m68mc9txievBNsqllc77OA/FGxazqwb5l7w59so
         jXvg==
X-Gm-Message-State: AOJu0Yw3cDy6QGY1r243kv7lhT3djmH8D+UXzNbhfPNr0+Kg4hPKLOwz
	VaGAB0ZGkU+UiUiKlva+BPdlvWYbQMAxePk8jaiUReUjYYBVayGNj79VM6TZcagMosA1MURYA1t
	9/UDRNmbrrFsxQQK7aBEZZoM0IvXuUiDp2pI7UOFu+7hyLS24E7Q6aFv4PKqkxaEeu8l3iJKG+W
	SQE1vstdotLQhO0v1XqeHMJ/GELM5QbHzNH5aJD6DII8xe
X-Gm-Gg: ASbGncv+yRJTNZhkPj9gbnrBdCiZTI8lMMPNlkJUQ3gJ8I7pDrSeYzLmavZWK31meS8
	SwbAWC6BkPXeJartsyeD2Ef+Mh6JnBWFF2F7Lg5IArWB2IhadIUtI7rJZYVgf6FnvfBftj4hwIR
	/jPITcnpvabkxpyJ9TYS13+r+YCUWOOlZt/dLgaj0w1LtXq3QG0+F4JRC2tq+8MQWxSAPWEUvO+
	aAoBxCVrjUi/IN+HGcfuemXZ54tjKg/mvqtF/UJ5DvldXSwePNJGijmPzEQKDjpcr1LJ7z1AnJX
	UCCLBtMVMNMWWivTfZxx9zf/TAWBEH/dK3wgqmit8YGAAvvRMdER5VAAa9Ax/RdsMZ8z9PgBxnE
	=
X-Received: by 2002:a05:6000:4203:b0:42b:3090:2683 with SMTP id ffacd0b85a97d-42f731cf2f9mr3478725f8f.53.1764788905807;
        Wed, 03 Dec 2025 11:08:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHrCsLOzXlYEYjgUSi9cBx9XXR5B5aMOPk9SfKOvoFyYnnWFn1/7fGuRCFoxQcRBmO8tcA4tg==
X-Received: by 2002:a05:6000:4203:b0:42b:3090:2683 with SMTP id ffacd0b85a97d-42f731cf2f9mr3478696f8f.53.1764788905352;
        Wed, 03 Dec 2025 11:08:25 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5d6133sm44069492f8f.16.2025.12.03.11.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:08:25 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:08:24 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 14/33] xfs: remove the unused xfs_buf_log_format_t typedef
Message-ID: <npspjlbv4z7y66ywpua767z4mrugflzq75ffdwku6vptiii62p@lrrqlbooxbs5>
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

Source kernel commit: 1b5c7cc8f8c54858f69311290d5ade12627ff233

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index aa8e3b5577..631af2e28c 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -541,7 +541,7 @@
 #define __XFS_BLF_DATAMAP_SIZE	((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) / NBWORD)
 #define XFS_BLF_DATAMAP_SIZE	(__XFS_BLF_DATAMAP_SIZE + 1)
 
-typedef struct xfs_buf_log_format {
+struct xfs_buf_log_format {
 	unsigned short	blf_type;	/* buf log item type indicator */
 	unsigned short	blf_size;	/* size of this item */
 	unsigned short	blf_flags;	/* misc state */
@@ -549,7 +549,7 @@
 	int64_t		blf_blkno;	/* starting blkno of this buf */
 	unsigned int	blf_map_size;	/* used size of data bitmap in words */
 	unsigned int	blf_data_map[XFS_BLF_DATAMAP_SIZE]; /* dirty bitmap */
-} xfs_buf_log_format_t;
+};
 
 /*
  * All buffers now need to tell recovery where the magic number

-- 
- Andrey

