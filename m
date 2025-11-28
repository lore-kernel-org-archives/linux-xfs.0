Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A3732ABCC
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 12:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764334791; cv=none; b=McHDcCYrAx+FxhHqWro1dspdLtZfJ+yP3lCrbiWyIxfrydFI65rWdg8kjH8VJIJgAxySZKMnDqeRZOyrMzwZbmWR0qOr37qjVguwULEFNU0sDirjzPjz7H7nCKdF0iTZZ8VxIZegqMyeM3ac83YFMn/sS/wIq+wsx1YtWAnOehw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764334791; c=relaxed/simple;
	bh=5QcOkFfFDyBXYDnDanyoo0Sx7zR4bMbvdaWPFSIL9Dk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bz6feMz7eIA8wFCLrthCNdvnO87bbnvw0cgRxFMw0dqa7FPtXD6NSXbhx6M3hUIyjaYabLVuRJGOvPcTOZaGE0QwLSUbveQhpQBPEGmq+CcgxPk7X0ujahtGhHpn6gWMkMKBgngr8FSZAMASM3VAZ/AImMSs9cb9DCoShMdj8F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T8pS4d1f; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ae0aAH+x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T8pS4d1f";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ae0aAH+x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764334788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UbnViGm0SST3AIOO/NDK6ivARfPGgq8UL5FPgRGsaTs=;
	b=T8pS4d1fsn7qpHmykIofedKAKHqMnz7z2Bf20HHr2qMmMEBdhtGyDn36ahbecBKsPT3SYW
	K8AUU8mP2p5h8n2vBsSBM58V28eqr5oe1oMWGzdfO0vFT5S0J74SCPE77ImZE/GFGnu+p6
	fiOcJvJLFu5he4MzFdDh+bNCBIvEqXw=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-oxOuylInNzSnhQ8LcgTdBA-1; Fri, 28 Nov 2025 07:59:47 -0500
X-MC-Unique: oxOuylInNzSnhQ8LcgTdBA-1
X-Mimecast-MFC-AGG-ID: oxOuylInNzSnhQ8LcgTdBA_1764334787
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-787e3b03cc2so22144797b3.1
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 04:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764334787; x=1764939587; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UbnViGm0SST3AIOO/NDK6ivARfPGgq8UL5FPgRGsaTs=;
        b=Ae0aAH+xiZn0M0AZmsB9h871+6Wu2K+gwh5ossE977XXwsjldRXf6TILfNAwR56yfg
         QRZKF+COItBlNzPj9+tsIjZZ6DPC+TV3ZTMrho/TAYYyEja0TiQc6CGLkLXQpPWzqD1v
         vFEHLTWc250lQ8Rt3HTp+cIpWxZyc2R/VLlAexZe01jEB7f7VSTy0x5SE28aSysBJ+mt
         9pMcAyRcvByJyY6jUdnHyAJd1d+QZSCi4TzEk34+Mcq3mkbXq3R9ePPB1SyrXVvJnQsZ
         nagsi+zQTuAuVJHN8ZnB3l0Y//P0htTsUYpZUeB//hVe6MbXA8MAX6myp0fzB8bzTk4j
         KAaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764334787; x=1764939587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UbnViGm0SST3AIOO/NDK6ivARfPGgq8UL5FPgRGsaTs=;
        b=uExnAVcioeLl7NK2i3+MAwSLZ9F5ewTykDNW+DBAzF7ZybaSgDufDJFQqz3l5p+II5
         2XQEQOl0E7dwq4bzEwDs0p8oA8jkf64RWQhWV4mT1CYTABPPWM3qxfUJid10Tv8QGvbo
         tOAojLadBxBH4HkxPCZD8SeAu9EKq/3jIMCHyiZRQf1cHJECiyUvygbGH5T1BEZhrZeg
         928+jCco64wJ7evRglyev0DjXyGsad2Hk1RG0lGdFiBvFE5YD0uYChdtG03JYHoIoj5c
         brir6Xts2mHS8WfhbUo2SsLKPg0Ag4mQofttO5EpWYnTdMM5b07tbw8IfuRuDMGKpSVG
         mNhg==
X-Forwarded-Encrypted: i=1; AJvYcCVRy7MIq02xvfVMToodnu5ZZjkPweATQoG1kLpaOiJya9XInZ7FsMTF2+AK3eJGY9ogsmwxIAPGq9c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkguJ0FX5nQ/BPgNGp7jPPtg7+U8QcZbdLS+xMNXxaCcZFFdlv
	tGqqbgdtohJbzvZnPTLyteb05tRTvNmAfbC+Et2bSHCgICaMk8AbZzlGwCudH+I/BwVWOxp6nOc
	Khz/y/OKeU0OrYNNKgjJBxByx2753WX/wMNdsIv3O2xtj0mcAjerxVNPLwriZYdRgMUUwEY1JdE
	t3q9aioWzqfvFOzXbZAJnVdqkEXcD54bTNZ2xQ
X-Gm-Gg: ASbGncs3Jkucmnbs3Tv/s7grzCOTkdx1Iwapuo6seuUBA27UbOBjmc8Y9cWirD1Ql3+
	4ZG7J82qVuq+/scc/+D91kP8UgSdu6tINboWNRdgQnAhe5trn5w/kZY85tAZh5aFlPOAorhiBgc
	QS1gJglKH3Ra/pqh4KiOASacYefAlevdGa7RxUgA8ZdlZDOZ94BOzrU2Z55MqHKhW+
X-Received: by 2002:a05:690c:6f03:b0:786:78ab:72d0 with SMTP id 00721157ae682-78a8b47a179mr234771217b3.7.1764334786907;
        Fri, 28 Nov 2025 04:59:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGesqVOsUJELcTkEGN3hauFQ6kd2TkNnYcjHT4c1bgANcOfukNB8/4Sre15bHJPI3DpWDPFXhJhMME6PGLKN8M=
X-Received: by 2002:a05:690c:6f03:b0:786:78ab:72d0 with SMTP id
 00721157ae682-78a8b47a179mr234770957b3.7.1764334786528; Fri, 28 Nov 2025
 04:59:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn> <20251128083219.2332407-3-zhangshida@kylinos.cn>
In-Reply-To: <20251128083219.2332407-3-zhangshida@kylinos.cn>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 28 Nov 2025 13:59:35 +0100
X-Gm-Features: AWmQ_bmJ3AOy1Ou64bzbzmfYJle8eXItasxBb4QbS7GrXBYKV503HxVqfGGmAks
Message-ID: <CAHc6FU6H22GEQTaOh4tm_=yL7CZ-Ck4EkXtmdsn_oyAW7OWB6g@mail.gmail.com>
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
 wrote:>
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

