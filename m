Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6DC2BE057
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229553; cv=none; b=Jrtz3jIohd35C32RqEXjUorowqwiCc34EIdFOEEZO7U+jZHyfCW7dE5ORz1q1w5j5Bf1zyh1/3yt1GYnDNN2nxjqkrUIu5VDVLn/Q1oY8m0vnpSCvfAw5+1gKHp83woPj4SR/xyytH0WdkqUm1YV9RCvgZpF0ZXO+mt9bf9z8vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229553; c=relaxed/simple;
	bh=4oN3KsYgjU1gziBXcCV2JxaplDe0MjbcejD0zRksvRk=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bC6F847SMK559XKAqjftLxeQHs5t5p/hg0MFRsz7ABRBAmB/PRHBYERGaSOWF+6pSvQS8xo3HXFulYPciplywBUKA0l4dEFTgHMfl+VdozCcwJTy2xNkui1mnfuPliQTpuQSdpD935wb8VmTPkwceASQOlvsousf+o2vOarx+Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fd9uyu4L; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hG07ugsH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fd9uyu4L";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hG07ugsH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768229551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=27c0RwsiUqQbIRsQgbUzvN/pOWTjcdmLaKAYvxOvoHg=;
	b=fd9uyu4Ld1MH0zagbDtPsFUvjoQf9F8PmO6jkpm8Rr4foqLPDrg/16BGflUet5+P9465Hy
	61kes/SHKbh2plyASI+gNpvIgWRZ0+FuY1LVQtLv3FlrI6/yfdOr/vGiqmntiSmSDM/Zx3
	/iS0kIpi6Dilbs4FCgyHieMxu6rkBWc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-aF_fLwb3P_WRaNN-oWNRTQ-1; Mon, 12 Jan 2026 09:52:29 -0500
X-MC-Unique: aF_fLwb3P_WRaNN-oWNRTQ-1
X-Mimecast-MFC-AGG-ID: aF_fLwb3P_WRaNN-oWNRTQ_1768229548
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b8701569041so246650366b.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768229548; x=1768834348; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=27c0RwsiUqQbIRsQgbUzvN/pOWTjcdmLaKAYvxOvoHg=;
        b=hG07ugsHB2HIRTMIwCF0OCtBqNaeuaiN9aueXT1Ohedd52/yttCGaFFYwmS9rqpA/T
         rngerTTiUdwzisnyyoAaMxmCg+uKpp6qXm0HYnFu2SEs50cM7R4d1xP8+IveQ+1nGGoC
         xHP5HHINzOuJchZ+Cd93CIE73I3ZSUbfNj7DPSYPNbY2Xtku4VbwLK5/Ot7cDnXEvxXy
         1ZpXZAgorkPC4gjEDmKEECY0znP/k5OOB90Vh+TXFVq6k3oZZKr4TPmHuzfxHrXtJMNa
         lpmHG8HCMC8AdDJmkn6AuQL00VedGrgjVG7qUs1AKuK5iBs1VkzTXGk3qEQFpHX23wJk
         YsCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229548; x=1768834348;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=27c0RwsiUqQbIRsQgbUzvN/pOWTjcdmLaKAYvxOvoHg=;
        b=goqK31cqZdeX+SASfcAU+scZsE4nh7Kx8v/1t3S8sLMsNCtpN8nG3HM2cCh4omzD80
         UrQhXJ1h1eF0kwVHb4MTZEG5fKdtBCPfCyHyrL7OtN6yQVQ0XCya46hQ/V6afS0DcYAt
         nrpSEhgQMCJlK/1ZxwuL3JlTwW1AGev7oyRXoNr2qryUp/A35HrhpadjuGvsuwZwTGWi
         uwe9Ju1Yw25v++kDgY604pEdaguA/LX2H8VWJiB5W6waL/ZukpUvDgwU19fA+cvdWlnH
         cQY40m96CG7yfc2uzSwN3c2w7n0ibNcz4jwqKaZPgYCwW0R1Y/RNxHgkpw2N/MVo4p66
         qQMw==
X-Forwarded-Encrypted: i=1; AJvYcCVOu3eHM+j2h22m4cEUq7Y7/U7LkdSLVvpWAq/FoVpO3T/nlqV+Prnm9jkTUsdndeFTVz68YFEYv2A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzskYPZ+VGyJwkoTkfXQeaakN9+9XuPYJ8d3oQpYu6Jw6oWKo9N
	I7oXBVQm35PMCnw8w4SlU3jLajl0kE2PXNln+vpMYhHhfpi91lacil3GzUrftmKG5nWL5/fdR0i
	I5I37ERbA8C0Ywl+1rifKMQxfQ0J8jcGzMVtB1OKjqDeTV15h9PNlxZVa+jWI
X-Gm-Gg: AY/fxX6Ho7bGE71JObXYNhH00Cd+WRXqlB40aDs+hI84LEBm6NQgCv00S9/WK4FbZdX
	6ylcmPnN4NMY9ouHehrovRnby3oeIOCZUkDOwBR98nvgqq52boEJ2+5SSdeKvqHbQyR+xGZvz2w
	Dp6rNrqvSjIGKSk84663/eSKm/AOBN9xIdfKu7LAwYDpFhC/UYW8EPp/Bc0s8Z5EFIfwufhEVNT
	nrIxehECJ1mw831sPERN+zkLrbVvHPP2AFX0uPlDsfp0AuK+FsvRvved8cxBj2C+45N7Pfn5eD7
	8NqTeZA+7wj0BLJ2YfFkJR9V4Tn+ioxMKSsCFZfFRLWmtsfdrZAVX2BUKKgKGtRCsBV3fEMo9ag
	=
X-Received: by 2002:a17:906:ef0d:b0:b76:7f64:77a5 with SMTP id a640c23a62f3a-b8444f21c49mr1822211066b.20.1768229548320;
        Mon, 12 Jan 2026 06:52:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHdX+T72PLi+rN64BMH3u11dTZ5cmvdk1ssM9FQvlRjQjwZTrPkhU4nI7/e1E+OEM+96ED/HA==
X-Received: by 2002:a17:906:ef0d:b0:b76:7f64:77a5 with SMTP id a640c23a62f3a-b8444f21c49mr1822207566b.20.1768229547833;
        Mon, 12 Jan 2026 06:52:27 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b870bcd342bsm475411366b.56.2026.01.12.06.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:52:27 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 12 Jan 2026 15:52:26 +0100
To: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	aalbersh@redhat.com, djwong@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v2 22/22] xfs: enable ro-compat fs-verity flag
Message-ID: <t2mwgqd6j3lknok5yexswvdba6nbji24efthhcqhvtqirzeahf@wdlnxaoaupam>
References: <cover.1768229271.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1768229271.patch-series@thinky>

Finalize fs-verity integration in XFS by making kernel fs-verity
aware with ro-compat flag.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: add spaces]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d67b404964..f5e43909f0 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -378,8 +378,9 @@
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
-		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
-		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
+		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
+		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT | \
+		 XFS_SB_FEAT_RO_COMPAT_VERITY)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(

-- 
- Andrey

