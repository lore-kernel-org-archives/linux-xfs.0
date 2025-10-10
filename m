Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C0072614
	for <linux-xfs@vger.kernel.org>; Fri, 10 Oct 2025 17:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760117755; cv=none; b=Orx0zOMfX/DLHv9wyd9CGc/ycrb6sYsv6ZLVypapTs1JZVt1U8DmLpNZByWecBjbyP68pDO7+qbgkx6+5yA9ex6FyUV6xIlTxURTxPNWifguLIU3FxPXO1U+FTupiHmU8RPDK8qu8K88jghv4WVb0PnMyfoRFj9sDGKIHekfrs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760117755; c=relaxed/simple;
	bh=IggglKYr/mYXyJC0Xtb77bCR7NPMqzz+1XJexnGAlKI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D1sSk5Z0R2RHIG0PpL+I85lX7HbBSdktmGX3WrHVvap87p+bzel40TfQswLX2yau48pww4IGf9RAS7EGGuo2/mnoVrGYzZH2w1cjoKhnYnYga6GkzwSI+e+D4z2UTfU5CLFlRyyjhShlef0ZLR50gLUXCuvRZL7pt3fF8oTa4ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b=YhBjrtSf; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b="YhBjrtSf"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3682ac7f33fso27151561fa.0
        for <linux-xfs@vger.kernel.org>; Fri, 10 Oct 2025 10:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1760117752; x=1760722552; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WaJha/RTsiGsaafyilWUj58SigVqroEjGwJdfzbg+mo=;
        b=YhBjrtSfFIlndoPYWOsFp+0K5W9+lhszy5jBkHHzwMqs8geondC4Zn9mT8GGrFJFyG
         sTmfuLzn4xBXtWjMJw8D56dl/qyuXW09Swxs+1WDhLP7UcfOHr2/vigGr7kWy5l7WsIn
         lpYVjTwhFTH5Bmt5ElPpT9YlnFECjR2fXeeFGRMptdiO1b0xt6FE3J7Xs1O4zXze7RPR
         lb/s1mgGJbrr5LPaNMZ+CHM0LRrs7NNbjdHV7LNG1v0aVmW4kinIzYOuYG9c8R6uMeJB
         rf0h0jOTG4WJGwl/r99s6dWmZkedeKkj0mhVDYDMW27B9FnA4m2syfqalXRsShC0LosZ
         fvHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760117752; x=1760722552;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WaJha/RTsiGsaafyilWUj58SigVqroEjGwJdfzbg+mo=;
        b=GKbYPk5LNJ2bafLusXw2dSUSi0spJE1BaOQ4UZqXtQi89+CRSsOwffzSel0k2S6KAv
         nw0f7+SbTZ45fQ+kWyCup2IaSJe+bCCCsntoTaJmU1ek3R4HYWJdxDoXAJDmwpN3iHzZ
         +m6lsnFglW5FDVuiykscUGE0PuLWNeCvDG8gbp2EvhPZhbUS46vQWrdgwZmK/EreU7jl
         WKmA2oqDbXGsWzdJoGenOkhQs8pB38kt4Xg2/GpHZnXsW0eKk3V72CGSc6HYwTHFF2jC
         66tMxa3MzjMeqQjjaUengU8Zueji+O8//WJMdw8JU1hjyk/aABIkhaODi/+TbKJV/lCN
         VgrA==
X-Forwarded-Encrypted: i=1; AJvYcCVd1dlTLmcoru7JWiUd13FeUL4o/9YVmI/7r9danb9vblDPRvxCTIVQORNOcTYCNRVUIG/MYhxTOhk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKqvIzmPUdrzpbZd7nzqMmbRxKopa4ivWCyaTHS17NFwPtN4s3
	3xeOdXxtlu5vRzMsMIaxBlIqahkZ/+p2jD8wZP0dV40yqObnDwSy9JuVUanTaUn4kPV4TQ0Wui0
	wUmubwCvCNIMcrFiTmz9sE9DekTR1CVgCrsKwx4sE
X-Gm-Gg: ASbGncuvgQOF/Lo7CAOcq5Ui/L4Q4OtrKqjnG7qD3d16xiD11mFkXlPZtodlfioNeyn
	8Bnqfdd7ukAVTYteKl931ex5BopyGpU+1LGMz9/jMYw3G8u6QdVrirmt/bLKv0Vnx0QC3BXYHvk
	Q8+29HPhfai1CeIaJp9CvxESg/jx+7V0hLfSpKhNkDGdxmuaGaSl9PoulRg7vLzrtjR2m3vATEA
	6/Lu+PYp4WPeywCXpYlYkGx
X-Google-Smtp-Source: AGHT+IEg7U2mRo/sCuEaMBZi05IWQuozDnPwTLA4K00+QiyXbv0V6gmyV4WkX+TMmnnBajijbS/MI1qHRlcuMRqTE5k=
X-Received: by 2002:a05:651c:1543:b0:372:8cb2:c061 with SMTP id
 38308e7fff4ca-375f50e0c56mr40792551fa.8.1760117751464; Fri, 10 Oct 2025
 10:35:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251003093213.52624-1-xemul@scylladb.com> <aOCiCkFUOBWV_1yY@infradead.org>
 <CALCETrVsD6Z42gO7S-oAbweN5OwV1OLqxztBkB58goSzccSZKw@mail.gmail.com>
 <aOSgXXzvuq5YDj7q@infradead.org> <CALCETrW3iQWQTdMbB52R4=GztfuFYvN_8p52H1fopdS8uExQWg@mail.gmail.com>
 <aOiZX9iqZnf9jUdQ@infradead.org>
In-Reply-To: <aOiZX9iqZnf9jUdQ@infradead.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 10 Oct 2025 10:35:39 -0700
X-Gm-Features: AS18NWBX3sP91gIkaFjkVoWU_yHoCZUlMOojFvFO4ylrXOUPmoyQCz0m51oXW2k
Message-ID: <CALCETrXLu_iarb7TWC_6kP8c2Yyh-PweRsKhiHxS=takbG_Kqw@mail.gmail.com>
Subject: Re: [PATCH] fs: Propagate FMODE_NOCMTIME flag to user-facing O_NOCMTIME
To: Christoph Hellwig <hch@infradead.org>
Cc: Pavel Emelyanov <xemul@scylladb.com>, linux-fsdevel@vger.kernel.org, 
	"Raphael S . Carvalho" <raphaelsc@scylladb.com>, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 9, 2025 at 10:27=E2=80=AFPM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Wed, Oct 08, 2025 at 08:22:35AM -0700, Andy Lutomirski wrote:
> > On Mon, Oct 6, 2025 at 10:08=E2=80=AFPM Christoph Hellwig <hch@infradea=
d.org> wrote:
> > >
> > > On Sat, Oct 04, 2025 at 09:08:05AM -0700, Andy Lutomirski wrote:
> > > > > Well, we'll need to look into that, including maybe non-blockin
> > > > > timestamp updates.
> > > > >
> > > >
> > > > It's been 12 years (!), but maybe it's time to reconsider this:
> > > >
> > > > https://lore.kernel.org/all/cover.1377193658.git.luto@amacapital.ne=
t/
> > >
> > > I don't see how that is relevant here.  Also writes through shared
> > > mmaps are problematic for so many reasons that I'm not sure we want
> > > to encourage people to use that more.
> > >
> >
> > Because the same exact issue exists in the normal non-mmap write path,
> > and I can even quote you upthread :)
>
> The thread that started this is about io_uring nonblock writes, aka
> O_DIRECT.  So there isn't any writeback to defer to.

I haven't followed all the internal details, but RWF_DONTCACHE is
looking pretty good these days, and it does go through the writeback
path.  I wonder if it's getting good enough that most or all O_DIRECT
users could switch to using it.

--Andy
