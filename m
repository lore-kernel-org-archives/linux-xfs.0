Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB9F142621
	for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 15:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727450973; cv=none; b=jkfskBefIyWVz3MRMLwuVF4S+Y7Y3x1j3mO/BQURyvFiPu51qdnvTc7+Ar8NI5psacM18J2whOGeV50ojhPqFzwNcqcYIaBtD5XcBSQ9SFxOMadZx4sUK3+rJ1w7O1EvgmBHGkDQr1/WlaEWEPyFEYYwx9gqNuSqRz8NctTg6/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727450973; c=relaxed/simple;
	bh=7TqLq5C7QHQlEwggBGYUC2UN61Ct8PN6+aSGSiQsZPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OmoVOwqg3NyvFGOcDUkF0Pgg9auYb3jxJXMfy3IHpwtkFK95EqwPaoxMKjpu4wRAiQQ5PKVzRS4ykxQ50aJUMHNQF1Z3ED1FzD6Zv9eFqd0Zw6CA1mObsIPZ2gKadt/VT5JfxTFhNsKDQCEv6enE6irEApthgUw2JuybK3AOTOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GBPKVh6f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GBPKVh6f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727450969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SIkmaHZMZN5iCu73ve4nSXAhaGgNHUWQXnG/m7Fi/pM=;
	b=GBPKVh6fHZ0V5bMFrpCkwXLP8QH+Let80PUEk5A/eMFRo35qmHzGe9AxuTe5B4UE+Y7CXR
	T1pc4XAI9qd8Y4LzcMUt1DAZziQF53uD+fWKVWmczIHDFhLBRNQoZXopbhHQpsi3RpkNN9
	p7UxHOFIZ9N1XTHBuQ6BKgvWQFYWxoE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-AomiEYdXNky8XDq16i8m9Q-1; Fri, 27 Sep 2024 11:29:28 -0400
X-MC-Unique: AomiEYdXNky8XDq16i8m9Q-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a8ff95023b6so162802266b.3
        for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 08:29:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727450967; x=1728055767;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SIkmaHZMZN5iCu73ve4nSXAhaGgNHUWQXnG/m7Fi/pM=;
        b=D3STH0WOVygfNDYiu2Lx0K99B9PDOEk62nCWH+9P4YDmiskwj4nkxp9JmGCSFpNUhI
         oiWuIDZZ4aT6uftlmbdOftT+r6dbGtupFcNP64zlJ8sTrbGozIhzybJlzIHykY0Nm5Mq
         ZUL42ttwvhYshB5BmlzJvmyjgw+HwgSdrmBKFTryhtyHVHJhqdpymxUfe+UjC5Z1txsj
         yPk0RRSf9hHw7PQcA9TaJSRguv/Awd9XJAFsh/4KGoboZ+rLiGnVhFoHR4mn2MiE9v+p
         PzL1D4MSUkzRhTrwOfQffLjLExEcGvYzTRf1JJBBwoyfXlisVEkBYlXN7mYUraD1kVZW
         PlTw==
X-Gm-Message-State: AOJu0YzvmEZMzqb6AK6awsDjpf7IjdvtncBqrqOHWZoYWP19o+BMuxGj
	Sl/P6etjAyiNJyuoMi5GydzCtnJsckaLZCzmLV0/gpjnqPdHLAQ75cQybkYik+EBukex4oLF69a
	HA1U3tJu9UR3UBd+zc0sAb1Y6WDkbrnwIWniChI8pSTA78xQ41bu+gsjxl+xODKn6
X-Received: by 2002:a17:906:4fd4:b0:a8a:4e39:a462 with SMTP id a640c23a62f3a-a93c48f90c2mr349088966b.7.1727450966788;
        Fri, 27 Sep 2024 08:29:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHW+mZXUYNBweprPHyEdn6MptabnhfF7NbEloDcaiz9jGrTYUuIwViUKV/p+hAun4twqkB7dw==
X-Received: by 2002:a17:906:4fd4:b0:a8a:4e39:a462 with SMTP id a640c23a62f3a-a93c48f90c2mr349086166b.7.1727450966358;
        Fri, 27 Sep 2024 08:29:26 -0700 (PDT)
Received: from thinky (ip-217-030-065-002.aim-net.cz. [217.30.65.2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c2979d88sm145578166b.156.2024.09.27.08.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 08:29:26 -0700 (PDT)
Date: Fri, 27 Sep 2024 17:29:25 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org
Subject: Re: Re: [PATCH 1/2] xfsprogs: fix permissions on files installed by
 libtoolize
Message-ID: <mkr2blf3lqji3sl6gzqilht2q75g3asm6g4nskypurlc4ptmfn@hbi6rcsnhcky>
References: <20240927134142.200642-2-aalbersh@redhat.com>
 <20240927134142.200642-3-aalbersh@redhat.com>
 <20240927151709.GK21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240927151709.GK21853@frogsfrogsfrogs>

On 2024-09-27 08:17:09, Darrick J. Wong wrote:
> On Fri, Sep 27, 2024 at 03:41:42PM +0200, Andrey Albershteyn wrote:
> > Libtoolize installs some set of AUX files from its system package.
> > Not all distributions have the same permissions set on these files.
> > For example, read-only libtoolize system package will copy those
> > files without write permissions. This causes build to fail as next
> > line copies ./include/install-sh over ./install-sh which is not
> > writable.
> 
> Does cp -f include/install-sh . work for this?

yes, the cp -f would also work, to fix the build issue

> 
> Aside from the install script, the build system doesn't modify any of
> the files that come in from libtol, does it?

yup, it doesn't (at least I didn't found anything else), but the
file mode would be different

Andrey

> 
> --D
> 
> > Fix this by setting permission explicitly on files copied by
> > libtoolize.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  Makefile | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/Makefile b/Makefile
> > index 4e768526c6fe..11cace1112e6 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -109,6 +109,8 @@ endif
> >  
> >  configure: configure.ac
> >  	libtoolize -c -i -f
> > +	chmod 755 config.guess config.sub install-sh
> > +	chmod 644 ltmain.sh m4/{libtool,ltoptions,ltsugar,ltversion,lt~obsolete}.m4
> >  	cp include/install-sh .
> >  	aclocal -I m4
> >  	autoconf
> > -- 
> > 2.44.1
> > 
> > 
> 

-- 
- Andrey

