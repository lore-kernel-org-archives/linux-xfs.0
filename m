Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDF333C1B3
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946973; cv=none; b=tMqoiJihVAJhJ5gaP68koNui85/DqDs6GTJktP5xry5OkdHP8uh9WhbtTyrgvYCDlpx53lHkxcU2+NuLq/JG07bIJB2cIp9wXVyHmMeCZrFOXOwX4J3gktCuPGQ5ufCeMFGY2NtjZA1T4AbrvDFhZizE2xullvOsFrKOeEZRAUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946973; c=relaxed/simple;
	bh=zAPrLrp/nZu096eNSL/tKAj9KjbzJmwXHOQGy1Ebrx0=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tTLv+aTjcerbKw187Z+lKoXxVjsN+m4EZIv+CQ4NYC9BQlk3M1HM8Ho/qhVvz3TO5KIokNAxCYw+yIJTYcXuxe2enZBQN81l6wHa0SIlmn2qUhr2oXio5oNePtJ93cyZVuc+cW+M+Q4kZl0W1be06i9aApidsu5gCPv1N/WVi1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c1/GCcm/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZWZPAXO4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c1/GCcm/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZWZPAXO4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RkXDr79WF7Y3PMsBfiOkflmYEk42gjxHVO1tHCTaoUk=;
	b=c1/GCcm/9fjaKATa6KctU1qsRCFDWM/ZvIQ3tPGvq7thxSYwKFk0VPGRwfHudY+0522388
	33PZeKSVeScypn2f2euhswhECBHtvvTQ4pPHQ23Ij4d1FatPRQKoyTI5MHQDX5yrgXyG0U
	aGXdEHV/yh1bSkeJ5vXgZJ61ibA4biQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-LU5ych0-MZGI7jrZoiIGRg-1; Fri, 05 Dec 2025 10:02:40 -0500
X-MC-Unique: LU5ych0-MZGI7jrZoiIGRg-1
X-Mimecast-MFC-AGG-ID: LU5ych0-MZGI7jrZoiIGRg_1764946959
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477771366cbso14737145e9.0
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946959; x=1765551759; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RkXDr79WF7Y3PMsBfiOkflmYEk42gjxHVO1tHCTaoUk=;
        b=ZWZPAXO41+o3JzAx2kBwa9KY+S/ksIgpKCQ3KodvclC926dkSxODEQUgAyOjjiVfrA
         w4XP8H8TNcvOsOxfUTUuWHTA9P0mLNEe5l2AgesvLoXGbAs/LfS8kkZgaYaM5izhK/L+
         81ZLihE6d8Ls8fWnIbAI7Sjl16LAp4ajIIFAhmuWG39qxzGcl2iptVlXoOJnCjJ5HOSI
         xwhH+8UvJGHVqWpSZqTzW9JELQtuDUY5MNWF+fJVs0c4hNWnnZF13G8nLqoPTlorlEFY
         FiFOhpVWXOkFSdKWt7wpPe5nIGEx2BMI8urbgHOwKIdfqUJ1YS/1rrZRGQumsNGfBHwm
         DXcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946959; x=1765551759;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RkXDr79WF7Y3PMsBfiOkflmYEk42gjxHVO1tHCTaoUk=;
        b=tBHptWzfL4XA0dCKpYoMxr4lHiMD07/NotNCiFm3je5UuktBGEukETxvJ3dpPQcW9D
         Myn2D3MxdMQjahb3P8yS62faHirJFWet/5rt+aBMo2KMFQUNvWk5U1pPMht3roQud+8J
         x26d7lLVc519GRQNnCbW8heWhDUj99LYC+kniTPZKyt3PUVD2Xui0rYCtkTQC3f//Jrw
         23Z1q5Ut7MXEQ7Wl64+h9AVQpj7gNyNtqY+p+bAJM6AgHQFZyQ2lic9ROQdKaHT4dXI4
         b2s9xeeJ9lC5Yb0DnM5dQA/txyW5g8rkVkBNTBPhkASPrY0mIEur0F4+XTzKWt8FdB6/
         WCpQ==
X-Gm-Message-State: AOJu0YyL3lQbtQtdHRmtyHMa/7kvzzYR/02lez63Xpcm2Vklr3khGtYQ
	CjeIZTPVYmUk6IhrfziToh+siqU/IG+6gpsxvynU0yFeYhpDIv9tpCG04r0nmPTLjkaaURgVseE
	apnZL4hPFkxvxKbSnv233MX1qFNSWlAJ3EzECic1+rO7d5Z7ySPX0V+gRiArItDs0OtsOFLvJPA
	oFp3QAN/MDW8C7Q3EkaWq3zyJevtGmRw5/jtEkmbAcHurJ
X-Gm-Gg: ASbGnct/NNsuEnE5PJA2TYr2ZKup2i6xg1u0azuHqdd5azlp0emtpd5rShdF+NkGD4k
	5C3gG5YCLhLcPCjT8Pad2qylBcUq11heVaKOb3kEigheOEOclsM/hqxE/q42Emi1rKwRyN0lr35
	Kp0Ly9Pxr/RWR2ec1ugnduEVPiRHmbFhE+4p39gPpGG9Tvt1xVrkie1ELrgW3SbJn7xK12cU1hL
	Hi2Azb12GrXEJ7f2RsZUQ3X+c/S92LgRgT7jMg2fDIDro1UYxW2gnWjIx9OM7fWSu9mmd2llZBP
	i1bCKjAnIPGtdgboVvfb30zE7hYcIQKk3OJab4mzt9oLeSlmy0B/fDo3fWrnmNzfvor1AljU36Y
	=
X-Received: by 2002:a05:600c:3b9c:b0:471:14af:c715 with SMTP id 5b1f17b1804b1-4792aedecacmr115195895e9.3.1764946958633;
        Fri, 05 Dec 2025 07:02:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGYjRSTkRE13RMm/Fj7zFrGJK9EvYwJqryF7T7RmbpByZWTuZ4mVDMmNOACsOvyGEIcuI/jIQ==
X-Received: by 2002:a05:600c:3b9c:b0:471:14af:c715 with SMTP id 5b1f17b1804b1-4792aedecacmr115195435e9.3.1764946958167;
        Fri, 05 Dec 2025 07:02:38 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479310a6db3sm92330995e9.1.2025.12.05.07.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:02:37 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:02:37 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 13/33] xfs: convert xfs_efi_log_format_64_t typedef to
 struct
Message-ID: <vcuamfjeymo2i7xja7okvzxo36fn5hzuuodxqn5u7n4pdx5cyj@64ltdnowhcal>
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

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 logprint/log_redo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index cdd6e8b763..38caf5a25e 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -43,7 +43,8 @@
 		}
 		return 0;
 	} else if (len == len64) {
-		xfs_efi_log_format_64_t *src_efi_fmt_64 = (xfs_efi_log_format_64_t *)buf;
+		struct xfs_efi_log_format_64 *src_efi_fmt_64 =
+			(struct xfs_efi_log_format_64 *)buf;
 
 		dst_efi_fmt->efi_type	 = src_efi_fmt_64->efi_type;
 		dst_efi_fmt->efi_size	 = src_efi_fmt_64->efi_size;

-- 
- Andrey

