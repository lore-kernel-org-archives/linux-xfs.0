Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E90634B18E
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 15:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771516623; cv=none; b=iGdwd2d7Na7Rbb6JBRuUN+1h2sPEAR/4+aIjnDkajQVkU/b4ehDbY5rCOp3pTK6gOwgRzK5OX5ROXpL5ttEypI4vU2sC19p36Vt0dL+SB6ITo3dX6EUOXTeojJ2OXilTRqno4D2wDCOLtxsPJnaQ+MtYkdVsr1rSb5g1jcWjsoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771516623; c=relaxed/simple;
	bh=pOcCucH2QQgxNtYfhrBvaiZVty5VGkPO9bM392oQxpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C1HOeUvnfKGTbMWT7jCvqOfUkpwzisILgQ72Wf6oyPYKbZTYXBtwGMn4cml7F/4WpFQUy6VRBBWG8dP+QZgpK3CEqSY6zQuuQHzJvUGfi/6TbDa5GkzmTLVBWfAr6HJsQxFm5akieClj4s8vsVItuiebo85N6Rf3olYknJIQyi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RsU654ES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RsU654ES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3135C4CEF7;
	Thu, 19 Feb 2026 15:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771516622;
	bh=pOcCucH2QQgxNtYfhrBvaiZVty5VGkPO9bM392oQxpI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RsU654ESon3ooSw7J7WXveYBmUMKB3O5kIALf9TsLzOWNM2+Nm3by+Ck1po1fhNkb
	 VpYBtwcKdOr6w8s7tqbnAR9tSImbPJVVdWIayMo9VOTciLnL+qn6/IZFOi9QXBgaVx
	 ZaV+08RJY8Vg5UGB5u2eTKkQCddwQqYoUhbcgGyXszVit/hOfjjsym2kNlC0Tq7J14
	 ILNBW84eOhdVw7A+KvdhKtza10kc1WBuQpy7Qx5QLtjeUoO7j2OPgSt/hDKGJIb2hM
	 ktouwce0TRC8h6sXlGN7/rNwlryn1dbKcqfLz9u7SIFEoILlSBUDKdtOOux/8wOTRz
	 jvmLR3cNBpzlA==
Date: Thu, 19 Feb 2026 07:57:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
Cc: hch@infradead.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	nirjhar.roy.lists@gmail.com
Subject: Re: [PATCH v3 3/4] xfs: Update lazy counters in
 xfs_growfs_rt_bmblock()
Message-ID: <20260219155702.GH6490@frogsfrogsfrogs>
References: <cover.1771512159.git.nirjhar.roy.lists@gmail.com>
 <8b7290dbe12fccd57b317562de68cf77ec670d96.1771512159.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b7290dbe12fccd57b317562de68cf77ec670d96.1771512159.git.nirjhar.roy.lists@gmail.com>

On Thu, Feb 19, 2026 at 08:16:49PM +0530, Nirjhar Roy (IBM) wrote:
> From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> 
> Update lazy counters in xfs_growfs_rt_bmblock() similar to the way it
> is done xfs_growfs_data_private(). This is because the lazy counters are
> not always updated and synching the counters will avoid inconsistencies
> between frexents and rtextents(total realtime extent count). This will
> be more useful once realtime shrink is implemented as this will prevent
> some transient state to occur where frexents might be greater than
> total rtextents.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>

This makes sense to me, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

But I have one more question: does xfs_growfs_rt_zoned need this
treatment as well?

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index decbd07b94fd..9d451474088c 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1047,6 +1047,15 @@ xfs_growfs_rt_bmblock(
>  	 */
>  	xfs_trans_resv_calc(mp, &mp->m_resv);
>  
> +	/*
> +	 * Sync sb counters now to reflect the updated values. Lazy counters are
> +	 * not always updated and in order to avoid inconsistencies between
> +	 * frextents and rtextents, it is better to sync the counters.
> +	 */
> +
> +	if (xfs_has_lazysbcount(mp))
> +		xfs_log_sb(args.tp);
> +
>  	error = xfs_trans_commit(args.tp);
>  	if (error)
>  		goto out_free;
> -- 
> 2.43.5
> 
> 
