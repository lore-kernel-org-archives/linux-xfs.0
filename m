Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F003D19F115;
	Wed, 20 Aug 2025 13:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755697652; cv=none; b=BsdiEsP/r6AOYY0kIVmJQRXkmYo7nGUpr+Glm58KWXWS2xxoSSeAymbksalaOSaDLlxLFMUJPK8BzF2sjae9y7yMnetpM7pjQC2QdGAl4Md0gTKX/WPHSEpXnj00YPFlrstIEAGhrS6j+TLXu5uOtiRIgbMIf99jDJac9/jDa20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755697652; c=relaxed/simple;
	bh=qsn2kv1ghHVBAovnnwDg8QvK1e94HdrEO0p9T8nhxIo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k/+HblnPFYRhyxEjOrwUY+TC5XdJ9vUCq7lGO3BMEIG/ckMgmDTMX4DWfRpqv/N2Dl8O6x4WmcOFqTKfT+pBj2P02kLc4VH+10cbCWjHAyaJ9otobHq3CkGY0fC8LKKcA0bvQktenaJGD3mV3KALG2mD9IoSLxDcZB4H+1rmPR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DNZSrgBA; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DNZSrgBA"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-3110269717aso471800fac.1;
        Wed, 20 Aug 2025 06:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755697650; x=1756302450; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iOvHRjntmm1D7/22TeGyMO8ZQan/YXdnVVmnvJDz8zc=;
        b=DNZSrgBArvTIsIDBNPK7xB+DrFknoB2cNGtNvm3YgLfirRMebaUmBOVB5A413phr1a
         ZQG6t8/tw7z7vojUYfH88PmFo/QLbtYyVimx9ZO7jRLflpipqICTP0yV0PTNUKaToc6F
         wA4hA2lsbwSUPzQ6hJrGNevZEdB+z9JLH3buGv1ISsKJ1LOH/m7LUD1cFRh3SDZAbcY0
         f7x9EcoUYW/RTA7TX26P/B7W3dFHDLd+Edx5PUtDhk41TMw3zDWbApTnTbH2xvkceCzL
         yow9wQ1h098nxi4G++kW8VrWLa5VtIElsNARyxay4JVsfsHEvaVZG03LaxF+3fJ/r1/X
         86Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755697650; x=1756302450;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iOvHRjntmm1D7/22TeGyMO8ZQan/YXdnVVmnvJDz8zc=;
        b=k8Hat6QtvXUqCPfhGoImOwkN8H/Y4VTL7t1a3qmOQBwGyucI82HrvW/qM63mAcu1Lf
         nBP9hQR+XsXQiTad1i6Z98fl7j2wqcFY4ujGquw7+o9dBSKJGOj3HvRmvp6EbowEF7hi
         8AJ87Pl7PDDrLj/Y0+SRYusj8xYeb2XOpPC5P0FAUYNotBYjBjGehSxU6IvnjSo5khvU
         NndzAr4AnYBrWGJ6WwG7KeUOUEbbWnNm0OxX1AFDhB1cyLD1L6/MjZ+2YBC8xNtEPOpj
         KtBWKHx/ae+FKYg94G2WKHCoqxJXkHJTAVcSSZoekHU88v56x9mdhxaXt+w5V+xj6m7a
         w8YQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1I81sCNkshUQT6rZN7lLSj/umamiW/Jd73DdqKcZUfsVGqVGZnIjVRF0oDDWQCHUBjCPN0ohhRlFP@vger.kernel.org, AJvYcCWZzstter6fKGpJqHYNUi1lIGSofPUdcj2SSMZDTNnf3AVYDJNKtyK8byk+/Ks6fYNYLKGbu+L5Xjo09Mc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHYoLWoO3boCMJs/SdOJX1c9Xfd25bsQtN/ZYuUyLW5/z9bSsd
	YD6fG8ee+PMYT/mzA5HL3C+dK2zzPaQs0uPfk1ryQg0puMmnFBnDPGMShQpIOJ4agQ+1abfdmMU
	lt++dWS0MsFpYtAwFP/8+t7N56YmbJxw=
X-Gm-Gg: ASbGncvSpDiUBoUqj0FiAPw2PlD8p+w4OJ+Q7ok0pvVwYp6YxR3ad1GJ2tPG1KfAFLp
	e1YF4lhe5YaLRfFriKUsrdXXdQdbX1GZHdl3r5IsThbTxUrrz6gXCvyz4MAQ+6lKUrMUJunUy5O
	jyrboKnOUwZ432ZRzfVGDwjlrdOpt0b0tfP2KOvBNsSVLZmCBJNXAMj/6T5ujQMUXBWGDtQKBur
	aZzDN9dH1bsW5DSiI101qOlESGAnw==
X-Google-Smtp-Source: AGHT+IHY5jMSk37ELH/V37DB4hs/fv6+/bFk3IbJ92BPMYrnSvTb7C3CyJn7jc06TM0KCwnaXT3uh+OVtxVv1LaKsy4=
X-Received: by 2002:a05:6808:22aa:b0:433:e8b7:14b6 with SMTP id
 5614622812f47-43771697dd1mr1901237b6e.7.1755697649974; Wed, 20 Aug 2025
 06:47:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250817155053.15856-1-marcelomoreira1905@gmail.com> <aKKvjVfm9IPw9UAg@infradead.org>
In-Reply-To: <aKKvjVfm9IPw9UAg@infradead.org>
From: Marcelo Moreira <marcelomoreira1905@gmail.com>
Date: Wed, 20 Aug 2025 10:47:17 -0300
X-Gm-Features: Ac12FXzaPx61N9NssKf12Th8UyxKpv6zTN6GDGr_PbpBgXIa4ObLTquUFAbJa-w
Message-ID: <CAPZ3m_g+KcJt_wxBjdmvyW+FqXAcEfVDUuHkp8iZ6XiUZ+6x-w@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: Replace strncpy with memcpy
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em seg., 18 de ago. de 2025 =C3=A0s 01:43, Christoph Hellwig
<hch@infradead.org> escreveu:
>
> On Sun, Aug 17, 2025 at 12:50:41PM -0300, Marcelo Moreira wrote:
> > Following a suggestion from Dave and everyone who contributed to v1, th=
is
> > changes modernizes the code by aligning it with current kernel best pra=
ctices.
> > It improves code clarity and consistency, as strncpy is deprecated as e=
xplained
> > in Documentation/process/deprecated.rst. Furthermore, this change was t=
ested
> > by xfstests and as it was not an easy task I decided to document on my =
blog
> > the step by step of how I did it https://meritissimo1.com/blog/2-xfs-te=
sts :).
>
> I tried to follow the link, but got a warning about a potential security
> threat because firefox doesn't trust the SSL certificate.  But maybe you
> can add what you wrote up to the xfstests README or a new file linked
> from it to help everyone using it first time?

Hmm, I've sent the same link to other people, and none of them
reported any issues with the SSL certificate. In my case, I'm using
Let's Encrypt. It could be an outdated certificate in your Firefox.
Regarding sending it to the official xfstests README, it would be a
good idea! If anyone here is involved in the xfstests project and
thinks the post is good, I can send it to the official README :D

> Either way this probably shouldn't be in this kernel commit log.
>
> The change itself looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks :)

--=20
Cheers,
Marcelo Moreira
