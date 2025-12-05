Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E4D33BBD2
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764947001; cv=none; b=Fa0s+1EoRpQqOdsVGXCv3mELo4sEloyTJp2FY/hhigPGsAPYz7KnfJIQ4daay54SckHUKMgemjO3mVtZtBZ6feGC/P4MxssdZC/bpet6HH/+ZmENyZ/q3baNUl2Ih8RuUpoUG7aIKz8biPFT0MApt7OMLv1igSI6r/WywYWMOoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764947001; c=relaxed/simple;
	bh=m31jT0Kw+XIAZ3XZMDTYVNL39AxVeT92e5gZosPwgYU=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mb08xW2ZzlFJG7Hyl6eUmOpBf9omIx791Qwjaxs5i+eFOT+EL21miQemk1taWzmVuFOLq0j69oOOxo9niu7pU/IJzFDKyHHRCfOd5whkmPOTMY1XRI645THyCIsrVDQD5c2ILj0UtVaCphLF9oSDyJcnpSIPhcyx0M2DGjMre+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b8iW9wb+; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PdYVBchB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b8iW9wb+";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PdYVBchB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=myd2cb6jiJMWmrBGk1+ROJ1AXszUUq3lTteTMN3MqJE=;
	b=b8iW9wb+JjRfPGORj3JAqQpYTV6oIsJuZg+zqg6r8h6G70rQHiaRs4cFK6DzCE+Di4nTMZ
	y7ghxWnYTWWVvwQ9ed9wtqQwJCovrmg7ct+4A70BOvJzlXWv6gy79/8VlcTBw+DZAvo3/q
	zaxCFx6QSJbASgc8AEPWsKZYidvmS9o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-398-qcoCYjhFP8W60cYYEAGHRw-1; Fri, 05 Dec 2025 10:03:14 -0500
X-MC-Unique: qcoCYjhFP8W60cYYEAGHRw-1
X-Mimecast-MFC-AGG-ID: qcoCYjhFP8W60cYYEAGHRw_1764946993
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47799717212so13878215e9.3
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946992; x=1765551792; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=myd2cb6jiJMWmrBGk1+ROJ1AXszUUq3lTteTMN3MqJE=;
        b=PdYVBchBRH7iEAH1e5Kl1sETs6cxkjeBJGylBZns1AQY3OcBc2ikEg+0i5QxZEr87a
         GqBJkzFxxnJvlXOSXFYfy6anm9lNq0PQfHl7Der2N7byeH7HK9v4DAgFoTC8nO3NLVRV
         rpJxsAhhMYEeTZCEXq5rHb8M+r7Rqs4eC5H6rbN4NKMStj168wlqiBMqcWqKgYnyu5/W
         r7p60iIeLhtQDHpWWaJ+fmIL0KptQQm4mOLDbEudm5FznbKK8qEBJkGLDaGZ45ITQMzg
         SGw1guKImfO8Y3lqVdHwY0pRgWA5y1oHQAUb8pyScVm0n9zvWHOJi1OQXDxX0exYA5DU
         5C2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946992; x=1765551792;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=myd2cb6jiJMWmrBGk1+ROJ1AXszUUq3lTteTMN3MqJE=;
        b=hK/gpGQhRccB3c90DW+mMiNhe/Z6LrL1G3LuhNF4BLU8TaalF1XiPachFnukAO1aGQ
         MbdmKxhoyuj+8KsfTpnVbS44sR5fcUk+Tzgxn+8CGWumvR/neSt511PSKHSX02dNgIYo
         MyI/d1lm3DFqdj6/1Qw1qwrbYeu81UbLm81rkf+I6HzAjnAYFt3uCvPPzA2dSVcN2HuU
         sPJo6nIlKiO9+CWHGMBUr072wXp7UjadFt+lVa0wrlkkpWi03MtAbh3Azex+lNbOW8xE
         do70dsaaUDRr4X2jtM1I5HVj0pxTiXcCKfrMoIXy4AVNIcCoWwpuAabHAtWxjgbl1yQo
         pDwA==
X-Gm-Message-State: AOJu0Yy+zHa0BNmlMDtciAv/whnlcqeZ6nSsNazweq+nkVTGrTjsCfMD
	qFGcaokQgVHo2HAqwsPr3DZ79VSex7YRMP2UG6pFY5r03uH1PaBqvQMqPVbS3CxflRqNfh9cn+A
	Az97HM5YUypJ+hzoSPs7myvcOkSrxPV0ovPvsmOl7MsRYtbZoUHROMS5P/kFIcZkdCeY6t/eBri
	UsB70Y9ZbmX03hfZ96vq6r79zhtV9lIlxyt9kmJnhrBy/o
X-Gm-Gg: ASbGncvh+evDQ1mFfCsyqos3pLDDK8UZ1kbPExKcm8wBWknJndla/7l/aCnPfahv4Fz
	YvU/zptMvos+mVCyAsj/AB8J+tMh4XX7QQ+19PjncoIkUb/vZ2QedjR1SnT3A8budX6rxvct2l8
	B/h/8GW5keKCn1SY540z3UiPCVTzrf271GblQiup0cD1Q69zDf+vpLexPbgbMFKVc9G0L3/SqDv
	U4pxHKS3iw5W4JPW09ecJOuXfhDgn7ARjaLDLA/4elqLldBLVE0d1G8SN7I7WIR9nWFdZp1S3HV
	scjSwRUoqgWrvAzaxXBu106k1ZmFxp9RFqKj2ixLWZmn+ikECFt2a4FJFw8iOLbEV9wZILQG4nY
	=
X-Received: by 2002:a05:600c:1c13:b0:477:7ae0:cd6e with SMTP id 5b1f17b1804b1-4792aed9f52mr94096185e9.5.1764946992235;
        Fri, 05 Dec 2025 07:03:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFFApOJpAPi0SJSb49K/nd0yN6jboVjNzsv1TlKH2ZXf/lJfcoRHmuwYulufDZSYJPxe/q//g==
X-Received: by 2002:a05:600c:1c13:b0:477:7ae0:cd6e with SMTP id 5b1f17b1804b1-4792aed9f52mr94095625e9.5.1764946991564;
        Fri, 05 Dec 2025 07:03:11 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47930c76edcsm87414915e9.11.2025.12.05.07.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:03:11 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:03:10 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 20/33] xfs: remove the xfs_efi_log_format_32_t typedef
Message-ID: <qthxvccwl66wmqmzodetc5xdap2kz6yo2qskdxgq5ttt6mnyb7@4kykby5bhbos>
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

Source kernel commit: 68c9f8444ae930343a2c900cb909825bc8f7304a

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
index 81c84c8a66..75cc8b9be5 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -649,13 +649,13 @@
 			nr * sizeof(struct xfs_extent);
 }
 
-typedef struct xfs_efi_log_format_32 {
+struct xfs_efi_log_format_32 {
 	uint16_t		efi_type;	/* efi log item type */
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
 	struct xfs_extent_32	efi_extents[];	/* array of extents to free */
-} __attribute__((packed)) xfs_efi_log_format_32_t;
+} __attribute__((packed));
 
 static inline size_t
 xfs_efi_log_format32_sizeof(

-- 
- Andrey

