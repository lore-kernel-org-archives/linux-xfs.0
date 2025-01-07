Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3737EC4
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 02:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215236; cv=none; b=EsTeK3pXffT6fm9MxBWRzyLcgyPm8zbYoYAwFhdHejr4Y3iEfgPd2Rrn6PmJXaNnn2t+1OQPB34VxB6W1RhdJD+pMUfiiWR/DvP8drlYWXkUrytsjFFKu+TVWoaGYvRUs48EZEKFaqYMQD4xwZ2ldtVSiL6R/zK/dFoWo9XXlZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215236; c=relaxed/simple;
	bh=xd0TB5l7JLypNTCYT/J5zFnOVU1YxoxvN/w+0fZpo6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N5WKvx70ErfnkLdIBU8u2jb7A9okhOGvdzvFBFwSiETbMBn6vEvnWOtxipKK2cWJe3CesqYc6Z1cbif1QJeqQNmXf4Z2Gwhn/1ncStVRm6DlU1pV38h1laoChwn8WLVKQZ7DWSoEgGBbyyHgk0GmPhXpIAB09FfM8P6/aiVM0BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ebGYRXx8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ebGYRXx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C085C4CED2;
	Tue,  7 Jan 2025 02:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736215236;
	bh=xd0TB5l7JLypNTCYT/J5zFnOVU1YxoxvN/w+0fZpo6s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ebGYRXx8wcArB3opdFoJxwfeW0cuakBJ9rU08WEAcBGJlvmaRuJge7YiMqBw35B8i
	 hP5HMzKrsLF42Wfzha+2UtpRPXKt/cQdgUlmwwdVRUjGBZoFTjyfSKJpK0BkCusac8
	 Q0qlqC4PUcRy0MfsIwchFWiRgsPkx3QHlI1xD+Ra135Wv/fbet2himwkkdQY/n+BM/
	 HGjeU6W5IUNgMvb9QGXFhqHrTFrWepOzPRzUxCzAcCPPa0tswrKedk+KoZS4UtsKQ+
	 TT7MUMShzcpBk60PrgYz64CASmZmU6xvZK+ULJ/QsIZEFfVBsztb4QUpOa39e+ZhHu
	 lt/RRCGp96ygA==
Date: Mon, 6 Jan 2025 18:00:35 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/15] xfs: fix a double completion for buffers on
 in-memory targets
Message-ID: <20250107020035.GS6174@frogsfrogsfrogs>
References: <20250106095613.847700-1-hch@lst.de>
 <20250106095613.847700-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106095613.847700-2-hch@lst.de>

On Mon, Jan 06, 2025 at 10:54:38AM +0100, Christoph Hellwig wrote:
> __xfs_buf_submit calls xfs_buf_ioend when b_io_remaining hits zero.  For
> in-memory buftargs b_io_remaining is never incremented from it's initial
> value of 1, so this always happens.  Thus the extra call to xfs_buf_ioend
> in _xfs_buf_ioapply causes a double completion.  Fortunately
> __xfs_buf_submit is only used for synchronous reads on in-memory buftargs
> due to the peculiarities of how they work, so this is mostly harmless and
> just causes a little extra work to be done.

Tempted to add:

Cc: <stable@vger.kernel.org> # v6.9

though I think backporting isn't strictly necessary because in-memory
buffers don't have log items, right?  If so, then we don't need to cc
stable.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> Fixes: 5076a6040ca1 ("xfs: support in-memory buffer cache targets")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index aa63b8efd782..787caf0c3254 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1656,10 +1656,8 @@ _xfs_buf_ioapply(
>  	op |= REQ_META;
>  
>  	/* in-memory targets are directly mapped, no IO required. */
> -	if (xfs_buftarg_is_mem(bp->b_target)) {
> -		xfs_buf_ioend(bp);
> +	if (xfs_buftarg_is_mem(bp->b_target))
>  		return;
> -	}
>  
>  	/*
>  	 * Walk all the vectors issuing IO on them. Set up the initial offset
> -- 
> 2.45.2
> 
> 
