Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB16147C9E
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 16:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713370625; cv=none; b=CNOgVhWKzWsdS+ImO1boOVyHNUPhmIXOnsaigwJ9c+cigZOUoQiHYqhym0awIPcVayUWCVhw7a6dRsANAs4gHiU7u+jPI2ADdei6krDnUHz2ya9+5Cm9kfP2ZCvWJGd167ZTzUJqDF2MddzyZggLZ0kr5W9kN4FxhTHRI9DFtWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713370625; c=relaxed/simple;
	bh=QHbXu60hIYPcu2upLEJCNpbT4ZuJuUjUD2HLvj70emw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JaTfELN0vq/Wn9IUxQXCDIRjO7vYZx9u0GQqkPfOTVhaCdedpi1HbhFShF4u5LEDPYSIwcO0RAIo35f65BGnakJhUnPeldRRn/W8ALbRMwytzzLdzPCdHDsBpnhErO+G2u9GncIGdzyD0lGwFDgkM/CuGfW9swrgRBgvtHkWoYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b/dyuUaA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b/dyuUaA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713370621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yVo/jy69JZgmk6ipt44yooon16rXmwikx8HeguITUzo=;
	b=b/dyuUaAoRIVgnGRT+xOi8+YxBxA5K3qdSn4oqf2f0EdYZ2L6OsvR2eW5l6HDjT5Bd6/6s
	JCzNJwmevc765kZH2NU3Aqx/isNdRVdLrDVBkXZEIgvxRhk2zbUocOBX0PV/qPRAeGarBN
	e6ToDZEJX/+So1Mx6dvP9hPuxbIZWGE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-9nr8PfHwPLuv03GlmVlJqQ-1; Wed, 17 Apr 2024 12:16:59 -0400
X-MC-Unique: 9nr8PfHwPLuv03GlmVlJqQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a5190b1453fso436918766b.2
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 09:16:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713370618; x=1713975418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yVo/jy69JZgmk6ipt44yooon16rXmwikx8HeguITUzo=;
        b=rBU4lfszz7orkt4e1djK4X+SwKBtHpWT+3dlSoSBo/NQe5cZ94o+yUgtpvFV6mHASK
         Cwk/P8BztWSOlhyIwzwV1PpL99SbsiasKkPgW5QC9cG70eqwGX79tY5XpHoGKJrxEyby
         S3bvn+UZCJy4FHGUat5L1wQ/+HejhZIDiqptlWw3FEvvOTMV90BRC+6GpMHY5kz1WIKP
         SZjLSm31maVpduwuEGXnp4aQTT7xsp24LSivN4tzcA2sncKdF5oOBF181r5vUxn9xtmI
         kn883wIUjXy3aSX0AuYrnc9hyPoNVu0yFZmGC6vUjdnnRTHFSA5RN13PEhqmtpauVcv5
         F8cA==
X-Forwarded-Encrypted: i=1; AJvYcCWqQUY17T/3ZjgwBW/nNQmWa/RAN/ZwPrqGHxaurxTfnXitZ+Y+TIHGYQAsIJIF+vboZDgGu28JcP5Aw5qEmpBMOtk4S/NseBW/
X-Gm-Message-State: AOJu0YxAlkA1l+EUxTm/H2j6oNzbsOaO3E4e9GMLn0VhkmQUwaLVYSN3
	RJOWGLmPpnWqurgMCQ+AisWdcbn9ANdrkDQGj7p0kT3Qtpn6mnKXwyJobF8+mRgYNmy19mNjT0r
	G6Kq+Haf2Oz+jNCvEGDmPGYCMbRBQvPJbFIl7iGwgaoIGOSiDQ2Czwr0x
X-Received: by 2002:a17:906:3c4d:b0:a52:28ba:2ce0 with SMTP id i13-20020a1709063c4d00b00a5228ba2ce0mr9803913ejg.29.1713370618033;
        Wed, 17 Apr 2024 09:16:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGaK62uD8GPwojt7NXkSkjuz2UK7J5F6Xr2kth4oPykFRYqeD4KDzzTQbNjlCs+orwMaMAL2w==
X-Received: by 2002:a17:906:3c4d:b0:a52:28ba:2ce0 with SMTP id i13-20020a1709063c4d00b00a5228ba2ce0mr9803904ejg.29.1713370617655;
        Wed, 17 Apr 2024 09:16:57 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id p4-20020a17090635c400b00a4a33cfe593sm8272427ejb.39.2024.04.17.09.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 09:16:57 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@infradead.org,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH v4 3/4] xfs_scrub: don't call phase_end if phase_rusage was not initialized
Date: Wed, 17 Apr 2024 18:16:45 +0200
Message-ID: <20240417161646.963612-4-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240417161646.963612-1-aalbersh@redhat.com>
References: <20240417161646.963612-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If unicrash_load() fails, all_pi can be used uninitialized in
phase_end(). Fix it by going to the unload: section if unicrash_load
fails and just go with unicrash_unload() (the is_service won't be
initialized here).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 scrub/xfs_scrub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 752180d646ba..50565857ddd8 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -631,7 +631,7 @@ main(
 		fprintf(stderr,
 	_("%s: couldn't initialize Unicode library.\n"),
 				progname);
-		goto out;
+		goto out_unicrash;
 	}
 
 	pthread_mutex_init(&ctx.lock, NULL);
@@ -828,6 +828,7 @@ out:
 	phase_end(&all_pi, 0);
 	if (progress_fp)
 		fclose(progress_fp);
+out_unicrash:
 	unicrash_unload();
 
 	/*
-- 
2.42.0

