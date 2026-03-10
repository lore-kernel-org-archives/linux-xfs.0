Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122812FD1DA;
	Tue, 10 Mar 2026 14:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773154122; cv=none; b=ZGGtL0m9DdW1Yw7olbme9XOa+ul9uGFwE1CcPUP5Co4scP2JaRUP1Jf0qVhxRV6G6IZoeXY38L4qLuhwvXCwSkYe/59QgOmcc7gYaCGuT3FSYYiEPpLMAmH4+iIhkNNaNYJsyK5uU331u7okIFlbJfTljVG3jLs8qAm3qTIu4RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773154122; c=relaxed/simple;
	bh=/ERBHzm4gpqPnWOIhVKShzxiAhUaoHBj4twlF09ISLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ADZB4gzTNCFuHe7YhLzE5Y5M7iYqvdtDY+sM8VPhHH1wAgbZmwiHhw2WeNzU6aHV3hSM5KoLE/mXwQ0/R8YC38HyDgYJXjR7c6cw3BmmukqjiM01kapDEpEdVfOgPvYAkyUNCsYeIYWdy3B9EQdPAOvgibzykJKi1rmWjtNHOQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QjNRvFVA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QjNRvFVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65F4C19423;
	Tue, 10 Mar 2026 14:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773154121;
	bh=/ERBHzm4gpqPnWOIhVKShzxiAhUaoHBj4twlF09ISLY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QjNRvFVAhYKhcwxcAoC7kakqXSJw+wibAT6J49KsZlMN64uISzN1HbDrd4uaf3KsV
	 uIWnhQPxSyV9U4NWAx1il9+7WgowH04FSx0M4M5tITOwFeAiPoiDVtYeCbWtxp9eWI
	 wIF6B9xVSExHWU5/izTDNYff7MdMkZDyjIOe5ct9IzfXwM1SeR+3P4FYPtE6b5UIYY
	 W94HkoiMZLCSE4uaL35WObyIFWSguJk2Mfqjo3jy+oD/0npRLym4HNRhpl0LEBbuhy
	 nrvoAjb0mCMmKJbnnsTrgeXiVhYM1HldDk6zkBIzfzHjv9+7yqJLl8kfqwv3wIQxcq
	 co9gyL0nhyokQ==
Date: Tue, 10 Mar 2026 07:48:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 2/8] xfs: flush dirty pagecache over hole in zoned
 mode zero range
Message-ID: <20260310144841.GM1105363@frogsfrogsfrogs>
References: <20260309134506.167663-1-bfoster@redhat.com>
 <20260309134506.167663-3-bfoster@redhat.com>
 <20260309172219.GM6033@frogsfrogsfrogs>
 <aa--e9z5MZ9MOAFu@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa--e9z5MZ9MOAFu@infradead.org>

On Mon, Mar 09, 2026 at 11:47:23PM -0700, Christoph Hellwig wrote:
> On Mon, Mar 09, 2026 at 10:22:19AM -0700, Darrick J. Wong wrote:
> > Why does the mapping disappear out of both data and cow forks between
> > writeback setup and completion?  IIRC it is because the writeback ioend
> > effectively owns the unwritten mapping.  We want another writer thread
> > to see the hole and reserve its own out-of-place write because the write
> > mapping that writeback's working on is immutable once the disk actually
> > writes it.  Right?
> 
> Mostly because we don't have good code to turn a COW fork delalloc
> mapping into a data fork written one.  Unwritten extents do not actually
> exist for zoned RT forks.
> 
> > I wonder if we could stash a delalloc mapping in the cow fork with zero
> > indlen during writeback to signal "get a real zoned space reservation"?
> 
> What would that help with?

Faking out iomap zeroing, and probably not much else.

--D
