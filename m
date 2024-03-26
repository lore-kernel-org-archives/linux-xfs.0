Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511A813D8AF
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 17:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711472565; cv=none; b=Y6NrYa/3uUNJwQt1Lwk35U5tDsQQwUgyEvg8JeByEmuEuxZoa9nJ719SZnnixQmso251bt+vkLl0fYmXImFqno5SoUvj082FdV75/hquufU/5p+/1SlvEZTGnUTSdlfd79rpo/7FhvAVjtw4N6y3Syr+AEB44XlNOwH3GhHifDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711472565; c=relaxed/simple;
	bh=5DIpeN8U62la1iTsj+HzWWSonzOEtNKFT2zy8ah0l4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cXBa0trHHynQJT/9fca6WPjm+9adLlv31F0BOJoqtdUC6QSxcYlysGPrYhgRACAc+pl+ph++G2bg7XUXENm9Y5ssy8wCSB4EQriyCWVZ0ZHthUncFfNzc1dIJSPgd0rnHwmOL57U7ZEYnD8+KI//qWtaBMbXIK1cW8f568zhHQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hlRWBFbX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hlRWBFbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7703C433F1;
	Tue, 26 Mar 2024 17:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711472564;
	bh=5DIpeN8U62la1iTsj+HzWWSonzOEtNKFT2zy8ah0l4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hlRWBFbXbE96cMeHIQP+1U28niCY+q83glKFeEZ9Juu7+KMurk/7d3a0jTpXkW1/j
	 YOj6TBQ55KT9HszfRqb+lCXwKOtywbXy/jR5uH8lbjjs9dvP2EFvpFEZ5uri2Gt/4Q
	 6pzMinbqCfa4JRgXq1Xag35T/El3NmBHKxDktP07CQYGHgWC25KDgCfB0IZ1Zz9Yhw
	 O/dD3EZI0gLgoG+bykBCwc6eTjIJqJ/Jqvbk7JA1d21o6Ng4XFXh1DzUhziQPcfKHL
	 G8vydgLPcayAIH7+OrUUAaJ9zQXPTk5TF2fvOdtpQz57ylTO+swQvqAh8zSHi9Vd3Y
	 ynQnpO39r3Xbg==
Date: Tue, 26 Mar 2024 10:02:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 094/110] xfs: support in-memory btrees
Message-ID: <20240326170244.GN6390@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
 <171142132733.2215168.1215845331783138642.stgit@frogsfrogsfrogs>
 <ZgJd9eJ5qbiX0fPY@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgJd9eJ5qbiX0fPY@infradead.org>

On Mon, Mar 25, 2024 at 10:32:37PM -0700, Christoph Hellwig wrote:
> >  /* no readahead, need to avoid set-but-unused var warnings. */
> >  #define xfs_buf_readahead(a,d,c,ops)		({	\
> > +	void *__a = a;					\
> >  	xfs_daddr_t __d = d;				\
> > +	__a = __a;					\
> >  	__d = __d; /* no set-but-unused warning */	\
> 
> What about turning this into an inline function instead of piling
> more hacks like this onto the existing ones?

Done.

static inline void
xfs_buf_readahead(
	struct xfs_buftarg	*target,
	xfs_daddr_t		blkno,
	size_t			numblks,
	const struct xfs_buf_ops *ops)
{
}

--D
