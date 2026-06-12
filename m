Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD312286419
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 11:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262451; cv=pass; b=EJc9C/OqBS2zcqNdRSpvJoRl0mNRnBbJKRPctXdyOQFzdUib/2PhcRU1W2L1sPULK3WixIgvQMkHMoXPJgpdmPrWCm+XP7c1MYf3CCwzesdbUPnVrzGR+51H2OAy0Y7KyZ8HmjJFEDU9MepK2UudYPl/CRQC3/d6+7t9NjE2GSo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262451; c=relaxed/simple;
	bh=yEfJW+RN/W3gZtmAmbkYw98tUflR0OQi1+m8RV5zmrI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t/s7oIJm/VcPTJODifYJa7qyMnRZlkmfsNAoNPs10JCoCHzdX0LQkRcn8sLO9Y4eFBlbDcx3kVtKSmPNRvN9dRP/0r9RMxQPSdx9TP5A7j9lROTtFGWo96DDJCvwEu7o589w5V9nXS6CH6w1GBx3c1OmjdcTYCcM9dJF7qxfyA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lfXnChEX; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lfXnChEX"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-befee9e5ef7so101252466b.0
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 04:07:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781262448; cv=none;
        d=google.com; s=arc-20240605;
        b=VcL+KtLGSLARyyt24Njxs2+UP6bIVXD9RFQCrvygXgQzVJq+48M3C+rAtpxuOtJXNp
         S/K8ovBExPT5KrS4RwZBTzJGYiJckh8/qqflFmC/SyEF8pI4QC/C4J+j5xkMErOZLNJn
         6WZliZaZztsfcZOSkQf3mS1iQgrUA5XxFWnCLQxxA2QEYNy7RwgjPJCXr7tPgpZ41ouv
         Bc2im5cUYoWxZbCrQKn9g9KUx81OdUDxUltYHkccTNLxIa7tf8w4t6FgDm8m5wc8Q6eQ
         I+CAK5+AbR2chW4vOh9bKyuiAdP3KNiu9h3tBfugb0yToSQHni0Mczu2Yaq/TGBjhwx7
         elfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=N0tkKAHNsCUjanzy/2m0xBZMJU4SVIEAMvv/Gxp0iCQ=;
        fh=EE/+OloKuXsUyfHy7pVKrrG5p3J739fKsG3WW+D7WwA=;
        b=fPAkoiqk9tBQkmpfgU4opD1PJEwVSyEV4gPW1MoeQ0/31mIxn0ktmP81SgDcJM6Uf+
         gHYwJeQdfF7RnqRxjDDErwDnM5HLZ09u/Q5YT3OvbVvhqaSM16RxAuON35+rZBVcNVUT
         x6GdY8EVtgeCpBvfVzTmAriLiHmRjkFQuJvYup178O3sKqU6OIWqXK1yssQ/k02OcXfK
         AE9cqPCvnwq7FQB3qY/OlrHMTJobtrk6hLF/d8b12DjMGmZpzVRhSwPWQMY0IKCcC57E
         M3Y35V15J0rsqCxbhfxgyKn8VbEnBP6E8qAOSpFNUIWKy7R0nQo0wEtLZ6aXDtLb30Ee
         fI/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781262448; x=1781867248; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N0tkKAHNsCUjanzy/2m0xBZMJU4SVIEAMvv/Gxp0iCQ=;
        b=lfXnChEXcoGBxuZce9K4lSU6OdvzodyUyS8EfIbbhhFxabbVjmb+NYc04WparawKAD
         dYeris2GUkRJBJHgc1qVU1lw1fQyEScZaNtlR7L6V/2++mQRFm6fXOI91F5xYWBb+RqF
         prw5K6/+ArskikQUC3fuK9n+pmkkZm2e0M+oT0sD2WYAutUCjSfhb8SJNT9hscsfd6Ai
         L1lmhCOw0+1F6w1/yiQ0PZLuC5yZYakMVFd/zlzxZjV0ikmKfRFJHwYOgy0K2ob2cTnU
         CZd+GGcv8HYB1/7ep1KoyFfyftCxOe4X0yfAx7KIz5Jy0251d/teE86xUBG2aM7R+FSj
         ffYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781262448; x=1781867248;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N0tkKAHNsCUjanzy/2m0xBZMJU4SVIEAMvv/Gxp0iCQ=;
        b=gCGs+K6OKoEcujFh1xHCaPMh4zC4WrWxsZi1xQQMdf01e30pIMv9/RPR09L3Vq5ZDn
         GjzBxLpR0VQ5HY7N3HTFr7lgVR1RspEwHxA37k1KDyCCeqvVJau5c9YXNKFrj5nzpP90
         6Ofg+TgAj+ajMkJXujWO7WsKhYAxWe5OxGbuYYBjA4zS2DjsbSwNXLgq2jPECJfbcdXC
         gaBt7H9prGyIK0Hy6PsrKC+nWJBTLydOVr9CGy/8SKbTwnLF0SwmRNyMVeHKgv4oHuwX
         +L5+MeJM39TLxkwJGQEL3zMnoP/wr+coK3mxa61FNFgLysq205C41PJxe1YFERvaQxgE
         tk2w==
X-Forwarded-Encrypted: i=1; AFNElJ9hrw8I6Jyoo+O0Bc8OKBfqhdLXq6AWSxujrOi0yvKD3lhgJBBSuAZkzakw3p4MAyy89ntV3oApA9g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWX3S60uMIe1a3XeJuqzYFvS+XR++ZaT866M37Hf9zPRZelLmo
	1xItEAaoUncf9mi0Flp8SntUiM0gk/4P558bSEeORSEMjGqLhoBnPplBcdrhaTw63pCD0OPBhzJ
	/XAABlalLgxNaVdbnfhXeof9wxhDRLdQ=
X-Gm-Gg: Acq92OGSv4sZtmgALVfewf9+C+UktgtDVxfOs81PU8Uo7M17u9fGJHqCXHyJ3lYKCaf
	OVhzSuYqCF/xrXoURqGUxRGqbNkc+Hz1kwAhnptL8RAjXbEMAm2t/w/Ve7RnUc7nqUYijAaNHOo
	d4eivEPw3HSMWewHoCondkXotH/aVRqj24dItxEgejoyuKGdthJl//XSTNQCirBnlEzq5MYZNQ1
	7OWYWG0MO7Xusfhqa8N8wsWkZVtSGH40tDcBCWP7apI7CXuRwIBRGHiQ0PevBqiKCtwP7xsRtjV
	1t+qdHrRpcBoQBveMqw2JCNbRU4SWGIUC+UrAIqAAvdbEeEHXw==
X-Received: by 2002:a17:907:75ce:b0:bef:d412:cecb with SMTP id
 a640c23a62f3a-bfe28a2eba7mr76154466b.20.1781262447844; Fri, 12 Jun 2026
 04:07:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ailmd8JNOT62E6vD@infradead.org> <20260611180532.1725-1-aditya.ansh182@gmail.com>
 <aiueFE1yWmLJGIFA@infradead.org>
In-Reply-To: <aiueFE1yWmLJGIFA@infradead.org>
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Date: Fri, 12 Jun 2026 16:37:15 +0530
X-Gm-Features: AVVi8CcZe4yJsTosZF0jrJMIFAzJQfrw7WfmiQ4jwZYYBt8zoU-2ik0E9RgEekA
Message-ID: <CAK5ssPMdACpa-RRqsjLEngjizcyUxcgH+tTKtG76x7e75cUaLg@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: prevent close() from hanging on frozen filesystems
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

Thank you for the detailed review and feedback.

The procedural guidance is helpful. I'll split the changes into
separate patches, move the reproducer and additional background into
the cover letter, and resend as a standalone patch series.

I'll incorporate the comments on the EOFBLOCKS_RELEASED handling,
transaction flag naming, comment formatting, and the transaction
allocation path in the next revision.

Regarding xfstests, I plan to convert it into an xfstests regression
test in the near future so this scenario can be validated automatically
going forward.

Thanks again for taking the time to review this.

Regards,
Aditya Prakash Srivastava

On Fri, Jun 12, 2026 at 11:20=E2=80=AFAM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> Hi Aditya,
>
> this looks mosltly good.  A few procedural comments first, I'll then
> move on to the code nitpicks.
>
>  - please don't respond to the previous patch, always post standalone.
>    git=E2=82=8Bsend-email gets this right.
>  - a lot of the history in this commit log belongs into a cover letter,
>    not the commit log itself.  Same for the reproducer.
>  - please split this up into multiple patches dong one thing a a time,
>    e.g.
>
> xfs: add a XFS_TRANS_TRYLOCK flag
> xfs: prevent close() from hanging on frozen filesystems
>
> > A simple GPLv2-licensed C reproducer demonstrating the hang (compile
> > with -pthread):
>
> Can you also wire this up to xfstests?
>
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 0ab00615f1ad..56c7919bf1e5 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -574,7 +574,8 @@ xfs_can_free_eofblocks(
> >   */
> >  int
> >  xfs_free_eofblocks(
> > -     struct xfs_inode        *ip)
> > +     struct xfs_inode        *ip,
> > +     uint                    flags)
>
> Maybe name this trans_flags so that the usage sticks out?
>
> > @@ -1807,8 +1807,17 @@ xfs_file_release(
> >       if (!xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
> >           xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> >               if (xfs_can_free_eofblocks(ip) &&
> > -                 !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
> > -                     xfs_free_eofblocks(ip);
> > +                 !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))=
 {
> > +                     int error =3D xfs_free_eofblocks(ip, XFS_TRANS_TR=
YLOCK);
> > +
> > +                     /*
> > +                      * If transaction allocation fails due to a froze=
n/freezing
> > +                      * filesystem, clear the released flag so that su=
bsequent
> > +                      * releases or background blockgc can retry post-=
thaw.
> > +                      */
> > +                     if (error =3D=3D -EAGAIN)
> > +                             xfs_iflags_clear(ip, XFS_EOFBLOCKS_RELEAS=
ED);
>
> The comment has two overly long lines.
>
> Also the resetting the flag on error is a bit odd.  As far as I can tell
> there is no need to clear it before the action, so I think we can just
> move to clearing it only on successful return, e.g.:
>
>         if (!xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
>             xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
>                 if (!xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
>                     xfs_can_free_eofblocks(ip) &&
>                     !xfs_free_eofblocks(ip, XFS_TRANS_TRYLOCK))
>                         xfs_iflags_set(ip, XFS_EOFBLOCKS_RELEASED);
>
>
> > +     if (!(flags & XFS_TRANS_NO_WRITECOUNT)) {
> > +             /*
> > +              * If TRYLOCK is specified, attempt a non-blocking lock t=
o
> > +              * avoid blocking indefinitely on frozen/freezing filesys=
tems.
> > +              */
>
> This would be a bit cleaner as:
>
>         if (flags & XFS_TRANS_TRYLOCK) {
>                 if (!sb_start_intwrite_trylock(mp->m_super)) {
>                         kmem_cache_free(xfs_trans_cache, tp);
>                         return ERR_PTR(-EAGAIN);
>                 }
>         } else if (!(flags & XFS_TRANS_NO_WRITECOUNT)) {
>                 sb_start_intwrite(mp->m_super);
>         }
>
> And maybe the flag name would better match XFS_TRANS_NO_WRITECOUNT
> a bit, e.g. XFS_TRANS_WRITECOUNT_TRYLOCK?
>
> Maybe also add an assert that XFS_TRANS_NO_WRITECOUNT and
> XFS_TRANS_NO_WRITECOUNT are not specified at the same time.
>
