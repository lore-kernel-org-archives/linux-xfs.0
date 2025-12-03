Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70C731D723
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788970; cv=none; b=Oqj7BX+mym2LrtOO91SgbyvZtC7cGoRWdM4r1HEvCoOJejtHRnA/cxD2Hbgw1tOQDEPMbiHxTinn1Gh3cWhn6ky7xj8XI6vkfrVm7BClMdTpLiixTzZ3KeMhWhP4bIzdoC1fo57UNvXObaUhf0BigQ/HRhx3BRMKThUg/9toD6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788970; c=relaxed/simple;
	bh=xGnykQaua/nd/s4s8V87ZJQ+lof2bTmvrXZcuxC/B3A=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e3SdhZ+8PFW1ZzkCCNIkPmPnUUFa1MVfom+AhZHbw56aZdowwauKf0lihlwpTkwYvyBK07TSjOjup+akvxa/3owB9ZT6zOmoORy6dmax69gPBguVWK4rrGjhvBIxku1qo2lAZSEONNKUXiPrOcJzi3LH87TNbUDa4OBUu59N82A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a9+fvlpY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=thtTX3Oz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a9+fvlpY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="thtTX3Oz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8tsf8MnXAOA+ZlTJo0VvCTEPLXIZEoVQ1tGqT0a0KOs=;
	b=a9+fvlpYj3uSar1cbtUkXgRIW8yXlsQBLSW3/gWcV7puFw7U4Gi2Y87QffmiXatQwT06Tc
	bVBkaJAU8Xi3NwzVb/ht+nBZILOeRlddI8+c2RLLYtOmJmp62kqUOS/MfcMHGxiIRyWaUn
	4RyX7yPRxzQ83vM3yaY1jZ7tv6uDJO0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-533-wmpa4zmUOWK3Hj9ZoEBKJQ-1; Wed, 03 Dec 2025 14:09:27 -0500
X-MC-Unique: wmpa4zmUOWK3Hj9ZoEBKJQ-1
X-Mimecast-MFC-AGG-ID: wmpa4zmUOWK3Hj9ZoEBKJQ_1764788966
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42b2ad2a58cso64110f8f.0
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788965; x=1765393765; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8tsf8MnXAOA+ZlTJo0VvCTEPLXIZEoVQ1tGqT0a0KOs=;
        b=thtTX3OzkBTYp5GpGSn7gzpybcivN9Fx3WRO1Yi0R/cpuEnkD1QzM0u+8dVWc8tswf
         1sk4J9p6GHkvZcZmhgfdyyxcqP9Xv/pFDkC472aqAsGPAEszC7gV2lMw9YVlFrOcYxRk
         9i2K7gUJPm2olBvOnKEdB9VtX9NYlYAAEPH1oTwrAswZVMy3Kj7t/ffsE17pDRczXdD6
         2LBqNHcXbkmfPjVJYxLZIvfURKOu1iu5MXTaAf5nyMz8ezVvY7pg0/hD6242WBaFhFMl
         AMqMJP2y8ESAAvYDSLjc+tr3wfpFg2nHbt/XvBVt4rrAmw+xQ2KcBpvxuoJ4tDvs6PRj
         S99g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788965; x=1765393765;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8tsf8MnXAOA+ZlTJo0VvCTEPLXIZEoVQ1tGqT0a0KOs=;
        b=od/eDFbeaUYsXZJPKMPS1MqQQijs65FqPjMfxvZqeWNWYMeDSZRqJa+lIL4LyCHAJp
         vM2jxVXkZG3x7DRr7g4I31zAw1rT/2U8st4y38IW5T+TurQD/pGkhp44ik0Y7yIeqLwq
         xuQbWgKEkL74aIvqx9qKZrGzwUv0oPlv6xEBguar/PRr/phbL35AvIN+BnC3No6A6p5W
         FS9keRrpeDRj8k2SKzWqN7pfbYFEHsMgRDZJ2NdAxenCBR8SoRWyLZzK5N7X7b2pmOMc
         UQM3PAEqKd/dyeccBz2SDmWYB5PJrQvz8b9iH2nf1noNdNcMsCk4PDQnSohuI5Fyln2t
         1RQw==
X-Gm-Message-State: AOJu0Yz8YJv3VN93jyAwKa5kifICS6ppPh9Jw+sk9UX3p6GUDhDc6cF2
	mWZCB5vVQM83VLMYOWUztxomfdJBOfSPElQAgLwsnhdULlRV0gVUVz5kWzXteqr4uecdntjm5XR
	WY0so0l2RycS9Gmjab9TG6uwLjfIqf4gFjANtXzoOfHM/EqDXGMJEKyUPidxkA0k9/xhYdEnNB+
	ZM7i6EjIMv3Ab8GicQMJBEw0YoaGG/mW8YSL4Vs2LC7YP5
X-Gm-Gg: ASbGncuN84hOVKWkcxcF4D77DlrpqJR/KI4p4m6jCry4Jp95FEMW5tvmSKNfQzKsR5l
	Ff6ls01GPvRmWSa1TjZRIIppBbkGfnWs2qUyNRfL1Ne0H6muW79xY/THno1jAhm8LgL+QVDGVqN
	T0Fx0SJ0Ot65K0m4hh+/1Fgg2QQk4Ik/z2AogvJvmWuwursc8unm/TAZZv9fEJBbUW6U8smG/MT
	rWz9KW/w8L4G7UY3aD4r+XK0Z79eDNQoRhiqAxl/VGPoIATso6Vi6TgzyoytF4aSKTwqP6PFDko
	TV4vXEPNi8bCSirasSwgRcB+WaPozrALmgMQwvnL41fmvIrQh+5Qj7aNaTx4K21KCmS0Y5F2E6M
	=
X-Received: by 2002:a05:600c:46cb:b0:476:d494:41d2 with SMTP id 5b1f17b1804b1-4792af3f8f0mr35855805e9.29.1764788965255;
        Wed, 03 Dec 2025 11:09:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFhgPz1LwXKIK9gUIky6zh6dBCvXklfDlARyGYUIdzHtf8WfUfcAtSo1r79sgm4sQTPeadI0Q==
X-Received: by 2002:a05:600c:46cb:b0:476:d494:41d2 with SMTP id 5b1f17b1804b1-4792af3f8f0mr35855425e9.29.1764788964785;
        Wed, 03 Dec 2025 11:09:24 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792b150878sm27207635e9.3.2025.12.03.11.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:09:24 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:09:23 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 21/33] xfs: improve default maximum number of open zones
Message-ID: <btym4y2x5vt75pzbyhw666obsvpeogmmplawgiadz2st3hi3xm@btd7czv4tqyc>
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

From: Damien Le Moal <dlemoal@kernel.org>

Source kernel commit: ff3d90903f8f525eedb26efe6fea03c39476cb69

For regular block devices using the zoned allocator, the default
maximum number of open zones is set to 1/4 of the number of realtime
groups. For a large capacity device, this leads to a very large limit.
E.g. with a 26 TB HDD:

mount /dev/sdb /mnt
...
XFS (sdb): 95836 zones of 65536 blocks size (23959 max open)

In turn such large limit on the number of open zones can lead, depending
on the workload, on a very large number of concurrent write streams
which devices generally do not handle well, leading to poor performance.

Introduce the default limit XFS_DEFAULT_MAX_OPEN_ZONES, defined as 128
to match the hardware limit of most SMR HDDs available today, and use
this limit to set mp->m_max_open_zones in xfs_calc_open_zones() instead
of calling xfs_max_open_zones(), when the user did not specify a limit
with the max_open_zones mount option.

For the 26 TB HDD example, we now get:

mount /dev/sdb /mnt
...
XFS (sdb): 95836 zones of 65536 blocks (128 max open zones)

This change does not prevent the user from specifying a lareger number
for the open zones limit. E.g.

mount -o max_open_zones=4096 /dev/sdb /mnt
...
XFS (sdb): 95836 zones of 65536 blocks (4096 max open zones)

Finally, since xfs_calc_open_zones() checks and caps the
mp->m_max_open_zones limit against the value calculated by
xfs_max_open_zones() for any type of device, this new default limit does
not increase m_max_open_zones for small capacity devices.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_zones.h | 7 +++++++
 1 file changed, 7 insertions(+), 0 deletions(-)

diff --git a/libxfs/xfs_zones.h b/libxfs/xfs_zones.h
index c4f1367b2c..5fefd132e0 100644
--- a/libxfs/xfs_zones.h
+++ b/libxfs/xfs_zones.h
@@ -29,6 +29,13 @@
 #define XFS_OPEN_GC_ZONES	1U
 #define XFS_MIN_OPEN_ZONES	(XFS_OPEN_GC_ZONES + 1U)
 
+/*
+ * For zoned devices that do not have a limit on the number of open zones, and
+ * for regular devices using the zoned allocator, use the most common SMR disks
+ * limit (128) as the default limit on the number of open zones.
+ */
+#define XFS_DEFAULT_MAX_OPEN_ZONES	128
+
 bool xfs_zone_validate(struct blk_zone *zone, struct xfs_rtgroup *rtg,
 	xfs_rgblock_t *write_pointer);
 

-- 
- Andrey

