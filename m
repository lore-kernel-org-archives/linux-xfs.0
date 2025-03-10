Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEF01CB337
	for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 08:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741594001; cv=none; b=hNqTKaAtj+6eny8VpJbe0MWSSePjil6kWvvTEpE275zleAaaZ/v3o52PNwS4TA6bv0yCjy9QN9ywyHEdta80kuAYwukCNzcpEZUAGDDeRXA+OlIWIQb7XOss59owxM0V/u2aS6OU4V1MF5WU/fIZkSWPisWTyjrsQqRF5X7fNic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741594001; c=relaxed/simple;
	bh=93W6ybCwcYA7AqE4AGQacqgIe8KHvftkYc5f4XtCDwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M4ZlBWCbj3q7wytAe0jD+PUJLp3YR+M+NTXkEYHBTaA0ejmzcqgT3X+XcISKnoxzRuocRduCM2mX2L/Go1ht0av/HmCu1GU1Oxq8BuCKI8jp5CsVpsCg+0NIB4QT8BQA6wtb5YEyBo5OhPS28PPA4kYVbTEpQdzjzuA/XqGRVuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SJt47uIL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SJt47uIL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741593998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RCOLOU56jiLb/4wdgy3TIcrzpp/26Wu5xoarM9qeWc0=;
	b=SJt47uILYl6R2MXsYZ1KOD2Bn5YjlR978EL9Jm2iJ2TyY/X9Bsr+KqQn6q76CXZr6IMLcZ
	OfnYBhR0ugsk9rdfDpxs1aStFbTt74nihdYuKb+MepgZSljOlZvqia/Es9pUUwacHR39fx
	mjpOC7PfDQITpK0yMKSFqaLJvRx+/T8=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-thKILgTnMEW5ulvCGk4W6Q-1; Mon, 10 Mar 2025 04:06:37 -0400
X-MC-Unique: thKILgTnMEW5ulvCGk4W6Q-1
X-Mimecast-MFC-AGG-ID: thKILgTnMEW5ulvCGk4W6Q_1741593996
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-224347aef79so65495755ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 01:06:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741593996; x=1742198796;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RCOLOU56jiLb/4wdgy3TIcrzpp/26Wu5xoarM9qeWc0=;
        b=CtRQaOhEFau5/QX1I/FIbSh/02211UOh7kD12AN15sZpjTc6TQ+cGHTDJobMkniYfH
         82Eift9OCvCxNfhNdEvb/8OpWXyH3jfMPIhjxDxtb9Y490ZowEWB36LgUgSfsbu1eoBb
         HUnWf/+FKRDGrhdMFIPxnT8dE1l7XDazCXKdn4yYQLjZ2k/RhJadwp4/VFSwNzaVstKN
         GyfvMBVZ47A0tkOYiqpPMeKSX5JUCN4wcBO356TefUTQ+llKNlMqn71m7z2Q+1xGRPXZ
         1y0PHo5nylhB1IGh50qFadV3N+uecIWgBfs/QjS4hiK+7yfYErvzZgnWSc10hYP2Oxie
         l9SQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0zgOQl4ZwVgXJXXW1C0kt7ReHM+yE8jNJCQrzpZspOTxT+iCUiYZNfJPSXJT3zMrvXAd6TkLjR/o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy81Bzy3wW84moWSGdXblIfz8MAzBEU8SbkFdYDTbbIWs/P5wcK
	6QLAvFR4CmMlfY/3mNQtGNaf/3HF457ElHwog9j0h5r26R89LCwfe8xau08XYk1gHu6fxh0BKA7
	oSLh0infBF450Albdb/Qygom4hOko/czrzQJ5diy10XpjciSNcM9f9GJh+Q==
X-Gm-Gg: ASbGncu1Jt/15wEKr7V5WNsQ8DvhkHQwHmC70TrBGyzp4NvjVBPKq89jrGwUXDj5tR4
	4S7fvKBPbYs+K4Gv4ZekaYTBQj/X1IKW2F//ZyNrsrGEnLxc4IEOQ7AsK0ByL10bW+dmfVpTkJL
	WyauSZ+sYkUSUPd1iMVe20eZaXlRgXJrBeaJZ2dw6GCQRzniJOeMwneIeF2Rd0lQinc0OlAevto
	vA2xcdL3+YK8T++/pddjUIxr8Njni1IrSQMqVUGEy/lFXNJP/pVAF4AhD2LemUMfYPmIREJZhYC
	e0LpVyTWrOOqTpYpzPPvXwUSgnXhrCPl+Kti0buC9GxwnwRB0yrEgA/y
X-Received: by 2002:a05:6a00:3d55:b0:736:52d7:daca with SMTP id d2e1a72fcca58-736aaadf019mr20663420b3a.18.1741593996267;
        Mon, 10 Mar 2025 01:06:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF3zepBp9E0MRImticocc6MTl8Bx7wo5uHRMcLdiudFO4r9G/SfjZxODbq9kG76X31x/uUrMQ==
X-Received: by 2002:a05:6a00:3d55:b0:736:52d7:daca with SMTP id d2e1a72fcca58-736aaadf019mr20663391b3a.18.1741593995950;
        Mon, 10 Mar 2025 01:06:35 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736cd220c5fsm2495334b3a.55.2025.03.10.01.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 01:06:35 -0700 (PDT)
Date: Mon, 10 Mar 2025 16:06:30 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com, ojaswin@linux.ibm.com, djwong@kernel.org,
	zlang@kernel.org
Subject: Re: [PATCH v1 2/2] check,common/{preamble,rc},soak: Decoupling
 init_rc() call from sourcing common/rc
Message-ID: <20250310080630.4lnscrcbaputlocv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1741248214.git.nirjhar.roy.lists@gmail.com>
 <1d07e5657c2817c74e939894bb554424199fd290.1741248214.git.nirjhar.roy.lists@gmail.com>
 <Z8oT_tBYG-a79CjA@dread.disaster.area>
 <5c38f84d-cc60-49e7-951e-6a7ef488f9df@gmail.com>
 <20250308072034.t7y2d3u4wgxvrhgd@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250308072034.t7y2d3u4wgxvrhgd@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sat, Mar 08, 2025 at 03:20:34PM +0800, Zorro Lang wrote:
> On Fri, Mar 07, 2025 at 01:35:02PM +0530, Nirjhar Roy (IBM) wrote:
> > 
> > On 3/7/25 03:00, Dave Chinner wrote:
> > > On Thu, Mar 06, 2025 at 08:17:41AM +0000, Nirjhar Roy (IBM) wrote:
> > > > Silently executing scripts during sourcing common/rc doesn't look good
> > > > and also causes unnecessary script execution. Decouple init_rc() call
> > > > and call init_rc() explicitly where required.
> > > > 
> > > > Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > > FWIW, I've just done somethign similar for check-parallel. I need to
> > > decouple common/config from common/rc and not run any code from
> > > either common/config or common/rc.
> > > 
> > > I've included the patch below (it won't apply because there's all
> > > sorts of refactoring for test list and config-section parsing in the
> > > series before it), but it should give you an idea of how I think we
> > > should be separating one-off initialisation environment varaibles,
> > > common code inclusion and the repeated initialisation of section
> > > specific parameters....
> > Thank you so much. I can a look at this.
> > > 
> > > .....
> > > > diff --git a/soak b/soak
> > > > index d5c4229a..5734d854 100755
> > > > --- a/soak
> > > > +++ b/soak
> > > > @@ -5,6 +5,7 @@
> > > >   # get standard environment, filters and checks
> > > >   . ./common/rc
> > > > +# ToDo: Do we need an init_rc() here? How is soak used?
> > > >   . ./common/filter
> > > I've also go a patch series that removes all these old 2000-era SGI
> > > QE scripts that have not been used by anyone for the last 15
> > > years. I did that to get rid of the technical debt that these
> > > scripts have gathered over years of neglect. They aren't used, we
> > > shouldn't even attempt to maintain them anymore.
> > 
> > Okay. What do you mean by SGI QE script (sorry, not familiar with this)? Do
> > you mean some kind of CI/automation-test script?
> 
> SGI is Silicon Graphics International Corp. :
> https://en.wikipedia.org/wiki/Silicon_Graphics_International
> 
> xfstests was created to test xfs on IRIX (https://en.wikipedia.org/wiki/IRIX)
> of SGI. Dave Chinner worked in SGI company long time ago, so he's the expert
> of all these things, and knows lots of past details :)

Hi Nirjhar,

I've merged Dave's "[PATCH 0/5] fstests: remove old SGI QE scripts" into
patches-in-queue branch. You can base on that to write your V2, to avoid
dealing with the "soak" file.

Thanks,
Zorro

> 
> Thanks,
> Zorro
> 
> > 
> > --NR
> > 
> > > 
> > > -Dave.
> > > 
> > -- 
> > Nirjhar Roy
> > Linux Kernel Developer
> > IBM, Bangalore
> > 
> > 

