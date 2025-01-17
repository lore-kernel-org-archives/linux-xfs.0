Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11411F9F55;
	Fri, 17 Jan 2025 13:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737120483; cv=none; b=oH/788VgTUg9uvuK6hnKYY0Rr0dh5F6AGlbGS097NdG3eoMKzkLkrsZ49v9hKu/zDoSCo8KviJPipUkHeTKQ5VQkPimEsipiBVY7MaFFDvEKwR520kpVuACqRiS8WnVCZLZFOmI90dl6rmfMVwSwF5E0uNqHKnWTFdPTcbEgBrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737120483; c=relaxed/simple;
	bh=MDRgyCYC+QZLDO7X6Fl9FOUuOkEWEdtma8wTYy36+tc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b78g4rrTTTR2z4wZrFl1eqhalqdUGl3blXGKweVc9796U5SjNgiB/9nXPZM7Ssd868BpBw6bHMjW7HlUI6sMIngfzRSu+REv4OUy2KY9MnNifADk+pKQBYg4mTOgcQobApSPMbiDx3C4WK1lZJphdRwExH4spin3RuO6ieGD8so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A45TTx1N; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A45TTx1N"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5db6921ad3dso3236193a12.2;
        Fri, 17 Jan 2025 05:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737120480; x=1737725280; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wfvAkRB13R52yZSgrIy5OPC9NG4d9UP7L5U1RGPvvrw=;
        b=A45TTx1NJCKA7r1Rlmdan0NRooTYIIZOs7crc3WKUUqZUp7/FC7w4mi3xIAhTNvenh
         fggCVFxgO3s0AAop9OlKBtqv7xoi15VkdJBrv6XZ+/zFwnyA+oK8ztbVjfJZ/yBM42tC
         t5Ia1UnIGCS/+777EHPxaPYE3aExkpCOmjXpzKk6vI3tfDHuYR9exPPtHbyHWCNQhG7j
         RYIXxbOnZcd0t7i5KtZfWdQqjONE+WmB8bRH0FNvC7CsHZSLFk49WMGP8+/lNrrHfxec
         HPX3jIL1ffBVpzbClsHYoASN5qKiQzqu0i8fX7VTOWgjiWkQ6rMbtt4aVlaAOzBoKaFN
         XIEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737120480; x=1737725280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wfvAkRB13R52yZSgrIy5OPC9NG4d9UP7L5U1RGPvvrw=;
        b=YAom5Xm5lJ3ae3q5LzZTZTZGUki6H2UbzHOdWbilMnW9TstgNMnuAY6DadpbzFE7GI
         q5hNLmntPWVkU9/vggvCqGlQz5wTCouC9c182GvJ3epKi0PprhS4qLX9Wrz7yy87wvjJ
         bU4TheNDaQkrDU811AIXAMfotc0pZPBzkrNbzmurWlCNLHfHQoJEA4IR+UKQRx+iWJzh
         /pfXC6ce75jfet5Wlw8rL5949cmu6LcUJppqawHhpWiH3UyLmR9sjOxZciiqgyud7G5m
         IKQnx8B8HT68Joi/fQXUm2ibnv9rG/EQxqM1d8RGch4p/Qxv9EEMGKOR7bcTsX7Wns8a
         s3sQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6d5AxkA6HgmHlK2qzqg7mH+G3xFladTHdel64CTsztFUb9urqu3dsnUgXannV5/BOdJQitCDAaMWc@vger.kernel.org, AJvYcCWmil6Qh9aVTcZjAqrwncR7YX5XtgyDMYP9VzlQDKzxPu3oD3hBLvYz+6wCEFVPF3gWrtHNdMxL/SEEXv0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbeNtWkFYuUtsMLuHm7KMT1uAigUBsXD6xa++dXavZlg3TXZu5
	VAQz2suGonb7SF+bD9OCKMCjjm490u+WaGe2mwxK9IY+4tUGtRCLAj8+2xT1UWY1Qzek4W+/Ctf
	fVRyDRgYFhor1TACwbtPzOno+2yJcmCK1DKg=
X-Gm-Gg: ASbGncsedwtpP42+i/UJ5ETKHLnIrcXDZupzg+JWmHOOYx72rEGtBTFiBf2HJFe2YtQ
	KyAKX5y1bCAGezO4alWetryMirqgBMficmO3w7g==
X-Google-Smtp-Source: AGHT+IEy8roQnL/aQrYpXWQT1Oa55B/HQuxux32mSXfBXZOWYq/LGsNZtQ5uO8nDb44FSSEc7wjUhqwKDO2c0ep827A=
X-Received: by 2002:a05:6402:3588:b0:5d0:8106:aaf4 with SMTP id
 4fb4d7f45d1cf-5db7d33fe72mr2184712a12.21.1737120479603; Fri, 17 Jan 2025
 05:27:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <24b1edfc-2b78-434d-825c-89708d9589b7@163.com> <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com> <20250108173547.GI1306365@frogsfrogsfrogs>
 <Z4BbmpgWn9lWUkp3@dread.disaster.area> <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
 <d99bb38f-8021-4851-a7ba-0480a61660e4@163.com> <20250113024401.GU1306365@frogsfrogsfrogs>
 <Z4UX4zyc8n8lGM16@bfoster> <Z4dNyZi8YyP3Uc_C@infradead.org> <Z4grgXw2iw0lgKqD@dread.disaster.area>
In-Reply-To: <Z4grgXw2iw0lgKqD@dread.disaster.area>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 17 Jan 2025 14:27:46 +0100
X-Gm-Features: AbW1kvbcvowqWGDXZOjyiQm8cpt-QxIMZJhxjxRtQoOaiQYuhi-XZrz3BxdLNzQ
Message-ID: <CAOQ4uxjRi9nagj4JVXMFoz0MXP_2YA=bgvoiDqStiHpFpK+tsQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Chi Zhiling <chizhiling@163.com>, cem@kernel.org, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chi Zhiling <chizhiling@kylinos.cn>, John Garry <john.g.garry@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 15, 2025 at 10:41=E2=80=AFPM Dave Chinner <david@fromorbit.com>=
 wrote:
>
> On Tue, Jan 14, 2025 at 09:55:21PM -0800, Christoph Hellwig wrote:
> > On Mon, Jan 13, 2025 at 08:40:51AM -0500, Brian Foster wrote:
> > > Sorry if this is out of left field as I haven't followed the discussi=
on
> > > closely, but I presumed one of the reasons Darrick and Christoph rais=
ed
> > > the idea of using the folio batch thing I'm playing around with on ze=
ro
> > > range for buffered writes would be to acquire and lock all targeted
> > > folios up front. If so, would that help with what you're trying to
> > > achieve here? (If not, nothing to see here, move along.. ;).
> >
> > I mostly thought about acquiring, as locking doesn't really have much
> > batching effects.  That being said, no that you got the idea in my mind
> > here's my early morning brainfart on it:
> >
> > Let's ignore DIRECT I/O for the first step.  In that case lookup /
> > allocation and locking all folios for write before copying data will
> > remove the need for i_rwsem in the read and write path.  In a way that
> > sounds perfect, and given that btrfs already does that (although in a
> > very convoluted way) we know it's possible.
>
> Yes, this seems like a sane, general approach to allowing concurrent
> buffered writes (and reads).
>
> > But direct I/O throws a big monkey wrench here as already mentioned by
> > others.  Now one interesting thing some file systems have done is
> > to serialize buffered against direct I/O, either by waiting for one
> > to finish, or by simply forcing buffered I/O when direct I/O would
> > conflict.
>
> Right. We really don't want to downgrade to buffered IO if we can
> help it, though.
>
> > It's easy to detect outstanding direct I/O using i_dio_count
> > so buffered I/O could wait for that, and downgrading to buffered I/O
> > (potentially using the new uncached mode from Jens) if there are any
> > pages on the mapping after the invalidation also sounds pretty doable.
>
> It's much harder to sanely serialise DIO against buffered writes
> this way, because i_dio_count only forms a submission barrier in
> conjunction with the i_rwsem being held exclusively. e.g. ongoing
> DIO would result in the buffered write being indefinitely delayed.

Isn't this already the case today with EX vs. SH iolock?
I guess the answer depends whether or not i_rwsem
starves existing writers in the face of ongoing new readers.
If my memory serves me right, this exact behavior of i_rwsem
is what sparked the original regression report when xfs
moved from i_iolock to i_rwsem [1].

[1] https://lore.kernel.org/linux-xfs/CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3J=
SeZR71S1dXg+2w@mail.gmail.com/

>
> I think the model and method that bcachefs uses is probably the best
> way to move forward - the "two-state exclusive shared" lock which it
> uses to do buffered vs direct exclusion is a simple, easy way to
> handle this problem. The same-state shared locking fast path is a
> single atomic cmpxchg operation, so it has neglible extra overhead
> compared to using a rwsem in the shared DIO fast path.
>
> The lock also has non-owner semantics, so DIO can take it during
> submission and then drop it during IO completion. This solves the
> problem we currently use the i_rwsem and
> inode_dio_{start,end/wait}() to solve (i.e. create a DIO submission
> barrier and waiting for all existing DIO to drain).
>
> IOWs, a two-state shared lock provides the mechanism to allow DIO
> to be done without holding the i_rwsem at all, as well as being able
> to elide two atomic operations per DIO to track in-flight DIOs.
>
> We'd get this whilst maintaining buffered/DIO coherency without
> adding any new overhead to the DIO path, and allow concurrent
> buffered reads and writes that have their atomicity defined by the
> batched folio locking strategy that Brian is working on...
>
> This only leaves DIO coherency issues with mmap() based IO as an
> issue, but that's a problem for a different day...
>
> > I don't really have time to turn this hand waving into, but maybe we
> > should think if it's worthwhile or if I'm missing something important.
>
> If people are OK with XFS moving to exclusive buffered or DIO
> submission model, then I can find some time to work on the
> converting the IO path locking to use a two-state shared lock in
> preparation for the batched folio stuff that will allow concurrent
> buffered writes...

I won't object to getting the best of all worlds, but I have to say,
upfront, this sounds a bit like premature optimization and for
a workload (mixed buffered/dio write) that I don't think anybody
does in practice and nobody should care how it performs.
Am I wrong?

For all practical purposes, we could maintain a counter in inode
not for submitted DIO, but for files opened O_DIRECT.

The first open O_DIRECT could serialize with in-flight
buffered writes holding a shared iolock and then buffered writes
could take SH vs. EX iolock depending on folio state and on
i_dio_open_count.

I would personally prefer a simple solution that is good enough
and has a higher likelihood for allocating the development, review
and testing resources that are needed to bring it to the finish line.

Thanks,
Amir.
