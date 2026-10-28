Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.176
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793204284;
	b=pmFXu5BrGQs2YIKU5CrST+qEwvZIa7ZL6kOI3hpXP2p3nDUWDUtHwnfE+zniY3y/918x
	 Ix3P6jsSzyYBZ6aQUrfb4oTEP3+KCNEaVIU6NJrp62x42J6nrShHbN0UDn9V4DVH5bG9C
	 u/QaJZefSNBOv6ozxGQegxXY4yi/XZ/d6We4KnCKTXx3nx1Qz6vjHCduIgGb5TA7XJgsK
	 CTcHmJ/vzMPzjRshTnwHMCeP1nlMnlMeb/Q53X3r+m/YLHBsRZMwbPGql/EQprhGBWK1u
	 VK7RnakQ/d5pVDz4EdDcAdMdZxK6/s07c+Q1IF60cBn/DR2dwZhVQJSg8fgh4T0KcYg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793204284;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=LR+4Nh8FYTRY8kZRrhgD+RKAvmlbTqJy80aNBobHu6k=;
	b=MhlWcANfffgXXrhnmTgqi5KKwI7GkuDJ3UeUNjGijucAtUhv+7ZKrYma8Izz5LT5i1Bu
	 qSY+HMhe/TgrmKw5Er7EIekryD3caymc+9q4LzR0dYdPzkA4Pr2cNo8zA8MrRpHubnXUT
	 QSJtzm8nvUy9oW/eMqX+B5NMjZiPqifVOEzeBBvkNCDQtdYWt0PZVeZPBGh8xk2EOViwJ
	 DJrwhZofUZqJlN944Sm2dQzaz1T3vQ9s0K+0XseBGXdJMfb8O0dkOv+h+IOzFvdT0FEor
	 RfcCt2WKbdwV1qXOQm0vFaN+Bgv/3kz18I+OJy4VzssSoAigM0AcUfP5K1P7i1fefXQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aE0UVEPl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C12606A31C
	for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 16:18:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8C12606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aE0UVEPl
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-886e61fa30fso609635b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 09:18:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793204283; cv=none;
        d=google.com; s=arc-20260327;
        b=QY8jMMP909uhXZ6cbFhtvaRpi18gdDPMdsi71xoQja4G56VBL4mRRLkiO++HSK1VOo
         O3WlpmIm9BMoJ1IGS6LIey63yC8A1Lp3n2c4OHef5IB0i7y07TWmzA0YEI+Ct0GNE776
         UVZbCizzcyEe3dnrFRJgac2wGqbh3sjrJa6rwJbFq6oJjG/M+f7vhnQswi1fmqKnl03K
         ur2zv5FLI94BOIM8R/QSvrxHAjNbYML334WBkmsoMTXRvh5BURmBOhsCcm8Kv77TFPB6
         BplfLS+FOBsgVJZ9us7m5KqE7m6XD3djRk4XSDJOF2yJuU4BTv/4HOA0Q+F4uwKC5JXO
         Buag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LR+4Nh8FYTRY8kZRrhgD+RKAvmlbTqJy80aNBobHu6k=;
        fh=KgfmdeaZUvUsdzoot6w/GIQFtRMYwWhV5K4w09VLOgE=;
        b=b+ykwmHjKaCYtqcnWi1kr0uwWd6IeapGk5auXh/Z137ZCqXaHxOEIPwG7iUo78Iha4
         NBo+Ji4XFbxgaCVudSnfKZRpj0XKsp0kOEIdK+UM5vDAyC98Ixad52F5ieBc4+Q5zqf2
         NcurRPX4nlMUstXg8pZ6WWmxN6CDs70nR2nkoESv4qF5gnRl18n61DdPfXEEaJUNipdP
         UdS0PA4IvNgWu72xLQcxiKaJB9Pni6LY92N7idVvtr0u6gyFUy2e5QqGzmFOK/B6cU5I
         a+vL28iFfYqRzuYUNMTlme1CumRDXGu0gB+vFi2pb0zdO9thfgxh/yE7g4euE6NN2xJn
         WmRQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793204283; x=1793809083; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LR+4Nh8FYTRY8kZRrhgD+RKAvmlbTqJy80aNBobHu6k=;
        b=aE0UVEPlAf/V7Y31izbriey87faIFsoS80MZfhPz+nDPK2fFTvb3pIODF+rYWahhAL
         IE/GRtPxJFWJY401Rp92EZ6jNjNQiz4DcR1KQKNa6Wrp8DP5JXEhIV3bawUSZ6OBMF3Z
         Fag/CZu8p4S0vDV+pKLBKXG5EdyK4ORV7TOV/oJxfGOY2FaA54ToDtf6HylO7ckImk9L
         EZJGWpNqqI1H/cea5knc2AQwEuMaFuJBcGtCUYmE2I6v4kVZDruIbLWQjeqrsqwYkeKv
         brBqy/vSgeArKD9ZAiQYA43dPDFIFx74Cu6p0i9jVLMzAd7CHb1//RgOJp9+fhNk+tAC
         6PvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793204283; x=1793809083;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LR+4Nh8FYTRY8kZRrhgD+RKAvmlbTqJy80aNBobHu6k=;
        b=24au08pSqonXvnqo3d/J5elPE8XFzYx1bmw+Fk14OjCkEBWZGD9upGXYZuST+mvElY
         z938wFqj4j0my7zOINThJmzZknXveO30mz3ezDCY7z/fRT8SiacUyyb4l5Wrw2fXKVBJ
         5Grv/KowbkB0p1Yq6bX23640Sz4QHnL77VsCv7vdqkmxQj2G389UasH5r8lEJgtJU8cf
         +FfScRaE7qRomC8YkPZjl//zzjN69zdwhPYLzdtggPgHMxcaw0O7g3CVJGe+RUH5dRYp
         Hojj7wu5yOshPVxaa9RwYxLR7wicSi4Cs2ot9E6Y5KFaLNGRPdwts6p8S2o8mSySUYUL
         t0Lw==
X-Forwarded-Encrypted: i=1; AKwUvBy1AjmbBZYK3ilygoEJL6tofny+KNS3ruw+phhM9g9SbnaFv741tK/w5st6RXyAlnP09A0+jzW49ig=@vger.kernel.org
X-Gm-Message-State: AFq9FYJEWL7UzJVMBKUPuZPJmal/guWvi6QriqnaGRt+h3irgeSauv+A
	K9KF9C8N91OYE/G6kxi/0qJFEXC2RERFEpatxvczyyTF18OPVt66D2TojZAcF3p+e5Yf+TVl0fM
	hnfi+aKhLoS4xdeBcVq7PnTrj1TgizII=
X-Gm-Gg: AYBFou3/FJ1A9a0uRFoxBDf60Eqelqcv3OGd7zzwp7XHy3SAqTKhzeo26XcU0vtC7Hi
	qbV7fB2qxmLbBBehlYtms8ZlNACGWeHpUCrlE1bIRp4v+VhhTdbokRVu1XM7IrGOWpdMJ5uGCji
	ZUb8CCjgRndO8waz9i8bZvovgGdbx2kIWizyndd28wZmL8R+MytMMRzlPXfm6o28D2kms2P7OUw
	6x+HzMJSJg1EDFrjNllzjepMJYkOyNDXhLEansyIXH1oY/iJYHphPmIcUS0vbKXb2MG3MN58SAK
	uwsdlpKXmu2a6lqBzoXd9552RTbDXzHvGdXjWXA2uIoeaffsZaP76uI7GrxxwQMAIFsugenAWHV
	MRwXf2zIHecrHqm4m7MZWVKr6aJD5n38Wlb5pDA==
X-Received: by 2002:a05:6a00:391f:b0:89e:9560:fc7a with SMTP id
 d2e1a72fcca58-8a6e6efa7a7mr2168656b3a.29.1793204283163; Wed, 28 Oct 2026
 09:18:03 -0700 (PDT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261027215326.2693300-1-joannelkoong@gmail.com> <20261027215326.2693300-2-joannelkoong@gmail.com>
In-Reply-To: <20261027215326.2693300-2-joannelkoong@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 29 Oct 2026 01:17:43 +0900
X-Gm-Features: AclHuK91pZpqmliH2N1ROYQZJFORz_xx3uP0uM_hYUkPFZ1oO9AzV0q2NKIx0ms
Message-ID: <CAKFNMo=Kqs0T=a578WN+=PZ2gse2APWZ_jnJ64XyrerFK41sXw@mail.gmail.com>
Subject: Re: [PATCH 1/5] nilfs2: convert iomap ops to ->iomap_next()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <djwong@kernel.org>, changfengnan@bytedance.com, 
	kbusch@kernel.org, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Jonathan Corbet <corbet@lwn.net>, David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Andreas Gruenbacher <agruenba@redhat.com>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com, bfoster@redhat.com, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Viacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Zhang Yi <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 6:58=E2=80=AFAM Joanne Koong wrote:
>
> Convert nilfs2 iomap_ops to the new ->iomap_next() callback. The callback
> is generated with the DEFINE_IOMAP_ITER_NEXT() macro, which wraps the
> iomap_iter_next() helper to finish the previous mapping if needed and
> produce the next one. No functional changes are intended.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---

Hi Joanne,

Thanks for picking up the newly merged NILFS2 iomap code and handling
the additional conversion to complete this series.

While this patch is an intermediate step, the changes look good to me,
including the finalizing conversion in patch 4/5.

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks,
Ryusuke Konishi

>  fs/nilfs2/iomap.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/nilfs2/iomap.c b/fs/nilfs2/iomap.c
> index e130ed63abd9..359786c97f2b 100644
> --- a/fs/nilfs2/iomap.c
> +++ b/fs/nilfs2/iomap.c
> @@ -67,6 +67,8 @@ static int nilfs_iomap_begin(struct inode *inode, loff_=
t offset,
>         return 0;
>  }
>
> +static DEFINE_IOMAP_ITER_NEXT(nilfs_iomap_next, nilfs_iomap_begin);
> +
>  const struct iomap_ops nilfs_iomap_ops =3D {
> -       .iomap_begin =3D nilfs_iomap_begin,
> +       .iomap_next =3D nilfs_iomap_next,
>  };
> --
> 2.52.0
>
