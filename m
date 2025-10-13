Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387762868AD
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 12:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760360349; cv=none; b=QvcD7gwCepsfNe9T7ZiiJYiF3CqF0VuMlvL2ktnqBe05O1ShWW+NNDQlCuC9L2rtnoslchtfavCVVM6zgw9mxudbGioMzLSWpZDJrgEm2Yon+aNrb8PGApniweYypQv4G9YZi8mVzhaHWWjfF4a866yznhAl99GSK21B599Glzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760360349; c=relaxed/simple;
	bh=D6V3XPkrc+t2idQmAkRSOk7iDPs7p8w0xsyna0/EAms=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Edl5M/ZveY0bNR6czCsLtXDTShk5U4QhWoRwmUoLEWC0NqG9d/s8qcBZp0gKv9ntcYbG+9MhZaq3x6Hgq+XXWcI42frlGY8mUnS0dytfOba6f1DQ64b95Nq7E0gcqn6p/J3tmxe1CuzJFvUmT2p8kcH8Q1teldnRJzZf7+k/DII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=B9UyH05f; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="B9UyH05f"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-36ce5686d75so2849050fac.3
        for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 05:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1760360345; x=1760965145; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Wmypoq4JusPQtINuz1Vuv55d8t7TPWrzMFDko8wjps=;
        b=B9UyH05foBQyFo3GAqVmomH33i32hZfsbauxq2TxSOZXmKGJfh08jxhtDuYctqirTi
         +znbj5YMDykLDsosYTPWEgW+T2R4d6Kpu26CrxcrpHuyKc5hlq7p7XABUmzfVxyE3HYo
         YjQqvWGD9A3KL6wQKE9NuFhi9ZCiLWGbmax+NtRk0Tm7h66+iNefKK/1pCYfUljJl+yQ
         nzCT1p1+4OVJLh+B1DSyY9lOk948JiO4EpJ5btrqqtrgc+zcetIN0DjA5BT0I8BaF99r
         atybbxItM8SPjnbn8hiNTQVdD39QA2GOdN/PCu/Bt0M9eOZ7f0xTDW16UaqhNBGmwEdC
         z/qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760360345; x=1760965145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Wmypoq4JusPQtINuz1Vuv55d8t7TPWrzMFDko8wjps=;
        b=qKyc8Tctt8hg19QNplfFtfSJFR0YDQhgDGJnCv83fjG2nocl4+Ogt4VPeeLvCtur1K
         Jy7l7ZevgxWghRzwxHKYk+3SqDKLlcMT3Cw3oJ/EHat9Ts/6klnLPuIb5LMRDDlBhfyf
         ZAReCj025ld94sfwLBL99QPZWY8K40pIMMdJX/jRgAGeQzPgwygV857BINcfvH4K05K3
         kX2WHX6xObp1tuUBhANoUl92k6MTtUXiy84Q1YUZE+oEV1GS1VZgko4eeOq+8OqRy0jB
         NszwE+jY9eJ3AGVCgJ7JMJv8C8dMbk54T6OHJkF83YNhydI0S0BwWLYqZoSLOgw1Vj2H
         D5+A==
X-Forwarded-Encrypted: i=1; AJvYcCVXuvZzgI0TNNahbH2ZQ9dzoDpqMntcZOMTTBYSYC0JQTDLu5YLngQb9ndd9tLEjAwJsIC0lRx14rY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5WlaQkbloh88Og1l66sX6zkx1HxymU1NuJaQQiUaU1+juYUuT
	eciGxoea7JdQIspof4WbJgP63k73EOBrmzY+ODLGiKIUpPXbKd/Wt5w67WewUa9JTeVrIoGZEz2
	f4W+95ijqf6HcxiQ8J46luvSJT6rfTXIX+cSpLrMeIg==
X-Gm-Gg: ASbGncuIqHAhyQhFQnPCV1DR3W+PgcHn6ovrPqXxSwCt3WjOSObw6wSKy2UYMDjunrT
	ne44v6Oie1rq144keN6gmiX71t1ZOL36v3nP9BBx+bhSsseTImRViZQL84FcrWKkBT+4mjvwtti
	5mwLGiCOGZt702owsXRQ+NZgQ55oCpcvAnDpF1RRPfVWKqN2xOraG/aYL7IT2hrEhZBr6RY5UMr
	ne9pYuj7WoZrihf/NaCRQl/HhUCnQExHf/tNs7WbjzH5g==
X-Google-Smtp-Source: AGHT+IFcgfB7Wf1FZ1oK1mDKCUiDJpUURtVox8EHig27s8X9dUwwKIMVBBoJvN74OlkrVqbewuUEWyvLA9j7WIpDFWo=
X-Received: by 2002:a05:6870:5490:b0:395:11a1:2a5 with SMTP id
 586e51a60fabf-3c0f68f3ed7mr8576313fac.19.1760360344992; Mon, 13 Oct 2025
 05:59:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251011013312.20698-1-changfengnan@bytedance.com>
 <aOxxBS8075_gMXgy@infradead.org> <CALWNXx8pDOvDdNvw+v0rEyi33W8TL+OZW1YiFbF6Gns3PeWOLA@mail.gmail.com>
 <aOyb-NyCopUKridK@infradead.org>
In-Reply-To: <aOyb-NyCopUKridK@infradead.org>
From: Fengnan Chang <changfengnan@bytedance.com>
Date: Mon, 13 Oct 2025 20:58:54 +0800
X-Gm-Features: AS18NWDyQf8Y1FBCeSc2-tQU2iORMO74jotl63VadojDvfzhepmbn3llIRtG9jI
Message-ID: <CAPFOzZumoCERUj+VuegQNoAwFCoGxiaASD6R_4bE+p1TVbspUA@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] block: enable per-cpu bio cache by default
To: Christoph Hellwig <hch@infradead.org>
Cc: fengnan chang <fengnanchang@gmail.com>, axboe@kernel.dk, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, jack@suse.cz, asml.silence@gmail.com, willy@infradead.org, 
	djwong@kernel.org, ritesh.list@gmail.com, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Christoph Hellwig <hch@infradead.org> =E4=BA=8E2025=E5=B9=B410=E6=9C=8813=
=E6=97=A5=E5=91=A8=E4=B8=80 14:28=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Oct 13, 2025 at 01:42:47PM +0800, fengnan chang wrote:
> > > Just set the req flag in the branch instead of unconditionally settin=
g
> > > it and then clearing it.
> >
> > clearing this flag is necessary, because bio_alloc_clone will call this=
 in
> > boot stage, maybe the bs->cache of the new bio is not initialized yet.
>
> Given that we're using the flag by default and setting it here,
> bio_alloc_clone should not inherit it.  In fact we should probably
> figure out a way to remove it entirely, but if that is not possible
> it should only be set when the cache was actually used.

For now bio_alloc_clone will inherit all flag of source bio, IMO if only no=
t
inherit REQ_ALLOC_CACHE, it's a little strange.
The REQ_ALLOC_CACHE flag can not remove entirely.  maybe we can
modify like this:

if (bs->cache && nr_vecs <=3D BIO_INLINE_VECS) {
    opf |=3D REQ_ALLOC_CACHE;
    bio =3D bio_alloc_percpu_cache(bdev, nr_vecs, opf,
    gfp_mask, bs);
    if (bio)
        return bio;
    /*
     * No cached bio available, bio returned below marked with
     * REQ_ALLOC_CACHE to participate in per-cpu alloc cache.
    */
} else
        opf &=3D ~REQ_ALLOC_CACHE;

>
> > > > +     /*
> > > > +      * Even REQ_ALLOC_CACHE is enabled by default, we still need =
this to
> > > > +      * mark bio is allocated by bio_alloc_bioset.
> > > > +      */
> > > >       if (rq->cmd_flags & REQ_ALLOC_CACHE && (nr_vecs <=3D BIO_INLI=
NE_VECS)) {
> > >
> > > I can't really parse the comment, can you explain what you mean?
> >
> > This is to tell others that REQ_ALLOC_CACHE can't be deleted here, and
> > that this flag
> > serves other purposes here.
>
> So what can't it be deleted?

blk_rq_map_bio_alloc use REQ_ALLOC_CACHE to tell whether to use
bio_alloc_bioset or bio_kmalloc, I considered removing the flag in
blk_rq_map_bio_alloc, but then there would have to be the introduction
of a new flag like  REQ_xx. So I keep this and comment.

>
