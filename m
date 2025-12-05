Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C0727FD75
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946996; cv=none; b=rA15JWemBWcVfgeW3wNf5tj6iYiSRP1Twebrgj4v7avgj8x5b52TMfbO4ZKugks5pMmU1UKUC4XQbNpPlGSMWFXEocjYfpkZ/Hqzhey06wGZDPIzYX7AOkWJ+FTVvNCiT+UUu5A6fIMV08Onkhm6W9w3DxjIJQsuoV564zO5A8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946996; c=relaxed/simple;
	bh=I1T0asy8kQiG60Hdwfx/yhyep1TWkfor7joWKgLHjzs=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ldz4DiPAoZ8lEhlm00sQJQtBFUdSIWnAA7a/YM/HjQuNvi6jEcBZGFotG2PuQ3yshb6HNv9AMmZBA431d7CoJHn8wljlN0yIRJrXEC2ac/f8VgDeWlkmdHxvXKWJnqJ3AQoyVuuD65mtjrRaRH6QVYp/liNcq3Th1DSbh8hD4r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UCNtQUdM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hN1BlAOg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UCNtQUdM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hN1BlAOg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rMcvRF9TvDiPuStT1jY7vP1B0fRVjJ49mFqe50dOGRM=;
	b=UCNtQUdMXOxgoTTX9+VG1AxV8vgmn0e1CF99oc/2QoSrNhZNeuRW4iBjOrQ41amHam0hij
	z89O26S0ba9egBXdsGd4PX16+0ckN8XHpCBwew8KR30y2B1ugVh7wIX7DkgooV7ZdFoRwK
	E0C3ooFnhwKsVM89zDrQ+AVp9y7uc6M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-107-Fjee_3PSPXqTH5EmyAAYpA-1; Fri, 05 Dec 2025 10:03:09 -0500
X-MC-Unique: Fjee_3PSPXqTH5EmyAAYpA-1
X-Mimecast-MFC-AGG-ID: Fjee_3PSPXqTH5EmyAAYpA_1764946988
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47918084ac1so18556795e9.2
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946988; x=1765551788; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rMcvRF9TvDiPuStT1jY7vP1B0fRVjJ49mFqe50dOGRM=;
        b=hN1BlAOgBPiBJ2ARE/aNRCCTyhR4yNCuRrRHMoOBsZgvkblc0jmmn+nbeKKpCgUcwP
         IjJb5UWT0AzC3aNHuj5Ps1llxRnAzkrmL41FPRR/opN4DmsVydZWVG9+2itYuxdO0puL
         WTWE8JRNP5k2AHkaOoeJmd2vbZ9YH/TRM/q+3uDbStFktKsaIDGeTjGyLyf71lBV8cfx
         OH7gsbGPAEKgoaUhOI6QUgjjQMg5ilPktUuwcFG8H67ClPyA84E6NzOhpKBroDskGKgv
         CB897H84Z5fQsUZ26tizbsT7hJbffpf/IEI4wYRVKF6cAWlnNXW6z7e6/rA8etOHm6p9
         9hdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946988; x=1765551788;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rMcvRF9TvDiPuStT1jY7vP1B0fRVjJ49mFqe50dOGRM=;
        b=Q2IVAs8wKRzR90cbtVlDdIP82dyRg784+Zd3c7tTjHSvnBLg/ibYsEj3ZLjSBN/xDs
         Vi9xX2Xs2xt8K9/2pQwyVgcORSbS9CuNGsvuuJHp5Wsrf9WzdCIlgiv3IBvsqbRlk+6d
         YnF2bQ0T12lVgbRCSTrqmEZhh2ucbM6Dp3EhIUcbWksHse+QS8H0X6/h98QSFm5PlhZ1
         GGVDV9/izLIIHPKHNKt2MPCj7CHBF6eYucsX30h8XVX+VFPQdUK6CBrbOMbR3PxjeM1R
         Uqh3BUgihYqoE57DB9pcZHhPNYVGU9bGvpE+Ny4v30lnNJ214HfFuIKIzyijPLNSYc23
         KbuA==
X-Gm-Message-State: AOJu0YxIhm8RNDyWVGxLLnG/xqnO2VH6HQofi2GPIas2xDb5u+mf6UAK
	KzMCYqVeOVDMsKHSCyEhZsZt0U3lIMeTvA8qQqZWU17ginbybv9HfHmYyR7MRzfcn3piuHEqoIu
	AjGX7kPNNMSCVxhoLnKtaqCdWg7hAxZOpwrtoBKRgaLzK4c4AL7GF/IfBFqpwaYsTFAPrVwVa0r
	z+e5ArbU/YBvmeWvftsFIqY0//OfgYZzjd2BXmNHBFwTkw
X-Gm-Gg: ASbGnctTZw0i6buGCCnu5Ad4+rRxWmGcW/IcUPLW8IyY+dbprB0g54lT0pT8bNVHdi6
	BlRMw3Wc72WAXMTxYS+ebcfBV/kCw80HXWRtFNURZu1gt0CU1UhRQFpqqmrGr0ji/loagGMC2Yt
	0WexoAXocexLc7DbBp/oK/b484waDuQaFSMt7m5am/qCiWnYQgU3O3fQ6C+FfDef0/6PNSa0EEW
	GDo3IiOctFp0RRBrp5scMwvt7INrHszY+YUMU5axYqo4RB1jVvrBZXi4HrLsKYKKINu5vHBNzx9
	wJBDuDaaiJa+GLuskaMfghve+OMrC0APU9uKmoJ187C+MtA3ohc4BFJ4+HMNKp9vtlQUlscbiks
	=
X-Received: by 2002:a05:600c:3b05:b0:477:582e:7a81 with SMTP id 5b1f17b1804b1-4792aed9ab8mr106068935e9.4.1764946987556;
        Fri, 05 Dec 2025 07:03:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFw8yPmZ7dQhvvXJJABIwZOHRMI9v6pzDTyu6Fnc2TWeTOCwGCWmGFOWhBnPof3l8cLhJro8Q==
X-Received: by 2002:a05:600c:3b05:b0:477:582e:7a81 with SMTP id 5b1f17b1804b1-4792aed9ab8mr106068395e9.4.1764946987021;
        Fri, 05 Dec 2025 07:03:07 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47936a3df90sm8620195e9.9.2025.12.05.07.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:03:06 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:03:06 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 19/33] xfs: remove the xfs_efi_log_format_t typedef
Message-ID: <j547wijpizf2f4ie4hm4j32hcsvq7bq7cam6i2sphygfjvnc46@yvxcfgjxsbzh>
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

Source kernel commit: 655d9ec7bd9e38735ae36dbc635a9161a046f7b9

There are almost no users of the typedef left, kill it and switch the
remaining users to use the underlying struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 2b270912e5..81c84c8a66 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -633,13 +633,13 @@
  * log.  The efi_extents field is a variable size array whose
  * size is given by efi_nextents.
  */
-typedef struct xfs_efi_log_format {
+struct xfs_efi_log_format {
 	uint16_t		efi_type;	/* efi log item type */
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
 	struct xfs_extent	efi_extents[];	/* array of extents to free */
-} xfs_efi_log_format_t;
+};
 
 static inline size_t
 xfs_efi_log_format_sizeof(

-- 
- Andrey

