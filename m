Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8341F15442D;
	Sat, 18 Jan 2025 13:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737205437; cv=none; b=R32krSgnWalehoPjmhpnfioGCkZjaNn5XxLmLdtcoj6Az7LJT6CW3LNVS3NpD3IYOXZNzE8BEP9240Xl9+exL7s8Xhh5jVIElMEWX40RsIHCn7Jv0kwalCQLdZL6J+D13BLsv5H1rWPmi+VvCrMJCULL3H5wOqUosoeU4k0Sd1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737205437; c=relaxed/simple;
	bh=5aKDrdc822kTUEmzAN+y5K41wuWG59TLFzZYqCocWBY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pvhrRwk4FKxmE4VVg9ihM+N2S1/yxMxz+REc4FJyFMQ9RyFYRvn32bv9PyATo3eM+r5t6qHasvj7GbjJwgi8OM0qGUSKzaPeSuVQ+iSWyeVQ/PMHUlLT3QNdl86lcq5ollP7NNTHX1N03EVTyfGXyZJm43r1DRoasFAF4TXwp+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IlqYAmmC; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IlqYAmmC"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aaedd529ba1so397042566b.1;
        Sat, 18 Jan 2025 05:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737205434; x=1737810234; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=21u8ZLqHUehTvlN9ptxl1pY8HJZGf5/SxBCODiMfSL0=;
        b=IlqYAmmCb8+PkaQCPdrYQfEL5WsSxxC9/4y/GnD9rj9pZWSOJ2BWiCkMoq7vIM1AqI
         qyyOTY/EMT5a4iYz+nKOhVgx0qLxzOv7l+AWhAydTftQ7c2z3+vVQQeOvQZyU0iwQsJt
         D51IphDST0zcMJt6GbBw4wBHJD5Wla3YwBAxt7Gtd4GCvw8Tb8d8Dno/uDcGllU9k8e+
         RChAGwtDlNlWNkslU8olokRo+SfZA8LmOzAsUxA8denTnrt7GnFtDa9cFNIJrS0sJgCX
         mc/e90gwmLH35IXqGpbWTGWDWGhVCVKoESDOQ+4wRx08nhSDc62cuUs31+PnJWTRnVyv
         vnLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737205434; x=1737810234;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=21u8ZLqHUehTvlN9ptxl1pY8HJZGf5/SxBCODiMfSL0=;
        b=FTx7vYBHkUdYO+OmgI+bpAMI7u7WexfyZUG4MwA46dZqwO6MbQsO9+Rs5wsSUEP6On
         OxapQ5mm3zYSWhNCD66ev78Xl1tkHsJxYwTBlSdH7dXyzNzxgY7vALFygHsoSyQzFMbB
         3EzsGXljBA2GalIJqF1TDwqU1dyrTUm36qS99uBceEsRzuYpWiIHlHwGUhyW/4jiXit1
         Coyz1Dq7AF+tNy94LoS75j3MQshEMlU9rGnHFKt6jbm+eC40L+EtLAJenahkSgwOlMTI
         uzjH4LiewPSID3Z6P7vPItW5KxTbfta0zK9cgz+aoA/u9j4PoBy1m49WhHx0/8lyf87d
         Aj4w==
X-Forwarded-Encrypted: i=1; AJvYcCV1yss53F+RCiv2eymTQvEo3dskZarMpAI5OJdm1hWfQec1L9wI6oZIvq9chmyZlf1IqsFplylOy0UHM+Y=@vger.kernel.org, AJvYcCVj5KYa7wzNKVW6b5acx6YO8G8VQCiS/bqsu3gCnjiEMCoUeW+vOMKYO8JfhWlco8X6NaiYv3jbPkng@vger.kernel.org
X-Gm-Message-State: AOJu0YyIwRsXnSnnw0ppeC7vZHYu+w3sQu+bv7frHQfvGWBVGmDcH7X1
	qHcZnSclP57G2H5fBiaAQK+w4eKc/USXorNVy/FRtb2AmHLQxU74Q/F97G4haM7LXlII+gyPoqH
	gH6Gxz6yeaiYr2qlAlE61Je8/5qE=
X-Gm-Gg: ASbGncuElF7FObhujnhdDtg1QpS6atrlh+lfWE3aSEblnbmm+TlC5M9TeMqZnYluCfm
	BtkBbI/cwKqhDLN+zBm0gTGC4oEFd/WonirR2Imd1z+O3kWAHBIo=
X-Google-Smtp-Source: AGHT+IFjPExWJUSy6XPhdKxFhoTDU2+9C2zax2nTiinkrY77ome+5VzMKDP0qPHGwzsRoUuATfrEiDB4W8asIbs8qC8=
X-Received: by 2002:a05:6402:1ed4:b0:5d0:c697:1f02 with SMTP id
 4fb4d7f45d1cf-5db7d30092amr12798389a12.17.1737205433183; Sat, 18 Jan 2025
 05:03:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <953b0499-5832-49dc-8580-436cf625db8c@163.com> <20250108173547.GI1306365@frogsfrogsfrogs>
 <Z4BbmpgWn9lWUkp3@dread.disaster.area> <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
 <d99bb38f-8021-4851-a7ba-0480a61660e4@163.com> <20250113024401.GU1306365@frogsfrogsfrogs>
 <Z4UX4zyc8n8lGM16@bfoster> <Z4dNyZi8YyP3Uc_C@infradead.org>
 <Z4grgXw2iw0lgKqD@dread.disaster.area> <CAOQ4uxjRi9nagj4JVXMFoz0MXP_2YA=bgvoiDqStiHpFpK+tsQ@mail.gmail.com>
 <Z4rXY2-fx_59nywH@dread.disaster.area>
In-Reply-To: <Z4rXY2-fx_59nywH@dread.disaster.area>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 18 Jan 2025 14:03:41 +0100
X-Gm-Features: AbW1kvbNj3zIXsl6X-Hur4vt3wOw1OUqIViUvun5A_Z1CfQ6Gt_GxU6PzTfgfe8
Message-ID: <CAOQ4uxizxUg+EXar2GzDWgp+reRZ_0wc+DAaSAGmUZ1VXOjjLw@mail.gmail.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Chi Zhiling <chizhiling@163.com>, cem@kernel.org, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chi Zhiling <chizhiling@kylinos.cn>, John Garry <john.g.garry@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 17, 2025 at 11:19=E2=80=AFPM Dave Chinner <david@fromorbit.com>=
 wrote:
>
> On Fri, Jan 17, 2025 at 02:27:46PM +0100, Amir Goldstein wrote:
> > On Wed, Jan 15, 2025 at 10:41=E2=80=AFPM Dave Chinner <david@fromorbit.=
com> wrote:
> > >
> > > On Tue, Jan 14, 2025 at 09:55:21PM -0800, Christoph Hellwig wrote:
> > > > On Mon, Jan 13, 2025 at 08:40:51AM -0500, Brian Foster wrote:
> > > > > Sorry if this is out of left field as I haven't followed the disc=
ussion
> > > > > closely, but I presumed one of the reasons Darrick and Christoph =
raised
> > > > > the idea of using the folio batch thing I'm playing around with o=
n zero
> > > > > range for buffered writes would be to acquire and lock all target=
ed
> > > > > folios up front. If so, would that help with what you're trying t=
o
> > > > > achieve here? (If not, nothing to see here, move along.. ;).
> > > >
> > > > I mostly thought about acquiring, as locking doesn't really have mu=
ch
> > > > batching effects.  That being said, no that you got the idea in my =
mind
> > > > here's my early morning brainfart on it:
> > > >
> > > > Let's ignore DIRECT I/O for the first step.  In that case lookup /
> > > > allocation and locking all folios for write before copying data wil=
l
> > > > remove the need for i_rwsem in the read and write path.  In a way t=
hat
> > > > sounds perfect, and given that btrfs already does that (although in=
 a
> > > > very convoluted way) we know it's possible.
> > >
> > > Yes, this seems like a sane, general approach to allowing concurrent
> > > buffered writes (and reads).
> > >
> > > > But direct I/O throws a big monkey wrench here as already mentioned=
 by
> > > > others.  Now one interesting thing some file systems have done is
> > > > to serialize buffered against direct I/O, either by waiting for one
> > > > to finish, or by simply forcing buffered I/O when direct I/O would
> > > > conflict.
> > >
> > > Right. We really don't want to downgrade to buffered IO if we can
> > > help it, though.
> > >
> > > > It's easy to detect outstanding direct I/O using i_dio_count
> > > > so buffered I/O could wait for that, and downgrading to buffered I/=
O
> > > > (potentially using the new uncached mode from Jens) if there are an=
y
> > > > pages on the mapping after the invalidation also sounds pretty doab=
le.
> > >
> > > It's much harder to sanely serialise DIO against buffered writes
> > > this way, because i_dio_count only forms a submission barrier in
> > > conjunction with the i_rwsem being held exclusively. e.g. ongoing
> > > DIO would result in the buffered write being indefinitely delayed.
> >
> > Isn't this already the case today with EX vs. SH iolock?
>
> No. We do not hold the i_rwsem across async DIO read or write, so
> we can have DIO in flight whilst a buffered write grabs and holds
> the i_rwsem exclusive. This is the problem that i_dio_count solves
> for truncate, etc. i.e. the only way to actually ensure there is no
> DIO in flight is to grab the i_rwsem exclusive and then call
> inode_dio_wait() to ensure all async DIO in flight completes before
> continuing.
>
> > I guess the answer depends whether or not i_rwsem
> > starves existing writers in the face of ongoing new readers.
>
> It does not. If the lock is held for read and there is a pending
> write, new readers are queued behind the pending write waiters
> (see rwsem_down_read_slowpath(), which is triggered if there are
> pending waiters on an attempt to read lock).
>
> > > > I don't really have time to turn this hand waving into, but maybe w=
e
> > > > should think if it's worthwhile or if I'm missing something importa=
nt.
> > >
> > > If people are OK with XFS moving to exclusive buffered or DIO
> > > submission model, then I can find some time to work on the
> > > converting the IO path locking to use a two-state shared lock in
> > > preparation for the batched folio stuff that will allow concurrent
> > > buffered writes...
> >
> > I won't object to getting the best of all worlds, but I have to say,
> > upfront, this sounds a bit like premature optimization and for
> > a workload (mixed buffered/dio write)
>
> Say what? The dio/buffered exclusion change provides a different
> data coherency and correctness model that is required to then
> optimising the workload you care about - mixed buffered read/write.
>
> This change doesn't optimise either DIO or buffered IO, nor is a
> shared-exclusive BIO/DIO lock isn't going to improve performance of
> such mixed IO workloads in any way.  IOWs, it's pretty hard to call
> a locking model change like this "optimisation", let alone call it
> "premature".
>

I was questioning the need to optimize the mixed buffered read/write
*while file is also open for O_DIRECT*
I thought that the solution would be easier if can take Christof's
"Let's ignore DIRECT I/O for the first step" and make it testable.
Then if the inode is open O_DIRECT, no change to locking.

> > that I don't think anybody
> > does in practice and nobody should care how it performs.
> > Am I wrong?
>
> Yes and no. mixed buffered/direct IO worklaods are more common than
> you think. e.g. many backup programs use direct IO and so inherently
> mix DIO with buffered IO for the majority of files the backup
> program touches.

Still feels like we can forego performance of mixed buffered rw
*while the backup program reads the database file*, should a backup
program ever really read a large database file...

> However, all we care about in this case is data
> coherency, not performance, and this change should improve data
> coherency between DIO and buffered IO...
>

I did not understand that you are proposing an improvement over the
existing state of affairs. Yeh, I certainly have no objections to fixing
things that are wrong.

> > For all practical purposes, we could maintain a counter in inode
> > not for submitted DIO, but for files opened O_DIRECT.
> >
> > The first open O_DIRECT could serialize with in-flight
> > buffered writes holding a shared iolock and then buffered writes
> > could take SH vs. EX iolock depending on folio state and on
> > i_dio_open_count.
>
> I don't see how this can be made to work w.r.t. sane data coherency
> behaviour. e.g. how does this model serialise a new DIO write that
> is submitted after a share-locked buffered write has just started
> and passed all the "i_dio_count =3D=3D 0" checks that enable it to use
> shared locking? i.e. we now have potentially overlapping buffered
> writes and DIO writes being done concurrently because the buffered
> write may not have instantiated folios in the page cache yet....
>

A shared-locked buffered write can only start when there is no
O_DIRECT file open on the inode.

The first open for O_DIRECT to increment i_dio_open_count
needs to take exclusive iolock to wait for all in-flight buffered writes
then release the iolock.

All DIO submitted via O_DIRECT fds will be safe against in-flight
share-locked buffered write.

> > I would personally prefer a simple solution that is good enough
> > and has a higher likelihood for allocating the development, review
> > and testing resources that are needed to bring it to the finish line.
>
> Have you looked at how simple the bcachefs buffered/dio exclusion
> implementation is? The lock mechanism itself is about 50 lines of
> code, and there are only 4 or 5 places where the lock is actually
> needed. It doesn't get much simpler than that.
>
> And, quite frankly, the fact the bcachefs solution also covers AIO
> DIO in flight (which i_rwsem based locking does not!) means it is a
> more robust solution than trying to rely on racy i_dio_count hacks
> and folio residency in the page cache...

I will be happy to see this improvement.

Thanks,
Amir.
