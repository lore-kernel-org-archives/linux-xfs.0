Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FEF2D9EED
	for <linux-xfs@vger.kernel.org>; Sat, 22 Nov 2025 07:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763796350; cv=none; b=m41xKDu8Nt/axaDjS/0flNHBVIa4dfnIUnrilfxrZO7imYdQsGgTxCcJC50LO7e/qEEdJxZNHOdVl05EDBBQITJglC4fmIfP6f98tv4xs15kA74mBX2fYp6GCPXXn9TKB1ZKPrdly90W2ZyHSpHWdDrC/poQphT+7lAC15GOXsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763796350; c=relaxed/simple;
	bh=JIS6SCLgbf+oOuOkDo/dHaEAqLI3/Ie51gDdGsv7FCQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TMrQVy74Iwn7SdRt74IGB+cvQZJZdM8rJQ/+DrEdSvJ69ym+C+rlfqfVGpqvT7cz0avCs+D+a7WSfwraouWRGEgjCbG9BsNPWaOpeZBLjXGQzyw+SQ7NCApS2xmaVlOYdEr8qvyGhB1j1gN19yDxAA/llqW8ZFT+70U7rANFSG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZjcRA57/; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZjcRA57/"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ee19b1fe5dso36581041cf.0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 23:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763796348; x=1764401148; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eBwVylaCDYZawWaYOaVSH7r235GJ5pL280n6ediNWBA=;
        b=ZjcRA57/YXefxgoGdWXVN8EPiVm0A136uG8o0QRPI+sl5or1kY/QalKRQWEoo/zmUz
         XkVBfD3EqoqRhaxvZZwgenHqfh5VN6RxWQgdDig2R00+niA5djY7LD9L5HB5YvYO7zb+
         xgGYtljvBvZCPAFbXSoQORX+Wl0LtqT6rIAWQeeM/lSp900kOf+DLwtYrvU5LVuES1Mz
         n2CqdhuPoBLvTIY+eiJ63ShleCaNQJR6yjzvaBlyhJN+7XSsq96+vOjF61C6t56AyEnQ
         EIhXgZkGisTcukOu2zlpbpzc5V7NNr1STuD07RhtuYlxcjHEl91s8dHPM6rNojO8W6Z4
         ySGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763796348; x=1764401148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eBwVylaCDYZawWaYOaVSH7r235GJ5pL280n6ediNWBA=;
        b=M20eAdq79ZfYZRjsb9VB4digaUoKP7bfa9yjwIJeWVUENjBWSUFfbzXqEssJWVYKeI
         gz0cop2TkxlBn0+EMSeRcjKs5g8wEQp38eRKwLFubj/QgBFlFeBJOnwE1LMmzURA21FN
         zBsqvglOzq3U296tI2nwl7cJuLDVff6lqE/myHlhsstyHJTM13M74nGd6MeWMzLjL9LD
         5Jb1gFc1lmyxptLXpfMPnx3Hr/NEl19JHPmgJQi2HlzHTrTxeghelUqXgKmPdXtB7ecG
         pTxq9F5YUIjBjm6T5B88eZXLO4l7X7UoBJMKl3Y25YKVSVQ8PUA7E0CZkFUX7cKY3LSN
         Homg==
X-Forwarded-Encrypted: i=1; AJvYcCWLKBMx89vu5I4SObH9M1/52TGubIoMQJX186ZGJcJBdvjZVaN3z6pfI7jvpIlJ2yQOu16IbaCCK60=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5z8iMpUNTyA8Z8tweFeTnmizblGPf8erTZaYP/X6nxxchE1oe
	WuW+GuIal4PaD1Of/3vdSoMpDY5tyNkrOuoXWeDcgnl8t8ChcEUIldYV+VUPFGM8pm2ebCO6P38
	ZrywzJPCDTOJLNmvYP/snEiJND0qTeh8=
X-Gm-Gg: ASbGncujKL3M2eFuiYFuTUXneVaI3dStt+FoAZ/XtVNrnqXDIF7wDrTbHgRGcJSplWz
	KAjDc9DC8TBCi89UGIPF5aBIA2Pj/LjU1T7D4EZbH/Z8S63KffqayFbsi87ZjqoEn6czPGhvt/t
	oGCj8cu16WT12C6IEHx9XPTPC9ExxQehPern1jFfhJyZxSmGW3JDfysnfjdKiHQjPpX1aDTc/2R
	d3jSA6kqMSaCtsxe3Nc2+xZKer+ZV4RxIxGFCXhD7VOkt2CRie0tkLshhsIMO0gT8p4KZo=
X-Google-Smtp-Source: AGHT+IE9V/QbSlM+tFjYlGuMiqhVjgd2vxC0t40Xg/Gl8NLqAZlhJSgGugagYhyt41bdzYZDASTkKfW3q1PwTWY5MjU=
X-Received: by 2002:ac8:580a:0:b0:4ed:b1fe:f885 with SMTP id
 d75a77b69052e-4ee58848f99mr81632341cf.19.1763796347971; Fri, 21 Nov 2025
 23:25:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <20251121081748.1443507-2-zhangshida@kylinos.cn> <aSA_dTktkC85K39o@infradead.org>
 <CAHc6FU7NpnmbOGZB8Z7VwOBoZLm8jZkcAk_2yPANy9=DYS67-A@mail.gmail.com>
In-Reply-To: <CAHc6FU7NpnmbOGZB8Z7VwOBoZLm8jZkcAk_2yPANy9=DYS67-A@mail.gmail.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sat, 22 Nov 2025 15:25:11 +0800
X-Gm-Features: AWmQ_bm3jSl3t5CGtWT-qk2xFeLKlRyvhhYg4MhhBIRyX0iMMBB8sT9lfrjP88A
Message-ID: <CANubcdWaegO8k=_fkNFSvnp2bUYMmPehSFnenCCjVw2sz_1jqg@mail.gmail.com>
Subject: Re: [PATCH 1/9] block: fix data loss and stale date exposure problems
 during append write
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Andreas Gruenbacher <agruenba@redhat.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=88=
22=E6=97=A5=E5=91=A8=E5=85=AD 00:13=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Nov 21, 2025 at 11:38=E2=80=AFAM Christoph Hellwig <hch@infradead=
.org> wrote:
> > On Fri, Nov 21, 2025 at 04:17:40PM +0800, zhangshida wrote:
> > > From: Shida Zhang <zhangshida@kylinos.cn>
> > >
> > > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> > > ---
> > >  block/bio.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/block/bio.c b/block/bio.c
> > > index b3a79285c27..55c2c1a0020 100644
> > > --- a/block/bio.c
> > > +++ b/block/bio.c
> > > @@ -322,7 +322,7 @@ static struct bio *__bio_chain_endio(struct bio *=
bio)
> > >
> > >  static void bio_chain_endio(struct bio *bio)
> > >  {
> > > -     bio_endio(__bio_chain_endio(bio));
> > > +     bio_endio(bio);
> >
> > I don't see how this can work.  bio_chain_endio is called literally
> > as the result of calling bio_endio, so you recurse into that.
>
> Hmm, I don't actually see where: bio_endio() only calls
> __bio_chain_endio(), which is fine.
>
> Once bio_chain_endio() only calls bio_endio(), it can probably be
> removed in a follow-up patch.
>
> Also, loosely related, what I find slightly odd is this code in
> __bio_chain_endio():
>
>         if (bio->bi_status && !parent->bi_status)
>                 parent->bi_status =3D bio->bi_status;
>
> I don't think it really matters whether or not parent->bi_status is
> already set here?
>

From what I understand, it wants to pass the bi_status to the very last bio
because end_io is only called for that final one. This allows the
end_io function
to know the overall status of the entire I/O chain.

> Also, multiple completions can race setting bi_status, so shouldn't we
> at least have a WRITE_ONCE() here and in the other places that set
> bi_status?
>

Great, that means I could add two more patches to this series: one to
remove __bio_chain_endio() and another to use WRITE_ONCE()?

This gives me the feeling of becoming rich overnight, since I'm making so
many patch contributions this time! :)

Thanks,
shida

> Thanks,
> Andreas
>
