Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C78C296BCF
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 08:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764577821; cv=none; b=o7JIP4RUYgWnfvHM7Py/dAAfIDayxP8SpKD3LzS/BAV8hlQHLnXrU9uiT25gYRAE3+bdW6KgNOULclhen6tS3XfD4yAOkEKBKe7LDexyitG+v65xvtdcreBXP95VKL5R147gRHR8WbKdvKoO6Lml//icEJXKZSrKRDJWoBfguaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764577821; c=relaxed/simple;
	bh=SwVqI6MJM5Lrg97Ok9vpLMdiyd5GgCZUgGLi9eNg6mQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i9C6bo7DPQw+aadP8snrq73BhaSk/yX6KURYUKE9Zfi4RNDvWnGKAgVjqCUDvvEIDBe+QQFGiHgcvxtkECRonXMkkp0WpBij69kEmhaACeX0QLwPSrtZnaTV+j4JyKIIT2g5NBA+CQuIDNreCjQRjDW89GbKB20w/C6nCzmgNE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T3Qh7cAB; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T3Qh7cAB"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-882475d8851so40912146d6.2
        for <linux-xfs@vger.kernel.org>; Mon, 01 Dec 2025 00:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764577816; x=1765182616; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2eJc3g3YpMCQbgaI10ZHeYIFEHAk4BHGKD03PpLocf4=;
        b=T3Qh7cAB45/DpmST+9oRFHxmslGeoYmVjzx/YUVq+LY/QMEUPNRhzetvVDrPMljeQX
         UpilVG/cNZP8C1HoEA9NHWW8t5VzYFMLOzpZHnfWeCIT5plKCPYKS3ZBcvOwrVw/620I
         HWu9Wb8faSnEL+VY9zGXkeJuXiz5uS/j+FHnDPYDT1q4sG2dQVC4HSqGnSoRoEZ9R1P6
         jI4Qo73InDRtLjuv0hi8RWak9TUQwSxde+ExHdwgQ3vJbWsBBOA4nWlzFQ5SX/OXMc4b
         v+0lYSjX+faFk3s86bM1VWKzadoIlKGZ+dGsFhNDY6eY6M5esYUxdVA3ZXGeSP7WtCcy
         yPhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764577816; x=1765182616;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2eJc3g3YpMCQbgaI10ZHeYIFEHAk4BHGKD03PpLocf4=;
        b=IZwBgFMfGbQmb2F50Q07nB0n+Vpkg0GxM0lDRfoZTHmYKb0OY0mMGOOZa2wbpmzAQ0
         M6nafFdMIu0BlO/8m5UwVS/Pwuucakf8QIDWAwhXuhwSGxO9JcjUzJa5EgMxK34Fr00l
         TC0XUKEvnfg65dqbDnD0hTeXJRiVd+WRt4zW/gxwUn/d9XIOYqTF7vvNlCTpAaIMV74w
         mfyUIRzE+cnBXbILhWvqEvootv//LhyYe/OKpHMxPnOCd/rL287u272udajM6aeJ87N/
         lllUlpKQitrf/1ieiUaZVU/SZttaa66DyrYfEbkeGdVjgm4W7IQ/OchaGzo8voE6tq4o
         +gsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWp3Xrb9mpjUBZk70ZWM6oXxoxMiyXbz6VS63TcESyFdXrJlD695q4OkLEvA6xiTJAgcmTg+Pdo2Zg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgYeU81B0+jFQNh1HI0D3XX3s6klDyVQUbOHd0/aS1K331wm7Q
	GPghJ6eo+j4oHk/4LAKXRSh66wotk033rtTXCjXgIMCmXtxC54skr/OqnmZtxC7YTy8dDErk1wf
	9JBzgHWw9SI4RFElYyVW8d+AYG/KI77o=
X-Gm-Gg: ASbGncv/d8jLi9bDaMbPwaFmw5JvhplGtqZNNFty2dByRCu+wkC2S9GMfiwCAf+L39+
	uU2QbOUzDhVvmNBWgvaFi/foqheUtnR3Rafg5fecuojguCIL1j6B5wpdGqPH/mf1ZT62g5lWSll
	h/CUai2vIx9e0rzahN6Si5mWHADHDndjfa9kaiP1Z1wL38Aa4Uq+BycjJMbzKY4aZZjhBiTgFP6
	LJTio3f0/kKMg2YQ91n+pV+66JYyxcpmH51LaFpSEaMZM0EYWT0zLEub5nl3IWbQsZwABY=
X-Google-Smtp-Source: AGHT+IHsCmYuVPkQVfU+yWs4legJ9LdKct4F60FxyJiLbura9Wp1LF6O9gYr9xGvWJ06vP7t0LTxtkuDR8IlXcjYyW0=
X-Received: by 2002:a05:622a:392:b0:4ee:2bfb:1658 with SMTP id
 d75a77b69052e-4ee588e099cmr550604311cf.45.1764577816018; Mon, 01 Dec 2025
 00:30:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251129090122.2457896-1-zhangshida@kylinos.cn>
 <20251129090122.2457896-2-zhangshida@kylinos.cn> <DFAC6F10-B224-4524-9D8F-506B5312A2E8@coly.li>
In-Reply-To: <DFAC6F10-B224-4524-9D8F-506B5312A2E8@coly.li>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Mon, 1 Dec 2025 16:29:40 +0800
X-Gm-Features: AWmQ_bnNbz0I6L6p96dlX3gePB04hX8D_DO2J9xuy2-homPgSXL859tuVJ_3RFk
Message-ID: <CANubcdWbKoC3RgPz1Eb=auxfnq-4_tMoqWiRaZiPcZUxNHYwVQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] md: bcache: fix improper use of bi_end_io
To: Coly Li <colyli@fnnas.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, agruenba@redhat.com, 
	ming.lei@redhat.com, hsiangkao@linux.alibaba.com, csander@purestorage.com, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Coly Li <colyli@fnnas.com> =E4=BA=8E2025=E5=B9=B412=E6=9C=881=E6=97=A5=E5=
=91=A8=E4=B8=80 13:45=E5=86=99=E9=81=93=EF=BC=9A
>
> > 2025=E5=B9=B411=E6=9C=8829=E6=97=A5 17:01=EF=BC=8Czhangshida <starzhang=
zsd@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > From: Shida Zhang <zhangshida@kylinos.cn>
> >
> > Don't call bio->bi_end_io() directly. Use the bio_endio() helper
> > function instead, which handles completion more safely and uniformly.
> >
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> > ---
> > drivers/md/bcache/request.c | 6 +++---
> > 1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> > index af345dc6fde..82fdea7dea7 100644
> > --- a/drivers/md/bcache/request.c
> > +++ b/drivers/md/bcache/request.c
>
> [snipped]
>
> The patch is good. Please modify the patch subject to:  bcache: fix impro=
per use of bi_end_io
>
> You may directly send the refined version to linux-bcache mailing list, I=
 will take it.
>

Thank you. This has now been taken care of.

Thanks,
Shida

> Thanks.
>
> Coly Li
