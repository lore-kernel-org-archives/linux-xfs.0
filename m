Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7681392
	for <linux-xfs@vger.kernel.org>; Sat,  8 Mar 2025 07:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741418445; cv=none; b=Dx/lLHejAum/jf360vHjrAiSnmomnq+DZKUy+cdv2efnTJOMUNnuJhP1cGPl5tah6iLrdT7oIb+O9UPxT2BDq3nWh5vS+Y5fdOkBPRac4BtCWuVpN1DX1+u5eXAUBdPLt3lz8eHPRWMN8ImD07KXo8pX9f6rY9HSMuIwdLADPK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741418445; c=relaxed/simple;
	bh=8sxuAERpEbGvHkeeugpgqaFjFk1RBwouM05IenGdnOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r48f3DixZnHjB936hC5PHu8S2BBal3KDJx+a/wTbnhLrSp5qi4GP9/deloQz3uvCZy5849BMJ2DpSAfH9w07bJOi8dOF4WaTOsMyXF8xt8j5s833BjqSJ2TjcrTcyzdPNZSUV0GRGY4PbsrdRacvf6WxWWdIVozfL79yZWLmYsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dGiX16tv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dGiX16tv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741418442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SCmKkV1CZokZ249gYYS9oMcIg8uihOkUdFQfQeNSRaw=;
	b=dGiX16tvxCqDN46XZJlKMO5HaJiUHJOtB8I7slxTp1pNuU8FUN8bt0/jHbToRepcxs0hGI
	4G1fKZ/9fyCnkE9XGWCFAH2bST8E88wIiwqevi+L+P2NIdK/lzdGkavAE3cYvs7V3G0hFW
	3jIqBqFh9PTaR4J5/+InKV8zf75seeI=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-D_USI4DHM5urY17K9lvj6A-1; Sat, 08 Mar 2025 02:20:41 -0500
X-MC-Unique: D_USI4DHM5urY17K9lvj6A-1
X-Mimecast-MFC-AGG-ID: D_USI4DHM5urY17K9lvj6A_1741418440
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2ff581215a0so7353822a91.0
        for <linux-xfs@vger.kernel.org>; Fri, 07 Mar 2025 23:20:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741418440; x=1742023240;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SCmKkV1CZokZ249gYYS9oMcIg8uihOkUdFQfQeNSRaw=;
        b=BIjnLnAJDcX6N1K6+QOQN6R92rcxjXmonB8unuVXbmQ6JsTrFB/J2noX/3stG0gvY2
         XCMWyLej7pEpO8KIF5YiamVh0uV1pNoQGM8ae3kW1vyRBMEKndlsIlz4EpO/9FUSnvV+
         4HxLh8r82RXYHuCJOx6Go3o+RgV6APOHDqM+abukvVn5wgRfXW5ZoyNUZhNs+0smn1Dy
         o9S1EzaMi1lCYTjvNOdDAZucjQwm5CjpkKuWn7T7tANkBteTLxWaiX4wFtDZfvtUxn66
         t2tJb5m6qyjeNKfmeGyQy8YsiTeiuu4OyVCfqHvTpJdFuR8AlCO+j+MmCMSNADtnuLHa
         kS+g==
X-Forwarded-Encrypted: i=1; AJvYcCVwV8dXMQGt0cA4PfbLaZy3cryn4ENoAUkTfDudYDJEN+/S/k0nRQ5HpeSqTPFwouyS+g31Tfwegi8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDyruldfCGoAiS3cQ+XI6lNoIergYwE9jES9idVjKKmhNuc59V
	9m/wzATb1uphXnyxGvD0XMh8KVLGvOCUCSQfYwURwUOLKDkj5WCXZy376Eu7jVHWlgPxhDcG+VE
	hhM8B/dkpu6GnCwgKd1QXF/U14/x+7aq+ghfYjFVNJcLveB5l+lEQzDN89g==
X-Gm-Gg: ASbGnct0YxLPdLjl5C44GRHaBxQDXTNi00TPfC/sstb5xyvhpzJQO6VoKiWJPq6Zlb7
	eS7QYqKFn12iJs5SAoSDEQZcexYWCvpUpiI76U19Sw3tv3OnZdvlZCm81fkRtBsW7/7kYsnxTlU
	UxxJwNAvPKrnm7cMwQYUYJ+8Tjv4Ok9jmaUSaMnh91tlPLXnRQXciWeZ7aKnlwfRT+FMTn7Ac00
	g4WZ7oekPWVv75UEAqNimCjnUZ6vq0ji1HI7CDxQV3Omsp8jru7lgKrmt2Bo2/gPKL9+RjVciK3
	JvS3D2AxU2pfd0UOBnznq2cqHcKiqCv3SP3e4MjW2sOceieUmWHBliY5
X-Received: by 2002:a05:6a21:103:b0:1ee:e641:ca8 with SMTP id adf61e73a8af0-1f544b16c66mr11008022637.20.1741418440314;
        Fri, 07 Mar 2025 23:20:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHd8WnneJ5eOgn0QHqj+cjsbRu2WaQD2CgClh7WJVs9v/NrrONTtCOd5IaZ87Dmd1CYw1zzMg==
X-Received: by 2002:a05:6a21:103:b0:1ee:e641:ca8 with SMTP id adf61e73a8af0-1f544b16c66mr11007995637.20.1741418440041;
        Fri, 07 Mar 2025 23:20:40 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af368398b1dsm2707688a12.8.2025.03.07.23.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 23:20:39 -0800 (PST)
Date: Sat, 8 Mar 2025 15:20:34 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com, ojaswin@linux.ibm.com, djwong@kernel.org,
	zlang@kernel.org
Subject: Re: [PATCH v1 2/2] check,common/{preamble,rc},soak: Decoupling
 init_rc() call from sourcing common/rc
Message-ID: <20250308072034.t7y2d3u4wgxvrhgd@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1741248214.git.nirjhar.roy.lists@gmail.com>
 <1d07e5657c2817c74e939894bb554424199fd290.1741248214.git.nirjhar.roy.lists@gmail.com>
 <Z8oT_tBYG-a79CjA@dread.disaster.area>
 <5c38f84d-cc60-49e7-951e-6a7ef488f9df@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c38f84d-cc60-49e7-951e-6a7ef488f9df@gmail.com>

On Fri, Mar 07, 2025 at 01:35:02PM +0530, Nirjhar Roy (IBM) wrote:
> 
> On 3/7/25 03:00, Dave Chinner wrote:
> > On Thu, Mar 06, 2025 at 08:17:41AM +0000, Nirjhar Roy (IBM) wrote:
> > > Silently executing scripts during sourcing common/rc doesn't look good
> > > and also causes unnecessary script execution. Decouple init_rc() call
> > > and call init_rc() explicitly where required.
> > > 
> > > Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > FWIW, I've just done somethign similar for check-parallel. I need to
> > decouple common/config from common/rc and not run any code from
> > either common/config or common/rc.
> > 
> > I've included the patch below (it won't apply because there's all
> > sorts of refactoring for test list and config-section parsing in the
> > series before it), but it should give you an idea of how I think we
> > should be separating one-off initialisation environment varaibles,
> > common code inclusion and the repeated initialisation of section
> > specific parameters....
> Thank you so much. I can a look at this.
> > 
> > .....
> > > diff --git a/soak b/soak
> > > index d5c4229a..5734d854 100755
> > > --- a/soak
> > > +++ b/soak
> > > @@ -5,6 +5,7 @@
> > >   # get standard environment, filters and checks
> > >   . ./common/rc
> > > +# ToDo: Do we need an init_rc() here? How is soak used?
> > >   . ./common/filter
> > I've also go a patch series that removes all these old 2000-era SGI
> > QE scripts that have not been used by anyone for the last 15
> > years. I did that to get rid of the technical debt that these
> > scripts have gathered over years of neglect. They aren't used, we
> > shouldn't even attempt to maintain them anymore.
> 
> Okay. What do you mean by SGI QE script (sorry, not familiar with this)? Do
> you mean some kind of CI/automation-test script?

SGI is Silicon Graphics International Corp. :
https://en.wikipedia.org/wiki/Silicon_Graphics_International

xfstests was created to test xfs on IRIX (https://en.wikipedia.org/wiki/IRIX)
of SGI. Dave Chinner worked in SGI company long time ago, so he's the expert
of all these things, and knows lots of past details :)

Thanks,
Zorro

> 
> --NR
> 
> > 
> > -Dave.
> > 
> -- 
> Nirjhar Roy
> Linux Kernel Developer
> IBM, Bangalore
> 
> 

