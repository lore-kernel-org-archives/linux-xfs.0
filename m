Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7702A23395C
	for <linux-xfs@vger.kernel.org>; Fri,  3 Jul 2026 01:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783042632; cv=pass; b=aeSwcp9+UG7P3xinGz+mucPGDePEYPwuHPo+c6uM0u20qmwQSK1kJtqVaDKE9UFOGeUKY/gdK03/DTlcxVrDOYRyB4/9xnA492WWgCyUSWYzJf2g2ydx3Oti23hXkqoHfT/cn/SMW6Azn7OxHetRYldwBkxuA7nyuCksjZriNGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783042632; c=relaxed/simple;
	bh=YMafmxr+u+dHYErOVxj/FNmniwqg1vVnRq/lLcyl4cI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KerGiUGMa6Aqm4OjpLyTolKGcrncpG8P6n8zR8ukDcGQfeu2Jc0X1Ba4tbFCT1WOGuDnffLIdTZJ5eW1crtL1UXLdvQeN8+ewSKG50eVAMPKXbSYStbHTIZwqHysnVrS6CSfwjL6mEeYGBcg/zKABTcCsc1yZm+tgJa1GRzEClY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OSLPPSxW; arc=pass smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OSLPPSxW"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-474303f3c72so37243f8f.0
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2026 18:37:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783042629; cv=none;
        d=google.com; s=arc-20260327;
        b=TaAa86hzOusjF1Ye3MuW3g9crc3BNoynq2FHKqcxzwUgP0NYhn7pkNCQEB4HsEOs2a
         Tjh2MM+zvMWscFVPIWxGWMhK87nkTR9+aVIOUGs7RRyM3RIEJqar28oqF5fMxkzQakOP
         lr6xKqq+Sl5BeM58+Jo42J5CuBVY8PuViCx/qdHvvg5Dj7cHuFGO8MTervvoV/fs+NEc
         KJkg9ik99pKqF/1HGNQeuYntEbvRq3rWuyofKsuO1oHFZgysoxTtylkv/utpZetJf9ao
         Wsbo8l85tUHNZpWMPFBbhISM9HNNiQrKgHHuuM6jPmKPYmdiU+aVsogcnkl0gehEWAyw
         LY3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tNl1bH7dvjSHeVWsTMaZDTnFNN2LUwwSM0ajOC2Eq64=;
        fh=TC7xAIBlyEyJ3NJYZ+fSGKS0XyE//FlRGfrlmbpllzM=;
        b=lHCJsi64mzghw/E03O+G+0S6UgGvLVRhyVnJ2lvTOI7lWYAe7w5YSKHhWL6WH24t51
         OhSL4sPZkSakj3V8Es3F2HmNJKEYda0/MulbuQD840Lq3SDutjDKXMiEd3P0vLTZ8qBc
         KmuIWg1llEK12xt3da8zFi3bqxYxpFMNGL+SeD/0TskLNzvaX7T1cZ0ayQWqgaV1IKQV
         /ZrtECS6IM8+44ox75g2HFqAuRVVh9yd+l8JBLXi/s4Eb++C9SgoQ4TuBa7XbDhh5GzC
         7vHyXhoOUkqpBMLPkJZr/JyePYYrByQA9HDWKnFT9rsjf0Sj/Hya+bXaIwWbcoQeI67o
         ZHaA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783042629; x=1783647429; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tNl1bH7dvjSHeVWsTMaZDTnFNN2LUwwSM0ajOC2Eq64=;
        b=OSLPPSxWqn16s4eGDyLbORnovIBg0BtZJEBnyWUTexpYXt8jm4lfKodTxqjuVIL9a8
         UIeaVlXFh12HjENRQT9FcNB7LBWNIifhYipV59o0X5yZl7VOhkxmJupuBO46kwiyiOkE
         93wutWBGfTbZYmDxWO1GLUv0N6WC/TtJFAsoLtujAJoUcXmoXaWQEB7x197T0hulyg/M
         ZC+NA03JauS5I1oypD3UhDj7Vp3kPaZmDldemIe0joGocE0Tba+pGkNt66yclJ/Y+5kl
         Y41OTrS7TTQoZX1XtA6f/MQITHdAjywPhIYWJv8Azlp0edlR7Cag82xBZZDniRrqnpbf
         T9rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783042629; x=1783647429;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tNl1bH7dvjSHeVWsTMaZDTnFNN2LUwwSM0ajOC2Eq64=;
        b=E1wZB+rDcA8YoHx8F4ZlZaO2IcEBniymkLBxD5K8os7frW7n4+Ba5vhTVZfqNnfKzA
         hqY+hCl06kUpPeKWbtWG0e2IGiZGIWg3G/eXbwrmqWExsTrEwuJsoknXb8R9f6Wd3vfa
         NLsOltKR+F+koCRVo3rHlD89GnyM8NtcbI26sVnkpX2S2S5vwGy0/llXXmNJEcZ4dP8v
         vz72jcSwqC1buZtTDUYqZfuksDmI52P0o1zBsiZYqVFsCeaG5G1PwQJ4yizzttR2Pr4o
         2tiJvQCtluhxHCVpKe0v0KECTfaUtt0QPhZMQStlycZUNKoLexIXZokFd/0Y+MNiUZHj
         gGdg==
X-Forwarded-Encrypted: i=1; AHgh+RougW/8l2QqY5B0FsFbCkTaqGVqzKtZgOHCD7TofIqdvTK4UfvF8sM80HOzEGTDU6c6hNgAm5cLOpQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPMLtBYccWRrqvnGgfkC8BVqfrG9GzHyYn9yAvJxvh2WXNeWkZ
	WyB2/iOgnruOXq9lXyqsQSYKmlAmDqIYtvjA9Aux9tPgDUSEGiCupEZB6spQ71xH8rrcpo96loG
	bnvuEfY9UZnJC+Wdt0sq1uxcuBDT20WI=
X-Gm-Gg: AfdE7cnOjQpmy/nBSURgsGuNuX2Umf8crO8cxVQAfUHHtg9Nh2MgbhO5qW5lq+kHlDD
	J21zwRQF5hK08CkTyEGBfd0lvUxL9pta/L2aL2sNyCMX27VnvwfTqSApRejd8Mpb7CZTVR5AvhW
	MXnMff5/OaMyxcHpzs9LzkMs5cdTQ8JkIepUYhi7IUbnk6lhGEtALqWGhQRpj1L1utHo8pzOKRk
	rjYneGDhYRF8xVO0pRX41otvWEg86nyNai7f4k8qTDBLSv/y0V/nQu5ThqDRu+tGJSZwzDwFOyC
	DZqpBVXd3KISLlOBHjks3vGBgSb6IuZJdnv4HVUf9O+SAGNlD2rt
X-Received: by 2002:a05:6000:310a:b0:474:b860:b7b1 with SMTP id
 ffacd0b85a97d-477573bbc08mr11953399f8f.9.1783042628647; Thu, 02 Jul 2026
 18:37:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-19-joannelkoong@gmail.com> <20260702192658.GN9392@frogsfrogsfrogs>
In-Reply-To: <20260702192658.GN9392@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 2 Jul 2026 18:36:55 -0700
X-Gm-Features: AVVi8CcC6fzVqkOo0UfHNUMqKEbgK9tYEuLIjcETtAi_mnO3ekDmRCY21CtHqN0
Message-ID: <CAJnrk1YZQOQ0D6p6qYx1BPvKQaDgZsrKzLbGZzaH8tUkj_OoOQ@mail.gmail.com>
Subject: Re: [PATCH v2 18/18] Documentation: iomap: update docs to reflect
 iomap_next model
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: brauner@kernel.org, hch@lst.de, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 12:27=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Tue, Jun 30, 2026 at 05:09:33PM -0700, Joanne Koong wrote:
> > Filesystems no longer pass a struct iomap_ops with separate
> > ->iomap_begin() and ->iomap_end() callbacks.  Instead, every iomap
> > operation takes a single iomap_next() callback directly. iomap_next()
> > finishes the previous mapping (if any) and produces the next one. Most
> > filesystems build it from begin and end helpers via the iomap_process()
> > helper.
> >
> > Update the iomap documentation to match this change.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  Documentation/filesystems/iomap/design.rst    | 115 +++++++++++++-----
> >  .../filesystems/iomap/operations.rst          |  60 +++++----
> >  Documentation/filesystems/iomap/porting.rst   |  22 +++-
> >  3 files changed, 132 insertions(+), 65 deletions(-)
> >
> > diff --git a/Documentation/filesystems/iomap/design.rst b/Documentation=
/filesystems/iomap/design.rst
> > index 0f7672676c0b..7a37e303eea8 100644
> > --- a/Documentation/filesystems/iomap/design.rst
> > +++ b/Documentation/filesystems/iomap/design.rst
> > @@ -75,7 +75,10 @@ At a high level, an iomap operation `looks like this
> >
> >  1. For each byte in the operation range...
> >
> > -   1. Obtain a space mapping via ``->iomap_begin``
> > +   1. Obtain the next space mapping via the ``iomap_next`` callback.
> > +      From the second iteration onwards this same callback first finis=
hes
> > +      the previous mapping (committing or unreserving space as needed)
> > +      and then produces the next one.
> >
> >     2. For each sub-unit of work...
> >
> > @@ -86,7 +89,13 @@ At a high level, an iomap operation `looks like this
> >
> >     3. Increment operation cursor
> >
> > -   4. Release the mapping via ``->iomap_end``, if necessary
> > +iomap repeats this until the range is fully consumed.  The ``iomap_nex=
t``
> > +callback returns ``1`` while there is more of the range left to proces=
s,
> > +``0`` once it is fully consumed, and a negative errno on error.
>
> s/and/or/
>
> > +Filesystems rarely implement ``->iomap_next`` by hand. The ``iomap_pro=
cess``
> > +helper implements the finish-then-produce sequence in +terms of two sm=
aller
> > +callbacks, ``begin`` and ``end``. See `The Mapping Callback`_ below fo=
r more
> > +info.
>
> I wonder, under what circumstances would a filesystem /not/ use
> iomap_process()?

Hmm, maybe a situation where they need to share or carry some
filesystem-specific state / info between finishing the mapping and
producing the next one?

>
> >  Each iomap operation will be covered in more detail below.
> >  This library was covered previously by an `LWN article
> > @@ -189,7 +198,7 @@ The fields are as follows:
> >     * **IOMAP_DELALLOC**: A promise to allocate space at a later time
> >       ("delayed allocation").
> >       If the filesystem returns IOMAP_F_NEW here and the write fails, t=
he
> > -     ``->iomap_end`` function must delete the reservation.
> > +     ``end`` function must delete the reservation.
> >       The ``addr`` field must be set to ``IOMAP_NULL_ADDR``.
> >
> >     * **IOMAP_MAPPED**: The file range maps to specific space on the
> > @@ -208,12 +217,12 @@ The fields are as follows:
> >
> >     * **IOMAP_INLINE**: The file range maps to the memory buffer
> >       specified by ``inline_data``.
> > -     For write operation, the ``->iomap_end`` function presumably
> > -     handles persisting the data.
> > +     For write operation, the ``end`` function presumably handles
> > +     persisting the data.
>
> Unrelated to this patch, but this should say "For write operations, the
> end function must persist the data" because iomap_writepages doesn't
> handle inline data.
>
> >       The ``addr`` field must be set to ``IOMAP_NULL_ADDR``.
> >
> >   * ``flags`` describe the status of the space mapping.
> > -   These flags should be set by the filesystem in ``->iomap_begin``:
> > +   These flags should be set by the filesystem in ``begin``:
>>
> > +``->iomap_next``
> > +~~~~~~~~~~~~~~~~
> > +
> > +Each call must finish the previous mapping, if any, and then produce t=
he
>
> Each call?  Oh, each implementation of ->iomap_next must finish the
> previous mapping.
>
> > +next mapping for the current iteration position described by ``iter``.
> > +The mapping is returned through ``iomap`` (and through ``srcmap`` for
> > +operations that read from one mapping while writing to another; see
> > +``begin`` below).
> >
> > -``->iomap_begin``
> > +The callback returns ``1`` to continue iterating, ``0`` once the file
> > +range has been fully consumed, and a negative errno on error.
>
> s/and/or/
>
> I think there should be a transition sentence here along the lines of
>
> "Most filesystems are not expected to implement all of these behaviors
> in ->iomap_next themselves.  They should instead call iomap_process as
> described below."
>
> Or demote the next section so it's more obvious that the "iomap_process"
> and "->iomap_next" sections aren't independent?
>

Sounds good, I'll incorporate all the suggestions you recommended.

Thanks,
Joanne
