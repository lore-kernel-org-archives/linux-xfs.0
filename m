Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D893009D4
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 18:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785351467; cv=pass; b=B1ojt7F5v2J2YFLjMO5oQua5aRM8pd+VcbES5jwz/kH5JMdnLVvEw1z045PJ0e5jBGyFciF5P5uhasKrp81u4KLY8gkkFj0gU0DAmgazXhUTmTIx6ZPekMdzfDzzCj4GuvOCjhLmS8FBlJIz9fpzzKcx1o7qR1Y9XUnGkocfpz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785351467; c=relaxed/simple;
	bh=KPTM8WsrM+BqDuldSkxfB5b9uV+pWlsBXXIQBR+/rKI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hLY9YxlyJVTBzve74YE8dBtxF5K/FLg0QwEiCopDdeFgptY7tEy+UgCsL9t121dDBaznaCj4gRVACRM5ZzFbOLSoLrln8IMFIMzace+ou2iQsDHUUuTpm8C0BC3NhLqnniLOqBxmfxEvtRp146pnHHUBqyvaI8XeHIqAp+XzuSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HG0tt/YA; arc=pass smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HG0tt/YA"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47640541585so1013075f8f.1
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 11:57:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785351464; cv=none;
        d=google.com; s=arc-20260327;
        b=lRMdo0uf0T/BjadfgsGcR3/exA6N9UsZYr6np/0eazPaYJ/3n9Bn21U66HBuh75fjn
         rO5pEU7N86A52WBW1i6amBBtZ+4vZPNgEPAhfPwwdfqIL4zl/n8phO+Cz713gQfjQzDg
         ofrUWOkXdGp4AxCjP4H/0o5QDXyyBmOrd35ocVUeUHxEWL1FF8frpvyB80VZRAFj/w6y
         oyharXN66EuTyrCWzZiZvoqLEoGWNQUKbALmKtEHRoTyhZibsKrpEIBoZgAt1WHFLRHT
         JD7bRByEMqmMKo4aHPCPRN0aiBu62Nk7bSHAzmF2mf24UKv+j+EYpoC5pU+NgmCSDVth
         K42w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hrYoz+dHSHJ6SiWtUtRhVIViWrdquT77cC2xckRZ/s4=;
        fh=An5sKKFM7+iW3u3h5lMTmgFmb9SAblVzajHsHJspf/k=;
        b=N0ek2G0/RztdNGXzMdB+sVL3nnHqdK19EbWhngYjWQbx8OH6gSrSdRbMvIsDx2OXZD
         Ff2767Ic8NS6JnvO5aL8v1j8DS0NjXRtpcBrcp6yxWa/M12NeHyz+RGcBi8mnlMfwps3
         /sFSEQvrDxsa7oI0Z2/wd5IH2tmqDFyKMcWYWGAVJkVGtffQl82hHAuOEeDksl8UTrQU
         W/pdOTmpcdRdcrfvle2SX1cXN2SaectyLKYCPanURtYSlya68zgGbxAOHpNDP482L13A
         dmycfi+HMh+qCVP/8yUfaJuowjqsw+p25sde0vqjG9JH+HNTQPJvjgg6+8jvzviE0xsS
         h5qQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785351464; x=1785956264; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hrYoz+dHSHJ6SiWtUtRhVIViWrdquT77cC2xckRZ/s4=;
        b=HG0tt/YA/SSLfwLylBcNQhEwFyWO1drr3eRQ2k8B23pLjX/HI/2cb2evXopALFvuuk
         MAFC6cRYVjBdqMBoSW2+zuwN84/HqCRN3O40w/7tZWCeNwv0TUt3vAD+BiGVToHDx+g0
         1/1vFeXQ2C3WQFDDua64DpArALa8XLd6ttONE70FinI5kKaDBY6Hdwmtp92A6XKzD4CQ
         S+/6R412oyLDPlk13gILEfPil8d/9Ca6o0sb2L0ETV1/MSAC8sLudxzOpLpVP4Ys8gVS
         sUjqUqBnjydvSZW21v4EyZOx+/hTh3+245DMaYmGIIEveluYyb1EcsfN6VIQ6/qQOOHD
         Qreg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785351464; x=1785956264;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hrYoz+dHSHJ6SiWtUtRhVIViWrdquT77cC2xckRZ/s4=;
        b=A0Ja15a3mMyw5Gujsn465D+sHDLgBRbxw8+u/uyA/bd6mVgcX5NN5PhhABGgQlWk+E
         AyqyRMRn50OIZAwdXFETuXR9MQGGHHSTbKi0nyn+vPR5zyB+UXTpbzV9qyuIR1lnXvFz
         ordaYKBNs02xeuTa395pg2eynF7iX5UtXgQJ9E1h2liXZFr33eniN825rwnVxnPbp8Bo
         7BhAHBnZAYPkSBYZ/bfPKHUTrWNRhp6GT6RuqnMvQENpS5fyKE9s21F1a0nAwrV1QexF
         G0EsRRSmEtdZLmFuEXbjyqnHrHDY78GZ2JD8N42h206qRgyFI81XPo6J6drFtKeiXCZ3
         GHYA==
X-Forwarded-Encrypted: i=1; AHgh+RoEEW6W0yLUcJl7KtrB2+okZ4eP3rbrxcrL0MzbwzFU1st6qCXuOhVdWKCgUk8olowi3PqUAV05EDo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyll8us1aUmDfDpINZ/bjRDwUCa6K0OSRVMnpG2pDCQDQoVt98B
	gizceRKX+urAEDBP6vwgcXK7J2k608PD5SHeSfy+XmbDpLD2P/dg7ybb6n1w1E2cZXJYKLeekto
	IKbkryMZGpgsqT0MfrdqZdN7d9Lx93j4=
X-Gm-Gg: AR+sD13TAOAZLVh5qWg9HKxBwv0c+/Ac9H/jjNn/kNvP6g5mUuiwdx1mvv1sf21qCZd
	zU60dkLR2CSydo5vzt/Xf2WGxCjVsT1Nucd+wmaOPMfPNFy50MAdc2oZTAZGg++Gx2sqQhyW20H
	mUKhdzlmXw/nhXZ6AxevNCKV7SZZCu0xOgsoNB3X2LPSsBitJiHVNaHHe6wXKJlLFBOeYlyBfSc
	eeiRNqDqwK+yLlYZYK6ARk9O2geBRXr8zwnEJj4rwGp8Kp5p2z+0ciUFXSMfrmsnchYaQ7P9T9a
	82GiZISF6Mjq0vS0/+5gmg2GBKl9T7bwCgmpWr9f5bFfDcqvOPYkZeee6G4tHOdT6wVUP/YpL6S
	qZhHMS7X056LxiiXDhQ7cCm4i
X-Received: by 2002:a05:6000:288a:b0:47f:8e78:4d0c with SMTP id
 ffacd0b85a97d-47fc66738eamr85810f8f.48.1785351463693; Wed, 29 Jul 2026
 11:57:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
 <20260727211758.1116539-21-joannelkoong@gmail.com> <20260727223345.GI2901224@frogsfrogsfrogs>
In-Reply-To: <20260727223345.GI2901224@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 29 Jul 2026 11:57:32 -0700
X-Gm-Features: AUfX_mw2AKZ6T_CPZERPb2AZJh9r8QLmI1mksg1KCuOzXLA3WT8egaBLm2tNcG4
Message-ID: <CAJnrk1Z7Z3F3_Gee0Ej0n_0-2LPxJq=4rxmw=xg+e2ryoa6MNQ@mail.gmail.com>
Subject: Re: [PATCH v4 20/21] iomap: pass iomap_iter_next_fn directly instead
 of struct iomap_ops
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, hch@lst.de, linux-fsdevel@vger.kernel.org, 
	changfengnan@bytedance.com, kbusch@kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	tytso@mit.edu, Jaegeuk Kim <jaegeuk@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
	Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 27, 2026 at 3:33=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> > diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> > index cffcec532ea6..d2d3c84d93f9 100644
> > --- a/fs/xfs/xfs_iomap.h
> > +++ b/fs/xfs/xfs_iomap.h
> > @@ -53,14 +53,22 @@ int xfs_read_iomap_begin(struct inode *inode, loff_=
t offset,
> >               loff_t length, unsigned flags, struct iomap *iomap,
> >               struct iomap *srcmap);
> >
> > -extern const struct iomap_ops xfs_buffered_write_iomap_ops;
> > -extern const struct iomap_ops xfs_direct_write_iomap_ops;
> > -extern const struct iomap_ops xfs_zoned_direct_write_iomap_ops;
> > -extern const struct iomap_ops xfs_read_iomap_ops;
> > -extern const struct iomap_ops xfs_seek_iomap_ops;
> > -extern const struct iomap_ops xfs_xattr_iomap_ops;
> > -extern const struct iomap_ops xfs_dax_write_iomap_ops;
> > -extern const struct iomap_ops xfs_atomic_write_cow_iomap_ops;
> > +int xfs_buffered_write_iomap_next(const struct iomap_iter *iter,
> > +             struct iomap *iomap, struct iomap *srcmap);
>
> I wonder, would it make more sense to have a macro to define the forward
> declaration?  e.g.
>
> #define DECLARE_IOMAP_NEXT(name) \
>         int name(...)
>
> DECLARE_IOMAP_NEXT(xfs_buffered_write_iomap_next);
>
> Hm?
>
> Though feel free to say "declaration macros suck!" because they do.
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>

I think this makes sense given that the definitions are generated with
macros. I'll include this change in v5.

Thanks,
Joanne
