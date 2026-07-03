Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FAD23BD02;
	Fri,  3 Jul 2026 02:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783044022; cv=none; b=mSEoiXxV2WtNRNoV6WyPYQX7tHMBFmq+T1mIgdIhNzIgIJ0GcXh31n5RD8k6WOwMxSYMQDBiDvVpqc0tn7lofdRFoJQAlGN9rwmWe3233m4RSPt16yH+wC/tkR6AeNvZcLVvZWzC3zP+1NSddBoDPgXXEaJtYtAq6ftv29NwGX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783044022; c=relaxed/simple;
	bh=rVUsf9s27g0oL4qyTJOW6ytXgxFzqPeYvnBAqT0qu8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MKvfZO5V2AyMcr2uoOM5d4/SGeGzCZTkoJni+JmWyfoYRsdHGyxVC7+4UqjHwssRaDXJpvr2j+bU4sFZ/BKFsuKfipCV52LyRn1426QTtUolo4iSFdehz9VzPkEzT1C4nhoCfPutQzkeo46pL8w0aj21cHdAyb3Ajh9EFTNJuCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZZwM2VLC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZZwM2VLC"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C76591F000E9;
	Fri,  3 Jul 2026 02:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783044020;
	bh=7KDM/4aP5qHk37jWKwwNbvJ+YWJqTEZ+9ZiwKcHjN+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZZwM2VLC9/Jodn6mInMpHPh8TGbxKk2cFf/75CAtFRq0KVkKGnQgwgNPLel1WcXbG
	 ip73MshfUWjbgZsYNfH2PCMESxQnsKAqOlbrNGS+e2I/Qogbzx0Uf/oxCduYNOdSGq
	 3GfDws/dtt/17w7BngGUFoKY5WtN60h34fYoLmTWomyHWUYbhkhT4LumyP2pTxkWez
	 vI1BitpfhVZwfwPyDYBqOKaZKO09Y9ImG9gbZiGuSWEZuptVr8LHg3QCJH0Vi5tj2i
	 Bhsang1BKidNlIsykVNi/GZalR65+4Os10VFvkk+Om8xLgyOTAj3CcZpZIInvu8KhM
	 ht9ePnC0aBvfg==
Date: Thu, 2 Jul 2026 19:00:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: brauner@kernel.org, hch@lst.de, willy@infradead.org,
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 18/18] Documentation: iomap: update docs to reflect
 iomap_next model
Message-ID: <20260703020020.GS9392@frogsfrogsfrogs>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-19-joannelkoong@gmail.com>
 <20260702192658.GN9392@frogsfrogsfrogs>
 <CAJnrk1YZQOQ0D6p6qYx1BPvKQaDgZsrKzLbGZzaH8tUkj_OoOQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1YZQOQ0D6p6qYx1BPvKQaDgZsrKzLbGZzaH8tUkj_OoOQ@mail.gmail.com>

On Thu, Jul 02, 2026 at 06:36:55PM -0700, Joanne Koong wrote:
> On Thu, Jul 2, 2026 at 12:27 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Tue, Jun 30, 2026 at 05:09:33PM -0700, Joanne Koong wrote:
> > > Filesystems no longer pass a struct iomap_ops with separate
> > > ->iomap_begin() and ->iomap_end() callbacks.  Instead, every iomap
> > > operation takes a single iomap_next() callback directly. iomap_next()
> > > finishes the previous mapping (if any) and produces the next one. Most
> > > filesystems build it from begin and end helpers via the iomap_process()
> > > helper.
> > >
> > > Update the iomap documentation to match this change.
> > >
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> > >  Documentation/filesystems/iomap/design.rst    | 115 +++++++++++++-----
> > >  .../filesystems/iomap/operations.rst          |  60 +++++----
> > >  Documentation/filesystems/iomap/porting.rst   |  22 +++-
> > >  3 files changed, 132 insertions(+), 65 deletions(-)
> > >
> > > diff --git a/Documentation/filesystems/iomap/design.rst b/Documentation/filesystems/iomap/design.rst
> > > index 0f7672676c0b..7a37e303eea8 100644
> > > --- a/Documentation/filesystems/iomap/design.rst
> > > +++ b/Documentation/filesystems/iomap/design.rst
> > > @@ -75,7 +75,10 @@ At a high level, an iomap operation `looks like this
> > >
> > >  1. For each byte in the operation range...
> > >
> > > -   1. Obtain a space mapping via ``->iomap_begin``
> > > +   1. Obtain the next space mapping via the ``iomap_next`` callback.
> > > +      From the second iteration onwards this same callback first finishes
> > > +      the previous mapping (committing or unreserving space as needed)
> > > +      and then produces the next one.
> > >
> > >     2. For each sub-unit of work...
> > >
> > > @@ -86,7 +89,13 @@ At a high level, an iomap operation `looks like this
> > >
> > >     3. Increment operation cursor
> > >
> > > -   4. Release the mapping via ``->iomap_end``, if necessary
> > > +iomap repeats this until the range is fully consumed.  The ``iomap_next``
> > > +callback returns ``1`` while there is more of the range left to process,
> > > +``0`` once it is fully consumed, and a negative errno on error.
> >
> > s/and/or/
> >
> > > +Filesystems rarely implement ``->iomap_next`` by hand. The ``iomap_process``
> > > +helper implements the finish-then-produce sequence in +terms of two smaller
> > > +callbacks, ``begin`` and ``end``. See `The Mapping Callback`_ below for more
> > > +info.
> >
> > I wonder, under what circumstances would a filesystem /not/ use
> > iomap_process()?
> 
> Hmm, maybe a situation where they need to share or carry some
> filesystem-specific state / info between finishing the mapping and
> producing the next one?

The ->begin method can still set iomap::private and the ->end method can
dispose of it, right?  Oh, wait, no, that doesn't work because you're
talking about ->begin/->end passing something to the next ->begin.

I suppose you could make iomap_iter_continue preserve the iomap/srcmap
private pointer across the memset(0) calls.  But all current users
either rely on private being zeroed by iomap_iter after ->iomap_end
returns, so that would be quite the change.

Hm.  I was thinking that the signature for iomap_process could be
cleaner if you didn't have to pass iomap/srcmap explicitly.
iomap_process could do the (dangerous) casting from the (const struct
iomap_iter *) to the (struct iomap *) pointers before calling ->begin
and ->end.

But if you do have an ->iomap_next function that doesn't use
iomap_process, then it has to do the pointer extraction itself.  We
already expose the innards of struct iomap_iter to callers, so maybe
it's ok to have some gross helpers like:

static inline struct iomap *iomap_iter_iomap(const struct iomap_iter *i)
{
	return (struct iomap *)&i->iomap;
}

static inline struct iomap *iomap_iter_srcmap(const struct iomap_iter *i)
{
	return (struct iomap *)&i->srcmap;
}

I'm not sure *that*'s any cleaner.  And I think it gets confusing with
the other srcmap extraction function.

Eh never mind, I've talked myself out of this. ;)

> > >  Each iomap operation will be covered in more detail below.
> > >  This library was covered previously by an `LWN article
> > > @@ -189,7 +198,7 @@ The fields are as follows:
> > >     * **IOMAP_DELALLOC**: A promise to allocate space at a later time
> > >       ("delayed allocation").
> > >       If the filesystem returns IOMAP_F_NEW here and the write fails, the
> > > -     ``->iomap_end`` function must delete the reservation.
> > > +     ``end`` function must delete the reservation.
> > >       The ``addr`` field must be set to ``IOMAP_NULL_ADDR``.
> > >
> > >     * **IOMAP_MAPPED**: The file range maps to specific space on the
> > > @@ -208,12 +217,12 @@ The fields are as follows:
> > >
> > >     * **IOMAP_INLINE**: The file range maps to the memory buffer
> > >       specified by ``inline_data``.
> > > -     For write operation, the ``->iomap_end`` function presumably
> > > -     handles persisting the data.
> > > +     For write operation, the ``end`` function presumably handles
> > > +     persisting the data.
> >
> > Unrelated to this patch, but this should say "For write operations, the
> > end function must persist the data" because iomap_writepages doesn't
> > handle inline data.
> >
> > >       The ``addr`` field must be set to ``IOMAP_NULL_ADDR``.
> > >
> > >   * ``flags`` describe the status of the space mapping.
> > > -   These flags should be set by the filesystem in ``->iomap_begin``:
> > > +   These flags should be set by the filesystem in ``begin``:
> >>
> > > +``->iomap_next``
> > > +~~~~~~~~~~~~~~~~
> > > +
> > > +Each call must finish the previous mapping, if any, and then produce the
> >
> > Each call?  Oh, each implementation of ->iomap_next must finish the
> > previous mapping.
> >
> > > +next mapping for the current iteration position described by ``iter``.
> > > +The mapping is returned through ``iomap`` (and through ``srcmap`` for
> > > +operations that read from one mapping while writing to another; see
> > > +``begin`` below).
> > >
> > > -``->iomap_begin``
> > > +The callback returns ``1`` to continue iterating, ``0`` once the file
> > > +range has been fully consumed, and a negative errno on error.
> >
> > s/and/or/
> >
> > I think there should be a transition sentence here along the lines of
> >
> > "Most filesystems are not expected to implement all of these behaviors
> > in ->iomap_next themselves.  They should instead call iomap_process as
> > described below."
> >
> > Or demote the next section so it's more obvious that the "iomap_process"
> > and "->iomap_next" sections aren't independent?
> >
> 
> Sounds good, I'll incorporate all the suggestions you recommended.

<nod>

--D

> Thanks,
> Joanne
> 
