Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7159E32A3E7
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788904; cv=none; b=nzchm1KvdF+ItH0/xFnj+/UnQMe4ibgCU6gII8Wx+h5NC3MuwJ5SRGVB/raGSXYFv3Jv6zwJJGU7ptoiR8YDYdJDc4hDWZH8lJncvn6H52VgAtqNOQautv5YudzSTnIW6Wp0hQZtxHS5pMyY05+ii/k0tsE8b2S1Ho2f49Sxock=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788904; c=relaxed/simple;
	bh=d7Fr8AowKYXvBaJdq+h8MDuoesfQWwSTfkw09kdWTKA=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Im0WpArQ0uGVhKJq7OmIHVlDl1A956vrz6O2J+i87w96jr/ezT5hFtEBipCZzx0QRqTKpIyL9C/WUrugRq8bQG3O5I/HP8XhJFHX9PLn09WXbIpdeWSQzn7aTG1MYr26J9S4Ad7Uac3u7HNafMUtBQB/KO9cDOB0NaPjhhANYoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QXdT/xHp; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=A7DdGP3/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QXdT/xHp";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="A7DdGP3/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O0gDHqVMMcE+VdX7Gi/rWrDUwIx6goXcTBQRlv3UhbQ=;
	b=QXdT/xHpiaWXI5za1Ufjbz2NXAOnmW8HCbYjy6FzjE6By5ZGT9ihPSCSgbpzQusUODt3g5
	cgBvI5SQGT2B+5kRK9e6Mkd/XQU7+1efXdwUirSOnsmZ6yLNS0s/9PQKxtzS67Eq95jELb
	XF+D6GuO0FEdlD4qymDmlIvAclJ+xJM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-sZS9ddHoMvSx6r4aEkJvAA-1; Wed, 03 Dec 2025 14:08:18 -0500
X-MC-Unique: sZS9ddHoMvSx6r4aEkJvAA-1
X-Mimecast-MFC-AGG-ID: sZS9ddHoMvSx6r4aEkJvAA_1764788898
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42b3c965ce5so84286f8f.2
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788897; x=1765393697; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O0gDHqVMMcE+VdX7Gi/rWrDUwIx6goXcTBQRlv3UhbQ=;
        b=A7DdGP3/nl8FScK62fgg3Z/10rpYJn06Qmx28bm9Nz7fi/MJD/Q9baVWJ82xsah9Uk
         xC3VMt3nQgd3Rp9Yyb/PgBLQUmQ/ZB6je78jJ0vaQLGyFwC9VYCRR/4zbfn/yHEMQvSV
         zHF0kowTpBRLBUjZELnBzed2nGUF5ym2fKNF0VPbNlmK2l2v4BMecTundfAv06rOiqPY
         ggYTU6W7OLYb+oTgwe9L16i2bwq4ffqYTBJalQ5Cm1bzANHNU/YF19wEwD8+rGGc2Nmf
         5e41SHedNbq3pvrLQ72v4tbXt8RdNCVo5ECyqHTVj/kAOj70r+f74AaMM9gBHCA6RnMT
         ThfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788897; x=1765393697;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=O0gDHqVMMcE+VdX7Gi/rWrDUwIx6goXcTBQRlv3UhbQ=;
        b=oePIunLAkBnSyu8S3jXJA0QFrVnbtUIgTENUMU4YA8Myu4h4lknUOtb2osgvZt8ly8
         R5w+IE9lSd8XSHffd2/zN3yPXIFRg1DtLT278SMfK8050D6IIPSSSnRCOoxirTZPv0ud
         W5vLxZUQSSa4vF1Z+2fK/Ar7uy0ToZBJj9vRp3XSWW0yojLYMSankCdEOqMiPQjKnYi2
         ZwwkI54Fix4qfHVllLNgpfmwks9ijhxKVMaIEsgucwv3F4zR3BRoDKIgRsltZ7eWyDXX
         PIoqWlmZgoLpLKfEy0Q+xcFyFEAfYpwcB+Crz9vvCB1+yTe7AGuNlO830tKYhjDoKRZo
         kSCA==
X-Gm-Message-State: AOJu0YzVLA4/YnhHoAaUN57aBc6hvGV6NmPoeQ+gFHO4I+r7U92pi/zs
	SElxVabgwLcfgFsfG0YZu2nyMDuLeGz8IULllAn5BNNg4V/ZmgW4XY6V5ZhI7EvSBvf+omgpw4N
	R6b8cEIC54BjOC9cXDLFPMMUBFio/9g+Te+vpVMpWC4rEJZUHFnykpBDAgT5vmq2C5KEAbfwPje
	TVsdX9pBiF8OPt0UullA16tb4WrHnSIVgczPkODjotii9N
X-Gm-Gg: ASbGncvonlWi3/6BabeENs9ZckOBHsSvMi+FciWPuGgRrQDSfYWnXWrKopYZz9zrBjN
	5fhnDS1UHTb/Y7SDODD/Oo1OkbIi5te+O+LfW2YUe3xHwpYj/KJ4wXUj/Oib8xYXAw/82UKx3aO
	tLHgLOGvl+YXE1CrvdOIgOcWIzNEHYxuWK+Fs1dYBK/rsDo5Kg1t6qBJBtwFIovlTpLqspENdNW
	Hh1gMxZlbkUI1+eieAe9uO02VgYfukJvp7FRzQSicbs0BJJeEVhSJQ4dqhjxWsqu20QBnScvEax
	3/R8pBhhPirIrPwvNq1P4TSPVi2wQ1pqXCrhjP7PtA2m8jK7F6cZaADATD2KFLSZQdON7F9+AE8
	=
X-Received: by 2002:a05:600c:4f81:b0:46e:3d41:6001 with SMTP id 5b1f17b1804b1-4792f3987c6mr1757185e9.34.1764788897283;
        Wed, 03 Dec 2025 11:08:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF37P/gQ2BEvtDwMh7w0VGoG2/eSZB+C1f7iYXMCvhzEAP9ICc5xQGpCHsID/ixWBOHsBAQNA==
X-Received: by 2002:a05:600c:4f81:b0:46e:3d41:6001 with SMTP id 5b1f17b1804b1-4792f3987c6mr1756825e9.34.1764788896802;
        Wed, 03 Dec 2025 11:08:16 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792a7b03cfsm65371425e9.14.2025.12.03.11.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:08:16 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:08:15 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 13/33] xfs: remove the unused xfs_efd_log_format_64_t typedef
Message-ID: <lkibes7sglndyjcuyv5su4g7cvygysmm65zh4jzr7vpthtkjry@7qbmuquizfiu>
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

Source kernel commit: 3dde08b64c98cf76b2e2378ecf36351464e2972a

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 2155cc6b2a..aa8e3b5577 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -718,13 +718,13 @@
 			nr * sizeof(struct xfs_extent_32);
 }
 
-typedef struct xfs_efd_log_format_64 {
+struct xfs_efd_log_format_64 {
 	uint16_t		efd_type;	/* efd log item type */
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
 	struct xfs_extent_64	efd_extents[];	/* array of extents freed */
-} xfs_efd_log_format_64_t;
+};
 
 static inline size_t
 xfs_efd_log_format64_sizeof(

-- 
- Andrey

