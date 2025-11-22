Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0FE3B1AB
	for <linux-xfs@vger.kernel.org>; Sat, 22 Nov 2025 14:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763823435; cv=none; b=to7DfTWkK/4atO39Z8azonDFacHd7TSKWS0oDWnQzfsv18dSehv56apJ7pxSyTXsUQfDMrDC7nv12yzS9Z5ghGqcBFL3FZvu4co0bnuQzyxGzkvRaO7hpFDfM80PE+guvHsANu4FJgFoUF7gPTFvGmYPRV3jBsP7NXoLfNXpcWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763823435; c=relaxed/simple;
	bh=hFzOPcepuM2226lVzyXCQ+m40VlkuCq0KyoZ7KBoHiA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r8HNCtkmVrTcYFBawIOJwI3Wm8QhMpHdyTBOjz+hUKwq4xQOkOldYeUJ6YWe4eBZYMQrt5Kjbe/pNPbWdKd3BbOXYQmY8nxnE/YN8YNAdVjYDbFuTkCKrExshvh/L2BvShQsPGPrj6Gn9DN0IIpIRdjLlIReVsYLk0GwNSoniVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ww+pl2V8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eIUpwg3T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ww+pl2V8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eIUpwg3T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763823431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AoeYwuTA2OCKqGileGsNd+ysqL+d5N6ZH/jsAbQy4b0=;
	b=Ww+pl2V8p/Ei8G2LzFV0Deobf6rlBBVDxLzff6He1jfpnj1M04DKWVfZQ+XqvRbOlZmz8t
	kFxRioFV+A5LnAWmYpehcfFaoxVPGIGVPu3qfIfviRNQhDPPwrdEm5NP+R5X1ZzY9CuqgT
	8rhuzLn6Usy+xBddmA8twGr0aR66cNY=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-BttRI8-mP2WwQQPAhB0rnw-1; Sat, 22 Nov 2025 09:57:09 -0500
X-MC-Unique: BttRI8-mP2WwQQPAhB0rnw-1
X-Mimecast-MFC-AGG-ID: BttRI8-mP2WwQQPAhB0rnw_1763823429
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-64203610e3fso4542042d50.1
        for <linux-xfs@vger.kernel.org>; Sat, 22 Nov 2025 06:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763823429; x=1764428229; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AoeYwuTA2OCKqGileGsNd+ysqL+d5N6ZH/jsAbQy4b0=;
        b=eIUpwg3TENYqF2cj0uP3AhWKJPeVSJmQPzIP8J5oJWK+SkaEmNWigdDjlsNEXw1rfh
         +vNENborw5BVXytVoEHHZ9bRt+nJrsnppH+ga8wtSPC8qRnXkCEZHlA9Aq0rFvB9YAd3
         kdks1ZYh4HuVqWAoq1rct6FdVT0BuNbXpGWqeR2rqX/zSVDbj3wFQlo99cKoW+0AYl6Q
         1yAtMWquachuYZHU33aLZByiMvWn6rw+EFL3uZ3/W9l86alVE5D6/HUSu4ByJO6Ov1Dz
         KStmc1tutsaRz/FlYeYX/sEo3P1bJBOIE0S9syZ2ifUutAy1oEVicMQI9aHDsO0+gNOn
         eFdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763823429; x=1764428229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AoeYwuTA2OCKqGileGsNd+ysqL+d5N6ZH/jsAbQy4b0=;
        b=X0w+7IUo3aB4An2CrgeVgiG2M4//efteAGs1kC96mGiFEw+nD5X88NQOqwprlMtNvf
         Uuf324KG5TBgrBV2CnVU1yixc3YaCytX8vBc7WdziP8/CCyeqEltyrRnEe420OCOfHbK
         Q1NlkGOgK5iu1NoicTa1uBec04+V+U/cAS+faHBJyhmjoTdDGiqgw3gSgZSBNuS7KvVh
         McLG/HxhirRIFKoOgM7rP+DiZBDZvZ7eJHzCpipFcnpGABjdJJ4h1fneoK5XytURpYCo
         QmA7eOsKkI+Qpd/DmS0yFmaT83eHyaWMwNTqYt1ru5/Tz+aThGFL19+YXpp/oTCav6PG
         Q3gA==
X-Forwarded-Encrypted: i=1; AJvYcCWmoTh1mG02rOzg1RWzhs78uDeYl6E7+buA/5wif55O6GMS8BA7f9nsIpqPkjwKO3g+KP3hIWLchpI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhPVCQfY4/xsrZOD/LYzOrOthcuS26OxlHw3YFLwnm98fNY2iK
	1zsY50ORGpT10/QVp/2Apbu90SaIq//zxKzr7BSRkWqUIMT2HlpjZBSsCFm3DgLNnBGLZ6fJlH8
	3TuXsx+m4+Ka6+op9Ngu2efsJy5vgRYMvsvv3xtijL0Z+aAxrSb/Yv2OWGitzpSJHFY0R+FopQf
	wGOY5GOxzNWC7sIIfoHIo8IEXO69/Fbk1IaaWU
X-Gm-Gg: ASbGncs06weSrtMZlrDfrrLtvYzUNn4N5D+ZIljTJYAGqQyvXyy4PRE1OqQiSaUW2EO
	X5fJYjNPp9iPxGQty+lb32TTFkMd2PR6lu82o78nR0QBbcWbYu5SEudtqawjYUClgEhGBgGpQLO
	kHiyrkZJiCKKd/mGuiiijnpH0zq4fWw8UUGYhiG2Rw/nvSqTcxsA3rEnfdYFQ9fGkp
X-Received: by 2002:a05:690e:1511:b0:63f:a324:bbf3 with SMTP id 956f58d0204a3-64302ab18damr4335095d50.42.1763823429379;
        Sat, 22 Nov 2025 06:57:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFJA7IrsaRMoz4Q/MV8XxAm6kxOszSooFbnuk2I2D2sSCVAvxGo1WW7Hp8NfZ+CGh7b65wTnbGGciN5n9h/Z58=
X-Received: by 2002:a05:690e:1511:b0:63f:a324:bbf3 with SMTP id
 956f58d0204a3-64302ab18damr4335087d50.42.1763823429039; Sat, 22 Nov 2025
 06:57:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <aSEvg8z9qxSwJmZn@fedora> <CANubcdULTQo5jF7hGSWFqXw6v5DhEg=316iFNipMbsyz64aneg@mail.gmail.com>
 <aSGmBAP0BA_2D3Po@fedora>
In-Reply-To: <aSGmBAP0BA_2D3Po@fedora>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Sat, 22 Nov 2025 15:56:58 +0100
X-Gm-Features: AWmQ_bkhaeO27ks2qTqUvx9zYAyPvR45fmibJyAeax_P7fjCjfN3MMivydMdvis
Message-ID: <CAHc6FU7+riVQBX7L2uk64A355rF+DfQ6xhP425ruQ76d_SDPGA@mail.gmail.com>
Subject: Re: Fix potential data loss and corruption due to Incorrect BIO Chain Handling
To: Ming Lei <ming.lei@redhat.com>
Cc: Stephen Zhang <starzhangzsd@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 22, 2025 at 1:07=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wrot=
e:
> > static void bio_chain_endio(struct bio *bio)
> > {
> >         bio_endio(__bio_chain_endio(bio));
> > }
>
> bio_chain_endio() never gets called really, which can be thought as `flag=
`,

That's probably where this stops being relevant for the problem
reported by Stephen Zhang.

> and it should have been defined as `WARN_ON_ONCE(1);` for not confusing p=
eople.

But shouldn't bio_chain_endio() still be fixed to do the right thing
if called directly, or alternatively, just BUG()? Warning and still
doing the wrong thing seems a bit bizarre.

I also see direct bi_end_io calls in erofs_fileio_ki_complete(),
erofs_fscache_bio_endio(), and erofs_fscache_submit_bio(), so those
are at least confusing.

Thanks,
Andreas

