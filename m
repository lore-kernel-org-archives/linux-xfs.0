Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994F83CDBC0;
	Mon, 20 Jul 2026 08:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784535632; cv=none; b=a5RQ8obZu3WJVoNVYhpVgUemN2K0+B/tX0exODxAQekk7bZ+UGlTIoLQ7zVxMZN+jEIHsY9jtojXyVO4KYamwmWN7kJluRj0QFeTVNh6rtK7KX6nFK+uGEW4uWdZW6k5MtsGraOdlct9EOXISO32bxxnufNV4NTjoo/SSFllOUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784535632; c=relaxed/simple;
	bh=9hrMIyeDDxXx2Y7I+Ld2m9yRvcSek29z5nUmqR0hgxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LR02/MZfNPI6y1BPPCQvqcN9/JwEHEsNSbjV9sdfPhDugQu7liSXV/u020rLiTdRYU747xmYzF4mB91grKkL8VHUbvKFERz0uJTuh6eEyTx5tFwDJpQ95MTMWgxIMI3W9N7agXWrJLUF4veOhW1YVkWd9C1DBohJotk6VH5NLQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0646E68BEB; Mon, 20 Jul 2026 10:20:24 +0200 (CEST)
Date: Mon, 20 Jul 2026 10:20:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, brauner@kernel.org, hch@lst.de,
	willy@infradead.org, hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/18] xfs: convert iomap ops to ->iomap_next()
Message-ID: <20260720082023.GC18764@lst.de>
References: <20260701000949.1666714-1-joannelkoong@gmail.com> <20260701000949.1666714-3-joannelkoong@gmail.com> <20260702164339.GI9392@frogsfrogsfrogs> <CAJnrk1ZRQaFseAnz3zm31oR3KmQWje5HDJjhNbAQSAQyK9_PMA@mail.gmail.com> <CAJnrk1bj4pLpAzLhehrbDJuKWa=WMq-3XOAm9dhsEVDF9WCBPQ@mail.gmail.com> <CAJnrk1YkAEUhjw6mNEx70ojN7UMQT__oHn5m1Ng2Lz7FoLRhrA@mail.gmail.com> <20260717175552.GT7380@frogsfrogsfrogs> <CAJnrk1bjA+Y5V-87AhNGR5-ss7gUJWwLkjouwic1Mckd2QRH7Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1bjA+Y5V-87AhNGR5-ss7gUJWwLkjouwic1Mckd2QRH7Q@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 17, 2026 at 02:48:03PM -0700, Joanne Koong wrote:
> > > > > > > +     return iomap_process(iter, iomap, srcmap, xfs_direct_write_iomap_begin,
> > > > > > > +                     NULL);
> > > > > >
> > > > > > But then "iomap_iter" sets up a new problem: should iomap_process have a
> > > > > > new name that goes along with that?  iomap_iter is already taken for the
> 
> I'm starting not to like "iomap_process()" either, it seems too vague...

It is.

> I think it'd be better renamed to "iomap_iter_next()". The callsites
> would then just look something like:
> 
> static int
> xfs_read_iomap_next(
>        const struct iomap_iter *iter,
>        struct iomap            *iomap,
>        struct iomap            *srcmap)
> {
>        return iomap_iter_next(iter, iomap, srcmap, xfs_read_iomap_begin, NULL);
> }
> 
> static int
> xfs_seek_iomap_next(
>        const struct iomap_iter *iter,
>        struct iomap            *iomap,
>        struct iomap            *srcmap)
> {
>        return iomap_iter_next(iter, iomap, srcmap, xfs_seek_iomap_begin, NULL);
> }

Looks fine.  And this might also be on of the rare case where a littl macro
magic to generate this might fine.  I.e. turn this into:

static DEFINE_IOMAP_ITER_NEXT(xfs_read_iomap_next, xfs_seek_iomap_begin);
static DEFINE_IOMAP_ITER_NEXT(xfs_seek_iomap_next, xfs_read_iomap_begin);

and

static DEFINE_IOMAP_ITER_NEXT_END(xfs_buffered_write_iomap_next,
		xfs_buffered_write_iomap_begin, xfs_buffered_write_iomap_end);

(could be shorted with string concatenations, but those are really annoying..)

