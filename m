Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD4627A90E
	for <linux-xfs@vger.kernel.org>; Mon, 28 Apr 2025 16:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745857744; cv=none; b=IaqvI+lus+67IpoJD/7aQm/b3zIbhou6URYIgArQaVwlgXO1FgOVCQlmD3XkXGZQKNbYHe3YOMrUBHxoUwqelWFy0pIt/ts2afZWejNByvvBZO39mynzWECR2aHIADhlDWvXoxGj5Y1ADISTWnbZEDgHtAq3lEDG6tk5nWzQ1lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745857744; c=relaxed/simple;
	bh=Z5Ddb8N0lHDI7tN0JzpYSjV5eOkooObl2oMAbc5aI9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EYrhwpxOAfC2a/6IDoTTwdRZwM9QX+xAlnJ3U15lkhB1rokyU8jt2u4qtjx9uKYNXB2567A/9uM/oZX2+Y64Zwf8GaiEz0zI4eEDd34VabFTHgoPi1RabscIbMcBZu55hFvgUaM+RpNU8edjqHf9+TqhJ3EbDgnUGaV7ng9wwvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T8+L3ti2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T8+L3ti2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745857742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OFWxffRlMnVuYf3wgqTa5LbhdqIbi19b7osKAQDO/54=;
	b=T8+L3ti2wYKCqJVUOM9b0Bp6iYwdGXq2S9Vs/KS3hXV9QsxTw38+Kvvdc2QnhdWfrf1fTG
	/SrITm8RoGYr+jyiETysgl8O6WVJgWLFJpWQEYBbF25yajkxcmWQaf3QGqYJ+Yetc29tYw
	NessEgNkA2s3YzUqdd61VAFW/6WEc9U=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-H9537RZuMKKz4XDvhsjVlA-1; Mon, 28 Apr 2025 12:29:01 -0400
X-MC-Unique: H9537RZuMKKz4XDvhsjVlA-1
X-Mimecast-MFC-AGG-ID: H9537RZuMKKz4XDvhsjVlA_1745857740
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-ac297c7a0c2so314243266b.3
        for <linux-xfs@vger.kernel.org>; Mon, 28 Apr 2025 09:29:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745857739; x=1746462539;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OFWxffRlMnVuYf3wgqTa5LbhdqIbi19b7osKAQDO/54=;
        b=tB+8U634NgtCmp3ju3rLQvPOuw3yBbAPrFXMJrbk7b64XYbB0hk/1eqFZ5rCBFZndh
         6l85tF2r4wBjzmPasHGKumOa2QFf1cZAGkD3g+tYPR27WJ06Oiany1j7H4anm9YZYlcc
         S0sXJTnc8mu+0jGt58LpXlGoradUwTGZ8eAArMPnJxdh1Cr9PbZSJzc/saE622XsUSOB
         ROXjTHHfo7hxu7cA0hcxFVLY8ab66heyPk0y/AoYVYMSuTO9Nwl/iPvUvmiYLDCtknja
         Opkw0h8NYsfyOt7k5Gk4vVP+3k1woPRMWK0OHEaNkc+cJXkXDN6tX7ZUFKOvtcz3sAp7
         tAzw==
X-Forwarded-Encrypted: i=1; AJvYcCVme/APild3zWTqsgrdJLo9+kVxbseSlHx8rMJLDwidrguXJKB0jPXovpP0LJ66n5j8duiMeOUL4mo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr8UZfL2jT0COmyB5TBuPSH4v4OI85xVgK1nj47JD3DpoVN+QP
	Hr5x7LWhcnItW2xF5kzCNGXrmSQh7ro/8igo+JDqCZUJjJKQSkr9/mdLLv57xUD3tr1CKS6xUfZ
	IXOiMRKntpPokG7ieTBiFx7CLVlbsKiD7UUS6N/AmfsV7iJk8hhZHO/LWVGjCWqoc
X-Gm-Gg: ASbGncv8Xr7HgI1F2cHVP2UI7D/yXT2V1DRqFKY7T9hKaZRtWBG5j1hm+IUGEjJerXG
	xSEAkNg0o0a6Xrim+AzB2Z/zpgFTScO94UmijXxHEuIhDI8o2ypldtz45GMKs8ZW0bblpcwxE6q
	f9T2J/IbjB/MkG5ubQHTbIsdH+s0IlZ8+fFurqm0QtWKUW4dM4kp69w8LYkNeJdv0KNGYzqBt9T
	WJTPQiCF3utvDfTFW6olOeXfPlrTrJ4w+yz59vvHvnOXiHhmWLH+tg1VGvNIlCRkjqhJ7RJ1Fxb
	SiP/UpqkWYT/foxEVLKseZAoCyBPkuU=
X-Received: by 2002:a17:907:2dab:b0:ac6:fec7:34dd with SMTP id a640c23a62f3a-ace713fb7d0mr1174244966b.52.1745857739536;
        Mon, 28 Apr 2025 09:28:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFos8A5rDD2Y51rjgiz4zZqxMer/mBvc7yjso+4lLnysXGGJfwHNhqiujJy6z/+f5KbunMv9A==
X-Received: by 2002:a17:907:2dab:b0:ac6:fec7:34dd with SMTP id a640c23a62f3a-ace713fb7d0mr1174243366b.52.1745857739211;
        Mon, 28 Apr 2025 09:28:59 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e41c491sm642919366b.34.2025.04.28.09.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 09:28:58 -0700 (PDT)
Date: Mon, 28 Apr 2025 18:28:58 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Andrey Albershteyn <aalbersh@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 44/43] xfs_repair: fix libxfs abstraction mess
Message-ID: <hrbhwqnymqgvp6l36s7r7mdnnmhhm76zoibtxtfo32iishzhza@fbuuly4t2fyn>
References: <20250414053629.360672-1-hch@lst.de>
 <20250425154818.GP25675@frogsfrogsfrogs>
 <20250428131745.GB30382@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250428131745.GB30382@lst.de>

On 2025-04-28 15:17:45, Christoph Hellwig wrote:
> On Fri, Apr 25, 2025 at 08:48:18AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Do some xfs -> libxfs callsite conversions to shut up xfs/437.
> 
> I'll add it to the next round.  Which afaik is just this and some minor
> commit message tweaking.
> 
> Andrey: let me know when it's a good time for another xfsprogs series
> round, and if you want the FIXUP patches squashed for that or not.
> 

I'm preparing for-next update, do you have any other changes for this
patchset? I can fixup the commits and fix "inherit" commit message.
Or if you want you can send it now, I will take v3.

-- 
- Andrey

