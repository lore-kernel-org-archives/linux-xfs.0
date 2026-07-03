Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB04238D52;
	Fri,  3 Jul 2026 01:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783042884; cv=none; b=ns/arCSxAQpa8jiXNx3jgYecn5hGsj9qJBFD1iRJVJY2QsTz+WyfB8vwGJoSlRftLcjVZrX9Fb+FP9b0G58WU7e+ihLM48YlHrGhdMTrXRO/0EmZ46FM9WWUdQtFTDIHJlt4OAx6kPymvU6qYYJfFdam6m9iRIuNQioXQQh0m0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783042884; c=relaxed/simple;
	bh=bjNUCZE7eqMrZdYmdedXf80XPW399626ejmeo3cYt1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KAHfGJtrjySMpaQfBOLtIv3uowNRcZ3NIADTFYiUInZlkM7MvsDMuyvnPs90jmvVPaQthi/sXBWCNx+9gnun6bHDI0yp0s6bs7XP8I2ZIlpy1Yug5G0egRAbJ9bxajeo4MQ97eLyqPaZdnmy0CRQ//9ocEtZwNPJXSbd4nYoB+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dqpI2wMI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dqpI2wMI"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1B8081F000E9;
	Fri,  3 Jul 2026 01:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783042882;
	bh=lMDzafkUat12ZiI7OV4+Kal9LS3XYBbc3Pl9VS2Ujeo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dqpI2wMId8VmtKqYtsRBnyfi1uRVfCCIroI0qIO8JgHg8QaA6Ojw1ZdGrpXkROqou
	 I/HQuCxjQf5bn5y6jbfRdrC3f5qh89O87EHptAr1UaVjW6XuKtvKm528vCYI8KArG/
	 XnSB2AAA678ECGrpnoXShd4PFocFUmDy1j2WpN1AgNbB0Cz5JDkV+pMRDNHpfVJiRH
	 Az5sp0ObV9P31pLQHTrdzbPYWscBJQL70isAaCF3HYPXhbY/q1GyvcwbsLqIG3K7dY
	 orzln+uOwUE3Zm8I3+FQ/mQ/rii5DohIt6LOxhDBr1ZGikkj5CTmp7c3DMJq7HH6PZ
	 eZTzg46TPYRug==
Date: Thu, 2 Jul 2026 18:41:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: brauner@kernel.org, hch@lst.de, willy@infradead.org,
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/18] xfs: convert iomap ops to ->iomap_next()
Message-ID: <20260703014121.GQ9392@frogsfrogsfrogs>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-3-joannelkoong@gmail.com>
 <20260702164339.GI9392@frogsfrogsfrogs>
 <CAJnrk1ZRQaFseAnz3zm31oR3KmQWje5HDJjhNbAQSAQyK9_PMA@mail.gmail.com>
 <CAJnrk1bj4pLpAzLhehrbDJuKWa=WMq-3XOAm9dhsEVDF9WCBPQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1bj4pLpAzLhehrbDJuKWa=WMq-3XOAm9dhsEVDF9WCBPQ@mail.gmail.com>

On Thu, Jul 02, 2026 at 06:21:00PM -0700, Joanne Koong wrote:
> On Thu, Jul 2, 2026 at 4:59 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> >
> > On Thu, Jul 2, 2026 at 9:43 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > On Tue, Jun 30, 2026 at 05:09:17PM -0700, Joanne Koong wrote:
> > > > Convert xfs iomap_ops to the new ->iomap_next() callback. This uses the
> > > > iomap_process() helper, which finishes the previous mapping if needed
> > > > and produces the next one. No functional changes are intended.
> > > >
> > > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > > ---
> > > >  fs/xfs/xfs_file.c  |  4 +-
> > > >  fs/xfs/xfs_iomap.c | 96 +++++++++++++++++++++++++++++++++++++++++-----
> > > >  2 files changed, 88 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > > index 845a97c9b063..7f8bef1a9954 100644
> > > > --- a/fs/xfs/xfs_file.c
> > > > +++ b/fs/xfs/xfs_file.c
> > > > @@ -857,9 +857,9 @@ xfs_file_dio_write_atomic(
> > > >                       NULL, 0);
> > > >
> > > >       /*
> > > > -      * The retry mechanism is based on the ->iomap_begin method returning
> > > > +      * The retry mechanism is based on the ->iomap_next method returning
> > > >        * -ENOPROTOOPT, which would be when the REQ_ATOMIC-based write is not
> > > > -      * possible. The REQ_ATOMIC-based method typically not be possible if
> > > > +      * possible. The REQ_ATOMIC-based method is typically not possible if
> > > >        * the write spans multiple extents or the disk blocks are misaligned.
> > > >        */
> > > >       if (ret == -ENOPROTOOPT && dops == &xfs_direct_write_iomap_ops) {
> > > > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > > > index 225c3de88d03..4fa1a5c985db 100644
> > > > --- a/fs/xfs/xfs_iomap.c
> > > > +++ b/fs/xfs/xfs_iomap.c
> > > > @@ -1037,8 +1037,18 @@ xfs_direct_write_iomap_begin(
> > > >       return error;
> > > >  }
> > > >
> > > > +static int
> > > > +xfs_direct_write_iomap_next(
> > > > +     const struct iomap_iter *iter,
> > > > +     struct iomap            *iomap,
> > > > +     struct iomap            *srcmap)
> > >
> > > <unvarnished brainstream ahead>
> > >
> > > Now that I see the callsites, I think the "next" name could use some
> > > bikeshedding <cough>.  The purpose of this function is either
> > >
> > > (a) to look up the first mapping to start iterating;
> > > (b) to release whatever resources were attached during the current
> > >     iteration and look up the next mapping to continue iterating; or
> > > (c) to decide that it's time to stop iterating.
> > >
> > > From that it seems obvious to me that xfs_direct_write_iomap_next yields
> > > iomaps for iteration.  In Python those are called generator functions;
> > > in Rust they're called objects that implement the Iterator trait (or
> > > iterators for short).
> > >
> > > How about s/iomap_next/iomap_iter/ ?
> > >
> > > Then this function would be called xfs_direct_write_iomap_iter, which
> > > IMO is a closer description of what the function does, which is to say
> > > iterates iomaps for direct writes.
> > >
> > > (Yes, my brain might be polluted with thinking that "iomap next" refers
> > > to a major shift, in the sense of "linux next". :P)
> >
> > Thanks for sharing your thoughts. The idea makes sense to me in theory
> > but I think in rust and python the "iter" naming is reserved for the
> > iterator object itself and the method / callback for advancing and
> > yielding the next item in the iteration is named "next" (eg
> > Iterator::next in rust and __next__() in python)? I wonder if the
> > s/_next/_iter gets confusing with multiple things in iomap already
> > called iter (eg the struct iomap_iter, the iomap_iter() function). I'm
> > not sure, I'm happy to rename this if that's the preference.
> >
> 
> Ahh okay, I think I see the point you were trying to make. The
> callsite functions are like:
> 
> ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
>                 iomap_next_fn iomap_next,
>                 const struct iomap_write_ops *write_ops, void *private);
> 
> int iomap_fsverity_write(struct file *file, loff_t pos, size_t length,
>                 const void *buf, iomap_next_fn iomap_next,
>                 const struct iomap_write_ops *write_ops);
> 
> void iomap_read_folio(iomap_next_fn iomap_next,
>                 struct iomap_read_folio_ctx *ctx, void *private);
> 
> void iomap_readahead(iomap_next_fn iomap_next,
>                 struct iomap_read_folio_ctx *ctx, void *private);
> 
> etc, so it's not clear from the "iomap_next_fn iomap_next" naming that
> it handles per-iteration logic, whereas renaming it to "iomap_iter_fn
> iomap_iter" makes it more explicit. Am I interpreting this correctly?

Yes.

> I think this is a good idea. If no one has an objection, I'll make
> this change for v3.

Ok by me.  Ignore the email I just sent, please :)

--D

> Thanks,
> Joanne
> 
> >
> > >
> > > > +{
> > > > +     return iomap_process(iter, iomap, srcmap, xfs_direct_write_iomap_begin,
> > > > +                     NULL);
> > >
> > > But then "iomap_iter" sets up a new problem: should iomap_process have a
> > > new name that goes along with that?  iomap_iter is already taken for the
> > > legacy path.  If we were emulating python I'd suggest iomap_iter_yield
> > > but this is C so we get to reinvent everything from scratch so who
> > > knows.
> > >
> > > --D
> > >
> 
