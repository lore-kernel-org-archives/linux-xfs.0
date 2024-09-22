Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B0F632;
	Sun, 22 Sep 2024 16:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727023884; cv=none; b=FfdlOtj4A5hMnKEr+hAvZ7T97s1HtPw56a2bSYhCNTaWmYYJSBQ+eFevhaKw7a2CwGj6Em6FNAQfHT2YOjanbUTJr6qb4nl1QC6Ys5YiJ1uKj1e6og06fAWV5WehNk0f7TvWYeJCL5gdVkZ5mDFNXgYG7sx1HsuZpn08NwfkdtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727023884; c=relaxed/simple;
	bh=bnXL/CBG6WeT0vqoQrrnx+ndunnjF44ffiYICMaEYoU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t0xxp1LsaecL1ZCnlGom3U89UAmi8przOQE1qH0e2+PrJV39m84ke4yoC01/9QhrtX99PoSNVn2jGV4VFHAx4tMUzMlZRiMt/LFGEWkyaDQ7rzSuzdDM+7Pt6f/CI7PiEsWxHpxcragKqdepXjwiy1lXKULoDuYmrjPnJE86FB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E6X/LSMi; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E6X/LSMi"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2f7657f9f62so39422021fa.3;
        Sun, 22 Sep 2024 09:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727023881; x=1727628681; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g1oL5S/B37tEUQ5pYbFLSlwc7f6+AmoEVqGKun0bI4g=;
        b=E6X/LSMi72nxCjHfIVeNE0jHiRczFIFYMQWNPKerwYYk7N1MiPX0erWTL5q+j4MUYW
         VcMRk9t30duAqxAGqQzOxGQ2C/WMiwVFkNk/b2Zydran7NNvCQ6q24i9H+CVCvtWk28I
         OA97oJStIZLPc0omB5DtTntYknXLyGI67L1+iT6q6gB0gBcmJ8hjFLJf+R48AVU+AoLi
         Feo8qrD+ug6iQZk2GIgN+SRS1BRZdfTUZrKRorPD1MqgjzZR158wVFjYcYMlfIdTz774
         KxUoDhW0lBO8Vw1WdYvjvL9aLHZY5kSXoav3uXIZylFRfbJwqWHnU8Zg93cNJf78MZw2
         84jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727023881; x=1727628681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g1oL5S/B37tEUQ5pYbFLSlwc7f6+AmoEVqGKun0bI4g=;
        b=LvMQNYL701lg/4gxSI0/yDtg1eyVYlLHXErSvmX2FOK6yNJRbt73i4DUSJ11ZK1NZt
         pjbpgfiJXjspjftOBn2sGy+6lsg+eg/JseRB2YiQm8Io/lBRJt7xQTmPQXBMC+lVjjpk
         MR9WKib7i7sOY4KAnJ0hvFVPpJOMDd9+lpro7SpNiKEmRJ7R3MTtcoEmtqWvaHGKgYfw
         R2K5KoQ5Nbh2c7MRpdjsU2c3NzYRDMdExr8TWYtonQaBJ2B51C2UM7jPDVxcd7xL0O7N
         4jIZv2QZxNeQbwrBjHZuO+GMCkNRa88QxXr43TOE/v4jst9siSdVhSgkh8u+qnablIzx
         khXw==
X-Forwarded-Encrypted: i=1; AJvYcCXqxhdpZ4309YTkLv0Bnlf1JneOTFHz6gp+QsgzwHgj3vmyjLxcMiaLAI6wYd9ZXrXw7N9WqQ89qrieyqU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwikFRl8fMEwg4qL2UUYTI7eHu6v1+sHtAjW5QQ0GAIp8jr772b
	Km7caFvnVNboVItWfrjLWJ2NP/C6n3WY8v8wGh0gxLmOr7n54IwmAogD67mEpk4zVFYu97DoNyT
	2YdP78Ju3V1sHpOL8dnFqJp44E8TB/Q80
X-Google-Smtp-Source: AGHT+IFaIFXNew6YSptZuEfp/uuOAp4TfLFde0avBFcvfvo5FnXC5exEtiYyCltVa5Z+vNKKF6YE38TF+QAL+A1cz5k=
X-Received: by 2002:a2e:515a:0:b0:2ef:2dc7:a8f7 with SMTP id
 38308e7fff4ca-2f7cc356047mr34091961fa.7.1727023880842; Sun, 22 Sep 2024
 09:51:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240919081432.23431-1-ubizjak@gmail.com> <Zu2D0AamCdaTUUhZ@infradead.org>
In-Reply-To: <Zu2D0AamCdaTUUhZ@infradead.org>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Sun, 22 Sep 2024 18:51:09 +0200
Message-ID: <CAFULd4afM8UA7Xitd4d39+zAixFJjJUu9Yq0K0bHa9XN8aU_EA@mail.gmail.com>
Subject: Re: [PATCH] xfs: Use try_cmpxchg() in xlog_cil_insert_pcp_aggregate()
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chandan Babu R <chandan.babu@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 20, 2024 at 4:16=E2=80=AFPM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Thu, Sep 19, 2024 at 10:14:05AM +0200, Uros Bizjak wrote:
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -171,13 +171,12 @@ xlog_cil_insert_pcp_aggregate(
> >        * structures that could have a nonzero space_used.
> >        */
> >       for_each_cpu(cpu, &ctx->cil_pcpmask) {
> > -             int     old, prev;
> > +             int     old;
> >
> >               cilpcp =3D per_cpu_ptr(cil->xc_pcp, cpu);
> > +             old =3D READ_ONCE(cilpcp->space_used);
>
> Maybe it is just me, but this would probably look nicer if the cilpcp
> variable moved into the loop scope, and both were initialized at
> declaration time:
>
>                 struct xlog_cil_pcp     *cilpcp =3D per_cpu_ptr(cil->xc_p=
cp, cpu);
>                 int                     old =3D READ_ONCE(cilpcp->space_u=
sed);

No problem, I just tried to keep the number of changed lines as low as
possible. Some maintainers don't like functional and cosmetic changes
mixed together.

>
> >               do {
> > +             } while (!try_cmpxchg(&cilpcp->space_used, &old, 0));
>
> And this also looks a bit odd.  Again, probably preference, but a:
>
>                 while (!try_cmpxchg(&cilpcp->space_used, &old, 0))
>                         ;
>
> looks somewhat more normal (although still not pretty).

Yes, the alternative form is what some maintainers prefer.

> Sorry for not having anything more substantial to see, but the diff
> just looked a bit odd..

I'll prepare a v2 patch with the suggested changes.

Thanks,
Uros.
