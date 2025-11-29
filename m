Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F659460
	for <linux-xfs@vger.kernel.org>; Sat, 29 Nov 2025 01:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764381050; cv=none; b=bxE9nVssPAUPAKrlkwKF+GHVNaspkzqIANCmMF/nV9W1+kCM83Ql+ZSWo1IiFOHgMUgaHE5x/m6pKUq+PsqVyV7oj2LtCe2u485ttLeIGVozk2PkmCxn8yWPNcicVCdhxD9pCh6BJE3MYyOj4tlv/lrwRT5GIQuuj8yObEdb7Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764381050; c=relaxed/simple;
	bh=NaSVgYTQZj//T0kXBeK5L/YqRjV2JfM4MD+L1BQ61uA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YCRgZ2xJGIbbJrXucF6cOWQKZ//kAkKB0b7TdRDDhWOcYI8dwhHiPu+O23LD4/b7jFPVJx84wF4seefeL8UBhomV9VbObmepxEkAqt6GHOHFYdxsgRz2BBdBZ0108Fvo2GY8EOyI2G4TZwAczVfwnnYI4KkBX7EtoRzW9IcUzjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RJaomsKU; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RJaomsKU"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4eda057f3c0so16854591cf.2
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 17:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764381046; x=1764985846; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xXq5BoozcLEtMZPipx/4wTBGFkZq8n4VHxCYYlUf+vY=;
        b=RJaomsKU0RFImSp0lKj+tCXDBYiRDR6Ym99JMqbxsanbLdacTBoZI8afLEDT2XVHyL
         jf3qT2d6hBUsHJ5gr1BWXz72DX7Eeh0gSdtMFoGa4c1/4IT5gXrdHr/Bf2Sz7r2L+N2J
         FwvVZ28GXeKVQ6swn1L23xHmOOM5aYMwQKGdMVkXQ4vNWUK8cKrp4RBAV1T1yzjhHEaY
         JlC05worradVWjm1d+w107iZ5W+cSmrxuUCoC1aEfktG+Rf4xdXwXhpBtR6hLZefwp7r
         nnNsMjNvUSCpqDmgskmxOc4n0pqDHHVWxf1Ixq2XvuGV1BmEgaxtZgPJbiYVH12ISwgS
         hd+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764381046; x=1764985846;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xXq5BoozcLEtMZPipx/4wTBGFkZq8n4VHxCYYlUf+vY=;
        b=gokp9ot9Im+fVKm4IHk5YNpsSgRPL0Dt+bhtrVz1UkQ1cKFGzOWdxSBoNwOQh2TBJQ
         HN+E52eKcYffRoLdZpQkQ000ywgrNa87/j0L+28JZY8U0j0DURQbPgwAqkAiYcXWDGf0
         lKElKlOQ76mwzEXDKdcLwe5RXT6N9gQWbaLZoifUiN6YQF+zRoagyr2fC/AEsp+CwnL0
         kbbD1moj+FVHwIpqntb29Q+cpPm9KhEIa/APsmtztb/5ddIWRgVgiEsbzthB65cPu+L0
         nrrxXV078wckrVnUqW6kaKDDEivO8vzfxh2z828QQMN8twmi0bcrOL/23VkwDV2I0z72
         yb0A==
X-Forwarded-Encrypted: i=1; AJvYcCURtywAs9nLQqLNXPpQlxWM3MIKIDhSsoLNrKIqLAv4OyTFpyrsdPxyPVOzZhaDOs3OHDnJNDiqXUQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/Yf96Q+Etd9Si4P61pHagwZDLATnQuD96ynRwTlbtCazF6ZEC
	h2mTlcWC3NlpLUMANPR8jFwJ8k/ed0bsEwA5S+KwHnONrSPAggvKy5eOeiQcoQymkpGIb05FoKE
	xT3fPUVYm9vxxKEV/tHbidVPC6LQmUmw=
X-Gm-Gg: ASbGncv9MUjuDOrK0YbsZCxCh3/nqkUdBYUCa9Xfl688LzddKcCY4fN0+pd08LKVqLi
	C+nw59G/ThbIdy5Yv379+dYwr4e58QqmcZ/IQVrPVKoZJJRMj57AmPiMXTRpwJS24ObJQE4AKvj
	ltsi21XFtM9urA45Ia8hjWQrGpc8S8xcJ0EGFqALWcG0HJO6ik5ULYfkzz6La45oJLmm1nXb29A
	CtgfTPDDsb7ehq7l3CAD9YDUPRa5VCTSVCV/b7+G/yxOpdrMxhvyBxRsS5FoJwQOVWyb1etZubu
	wCrT
X-Google-Smtp-Source: AGHT+IE+Tw+9Y5Bub3lN6sC4Pj0OtdTK9knmaYL6GikYTYtgwTjW4uUHcZO2kGFVdLFpIVKdsMHQoOJ3Bk1wdK27dic=
X-Received: by 2002:a05:622a:1909:b0:4ee:2942:c4fb with SMTP id
 d75a77b69052e-4ee5882d9d4mr417978631cf.31.1764381046350; Fri, 28 Nov 2025
 17:50:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
 <20251128083219.2332407-5-zhangshida@kylinos.cn> <CAHc6FU6dmK1udCgj9vMj1ew-4+bZOK7BA47kyEgONEwGg42veg@mail.gmail.com>
In-Reply-To: <CAHc6FU6dmK1udCgj9vMj1ew-4+bZOK7BA47kyEgONEwGg42veg@mail.gmail.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sat, 29 Nov 2025 09:50:10 +0800
X-Gm-Features: AWmQ_bmFiM-2nj0DOVO633rnw-D1LMnVAvls5FZ2mk8-RJDyk4i3to2si2g7WjI
Message-ID: <CANubcdW7FxbtSRzePgO4wQwUFBpgbSYdL-GR87vUXKq7tAPsJg@mail.gmail.com>
Subject: Re: [PATCH v2 04/12] block: prohibit calls to bio_chain_endio
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn, 
	Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Andreas Gruenbacher <agruenba@redhat.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=88=
28=E6=97=A5=E5=91=A8=E4=BA=94 20:58=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Nov 28, 2025 at 9:33=E2=80=AFAM zhangshida <starzhangzsd@gmail.co=
m> wrote:
> > From: Shida Zhang <zhangshida@kylinos.cn>
> >
> > Now that all potential callers of bio_chain_endio have been
> > eliminated, completely prohibit any future calls to this function.
> >
> > Suggested-by: Ming Lei <ming.lei@redhat.com>
> > Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> > ---
> >  block/bio.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/block/bio.c b/block/bio.c
> > index aa43435c15f..2473a2c0d2f 100644
> > --- a/block/bio.c
> > +++ b/block/bio.c
> > @@ -323,8 +323,13 @@ static struct bio *__bio_chain_endio(struct bio *b=
io)
> >         return parent;
> >  }
> >
> > +/**
> > + * This function should only be used as a flag and must never be calle=
d.
> > + * If execution reaches here, it indicates a serious programming error=
.
> > + */
> >  static void bio_chain_endio(struct bio *bio)
> >  {
> > +       BUG_ON(1);
>
> The below call is dead code and should be removed. With that, nothing
> remains of the first patch in this queue ("block: fix incorrect logic
> in bio_chain_endio") and that patch can be dropped.

Yeah, that makes it much clearer. I will do that.

Thanks,
Shida

>
> >         bio_endio(bio);
> >  }
> >
> > --
> > 2.34.1
> >
>
> Thanks,
> Andreas
>
