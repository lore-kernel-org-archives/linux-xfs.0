Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B98423370F
	for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 14:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753800912; cv=none; b=LvascxWT1foGg6NSNcgiIlmvAomtU2jwTHErQoX/vasQWUr5PcSe7GQ957AcAnCkB+RTe3/etRw3q4biBrepYGDgxhqhvIXIuvMIFPigjudsYx3gh140g1Lc+nVKA7UtbmMhHsvg5T5ObGJxQSXiDF2DCn4Lgh5k+Zv/STyEjIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753800912; c=relaxed/simple;
	bh=u05V42ByiHjQvOOi9BsBHGHDUWV+gNVZB5dFW5EZ/+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OxX46ciaQhfD63I5KDOQL6DQs5l4zmSJaZcamN1PhbiekSwHLIRRNMefpaGhIsemI1MO8b/ARNjiwowGMb1d+yd4vzW1XYperDRw80F5E0PqSO6chA03/2l1zzV6h/yfNNyvqIA+63l7L6Ow7H9+or754s8YS3C4xJdbE/OUnJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=awton8Ci; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="awton8Ci"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753800909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XSrzENXEUqAG4xYhi7LkHLNBglJqdLHYS0/Iu08pFOM=;
	b=awton8CiDoaaPQD5iWcJ0Dpb8vn86MSEVYfrD8T/AExb29bYujbplGG1s1jZTdyWXLxYAL
	aM2uuJmb9Mccol1aGlHOwz2FEvzOwK6QFI1HM6fL3bw48UYksiF4X4fTAupb6YodS8pM1O
	2wIU4ymmWrHLXpGgjOOoLusDpi2dnFs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-r6rYm24VNQOkVv2Ejf-Uew-1; Tue, 29 Jul 2025 10:55:07 -0400
X-MC-Unique: r6rYm24VNQOkVv2Ejf-Uew-1
X-Mimecast-MFC-AGG-ID: r6rYm24VNQOkVv2Ejf-Uew_1753800906
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-ae401eba66aso374426866b.3
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 07:55:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753800906; x=1754405706;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XSrzENXEUqAG4xYhi7LkHLNBglJqdLHYS0/Iu08pFOM=;
        b=J3AS6brPEU+fcQ1G38Pzd0p6ROhe2Gz92MxxL7DStYX707TJpdd1a2yISFphc49p79
         y+ooTDKmNlwDYMngYGrV//BiXY6aiUhcYZiI64bi6Y3PVwmwqzyPKWanaUN59hDNA2Rf
         WaU5BVOQyBG6X4PviJDpd5ZLFs3LHt/7lInPWOdEgyf60f58cYQu/sjbW2Yalnm6FWG2
         PZ98CyrRuZVKj9OkttEX8Lp2ZUuxg/51Zk37cf+JFNt7gvX/fCuGi+etTmNA4r0v8dyG
         dw0i/9cnAs2qYdhKZwlnW2PNGLgV6OG4M82ZYSlKz03ZRJCzfjrn/+p22u2IrS624mPi
         fSaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUijbUzVZyqr2+se3jJSkb2oWFXJeN2xhA/PsEMqX4hKUWlalLaNEBgtpRCW8HoeVLfnkHkeO6/M18=@vger.kernel.org
X-Gm-Message-State: AOJu0YzajejTW3FGklOcBMshODpjlQrzWh5FmIFQBahzgoShwXbMiE83
	SNhrU/FECg5Kzt+arho9KCRgvr2n6EIqoChlDH27oLPPIeYCVkotGZ6VX4BJgeqEfDkjIc5HSkX
	rfjUub32l9BtW1xftrHBpC6mjbK490dfQwKZbVxd146Bt2FAzsZLhhaYa/DzBTWxc7OAf
X-Gm-Gg: ASbGnctjkANW90ZN7MF/SlTQqiAzKSBAjM1VTxb7kvtWUgI20N/Ps0qBUrptboWl8cQ
	7l0vo85tqdJZfOer1/G9UpARRiu5O1HMXGQf2KZuzvW2tQaz5goW0u3bDZkrmw7Uqthh/XrMhga
	7o/bVtmAfn8Gr+IbfsAdtax7gZ3SfW0Kq2hZGG6uaux8rYQf2K4ZCfxR5KSGjQw0V7DB21q8IZF
	vjicVaT0EgpL8eEo/B+Ydd0gMognClnIzdZjXFcQ5O2mSGuieoYAYPnHwJ1nNDHZmsyHaaCRZbu
	Y5IcmrEwjJX1A53RMVmYxkoTcm0/GanzwuUubv556LYbkiGbjr+23LJiaRg=
X-Received: by 2002:a17:907:948d:b0:add:fb01:c64a with SMTP id a640c23a62f3a-af61e43b3d5mr1708809866b.43.1753800906043;
        Tue, 29 Jul 2025 07:55:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFHd+MoTgpSO7r7vlcoVrPb9CgpUhhZOR4sUjxNgI2hnZPxiAUyPDLQeFa48qmlCH+6mwgHGg==
X-Received: by 2002:a17:907:948d:b0:add:fb01:c64a with SMTP id a640c23a62f3a-af61e43b3d5mr1708805566b.43.1753800905618;
        Tue, 29 Jul 2025 07:55:05 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af635a63116sm603133866b.90.2025.07.29.07.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 07:55:05 -0700 (PDT)
Date: Tue, 29 Jul 2025 16:55:04 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: allow setting xattrs on special files
Message-ID: <bpj4pnks3d4uswsjjtjlcuczvinkyzypxaswv5xhpn6vnfyec5@ngfiv2stkbdn>
References: <20250729-xfs-xattrat-v1-0-7b392eee3587@kernel.org>
 <20250729-xfs-xattrat-v1-2-7b392eee3587@kernel.org>
 <20250729143254.GZ2672049@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729143254.GZ2672049@frogsfrogsfrogs>

On 2025-07-29 07:32:54, Darrick J. Wong wrote:
> On Tue, Jul 29, 2025 at 01:00:36PM +0200, Andrey Albershteyn wrote:
> > From: Andrey Albershteyn <aalbersh@redhat.com>
> > 
> > XFS does't have extended attributes manipulation ioctls for special
> > files. Changing or reading file extended attributes is rejected for them
> 
> "extended file attributes" or "fileattrs" as Amir suggested,
> but never "extended attributes" because that's a separate thing.

sure

> 
> (no need to drop the rvb over this)
> 

Thanks!

-- 
- Andrey

