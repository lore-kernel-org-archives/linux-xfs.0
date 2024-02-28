Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0966A13D2E8
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 23:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709164049; cv=none; b=S6hRVyMKTUyJyRFjP5MNbAvkjeWI8pg1ClGRerDmXOk21sKC8yFU7aK1RJdrdURTMbUTI1lY5wwc7SMXlLc9XUJls0hFH9vRCiC76ANXPwUJX34n/D54BF1kRR1i4hGveD64Epg4MOQAYwtSZYKWSmSAONiQK1FSH/U0iJJVigk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709164049; c=relaxed/simple;
	bh=CErcVwzK1TTHfc+m0Kbn7aeahlUqGCojo2q/jlVzhqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dj7teD62w2OHMXQApopcY2cxBkyq8lj0EUyXgtDu1Wn4Vfvoiha+L3xqtzGY+mpk1quVR8G7bib1LYbufW7mKOKRCt+tBvOweLmqbIG1PIlmTe2W2m62vfkquOcR0QRK6KdtpJSaC/FbYnOAm/6ky1MWItuWDAi9U7fhXIfSYcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HgrMVkqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HgrMVkqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A70C433C7;
	Wed, 28 Feb 2024 23:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709164048;
	bh=CErcVwzK1TTHfc+m0Kbn7aeahlUqGCojo2q/jlVzhqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HgrMVkqVf2a+dD1RNIhllUQsjsxhzphGxBkqyd49i8wBMQceR2efHWNzm8CXp0yXr
	 a+tearMLudf9ijgv81CrO91RYvc8l1I2eUo3PB5myivkwL1yPvtfcLTj9v1cqzHlzH
	 36l/JXspeuE0kWNNN/J0lC5x4gUOPNGLjRNC1umHFQHr1zWbqxrmCYDdUrWCJ4XiJ7
	 ji1hpZla1IfvWJsUwXhAKbKigRmXfbbxI0XFDxqmu3KWqx02sE7kaZ4keC7g5xT8P0
	 HND1BJBlseRLVC/hG7lEaKTHs5G0T4DrjqhNRhPYJcwJxADxaCi2qZeoUtsMQEIupP
	 I0pRxDe/GDNRA==
Date: Wed, 28 Feb 2024 15:47:28 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Akira Yokosawa <akiyks@gmail.com>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] kernel-doc: Add unary operator * to $type_param_ref
Message-ID: <20240228234728.GW1927156@frogsfrogsfrogs>
References: <fa7249e6-0656-4daa-985d-28d350a452ac@gmail.com>
 <878r34p60q.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878r34p60q.fsf@meer.lwn.net>

On Wed, Feb 28, 2024 at 03:40:05PM -0700, Jonathan Corbet wrote:
> Akira Yokosawa <akiyks@gmail.com> writes:
> 
> > In kernel-doc comments, unary operator * collides with Sphinx/
> > docutil's markdown for emphasizing.
> >
> > This resulted in additional warnings from "make htmldocs":
> >
> >     WARNING: Inline emphasis start-string without end-string.
> >
> > , as reported recently [1].
> >
> > Those have been worked around either by escaping * (like \*param) or by
> > using inline-literal form of ``*param``, both of which are specific
> > to Sphinx/docutils.
> >
> > Such workarounds are against the kenrel-doc's ideal and should better
> > be avoided.
> >
> > Instead, add "*" to the list of unary operators kernel-doc recognizes
> > and make the form of *@param available in kernel-doc comments.
> >
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Link: [1] https://lore.kernel.org/r/20240223153636.41358be5@canb.auug.org.au/
> > Acked-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
> > Cc: Jonathan Corbet <corbet@lwn.net>
> > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > ---
> > Note for Chandan
> >
> > As both of patches 1/2 and 2/2 are needed to resolve the warning from
> > Sphinx which commit d7468609ee0f ("shmem: export shmem_get_folio") in
> > the xfs tree introduced, I'd like you to pick them up.
> 
> This change seems fine to me; I can't make it break anything.  I can't
> apply the mm patch, so either they both get picked up on the other side
> or we split them (which we could do, nothing would be any more broken
> that way).  For the former case:
> 
> Acked-by: Jonathan Corbet <corbet@lwn.net>

Seeing as the changes came through the XFS tree, I second the notion of
pushing this via the xfs for-next.

--D

> Thanks,
> 
> jon
> 
