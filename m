Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9613114D29E
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 13:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712842662; cv=none; b=inwXXP9fXzZzk5TFfLu9RHNe5DsQbo9zoJfk90Oous5lAWtKXcm6tYwSLe8doO+kSBVxjn9dSV8stsy35IJpjKPzaC/aHNMaJSiZkpLi0F7/nn7jH/cV1LDCE+z3HAl6GQ2FH8eqeOKujX6ADAcSYYYikQT6t9V5hAd+jCBszTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712842662; c=relaxed/simple;
	bh=DIAb7MBg/O79YuapLR2aNqATub3e0SOKNJsfHZ2b5E8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QnI0mk/eth1sv0kUaPH67a+KAKsusq/UlX0tRZ3pLc5Z9M3iELViui/LAx9XnxsxPJr/xOSPiVEIZfttHr52A5i7ONAETKuvLFaVisi6Xbshe8f25dwaCyAKRfQ2pnzcOHYBX4bWR23PIdRZKuj3bteEWIMfy2/fZsNWBQvSMqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VdZr9owC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VdZr9owC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712842659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dERZePAMGY5Ogff4MXaSm74/ezvcT6trwfEdO0OfoQE=;
	b=VdZr9owC+8APMHB3glMhT0+GoERpECKD3T8BC9YDTW+BJl57CNFRMO+ue4QDnRUrcWeMuZ
	ogOpAwkR6EDGfNM1AaYWrlhS90kr1hA+0RbvzexO8WZ5a6XXzWvfDiYselGKQlpYveZ3Bg
	Yatf18y1hEBa8VAULB2o0YbXavYuV0k=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-280-85Vo_7wFN-SgDy-cknTwBg-1; Thu, 11 Apr 2024 09:37:38 -0400
X-MC-Unique: 85Vo_7wFN-SgDy-cknTwBg-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-69945bfdbfdso2030826d6.0
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 06:37:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712842657; x=1713447457;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dERZePAMGY5Ogff4MXaSm74/ezvcT6trwfEdO0OfoQE=;
        b=V5Z4dP4pZweToK66zKVrc79xCTBJJxyA/Z+DM/P5bjuYNd8lNQo3+wIMC1xpN1tGYL
         N9LUoR10vsO5IMau9ye8Vr/sBhJVLuKXN0D4blTJxMi35Yd/AcHMFnn5uCx+RgOSyHWN
         nuV/abAZbaeKGhNN8i1n2se2RVvFj2OnHh46mfagz4VgntkSz0JEs9+vnBUmvlbYSrmt
         JAGO9w7GJC6MzVsWvqXd8/CyF1hjmh4ozihcg0ngbPg6EMLe9essxiPVU6URwvOKcSyw
         LMhVVAhUdbzuC3Vk7ZluGQPOFXzHakKaVzUCohoyowlCAyNJSprNEdmxCzpvXQXVC4Os
         cnIg==
X-Forwarded-Encrypted: i=1; AJvYcCX04Q7M4s4/Ml5wOX9kzIWJxVxEwKUSB/3eGQu48inkKjY8VU44riYdWM+K4EiGgzG9/GW+Dlge2MHwDx7jZaCUS0TXxd2ziBZS
X-Gm-Message-State: AOJu0Yx77yJWwzKuckkYl8mpun8xpua7xJLocZiCTGN9LHRgtXjBkBFE
	nd4ODXRb84dww7k0lEHr0hIZqd11Qk9XFoOVhE94iMCJk47T/A4t6mmMfFLxZRTaagugqwVTL51
	rD2tS1i1ieXKSRL3MU6cv1bUCEtDhL9Xd2XY6ii9PIRAYz/pyK3sDwsJxBw==
X-Received: by 2002:a05:6214:da1:b0:69b:1833:598e with SMTP id h1-20020a0562140da100b0069b1833598emr6052240qvh.6.1712842656869;
        Thu, 11 Apr 2024 06:37:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQ6y7GR0pZzFXXvPoL0L/gLuIw2bwjbZR6CEdv4NI7c2F2dzHLnZvnROzJ8bJwU9WvPh/HLg==
X-Received: by 2002:a05:6214:da1:b0:69b:1833:598e with SMTP id h1-20020a0562140da100b0069b1833598emr6052197qvh.6.1712842656337;
        Thu, 11 Apr 2024 06:37:36 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id e7-20020a0cf747000000b0069943d0e5a3sm946973qvo.93.2024.04.11.06.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 06:37:35 -0700 (PDT)
Date: Thu, 11 Apr 2024 09:37:33 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	david@fromorbit.com, dan.j.williams@intel.com, jhubbard@nvidia.com,
	rcampbell@nvidia.com, willy@infradead.org,
	linux-fsdevel@vger.kernel.org, jack@suse.cz, djwong@kernel.org,
	hch@lst.de, david@redhat.com, ruansy.fnst@fujitsu.com,
	nvdimm@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, jglisse@redhat.com
Subject: Re: [RFC 02/10] mm/hmm: Remove dead check for HugeTLB and FS DAX
Message-ID: <ZhfnnYfqWKZn5Inh@x1n>
References: <cover.fe275e9819458a4bbb9451b888cafb88af8867d4.1712796818.git-series.apopple@nvidia.com>
 <e4a877d1f77d778a2e820b9df66f6b7422bf2276.1712796818.git-series.apopple@nvidia.com>
 <20240411122530.GQ5383@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240411122530.GQ5383@nvidia.com>

On Thu, Apr 11, 2024 at 09:25:30AM -0300, Jason Gunthorpe wrote:
> On Thu, Apr 11, 2024 at 10:57:23AM +1000, Alistair Popple wrote:
> > pud_huge() returns true only for a HugeTLB page. pud_devmap() is only
> > used by FS DAX pages. These two things are mutually exclusive so this
> > code is dead code and can be removed.
> 
> I'm not sure this is true.. pud_huge() is mostly a misspelling of pud_leaf()..
> 
> > -	if (pud_huge(pud) && pud_devmap(pud)) {
> 
> I suspect this should be written as:
> 
>    if (pud_leaf(pud) && pud_devmap(pud)) {
> 
> In line with Peter's work here:
> 
> https://lore.kernel.org/linux-mm/20240321220802.679544-1-peterx@redhat.com/

Just to provide more information for Alistair, this patch already switched
that over to a _leaf():

https://lore.kernel.org/r/20240318200404.448346-12-peterx@redhat.com

That's in mm-unstable now, so should see that in a rebase.

And btw it's great to see that pxx_devmap() can go away.

Thanks,

-- 
Peter Xu

