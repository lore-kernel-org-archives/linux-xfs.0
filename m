Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C818313528
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788889; cv=none; b=VmlVwOltIwYYU3vUGMxR739x42yHsWDWgdGnjMaWkW/LUDuO3zCnYIdKAaGShIkXPpX3BSOgGDNa6NkuazVG3Fq0F1sB7DKEAOh6uhbbT6fxMA9uHuVKbfqQSARrjdYyc0s1pBm+gbevyi41Sadr/Rgr/LFVZMIGHbKBieuEiJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788889; c=relaxed/simple;
	bh=Gdvm7Tevs8jvvxNu6HHKxLKL8A3p+KTpec4b38NOUNA=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QhLeHEDS832qU3RHNbiT3uWZ/Y+/i2iOj0VXvW0eBBxBLDzj9uQeBa2opvIv4ZndOHNoh1XyqAnH2I87JoEKjtJ9brUo61P2jpm5wD5pFFIGj6aZtjbaTSFM++K2VtZBrHES8BfiSE48bSNi2cLBK0G+9Uk7E2zr9IYnWZugGzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tm09al22; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XXrB62Qo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tm09al22";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XXrB62Qo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MoiUOYaaPLpm+OMIMXDmQLYs4k2eZZ4J3+2cVJLHUtc=;
	b=Tm09al22iFu+GOR4p5/+o4PNmYQiEhoghQlOjDNBzw2zJz9MhSk8CpzXZ6EXGBVDr8lZt4
	nERNvSQElqyYatiTLK4x7s5q8WDW60zRTDUyxb6EDU1JaOrz5bCUKeYDtOOhKDuW54oM+y
	yzn3kFN7NhmBCdY1se8A/VGOvxkQc4c=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-207-K70xjkpFO6Gz6_RXcfxSwA-1; Wed, 03 Dec 2025 14:08:06 -0500
X-MC-Unique: K70xjkpFO6Gz6_RXcfxSwA-1
X-Mimecast-MFC-AGG-ID: K70xjkpFO6Gz6_RXcfxSwA_1764788885
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42b2f79759bso72660f8f.2
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788884; x=1765393684; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MoiUOYaaPLpm+OMIMXDmQLYs4k2eZZ4J3+2cVJLHUtc=;
        b=XXrB62QoXBLazYw2/PsAbw4Z+XOM1SV0hISxs6xQ6qNH0CV3qKd+0ZjmmsLrCZqFYF
         1YvlucPZCquuhnhCydGjt0NvZyjoitUA30Ym8FOnVBbE+/PJFYucAyY1Chv71Rpp01qP
         fIAoAoy9pjuyjmRqxmnATrHWUR746nEb2hD+dc+4vN7TMapfyyCXCsrsHq6+SfTpnspV
         pdnAUQM5koJ8BBZt90eymdl+U1XxerniuDC6jeSxVPMy48rtYNAlfvKodJMt1iRYRMjT
         rdn1RxXRL4f6H/BMLKD9Yg0hbLA28DcLVMcz3sOBxQFaglhxtnl3ouhYAvsjS1QXJxXT
         uRhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788884; x=1765393684;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MoiUOYaaPLpm+OMIMXDmQLYs4k2eZZ4J3+2cVJLHUtc=;
        b=nOrn9Q5U8A4Iqy4uRuCXgzGauzVzHAaE18MF1EDl3woTf8KME1mvNQONjQsiDyRNuv
         l0HfUm5ksJMe3UWAkDvXuiup68REzUoM/3KGP74DzRP+fBUG4Z9WKocN+baVLqHhbntm
         T8JCB35w4vDV8SR7yhmUCpmVHGijz+SgrFVbpT5F52JF+vf170bVtZUn1Lto9OPR0s3I
         ciBkbRh/vb+yhmXsc7X0u6GShuOp/kteF0J4/sbR2EF7aLSZfQzvslcEZWYtGK4eaiQQ
         pbHgFcd599I0aWdJK6ZGTDtwpR4uMheWt5pgoMRUIiSihYWk1f4bWcMYtI4lILfqZRn0
         g40w==
X-Gm-Message-State: AOJu0YzM4Z7bftkBUQs2QF2tEijymFGXTxGfGpjuLG5rE4oSoL671Bnv
	9bmm0HelX4oqCM8WOEQa9BiWm68D56AdPAN9UmKjM1z/OJN/uTYCAHMRvMG9eGjc2aNWqBP6WZT
	CJORiCVAvXel38SRMgEnnqLED9wlTOSBxMhVrDYqYxzYhEPaQ3YUxUjyNx8JrSB76q9pu2Hg78Q
	8w6dxBLdaegKMwBAJSGT9aYyeBVgbbaS8NW0eZf4cAH+LB
X-Gm-Gg: ASbGncuN+sS8u06JFeqN82Ok1dy9cBUJWGYTvckVIhZ4loWV0Pe4nCMnpoBYxZjXQtG
	Y17q/OMOuaiPe7zSspyPAo6iz/kQKPdICxFfOOTEduS6C0HsfxTQwBVrQPH6BmoKmhEjeB7bMdM
	AQ2wI+xNW+Y2taf/EZdnNwh+be9nBzKOM/yFe5/1HxzbozHl9UAyRY4Ngpw9K4xy+VcnzJ2z60r
	9gJB61O6KlCacx6xTDpRCjNCJLavCUPoCoRr0oxyAkri8b3e1s74E7jEo3g3O34kTwevAwlanyi
	VWo8jhCBjBeEizlhiR6mvdUSZbwNKXbVfBG1JIMWDZmiWm3Q9NWrNa7iYjc24MI3zzEojWIPTKo
	=
X-Received: by 2002:a05:6000:1863:b0:425:825d:15d1 with SMTP id ffacd0b85a97d-42f731a2ee4mr3190713f8f.44.1764788884263;
        Wed, 03 Dec 2025 11:08:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFtDaWSmMRK7RvFrAkAfmFW+KFPwo24pO7DQeI8zOsbKZo72F9ne3QIvOTjh3Mj7xPhQ7hP6g==
X-Received: by 2002:a05:6000:1863:b0:425:825d:15d1 with SMTP id ffacd0b85a97d-42f731a2ee4mr3190681f8f.44.1764788883809;
        Wed, 03 Dec 2025 11:08:03 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1caa86d0sm39004939f8f.39.2025.12.03.11.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:08:03 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:08:02 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 12/33] xfs: remove the unused xfs_efd_log_format_32_t typedef
Message-ID: <tg2ih5bqskupzzevz7tphckvr2r44t2fj7lorfangecldj7awi@5k4zrpgtm2f5>
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

