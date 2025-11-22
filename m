Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30C42D24BF
	for <linux-xfs@vger.kernel.org>; Sat, 22 Nov 2025 07:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763795358; cv=none; b=Fs6RBs7poUbuXlI1V4CTO/cevqGJAcsq56863VO/T8Jm3/zDq4zLIRgvJ49SytLxfh+l3THZb8hfsgnFI8QHlIqboFs6YMPSjt2VOQHtZviVLJkYIJQfvNAHzTkgur3LmBLGFTU70R4hV0/Df7di+i7/0MgzCCHGlQK+bWyxfb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763795358; c=relaxed/simple;
	bh=7Yd8nloP8m0dR422jBlUsUdryD11f8cV04WwFlwTHDk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SFmriRbW7nz1KlZqDgxbuaPPJTLqrJxmbprWxep8EyjON38CKRoY6aR5iIazimh2ksg1o/QESfSMbLN5Tlu7MwHQoWXyVgSawFJx2nRFnp4CLctqWA2rkfBOGPyXJQaB4UI/vhWJMqNo5bMp05BqVSDMSWg9ssFM+DbgMUe4m/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g+SOyhwH; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g+SOyhwH"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8804ca2a730so37998836d6.2
        for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 23:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763795355; x=1764400155; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TOU5zUa9ExH2UPIf77XppaYiXONJBt1V6maHsn7ikzg=;
        b=g+SOyhwHAKHXQcllkd5+4zdvPOLjeKqLL7A8kncx5suqPmNxkpgtjCRlgHgrZFKLh9
         9R3K7DEZhBJM23wVVGnnfJE6zWwULKGvNuhW82icfF64D8E9VPazIALxzvl9EKLTmiys
         HDwQVq7pKoP2awPscUxS1pYioZAdLsd5fPdqe9B881LJst8+58SQl8yMJARlkG3jmp7I
         qaIQCyCDgIyxTN2H/YymyCU33ukx3P7wFtw9nzWNLE28+oLNZOZLGHwDYdgupWrQPTdg
         Vp59TpmHidS3mzbCRC3oAsoYEwIWT/VW70Iy7yGhCiNjKxR/AgdPvXWQUVCu/XRJsITQ
         PIAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763795355; x=1764400155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TOU5zUa9ExH2UPIf77XppaYiXONJBt1V6maHsn7ikzg=;
        b=tu8aQMds5rqTgw+FRRy35wXeZZsQYvN7713UduamJ57CL3rH3Mj96cV4oU4EXNVUDp
         DNQwBLiFMbPW7OQX3PEOGnaNHoB++9X6RaIHsoM4NC7FDi9d4ERWDQGnHviTOi5w8Wwf
         9fp7zDpW3g7LKe8BDmJqDenAPEQCuLvYyTF0MjY+YONN4KQFtv57J4gKG0fkpKyDj3CF
         nUfBLhSUR7bmX36xV7q+7iLJa8VCJcJuL4oCpVx9+YHuZ0YA2dStwbhaEZCqLcKpjPaw
         kSwK63p+NpZ2gskRnao41Novs3Vo+gqHlOn6ZnkKdmtq137fDJesBBeznMtCEHmUh0QJ
         x3rg==
X-Forwarded-Encrypted: i=1; AJvYcCWFEGnATInbX4VEJBuWSXgPEOFWRW00Twazj5tOJcAI64Zm+71W3MY5Y8PXvCA7R6SVIWMWksXKs8M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJuGFKVLtJ/sRrv1D/GHTDyIzUq0fwOBAYscRaaneJKHk9KfG4
	I87rWC54+OUTr+XxWAg3QdyWa6i5s1PlaqsTcqCGh6BUor8OYHPtBv83hl50CzUu4rUaFAjgHMN
	iCJHwEoMcL1+Mz2tMs/ogjLSHgIHUCkw=
X-Gm-Gg: ASbGncvGQKtJNwNRqNlcSIaIR6kCbnRAa/FmcN6ZQSfTLx/zdLl1N67u9o0yMoHJfaK
	+3RCUYaLWYELU3u4IMf/tPdqIXrWBwzIwsoXQ+1hB9tNwgY75ZPkRHBcKXrbzvCNWvZ7J4FPhFN
	PIhSKVFAzWBgO7Hrb0tkiZac5GPgE3ttW1dw+bBRWOqhrNuhs58I29LjX9OrS8bAyY2qL+HeW/x
	o78qNlGsE4Z6+zVqLfHWU6gyxWfPKYQBZ9EG/JoSOGi7YgMnXxrF31sQ1BI3YjFIdDXNl4=
X-Google-Smtp-Source: AGHT+IH732VY2HEOL1GTjGnjiDpMpgHpw4qhxelOjeL0bgVDWuC8OicLazoWJuAvAFEObeAlgbjBNJsbaZaVBgshjVg=
X-Received: by 2002:a05:622a:1207:b0:4ee:1563:2829 with SMTP id
 d75a77b69052e-4ee58b04a99mr71664381cf.72.1763795354707; Fri, 21 Nov 2025
 23:09:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <20251121081748.1443507-2-zhangshida@kylinos.cn> <72fb4c90-0a75-43df-8f5a-154d9e050c09@wdc.com>
In-Reply-To: <72fb4c90-0a75-43df-8f5a-154d9e050c09@wdc.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sat, 22 Nov 2025 15:08:38 +0800
X-Gm-Features: AWmQ_bkaHk0wh-SvlSCw46Rlr82grFve_Y0_m2bfS2qbhv3bWWgwLzC0W1VLkPA
Message-ID: <CANubcdVx3MkWwncj1S0cS4FN+Stt8FpHD89dCFeStsd2QE=2sg@mail.gmail.com>
Subject: Re: [PATCH 1/9] block: fix data loss and stale date exposure problems
 during append write
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, 
	"gfs2@lists.linux.dev" <gfs2@lists.linux.dev>, "ntfs3@lists.linux.dev" <ntfs3@lists.linux.dev>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "zhangshida@kylinos.cn" <zhangshida@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Johannes Thumshirn <Johannes.Thumshirn@wdc.com> =E4=BA=8E2025=E5=B9=B411=E6=
=9C=8821=E6=97=A5=E5=91=A8=E4=BA=94 17:35=E5=86=99=E9=81=93=EF=BC=9A
>
> On 11/21/25 9:19 AM, zhangshida wrote:
> > From: Shida Zhang <zhangshida@kylinos.cn>
> >
> > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
>
>
> Regardless of the code change, this needs documentation what you are
> doing and why it is correct
>

Okay, will do that if I can get the chance to make a v2 version.

Thanks,
Shida

> > ---
> >   block/bio.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/block/bio.c b/block/bio.c
> > index b3a79285c27..55c2c1a0020 100644
> > --- a/block/bio.c
> > +++ b/block/bio.c
> > @@ -322,7 +322,7 @@ static struct bio *__bio_chain_endio(struct bio *bi=
o)
> >
> >   static void bio_chain_endio(struct bio *bio)
> >   {
> > -     bio_endio(__bio_chain_endio(bio));
> > +     bio_endio(bio);
> >   }
> >
> >   /**
>
>
