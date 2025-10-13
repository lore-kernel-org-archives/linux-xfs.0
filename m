Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6342C11ED
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 05:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760334181; cv=none; b=diaI6DhhYLJJeC9pODmmNzU+WuWGvmNx7X+5ivMEXML61fusSSRTbwU0MAlJS8H1rDqO9zSnA6cu4sYzhr4AXpa9MybngDL42SHznaxN5y0wa51VPitsmzgleSzJOuyd6vW3NPlGqMipyTCNDNEy3YIl6jmKLd2MBhLPrsdMXUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760334181; c=relaxed/simple;
	bh=LkiHDxUpll20Mzzyjyp6GAradkAWV81/VhYmzsLwOLs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VZevzshsMu8vLuWNNNmXwIYtUhjQkCXA52GLByIQnYDLHyDABQ3Y8X9ShjxwykkwWfyhl6bdF+sFsO/B90yfAUIby8WIRgTAOaLPIEWvEKalF+FKoiT8QMwHl3zcCysPuu1eUPxmzGSBzRmXo5gg1rP/4JKkLSie218S+0ZqeiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IWCG7q2p; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IWCG7q2p"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-54c0a10990fso1148528e0c.2
        for <linux-xfs@vger.kernel.org>; Sun, 12 Oct 2025 22:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760334179; x=1760938979; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rFw8GX7he7wIYguaN9JzvQNXMrk3Z90u5aRFTT7c2yU=;
        b=IWCG7q2p7ncp3CeE2O5Slzpe2mNztlvZhmi9ntpDYMpxLGBvuzLRHSH+ncBuJYaKD+
         jzc6ucI6ohY6D/Iica3jWOpZd+lh0UGTNdAzv30lo68Fos9U3jAC+xcC2jHVIp/qaQH4
         EKmTWoWaxx1XGMIAKWpSuyQBq+FQggTp+T2YRLmhhPAC1WDFsCEaklEKKoc3gnGZXfyM
         VxHlzrORf8boipLV1lThncDGuIYq55L9vVWVlvLFid8Y81xCaMzjT7xFu169zTPqSlYy
         ot8bM/NL0/yxTgbiqrefFX17lVANYxojBoKcYczeWjOU2o26WB8fcrBiEP6ApN2kkmmZ
         L4Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760334179; x=1760938979;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rFw8GX7he7wIYguaN9JzvQNXMrk3Z90u5aRFTT7c2yU=;
        b=GMbOCjPN3rEj3wijSk/uHXqNQYzq+77nBkhulKST/d7V3ZGcmm/EgntyvWsOERju8i
         WsuktBfNCtx8ufUd4FqbaDkpWkRTaOPh/KW1JtBGurEFN5doFIlLvPOSzS4Tjl2TcsAl
         y7d8fPZZF0XRBl21LbJvrsxxVZemqsF0DPu84fi8weYDAT7RlxKsmHWsZGg8SXEojC86
         0rDqecg1kjUyrxsx3gNvWbHC0Rl0/z4xJVC5ZdtZ6cxWQdzg2d7PGOCW2P/+4nlCr61r
         6Ct8pWWnavc/anc/BpYvjqo1m95glEh6L250jckdwzAUrVE3hxCgnzapT+PQS1V1LO88
         R9qQ==
X-Forwarded-Encrypted: i=1; AJvYcCVE71BEyn5p49kLMdiY240z17V4ELsp2c5eNMMdx1OJJnVv9HzqexMhbI7qqfi1w5n1VMHccRVmppg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8ynbntw+bIT+Du1/gfMCo1mTN8Jrzijw7AuGjSpoCmDDYRcV5
	nwphgmI9d8rlKKzBW2HxPhZbBQlD35BC7DNnM1wdUEKmdDb2U2LWdEB9kL5K9qs0Wo/oGwlikTK
	esNX0RErO0D5OHVqE6g3ckycKiyH0/Rg=
X-Gm-Gg: ASbGncsH/oPpHhorbtsgYxbj08PSWdt7Ky3qoSjF16vE8ZIQjWqm9iiWfisEqyOS4iu
	p0RZeetrWfqvBlDpab823+m5m41USMkJfcLsoC9jpDgIGIbyvHPl0FUh5LDaRiy7v/I9URsvPVM
	c/OebyUITPELCpyYT3QTDOKv5EFO3kRBVcXoBcZ/F8rhPK2jWY+GFNGtaNqtnFhhdMEP1EQagJI
	quJKgPc5H8D0EUnjrnXyLYEcVe3QLDTrIvahA==
X-Google-Smtp-Source: AGHT+IE2pzpIXFUlQnxpSAUJmDsWbuHYPNEdEfC1GOsG6qkn6Ggw30mR6TSMqPTmSaIF0L9e6DD5b5ldfGpQurArkk4=
X-Received: by 2002:a05:6122:91b:b0:545:ef3e:2f94 with SMTP id
 71dfb90a1353d-554b8aa8d4fmr6241006e0c.1.1760334178612; Sun, 12 Oct 2025
 22:42:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251011013312.20698-1-changfengnan@bytedance.com> <aOxxBS8075_gMXgy@infradead.org>
In-Reply-To: <aOxxBS8075_gMXgy@infradead.org>
From: fengnan chang <fengnanchang@gmail.com>
Date: Mon, 13 Oct 2025 13:42:47 +0800
X-Gm-Features: AS18NWBq65kKS67xgSwyGWf422mFA-TjXvUExYQYDBZ5JznD-_4en1JwPHXcFWo
Message-ID: <CALWNXx8pDOvDdNvw+v0rEyi33W8TL+OZW1YiFbF6Gns3PeWOLA@mail.gmail.com>
Subject: Re: [PATCH] block: enable per-cpu bio cache by default
To: Christoph Hellwig <hch@infradead.org>
Cc: Fengnan Chang <changfengnan@bytedance.com>, axboe@kernel.dk, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, jack@suse.cz, asml.silence@gmail.com, willy@infradead.org, 
	djwong@kernel.org, ritesh.list@gmail.com, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2025 at 11:25=E2=80=AFAM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> On Sat, Oct 11, 2025 at 09:33:12AM +0800, Fengnan Chang wrote:
> > +     opf |=3D REQ_ALLOC_CACHE;
> > +     if (bs->cache && nr_vecs <=3D BIO_INLINE_VECS) {
> > +             bio =3D bio_alloc_percpu_cache(bdev, nr_vecs, opf,
> > +                                          gfp_mask, bs);
> > +             if (bio)
> > +                     return bio;
> > +             /*
> > +              * No cached bio available, bio returned below marked wit=
h
> > +              * REQ_ALLOC_CACHE to participate in per-cpu alloc cache.
> > +              */
> > +     } else
>
> > +             opf &=3D ~REQ_ALLOC_CACHE;
>
> Just set the req flag in the branch instead of unconditionally setting
> it and then clearing it.

clearing this flag is necessary, because bio_alloc_clone will call this in
boot stage, maybe the bs->cache of the new bio is not initialized yet.

>
> > +     /*
> > +      * Even REQ_ALLOC_CACHE is enabled by default, we still need this=
 to
> > +      * mark bio is allocated by bio_alloc_bioset.
> > +      */
> >       if (rq->cmd_flags & REQ_ALLOC_CACHE && (nr_vecs <=3D BIO_INLINE_V=
ECS)) {
>
> I can't really parse the comment, can you explain what you mean?

This is to tell others that REQ_ALLOC_CACHE can't be deleted here, and
that this flag
serves other purposes here.

>
>
