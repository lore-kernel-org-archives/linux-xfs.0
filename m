Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33C732827B
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788867; cv=none; b=CHGZxNqpeNJrP1xNd5V5N1v8s4k9s74XUda7s4tZoU2UZkXRPa0PXmJxrf68atceokBMn/1O3Opk4KyLKYWUJVNgvZO/wsrNR2kCIs8Mzse/t0QadyH9Td9kTVChrTU20jdQxNQHG4Q6PiAxqSb34eMAdAaoisVwb4Re6BDt83g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788867; c=relaxed/simple;
	bh=SbBxxTy4F/ACxGxF8xau89ae7cYJ3jy61H0JxyKauAM=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZhQnWCzTtttAmtg7b8nCEIslSzeWbPqkDpEHk8r9AYpej7kS2xQoLP16BNJ/D4BRYXaly/Y+EO59sY4/8+1yAl3uRrmhxKUwMLCvpmRZ1GyTD5HfiIxhmIbYDVvF1wgUNIpii5wgsy3fcmVjb9917zQdhuH63xJsUAMFoG9URHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CGt9I45g; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q6lpLfHf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CGt9I45g";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q6lpLfHf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AKvuMZ9yOjOFZvKzY6cbgWjeHeLen5VOd92doJOXrh8=;
	b=CGt9I45gqCSClCJ3xF9FOPe4ASEKcaQ9/0otRgof8UVZZYZ+p2uH7QcyZCLA7E07bKZGPG
	25NizMMsLl/Vy52cr8WFtiAhgHLAMOjxj++gO+919njwulLKW+0d+pri262s0s7ltnr8Do
	HgsXYyu+cqSTM6M2gc4LF6118BimNlQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-CUS6zNZwMm2h5vSNfC58jQ-1; Wed, 03 Dec 2025 14:07:41 -0500
X-MC-Unique: CUS6zNZwMm2h5vSNfC58jQ-1
X-Mimecast-MFC-AGG-ID: CUS6zNZwMm2h5vSNfC58jQ_1764788860
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42b3ed2c3e3so88287f8f.1
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788860; x=1765393660; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AKvuMZ9yOjOFZvKzY6cbgWjeHeLen5VOd92doJOXrh8=;
        b=Q6lpLfHfWD74MCj5OQW9DXSLG5kJAd9hnes6bieW8+UV3Ri58mdJMBD9FDh+4HI95n
         saz90Q1n+8XV05NcNj8/ki2ra/TJDgOKX1n0OLzpPP+cHTcB7jkJn9fVG6LRHPLZkmgD
         mGEF9t4X6C8/VaPZpGzxwAYp4J5vM5HeZNbjW+3mNb4Lar3RmWxxvRLJF+VyZbdSTkXt
         ssM4Moz/Tqz90RqiftyDgUrliaBQbH9eQ94gkZcV9A6wd6BuN32MKJIREXiXOxWh2eMr
         c075V5XSAMSMm09Gdjk1FNj5oPNT2FHzFtapbZMstUmjtal+k7HdvEq/iQB0a7H56RWV
         V0jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788860; x=1765393660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AKvuMZ9yOjOFZvKzY6cbgWjeHeLen5VOd92doJOXrh8=;
        b=iPoy23gfGK/UnQsd3fhxNDOoI4KSBiSdpZBRlp0T6djEjA3QQBEwwhkKKGSK6I83VE
         aeFjyVOMC5YGFQXK1RGi2Qku3ur534pq2jzwkWC+g4DK8KOuh3wrzaT3pac+FAS5emuW
         +o53YPnAVBw7uDCbieC6B0vPhlw/Ej27Dutaj+kWZIeBE4zKJb3YyLrvMpoEG/+8x/Ha
         QTWp03MiHVIicsgc+S6rFHNymQ4Q1wpRD4xZkrBysjKgPXin1r/Om1DkDowyDRLUTAiy
         yahpg9HLbZC+lGVWId2JC3kPh9E38vyGgGZoAQ05GWo04CoJpsAawI+TuyR/bvvqROt9
         ULSw==
X-Gm-Message-State: AOJu0YwoLKcs51YWsR8PJq8smZIcc9Mc4OJA6Vy6i+tKGZln7SLa3jPN
	jGq520AeR/xjpp6pG+knEnHDpaOj3zfU+KLJa1h5NmG8/g0bom9twZZFse0ukQFJBHDUdEoHmIn
	9J8PfjdKRvdN6ACfSRoGVw185jFQslh9prn79258xDhZL8clcOPM/3WEbElUUqUmoMrnWXgLGH1
	AR02QGdaIcwCXnupAyulY3B4cIUbAM9B/UpatkoVQ3EpSw
X-Gm-Gg: ASbGncs74bIH+js8uO0IUyk6Pfg7ShYEZ2Vy+kQka/h8I6xGui0FngY1UoFac7SX8yF
	SBBUrVBO5FlNEdEm3gU0t+n8BqJPqUrW0LReksAI9WEmVTwn4w34iL/naghIlDWsPse1RJqyPtS
	zS+VWnPAHN0HP/WEfRvx5wNpm4qVE/Ir4UfphhkpN1sLzSko1s8OH4/KuULQIznsmQV5IU2H+xV
	DuMVT2BgBmPWsAzv67epOfoOFdznnp1PW0HutVofQlzJI8Wmwdg0uCAHaNky7IYQOEk+vXOfg8I
	ZvM3Wfx4NXjbiV9rhU56OhFGv/IVWtsnTLkHCX/tQHkZqasDr/LkPSI9e4u3FVKs7TDt9bSXoCM
	=
X-Received: by 2002:a05:6000:18a8:b0:42b:3bd2:b2f8 with SMTP id ffacd0b85a97d-42f731a2ef1mr3680324f8f.46.1764788859833;
        Wed, 03 Dec 2025 11:07:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEUgAwdMMa1R6kSYlNBriw+fZX4npD1Z9pBpFaece8peAhmC4GuhTLBk6mxn1NHh9Zeg1s5/w==
X-Received: by 2002:a05:6000:18a8:b0:42b:3bd2:b2f8 with SMTP id ffacd0b85a97d-42f731a2ef1mr3680284f8f.46.1764788859263;
        Wed, 03 Dec 2025 11:07:39 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5d6133sm44065916f8f.16.2025.12.03.11.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:07:38 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:07:38 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 10/33] xfs: remove the xfs_efi_log_format_64_t typedef
Message-ID: <zwhuzbkatmwiskq7gauhrsyipht6bplbwzzyd6ngbq5xj7rizd@xpgqn7du4375>
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

Source kernel commit: 3fe5abc2bf4db88c7c9c99e8a1f5b3d1336d528f

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
index 75cc8b9be5..358f7cb43b 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -665,13 +665,13 @@
 			nr * sizeof(struct xfs_extent_32);
 }
 
-typedef struct xfs_efi_log_format_64 {
+struct xfs_efi_log_format_64 {
 	uint16_t		efi_type;	/* efi log item type */
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
 	struct xfs_extent_64	efi_extents[];	/* array of extents to free */
-} xfs_efi_log_format_64_t;
+};
 
 static inline size_t
 xfs_efi_log_format64_sizeof(

-- 
- Andrey

