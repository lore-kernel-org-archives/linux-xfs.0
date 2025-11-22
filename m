Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07D62D061C
	for <linux-xfs@vger.kernel.org>; Sat, 22 Nov 2025 07:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763794970; cv=none; b=HylpVuMlnqoYvqworqc9cfU11aimlqBh4jEw2bJ6LRsHf/CI+2+L0ujLDuupyIoSCmMS3nCRVn1tM8ilOa9aBiYg9Zt4KBREBjEwzq9DyrzrMcnzB2tr2+79e81rHnYAHmMsopSAysELgq7csSJEEJdDAbzn/ogWj7OLrDetbOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763794970; c=relaxed/simple;
	bh=3qML6mAdP3XOHu6CRgEfvtbrG4LVKi3a96yUcu5LMO4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pCLX62FbjC0yoV7M74PZ4xsKvWfACnoVfWtWCsrSMvwUqilKuN8PgvcsA1Zb1SwTceZYlKOMWKbWK/+fm8mj0SZ/k1e5y/K/4yhbOo/0RGXvXGEM/dzrKoO/KhrcFmSvqW5yxQyvO1wk2gVH+3TRc6Cp+OvOaAGFkSw19y1HPzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JAOMxhh9; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JAOMxhh9"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8b29ff9d18cso273370785a.3
        for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 23:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763794967; x=1764399767; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WLckKOB/6XWKdTlMPCvOWJYhseDg7RVjB2FyFDWqsDI=;
        b=JAOMxhh9kJLyZv1WOtnIB96WIL5gbExrB4vzocj1PttnoksXSzoylwX4IhmFHcnhNf
         RtqQHEFItnsnUykv3q4F10GMDNn4KTgVtYDnviZJeMiTIzUpy6xynA+NVW5e7v4GrL6e
         S0I5QHYsSe6q1JpNx6yOWLQIcrZUghawz+DuZiiRLolpnsqiwaZ5E82+lDth/Dtn83Xx
         JdC0MtWe746J+twJjE7he+1jZusWcVSarZ5FDtDAkjF9p9UhdJq3q7iYsvMZW3ejHsYs
         uZHgEquDp6RyXARv75BlcVkgzSJOlkQvpRhvvUfL6E2/3lauVrBZOBNtW9cv5Qq3GR33
         AtDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763794967; x=1764399767;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WLckKOB/6XWKdTlMPCvOWJYhseDg7RVjB2FyFDWqsDI=;
        b=bT8Gj/T9Qh27w4dGsWR0a2dbbvskEQDfp41CjuNXDVnloU8VC83uj4fWSFmG8EPAIk
         Ct959MmzREwWL0LQmRRMdW4KDo6WbIQDCCrfx8HtkGubEO66HiZ0AAW8kP8HcgRHRITz
         lJ94gRoyvhXrfhHTYRG8XG6M8TsZf8QImUGPDLM5gSVZEI/mfBMNMDjn2MuZ8CUzsTjg
         MuhMIj3qQhj7lD6NKlnmf7CYXSQnZwNVzBA2zMdFcLx/9apqJmMoYhpJhJcQSbglLUbq
         HF5RjHf4JfJPh0XBUGxI207GhlMfJpPmY/ZhdE/NP/r9us8pGrWjMgH7qgBtsMeWmPQ0
         yIDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlILq9Vl+Ue0F4C3MSIok5Goci/L+03Fp6Fim+bLtEOUUeFHaFcrS5HtrvlJU4OarP4BMza/4kMCw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHgvZj1kSEww9ElMWX1eccdXpurFYpHjnijDY/C5JhXIs9Z3NV
	x53URKGCeE6ycwfRS9NGrTOQx+sVVR/iVUd6r6WMP6adJDKkoB7zuc1dC4Ta1HdwwxF12anGxsF
	wtS4JWgdBc+f1ujjYd7+ANT65qFdWwGg=
X-Gm-Gg: ASbGncu3UVTH7oA5wjqsLsNOMPTOdvs9+AKqmt4zLzOZpWKGEjkAUogbHPg7A9Pl3Ct
	0Se7tdUd9tLKJuTfx3aE446M+pokK4Asmxq+duCTw9MQ7BRZO1VzwEjQGdv8pdL7rObTiNcOWZ3
	dXKCh77SM3D70vZKNId5VTIdVErbDGEopA6T3k5OynBAinMYnt5zGW5kss20UBeGBXJrBEZxNsn
	shGdAOeNfAg5DRF/ckoHyti69pkaZ7kJLkXznmrShgWCwAbfwQCA5535noTv0o0AHPXax0=
X-Google-Smtp-Source: AGHT+IEjcPOv6aPW6JO4Bb1jDowgVciSWSsWd+FNjyx3VBhgbx3Pj6ddYbo0M3Mtuw+ANHFx2AKfX0TCp1WB72JEhOk=
X-Received: by 2002:a05:620a:7106:b0:8b2:e5da:d316 with SMTP id
 af79cd13be357-8b33d48b7d4mr603659585a.87.1763794967475; Fri, 21 Nov 2025
 23:02:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <20251121081748.1443507-3-zhangshida@kylinos.cn> <CAHc6FU7eL6Xuoc5dYjm9pYLr=akDH6ETow_yNPR0JpLGcz8QWw@mail.gmail.com>
In-Reply-To: <CAHc6FU7eL6Xuoc5dYjm9pYLr=akDH6ETow_yNPR0JpLGcz8QWw@mail.gmail.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sat, 22 Nov 2025 15:02:11 +0800
X-Gm-Features: AWmQ_bnR6g2ivQ9YSC5w0bIwME61y28InS6FucoZ4PBrcXjaLHV0KwJ_bufirnM
Message-ID: <CANubcdXx8Lp1JsqG3ctAE2V6jpuvJL93UH+7yHaAFtdMjHdijw@mail.gmail.com>
Subject: Re: [PATCH 2/9] block: export bio_chain_and_submit
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-xfs@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Andreas Gruenbacher <agruenba@redhat.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=88=
22=E6=97=A5=E5=91=A8=E5=85=AD 01:12=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Nov 21, 2025 at 9:27=E2=80=AFAM zhangshida <starzhangzsd@gmail.co=
m> wrote:
> > From: Shida Zhang <zhangshida@kylinos.cn>
> >
> > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> > ---
> >  block/bio.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/block/bio.c b/block/bio.c
> > index 55c2c1a0020..a6912aa8d69 100644
> > --- a/block/bio.c
> > +++ b/block/bio.c
> > @@ -363,6 +363,7 @@ struct bio *bio_chain_and_submit(struct bio *prev, =
struct bio *new)
> >         }
> >         return new;
> >  }
> > +EXPORT_SYMBOL_GPL(bio_chain_and_submit);
> >
> >  struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
> >                 unsigned int nr_pages, blk_opf_t opf, gfp_t gfp)
> > --
> > 2.34.1
>
> Can this and the following patches please go in a separate patch
> queue? It's got nothing to do with the bug.
>

Should we necessarily separate it that way?
Currently, I am including all cleanups with the fix because it provides a r=
eason
to CC all related communities. That way, developers who are monitoring them
can help identify similar problems if someone asksfor help in the
future, provided
that is the correct analysis and fix.

Thanks,
Shida

> Thanks,
> Andreas
>
