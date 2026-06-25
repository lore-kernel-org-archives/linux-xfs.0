Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C61436165E
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 20:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782420386; cv=pass; b=POo5t+CjG0RYirQ7WL7H0DxziheenSeS94vmjvj/gI/O3ZjciyjMZirQP8X70gat9TeJPjsJOliVQ4GxtBLqk1FDqUuTiasZQq2wuDRWclMl0mhXcHeu6cdCPoDWrlM9DjSwXNZu4D0H4x0VNL+Bep01iZVydNzC+1l04+UIxG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782420386; c=relaxed/simple;
	bh=HaomIJc4u8uV5s3jV8UCaYpd7LDFvMKtwdb2kF5+QTE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eGDbhToo8/CRC9QJYQXNfuW5JO5d8mAiTSYl73WUobitlTX64+zZDxqODCsSDqE122tsg0Je+gUtUcrnFAYXUE+G6ZAFQfyJu9eUWciCLE+3kAoNyDsIaC9WxrY3Dd0cGic8JMTivagxR6+BrjUHa2Q9UEujf0yENRsj7cdF16o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EiIhvuzg; arc=pass smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EiIhvuzg"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490b4a8e28bso2986465e9.1
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 13:46:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782420384; cv=none;
        d=google.com; s=arc-20260327;
        b=l6EamS8ivUaoCkBrQjBNifXkHDFAUrsq+7Z3Ywj4p1OCESvIa+9a9H60FLaXy1Khjs
         IrSngS+ySgK3fZA5oURne3RGDatYk24JOJczkx2cotkT0pAGpsJ+nKlgX+MDh4gOqxGj
         kGKNQM2JgqLJuQqY0omZvZQsXKILSt2azPVeAunAvEeFuBYSBC09TRmGfp/6FkBxNMbZ
         DBZPRrbfcOajtHhNZjw5gbw1PZikBuY8JCzXE6aOqjRSRM62iAzGfTkjHHCAPVl+SNPl
         qnFOX+9HbjC450/7vrgrpKq9KMRkBO+4iAi3/W9nCGLGOwrj2wM40oDDlxEgdPdXqhBt
         M5pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fAXfS4CBZdCJEVQc+BhQ1oRfBye22ZsCLRnQyf7mhxw=;
        fh=cyrbGEi8y2sfzM/I3TJYVYIKOBZ0u7eQmpgcvUsAGiU=;
        b=rdKwWXzacmVjAWhGSkmLJ1RtWsVoFU6TrS6jNMCoxoMB+sWE0xFQvVdiw5ofpxuTm3
         dcDzDdo06FCmKxHQj6/c+BGeKCBk7bngKX1a/qFVFv/0P1vTH0gABQ1YFFULEYdATGeY
         T+goCPRScFk5hs/0ZpPCY85ugiCFsTfgAmUzPM6tMTwz6SzGkMQEGRADgtedZe1GQd6X
         vbdjFXNNmKtOammnHvvC/vBSI5ryI/5RXT+6OAjjn9kd1rxGcAPijfgfOaDPjajDc5QR
         dOorpwM7VlKx4QxllqaZMZoARqFvCFqjXZ1qma6vOltNXqccVPp7tQl6lx0Cz1AgejL0
         HrZQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782420384; x=1783025184; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fAXfS4CBZdCJEVQc+BhQ1oRfBye22ZsCLRnQyf7mhxw=;
        b=EiIhvuzgxNYirqLKBSo/yH0wjd6874AAp7N6qM7fE6nbqC50ToXn5bwP2FlAGypa9m
         0WWExNGyIvtu4nr1gr/RbPtVS+YotC8/ICcOP7IIw4oXHQH2xzIrim7CQleAMenCkzB8
         a059xWHt/yajq5lQSuFkfEKvga5u7zejCA6/OTohQgdjqeqr0cPtoGm7e1Vjtg/OyGtm
         gcZWcPgmsJslOerTVMO2LgnfBOPsLoE2iq+HxKCeGuGMciiCtnN2mhcqJ4Q6tQ5h6f92
         ZJ/pMSOTvpoO5lAVGtNFfwPX/QvDZE1oENs9SsHc7j6DcaOLhtNfQw2fHOdA+xU/dRBC
         czRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782420384; x=1783025184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fAXfS4CBZdCJEVQc+BhQ1oRfBye22ZsCLRnQyf7mhxw=;
        b=BXJsPULagwthSvyzDkEB8x2t9I/3nyWcjf1oaQZOaCWZd26WoDa2dwMS+8lv31Wcmh
         Mh0fsl3To1BRsIaKqtnLcz2NsNERFX0ceNsdiHYVKmTcqBLKe1621ApykksENyNYNKOv
         I8LUyJB8IULsgikYs19RhxZ8VLw5l6Ju2nVFPWt6/adtibcRPELxra7R8L9OxF4tuFW9
         4zxRiHZSjHHZHdxTY7/p7gziG7G3kOJ5qYT6FOAR2Eai/q/D4ZTBdmIqKPMwO1QBWjmR
         6v1VGCh7wcEwngWr60chGdQAIc6JPm8ygVluAJVNyo7VCH70TdJWaqUPJAdBgoAFYfCo
         Kq+w==
X-Forwarded-Encrypted: i=1; AFNElJ8FY/bKp7XNlAfwebDUGda/JJzWBQhlgDuEE4myx77n2+sVMmGggUk8hv12wxPucZ0hKFa0cX9MSBM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyE5auKTWeh3vGKEf+A4I5I3DUSMg0ck4INQCjDr+hFHK03+mSK
	Agza0JPAdGaq+KC+88wWB19jJKLAm7Au/zTX5z1+S1+Hfv+UNRJXM2J8xe1E0a0LG6Qjcuc/pdh
	IB6swvXWY/dYVfShggr7BXFbB4+EqhlU=
X-Gm-Gg: AfdE7cnS5p93ocdVhAkmcXoqQb3sKZrAdFOFdzE//lza9RYOJ16q0btDawnozijvzt7
	joRyGdlkm9EVnpgMaEM+YuxkyKslaSrKUl8EnjGxye5M+4pp5kAD6TQdMApDD9zTaDPM9FmMJ6J
	jQthoic0i1NldipULDzStSuNrUWobBkH6sulOc2ZkRBfB+JXwecSX1ov0Lzti73I66KXLQJundy
	fzUhDz/TVCZGS+RZd1dDmIA3dMr40w+y/HiZdy2TVTp2W+RD1wSMPZ6gsogOTF1ozc3NcmzQZuT
	k4B81LafjyePwiNfn5Nr4iJn5Blb5VjEkrl7kX2KHnzZz9oBJLBy
X-Received: by 2002:a05:600c:6215:b0:490:e180:2ed with SMTP id
 5b1f17b1804b1-4926683879fmr52200165e9.4.1782420383858; Thu, 25 Jun 2026
 13:46:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260625024723.1611000-1-joannelkoong@gmail.com>
 <20260625024723.1611000-4-joannelkoong@gmail.com> <20260625130052.GB22620@lst.de>
In-Reply-To: <20260625130052.GB22620@lst.de>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 25 Jun 2026 13:46:12 -0700
X-Gm-Features: AVVi8CfoOIpJ3dhVoByHIMdE8LKxW__DmkmAxVoEMGk8sDBKcpsewrJWmavq_XY
Message-ID: <CAJnrk1Z=o701G_gNFM2MNaQPN9_vFCxfK3FvKSjz6pf1Qwj-YA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 3/3] xfs: example of devirtualizing buffered write
 iomap callbacks
To: Christoph Hellwig <hch@lst.de>
Cc: willy@infradead.org, djwong@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Fengnan <changfengnan@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 25, 2026 at 6:00=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> On Wed, Jun 24, 2026 at 07:47:23PM -0700, Joanne Koong wrote:
> > This is an example of what removing the indirect call would look like.
> > With the inlined iomap_buffered_write_inline() that gets passed
> > xfs_buffered_write_iomap_begin() and xfs_buffered_write_iomap_end() as
> > constant callbacks, the compiler is able to call the callbacks directly
> > and drop the indirect call through struct iomap_ops:
>
> Nice.  Btw, a more critical path would be direct I/O.
>
> Fengnan, maybe you can play around with this series and your direct read
> fast path?
>
> > +     /*
> > +      * Call inlined iomap buffered write and pass constant begin/end
> > +      * function pointers so the compiler can devirtualize them and av=
oid the
> > +      * indirect call through struct iomap_ops.
> > +      */
> > +     iter =3D (struct iomap_iter){
> > +             .inode          =3D inode,
> > +             .pos            =3D iocb->ki_pos,
> > +             .len            =3D iov_iter_count(from),
> > +             .flags          =3D IOMAP_WRITE,
> > +     };
> > +     if (iocb->ki_flags & IOCB_NOWAIT)
> > +             iter.flags |=3D IOMAP_NOWAIT;
> > +     if (iocb->ki_flags & IOCB_DONTCACHE)
> > +             iter.flags |=3D IOMAP_DONTCACHE;
>
> We'll probably want a helper for this initializion boilerplate.
> Or make it part of iomap_buffered_write_inline somehow?
>
> > +     ret =3D iomap_buffered_write_inline(&iter, from,
> > +                     xfs_buffered_write_iomap_begin,
> > +                     xfs_buffered_write_iomap_end,
>
> So we're not even doing the _next scheme here and already get
> results, nice!
>
> > +     if (ret > 0)
> > +             iocb->ki_pos =3D iter.pos;
>
> Similarly here, it would be great if we could somehow avoid
> too much boilerplate.
>

Agreed, I think this can all just be moved into
iomap_buffered_write_inline() and then the call would just be:

  ret =3D iomap_buffered_write_inline(iocb, from,
                xfs_buffered_write_iomap_begin, xfs_buffered_write_iomap_en=
d,
                &xfs_iomap_write_ops, NULL);

I'll clean this up for v2.

Thanks,
Joanne
