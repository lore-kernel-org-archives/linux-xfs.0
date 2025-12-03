Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D4932E733
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764789040; cv=none; b=VHoO5bjQ1aqd3Sd/rpGM3W3qYbFG2NrJnvodQFBLSih+8D+Rwu49reKOggsKf47VOpf8VmKrER5wPwc/y0YmcjR9F1xtP7qRb/9PaCbTea0A4s53dl6OVdF+EoO8snhVc0SnG/SWSu0mT6F4bpdoij2jN4rzZDr/ROpAYWIT094=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764789040; c=relaxed/simple;
	bh=06sUbuxi0oGeVUG0jSwvQr8yEe/Rjj9NfbKgPvHuwWc=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UJSyPLuOXgipxq7uPpUNohdEVRfk9Q7b30fMvwspONxEbSNboR6a5aKayfXLZA+TbqQhcjSHjr4A6A3Ikk7AUZbW4sEkPMKfy4HD0sY0snChlN8ooUh2wmsGJv+pddrG5gBlUOa/MzRcqqeVanlp7V4JwftQq6LGQKTz+JYGpB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bthAfqci; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XM1ng2+x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bthAfqci";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XM1ng2+x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764789035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WW0Or6hiYyltdDGiAn98o0hZ5SJP9i+yq/HAhmAFzAU=;
	b=bthAfqciq08wnS7Dxj1MS5m1+fhY1oweo5hU3xSenbX6/GCGsOVk9FvhHzjZT+x0vVswYe
	E5+L1bDxp48irjU5zPL3IDxwI2aOdlwhzaoQpMCMqx/GMfAMn/sPtqi84ebfEagcxCyLvt
	lz+LKh4Q2m7K5MPSjKIjv63jQMGrk5I=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370-_QqsZOjWOIGKLXqfxCxnuw-1; Wed, 03 Dec 2025 14:10:32 -0500
X-MC-Unique: _QqsZOjWOIGKLXqfxCxnuw-1
X-Mimecast-MFC-AGG-ID: _QqsZOjWOIGKLXqfxCxnuw_1764789031
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-597c433cd2fso31787e87.0
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764789031; x=1765393831; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WW0Or6hiYyltdDGiAn98o0hZ5SJP9i+yq/HAhmAFzAU=;
        b=XM1ng2+xtzHvcWI1yMwSwXkeykpUmTb0KDqvJB68Cxp7i329e6N/X04jWngWWTbXmA
         zwdXb9PeOWtBdYxEBFsXOB6nc0eIA5zCVaLW8YrZqCooJyJGlETsAiL9KX6GsZ+Psqku
         UCyiD3iIDR6XsTuo70dktRuQo7kOptTUTcfUKGHM6VEOiinyTzHKRBfEbdSkf5slTJoM
         0MJKkiq3ZGyUAvNAXbMIixD3UeuhK6q680XzGXqlykSijHB2eosbs6p836hoP/GkiVKq
         Vb+F374ooojVUJo5d6k/YyM3ZZI2RhrF2w1HYZQApyuHf0q5cgFAZScqJbIToFCg5hsy
         XcZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764789031; x=1765393831;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WW0Or6hiYyltdDGiAn98o0hZ5SJP9i+yq/HAhmAFzAU=;
        b=b6/t8KMAiCzDVbtMTtILGiiBP5XWCO7skC9sjmMq3pm6NSKBUvCc3u/XM+4eQn90m0
         yX3oxzz2YSYfIkW312Lq3eCwD2HFmMe99xrygCd7g2WiZVqUsqXVv8vxHzmznmtNlbFX
         WYLtTfHOsOUMjcGWMctykwkMFJ0TpwKFuGiavYd6gKot2r/BWIbxG+OBjkmpqQrtZ/SE
         zxYMGuceiH3WoYOX+SXrozkuya7EZmyllLMXK6V9T7wJehkna3m9hmTiliyvX3DTP+m9
         9u0aNTGYVUQf/nZ6qBswFQm7rCSLRBfN3n0pwTfUeJ8xTa/WJnSgX1YHtbY3KF1wPCfL
         3ujg==
X-Gm-Message-State: AOJu0YyevRE6mAfu377FBCiNrMhqamee+9jE3aooS50Z6eTiqW1KEfgf
	CT2P8qIOdCAUv1hRHUChCGuMkBdibrYKZfKqgFkqPIQyuFEB8scaIptmY1QVLSzXbCSi/UUVntS
	FoIb+KDtT1eVVlHwrXlcBFPEPTo95GrRDwiAlrdyMhRkycA0/1EukRR+SNKCeP5P6UHuqM2auic
	ji0pZn+Ab0Tr8wX/Nx1En2WFQ4EOBdBwuOOXlSP5FlvMUj
X-Gm-Gg: ASbGncvxTkwZBZyNaBMslMK8hfMsdW36txXSiBanayTAMVblAGzH+JrITJaXahcsW9v
	0L2MgzcO2Kf1p6AQH6m9WLdCL0YewcsNMofAlrFa0E32k7ZbVqHinecWKhbGTYWOu22l2d+AO5h
	4FuNywkfMP02Jc7n9jO8wZZapLMHBUfYnF0sHNbNTil+opHoUuLxs/pVECQY5t2jcwBXfNNf4ed
	RmYC8p2L8K1D4xnBrB0updzxcSkWSdH5cJ5TLHXKDKJ7/XyxUw6owwlMvIhlGWrxqrx3DNUXos2
	OW22QbQJWebnwBVMEOqRaqr+Qq12zTDbdNisOBFBLf/X0sye4DJqf3eiZZDrcp40umfFVcPzvuQ
	=
X-Received: by 2002:a05:6512:694:b0:594:49fa:793 with SMTP id 2adb3069b0e04-597d3f90a7dmr1504036e87.30.1764789030716;
        Wed, 03 Dec 2025 11:10:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFPhbyPsRKxdSJWqfqZkDQSiv/PfVetvazMxMyAmOqIXf8gG9ddnYqJ2KKvseVP542QLSWS1w==
X-Received: by 2002:a05:6512:694:b0:594:49fa:793 with SMTP id 2adb3069b0e04-597d3f90a7dmr1504021e87.30.1764789030122;
        Wed, 03 Dec 2025 11:10:30 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-596bf8b0aa7sm5996327e87.34.2025.12.03.11.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:10:29 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:10:28 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 28/33] xfs: convert xfs_dq_logformat_t typedef to struct
Message-ID: <466qwulm6lw4vsk6l3y5prr6xfaeolermivtmbea4e6uqa4zwk@4ted53j4s4pf>
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

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 logprint/log_print_all.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 49b2e0d347..471eb0a8e0 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -202,10 +202,10 @@
 xlog_recover_print_dquot(
 	struct xlog_recover_item *item)
 {
-	xfs_dq_logformat_t	*f;
+	struct xfs_dq_logformat	*f;
 	struct xfs_disk_dquot	*d;
 
-	f = (xfs_dq_logformat_t *)item->ri_buf[0].iov_base;
+	f = (struct xfs_dq_logformat *)item->ri_buf[0].iov_base;
 	ASSERT(f);
 	ASSERT(f->qlf_len == 1);
 	d = (struct xfs_disk_dquot *)item->ri_buf[1].iov_base;

-- 
- Andrey

