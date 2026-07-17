Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACE918FDDE
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 21:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784324899; cv=pass; b=pHThopAOgg+Yiw4OW3lNSSzGDfR7GqC/suBCVRbdLv/kpBqxMM1q9D8B7MGFswfwVj3DkUxhp1oYpsfmIr/y75yoQ8Q+WCQmHhqvIY3/mS49nri2t43YXmELYdjqgRpUxHJRQJuteFohz3cVqNsPYJEtBUHqp/MnCAC4bRX6f1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784324899; c=relaxed/simple;
	bh=sqU5R3rMMXM1EIenNXeNYk0ZrLRzBSfZNYzit9/wafk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qhVNjNfp+mx8HAW9Hxjo00GELfQThGzy06+TVMJdFspv//lzGSmOu2NRtnkg+HSh1vpTdhWJ0VC4mCh2TDd2AX3mtbZjb9G2Sk50H+sdq8MDtrk2/kUlV8mIdFif6UtqH1k0/S2gY/FolwdLnz+gkEocBYy0K2su9Kox0WjQP7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pXf8Eyj0; arc=pass smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pXf8Eyj0"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4954a32cf1eso4703355e9.3
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 14:48:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784324896; cv=none;
        d=google.com; s=arc-20260327;
        b=bEUhApgNWlA8DNgBhzRSPZ94lBXO848285coU6dD29VW6wSpDnSlBw8VmsSwIXypm7
         b7UxJRRJwHerd1IWQPAdzhz+PWXL+yz/MdJdRcx9TQbQp68XiYmrz7tjie4jmev9ysKK
         9eEoYp1399+tAJvMSV6JkLQeM6yZNKPYlZbMqtZ44t+YrzwAw6CdeKY5TAAENUCHqcRz
         N/VmS85DgfIEaGPlp6MiMCYPsXzCtJBfNXKNkH4E5wPcsqIyLGzBL9koEfrA7qUvZlp9
         OLibhcKYq4dRx7qUQesQ3cYLnPcKDGwHSwL39t1Hvz6QSaxhP+HHGvnRbbMi1U8cCmh7
         6Y4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GZjDxyMd9lYhUp+Y2lk0pT92jHBogv3cxfdr1gHkuyE=;
        fh=LDj00pRbFizTqdGxFoJeJ2UUHkXm6Tr++1pGw77IetY=;
        b=lUIs6aNISGXKO+DtNqpCSP9+tAqu4BZEOlJgfHnYDSLOk7eUKtuIwWizZ5hcULeWAb
         9R12sgieXQaLrSnN1q5x6QmwM6SGtYDcPIF27xnnOx9nF/SzMXNWCCvmruzHckPFV4yf
         Zw7qeNdYEcqgKb4294m86kn7vQJqwCGeC73vMXwi74l7ua52degZ1wZsEKCKQ/PpaMjX
         vrXA9GDAnqpJlv76s3NlhqH2TRzGPRPm71Dhodbwe+5C0IlmFwwMpWf12fnS4b9ZxVAc
         BDw73HNvir8JIa7foSBTNAjEGJAec2kfq4Pcs2dLRNYdIMMR28p7unOmZZXq7EHextc2
         49lA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784324896; x=1784929696; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GZjDxyMd9lYhUp+Y2lk0pT92jHBogv3cxfdr1gHkuyE=;
        b=pXf8Eyj09mAmVDmf9/D/oU6rwnXS3DXrCmAgYbcllxqHWloDIN5otfEN1/HYWGncu5
         KGNl8W/jKpbg4y+KXukBSmaOeXpce9XSj0/N88xLQwRuNGFvF3C4aAFyZeUKVJOiDeeg
         HB3yiXNBtpOIQHby+oqsEMR7nV5IBycmUrm84EYSarfghzAYvllj5mhJjse6w7u1IjrY
         bq10aNTKhzOV5j67Cy6fmbaBGzr37Ys453D5V07Kzb7eBLlZYMKgQgrHSsZDLRt83um4
         aqCxFolDcaaOeVAsTpcFfCef6aQEGS5+WrUURjf4EKYwvM5tcmeIvb3+9KF3+gM4uMaV
         IozA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784324896; x=1784929696;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GZjDxyMd9lYhUp+Y2lk0pT92jHBogv3cxfdr1gHkuyE=;
        b=mO3onfcIx6A2oj2KBgs56wjvNC98hv/utZq7FodHE8z+/+VF6UBbezhU984ff/pxbV
         lSJQft2Ml93/EpzgRIUPT7rQqRoVU7CcxljTN/TEBlZ/YVxK8ekHV9+WJcCOJiBYktJW
         AGhrg1NbZebX/qw8aPX66RTPtD5K7dhzkW5BNJ+c9IKi+RFI8HPfYBENQjkXQjkiHbx6
         T1CYtCxbnVvY2Dl7Ge4g+Nf4SLhpfx5VUdIKgQKSEPRps8E5B7uSkAQ/1uaBx4FNUpy5
         F+FMCSP8fFEXMnchQcYIbv10dXSilFzNb7qoIDqiq5yRDa7nMprl2kfumdU8qmb6qXVT
         s3og==
X-Forwarded-Encrypted: i=1; AHgh+Ro28Tr0KS6UaIVQ1CvcAMHAp4Mg+BOEzNs8opJX8wR//QSG8ejt+NocSX6nTQbKU51ypV9465pteXE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIKOfBEN87o4kli1s0jIpJaL07mdhO9IiwGqNmm688ohFlybhU
	gReFXQ4qTT57Waba9Pi0rN9Bo80LJ68cZeux43nhloZmDTOZEht27oHFgDpz+bEq4KT77N6f68D
	HD67RolISjnedsG8miL41An1d9DVWIGo=
X-Gm-Gg: AfdE7ckAd9pIkhwWosZZNJWwIiJtkxep5h29p5jqx4WqEAOEDi213ynSHXx2KchWnO+
	xiH+IqeIpL24IHtJ5u5VRFxPD14myNtusLvRyXc6tlO+1v4TWlkNY1qowkNECRGa4me51kwU6Ld
	+DRd0h57QaOZLxx8nNF9wcuCzsQ4O0QGG7GI2tnMEObDpCzIzugKd2wvq6/JEvrvUG/nGL/L6wQ
	GrnKRLHTxPC6C02T9DV2jWrcBKHaRijVpb3MSs04R0ExEYLIthu7FpF27K5ngERGzLO1YTvbaaM
	pVxFdNdFVb2er9J2jGo9TUUksJGSaF60EGnGR+2EpA==
X-Received: by 2002:a05:600c:b96:b0:495:4b00:1bab with SMTP id
 5b1f17b1804b1-4954b001c39mr45485455e9.21.1784324895791; Fri, 17 Jul 2026
 14:48:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-3-joannelkoong@gmail.com> <20260702164339.GI9392@frogsfrogsfrogs>
 <CAJnrk1ZRQaFseAnz3zm31oR3KmQWje5HDJjhNbAQSAQyK9_PMA@mail.gmail.com>
 <CAJnrk1bj4pLpAzLhehrbDJuKWa=WMq-3XOAm9dhsEVDF9WCBPQ@mail.gmail.com>
 <CAJnrk1YkAEUhjw6mNEx70ojN7UMQT__oHn5m1Ng2Lz7FoLRhrA@mail.gmail.com> <20260717175552.GT7380@frogsfrogsfrogs>
In-Reply-To: <20260717175552.GT7380@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 17 Jul 2026 14:48:03 -0700
X-Gm-Features: AUfX_mxuarmgCvMjpgrc3PqPzAefX6rjpJrhYlOJ5xPI1AmG7uUmKiouc0J-ti0
Message-ID: <CAJnrk1bjA+Y5V-87AhNGR5-ss7gUJWwLkjouwic1Mckd2QRH7Q@mail.gmail.com>
Subject: Re: [PATCH v2 02/18] xfs: convert iomap ops to ->iomap_next()
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: brauner@kernel.org, hch@lst.de, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 17, 2026 at 10:55=E2=80=AFAM Darrick J. Wong <djwong@kernel.org=
> wrote:
>
> On Fri, Jul 17, 2026 at 09:49:30AM -0700, Joanne Koong wrote:
> > On Thu, Jul 2, 2026 at 6:21=E2=80=AFPM Joanne Koong <joannelkoong@gmail=
.com> wrote:
> > >
> > > Ahh okay, I think I see the point you were trying to make. The
> > > callsite functions are like:
> > >
> > > ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter=
 *from,
> > >                 iomap_next_fn iomap_next,
> > >                 const struct iomap_write_ops *write_ops, void *privat=
e);
> > >
> > > int iomap_fsverity_write(struct file *file, loff_t pos, size_t length=
,
> > >                 const void *buf, iomap_next_fn iomap_next,
> > >                 const struct iomap_write_ops *write_ops);
> > >
> > > void iomap_read_folio(iomap_next_fn iomap_next,
> > >                 struct iomap_read_folio_ctx *ctx, void *private);
> > >
> > > void iomap_readahead(iomap_next_fn iomap_next,
> > >                 struct iomap_read_folio_ctx *ctx, void *private);
> > >
> > > etc, so it's not clear from the "iomap_next_fn iomap_next" naming tha=
t
> > > it handles per-iteration logic, whereas renaming it to "iomap_iter_fn
> > > iomap_iter" makes it more explicit. Am I interpreting this correctly?
> >
> > Going back to this... "iomap_iter_fn iomap_iter" doesn't feel quite
> > right. I think there's too much naming collision with iomap_iter() and
> > struct iomap_iter, and I like how in general ->next() matches the
> > orthodox naming scheme for advancing an iterator. I think
> > "iomap_iter_next_fn next" would be the best of both worlds - I'll
> > change it to this for v3. But if you don't agree with this, please let
> > me know.
>
> Fine by me :)
>
> --D
>
> >
> > Thanks,
> > Joanne
> >
> > >
> > > > > > +{
> > > > > > +     return iomap_process(iter, iomap, srcmap, xfs_direct_writ=
e_iomap_begin,
> > > > > > +                     NULL);
> > > > >
> > > > > But then "iomap_iter" sets up a new problem: should iomap_process=
 have a
> > > > > new name that goes along with that?  iomap_iter is already taken =
for the

I'm starting not to like "iomap_process()" either, it seems too vague...

I think it'd be better renamed to "iomap_iter_next()". The callsites
would then just look something like:

static int
xfs_read_iomap_next(
       const struct iomap_iter *iter,
       struct iomap            *iomap,
       struct iomap            *srcmap)
{
       return iomap_iter_next(iter, iomap, srcmap, xfs_read_iomap_begin, NU=
LL);
}

static int
xfs_seek_iomap_next(
       const struct iomap_iter *iter,
       struct iomap            *iomap,
       struct iomap            *srcmap)
{
       return iomap_iter_next(iter, iomap, srcmap, xfs_seek_iomap_begin, NU=
LL);
}

I'll make this change for v3. But if you don't like this, please let me kno=
w :)

Thanks,
Joanne

> > > > > legacy path.  If we were emulating python I'd suggest iomap_iter_=
yield
> > > > > but this is C so we get to reinvent everything from scratch so wh=
o
> > > > > knows.
> > > > >
> > > > > --D
> > > > >
> >
