Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64C312AAC6
	for <linux-xfs@vger.kernel.org>; Fri, 13 Sep 2024 19:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726254013; cv=none; b=P4pU/Cj0Vf69DQkDv6lu0C/pDI2mp9koXsyF5IgAdG8RqoL9BgI43rOSePRnGPTzl88/tRY0JGrGHMzJj4ZquKQjpO/xhMmsAjelaA/4mDIQvSV7bGGaNETMlq28ONNdbvhHq5XgU+gOAVSUAmj/4IwU58BpkZtvMvVclN85E4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726254013; c=relaxed/simple;
	bh=f0/qHNroIZs6VOcePLiioAm+uTAbOHcEwWrIFuPphM8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pSm9ZD4IHMVh7/I0/3eh7s0bmYl37tXn2Eno0y872FoP8/kkdv/DSjLw4IMAPeLuup/DUTGRdw6JEuspoKHTaBPkZoFOCTIbo6MvuhzGJqmuoX+5o9aqyMmPwN9uj/1w9SWzu7STNxCD8TzC7vbg9/6ZCcbKuMNLYpAfc1mXlh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MNIqm060; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MNIqm060"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a8d2b24b7a8so653145866b.1
        for <linux-xfs@vger.kernel.org>; Fri, 13 Sep 2024 12:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726254009; x=1726858809; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cZf2aYMb8Zlk0CPpJeIXHbW7WWQiG41ie4dpVzhJSlI=;
        b=MNIqm060n/GP04KJLUWbp3Q+iu4zZRWCmq0y54/MKekUsC+Ii42LeNtOdBzkp5rnm7
         KiBnmcwGyPxRCE7XnG2ACKeZmT75ghd6wIbLgAS372GyAMmVxtIm7+PkOHmZQJQm2mCa
         shGmIInv5HS92o08HTLWXqfcQ9g/Ltu5PB8mu9DfwADtFWWizHF+rvcfQtdqykT60byO
         6yINcotfPoo1X8JROsCZa5KTn+Ls0bsyyEifR/rpwJb1MuKd2EJ4NBBaD0EtZRhG5q0B
         s9INIq1cMfT8n46zIFnsxJ4rY5bQ3Q0oTFN8PSAa87kDuM9nYhg7aILWvdDEDKDynC9C
         0jbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726254009; x=1726858809;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cZf2aYMb8Zlk0CPpJeIXHbW7WWQiG41ie4dpVzhJSlI=;
        b=SlHIiLLEsDK4cmcwDi+eu2y9zvrC5Me6nLBGrd0l4/TQmUye1oqNgBUHGqTGE1yTEP
         VOo6mqFGvvCCTQitsvawdCtMd4zOrT9U77L/pmC23J4sMplziOYCLPf47L/WZEJI7fB4
         CBzv1UnDn3YCU/Q0CzVDaLqV+4Yug1iF2oXnn4sBBKo1K54Q9DSe4nTCQ193BJdqt0R1
         btRFr/SyM0OzpShUISMkV+WojMLvxdp7ET9XcVDbvjgRHqFD+7yEGwM11vi7YD09iuMN
         fnyhvxdI9JbCdbLzg8HmYFY0j9lygkyiuYW2Fbx+CZlaBiDDPz/DAMRvbWqlxQORythH
         jx+g==
X-Forwarded-Encrypted: i=1; AJvYcCU1U5lhTOeYbROQw6HCEcXYX3w82E/eiNtRyASgo9Ts66SN8ej3TuddbXUI+nhHor+kGdFuNI9FBlY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAhbzutXMQgUw1G844s9V3kQB37+3+YLLHYL8Lr+HSYWwsSq4L
	U+zCfrzJ30qbgFm14bYEbtTj1sEeNhkj2bYXE58KNs+tHsg3SHTANFA8tWyFMY94Iw+0JOzlDIH
	7v7tXojbjMkRMucMWnDyrRNGW1HMKZmSjIm8=
X-Google-Smtp-Source: AGHT+IHcpW0D1DrK3lVMKL+Vimy/qbLz1ntvEPc5JnGQtAjSuYw2dvEcnvfRgLvohNaDJWzygVp9zoxdzZKfoDHquNE=
X-Received: by 2002:a17:906:c10b:b0:a86:8f9b:ef6e with SMTP id
 a640c23a62f3a-a902a438f77mr781205166b.13.1726254007768; Fri, 13 Sep 2024
 12:00:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240913-mgtime-v7-0-92d4020e3b00@kernel.org> <20240913-mgtime-v7-1-92d4020e3b00@kernel.org>
In-Reply-To: <20240913-mgtime-v7-1-92d4020e3b00@kernel.org>
From: John Stultz <jstultz@google.com>
Date: Fri, 13 Sep 2024 11:59:56 -0700
Message-ID: <CANDhNCof7+q+-XzQoP=w0pcrS_-ifH9pmAmtq8H++tbognBv1A@mail.gmail.com>
Subject: Re: [PATCH v7 01/11] timekeeping: move multigrain timestamp floor
 handling into timekeeper
To: Jeff Layton <jlayton@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Stephen Boyd <sboyd@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, 
	Chandan Babu R <chandan.babu@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Chris Mason <clm@fb.com>, 
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Vadim Fedorenko <vadim.fedorenko@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 13, 2024 at 6:54=E2=80=AFAM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> For multigrain timestamps, we must keep track of the latest timestamp
> that has ever been handed out, and never hand out a coarse time below
> that value.
>
> Add a static singleton atomic64_t into timekeeper.c that we can use to
> keep track of the latest fine-grained time ever handed out. This is

Maybe drop "ever" and  add "handed out through a specific interface",
as timestamps can be accessed in a lot of ways that don't keep track
of what was returned.


> tracked as a monotonic ktime_t value to ensure that it isn't affected by
> clock jumps.
>
> Add two new public interfaces:
>
> - ktime_get_coarse_real_ts64_mg() fills a timespec64 with the later of th=
e
>   coarse-grained clock and the floor time
>
> - ktime_get_real_ts64_mg() gets the fine-grained clock value, and tries
>   to swap it into the floor. A timespec64 is filled with the result.
>
> Since the floor is global, we take great pains to avoid updating it
> unless it's absolutely necessary. If we do the cmpxchg and find that the
> value has been updated since we fetched it, then we discard the
> fine-grained time that was fetched in favor of the recent update.
>
> To maximize the window of this occurring when multiple tasks are racing
> to update the floor, ktime_get_coarse_real_ts64_mg returns a cookie
> value that represents the state of the floor tracking word, and
> ktime_get_real_ts64_mg accepts a cookie value that it uses as the "old"
> value when calling cmpxchg().
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  include/linux/timekeeping.h |  4 +++
>  kernel/time/timekeeping.c   | 81 +++++++++++++++++++++++++++++++++++++++=
++++++
>  2 files changed, 85 insertions(+)
>
> diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
> index fc12a9ba2c88..cf2293158c65 100644
> --- a/include/linux/timekeeping.h
> +++ b/include/linux/timekeeping.h
> @@ -45,6 +45,10 @@ extern void ktime_get_real_ts64(struct timespec64 *tv)=
;
>  extern void ktime_get_coarse_ts64(struct timespec64 *ts);
>  extern void ktime_get_coarse_real_ts64(struct timespec64 *ts);
>
> +/* Multigrain timestamp interfaces */
> +extern u64 ktime_get_coarse_real_ts64_mg(struct timespec64 *ts);
> +extern void ktime_get_real_ts64_mg(struct timespec64 *ts, u64 cookie);
> +
>  void getboottime64(struct timespec64 *ts);
>
>  /*
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 5391e4167d60..ee11006a224f 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -114,6 +114,13 @@ static struct tk_fast tk_fast_raw  ____cacheline_ali=
gned =3D {
>         .base[1] =3D FAST_TK_INIT,
>  };
>
> +/*
> + * This represents the latest fine-grained time that we have handed out =
as a
> + * timestamp on the system. Tracked as a monotonic ktime_t, and converte=
d to the
> + * realtime clock on an as-needed basis.
> + */
> +static __cacheline_aligned_in_smp atomic64_t mg_floor;
> +
>  static inline void tk_normalize_xtime(struct timekeeper *tk)
>  {
>         while (tk->tkr_mono.xtime_nsec >=3D ((u64)NSEC_PER_SEC << tk->tkr=
_mono.shift)) {
> @@ -2394,6 +2401,80 @@ void ktime_get_coarse_real_ts64(struct timespec64 =
*ts)
>  }
>  EXPORT_SYMBOL(ktime_get_coarse_real_ts64);
>
> +/**
> + * ktime_get_coarse_real_ts64_mg - get later of coarse grained time or f=
loor
> + * @ts: timespec64 to be filled
> + *
> + * Adjust floor to realtime and compare it to the coarse time. Fill
> + * @ts with the latest one. Returns opaque cookie suitable for passing
> + * to ktime_get_real_ts64_mg().
> + */
> +u64 ktime_get_coarse_real_ts64_mg(struct timespec64 *ts)
> +{
> +       struct timekeeper *tk =3D &tk_core.timekeeper;
> +       u64 floor =3D atomic64_read(&mg_floor);
> +       ktime_t f_real, offset, coarse;
> +       unsigned int seq;
> +
> +       WARN_ON(timekeeping_suspended);
> +
> +       do {
> +               seq =3D read_seqcount_begin(&tk_core.seq);
> +               *ts =3D tk_xtime(tk);
> +               offset =3D *offsets[TK_OFFS_REAL];
> +       } while (read_seqcount_retry(&tk_core.seq, seq));
> +
> +       coarse =3D timespec64_to_ktime(*ts);
> +       f_real =3D ktime_add(floor, offset);
> +       if (ktime_after(f_real, coarse))
> +               *ts =3D ktime_to_timespec64(f_real);
> +       return floor;
> +}
> +EXPORT_SYMBOL_GPL(ktime_get_coarse_real_ts64_mg);
> +
> +/**
> + * ktime_get_real_ts64_mg - attempt to update floor value and return res=
ult
> + * @ts:                pointer to the timespec to be set
> + * @cookie:    opaque cookie from earlier call to ktime_get_coarse_real_=
ts64_mg()
> + *
> + * Get a current monotonic fine-grained time value and attempt to swap
> + * it into the floor using @cookie as the "old" value. @ts will be
> + * filled with the resulting floor value, regardless of the outcome of
> + * the swap.

I'd add more detail here to clarify that this can return a coarse
floor value if the cookie is stale.

> +void ktime_get_real_ts64_mg(struct timespec64 *ts, u64 cookie)
> +{
> +       struct timekeeper *tk =3D &tk_core.timekeeper;
> +       ktime_t offset, mono, old =3D (ktime_t)cookie;
> +       unsigned int seq;
> +       u64 nsecs;
> +
> +       WARN_ON(timekeeping_suspended);
> +
> +       do {
> +               seq =3D read_seqcount_begin(&tk_core.seq);
> +
> +               ts->tv_sec =3D tk->xtime_sec;
> +               mono =3D tk->tkr_mono.base;
> +               nsecs =3D timekeeping_get_ns(&tk->tkr_mono);
> +               offset =3D *offsets[TK_OFFS_REAL];
> +       } while (read_seqcount_retry(&tk_core.seq, seq));
> +
> +       mono =3D ktime_add_ns(mono, nsecs);
> +
> +       if (atomic64_try_cmpxchg(&mg_floor, &old, mono)) {
> +               ts->tv_nsec =3D 0;
> +               timespec64_add_ns(ts, nsecs);
> +       } else {
> +               /*
> +                * Something has changed mg_floor since "old" was
> +                * fetched. That value is just as valid, so accept it.
> +                */

Mostly because I embarrassingly tripped over this in front of
everyone, I might suggest:
/*
 * mg_floor was updated since the cookie was fetched, so the
 * the try_cmpxchg failed. However try_cmpxchg updated old
 * with the current mg_floor, so use that to return the current
 * coarse floor value
 */

:)

thanks
-john
