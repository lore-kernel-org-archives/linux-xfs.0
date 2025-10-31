Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F82F286A4
	for <linux-xfs@vger.kernel.org>; Fri, 31 Oct 2025 13:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919088; cv=none; b=Afctj69E5agwvh/hU5qvL+nhvLrpupsMrI98Ut2jzU7YyyD4VKtIcbW0ooCXS5888uS6oQHQm8u0PnChPr5ukg9/Ea4oYJ53EkfpLHs8YBoPjgh+cQ8pebg0ddMTrxOwRWetxD0S0iIAwzihL1QZPbt5MASjdA+55LyZGKB8GNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919088; c=relaxed/simple;
	bh=4OtzQDVBAc8qST0hFrnUFXjbRseO6xbykyydInfexD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DTY11YhqzUCDGjyOnwAAUCWvXKk2/Iljz2zkw2dkIcpsET3nPHZhsC7taAiKaP/0POWCygApLia4qbNTeFfaWWoSEvS7AgQBKFkyMBO/lyFlG2EGzoVpfFPgeckvtVrrOBUzzN41parFtg2KCcdQjzJlpnD5tDCnbnzGXEBivdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mLty6SiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mLty6SiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524FEC4CEE7;
	Fri, 31 Oct 2025 13:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761919084;
	bh=4OtzQDVBAc8qST0hFrnUFXjbRseO6xbykyydInfexD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mLty6SiT+5d9K8eC5JywdFWoMElrGAwxpGZCnMMaoZv5O94l4U+xtUed8XZl8aBIA
	 TQwLI42LS5MR0FFJRg6llDfn3TGRYWQE9H8YrgFhlESnaOh2uAt2EQQohqdqZQ0In0
	 JALEIn63sEc50QOOYSe2HToy4ySkX4BX/sZ+By1DTALcoNv/7+VpFpCatXyho77fxh
	 EtD4hl0i41WraxtCYBRMMb8tk80ib0l8eULg/LY2CCZgy5lJjngsA1Qdgc5fNJm8Ju
	 HmlxG4Sdzbk9DiffHq74CL77IRwJzFtQSKWG4hjeusLjv+zUTZxQ33h099JJ2l65sd
	 xclgVWhVhLD7Q==
Date: Fri, 31 Oct 2025 14:58:00 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 5/9] xfs: remove a very outdated comment from
 xlog_alloc_log
Message-ID: <qjtcyj6bmtemyfyfp6ysiwkha3bdaugfvwtzies46hduah4a3b@zboakdsol6yh>
References: <20251027070610.729960-1-hch@lst.de>
 <p7Xlv7kSI7kv1WKg_1Kto7ngDP6yBIOPbqGKcF1P-dis0dLffr2cZFdgD4Hlg6SpZbQCtZTlxhM_ebusIE8Ejg==@protonmail.internalid>
 <20251027070610.729960-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027070610.729960-6-hch@lst.de>

On Mon, Oct 27, 2025 at 08:05:52AM +0100, Christoph Hellwig wrote:
> The xlog_iclog definition has been pretty standard for a while, so drop
> this now rather misleading comment.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_log.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 3bd2f8787682..acddab467b77 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1435,13 +1435,6 @@ xlog_alloc_log(
>  	init_waitqueue_head(&log->l_flush_wait);
> 
>  	iclogp = &log->l_iclog;
> -	/*
> -	 * The amount of memory to allocate for the iclog structure is
> -	 * rather funky due to the way the structure is defined.  It is
> -	 * done this way so that we can use different sizes for machines
> -	 * with different amounts of memory.  See the definition of
> -	 * xlog_in_core_t in xfs_log_priv.h for details.
> -	 */
>  	ASSERT(log->l_iclog_size >= 4096);
>  	for (i = 0; i < log->l_iclog_bufs; i++) {
>  		size_t bvec_size = howmany(log->l_iclog_size, PAGE_SIZE) *
> --
> 2.47.3
> 
