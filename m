Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA553D5660
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 23:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783036795; cv=pass; b=qc7yDwfyuIVA59ue8S1ylvNlFfBGhbqqnrmVhShOy250KJ3PgyC7LePYHKzCpTDITYkyP7+0BXz0F5Gr7BYlWiGv4gg0yxg6wARAl6wNYXTJlZOY48RgPbDTLnipoOQqHGbcLX/wo+zYZ9luPU4LWMYBJY5KVEQTS2HO+RjilE4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783036795; c=relaxed/simple;
	bh=9mfrTGat0AT7NLP1gbhbIUiw0dL1UYJaiMio4afATB0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mtqEF/yrSete055ygt1X+tRucSU+0WRy4CxtxPUX6/t5Pf8k7r18sEczvs7UX71/8nGu3eYnUWitbRUBhYVr8D6ww5HLVwety/7CYA5BPb06kSC3X8v9M//VV7QYm/++Ghm7pzjqdtluw19OykSmtqVvxxVCrml2sJyywDLSLQ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LuRB4kcA; arc=pass smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LuRB4kcA"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493c5220cb7so11660115e9.3
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2026 16:59:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783036792; cv=none;
        d=google.com; s=arc-20260327;
        b=l15k5WQE7FDTsyGBt2HoUgew8wMbvNGacAhRFx8n6wtgTVIAILc0vysLY71jJnEyfO
         lwCgKl3bydSFPGKtnVCzK9bnsKX9F7baRe/CvCTCfEEOMo1y7zz6kiYyEU7q51WbqkP7
         g61O9x/CWkuGH2CNiydbrLxoFJaP3E8C1aQJI5Q2pmVyH0c47Jz9OlxpVmNVN+mMs7B3
         TEckQ29978Q+d9rjddGcy2GYfA0+rFvvIiU3yDddikrKIjfEQjU5l7uUicIyHnObMoVh
         pjAXfGcurSrfCqgCRyENWCju3t/AYoiSDe5k9lNwam+2krdKQfyVuK50QXCbfgB+bBce
         6olw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Lr71FjY8xrzyOTpsfFewrECV5PtfY/nu/gI0pAnlh+k=;
        fh=u5gJkXUBK3qBX201ktVvUz1pk+WCQa2CYyjRtsKmT8U=;
        b=dzUIduPyzSNGTxg04qAoDRJ3LaDfwjD7yWAWLFhFnCZpZ2ovgRdD79JdgYWgQaIMS0
         9rf8LTQhZFXiZMGKFykQqPhYBP4u6cB8dueDO4AeG5In/xBB0RpXAIEoXS0aYAHJjthC
         Mtp/SUUAMLOuNVqsUP5/2yrQQeta1cIKffmvd70NWtqw/MbqJAhC5FCbr98NQ+9/8p6k
         ia4xQOi3DpZ7B5Jv9LuyOWgvoD9nrjNcg0FtTM868TXALjVFPjW4b3jiWjA/PqGe3Ow9
         R1jQi75mXs0/U7oCIJ0Q80dLVNQA1rDnxDcgsddbD90cZku2UGz7PigmKMI2I4P8V0SI
         5EEg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783036792; x=1783641592; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Lr71FjY8xrzyOTpsfFewrECV5PtfY/nu/gI0pAnlh+k=;
        b=LuRB4kcAQ9y8MIh/YvJtL+KSYYf77KFXLPxOyovtVvvxUHgY0YjXmkAZKsLwfpa8jG
         GUkFHhPhYd+M6tHa3Flt0x2uLlVRCQ6HrtYLmsu/ZKg+yhOqpvoC+1SlEkYocacz0KDV
         UjmI1kBSJk7VR81NuS4u7mLSYR/FG9Gr5Y9wUJuZkf5oEAABAtveNRpIWXNm0W5nBCDm
         EwXZPxpIdqvrovrJdohH94O5YoE6oyQSvHBUZXxlIyQeHfmfvFRfnVYJXYWRlfEwyEVS
         8lqrVie50IoGIFy0cVztoVHbk6/Ikbl1Q2pN7Y9BW9IMK7FcLsc8UpWrUc7eqPcXeZon
         fgoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783036792; x=1783641592;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lr71FjY8xrzyOTpsfFewrECV5PtfY/nu/gI0pAnlh+k=;
        b=ZPlJHRattStZ792DmfQjQk76AshKCO+GRCYZhgtOBJdsfTtFqV1IAW3T4tgKo2y11k
         NHBe1BQ8d3oTNQg96vExQjapG6wzsX0hF7nra/FTskMWVqwBQexGMgmSFxaQFw1cVen3
         Liwts1f0fLdlHD4S6ytkZwJWAqdtV78fsqSI472pZQofpN3MyjGbcxFLWGa163AGmCQ7
         UBdwHtuaZ3+bmxioS+cjIw/bGAU5AWfS2JxStDtKzSk+NVg9ByF9cJ5zi0MgQ77Pi5aX
         XY8E/ejd+KAo3wws2nvXlEbph/NcnmhyOqEezZeT+nTmf3n+GkDmzTpaA9zfQgmCEVdm
         ToSg==
X-Forwarded-Encrypted: i=1; AHgh+RqPq4keUyaBat3bR1PmbQDPv9IRDpIMieGa8DTP8XHcHzYXNyN5ILhpzPwrT1OKtvIQJ59s664fHD0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPGlySDHZgRec4Z8spQytrU3KeynOkcr/dsq+z3iOQ9Y/5BYVX
	HwzIa0V07wuXe3BqkKEy9XPwlQ5xrUXyIw+HT6OuUytNxy3TacFX2J7REYZHli/XU46XgluS+8A
	pQCQP0kkxLqZdlc70ummhfmQaO3CE0ww=
X-Gm-Gg: AfdE7cl5Gvjixhj02Kp1wdHh4Gzr6QuTfC5E0JpkP28xvBGlPxIgkZO9ztCs66iMOE2
	QhtX636UzWfrGRIyvS1T7v0Lilvuhgl9RMnEUH/ErjaQb9QBzkjjeykUMRgddGxhiuyNWEZ91Ma
	usojg++DYUNSbM1i0ULBLZxcMuna3pjR3oqa2CrZ+FQTrbTcZD3WCreDK+U7shRmfXF5ZrfWVeC
	EVL9/IIDzoGky6v9fmY39auK73gfQm7UnPUxQnH/PGyukFXF/Ot4ilAyQpBBP5RcT53earZMMDc
	ruUEWnE00i4VMgCF90He3SHBlXFmDUqUXVCnScVFTT4ieqLwJ/jE
X-Received: by 2002:a05:6000:178d:b0:46f:7127:9f70 with SMTP id
 ffacd0b85a97d-477b3889564mr11032946f8f.18.1783036792138; Thu, 02 Jul 2026
 16:59:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-3-joannelkoong@gmail.com> <20260702164339.GI9392@frogsfrogsfrogs>
In-Reply-To: <20260702164339.GI9392@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 2 Jul 2026 16:59:39 -0700
X-Gm-Features: AVVi8CfRMLQ82BMABsxnrmWXO9hzG4sO4-QzmTQ2Zp72T-55jYigQ-9-a_U5Uvo
Message-ID: <CAJnrk1ZRQaFseAnz3zm31oR3KmQWje5HDJjhNbAQSAQyK9_PMA@mail.gmail.com>
Subject: Re: [PATCH v2 02/18] xfs: convert iomap ops to ->iomap_next()
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: brauner@kernel.org, hch@lst.de, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 9:43=E2=80=AFAM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> On Tue, Jun 30, 2026 at 05:09:17PM -0700, Joanne Koong wrote:
> > Convert xfs iomap_ops to the new ->iomap_next() callback. This uses the
> > iomap_process() helper, which finishes the previous mapping if needed
> > and produces the next one. No functional changes are intended.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  fs/xfs/xfs_file.c  |  4 +-
> >  fs/xfs/xfs_iomap.c | 96 +++++++++++++++++++++++++++++++++++++++++-----
> >  2 files changed, 88 insertions(+), 12 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 845a97c9b063..7f8bef1a9954 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -857,9 +857,9 @@ xfs_file_dio_write_atomic(
> >                       NULL, 0);
> >
> >       /*
> > -      * The retry mechanism is based on the ->iomap_begin method retur=
ning
> > +      * The retry mechanism is based on the ->iomap_next method return=
ing
> >        * -ENOPROTOOPT, which would be when the REQ_ATOMIC-based write i=
s not
> > -      * possible. The REQ_ATOMIC-based method typically not be possibl=
e if
> > +      * possible. The REQ_ATOMIC-based method is typically not possibl=
e if
> >        * the write spans multiple extents or the disk blocks are misali=
gned.
> >        */
> >       if (ret =3D=3D -ENOPROTOOPT && dops =3D=3D &xfs_direct_write_ioma=
p_ops) {
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index 225c3de88d03..4fa1a5c985db 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -1037,8 +1037,18 @@ xfs_direct_write_iomap_begin(
> >       return error;
> >  }
> >
> > +static int
> > +xfs_direct_write_iomap_next(
> > +     const struct iomap_iter *iter,
> > +     struct iomap            *iomap,
> > +     struct iomap            *srcmap)
>
> <unvarnished brainstream ahead>
>
> Now that I see the callsites, I think the "next" name could use some
> bikeshedding <cough>.  The purpose of this function is either
>
> (a) to look up the first mapping to start iterating;
> (b) to release whatever resources were attached during the current
>     iteration and look up the next mapping to continue iterating; or
> (c) to decide that it's time to stop iterating.
>
> From that it seems obvious to me that xfs_direct_write_iomap_next yields
> iomaps for iteration.  In Python those are called generator functions;
> in Rust they're called objects that implement the Iterator trait (or
> iterators for short).
>
> How about s/iomap_next/iomap_iter/ ?
>
> Then this function would be called xfs_direct_write_iomap_iter, which
> IMO is a closer description of what the function does, which is to say
> iterates iomaps for direct writes.
>
> (Yes, my brain might be polluted with thinking that "iomap next" refers
> to a major shift, in the sense of "linux next". :P)

Thanks for sharing your thoughts. The idea makes sense to me in theory
but I think in rust and python the "iter" naming is reserved for the
iterator object itself and the method / callback for advancing and
yielding the next item in the iteration is named "next" (eg
Iterator::next in rust and __next__() in python)? I wonder if the
s/_next/_iter gets confusing with multiple things in iomap already
called iter (eg the struct iomap_iter, the iomap_iter() function). I'm
not sure, I'm happy to rename this if that's the preference.

Thanks,
Joanne

>
> > +{
> > +     return iomap_process(iter, iomap, srcmap, xfs_direct_write_iomap_=
begin,
> > +                     NULL);
>
> But then "iomap_iter" sets up a new problem: should iomap_process have a
> new name that goes along with that?  iomap_iter is already taken for the
> legacy path.  If we were emulating python I'd suggest iomap_iter_yield
> but this is C so we get to reinvent everything from scratch so who
> knows.
>
> --D
>
