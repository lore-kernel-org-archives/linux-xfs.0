Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F6F377006
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 23:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783033328; cv=pass; b=Gnw2QifdgHFc9JcMzt9mdyc9z3/VddtfKZfCz9J6kBt6NNyTVHEB7Ii8UgPWj9AJFiNe37AbVUGsJnIKrRhMMXawHD5Dkb6qJOhFRhjaHJsWe4uqQb67qQAsIKhVhvn3obUKvrDeJyl35+Iw2hS8tnjQQaHk6LiD+FI9MoAi608=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783033328; c=relaxed/simple;
	bh=4Kn3VQND47UCcI26pv7bb40u477SLSvq4NVjLC7sHeg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C4JTQfMAYGiipkbCpkP6X2jEkHadAYGXf7LedhKiYVHWo+JDQeq/Zt6vKvq7ybl0VcktShmgFq5DTETjohHCDfMOQoMZEmajzgXWDTodopJ2Rxkw+uGgEg4GD6gkBDJuwPRcSsJAjNrmt2OanYpW1CYHavByzOF9YOiS1Xlxt/c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fJaEPJ3l; arc=pass smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fJaEPJ3l"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4629051c946so767609f8f.1
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2026 16:02:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783033325; cv=none;
        d=google.com; s=arc-20260327;
        b=K38gXQEtbTxvw/s7GtHR+YqeuaCcjzf8c1mj03iArqIyn9Q/K8ZRIDR3qXcZeeDI9V
         IVYfiZlDCzbBLMwu5pnAzHTwiot+Tba4XW/43fnyzFVYP7QSWhZTXkY89xDhVhCS69md
         ADekUni1YDibXZnJQ4+PVoeJUE2cpQqsrxL/+wc8ds9Xf2pP0ZccUEyZAmFp5q0pv849
         vnVn8EnIsRybRH9cdBL4TRcU0w65a84q90DHMrDY60yO2Quu91KaEuoBES00HnXHw9Tm
         Ae5PzjLpj7/Kgr5p70jI/ug3xL5mWD02hIeRSMGSPYX3RTSjqCqZRciHZMK9K3FJ52Bl
         2BBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4DB0StncCI4DCdkHVBFZN5AAMbnpw9y/OLi7Kcm8C6U=;
        fh=xzfpBNFoV4DQFgDxU1q8T3tOwDFI/5z2/XxCinlFW3c=;
        b=C5jYdQB9/UvDe4461omJZiU3ESrTR4NSPsnEjjQQAVnWqR4XIHa+Dulu1S+yXP1jhr
         +NOSiZD9P5uvsGq5yw8nc0py4r3bAevAEdVNkd031ZcYFuFfPlb6dcjjsPqcnBCU72nJ
         4CVFWxJCPCUpCaK16Z0RtDK/8InD02fhOViOn7BGV9/ZeYdVcU8Oyd3Ybr4jin6tanUo
         OUrdhlvxHPibPaUK12bKRD31QJ1BFA/jK/xGFO4gWgKWMUpJOtZY+y53y6j6Wg4vICz9
         WzQ1W+NNLj0P/mEmLlB/FjWp/NAS4pAvw1+KL7iBhqEuTU35hQXN8REdO5UcmDRj9mIM
         Snzg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783033325; x=1783638125; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4DB0StncCI4DCdkHVBFZN5AAMbnpw9y/OLi7Kcm8C6U=;
        b=fJaEPJ3ld+n66r1G5fSulWfucGH7LbdhRHl+lw4OzgmeFjsyUZpSjGk0ARFBeMStHJ
         5iBdiO1V9XFNcgioODdbtjBieLBMehoW9n2JdGkpAk9S6+6qTfdfCGEjKPr5XM7VioOu
         CBxZtd6lthU/F0kBOtEAW9th911Tkx2DnrhSZwqa0UuanXVZfgk3C411Tf/gUNvMBVrc
         rzOZRzxgrcApMw2SeK/YK43VaOAKVhQXCNJ9OOdwZV18IvOM43VGIMl1Gejr54Wa9orj
         Xus2O8eFj4mYhw8D33DFyRSomOK1AbOjSkpIJkHilF6ovudCY3f3PryZAjQy+wTpaa5i
         CuZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783033325; x=1783638125;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4DB0StncCI4DCdkHVBFZN5AAMbnpw9y/OLi7Kcm8C6U=;
        b=gHugvsr3AZGpUkrWW0UdbpbKK0RphxL56yHYZBngOSF9E1WPMg2s48nHfhkzaZ8v6J
         qb0hj9BH7LODbBn25FppZobAbNQXdPyCawJzwmkIN2w/E9vEK/aB1i0IIWPnsHRsEiux
         6GL8o5Jj1vSu8/7YNE+gX9/BKHcOBfq6xBhm8QV7iVJtoaJUITAADHkt/9rY3rH6ZgTN
         Llw4GvazZKYernzH07MCW1Ms011uHP05f8tkLoJvMTyH2uK2dcShawzQn874W+hoCccd
         kIZCvvaNQEuogELu0gcixToIvBJiIQADuNJ9pblABHLIfoS0nsdvuZyjC+gE1prpyPf8
         6vww==
X-Forwarded-Encrypted: i=1; AHgh+RqBTt73Wxw2x57oqoA0EMs2hiNEsckV0XMt5CxVvcn7z6c9UTCPfYVDcL/f7IjxrQefDdAm0FwcGRY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUAp2VAMTpGxFI6mhZRCPmaWY84N+8LugUO9n9cPb1l2nLSenr
	A0JuzenkZYG5HOgM8j7x7Ez7Y0KnmGgmvco9pYAl+pvsq8ITu6fu03PW+K8ZZNJhA1KsKOL8tG+
	kmUSK35THl+V4dVKsLeTYHGvzbi/TKDE=
X-Gm-Gg: AfdE7clD6a9umIxNnOcWDg20FEOjcFyMm+1MIpHSrLIZZcuN31d5hFkgfhOJZjCPTsb
	DFsa7aVrVw7bSXnoB06ybYyjCZjIRaop6ROfXhmMknCkYSuhowql5Xi/S++m9lh/QUp4Bs9xXJO
	Dmf+gxxucf3XIJxZscpNnix7iB/yILhSQWOGxPDKgmXYENdaM21fRrYapMjTkeib/zRQtWrwGt+
	ehTYgJGHCdMeaqR+qNWSC+FvxH2QT8m5k7dxGDCJnSoLFtyjpR3mLAihqeDq2pUz2QB1GcYR4tn
	Ko2CZHDOFSy2UJH520mHRaH1YuT49m+5r7fN2af/MuJMQ0NAVoGw
X-Received: by 2002:a5d:5ccc:0:b0:475:f0c2:75b3 with SMTP id
 ffacd0b85a97d-47936d2f33emr1915668f8f.30.1783033324743; Thu, 02 Jul 2026
 16:02:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-2-joannelkoong@gmail.com> <20260702140009.GA21339@lst.de>
In-Reply-To: <20260702140009.GA21339@lst.de>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 2 Jul 2026 16:01:51 -0700
X-Gm-Features: AVVi8CeaIMzXU9RzKe_zbiO3Q8oQSJv6T5IEdOvWb1S4DuwOGjn86_r2tKsstdQ
Message-ID: <CAJnrk1ae4QJgg8pPBVaxQdBkHLTeVtdmPdzLyMJeRkt8xx9OeQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/18] iomap: add ->iomap_next() and iomap_process() helper
To: Christoph Hellwig <hch@lst.de>
Cc: brauner@kernel.org, djwong@kernel.org, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 7:00=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrote=
:
>
> On Tue, Jun 30, 2026 at 05:09:16PM -0700, Joanne Koong wrote:
> > +static int iomap_iter_legacy(struct iomap_iter *iter, const struct iom=
ap_ops *ops)
>
> Overly long line here.  Not that it really matters too much given
> that this goes away by the end of the series.

I'll fix this.

>
> > + * Iterate over filesystem-provided space mappings for the provided fi=
le range.
> > + *
> > + * This function handles cleanup of resources acquired for iteration w=
hen the
> > + * filesystem indicates there are no more space mappings, which means =
that this
> > + * function must be called in a loop that continues as long it returns=
 a
> > + * positive value.  If 0 or a negative value is returned, the caller m=
ust not
> > + * return to the loop body.  Within a loop body, there are two ways to=
 break out
> > + * of the loop body:  leave @iter.status unchanged, or set it to a neg=
ative
> > + * errno.
> > + */
> > +int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
> > +{
> > +     if (ops->iomap_next)
> > +             return iomap_iter_next(iter, ops);
> > +
> > +     return iomap_iter_legacy(iter, ops);
>
> Maybe inline the code currently in iomap_iter_next here from the
> start, as that what we're getting to by the end of the series anyway.
> And just do a:
>
>         if (!ops->iomap_next))
>                 return iomap_iter_legacy(iter, ops);
>
> at the beginning?

Sounds good, I'll make this change.

>
> > +int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *i=
omap,
> >
>
> It seems like this is largely just factored out form the old iomap_iter()=
.
> Can you do a prep patch before this one which factors this out?
> Preferably in a way that keeps the code in roughly the same place to
> minimize the git blame disturbance?

Sounds good, I'll extract this shared logic out into a preparatory patch.

Thanks,
Joanne
