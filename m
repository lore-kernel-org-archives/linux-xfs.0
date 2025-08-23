Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303A81E5710;
	Sat, 23 Aug 2025 17:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755970468; cv=none; b=nf4WjpkmEHe4sdfdNGBt/ojywgjH84fuvjGOl5/zZgQ/jQmThUbQsJl+LiZ/sAha4svLsjM3C2oV0NeigJJB5s62ZrfwGx5//NwFil1ypXbWyrt4RmCJz4t0CkURHMRiAcpRi4GaSucOiAMwh0LBahXinDKAVSMstoOwpqtbQcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755970468; c=relaxed/simple;
	bh=tBH6auSAE4OXD74KbmL4jIt84sIrdk7oKfzCqhk3a0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QszjMiNtPdcA4xLFBGlYSbP6/GefluviU+HYfPRIyOKGzwHqjSjQmdTeW/q6IcXuKww3JgJleVryU246YjNur2f/o2+9YAcVRwRxsesRjJKnIpNZOHfaFCwNd5IGGxwOEw3+WMGz6LUtepxJxEUcweWbdP2G+n9m1hotalF38A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gOTdtPX0; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gOTdtPX0"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-61c030a96f7so766475eaf.1;
        Sat, 23 Aug 2025 10:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755970466; x=1756575266; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p79RiCkjXWLUASsdJ5DgtzttInFEX17Obcr/BXMTYnY=;
        b=gOTdtPX0ceM7HRj5AtJfREKzs5Q9ktqKyA/3J5Mq5LSGMpVcYTpNA5fl4pYCiQ5ZPq
         o+BK3iVCTSEvkjMmbI+/wRBDCT5JyJgeEQDMFCokZNo6sgPxfYxxcmzrmbYkSfDxSz1M
         h0fw+JgZo7bnpIP2k4h0JXLT362UMvMnH+1PcXRpVt7sdx4JoWw6YRDvrryMVshJMsbG
         1fLWWSLKshOdYWvc+gA5ux1jhmHucLQBaMPK5yLuHDRRrkAbGEm2oynAgCjmr3AZuuLE
         8A7WwpMSzEKvye4OQcuo/X+qFxCFfgAbxV9YaE2yhMTPtVO7r5lCnTB8ybIwuhAf1bL2
         ZoQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755970466; x=1756575266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p79RiCkjXWLUASsdJ5DgtzttInFEX17Obcr/BXMTYnY=;
        b=JrnBnKOwnqWNoggMKs0egwKAkmYhoYesgBp7eJPg/+BK5N0Qdpte7gPGg0waxhQsAd
         f/TYbR7scEtZ9aeISGLi3lpCx8mSYmzmWYPRvOzarGMFSmesJyC9mR/sbK7lXCn/SmEZ
         u5VYvkNdJfD196x1MPk4g3t3t6NwvAVJtG4Pb8xsoYd6SCfbPatYsLFrOlT3sSPLSw/v
         GsYp1J7+Txmq8hZpFRdU4859mVyzHYt1SW0JErZpc+U2DLUQUdl52KX89U62mPg/hZp7
         Mhqiq/VZch+0cxDKDYoVmgnIZlJYX8+UOxRkck+AahiE5JrBARMOTD/Q08F/jJ0jghPr
         A3dw==
X-Forwarded-Encrypted: i=1; AJvYcCVRPUeUax7LJOjaIWqprcz+d/KA1tcYmsxX0178GnGtDYCdt7MZCL4oehIevzHF5c+Zl28PXSTMOHU4aJs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzT2Ra2g7vqtx29sP7zBKnuZr1as6UMOIIBY+t7iyjpYWNj7dm/
	YM4B03CZhbIt9mAEBTgZ4ov1gga24Ss3rDD6uygOeEWi1zDFV6th0RdeiCZgdoWSp8oZcnclWI2
	rBCUQ+CP24gC1pAHpBn0SXnvB2gQs3wbz/P+/8oc=
X-Gm-Gg: ASbGncsPsKn853fvLVoDREJ9GotXknNkbtevW4iEH+PATQ8n+slgXdyw0D7YWNMEeBH
	oRIUM8vWkEvROAIULlEl+KRiHITT2pm6FiESk12K17pyuGwtreRYpJXSGlIdV+7aTOvpqtLQzW/
	w5KwGE+/YNPBut2MOcMv5rRQLjYScoVVePQxmwg7E2ZzihItJybcILP8OJVsDQZWIMPqtu7sv3J
	Bd0AQbgLYiAKbbwVnI=
X-Google-Smtp-Source: AGHT+IHxiBRiuMpJ7EqZBfQD9DGyW5DeRno3nnCyer5o8dqLsztFHLgzy9OFP6aS9O4+O9Cni7wDhcQwllFqXWMoqwc=
X-Received: by 2002:a05:6808:8516:b0:435:7380:5b7c with SMTP id
 5614622812f47-437853412bbmr2713428b6e.35.1755970466106; Sat, 23 Aug 2025
 10:34:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <DgC9ldLgYmvzXaAZpH-XsBCKhwKSRirv1SdyNKAyWkv0buVk8ZXruCVWp7pYeSa6Ogg-jj6hxYTLAxC0m0FYeg==@protonmail.internalid>
 <20250817155053.15856-1-marcelomoreira1905@gmail.com> <hi2bosmnbbqbsrxydjqh4w7ovzggfdvpafubqbzdovuwzwqlfh@z2wbwjaqizzk>
In-Reply-To: <hi2bosmnbbqbsrxydjqh4w7ovzggfdvpafubqbzdovuwzwqlfh@z2wbwjaqizzk>
From: Marcelo Moreira <marcelomoreira1905@gmail.com>
Date: Sat, 23 Aug 2025 14:34:14 -0300
X-Gm-Features: Ac12FXwL9MRv4pRL09Pu0iTzs3q4OMT6afVV2IdGC2Zw0TVyKwdTvxyopZ14-jw
Message-ID: <CAPZ3m_iNj2zwpAovv3BTz8gNp5XzdxSRHBFonM9sJvaSjYVBeg@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: Replace strncpy with memcpy
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em qui., 21 de ago. de 2025 =C3=A0s 06:39, Carlos Maiolino <cem@kernel.org>=
 escreveu:
>
> Hi.

 Hi :)

> On Sun, Aug 17, 2025 at 12:50:41PM -0300, Marcelo Moreira wrote:
> > Following a suggestion from Dave and everyone who contributed to v1, th=
is
> > changes modernizes the code by aligning it with current kernel best pra=
ctices.
> > It improves code clarity and consistency, as strncpy is deprecated as e=
xplained
> > in Documentation/process/deprecated.rst. Furthermore, this change was t=
ested
> > by xfstests
>
> > and as it was not an easy task I decided to document on my blog
> > the step by step of how I did it https://meritissimo1.com/blog/2-xfs-te=
sts :).
>
> The above line does not belong to the commit description. I'm glad
> you've tested everything as we suggested and got to the point to run
> xfstests which indeed is not a single-click button. But the patch
> description is not a place to document it.
>
> >
> > This change does not alter the functionality or introduce any behaviora=
l
> > changes.
>
> ^ This should be in the description...
>
> >
> > Changes include:
> >  - Replace strncpy with memcpy.
>
> ^ This is unnecessary. It's a plain copy/paste from the subject, no need
> to write yet again.
>
> >
> > ---
>
> ^ Keep a single --- in the patch... This is used as metadata, everything
>   below the first --- is ignored by git.
>
> > Changelog:
> >
> > Changes since v1:
> > - Replace strncpy with memcpy instead of strscpy.
> > - The change was tested using xfstests.
> >
> > Link to v1: https://lore.kernel.org/linux-kernel-mentees/CAPZ3m_jXwp1Ff=
svtR2s3nwATT3fER=3DMc6qj+GzKuUhY5tjQFNQ@mail.gmail.com/T/#t
> >
>
> ^ All those Changelog metadata should be below the ---, so they don't
> get into the commit message, but...
>
> > Suggested-by: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Marcelo Moreira <marcelomoreira1905@gmail.com>
>
> ^ Those should be before the '---' otherwise, as I mentioned, git will
> ignore those.
>
> > ---
> >  fs/xfs/scrub/symlink_repair.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repai=
r.c
> > index 953ce7be78dc..5902398185a8 100644
> > --- a/fs/xfs/scrub/symlink_repair.c
> > +++ b/fs/xfs/scrub/symlink_repair.c
> > @@ -185,7 +185,7 @@ xrep_symlink_salvage_inline(
> >               return 0;
> >
> >       nr =3D min(XFS_SYMLINK_MAXLEN, xfs_inode_data_fork_size(ip));
> > -     strncpy(target_buf, ifp->if_data, nr);
> > +     memcpy(target_buf, ifp->if_data, nr);
> >       return nr;
>
> The change looks fine. Once you fix the above points:

Ok, all points are clear to me, I'll send v3 soon. Thanks Carlos!

> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
:D

--=20
Cheers,
Marcelo Moreira
