Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C52026980F
	for <linux-xfs@vger.kernel.org>; Fri, 10 Oct 2025 09:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760087842; cv=none; b=TXyAcvI7ytYoWcIalUEQ3dP19dohgORRhvKqjNc9XpJn/9uXzBaRiHDrVlux6RaHOu4GAtK/R0o9iWFArSJcRVcIxBJUzsk2juQJlS7kfF5cY2VT+Nf0r43+jdroo4r9zWdWjrXPhbuM5JJLxv3BEmSxn2kjA6d/FSc4EsbzNfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760087842; c=relaxed/simple;
	bh=9jTDXCqIKh2+ih4S/itRPeKddxX7Azrs29JnYafeu9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k+KzOv4IRYCTm5lb327kqRuzAu42k4o5laYS++/y8Kcmz1Ev30LLv/4AGuod+QpnQ/cYMejvjNF8e4NI16ADhwCqDtk0NXVo0Dt71aZimMvCK4ry89S/Qte1OqlNTThv3E4sx1vrjhix+sbZH9MPmZ8Pa+3QQGpHG9xg30O4Ko4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qx/YVWJW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qx/YVWJW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760087839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7q6Lpm16pbcmKlbg4UzZsCAZvZL9WSf8sXgF4eHK/zY=;
	b=Qx/YVWJWbb1Zz/EY7VsaFP8kGDVti3CQtcJVoSFy7DvI4i5l5ioaHmMSjOcLoydrBmf3jq
	Z1a7n2AU63Gunkj1yTGg37cgSd6Ot2ueBqhLaP52vvWOTU+P9g0i83HXbmgY6VzlBMtaqF
	ePJ4p9aS6FbZdGw1HBmC4tF43qGHQmg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-VdIt_SyVOrCkiBXLTp2EoQ-1; Fri, 10 Oct 2025 05:17:18 -0400
X-MC-Unique: VdIt_SyVOrCkiBXLTp2EoQ-1
X-Mimecast-MFC-AGG-ID: VdIt_SyVOrCkiBXLTp2EoQ_1760087838
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e25f5ed85so12870595e9.3
        for <linux-xfs@vger.kernel.org>; Fri, 10 Oct 2025 02:17:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760087837; x=1760692637;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7q6Lpm16pbcmKlbg4UzZsCAZvZL9WSf8sXgF4eHK/zY=;
        b=jdYwwExGQQq2bjPn9MfypDW9SeXkzOmgwJRH5QFx5/iM4O91LyOZlEb6bmRJO3GG5S
         6dw//dH9Z59WOWg0DtmVtC6OwFVoLnlIjtqNAvepSzggMUfoew4ryiQEHZAFVENsf3D6
         B2y0Q7OCJ68O+WDxjAA6ma10/9pJrs2GmYuMeNpV3DKIMX2kwcneZFYFEcjVD3hx9I6r
         Nu7of1972rh4nh6C24frq2xNZ55lslK6fdymjxm/uNMmCe0O+f64F16lT9LJ0th4hibU
         pCVetgjSfk47RclOtwNmIzALGaahu4WD3nNGtCOXl1RO15iIwWBZVz8jtmueMtYdY6UB
         4dPA==
X-Gm-Message-State: AOJu0Yxf+s9tcLheEuaxMVjOw2olIdc63+bWDB7wkOuKakUrLNDiLVxO
	9wdat1yCBaYywH/AYnNd5oVMYmugA9+0ch5elSV+CsnbXbBJQbvAAcmuwS9AQ6mUnklBYLdnjGU
	kutUmHUfqWlWwY7sfBL17oA1milBSWbmRa2tqRl+hJxHJZoDllSxrBN+qTr8r
X-Gm-Gg: ASbGncuP3QpRtTN6UldWZEFWObYPR3D5ag4qLLeIfpjD5iBE685qKGfhLRWmvqkEKyM
	V71369q2iGQ1Q0xsVFzoZDGIn5OgL1TiBKVdQeEl/6uAHKPXJijFOTb5zd7E8d7/+BW9OvCf8gt
	ffrJiLFNC1vAFntKkGAcG2Kas/FGT5jXDO4st2yIdIPfFeak1ektG869QAwVARJp9kamqTJQwNU
	Ef1RkpqHVBWfY0NzRQcK1yCeKg7F9n+AW8jU7r+LgUFzQ0/YOttTP6SFuKkyuvAW9rvtQ90wdaN
	dGATxKO4aUM+nEAi6muEzJjyVeBWO8Lwo6QVS28zipUSxUzVATOMPG+EKdU5
X-Received: by 2002:a05:600c:c162:b0:46e:47cc:a17e with SMTP id 5b1f17b1804b1-46fa9a8f4c8mr74621375e9.1.1760087837323;
        Fri, 10 Oct 2025 02:17:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHLMOND1Qc65hfhuzF3EQEWzDNfHAaOTo/XbVWlsh5gzH/uUqVctqePO1OdkaPRfdast9vg5A==
X-Received: by 2002:a05:600c:c162:b0:46e:47cc:a17e with SMTP id 5b1f17b1804b1-46fa9a8f4c8mr74621035e9.1.1760087836658;
        Fri, 10 Oct 2025 02:17:16 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb55ac08dsm28640465e9.13.2025.10.10.02.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 02:17:16 -0700 (PDT)
Date: Fri, 10 Oct 2025 11:17:14 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, pchelkin@ispras.ru, pranav.tyagi03@gmail.com, 
	sandeen@redhat.com
Subject: Re: [PATCH v2 0/12] xfsprogs: libxfs sync v6.17
Message-ID: <vydt5kvfarxguwo7nymwsk4cdj5dvhqm6vo3v74ax6aqeb2db5@nitrtkepikgy>
References: <cover.1760011614.patch-series@thinky>
 <20251010050832.GA15629@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010050832.GA15629@lst.de>

On 2025-10-10 07:08:32, Christoph Hellwig wrote:
> The patches look good,
> 
> but the way you mailed them out is seriously broken, all the mails showed
> up as pretending to be the original authors.  I'm kinda surprised this
> even made it past mail server s:)
> 
> On Thu, Oct 09, 2025 at 02:08:24PM +0200, Andrey Albershteyn wrote:
> > Hey all,
> > 
> > This is libxfs sync with v6.17.
> > ---
> >  0 files changed, 0 insertions(+), 0 deletions(-)
> 
> Also this looks wrong.
> 

yeah, sorry for that, new script, will fix it :)

-- 
- Andrey

