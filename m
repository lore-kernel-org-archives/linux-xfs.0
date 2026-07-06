Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F65B13B7A3;
	Mon,  6 Jul 2026 03:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783310393; cv=none; b=ALSyrhePOzLZqbxetmIqWgHSu0PEk4SEEgdvOO/vOCjRoB7spu9QdJkVahI+HZkQNFYpQd6nQODKe6Mpls9kjDj80bFNIyFbw4dTjxIgO8CUlCbi0BL8YvYTqf06MIL/gibeBZEoebWV/5n5nB3sQpqavebrOgL3LNAT59QqdjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783310393; c=relaxed/simple;
	bh=0yHlcrsyfBalhWb3whVHo4M2Gl29ZEj+sCh6EvDmekI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mp8TFSPoPnY63Q1ZXIS/PJlpBYvjXdQyQAHHx//Msh2LEkx3CsEaUJDhY7zF5MKTVA0KR1pRLPy2Q+5M8rfkqU+JJzjEFXJk2NYRVpHiqX0vQPLnzi3Y4qTny6mI3rL5FsiqllVqDQZzkVXbT71tSySg4t7N8pCjZq72umDGi80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A18A868B05; Mon,  6 Jul 2026 05:59:46 +0200 (CEST)
Date: Mon, 6 Jul 2026 05:59:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	brauner@kernel.org, willy@infradead.org,
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 18/18] Documentation: iomap: update docs to reflect
 iomap_next model
Message-ID: <20260706035946.GC21998@lst.de>
References: <20260701000949.1666714-1-joannelkoong@gmail.com> <20260701000949.1666714-19-joannelkoong@gmail.com> <20260702192658.GN9392@frogsfrogsfrogs> <CAJnrk1YZQOQ0D6p6qYx1BPvKQaDgZsrKzLbGZzaH8tUkj_OoOQ@mail.gmail.com> <20260703020020.GS9392@frogsfrogsfrogs> <20260703124331.GA26440@lst.de> <20260703161147.GB9407@frogsfrogsfrogs> <CAJnrk1Zv8FEAD+T=1+ZLi6q8ztHVY1zray019QNdeLpYjTNQAQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1Zv8FEAD+T=1+ZLi6q8ztHVY1zray019QNdeLpYjTNQAQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 03, 2026 at 05:34:59PM -0700, Joanne Koong wrote:
> On Fri, Jul 3, 2026 at 9:11 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Fri, Jul 03, 2026 at 02:43:31PM +0200, Christoph Hellwig wrote:
> > > On Thu, Jul 02, 2026 at 07:00:20PM -0700, Darrick J. Wong wrote:
> > > > The ->begin method can still set iomap::private and the ->end method can
> > > > dispose of it, right?  Oh, wait, no, that doesn't work because you're
> > > > talking about ->begin/->end passing something to the next ->begin.
> > >
> > > Should we move ->private from struct iomap to struct iomap_iter?
> > > That'll deal with the constness and the fact that private data
> > > really is a per-operation thing.
> 
> I'm not sure I understand. Doesn't struct iomap_iter already have a
> private field that holds caller-supplied per-operation context?
> afaics, the users of iomap->private (gfs2, ntfs3, fuse-dax) do use it
> for per-mapping data and release it in the same iteration.

True, different uses.

> > I dunno -- towards the end of the fuse-iomap development work I actually
> > had started using iomap.private to store per-mapping private data.  But
> > that work is dead now, so that's not a strong argument.
> >
> > > That also reminds me that now that we actually still keep the low-level
> > > begin/end ops we need to switch them to a calling convention that
> > > passes the iter instead of the ugly container_of.  This is something
> > > I wanted deferred until we get the iter conversion, but it turns out
> > > that now leaves them untouched..
> 
> That's a good point. Do you think it'd be better to include those
> changes as part of this series or do that as a separate follow-up
> series that targets the same merge window timeline as this one?

It might make sense to simply use the new signature for the iomap_process
callbacks and switch over only once.  And never touch the existing
begin/end methods in the iomap_ops.

> 
