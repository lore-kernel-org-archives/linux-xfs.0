Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0623E28CF77;
	Sat,  4 Jul 2026 04:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783139896; cv=none; b=m+yxxha2ZjlCaLS3/JPwJQ4cs8n+2ufD7vI3THEmshcQjP4EQTzLyy32pWvHkkzM1YTd+RXT0Mab2D6LRGzrBS0IsiKDXkcMEvTNHEJSP6DnGzIwco72kB0b5ULO854SH5u3Fw8GASSfeF9KtT50b2hGlQlILAz88xuXbkC4BdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783139896; c=relaxed/simple;
	bh=yRJWIPYU7x9O4o82CkNjHV3Q+ojcQHdhKbof/8IUxkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AyhRY0e0tksHKei9UsszKPgE0ycNqZcf5OgxyZ19KwbpUqRaUE3/xZh4qWzKsUGJMcDAs8b8XiJyko9Z74noHoOTCNCkLTBj6LR3idUljpMRDjzA3FPLNdSN1CExdF1pPiyNs/IUNgW4qAFNcG6/LPNW6a5QeXfIh7r7lBfT9nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DXfbiV6g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DXfbiV6g"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F35141F000E9;
	Sat,  4 Jul 2026 04:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783139889;
	bh=qRAmcRU3owZQdAAKakvkU8W3SwpcXOWxnb6DylVdk9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DXfbiV6gKXNj8Wvs9hw5qkDLynuSYspyuLQhy00fnh1MqDD/O1hx1PQASm1qyaIDy
	 diUZyrCsQRk1bp93hnlAfbd1FTZT6khHhBvtenlfMxl0CuH6U/Na71wHsu9K0f4fZn
	 UXwB4GH0XiZ3KdAAqrbQHIvWhTmfpjGsW7mj/f31qSQnQ9LH6XUGPKYrHNf5/AZVVw
	 D2atEWFNjynMkgF0r00OkSjCntE8Wccsc9OXtF0Pb5Yo56hhKTK71daRZSpVB0zg4H
	 BsP41jGwa8i/K0kfC9JXAKJ8h2da/qjBaWTXWEk9ZtRliYRbHiTK0ZNK85I5pw1YZv
	 MkS/8BYN0ApjQ==
Date: Fri, 3 Jul 2026 21:38:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, brauner@kernel.org, willy@infradead.org,
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 18/18] Documentation: iomap: update docs to reflect
 iomap_next model
Message-ID: <20260704043808.GC9407@frogsfrogsfrogs>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-19-joannelkoong@gmail.com>
 <20260702192658.GN9392@frogsfrogsfrogs>
 <CAJnrk1YZQOQ0D6p6qYx1BPvKQaDgZsrKzLbGZzaH8tUkj_OoOQ@mail.gmail.com>
 <20260703020020.GS9392@frogsfrogsfrogs>
 <20260703124331.GA26440@lst.de>
 <20260703161147.GB9407@frogsfrogsfrogs>
 <CAJnrk1Zv8FEAD+T=1+ZLi6q8ztHVY1zray019QNdeLpYjTNQAQ@mail.gmail.com>
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

Oh right, iomap_iter::private is a private pointer that the filesystem
can sometimes set to pass per-file-operation data to ->iomap_{begin,end}
... that is tortuously extracted from the iomap_iter via the iomap
pointer.

iomap::private is a private pointer that the filesystem can set to pass
per-mapping data from ->iomap_begin to ->iomap_end.

IOWS, never mind, I'm babbling nonsense.

--D

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
> 
> >
> > Oh, you mean changing the signature to:
> >
> > typedef int (iomap_begin_fn)(struct iomap_iter *iter...);
> >
> > instead of passing parts of the iter as separate arguments?
> > Yeah, that would be nice.
> 
> Agreed.
> 
> Thanks,
> Joanne
