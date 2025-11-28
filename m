Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A1A32C923
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 13:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764335497; cv=none; b=qKbP53iU2SZ2D4XD1hycDAA9h9LnX9CIBYYQOoskyUz7tBvub2MmdTYYEMXVIHLBKZxMykMJObM8iDHGFOmX69MpL3EuEctEdFzxcX0f8U7F9rORYIWikytIQnLmP2CYS54ko4WiMuy/935+eQecvr0NX5vIvpFhI2xLszS7d/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764335497; c=relaxed/simple;
	bh=cT5VambQLzg4yYEkETS1DAEPp4cL0vkJ6BivaulYb7M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QdxzmOWAtRf+bzosEkNsLiG83Vgks6MUa3XilrNS5dvNsQEMqVTvB9G4TPG+OfpjMzJsztHWMIg/5QlVAYhMwa9bltNQsiRYNlq7Pfg7vHkX3gX+X25n7NyEw1E0SnK1ErOyepnFrsu9nvite1DCUtGy2Iwccqju+NpEUAWLie8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BYnzK0TC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hcyUvvIv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BYnzK0TC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hcyUvvIv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764335494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cDb8wvl+/S3cs8WDouA4IaIUDYl/lhw5kT6xFlbeDqo=;
	b=BYnzK0TCQYYDyxEdqxbIKOuKmGPPs8LVsHSQARwgZ7PjRloKJuBe/0iyYLVPb8PgZ/I2V6
	B5L39mMYyTY6cibG8vGjmMU0vsOaSs+Gxl71nCpbC0dDXu75uaq4uN8JsqBdd0+C9C3tCT
	nO9mKdjPsn/VLz/1Xphuw6ETmU1GaBI=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-0L0cH07MP7-NPe5gTT3ePQ-1; Fri, 28 Nov 2025 08:11:31 -0500
X-MC-Unique: 0L0cH07MP7-NPe5gTT3ePQ-1
X-Mimecast-MFC-AGG-ID: 0L0cH07MP7-NPe5gTT3ePQ_1764335491
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-78a712cfae6so24057607b3.3
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 05:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764335490; x=1764940290; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cDb8wvl+/S3cs8WDouA4IaIUDYl/lhw5kT6xFlbeDqo=;
        b=hcyUvvIvuav6RH+u70kqFcSAh3EVr1cbA2yCr6KDZhA+V701MG7dD3bdZoZjEJfvcW
         qghp+0oiRVyV4HcjWac3sQpN6S4i+ix50w6Eon+dq21W+hgPcWmw20v53vBmAkMrw2Ms
         GoOKcZRqfAB3NJIY4eLnDwO0kOyS2RXv8kCWJxC4Ou4JZGIJ6uG5FBQ1ER4TqN53Suqd
         LVdSNBUGjyJ+0S/+s5EU7axwq+Mh2IYs+ta5pJKgT7276mm/Zd2NsrzFekq6626EE5kK
         Kd5vQ7sCLpVlxulSx793TVyXmQe+Pb6uMFgWQPVf4GngQO0fbKGlO1N+CSyYi1+4AobW
         F/7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764335490; x=1764940290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cDb8wvl+/S3cs8WDouA4IaIUDYl/lhw5kT6xFlbeDqo=;
        b=LTDs0RtHKhoBcGz54Mh1fdzVmxJLuEjXr/Vjtal69nJNlfk7esvnpD1cICYpv0K+z2
         D+r0guIHyqYibGWPV5wL7KhdgqTK5/qTcuop2Z5DOHuyOJi/p42nj/5nuP5UtXY1vvVe
         1q263Fq3fcOxi0Xntb9sXHCxDzoiojp7PpRB4DLGkNdrYTYeitr35QZxIQ2mXMPkr5O8
         C7dJ2oVTb2+byM/mccOeVtMTe8i/sCANXEyQqM3d+2lr+0/nof8raU9LaXc8xBaPuJTw
         x9ZNWwWSQSYnsRX7TxHJFgNiyITlZpWlL7qy7W6ObxkGZu405OsDJjl8GNsX6JLThC56
         7u1g==
X-Forwarded-Encrypted: i=1; AJvYcCVt9C+zp5zchkFZb4LCACdblHAt6FdUWD6gLj5XGHU9wDTcFr0q8VYLyOCdBancfuppsnulGV0KiM8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyolFvS7zxll/cOvzKcZQQ/SJnbANt9yKRGtVSVCAnVd2ZcadWZ
	sHHueuseDwaiwGizxEEognFh5Nt9adiou14HgoFa4PyQgcIkJkMN25tTcb0NIwBfdTZ2U3z1Wbs
	uMQoUAtlwv39V2ZAcTt44LoTNGjXK7Zz/4VwvnRzLQhWgp9g4vAOxO5Y1k/tS6jZiIDw760VWzn
	Dj0FKUN5vRlScwqvcNPHJSATHBypUPBxU1SB45
X-Gm-Gg: ASbGncsmJnOLATwXWIZZS1WJ7/aJKpXCS3bUyCB0UhgXguI8PyUxmxY/F+K+xcC2zmu
	JLF9SvF2fsFs6xyaY3T1zlHAqzvoC1R/xcR1ljgjtLqeOMq+F4ptCei0dmyxQmrQbCCdiwiVT5P
	pvWZNUPjsFgjqz889TKFgKfhPuMWB5vv53WXrjcv/R3ch9ECduVLHHbzEdFtpnVB8s
X-Received: by 2002:a05:690e:8d2:b0:63f:bd67:7c52 with SMTP id 956f58d0204a3-64302a48446mr15103909d50.29.1764335490414;
        Fri, 28 Nov 2025 05:11:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFpYs6Bqkkw2QMj53nrShI4JIcUgw0aEZxMMPQ2h/FT8I7boFY7Ao7pNuY9j2sTWaBF/Hvop1CT06FKU/ZbYVo=
X-Received: by 2002:a05:690e:8d2:b0:63f:bd67:7c52 with SMTP id
 956f58d0204a3-64302a48446mr15103893d50.29.1764335490100; Fri, 28 Nov 2025
 05:11:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn> <20251128083219.2332407-3-zhangshida@kylinos.cn>
In-Reply-To: <20251128083219.2332407-3-zhangshida@kylinos.cn>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 28 Nov 2025 14:11:19 +0100
X-Gm-Features: AWmQ_bmMbDxUx7xf6l9s72idOADcxGPBv_GTFewzDFs5Yo-0xMy2x8K16_Wfsjs
Message-ID: <CAHc6FU43FWMYm2y2b9EvrFzsJdOn55s2QOMxCfRiHKVMVRqQaQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/12] block: prevent race condition on bi_status in __bio_chain_endio
To: zhangshida <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, siangkao@linux.alibaba.com, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2025 at 9:32=E2=80=AFAM zhangshida <starzhangzsd@gmail.com>=
 wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Andreas point out that multiple completions can race setting
> bi_status.
>
> The check (parent->bi_status) and the subsequent write are not an
> atomic operation. The value of parent->bi_status could have changed
> between the time you read it for the if check and the time you write
> to it. So we use cmpxchg to fix the race, as suggested by Christoph.
>
> Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  block/bio.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/block/bio.c b/block/bio.c
> index 55c2c1a0020..aa43435c15f 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -313,9 +313,12 @@ EXPORT_SYMBOL(bio_reset);
>  static struct bio *__bio_chain_endio(struct bio *bio)
>  {
>         struct bio *parent =3D bio->bi_private;
> +       blk_status_t *status =3D &parent->bi_status;
> +       blk_status_t new_status =3D bio->bi_status;
> +
> +       if (new_status !=3D BLK_STS_OK)
> +               cmpxchg(status, BLK_STS_OK, new_status);

This isn't wrong, but bi_status is explicitly set to 0 and compared
with 0 all over the place, so putting in BLK_STS_OK here doesn't
really help IMHO.

>
> -       if (bio->bi_status && !parent->bi_status)
> -               parent->bi_status =3D bio->bi_status;
>         bio_put(bio);
>         return parent;
>  }
> --
> 2.34.1
>

Thanks,
Andreas

