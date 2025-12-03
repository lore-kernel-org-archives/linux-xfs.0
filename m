Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF436313528
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788930; cv=none; b=XsCVi8Dy9zBFeSpIo9mC4GE8e8ZfN4nlGraq1tCOvM0DRgzeYXL7ymAL24P1w6ou0VQBPjJoK0hxQOvUCfBSPfdWMHdcs3nY2QwlHczZR69uT1W63JJogYFpkGicy79l5yp0hi8C9Am6qvp/VT3evJNsmgQCt8VUzTo4lXJUG9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788930; c=relaxed/simple;
	bh=XNvteBMgcE6xrUVzGm5dqXZ/wFTGDrTsUfF+Wu6Muvo=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tmvwk0SN5vcxChECPHlNdPwshPMGJCOxoJezG3OmhwdcSElh41dNU+KB/klY+kVV+Zuw5JPo5ABWz0i0pyn+SMVGRMjDV/UmYxovAGqjApdTqiyqKvocemukbfTgVQ9eMAnBVnpLn06fbtKC5SBMqFLUd/Ps0RKvT7Rv2fGsxEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NjkgYpWB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Or/FcjGD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NjkgYpWB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Or/FcjGD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JJTEz5PCvjJ2xbRrWFvtltZR21DJ2tAKhsGrD0F8HT8=;
	b=NjkgYpWBAaeR8Gg5LlXgwzpa9Q6Ji/7jGX9CMrQdHWjqEbxZYX+ZDAe0l/iEVjnBOfM6eO
	cE7gKO4vdPMueD2ll+LesH72gxT4lwunrM26yvJP4wEc/cEIUMQV5PMXhkaxux9TdPhdi5
	2eu56Or5Z6/Th41QxNXeWX3ODXNsh+8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-yMtQfbUjNnaVsvJuEQkw0A-1; Wed, 03 Dec 2025 14:08:40 -0500
X-MC-Unique: yMtQfbUjNnaVsvJuEQkw0A-1
X-Mimecast-MFC-AGG-ID: yMtQfbUjNnaVsvJuEQkw0A_1764788919
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4788112ec09so522965e9.3
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788918; x=1765393718; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JJTEz5PCvjJ2xbRrWFvtltZR21DJ2tAKhsGrD0F8HT8=;
        b=Or/FcjGD2gz+0TnBIepF0WxZ8Jq92HRogS2XwBqq3j9CXKQqpyUrOrQNZnqMTjz/fz
         AKPsUdwGLpcOBjbKBAN3/e2GYPDGFgxfvdC1z5BAZ3+R9mEHraBDF0tXoiiZydWr/+Wb
         Awp7me0cSiY9RdDphyIYIDIS0eZyibomwozszmSct8pPh6UMchg/mzREOmo4nZ1sfhiF
         DfBwYM1r3mY348ONLqmNUjjRgSGZuSyx+CsmFDyEcLIYgV8U+mP6NwWPwupMceFS1uMl
         mRgh24T0+bBOPwhAv0GWvNyYfWc+ndmcBAr46MfR3tewjwdSZHg5w9C5QIaAlYaGoyJN
         hasw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788918; x=1765393718;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JJTEz5PCvjJ2xbRrWFvtltZR21DJ2tAKhsGrD0F8HT8=;
        b=lNk2OlmfOvXzEW7WaeYrMdMtkt315zb+7PRLGukE+yDqzU9bLVIM0MiVAXCbu14k7y
         NxEzXat4LJPm9tg//9CF5X3CflzjIrVQAGe1eC2rv7ERKQBr95bbULeUITrkf0QT4fLq
         zJcBJk4lo9FrL68wXy6v4eiVSAUB74nwYD6T6SXsOdCAfhFKKVVB27Onj16qoY0Ee0vx
         tsfDe0lHTCKocile1x3n7zb4rNGMa8i5O7yb/Gpg/GSyDSjk81vcUbuknPSjMdXRN+XD
         ZDO+oR5FmIH6tFQt+VrOMozBDIWMafO4TBo7YShs8jYUxK6wECVCeAvsdJCVdT7GVqI1
         zyeA==
X-Gm-Message-State: AOJu0Yx2dacVE8Ab/e7mtSkn7VEK5c/XgE+gxe942ALeCeG4QzlI5dVE
	FnRM6LHalAUsdE4X+mnzza8rvs/ArrwkbuaAryeQB5YkogE6xM2v5ibNnQWc/WviK9FMwxxaYyH
	xXC/cPK/TNBSVKLznY6vg4NHr3vIqsDipayKIB1jqcnYbVCzqMXcsqGehrr2zER3mrp3lV5h8Vg
	g4sxR3VuJ8B/yOhikmp9+U8aTjdh95I8t93RCFNu7TgvNq
X-Gm-Gg: ASbGnctREG+XGy7m0COHXLiXJFXeWJjVvG+YwJ5ObX2vOC9ua1M1IfQ52RSBXEburH7
	tOGXHDA3hRPEuxG6LXJyx6VJZjn9Lm7eL0rAQgHCuq5kB8CgvVh3W/e+gGV7MOLfd4/D6vLUOmC
	80jioXuFrSj7SnEdwxh5V3tWRkwm+TJOBGflS0UQZd/MHnI2OuIpPAh3uzWe+fsz/KeB0jZj2yM
	Y7v5ekfbDizSWLKWq5EwkiQbVJjRmL1y+zBuLaytFJS9hbF3Hi07XS6nxqqTC/DzylnFNHUKB4e
	+t/vcqo1kN27vYllTcz/oMxiTmKaqCn56lpIRkro7yEHK9egNBUjGy124jEFf0QnpqAsIQpJ4pQ
	=
X-Received: by 2002:a05:600c:1e8f:b0:477:a9e:859a with SMTP id 5b1f17b1804b1-4792f3861bdmr1558595e9.22.1764788918396;
        Wed, 03 Dec 2025 11:08:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH7StX2NtnOju+FEutAqf8D5yv0UzqHEWJbS57gBeP3MBIiYKXOzwbtL7REEz0gbnA0lvEs2g==
X-Received: by 2002:a05:600c:1e8f:b0:477:a9e:859a with SMTP id 5b1f17b1804b1-4792f3861bdmr1558235e9.22.1764788917862;
        Wed, 03 Dec 2025 11:08:37 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792b61bceasm24286115e9.2.2025.12.03.11.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:08:37 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:08:36 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 16/33] xfs: remove the unused xfs_qoff_logformat_t typedef
Message-ID: <ahzsumwdnb4cju2oyplss5lkajm6j6co6lcg6ndjno4m5bjfd4@hm6sykmywgvk>
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

Source kernel commit: bf0013f59ccdb283083f0451f6edc50ff98e68c0

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index fff3a2aaee..49c4a33166 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -974,12 +974,12 @@
  * to the first and ensures that the first logitem is taken out of the AIL
  * only when the last one is securely committed.
  */
-typedef struct xfs_qoff_logformat {
+struct xfs_qoff_logformat {
 	unsigned short		qf_type;	/* quotaoff log item type */
 	unsigned short		qf_size;	/* size of this item */
 	unsigned int		qf_flags;	/* USR and/or GRP */
 	char			qf_pad[12];	/* padding for future */
-} xfs_qoff_logformat_t;
+};
 
 /*
  * Disk quotas status in m_qflags, and also sb_qflags. 16 bits.

-- 
- Andrey

