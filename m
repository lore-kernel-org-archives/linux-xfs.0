Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA3A306D2A
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 21:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782165112; cv=pass; b=ghYcg0IPHor73jgXfiEL80+Vb5DCUPVHe+XD5kgomXPxf/cRjzk1O5JUGA6IQbZeniycxcXwlGNX+DI1ldr+IsiII06qCya71mjrkeg83Tg/vWTNmgD4cKz2XkzJdQhXaq+htHyl31OqEoFjRbc1JQRcDXFhBUBCB/eZM9bAq+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782165112; c=relaxed/simple;
	bh=FpmQubblAsQpoxOUF1z2VQCYrco/qUz7f/N3cTh1srM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ogwma267f3TEbKoyOOYZR8r3jUdmmLg8MSfR8NWW+0IhYZyTPUdARJ3l42LMos11iisPuZ7w9HJM9fYFQEisOR3gBXU7aE6v8/l0dfmXkevpitQHHweZkrnf/lVpNXejC73GIGPmNAOIvVoO+3Ynds9kXQ1qrQ2P4pL+1OPYAWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cv82m+W2; arc=pass smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cv82m+W2"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490b613a17bso40716785e9.3
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 14:51:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782165109; cv=none;
        d=google.com; s=arc-20240605;
        b=BUf7GaTSZAyJq74gGwTXrMF0azp8UwB54kcONzpigxnzM46lMMzgu91XleNfqvh1qr
         VEZo6wWm3K2tw/HdvSQf4WvOegksp47/HQzkL8h5sfY0V3MBazDvTDROJZ24WDtNQLGC
         cjLNW9M0XGLL4ARDsi8cmosh4ENooNKjkloL/VzpJwVp09InDsKwhuR/wNYFdF85/gLz
         AHjcibvZQeDGR0PoMSZiQMg1UIYgQhKv9fVhiUVxYhDciIsGujLqCN+cbzRqCW29iNOi
         mfMIM40dkxejrJ4HlBAARLpI9zUPhNvP5Um5ffecRBcyXQ+XZn4K+R6VNwdJjVN+gmXD
         +7qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xjEUxqC8qO1qlPJz0zZDAHSSpl23PeHKm/vTJBwS5AQ=;
        fh=Y0BMDLV4dE96EO9DtBH73BTkRFDl/G1iRzIkJ3fcVig=;
        b=E1cz4WEa/SmZPWhKvgRVfykKTsIPyRvb7y8dbyU1wyYn/H7t4FzEuJF0ssVri0azzQ
         o2nyzIXjeSIvxuq0Ce3qGHmRMmjhaV4Si/4zt8GWMz2KztcNU+5SSD2s03ya0CKM5JWl
         svlxbaSsjIkVPrdxgkqJYBBR4ji0V28ooGO9ckQ6sl99Rc1Lg6d/CEUmSnFJYYmFKLft
         2HDmQZP8t8p4R9n9TQDYaE/3y5anB9OHfUhXoczP0Qm/c0geTTu6jtsWBfUH2eh/G7M1
         jOzj1HOla/xvXfitk0v5CoiZQmq9M484SjIHyWJwYKEVPQwEA1ai1RpelDjtbKGJR0l3
         VHqg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782165109; x=1782769909; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xjEUxqC8qO1qlPJz0zZDAHSSpl23PeHKm/vTJBwS5AQ=;
        b=cv82m+W2uCvu1e8WbUbpgxrwU8cMGO4yzCec491jN77039Apc2iRdB7yyUB7aSXehr
         RHrWVqrrW9M5TLTdeUeB1ysLnPsfFtL5j8iBoBgCEQywG/Enovv24ExVNHJSsuW/7VFt
         wgzsYbtDR0S0Fy+u27THSEOnVUWhOCb1KD9cPOAlhguoGMrtacS0lpxjxbTmpjDrSipr
         wq3CdSwCopnIGZiZE5rNhnjr4E9GyPxjWSa4MGwvt7GVCGd250g1KOGhcm8GP78fRg62
         qPwRxfKTynujuU9kVZzzCQOSZX/TOuoRKvwJiAxf/jwR9JiewU3iiV+HdNT6JDq3jb+Z
         tD2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782165109; x=1782769909;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xjEUxqC8qO1qlPJz0zZDAHSSpl23PeHKm/vTJBwS5AQ=;
        b=jLaC5VJY/OtaoLV0vX1mexhdF+lCCf5D9R8OGlN9yITrvptCFGmzQECtXkwNuL5vQM
         hzS736aYhu0rUa0Mqc5k5OutDxxIoA9GIQ7VxFrjrYBmQiLzhmNdv/qWpl+Zwsa5XDXE
         VoR0UE66u15BytkVmzpmILU+Dl+YFEI34VHGacCPmJnaSxvHStDDnln/Gdk2HbrdB5CA
         aeycJeiyzRzgsw7ZVwQJ7eKkurTSEQTcVoCRDw9PmSntwiSG1BijpbQ3CEDmk3fCeMtt
         n6qlo+YF/8m6TeAJJjhi9qdfQm/0SRt8tPGQ+0hnko7MztmQhWDG+5vqUk9l+uTCmjZW
         Gsdw==
X-Forwarded-Encrypted: i=1; AFNElJ+/dHBtnRwG35PuXPFrlfAu7+CgKZK56jG4MY2BrZeSSwJt2lb1bO++PGcnsVmBJGetXvWaXUI5aS4=@vger.kernel.org
X-Gm-Message-State: AOJu0YySopmcOa1YCN0SkR2lzjFb317rxw6roBS4+t9bxigLw6yOdoLt
	Timb3H7zr2d2nbi41XyNr6urFVus8mUuDYbaSfnzvq2uWZHwTfJ49pnadnjNh9A9+vs23U7d/jO
	jUjvk9vVWvtrgJaNjiYZ7ecKVUFnGAcI=
X-Gm-Gg: AfdE7cmO1+9lUrIQxSUmkSMo3ajaReiLEOXiK4vzthASLuejYe4ToFM4ysSFHSxFW16
	LJALgTPeYnJ8NGiE/oz50qxZTtcZ7j42edT6qm7a7QwMjvoSiCsurDJLhIi7zzxlgMbY+AcDZJv
	F+tP6AOJvVPidukfHHHUraK4I7QRNBlGsvMi3xV/J1A7KscL0IjzuZEHqzyGMvxj8tBOY+Od0Q4
	BS5o9SBVbyqnd6Q4S7CqfMXMmelzO5hl6D/vC4O7YhrKzaK3hcgTV+CFI419DsmUJ5fNaxitcZ/
	WND7sviUd0YvhIzi6AXq8JJyCWAbHHDcEk+05OAvhUAhwF7A5j4T
X-Received: by 2002:a05:600c:3f14:b0:490:b446:fb8 with SMTP id
 5b1f17b1804b1-4924908ac6cmr166056525e9.11.1782165109012; Mon, 22 Jun 2026
 14:51:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260619050105.439956-1-hch@lst.de> <20260619050105.439956-2-hch@lst.de>
In-Reply-To: <20260619050105.439956-2-hch@lst.de>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 22 Jun 2026 14:51:36 -0700
X-Gm-Features: AVVi8CevIgfNYxQYNyFNPu8nm9hh_BhFChXmfrfRf0pPdEn4KUuqrVDih803y8Q
Message-ID: <CAJnrk1ad7Wxr9CB4P1=VZPUS_BRmHTTmRVXVgRjM628iFCZh0w@mail.gmail.com>
Subject: Re: [PATCH] iomap: submit read bio after each extent
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Kelu Ye <yekelu1@huawei.com>, 
	Yifan Zhao <zhaoyifan28@huawei.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 18, 2026 at 10:01=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> Currently the iomap buffered read path tries to build up read context
> (i.e. bios for the typical block based case) over multiple iomaps as
> long as the sector matches.  This does not take into account files
> that can map to multiple different devices.  While this could be fixed
> by a bdev check in iomap_bio_read_folio_range, the building up of I/O
> over iomaps actually was a problem for the not yet merged ext2 iomap
> port, as that does want to send out I/O at the end of an indirect
> block mapped range.
>
> So instead of adding more checks move over to a model where a bio
> only spans a single iomap.  File systems can still create iomap
> that span more than an extent if they want to build larger I/O.
>
> Reported-by: Kelu Ye <yekelu1@huawei.com>
> Reported-by: Yifan Zhao <zhaoyifan28@huawei.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap/buffered-io.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
>
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 8d4806dc46d4..7449cfd995d5 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -524,6 +524,14 @@ static void iomap_read_end(struct folio *folio, size=
_t bytes_submitted)
>         }
>  }
>
> +static void iomap_read_submit(struct iomap_iter *iter,
> +               struct iomap_read_folio_ctx *ctx)
> +{
> +       if (ctx->read_ctx && ctx->ops->submit_read)
> +               ctx->ops->submit_read(iter, ctx);
> +       ctx->read_ctx =3D NULL;

Does it make sense to move this line to the bio submit_read callback
instead of unconditionally clearing it here? If we clear it here, I
think this makes read_ctx only able to hold per-mapping state instead
of also being able to hold persistent state across mappings. fuse
currently uses read_ctx to hold per-request state (though this patch
wouldn't break anything since fuse only ever returns one mapping
covering the whole request).

Thanks,
Joanne
