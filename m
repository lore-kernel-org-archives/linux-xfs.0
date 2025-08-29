Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF78E1DED40
	for <linux-xfs@vger.kernel.org>; Fri, 29 Aug 2025 04:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756441606; cv=none; b=WesrH4tEOFiN98z9f7AkXXK/zSVd68YF2VHwIll94JoSxK6rSJ2bCKyWLmaPGfmJreANtzZ44KbEiiQUAeu7hi1BILsUB5XT89DEYbabIMXGUOn7xBS9VY2esug3jW91E9ggKfz8UsP8pQsIHEfZTKEQLNBqUx3rn4VDFKmWsQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756441606; c=relaxed/simple;
	bh=EkoqvOV7dM9ZRk2hSBU1HXFUVM807mm71e5eGg2wvoo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R+hffH6io1VX62ERdvNBq231pZ2ViqK5KJ+NxBOhLh+tW2VEL6bPx1TDuMC5XredvbJc519KJOZ9qApdUJOiTi9yAwrAKUb3JKqpNYcXjOJq7NY3TkCJbyuoSMlQvXPysQUFX3ca8v/OVaww7DQggQMThSpALm6UO+Y1PLQWR+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=OZ5TIwwd; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="OZ5TIwwd"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-30cce5da315so602738fac.0
        for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 21:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756441604; x=1757046404; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l4MHI2CvzdDIWL3MJRQiUQ6XLwUHQ6bTI5Rtl+9YzQg=;
        b=OZ5TIwwde2XCSgywHqXxL9EyplG/SdEgMoVpwcIdVyD/4Wdph/5NuCtnxRrjaPMCNC
         RmwEC1rVx3DVbjjKlbYJAJd4ANU3L0hVooRUunJC6LIzYOkIF8nEyBUSNRp4jcrdAiwv
         3zO6rNjjvFgm3DQlY951+5xjpup9rbV10PtCBWFOHLZcIlMf82MDq0oDlJz7/ikKVamW
         2Lhc/CH4IcjyyekJKmnAoMnd8pG91Pu3VYcAUgBY11K0G/QfaT+aggHcyD0xUt/pAauu
         +Je751c74gOcKlXOTzUi0nwYS79194W8Rn07HCfAKs+q72iYtNZSIvnsRild/0yX1B7b
         N/6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756441604; x=1757046404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l4MHI2CvzdDIWL3MJRQiUQ6XLwUHQ6bTI5Rtl+9YzQg=;
        b=Vqea0WmJf0MWQ7bJO5MTSZf6WgvrlVfHRRAvXFXoDZa3SxtnW0+7o12v6oUMcHVXoD
         y1HbytuFjEnYAsBy8gcRFKT+RjmXjr+Bok6NHqAhifmxDDoXKppPzyfFCRsub9i9m63L
         h9j483pmqIdIKgv/jSx2AQkJz+GiiTq8dNaXuAtkp39QVZnrcsxNSTBEwnTFUvELCV5U
         kJc2fKEHyIM2daIlAyaW9T/9hkSH43bFsciLCT62aUitsGf+1ab0TQKOww3xuhe0qvrf
         QmCDvZdVQRxutmX572v/8ZKlI8QVPW51qbtOKbsn2vaK1GhkICIKnYMnHlSWkdUZM8EY
         gOrg==
X-Forwarded-Encrypted: i=1; AJvYcCUbKdIHn+QiEtRzWAVx3gil6z2eyGDqhn6vHWZND6KjGz5PZVPIXV/ylFFGvBlH9valglejWxrXnFw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyhaawy5YaHYIdhCs6Gj//z43MabxjB2l8B6OLCzVS2pzshx1jX
	lMxVEmdYuOdf2sv+71rXldFHCvcAKP9ozt48YxLHC1jF4qxYFEPlYpwUk7C3cYder046IqdLPVX
	Nx5zujhpxN4/t6jOXskOwi3JunwXlEqVBQX6kOAKm7A==
X-Gm-Gg: ASbGncuyuy++kp3sxtOoIkjSLPEOfSzpp9is67b2HTtHrFASQ0T6/jMz6RKUhd7gO1n
	9TKqMbcaquESgJf/8andvWucNBrf3i0+u6RfvNBmFIA9HkNlwUwwhY869INzI+pR372VnlM2jf9
	5nYFi+89DmPvHBFn1Dcujwzl50ucDnsks0HDw+gFIL2+1rTKWqiurGWrwErZ93FbMz3/ga/pvOg
	MFfcz8KfGRsR9rBjJUo
X-Google-Smtp-Source: AGHT+IFf4FjrlA+yJNoGwfHCxy5AzxXYoQmbOwMzox76J9uWS3VmXyQrRB8vf/VsxwQIM47CtDWnG0sD/EIc57wMe1I=
X-Received: by 2002:a05:6808:640b:b0:437:e919:7c69 with SMTP id
 5614622812f47-437e9198366mr694154b6e.28.1756441598826; Thu, 28 Aug 2025
 21:26:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250822082606.66375-1-changfengnan@bytedance.com>
 <20250822150550.GP7942@frogsfrogsfrogs> <aKiP966iRv5gEBwm@casper.infradead.org>
 <877byv9w6z.fsf@gmail.com> <aKif_644529sRXhN@casper.infradead.org>
 <874ityad1d.fsf@gmail.com> <CAPFOzZufTPCT_56-7LCc6oGHYiaPixix30yFNEsiFfN1s9ySMQ@mail.gmail.com>
 <aKwq_QoiEvtK89vY@infradead.org> <CAPFOzZvBvHWHUwNLnH+Ss90OMdu91oZsSD0D7_ncjVh0pF29rQ@mail.gmail.com>
 <878qj6qb2m.fsf@gmail.com>
In-Reply-To: <878qj6qb2m.fsf@gmail.com>
From: Fengnan Chang <changfengnan@bytedance.com>
Date: Fri, 29 Aug 2025 12:26:27 +0800
X-Gm-Features: Ac12FXzlKhRKFlcX7iMwV0JQwPE6st56qbCxyRHYK6cyh9oqTXOg70UqWcq9vqw
Message-ID: <CAPFOzZuLQK-2fKHsy79MyeKeUSNRU2YR-o48w4Qj1rfLAMcR4A@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] iomap: allow iomap using the per-cpu bio cache
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, "Darrick J. Wong" <djwong@kernel.org>, brauner@kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, 
	Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry, Need to wait a few more days for this, too busy recently.

Ritesh Harjani <ritesh.list@gmail.com> =E4=BA=8E2025=E5=B9=B48=E6=9C=8827=
=E6=97=A5=E5=91=A8=E4=B8=89 01:26=E5=86=99=E9=81=93=EF=BC=9A
>
> Fengnan Chang <changfengnan@bytedance.com> writes:
>
> > Christoph Hellwig <hch@infradead.org> =E4=BA=8E2025=E5=B9=B48=E6=9C=882=
5=E6=97=A5=E5=91=A8=E4=B8=80 17:21=E5=86=99=E9=81=93=EF=BC=9A
> >>
> >> On Mon, Aug 25, 2025 at 04:51:27PM +0800, Fengnan Chang wrote:
> >> > No restrictions for now, I think we can enable this by default.
> >> > Maybe better solution is modify in bio.c?  Let me do some test first=
.
>
> If there are other implications to consider, for using per-cpu bio cache
> by default, then maybe we can first get the optimizations for iomap in
> for at least REQ_ALLOC_CACHE users and later work on to see if this
> can be enabled by default for other users too.
> Unless someone else thinks otherwise.
>
> Why I am thinking this is - due to limited per-cpu bio cache if everyone
> uses it for their bio submission, we may not get the best performance
> where needed. So that might require us to come up with a different
> approach.
>
> >>
> >> Any kind of numbers you see where this makes a different, including
> >> the workloads would also be very valuable here.
> > I'm test random direct read performance on  io_uring+ext4, and try
> > compare to io_uring+ raw blkdev,  io_uring+ext4 is quite poor, I'm try =
to
> > improve this, I found ext4 is quite different with blkdev when run
> > bio_alloc_bioset. It's beacuse blkdev ext4  use percpu bio cache, but e=
xt4
> > path not. So I make this modify.
>
> I am assuming you meant to say - DIO with iouring+raw_blkdev uses
> per-cpu bio cache where as iouring+(ext4/xfs) does not use it.
> Hence you added this patch which will enable the use of it - which
> should also improve the performance of iouring+(ext4/xfs).
>
> That make sense to me.
>
> > My test command is:
> > /fio/t/io_uring -p0 -d128 -b4096 -s1 -c1 -F1 -B1 -R1 -X1 -n1 -P1 -t0
> > /data01/testfile
> > Without this patch:
> > BW is 1950MB
> > with this patch
> > BW is 2001MB.
>
> Ok. That's around 2.6% improvement.. Is that what you were expecting to
> see too? Is that because you were testing with -p0 (non-polled I/O)?
>
> Looking at the numbers here [1] & [2], I was hoping this could give
> maybe around 5-6% improvement ;)
>
> [1]: https://lore.kernel.org/io-uring/cover.1666347703.git.asml.silence@g=
mail.com/
> [2]: https://lore.kernel.org/all/20220806152004.382170-3-axboe@kernel.dk/
>
>
> -ritesh
