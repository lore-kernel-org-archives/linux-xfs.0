Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B91627E074
	for <linux-xfs@vger.kernel.org>; Fri,  2 Jan 2026 15:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767368606; cv=none; b=fTI/TWlk4TXSwt3CANDPQLhhZSvrtJfx9T7tEM+1leH5flRFT2Mad5j+reyPIli0r5xNzmxSMYrysrh7e+5dM2H2GPuRw1zvxJ0OB1rwhmv18nJmJ2CUfAW9N10Q1tkyZSGfH/hJqMK5c67uTPK87cMk2bQM43Dn2tPx5w8z47Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767368606; c=relaxed/simple;
	bh=2dwqUFew7od2MeYUd4pMaUJl/7Uypsvp58tk38X2xak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sr6kh4MK1tKIcKt5GED7BBeW1/ltdKWghp3uRCOmdAWy+DcBTs1h+sZzPFHkmSiAJP024shLw/6gnsrX/3G3fYJ1feXmSA/hXBBj3TlplFYsY73mtNrfME1fQqkju/MEVmrBULcBZViAdtQFfWIAtf3Xn0GXR3CU6114Rdn3myU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G4q6iuCR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=tsfuS1bo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G4q6iuCR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="tsfuS1bo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767368603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ubwpuamFY2AQrzeCL3bViI7nLkU6HgXAqKdT43+8US8=;
	b=G4q6iuCRtXskn6TXV0cmShZXU9VsMq3ynG0F3DcyjoWdSALBUREbLC5IXYJtmKpoJthH4U
	N0L88wb5xFJjbdsT7PYjTgqc4vMraBSGcNZTrytMg2Fn6KZJsJXFpkMQD7ETKVQUeMdrHA
	XGQxUaYGVmaVMV7ksCgHi4C+3WYelRo=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-58-YfLHEGWfOZCt_ZDvkzEKZg-1; Fri, 02 Jan 2026 10:43:22 -0500
X-MC-Unique: YfLHEGWfOZCt_ZDvkzEKZg-1
X-Mimecast-MFC-AGG-ID: YfLHEGWfOZCt_ZDvkzEKZg_1767368602
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a0dabc192eso280233985ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 02 Jan 2026 07:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767368602; x=1767973402; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ubwpuamFY2AQrzeCL3bViI7nLkU6HgXAqKdT43+8US8=;
        b=tsfuS1bonYV+ulYxe4cFsuH9z1b85Kkb0Ro6vqGfLUkFWfBZwQq6c7z8ZBGah951Qp
         5wjm5xelXbow58BfiomC42jDoXJ+Lp69BY8Ipx4DZI2QAjboDK8TxuLbbPJzX0R0LLNW
         bzpRZYLYpLpV21LbqV/m81Zl1fH7wG8ZoPvEeLrhGXqIf4O+SO7+xfa3O6q3D/MA9+HS
         3uRZB5cWupTlVtcq6wX1ukqr00YIWjXT/ng3wkuslLRQ3/DbH1AQD9d+daVQ1lSmUD0I
         nLvhn9Zn1N/UUZ41ayNShdepAf2RHwhglhCulJ+WZJVyGEuOO8SsGLlxv5f17GjGgtlZ
         9QMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767368602; x=1767973402;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ubwpuamFY2AQrzeCL3bViI7nLkU6HgXAqKdT43+8US8=;
        b=S5u9TD+02j/qLVo11QoWblpWmxaYBv576qgTFX2n2Va/FYi13hYUpJopMzWIpwhBRt
         XaoBMy031Qm5zIZSHnvpu5e9QXg+0H/TYlzHmCWp3QuUwHOdhwyRzWXTR0xWAkYQg+k7
         Q+VUPPe7pTPCnTmRlQH093/Ym6qfwszbHOFadu40V3oiyDoU8S0HHMGCpMPGYYodLvOK
         HAkBSi3z9+ivgYO4SOPMM6euoEWpwoOD6eWyrha29uP1w2X6WvEhETEh8ukf65ilVH6k
         xZDuLQJKwy5KxDsuuztyZ0CCxnPuOmB8cUyzniJKVhgP46vR6CzG+iIgNUGRiK6maR37
         CGDA==
X-Forwarded-Encrypted: i=1; AJvYcCW4wztEl+amfebZ/8M7vOTYNyxdv2BhSLJX/lZRYKBtOKY1ZL4ewXeQusGVQfCRO///Ru9HyOi92Aw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyqGd4VsZyCsa85xkijOS4QZpT6P+D5y+f5F50spSxcTT6GKB4
	JK1GdBGIvfXel+kWTsfrzEviYPZW3LP0YQsqSW90TO5XuMfPZZ3RnxJotyFitAGN15RZzV+VN4/
	FgCm3wZkKAdTaa2xyECmcsIPSTCx5XADzcUQW5oyeXWKxpcj0RiHlr0J5U3xyMA==
X-Gm-Gg: AY/fxX4vWDbwicQ/ymWUwUSulPqkWdWxhDZImhAQdWoKiVHHgZFqnm9NcyVXfFX+BSf
	Ov1G1kidpArQON5nvwl7RydzkwyJMTWu1Zb+/7JSGBorF9mti30DztcW6jwuU4IpZHd7nzgrIzl
	Fyvwv0aa+iBLew1bS1/Unz7OCV3NaS6Z4kQwT2b9npSOO7SoXsJJTZ4KbI/zoGirL3fw8KFvWGc
	5xLSkB+cJmxZBEtnWNsPRXOsRsqTO7yUpHWWEXVscLVegYkWDPskgHt1Mb7UOmm9Dvl+SVSe1Y5
	+4ZwlI2whDAd/d2OXuL/ohBB5SSw1lHaWnoch0CJsA26k6zD/2moaNXXIU1i0K2UBDuUISSNBt8
	7H673HkaE1oVlBnrxu6qi8VbiI+U/9zAWYrxv7qHCGUKdnJjozQ==
X-Received: by 2002:a17:902:ecc8:b0:2a0:f0db:690e with SMTP id d9443c01a7336-2a2f293b522mr444812245ad.52.1767368601630;
        Fri, 02 Jan 2026 07:43:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF0OCIb2Th3sRmo68pWOrOUpG3BBs23phZVPVnW42Vu89iwm2I8ZmIncZdMhhMDBnxhtTgAkA==
X-Received: by 2002:a17:902:ecc8:b0:2a0:f0db:690e with SMTP id d9443c01a7336-2a2f293b522mr444812015ad.52.1767368601080;
        Fri, 02 Jan 2026 07:43:21 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e79e05712sm35655650a12.14.2026.01.02.07.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jan 2026 07:43:20 -0800 (PST)
Date: Fri, 2 Jan 2026 23:43:15 +0800
From: Zorro Lang <zlang@redhat.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] punch-alternating: prevent punching all extents
Message-ID: <20260102154315.nfh5kdiz7b5cuswq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251221102500.37388-1-cem@kernel.org>
 <20251231184618.qpl2d32gth4ajcsp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <aVfHvxvMVbS7phq_@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVfHvxvMVbS7phq_@nidhogg.toxiclabs.cc>

On Fri, Jan 02, 2026 at 02:36:01PM +0100, Carlos Maiolino wrote:
> On Thu, Jan 01, 2026 at 02:46:18AM +0800, Zorro Lang wrote:
> > On Sun, Dec 21, 2025 at 11:24:50AM +0100, cem@kernel.org wrote:
> > > From: Carlos Maiolino <cem@kernel.org>
> > > 
> > > If by any chance the punch size is >= the interval, we end up punching
> > > everything, zeroing out the file.
> > > 
> > > As this is not a tool to dealloc the whole file, so force the user to
> > > pass a configuration that won't cause it to happen.
> > > 
> > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > Signed-off-by: Carlos Maiolino <cem@kernel.org>
> > > ---
> > >  src/punch-alternating.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > > 
> > > diff --git a/src/punch-alternating.c b/src/punch-alternating.c
> > > index d2bb4b6a2276..c555b48d8591 100644
> > > --- a/src/punch-alternating.c
> > > +++ b/src/punch-alternating.c
> > > @@ -88,6 +88,11 @@ int main(int argc, char *argv[])
> > >  		usage(argv[0]);
> > >  	}
> > >  
> > > +	if (size >= interval) {
> > > +		printf("Interval must be > size\n");
> > > +		usage(argv[0]);
> > > +	}
> > 
> > OK, I don't mind adding this checking. May I ask which test case hit this
> > "size >= interval" issue when you ran your test?
> 
> None. I was just using the program to test some other stuff without any
> specific test.

Sure, good to know there's not other issues :) This program is a good tool to
do some other tests, especially creates lots of data extents effectively :)
I've pushed this patch to patches-in-queue branch, will merge it in next
release after testing, feel free to check it.

Thanks,
Zorro

> 
> > 
> > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > 
> > > +
> > >  	if (optind != argc - 1)
> > >  		usage(argv[0]);
> > >  
> > > -- 
> > > 2.52.0
> > > 
> > 
> 

