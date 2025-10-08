Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E7F25DB1D
	for <linux-xfs@vger.kernel.org>; Wed,  8 Oct 2025 21:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759960292; cv=none; b=Z8kl0yXic1g7rlMEGrwVRelcHOvLFYYJgWYekZfzaU4D0t+Hg3IXFMMx+ZC6XvuJyfF1AprR6CLVI86/e3hM+0/ILgHQcmTmcVEoNmlXP1gw/rqtoEPXG5TSpmfTznAiNltrLv9vWQ/IvYcrTbI3vt3F/dgAugckkKxlIG0CxiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759960292; c=relaxed/simple;
	bh=YeSJV0cgcfmVCZvTRZDCbdnFcadUzWJbFbg45MrXN/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KhDufsMGq+530h2k+riIogB/DagJXCYZfdLZeSstDvm44kWBz5Haf+9F5lC+In7JF3KPHzDfSWtUJKSiGlff5EClThDoA+cNevSyc87OcS0o1B3nkQhijwMe4AienqMIC+Pr/p9A4VBUubpb72enVM/thwmEWEyNFsmHL16s8OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b=Q47k7pVW; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b="Q47k7pVW"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5818de29d15so380675e87.2
        for <linux-xfs@vger.kernel.org>; Wed, 08 Oct 2025 14:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1759960288; x=1760565088; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UODmqZKtdL3EMBNUY6ATgtpUWaz8jDceHaQiabSgito=;
        b=Q47k7pVWZ/15oEIi65DrlF2qic/CccxVX9rfn/up0AtXoZURXigbdr6rOKkNOBuSuM
         8Nw6UhUB/7UpexjTeyK2AQplSUrhxLsILF/TFGEaqUms2LdiqcPssg5UdSKnOQpmoOuS
         /jNy3jytXKeGSWOTdNv8I8/FMXcD/pcdrtxDnJYG0xNo9UG4xFfDvQFcJ56G8wj3BLFh
         8AgWB+flnhL6sbblN2EBv/TtGe9Yz5/bElQh5MQ2JtLCiCGZOzO+7YEOyMR3YtCjl16C
         OwhV/kZZVEpJu5ZBwDXCWshB8FmLQ9uAVQZ5ir+Cv8gn5pcsW00QiAYU5LxWlXaANDFC
         i2Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759960288; x=1760565088;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UODmqZKtdL3EMBNUY6ATgtpUWaz8jDceHaQiabSgito=;
        b=LNMbxUrM16wEup9lmCLuycBFMsjet/5+/8LpK4h50iGBd85kkc3AAzVv8TNNPeoF5v
         bOx38AqFVAV8QC2kSe2AI6rnNWtGc37rd6YLspH6ZWFKK/5iecZ4ECCfmwnagKhvTPDJ
         9OVA17R96X5RThBoZ7Xjq1bZsyt0EOa8kHCzDvngc4eTk6eQCI12ABvkL+hXdjz80gto
         d65npE2yN12ub0P+X+gmIy96Mk+XN5I+O+k6oywbLZxhE4gXxHGhzJKHwbPlgIG/0wkt
         Xemck82EUlYyj4L21dImap5ackt4LlRj1qC7ac6WOZ5rqwhy8ujj3v1t8HzyNpKUovTw
         JpSA==
X-Forwarded-Encrypted: i=1; AJvYcCVuq8vqV6C167CEAjn0TJD1YX1xBaWLTFMH22l/qKmAyRe70QtBBDCyYdKpHnTPgWvAjTN+oAOymnY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7zaM3Vo+wL5CaPPsoz8Fnp+JQc9xkWoUqp9RpNfRfXV+dMHgp
	K0iyuxuWKGq1Jf9vj35Tx5F8pA1tfp5Pc9dGC9kZLZQ8r3KuZje55/4dbWGL8FpO6yB6k2iC8Xk
	QO2rUJB/ZrHX835PpgqKoTzH0eMvOUO5WdqYHm/ka
X-Gm-Gg: ASbGncvf0zwE2bW0vjhAnu7QItqWBSqHDaoyaahXAPFa0TmsHQuH4mmWLzItPE2sI8w
	+Gsy3sH1xrXQtu/ADaJySThL1jbvU1QFMAFNk9g+MXILRIerdKBwb6Rb5adpxyCvSQ/BRs5/9LW
	6sZmzIstZkDN3WcVG3TbMK+2MR0BKlCBczbqJQT8+Ko7NB3dMBhHG3dT00mgdtTso7StAKAKBQM
	On08RFMN6CvKL5IF84iosazbzLevg==
X-Google-Smtp-Source: AGHT+IE04F6FHlysgOP0ikswtIrH8NUBw+D+tzXQPxcJCD1TnnlVxuJvk8AHLWSGYH7XWYJI32umqtC0L689azMpm/8=
X-Received: by 2002:a05:6512:b10:b0:577:9ee:7d57 with SMTP id
 2adb3069b0e04-5906de88ee4mr1339839e87.46.1759960287865; Wed, 08 Oct 2025
 14:51:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251003093213.52624-1-xemul@scylladb.com> <aOCiCkFUOBWV_1yY@infradead.org>
 <CALCETrVsD6Z42gO7S-oAbweN5OwV1OLqxztBkB58goSzccSZKw@mail.gmail.com>
 <aOSgXXzvuq5YDj7q@infradead.org> <CALCETrW3iQWQTdMbB52R4=GztfuFYvN_8p52H1fopdS8uExQWg@mail.gmail.com>
 <aObXUBCtp4p83QzS@dread.disaster.area>
In-Reply-To: <aObXUBCtp4p83QzS@dread.disaster.area>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 8 Oct 2025 14:51:14 -0700
X-Gm-Features: AS18NWCCZIvRbnEEZ_rcIrJP-lPqVtVRjM0R9vfOD1pzOtMxDgMCVY5rfRLuDmg
Message-ID: <CALCETrX-cs5MH3k369q2Fk5Q-pYQfEV6CW3va-4E9vD1CoCaGA@mail.gmail.com>
Subject: Re: [PATCH] fs: Propagate FMODE_NOCMTIME flag to user-facing O_NOCMTIME
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Pavel Emelyanov <xemul@scylladb.com>, linux-fsdevel@vger.kernel.org, 
	"Raphael S . Carvalho" <raphaelsc@scylladb.com>, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 8, 2025 at 2:27=E2=80=AFPM Dave Chinner <david@fromorbit.com> w=
rote:
>
> On Wed, Oct 08, 2025 at 08:22:35AM -0700, Andy Lutomirski wrote:
> > On Mon, Oct 6, 2025 at 10:08=E2=80=AFPM Christoph Hellwig <hch@infradea=
d.org> wrote:
> > >
> > > On Sat, Oct 04, 2025 at 09:08:05AM -0700, Andy Lutomirski wrote:

>
> You are conflating "synchronous update" with "blocking".
>
> Avoiding the need for synchronous timestamp updates is exactly what
> the lazytime mount option provides. i.e. lazytime degrades immediate
> consistency requirements to eventual consistency similar to how the
> default relatime behaviour defers atime updates for eventual
> writeback.
>
> IOWs, we've already largely addressed the synchronous c/mtime update
> problem but what we haven't done is made timestamp updates
> fully support non-blocking caller semantics. That's a separate
> problem...

I'm probably missing something, but is this really different?  Either
the mtime update can block or it can't block.  I haven't dug all the
way into exactly what happens in __mark_inode_dirty(), but there is a
lot going on in there even in the I_DIRTY_TIME path.  And Pavel is
saying that AIO and mtime updates don't play along well.

>
> > and it does so before updating the file contents
> > (although the window during which the timestamp is updated and the
> > contents are not is not as absurdly long as it is in the mmap case).
> >
> > Now my series does not change any of this, but I'm thinking more of
> > the concept: instead of doing file/inode_update_time when a file is
> > logically written (in write_iter, page_mkwrite, etc), set a flag so
> > that the writeback code knows that the timestamp needs updating.
>
> This is exactly what lazytime implements with the I_DIRTY_FLAG.
>
> During writeback, if the filesystem has to modify other metadata in
> the inode (e.g. block allocation), the filesystem will piggyback the
> persistent update of the dirty timestamps on that modification and
> clear the I_DIRTY_TIME flag.
>
> However, if the writeback operation is a pure overwrite, then there
> is no metadata modifiction occuring and so we leave the inode
> I_DIRTY_TIME dirty for a future metadata persistence operation to
> clean them.
>
> IOWs, with lazytime, writeback already persists timestamp updates
> when appropriate for best performance.

I'm probably doing a bad job explaining myself.

In my series, I move (for page_mkwrite only) the mtime update,
*including dirtying the inode* to the writeback path, which makes it
fully non-blocking / asynchronous / whatever you want to call it at
the time that page_mkwrite is called.  More concretely, my suggestion
is to be a bit lazier than current lazytime and not dirty the inode
*at all* in write_iter, or at least not dirty it for the purpose of
timestamp updates.  Instead set a flag somewhere that it cannot be
forgotten about -- in my series, it's this patch:

https://lore.kernel.org/all/f2ac22142b4634b55ff6858d159b45dac96f81b6.137719=
3658.git.luto@amacapital.net/

and it's a single atomic bit in struct address_space.  The idea is
that there is approximately no additional overhead at the time that
the page cache is dirtied for cmtime-related inode dirtying and that
all such overhead is deferred to the writeback path when it's as
asynchronous as possible from the perspective of whatever user code
dirtied the page cache.  My page_set_cmtime() is completely lockless.

My series is far from perfect, but I did test it with real workloads
12-ish years ago, on overworked HDDs, with latencytop, and it worked.
Performance was vastly improved (using mmap, not write(), obviously).

>
> > Thinking out loud, to handle both write_iter and mmap, there might
> > need to be two bits: one saying "the timestamp needs to be updated"
> > and another saying "the timestamp has been updated in the in-memory
> > inode, but the inode hasn't been dirtied yet".
>
> The flag that implements the latter is called I_DIRTY_TIME. We have
> not implemented the former as that's a userspace visible change of
> behaviour.

Maybe that change should be done?  Or not -- it wouldn't be terribly
hard to have a pair of atomic timestamps in struct inode indicating
what timestamps we want to write the next time we get around to it.
(Concretely, page_set_cmtime() would get some new parameters to
specify actual times, and atomic compare exchange would be used to
update the underlying data structure, so it would remain lock-free but
not be wait-free.)
