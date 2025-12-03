Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC84426E714
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788747; cv=none; b=Ec+myeZauSj2G/KzxWpa18gplyc3k8uOXdRAyINx51q+Z6j5GFpsSN2wpOUd+TQjkOX3mxtTMhOWBfMeJT2SrhxuE50sVFAoS278zYegi8t/u4x8aifUL4wX7R9EeKR9xGKvadx/8gWPE9N6xsHPoag9hkL8kNJxJt5X4wtJ6VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788747; c=relaxed/simple;
	bh=/SKPf86jt6YqNgmehYhXOP+Y1RqZRkRsXubJtzJ710o=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nJlbVkKaLXNuGilRwQagJbuyh/jt1mdunidaX5wEAg1clhWuQvoyUe8WD+Oaoq6Ge9b3anaNdVhcvL9t16plVNiA22UsJeHJMLiXszb6HAoihnAEWLIKd/mpBzqjEgee0yPszrtF6QcklXxr299JNXnNQBcUu+MYFhDr+CnKuLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RRkRFkrp; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EZrN2iLz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RRkRFkrp";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EZrN2iLz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kVW65G0c+l1mJvVwCoKc11aDp6eAmpqZYCm+0t5M/ww=;
	b=RRkRFkrpuXYQDmjmetNJLKKOHfabtmaa4CQ+gd5of8BbI62Lef5TP50cqL4hikLDtYYyFQ
	yqAK7vSFidhs2Dvw7gNUbk7BJQMU4pHSuQwTRWBxCL36VA7WebV1pLMYv5e002CzdmFmox
	cTDtu59CRIoU6rORdBl3QuBazrQvcBk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-hr0BdKSDPTa-bIUIxZBKew-1; Wed, 03 Dec 2025 14:05:43 -0500
X-MC-Unique: hr0BdKSDPTa-bIUIxZBKew-1
X-Mimecast-MFC-AGG-ID: hr0BdKSDPTa-bIUIxZBKew_1764788742
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42b366a76ffso80015f8f.1
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788742; x=1765393542; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kVW65G0c+l1mJvVwCoKc11aDp6eAmpqZYCm+0t5M/ww=;
        b=EZrN2iLzA+qGz7B9weTq42TFPd+NXc1glyKECwP0zCHaJB/FD7jc8OKlnJrZejMpa2
         7fuV5omODFyn/jmqPfOX2/0TvG0iAs4avIE2ukR4iy43P27QKGPJW74Bxq4gj+9hAwgK
         bCiTE/cDnwvaJmtN0spQ6OyJk1iknqF25n9idlW1SnPmUfHucw7k1n+u1kuj/kLf5CSP
         rgF/Q864WwS4PtA+8kVAq46ATX1H4+xHaKRoIaKsGtT9hNQQj5ZEwybkqBcCygthPuOu
         RE3pg8ftaguZJ8VDO4W+hY3AjEXRln2cKfSrO5W5PDoNa7Y4i6vE+zAX2Vv7Y3kVQt/R
         AyqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788742; x=1765393542;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kVW65G0c+l1mJvVwCoKc11aDp6eAmpqZYCm+0t5M/ww=;
        b=pSx94Pym8I1Tf8/GnShjWiVrhcyJC1uDedBIFsEFjGbUnOnZQRx8VlUdXWLj3fVEUl
         LE6XSMd8cmVLv3FJ+w8IXR/k8dvh/MbxUsoAcxuSbTo52cZKg87qgnC32PbPNlRuIC9U
         I8lbAG/QuVxTj049pO6DMrPMDU+BVQRqt0YiEmMdEIGKUzlL5gtvXv9UIRuupQ4P7kpx
         w2ND/KkKEF+OyyF1yLwJmqk9E9MPOaNHq92/PfTTzM//CTjTShoWps9l1vY+U2/VzVLT
         hieCvVm233LpCgTamdUPlpokJcaKjJJmC01G5it2FWugcKFvWdrRf9Sdht6fj9Fo305j
         mKKQ==
X-Gm-Message-State: AOJu0YwZYyiwBa05t1cytypb7jqzWw+0IqSITi2LqcHeL3eV7fR4oKWJ
	sbWH5O+iwRPF7RaAqoGWR5dxnMron3AMS0vIzaK667SysSP+0O0pnXtUVifil50tckcoW5jjUzZ
	DBAyqgRY6Cv8ehojyDrFzJnuMgnaqXsOUwbLxCRk2/QoILIzjTS4Wd8wYoz9gvHAfRLeTCC2isH
	3urbrvNThiQ4K+y2zEAktYKPYP15HBot6u6Z0vwssKkmPp
X-Gm-Gg: ASbGnctBsCfETN1dVj0SbITZ6sCsOSOCeFYP3k6nknTlgTpSxk94LUUTpKM+xf2JVzb
	SMwlvJ5zHeLguSezpK0cZ9k/7rZQpbesC9qCkmru9uJ6h5RV4aokVfxjjTr2B/0CkVTxfVeZJbY
	nqtLRBW/ntrncVydtCObNT7f9Od8w8b7tBQ+v+0KaQrvIiBCcZ45cjmWrh4FMmqNRuyN40duSkw
	6U3/Qy9sjTWgcBd00h6nGvnTMTpCo2+IMCHgzD+8A3UezmJQOwaBLGcY5BtaJY02RSje2GXp87b
	FVjiKjKw7UUTIrCQLcJuSRafLZ68YwkNyy+3H2KpzPvmKAKdaVIkInqcfxHLzJy8EHBYq/hn7DQ
	=
X-Received: by 2002:a05:6000:2510:b0:3ec:ea73:a91e with SMTP id ffacd0b85a97d-42f79800141mr80510f8f.12.1764788741972;
        Wed, 03 Dec 2025 11:05:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFiYDW8iGAr37Wt89tNgeNiAG22+JltG9xY0FNDjK8zEdBngQ0lbtDGroAlDwPyo0npx11hQA==
X-Received: by 2002:a05:6000:2510:b0:3ec:ea73:a91e with SMTP id ffacd0b85a97d-42f79800141mr80455f8f.12.1764788741392;
        Wed, 03 Dec 2025 11:05:41 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5c304csm40302031f8f.8.2025.12.03.11.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:05:41 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:05:40 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 5/33] xfs: remove the xfs_extent_t typedef
Message-ID: <agmbvh6pj7uvewlwjb6sljpvr7fyimdcpasprh7er5sarcdfuo@gsk4ltvyqyjo>
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

Source kernel commit: 476688c8ac60da9bfcb3ce7f5a2d30a145ef7f76

There are almost no users of the typedef left, kill it and switch the
remaining users to use the underlying struct.

Also fix up the comment about the struct xfs_extent definition to be
correct and read more easily.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 2c3c5e67f7..6d0cad455a 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -605,16 +605,17 @@
 /*
  * EFI/EFD log format definitions
  */
-typedef struct xfs_extent {
+struct xfs_extent {
 	xfs_fsblock_t	ext_start;
 	xfs_extlen_t	ext_len;
-} xfs_extent_t;
+};
 
 /*
- * Since an xfs_extent_t has types (start:64, len: 32)
- * there are different alignments on 32 bit and 64 bit kernels.
- * So we provide the different variants for use by a
- * conversion routine.
+ * Since the structures in struct xfs_extent add up to 96 bytes, it has
+ * different alignments on i386 vs all other architectures, because i386
+ * does not pad structures to their natural alignment.
+ *
+ * Provide the different variants for use by a conversion routine.
  */
 typedef struct xfs_extent_32 {
 	uint64_t	ext_start;
@@ -637,7 +638,7 @@
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
-	xfs_extent_t		efi_extents[];	/* array of extents to free */
+	struct xfs_extent	efi_extents[];	/* array of extents to free */
 } xfs_efi_log_format_t;
 
 static inline size_t
@@ -690,7 +691,7 @@
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
-	xfs_extent_t		efd_extents[];	/* array of extents freed */
+	struct xfs_extent	efd_extents[];	/* array of extents freed */
 } xfs_efd_log_format_t;
 
 static inline size_t

