Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1863C2DF131
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 14:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769005423; cv=none; b=A+IZBkw7A8SxxazA7cSo6h4863judVl6SfZukSCUawoT4G9GGcqjlU7IAQC3IftCbL0WmjIHvedKfvbIgGlEhoUCUcYML+rai2mA5Ucj5Wrz+iHyBxlftsOeP/zYygEbubjUM4nlb034B/Xnrb1nOUfsBtwSqGMU7HeotWhg+C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769005423; c=relaxed/simple;
	bh=nKUMXjOmLTnE+RfU3XyoOlaUilXKRnb6aV3RgZl3MWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JvB4dLgxcBp4NxosriSqfsU56MK7TAMtQ6KS0wIFToCQuz77MHiGimDDwf48aziE461SFTKNcfV0Pb0cAUMdL97KbS+aS9lMmjCF4apKujErLWuXMtBofFOUWIqk7Yq6G4jiqE4cvrk/dXER+7s9Mlx3eZvlrBoZLMa+MhM3/wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FMEPhyYv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UoIFnnPH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FMEPhyYv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UoIFnnPH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769005421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ffT6Evq9xkKRyRVBJ43QX5OBdbtSbykl1lCqzNla/MU=;
	b=FMEPhyYv0FNAFGI1ILoOBJvRivpPJH7z659aaKagxyQ+6BRr5oY8dvPJ72uSB90VDLDv1J
	hnBkogz1u92sPUOV08Cr0GHiSSThDxLkaTz/ghdRvGDDzD2L1jyuzMhajRlsX1d7eYccl7
	9MYJymD9/XrQ3EyXXvPd4XFifWUAp/U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-ZEXyt0svO8O4AucblvPZGg-1; Wed, 21 Jan 2026 09:23:39 -0500
X-MC-Unique: ZEXyt0svO8O4AucblvPZGg-1
X-Mimecast-MFC-AGG-ID: ZEXyt0svO8O4AucblvPZGg_1769005419
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-430fe16b481so4425730f8f.3
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 06:23:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769005418; x=1769610218; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ffT6Evq9xkKRyRVBJ43QX5OBdbtSbykl1lCqzNla/MU=;
        b=UoIFnnPH26a3qw83VrDvv8ZHi0/FuQCbKpJwqA7lfRAvvwI/yWB1s2e7E+L8jELUcq
         UVteg7J9McT0oNPpZcuK9tGJN7hf6v/yLh9AudWeLRKQrJGvJaTYcZ/+wwSrUhWbsvL8
         27BnXTXL7nGVWOMfwpe9KbOiRo1z/GfOlSm4Wcmp9kWTYYzsjZOn5B/UGdKsRGrGDFD/
         4jS1q298nvcZEUgPXe6dCVTFF8vRGSpdUpGZCNN3g58wsGKCn++iZJef8870dlO5jrHL
         farELbCe64Zt23icY2GFypueKmDJHmrUU/0uHdSbgmEKcaJAMJz/X0bIHPpLDQGprhzJ
         AR/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769005418; x=1769610218;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ffT6Evq9xkKRyRVBJ43QX5OBdbtSbykl1lCqzNla/MU=;
        b=m3SEp7Qp8kxV6qM+V0kHnv9CTVl0u/HrTkcS1JF4htCQMtTYlDogD0D77j/J4ibIwZ
         FoGFImH7SYmrbXHwHOVb8BMnWCtkh24y0hKrpoW0rRTkHqAURQQ4jBCPX+84Wu1VLe8v
         SD4jUc2M52YoPiWLJ4usvqAUER160fdT4CSs5jzlt2GE2iXR5CaLuUDR3j7WbHLvrxYz
         AIfjOunLzg7LB9aT+3/OIsORzjWgU+LZmY9If35yP7FY3MwlaCKdP9sxpABqpahd/bSt
         gf+s964rPDMaZKF/szjifrCOf5yyUA6l1VSI0IlQB/OaCTmECPJbuELjSikg1L8vWV0X
         h2wQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7EwPSKYYNeH9FXC1IsoQ2DzoOu7xJegOsqGiWUdyUu5xVwo9jxuLvN4FwoNCbe9uiSPEmr27rzWk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/HTRsMtr+9FzlT+6NV9ZCJTJbBCcb3Xap/rkJjYeSESS/ZgVr
	YaJCIVWT2x0+pXS3hzurrepKyYlkqYO8RnIWnWvXvgjH4bd16jxareBTb4D5ShWqwFiFgq5ckyu
	UkD3dOWNq27WZPKgDckFdG2MXMtmco7/Kcbcxq6ypD48NbKlyHUV+AwgpUMal
X-Gm-Gg: AZuq6aKYlgdgW2QHa19I+ehfYwX/G0rfJsKitpyxXE/aoFp1neOw68qftPFsP3ZFj2V
	jbqo0lWrIQ4khoBQB6dZW8/eIVQCRmzB385BJwrNaoILvy1OUTW8HYeA44L+ek/ZSXUpXyi++uY
	+j71u1cBqPOCZk9qaKjS+AX9PzxbZLtg2q9we8J88Ifp1hkMC00vsjHTApfXBFeU1qWyykXp0ih
	BlNq76gEm/5CboiMjvAocdyqKazAZALbsxoN6D/1t3blJf4rlioZBKMDTWrL42HKOhgoNG8usgR
	dbYy9Fmy0AQxasFDX7vwNZ7b/LztFvksToYBm7Y2QJqHfbySJjgErPLf7kpPCsZ5VNOgZfBv04s
	=
X-Received: by 2002:a05:6000:178c:b0:431:7a0:dbc2 with SMTP id ffacd0b85a97d-4358ff7cec8mr8739450f8f.31.1769005418366;
        Wed, 21 Jan 2026 06:23:38 -0800 (PST)
X-Received: by 2002:a05:6000:178c:b0:431:7a0:dbc2 with SMTP id ffacd0b85a97d-4358ff7cec8mr8739394f8f.31.1769005417731;
        Wed, 21 Jan 2026 06:23:37 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43569921f6esm36452697f8f.4.2026.01.21.06.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 06:23:37 -0800 (PST)
Date: Wed, 21 Jan 2026 15:23:06 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fstests@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v2 1/2] fs: add FS_XFLAG_VERITY for fs-verity files
Message-ID: <nz4xsllj46jv66y5ain5fu277umo4x44ijjjpiinel5jrkajsx@j2hr6kq65wcb>
References: <20260119165644.2945008-1-aalbersh@kernel.org>
 <20260119165644.2945008-2-aalbersh@kernel.org>
 <20260121003321.GB12110@quark>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121003321.GB12110@quark>

On 2026-01-20 16:33:21, Eric Biggers wrote:
> On Mon, Jan 19, 2026 at 05:56:42PM +0100, Andrey Albershteyn wrote:
> >  /* Read-only inode flags */
> >  #define FS_XFLAG_RDONLY_MASK \
> > -	(FS_XFLAG_PREALLOC | FS_XFLAG_HASATTR)
> > +	(FS_XFLAG_PREALLOC | FS_XFLAG_HASATTR | FS_XFLAG_VERITY)
> 
> This is the first flag that's both a common flag and a read-only flag.
> 
> Looking at how FS_XFLAG_RDONLY_MASK gets used in
> copy_fsxattr_from_user():
> 
>     fileattr_fill_xflags(fa, xfa.fsx_xflags);
>     fa->fsx_xflags &= ~FS_XFLAG_RDONLY_MASK;
> 
> So it translates the xflags into fsflags, then clears the read-only
> xflags *but not the read-only fsflags*.
> 
> If the user passed FS_XFLAG_VERITY, the result will be that
> FS_XFLAG_VERITY will *not* be set in xflags, but FS_VERITY_FL will be
> set in fsflags.
> 
> Is that working as intended?  It seems inconsistent.

Yeah, this seems wrong, thanks! I will send a patch

-- 
- Andrey

