Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F2233122B
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764947019; cv=none; b=J7d1odp5SzFaFu0JSLiYhuEyeOjJn41wukldCTy4p8cIACW63FaccUCUmkqNP1bJCjlOztQLDMPHu2lkeH04QlmhWLOHUkUpj5GYnQykVQHZTXlZeHc5byAJN4m6kZmP2kYsMxCJFKeA7e40WSpLksaPNS9h1QiBVqHX2XH3stI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764947019; c=relaxed/simple;
	bh=Gdvm7Tevs8jvvxNu6HHKxLKL8A3p+KTpec4b38NOUNA=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HNAW3GoJ9xXT3SpsitPm9suPbDCGeu73Zr5S6Xy4koVUw6fpzHllVzbUblNg3oa/oETsn1ST7MsYkLFzvce7JJ4z2BSDchgFwwRImCQFcHfSHgf8WR65YpoHWGUpAAVMhH6mhxny3tGW3kbAvAYy14uUsoK0J/hhdZBeZdcAv6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L076y9Mv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=P4YLLIBA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L076y9Mv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="P4YLLIBA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764947008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MoiUOYaaPLpm+OMIMXDmQLYs4k2eZZ4J3+2cVJLHUtc=;
	b=L076y9MvHLogkSE7R3q5p0WkK6IsrjEaGQ5EaxH+gKROD/B656qWSV+tN0l/ntb07ND3cc
	T3ZjpGOKzyVj6tYRn8jneXdtzBqViFL/rNrVG/xde+vpfgIjLa0tPy1W2hzDgF/1Ms1GUh
	uJ7R4LIVvuKaFuHLa8iY/bEG1JGO64w=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-RHnpdjZxPJKZ2JKTPFyM5A-1; Fri, 05 Dec 2025 10:03:27 -0500
X-MC-Unique: RHnpdjZxPJKZ2JKTPFyM5A-1
X-Mimecast-MFC-AGG-ID: RHnpdjZxPJKZ2JKTPFyM5A_1764947006
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42b30184be7so1055013f8f.2
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764947006; x=1765551806; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MoiUOYaaPLpm+OMIMXDmQLYs4k2eZZ4J3+2cVJLHUtc=;
        b=P4YLLIBAFQld32dLjl6FaYVQ+ensNZv3t5L4Ssg/F4Y6UCGWEslJc9oIxE3ayxLroW
         LBezfAZZIkMR439fwnoXj+8okhAdvqot0YL3rCMGIbOLH4m2Y+zZHMI908NyTNtcY5Y8
         BPP0LTNmgDtmYjKjXRA+tJ4mvNQsZq15LCzN8hY6Kn7QoBGt9UsEacAFeNU0vPKF2foR
         lIkAU0kX5KhYlV1+kL0KM4tbnA9WfeepVRLrtg2fk/APEN0w/IqVMUJyr0y4ticY4H/m
         wNFt8r8GRTTvvK5F1c1ee2pDpIiG6hhit0vDjgLai3yxOvP7sCofGUoGpj//n3lGG3I/
         Wwgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764947006; x=1765551806;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MoiUOYaaPLpm+OMIMXDmQLYs4k2eZZ4J3+2cVJLHUtc=;
        b=rIVC7yxKu7KNBoW4WWjvE5lQxPHriyPel2kwOtopB8WaSrnVSIj9N0aL4/oll2EuAd
         WB73dxdDPfGLEv61zDOEqqRXv0Z8SESWkhepkg9ig7mz62W1Y9gKnMVSZQMr5zPYFYTK
         6CqBH6aWQOch9D9naODE0vKjZzMOv8Ewsv1E7YwdfJfo4sZh+FMCdA5dLMeIN4Eex3Xm
         S/UzKuuDQ5njxsiLb5i9SBPj2AtN5CDfP2BvTRHqIZgMI3StKPZf742u9aX3U9mOG+Eb
         f57upldc1BJUDwGdTnO93S1iyLwiJR3xslHto/zZR8byFU8C94S5aLpNuTOFtd3pQWNd
         15rQ==
X-Gm-Message-State: AOJu0YyS84CklxAwaxWgygGKIKPELo3zDLTHVB2n24leBeY8yn0YuqpN
	AMXEs5HzuNQGD0XCZXsYYp22WbzN35CbN4e0zhS2pt7KcUVQZAdoFPp4IrCiFv1H/2TV1arRKj7
	1rtDKQeOt7lnVZTvvNfeRtTIXQ+O5d5Od6zsGjJcmuIg0Vg+NV1WoOHvS4p+spFSYe06zafXo6B
	QGrcTCSKnQLKG68pXJtiqXcwp29w+cvS5txlbQPT8koyGf
X-Gm-Gg: ASbGnctM1NKOo2lMCCQ7YgPkvyzvKN9KF5qiXwEzgxooRTZFIBAqGrytpNB4S42t3Jl
	lCcuPbVqeP98Y+DwEcxlwYBd6ORPDwmj34VsZz7GbtfxkCeOaXvHD1jKUDgojtYLbdv7JWansBY
	ZlrlgRfl2AoN+8TWgFIaC/B6FaqtS6CzqE3Um5sr9m5hcvu+NgrmBv7lpMdK0/JkbpDLF1ApCa4
	A19+EucJbXFPLQOYMPWGLNU0BWtNkt7pTVYJXWDuP/OXHZn2ZtCu3o3BBvSl4HTNvfJt21nD0Fw
	WZilxngAsriXWA/0MsAPQX5oQFfKeW7ywrYiNpRLCsKWbAz+IjM3vOddedbho7iO/LQzyz2Ajtk
	=
X-Received: by 2002:a05:600c:5489:b0:46e:506b:20c5 with SMTP id 5b1f17b1804b1-4792af406cemr98524245e9.26.1764947005660;
        Fri, 05 Dec 2025 07:03:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEk1f65n/5z+tKiLrty+f2uVBkQFDYr9gzX0C7MZ8pKqqUzOMNYwyot9cpvRGEryS6UiN5nTQ==
X-Received: by 2002:a05:600c:5489:b0:46e:506b:20c5 with SMTP id 5b1f17b1804b1-4792af406cemr98523805e9.26.1764947005093;
        Fri, 05 Dec 2025 07:03:25 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47930c747b8sm88934525e9.9.2025.12.05.07.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:03:24 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:03:24 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 23/33] xfs: remove the unused xfs_efd_log_format_32_t
 typedef
Message-ID: <vz6unvjqljn6ow2cllphml6caog6zeedvgfxu6xt4tisqewnuj@o5a4a37576e2>
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

Source kernel commit: a0cb349672f9ac2dcd80afa3dd25e2df2842db7a

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index cb63bb156d..2155cc6b2a 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -702,13 +702,13 @@
 			nr * sizeof(struct xfs_extent);
 }
 
-typedef struct xfs_efd_log_format_32 {
+struct xfs_efd_log_format_32 {
 	uint16_t		efd_type;	/* efd log item type */
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
 	struct xfs_extent_32	efd_extents[];	/* array of extents freed */
-} __attribute__((packed)) xfs_efd_log_format_32_t;
+} __attribute__((packed));
 
 static inline size_t
 xfs_efd_log_format32_sizeof(

-- 
- Andrey

