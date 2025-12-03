Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2988329E74
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788875; cv=none; b=sw8e3f1ksbF7uf6b5EEjaM4mDVDxVjNVRqw3B8tUVMnzykt5T9HJNKH5X9FizTGaJCzWQ/u9SzTfk04GlAAdQfYqDiuSEzcXTJpsUoMDFOlpjTMSuOIMl5gNPbcO5/7lpaP07psziorlFlRVTRAWFwBWiXuzY1bTp6UBBJfcvlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788875; c=relaxed/simple;
	bh=ScEO7wfgnfLBfS0FBQohNs8DYo0U/reczMR/5SuKeNU=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cRADrX38AnQKJi7Ea0tpRn+dNgOz9kdzphoitqDaMK6OWUX715xv3my74iHmGrOXDhDYmQyRoFkuvJbYl8aiS50NPaifDIm9asPwRaezyDPTx/su057UpR/TD6mrY/g5NJL5LhR+Phd+Ee5rljMeQ2b8eWmMdSiIyp1DnzW/92s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tej6iARg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=r7ZO6L2y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tej6iARg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="r7ZO6L2y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fFueDBUjtUwwyZm6JPF2ilU5dT5f4VsSY549X6J8OF8=;
	b=Tej6iARgvT6bZ9OCtNi6LTG3nPKPKtczztxdyPQCPemf8/0pKyCm2aW8O6AlQ6WjqNcTA2
	jFTKcwG+hWIsinZvHKTX43WycHHrjrP/YWNumhaxlQsnfcRZt0E4KgYoobgzgBEzQ1BPTB
	F7k6fAYen8mZ+O8DALLLH8U2tRd4wRo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-Y7HUpUbdOIC-nBQWPzcW5A-1; Wed, 03 Dec 2025 14:07:49 -0500
X-MC-Unique: Y7HUpUbdOIC-nBQWPzcW5A-1
X-Mimecast-MFC-AGG-ID: Y7HUpUbdOIC-nBQWPzcW5A_1764788868
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-477c49f273fso635025e9.3
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788868; x=1765393668; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fFueDBUjtUwwyZm6JPF2ilU5dT5f4VsSY549X6J8OF8=;
        b=r7ZO6L2yfkE/1BffgNTnBeZr3ruSJr7jM5ZrMIWSl+fWkCLHqi/ch6BhJ7hSzaxUjj
         VfsNSbCfbL51fsOrttbXr5tQwiFIA/RYSMt3/mJvZCuwC0k4z/q6xFAr4gh2Kh+WzyST
         7IPA+SWyCerqfP32P6GMkS6jZv71tvv11tRQEKlYDKltkAe52p/No767fDCaDmTJ5yXP
         n3FupwNUOcc2QT0u5EXFVg+aHrxYkr6hcDlo3V4oeAgXVA7vWg2JNjiKbmFR1HYMX+nr
         B5/kGHg5qcYsGVoBI9F3HEW79PNSvWlZsnGjR7MZ9QxIh5w75RiW5Ec7Jj1/CrEYjUrz
         mmLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788868; x=1765393668;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fFueDBUjtUwwyZm6JPF2ilU5dT5f4VsSY549X6J8OF8=;
        b=Qv1+Ic1BeWmc3rgaH5tl8qPZsWI9zlSxDLufLf8XwqOKLyvFZgcVcmxS17tDYjun/R
         820iXWdL4SucG+sOiMKZ9lW3aZcHO5E8+siYaA83zio4CrACGtSUwMcABkLsN8R7BOL1
         DMIR1s9h1AkJ4FzVbBEimUfPKNvTnJbU7Wg8Lg5yn9bcFlynN6DdQvJgSBR0JIJNwS9A
         b3VsO1f4GL8tdaHfIb8dRIjGSGhZYmMf95Uv3kG63xK+du/XU4hTN7COfbPoBb7rzktm
         W785P6MDighzNd8k2dnkwiLcnoAyZWIwW/YJ0yQSkgvn4rE3d9fBwppg7RrJT7q8NuHB
         OIKA==
X-Gm-Message-State: AOJu0Yz9ZFvN1DjEWIfASwNCGCqlDm4+kyJzb/T/1NYGdIWEm9G96Xlq
	2rXppdeyf/3jm5X1L8Nrx9jg63qK1t4VzTE796HMeveEzcv4S2Z4XVRKszCGhaeVHdQm1TpIhzp
	Z6PHzJSeBvfX0Pl8LB5hg2n3Opxid6RtVuGnALSQnilDjaHhrUSIFEISJcb11/wdsDy4MW+DhqA
	pP/KLKE8Jdegk7PWhvuUWQgXDOWZyhOpZBl1POKLfe5h1P
X-Gm-Gg: ASbGncu5vJo0Ln2w4sSYiSoP344gTbw49xdo3wh/LOLT7jVMi3YNBVsdJlldMxr/u4I
	PYaumXiRsofinq52rMYeF5uBedaRYtBT75kimRqAX+c46gebLK5Xl+gj25/8+XXnCLC0G5Ehfrj
	otSUXtnronQ5fIGAD3R/BRG7Vwu7MmLxBdxkckJ8ff+BT48deya8AGziufk7iJfYCvu5Jgl3XTZ
	EadF980VXqBkMHEvq3bHturlaodD+wMmP56TNwZjpcwFNzbdsCSZl1UpVW314NjvMHNkpDYGUCP
	Mvxgcdz6zGR2F3oyz+rU+0p4z1hIONs3Xx6C7VHAYeRogEXMbU+XFb6nYRB7sxP3LM8K+bCYOiI
	=
X-Received: by 2002:a05:600c:6610:b0:46f:b327:ecfb with SMTP id 5b1f17b1804b1-4792aeeb50cmr30951285e9.9.1764788868169;
        Wed, 03 Dec 2025 11:07:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF69PaZ4JraKmK23+91dX9sbbQclGs09iX/j3CLqVe6aKAiE2vMy9eO7wnqW1X6PYvpHKzWVg==
X-Received: by 2002:a05:600c:6610:b0:46f:b327:ecfb with SMTP id 5b1f17b1804b1-4792aeeb50cmr30950955e9.9.1764788867653;
        Wed, 03 Dec 2025 11:07:47 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792a7a7aaesm65360535e9.11.2025.12.03.11.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:07:47 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:07:46 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 11/33] xfs: remove the xfs_efd_log_format_t typedef
Message-ID: <uqilqiindg3bhsra33dumbbwr6xi2pq4i7wc3ulxm5sozxknos@e766dcx2juhf>
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

Source kernel commit: 0a33d5ad8a46d1f63174d2684b1d743bd6090554

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
index 358f7cb43b..cb63bb156d 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -686,13 +686,13 @@
  * log.  The efd_extents array is a variable size array whose
  * size is given by efd_nextents;
  */
-typedef struct xfs_efd_log_format {
+struct xfs_efd_log_format {
 	uint16_t		efd_type;	/* efd log item type */
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
 	struct xfs_extent	efd_extents[];	/* array of extents freed */
-} xfs_efd_log_format_t;
+};
 
 static inline size_t
 xfs_efd_log_format_sizeof(

-- 
- Andrey

