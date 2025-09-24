Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114211D618A
	for <linux-xfs@vger.kernel.org>; Wed, 24 Sep 2025 23:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758755558; cv=none; b=NV8/jx+oxB9xw2FAnD5n2NTDXKlxOaqi09SkPlQfj0l/TdQ0QLaRp2BRBRSXtJ4DD168pBTBDE41sqOdK3VJHiC83pQ1rgWWwWSdrm6HQSbuhu0dFmQoGTvZ3wrZeXSoK/xbRUUTujHKs/yvG2GeHd3Am65lrsiGtAKoa8RTy0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758755558; c=relaxed/simple;
	bh=V3NpRvW9bDS8Px6ewZhXBsJXI4FZyxfkPen8qdeBDls=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EeatKSUAIkDO5ykRT8qIjth/BbYbQmbZMmJQE8kfdGvGgIRnlC3mIq85OgLYZQocdfZufDb13RnvW/zD86H/XClntDepSBg22Bv8WPHZgqfo7NgGqw321Be9liHaemh4U6NkEfiEBtFUKSQy3HkX7evFi/hPlxu/uesGe77QtCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lT6ohyE6; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lT6ohyE6"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b7a40c7fc2so5519881cf.2
        for <linux-xfs@vger.kernel.org>; Wed, 24 Sep 2025 16:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758755554; x=1759360354; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9wgF3EXW2n5jzxxpEDCh3f6sbRv5p5MtrNgzg6BXcr4=;
        b=lT6ohyE60JBfvPm+x6zX4Oex9jlt/EI6qns2Iqpn1JwjHEXXObAAY78PNGnR+NXbMe
         /Hf4IotQ6YE4hJFpspnzk7GCskHp+dxcI8S2fTgvg2UcmQf6G24ZMQaYWu9cH5ArKe00
         ibjC0sp2Cohb9/DTLxjQYbGj4gSFOfIrKvrMESKsZS60Xv/eLFh9eIyVQPtvROkTvBnX
         Q9MPNgpDvoPBD/YjhSCfwP8a+L93J9JHaM55qOlXaCyzdC0j2h579M4UFrFMfPaIgGSt
         UIpMGbczytjJAG4Hal80IZx0QVwEeYnMxM4RKtRC/ngmgwnim2K367GrclTW1kGUNw8H
         08ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758755554; x=1759360354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9wgF3EXW2n5jzxxpEDCh3f6sbRv5p5MtrNgzg6BXcr4=;
        b=jEMnRr+8pJDv3xtntqOV+B5kY8FiiYYsEnLoktyeIzEo2aA0Fo0jeOGbkQaN3uqPrL
         7LAyA/fG1rbxfze39+fDewf6Yy/55kuVlNTWPB9VoSmlRIEeyet7ZKpgMFH0d6chhwQ5
         db9S8uK0PxuVzRBuMwmhYPDiC3/k8xvcEG2XLfxyu3OxjmrgCDTd9QYbxYgvR5gDsxN9
         YM775U1sw93fcU3KPFDxr0FDDReCezCdUtSMVXi7ZRdZ6+PkAjv1FvM46DZ6a5uR5Ogy
         qBDZfp15jHsoWp/wr3zQ5bUWOrmglEgAf1W6+f//kPiFwsGFmEMLKhYE80FKXWNT7sm+
         E9cw==
X-Forwarded-Encrypted: i=1; AJvYcCUhO0k4BRCBko1s7uApxqxOh9wlWEMqh7wIpWcS8sZPOyul+Nbx6GdD9xwwlkUm4hN4fbWwRPIqxFs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/l4pAaRRU108vdzR8UATxQOLJ94lGl/fTRvYjInebovXAXJN3
	s7c8zMfsW3kLEEOURC5QbDDXZyugXlYKKRnhSeKJiQgBk14IgyAQrxXMAiTDSOnFpi3u2TU7Mjy
	QZ8LricbyZY3TYH8kGdSFCWGn1IIE2Wk=
X-Gm-Gg: ASbGncvzy2Pe6SB7RflH5wBLxGpDWTV5Z0JVdGShSn0/6Lzg2T53e3n/YodxsJboR84
	7R/9ExRQd5JFhVmvBOOGTcyIftymOpEkZu7T7V26qsCvhGGFBp4VYNoAEBJlPvYJIFcBXiKmP2r
	0lKr+X8FA13hDPzPhkqO3PCv/LNfu/K+likLwXSUzjzSDpnd69IbO7OzBT6QrL6KEdTvQy5QFF0
	E6vBVGlLSm65PiVfCF40DLAhHnZAEukZSqd+Acb
X-Google-Smtp-Source: AGHT+IFI3JXzb4wb/FLOXlNqpgywkoeH7/aGkNbo/vnp3lU+rvvw0QDL0p6Eu/GxfgLHprie/Bfe3B2N/aliflsdlAQ=
X-Received: by 2002:ac8:5852:0:b0:4d9:5ce:3742 with SMTP id
 d75a77b69052e-4da4cd4aaabmr19919071cf.67.1758755553864; Wed, 24 Sep 2025
 16:12:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250829235627.4053234-1-joannelkoong@gmail.com>
 <20250829235627.4053234-6-joannelkoong@gmail.com> <aLktHFhtV_4seMDN@infradead.org>
 <aLoA6nkQKGqG04pW@casper.infradead.org> <CAJnrk1ZxQt0RmYnoi3bcDCLn1=Zgk9uJEcFNMH59ZXV7T6c2Fg@mail.gmail.com>
 <20250923183417.GE1587915@frogsfrogsfrogs>
In-Reply-To: <20250923183417.GE1587915@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 24 Sep 2025 16:12:22 -0700
X-Gm-Features: AS18NWA4HpZiLWRRef-i6KCQzuvd8AAyFsAqQlriSVtFgrbOhCHtzlyVTDl3KTo
Message-ID: <CAJnrk1Y=S5eP4nZ6nXKDWA646+q6gR4sXBSE732-aMa5uJnSaQ@mail.gmail.com>
Subject: Re: [PATCH v1 05/16] iomap: propagate iomap_read_folio() error to caller
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>, brauner@kernel.org, 
	miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, kernel-team@meta.com, 
	linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2025 at 11:34=E2=80=AFAM Darrick J. Wong <djwong@kernel.org=
> wrote:
>
> On Mon, Sep 22, 2025 at 09:49:50AM -0700, Joanne Koong wrote:
> > On Thu, Sep 4, 2025 at 2:13=E2=80=AFPM Matthew Wilcox <willy@infradead.=
org> wrote:
> > >
> > > On Wed, Sep 03, 2025 at 11:09:32PM -0700, Christoph Hellwig wrote:
> > > > On Fri, Aug 29, 2025 at 04:56:16PM -0700, Joanne Koong wrote:
> > > > > Propagate any error encountered in iomap_read_folio() back up to =
its
> > > > > caller (otherwise a default -EIO will be passed up by
> > > > > filemap_read_folio() to callers). This is standard behavior for h=
ow
> > > > > other filesystems handle their ->read_folio() errors as well.
> > > >
> > > > Is it?  As far as I remember we, or willy in particular has been
> > > > trying to kill this error return - it isn't very hepful when the
> > > > actually interesting real errors only happen on async completion
> > > > anyway.
> > >
> > > I killed the error return from ->readahead (formerly readpages).
> > > By definition, nobody is interested in the error of readahead
> > > since nobody asked for the data in those pages.
> > >
> > > I designed an error reporting mechanism a while back that allowed the
> > > errno to propagate from completion context to whoever was waiting
> > > on the folio(s) that were part of a read request.  I can dig that
> > > patchset up again if there's interest.
> >
> > Could you describe a bit how your design works?
>
> I'm not really sure how you'd propagate specific errnos to callers, so
> I'm also curious to hear about this.  The least inefficient (and most
> gross) way I can think of would be to save read(ahead) errnos in the
> mapping or the folio (or maybe the ifs) and have the callers access
> that?

That's what came to my mind too. It'd be great to have a way to do
this though, which maybe could let us skip having to update the bitmap
for every folio range read in, which was discussed a little in [1]

[1] https://lore.kernel.org/linux-fsdevel/20250908185122.3199171-1-joannelk=
oong@gmail.com/T/#mffb6436544e9be84aa0ac85da0e8743884729ee4

>
> I wrote a somewhat similar thing as part of the autonomous self healing
> XFS project:
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/comm=
it/?h=3Dhealth-monitoring&id=3D32cade9599ad951720804379381abb68575356b6
>
> Obviously the events bubble up to a daemon, not necessarily the caller
> who's waiting on the folio.
>
> --D
>
> > Thanks,
> > Joanne
> > >
> >

On Tue, Sep 23, 2025 at 11:34=E2=80=AFAM Darrick J. Wong <djwong@kernel.org=
> wrote:
>
> On Mon, Sep 22, 2025 at 09:49:50AM -0700, Joanne Koong wrote:
> > On Thu, Sep 4, 2025 at 2:13=E2=80=AFPM Matthew Wilcox <willy@infradead.=
org> wrote:
> > >
> > > On Wed, Sep 03, 2025 at 11:09:32PM -0700, Christoph Hellwig wrote:
> > > > On Fri, Aug 29, 2025 at 04:56:16PM -0700, Joanne Koong wrote:
> > > > > Propagate any error encountered in iomap_read_folio() back up to =
its
> > > > > caller (otherwise a default -EIO will be passed up by
> > > > > filemap_read_folio() to callers). This is standard behavior for h=
ow
> > > > > other filesystems handle their ->read_folio() errors as well.
> > > >
> > > > Is it?  As far as I remember we, or willy in particular has been
> > > > trying to kill this error return - it isn't very hepful when the
> > > > actually interesting real errors only happen on async completion
> > > > anyway.
> > >
> > > I killed the error return from ->readahead (formerly readpages).
> > > By definition, nobody is interested in the error of readahead
> > > since nobody asked for the data in those pages.
> > >
> > > I designed an error reporting mechanism a while back that allowed the
> > > errno to propagate from completion context to whoever was waiting
> > > on the folio(s) that were part of a read request.  I can dig that
> > > patchset up again if there's interest.
> >
> > Could you describe a bit how your design works?
>
> I'm not really sure how you'd propagate specific errnos to callers, so
> I'm also curious to hear about this.  The least inefficient (and most
> gross) way I can think of would be to save read(ahead) errnos in the
> mapping or the folio (or maybe the ifs) and have the callers access
> that?
>
> I wrote a somewhat similar thing as part of the autonomous self healing
> XFS project:
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/comm=
it/?h=3Dhealth-monitoring&id=3D32cade9599ad951720804379381abb68575356b6
>
> Obviously the events bubble up to a daemon, not necessarily the caller
> who's waiting on the folio.
>
> --D
>
> > Thanks,
> > Joanne
> > >
> >
