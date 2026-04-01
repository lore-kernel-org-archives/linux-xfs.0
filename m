Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4811230DECE;
	Wed,  1 Apr 2026 22:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775080964; cv=none; b=oZxpXl2Tym1FSJit5dykpwy50/tb8yyYLwBNQk12PyMDxPqjRik/FlYnq2h+dLzk78dR++kBBT6eW35YNZ9rOby0heMcEEG/ufG3nIgvsXJgSkMOjySq3+KlPPPBtTgsBFoQSBWbXTSi0mCZ9DVnq0hKc48tHwxyPnNKb075AVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775080964; c=relaxed/simple;
	bh=XLe7iwOJXHsWYPpv5bKbhLQ02plXgKrNwG0uXVLyzcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lnxU+Ezjp5XihgpqhrElbVNn6j/Fn5A6uBe2VjjsOecwLELTa845TLyGKWo1NQBC6tfWSrPcMptO22lGKjlrL8cAyACZBpR4kfe+Awzf4ClpKUEtCChYhQXiVpFwxQ5OirpJvD/d5BIE0dLpWBQFKNT6DJ9P7/dWoLFoHnca3wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lv3WUjD5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lv3WUjD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C417C4CEF7;
	Wed,  1 Apr 2026 22:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775080963;
	bh=XLe7iwOJXHsWYPpv5bKbhLQ02plXgKrNwG0uXVLyzcU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lv3WUjD5WCLSg7eVifiAgrFgfAdm8yUbb47Bzb+d3FXc476Hp55Aj+/MrhYGuemzn
	 2TwtfnzU+nBNNHzir/JRbRqq7b/473/tN1dk1rNc4tzw1HVIXTbBVlZzdhYD/kOs/R
	 ndAtx8tw4TcCo23N75bwh9ynZ2Wdr8QtHA5o5AxbWmSpLW4WoiCGOXioDlgEm01gCS
	 MEl7SXfy8+qib4he4f01aW68NkUSQGUxgDUNGcJ9NBrPlBaZluupNrfzLHn0K66Y8r
	 rOl6E4oFzqGegIkTEPvnicsld4HcK02IV+pLKXoK1Wn6B0BUANnot3sU50dbNmtRPK
	 0RPQ3EJ2+Caeg==
Date: Wed, 1 Apr 2026 15:02:41 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v6 02/22] fsverity: expose ensure_fsverity_info()
Message-ID: <20260401220241.GG2466@quark>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
 <20260331212827.2631020-3-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331212827.2631020-3-aalbersh@kernel.org>

On Tue, Mar 31, 2026 at 11:28:03PM +0200, Andrey Albershteyn wrote:
> This function will be used by XFS's scrub to force fsverity activation,
> therefore, to read fsverity context.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Acked-by: Eric Biggers <ebiggers@kernel.org>

> +/**
> + * fsverity_ensure_verity_info() - create verity info if it's not in memory yet
> + * @inode: the inode for which verity info should be created
> + *
> + * Ensure this inode has verity info attached to it. Read fsverity descriptor
> + * and creates verity based on that. Inodes opened outside of
> + * file_operations->open will not have any verity info attached. This
> + * info is required for any fsverity related operations.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +int fsverity_ensure_verity_info(struct inode *inode);

As Christoph mentioned, fs/verity/ uses the convention of the kerneldoc
for functions being above the function definition.

I think the comment could also be clearer:

> create verity info if it's not in memory yet

Maybe "cache verity info if it's not already cached", to avoid potential
confusion with enabling fsverity on the file.

> Ensure this inode has verity info attached to it.

Maybe add: "It's assumed the inode already has fsverity enabled."

> Inodes opened outside of file_operations->open will not have any
> verity info attached. This info is required for any fsverity
> related operations.

The first sentence could be misinterpreted as saying that this function
won't do anything in that case.  The second sentence isn't clear what
counts as "any fsverity related operation".  Also "opened" doesn't seem
like the right word to use when talking about a filesystem-internal read
that occurs without a file descriptor having been opened.

Maybe replace with:

* This needs to be called at least once before any of the inode's data
* can be verified (and thus read at all) or the inode's fsverity digest
* retrieved.  fsverity_file_open() calls this already, which handles
* normal file accesses.  If a filesystem does any internal (i.e. not
* associated with a file descriptor) reads of the file's data or
* fsverity digest, it must call this explicitly before doing so.

By the way, should there be a patch that converts
ovl_ensure_verity_loaded() to use this?

- Eric
