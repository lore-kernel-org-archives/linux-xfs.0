Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9951738D;
	Fri,  3 Jul 2026 01:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783042732; cv=none; b=e0oKA99SQa93LvWJfd5aUrdtj5wpXJEl988jiXpgdW1wEl0WgxTz2bq9lEFUz2OtzeGDvr0OCM5PoKAHFlBpPsjW5hiNje6mWDPmnRwJlllNuemkhqm33EkazmiY6OQgB43GkbelGFtzHFj7DIYlGF8amh/N/eAjm26k3xPU+Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783042732; c=relaxed/simple;
	bh=mq2220Go9A5bB1xPNB6asrxJttQ3xZ9wfPRW/70Ph9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GyhxUy6jYQCd64WmuMUxkTe9FeWsCGK9Vueag8H4PUeJZwV9XQ0Lh+yb9sq4GWEQ+WCqtSMLGmRvVkQ7DYPSHxJKRkYua9lE1592cJz/9NhA7rJFdNQtUB+t4/Ujx2iywfF1wBSbk748rRt2xTkE3hgNtlFgUvZFXjI0CdwlFoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PstlkvVE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PstlkvVE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 289BB1F000E9;
	Fri,  3 Jul 2026 01:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783042731;
	bh=tUzVD9QggnKtRDDowC8X3tSqTwejdWgdp3st0c+YMvU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PstlkvVEgI7aKssplK8kU5e9soyJ4pnpLXiGUdGW++UnvfJOgEeV91dhlZ7qi4cfY
	 p+aaaRWJUK5GlDZ6xusPI9rBXSwflcbxRw8L2e9yXD9ln5F37OuNZDkirK3HxV/vsM
	 OAudQ3+roRPZZLb+Cgu9oq/cpFOm48NoZzj2ZJOnV/vY0O9AlHz5eHAxb6MeKFgrkT
	 2qOo9vu4lw1PFkJUuLK1Ku/zBGQFgW37W15Z3dk38rKXbxOztSu3Dd+fUGiz9kRJUE
	 TpwtbZgMXwwO2WagY/NlN7O82Wls5oEwOirHhq02NZ0H83oS5phGTBW84XiOp1Gs6Q
	 GL2iU/QtVOyXQ==
Date: Thu, 2 Jul 2026 18:38:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: brauner@kernel.org, hch@lst.de, willy@infradead.org,
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/18] xfs: convert iomap ops to ->iomap_next()
Message-ID: <20260703013850.GP9392@frogsfrogsfrogs>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-3-joannelkoong@gmail.com>
 <20260702164339.GI9392@frogsfrogsfrogs>
 <CAJnrk1ZRQaFseAnz3zm31oR3KmQWje5HDJjhNbAQSAQyK9_PMA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1ZRQaFseAnz3zm31oR3KmQWje5HDJjhNbAQSAQyK9_PMA@mail.gmail.com>

On Thu, Jul 02, 2026 at 04:59:39PM -0700, Joanne Koong wrote:
> On Thu, Jul 2, 2026 at 9:43 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Tue, Jun 30, 2026 at 05:09:17PM -0700, Joanne Koong wrote:
> > > Convert xfs iomap_ops to the new ->iomap_next() callback. This uses the
> > > iomap_process() helper, which finishes the previous mapping if needed
> > > and produces the next one. No functional changes are intended.
> > >
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> > >  fs/xfs/xfs_file.c  |  4 +-
> > >  fs/xfs/xfs_iomap.c | 96 +++++++++++++++++++++++++++++++++++++++++-----
> > >  2 files changed, 88 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > index 845a97c9b063..7f8bef1a9954 100644
> > > --- a/fs/xfs/xfs_file.c
> > > +++ b/fs/xfs/xfs_file.c
> > > @@ -857,9 +857,9 @@ xfs_file_dio_write_atomic(
> > >                       NULL, 0);
> > >
> > >       /*
> > > -      * The retry mechanism is based on the ->iomap_begin method returning
> > > +      * The retry mechanism is based on the ->iomap_next method returning
> > >        * -ENOPROTOOPT, which would be when the REQ_ATOMIC-based write is not
> > > -      * possible. The REQ_ATOMIC-based method typically not be possible if
> > > +      * possible. The REQ_ATOMIC-based method is typically not possible if
> > >        * the write spans multiple extents or the disk blocks are misaligned.
> > >        */
> > >       if (ret == -ENOPROTOOPT && dops == &xfs_direct_write_iomap_ops) {
> > > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > > index 225c3de88d03..4fa1a5c985db 100644
> > > --- a/fs/xfs/xfs_iomap.c
> > > +++ b/fs/xfs/xfs_iomap.c
> > > @@ -1037,8 +1037,18 @@ xfs_direct_write_iomap_begin(
> > >       return error;
> > >  }
> > >
> > > +static int
> > > +xfs_direct_write_iomap_next(
> > > +     const struct iomap_iter *iter,
> > > +     struct iomap            *iomap,
> > > +     struct iomap            *srcmap)
> >
> > <unvarnished brainstream ahead>
> >
> > Now that I see the callsites, I think the "next" name could use some
> > bikeshedding <cough>.  The purpose of this function is either
> >
> > (a) to look up the first mapping to start iterating;
> > (b) to release whatever resources were attached during the current
> >     iteration and look up the next mapping to continue iterating; or
> > (c) to decide that it's time to stop iterating.
> >
> > From that it seems obvious to me that xfs_direct_write_iomap_next yields
> > iomaps for iteration.  In Python those are called generator functions;
> > in Rust they're called objects that implement the Iterator trait (or
> > iterators for short).
> >
> > How about s/iomap_next/iomap_iter/ ?
> >
> > Then this function would be called xfs_direct_write_iomap_iter, which
> > IMO is a closer description of what the function does, which is to say
> > iterates iomaps for direct writes.
> >
> > (Yes, my brain might be polluted with thinking that "iomap next" refers
> > to a major shift, in the sense of "linux next". :P)
> 
> Thanks for sharing your thoughts. The idea makes sense to me in theory
> but I think in rust and python the "iter" naming is reserved for the
> iterator object itself and the method / callback for advancing and
> yielding the next item in the iteration is named "next" (eg
> Iterator::next in rust and __next__() in python)? I wonder if the
> s/_next/_iter gets confusing with multiple things in iomap already
> called iter (eg the struct iomap_iter, the iomap_iter() function). I'm
> not sure, I'm happy to rename this if that's the preference.

That's a good point that the functions themselves are usually some
variant of next.

> Thanks,
> Joanne
> 
> >
> > > +{
> > > +     return iomap_process(iter, iomap, srcmap, xfs_direct_write_iomap_begin,
> > > +                     NULL);
> >
> > But then "iomap_iter" sets up a new problem: should iomap_process have a
> > new name that goes along with that?  iomap_iter is already taken for the
> > legacy path.  If we were emulating python I'd suggest iomap_iter_yield
> > but this is C so we get to reinvent everything from scratch so who
> > knows.

Any thoughts on iomap_yield()?  Though I can live with iomap_next since
that /is/ the least effort action. :)

--D
