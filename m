Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647C6285CAE
	for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 10:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792405814; cv=pass; b=W0WZ/ZCJ9sWFrqdOxZzl+CSWTS3IdpFXzV39EXgX1KcaoXYZC+SSemQenOhVI6xfo5D0s6uzUMLiDbd5ixFwuJuAXIEn6aVzdR0p3fz3zfJpT3H/UY+BBGNUSoL+GAiaVrQUkJzPrmJ2gz67AkCT7fNTDAJEKsyuTeiJF1iRY4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792405814; c=relaxed/simple;
	bh=w+Qw1NJ7EznQQFGT9BDIAW98bhAEyfZHFMzc+72qucI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VftqxjsoUxDww6Sej60wmflhkjXt7gR4OgQWlgKN06arEcOBuJmOzRuinxQVItnmt+OQ3P0DYnPuQbaQdrSzUgjySnEoZjx/Rg3MggfskBKNMg/S2xtbBTjsogqIfo5v3XSAxdityVYpfRJuS21gHvHWDuNjZWhY1WL6hO8LpXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IaHVD2JF; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IaHVD2JF"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c34bff61551so261880766b.2
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 03:30:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792405811; cv=none;
        d=google.com; s=arc-20260327;
        b=pqpOW4G3Hz6IhtxxBs2Di5dOduN2a1RXavzwijCEkl2m2/0FvfmJ0zmITpmpKvYvDD
         nXWAW3JdT0VxeOnEFO0UqjELxQwhe8veem2+D5ncI6QC92tqJtEx9xmOS5gF3rmyyQzW
         Cqn8twO39RMX3NpKnJlzY8IG6IzX+x16mvj7X+RXLd2s1GamM2GlT13g8LSUhKjWdoBd
         5qv8vs+M3AK8Ix/sC8gy81wyNMFw9ppvsgzmZznlfq2NvPZUmdiU42uLuzjx3sTsoGQY
         lcMoE/Aqi4pyrp33NB3gJhj+RsO7QT9aLY8cdShMAvUTYj4UxMzcChVxONkOAC4gu2Os
         jrrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=hDMlxvMSsYfLSEsRi+m3GMMa7nMDtPhzoMRARDxjIFo=;
        fh=9Hqx+s4suZMdmQEwV2reTRlWEhMH7dKUHX91iJiFXl0=;
        b=FAVFFwXRv660oZZk8MlvgIgCRTxN6ZHkyOQN5pML9MMNKcAOW6rIhOANky6EJRmSGJ
         4+XsiRI0OhD7BqMz4DdWC8u1UtmqRfaC3YhRm2vY9q/+37mdSwKoJIZzCcmvEYMGNOR4
         l7I2k7L6mJHstacJ/4PFXJzuxTvjsES7m00rV7riBUmtSXN56tn7qz1iSJHmlPTeeV62
         l4scfzxfleweIWoP0ob/nXWnOjgw31bjlqi4wl8RM9U59MAQ/BI9cp5wT9PaZJtCIX+P
         CZ0c44NlDylyi59s9urz4BATO5SZkN1usb2nQ37sckeBcXe1YwuI4Pzl6xeC7SQ/hyTi
         lXiQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792405811; x=1793010611; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hDMlxvMSsYfLSEsRi+m3GMMa7nMDtPhzoMRARDxjIFo=;
        b=IaHVD2JFW5QpQ94PKc3ONpS/3xBNTLZOJ4qerCzcPapnAEb/tpEJdg9vZ9WvitSU1C
         A7/+QnoKHY4O2Gy5pvgBvsBLFcpJ548voTmEqsFvzodzvO6xF5ELKb3rCApsY/clRXnH
         iLsL0/OmBy6G+GGy3hdlOm4swG5Wr0lo3USLGe/i4/EWLcBLhJlnRjMO5gGnf3G7OCGr
         m4fs9qcviKiRBpmRf/xdI+M+9SXMlb+oQ4QBaxUr3KSeSrY91BRk97tY7Z/sVB/dRmBO
         +clhV1BF5Okuk1RwjV+RoNJgpwZsLaznW4PBEqdpOyqDzmEnACG/RadDVHN6RJZm2lVq
         /VXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792405811; x=1793010611;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hDMlxvMSsYfLSEsRi+m3GMMa7nMDtPhzoMRARDxjIFo=;
        b=X4vsnhJvnyJSC6kaQYkYlymXQNu/GWdIjJMop2Ms75N2/56QHHnYVU2NJENTAVN68o
         C+nTNIbI4QM7MzTwJ1YO2CvG+yvT1gl4vyVqN9O9QbhtNd1EIyQ/Kk+peF98KXNw1mct
         q6omHGLU/lvSZ/sAGW+FeU8nhNmyl7b5bH2gsaGdUnZFVchUctwYBitEOGT4WV+uTveG
         fUPVA3jPvw6sZpLfskgISala/g3K8yyj5ssHZACpiKDBve2Hlxj34745D8QePZxD9Aol
         YTXGcDGNrmpjYkJLf1SJCS5A8wgJgy3idudioxSvpEi4pN+hpSp0QLMTEXxe2njHv9wt
         WDqQ==
X-Forwarded-Encrypted: i=1; AKwUvBwb7R/bIjWqlOV6OxvzV/Pp2Jw6jDiv1zomwIFFZNebQgoQzGTbOuuX9H20n+A3PmkulyWDhO8rGQI=@vger.kernel.org
X-Gm-Message-State: AFq9FYIBYqvB+dq8Q8uVJ+dJFEup6cnteBGkfWVSrtJjmYpW17fM4K3k
	6AOXk01aY5q5Zq35tDB2st5mNACysGawWRftyL4I+qBGNSkNGcptQsDlW46ptR4Uw681IcgH35e
	pBxmLKt4tiI4a3s1nhZWPlmea83f3OQ==
X-Gm-Gg: AYBFou0qAfkLl/BPNKbhCsIo1kb7IoNeq/QCcfd8SeD2Z+8rdkiRO4hYmI+cLRFCD/I
	p592KcSx36/KYCFB4iNCdcyECHtZnwB2M077THC2cYM56qGJyZdcMDffJyZaRuaJMdOxS6MuUcC
	2LnCftvZHzoUgrK8Eq+3ufGG5Cuq2UInZydAwvAbp+oMQT4v7uFgOtN81uZY/Q8S7IXxzP2bjtR
	SRDiN+HL7DNE+iecPjvs8qCE3W0ObBybaWudK9tuZKfNaXHtfuctyfFK5sc/zWuUMUkFFcjKsiE
	c3BwrTSKr3eCyrXuuJPCrLqAjaqF/5O5eo1j0mr4WKqRqC33k0qk02B6p/LOZcrjUITF8yxY2xN
	3y98uga2VmXI/MOT5r9kRbg==
X-Received: by 2002:a17:907:94cd:b0:c34:83c0:b92b with SMTP id
 a640c23a62f3a-c419e0372e5mr550966966b.23.1792405811317; Mon, 19 Oct 2026
 03:30:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261016091919.971295-1-anuj1072538@gmail.com>
 <20261016091919.971295-5-anuj1072538@gmail.com> <20261016092855.GD23141@lst.de>
In-Reply-To: <20261016092855.GD23141@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 19 Oct 2026 15:59:34 +0530
X-Gm-Features: AclHuK8ULi6B2WLcwQV3l7PwlG0hY-H7b4F5ML9dbW7RnQW2ii_Z4DBtgA4I11o
Message-ID: <CACzX3AsF4t_yLoWpN5t5jjhxb4noAXuyFdK_-F_FdLA1gmMYSw@mail.gmail.com>
Subject: Re: [RFC 4/4] xfs: support dma-buf registered buffers for direct I/O
To: Christoph Hellwig <hch@lst.de>
Cc: asml.silence@gmail.com, djwong@kernel.org, cem@kernel.org, 
	brauner@kernel.org, axboe@kernel.dk, linux-block@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, joshi.k@samsung.com, 
	anuj20.g@samsung.com, nj.shetty@samsung.com
Content-Type: text/plain; charset="UTF-8"

> > +/*
> > + * A realtime file's data lives on the realtime device, anything else on the
> > + * data device. If a file is switched between them after registration, the
> > + * block layer cross-device check refuses the I/O.
> > + */
> > +static int
> > +xfs_file_init_dma_buf_io_ctx(
> > +     struct file             *file,
> > +     struct dma_buf_io_ctx   *ctx)
> > +{
> > +     struct xfs_inode        *ip = XFS_I(file_inode(file));
> > +
> > +     return iomap_file_init_dma_buf_io_ctx(file,
> > +                     xfs_inode_buftarg(ip)->bt_bdev, ctx);
> > +}
>
> Ah, this is where the previous cross check comes from.  What about
> simply disallowing toggling the RT flag with outstanding reservations
> instead?

That works for the current exact-file scheme, but not with Pavel's
shared-context proposal[1], since other files can use the buffer without
registering it. There we can validate the context tag against the
inode's current backing device per I/O.

[1] https://lore.kernel.org/linux-xfs/4649a20f-aba9-418e-987f-66f21ab24410@gmail.com/
