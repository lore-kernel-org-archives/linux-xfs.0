Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4273981745
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 15:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714406145; cv=none; b=it5tCj2IEBlwccIDHBqvP0aakayRYob6N2/sla5fHCwmAAIvTM1Q/gEIZUb8MdYUVRACeKPYyiVp2Bx7MechiVSQsuyAVS7+74R4vJ4GPEId5Nn5AiVflcmmpsXCfQe+g+b1wHyWeuJBNIiHvNRtjPc15NmdAvBDwAVSlIohmnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714406145; c=relaxed/simple;
	bh=qQfCbXsmHydYULuHizQp3GVthZnwEU3K9w/Qw5GbG4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FdBSQDVbqqRhnL3kncHbjbNTkX2LdgsYWSJxs0RA/WH9onK6Bfw8PUPC09pRdGYJkH5DykzYKkmALMsig3iYh7g7l7HIy18kn8NtzqZ0M1UEzPkIWNWHO3G3dfdvvR0jJtve2NqTVzbsmSZYjk0oxcyfYFoEUyZ8/lDZT8tbNQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jvorMhqs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jvorMhqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E157C113CD;
	Mon, 29 Apr 2024 15:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714406144;
	bh=qQfCbXsmHydYULuHizQp3GVthZnwEU3K9w/Qw5GbG4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jvorMhqsNI3V+qAv4y63DqOQkwqjVKVKt0nOh5mqAdVQGdq8a/g+5yzfFNbf7u6Pf
	 jixvk11ubTakNTr/mg/nEq0Co3Se/wIby6dlch3USuRu3rQ/Rs/PFrsUHyjFCqWZX3
	 a/7kPdaErMQlNIk6GMLySWv4nLJEwm6bKxrTpEDGwj4QcprglDqbqLWCL8W0thZaQP
	 XoN3tMn03ssEpmOr41Ph9nBi/uWMxBsjKYf1hZshnUhBe9fTPlziXfDsSZRtLKNWY3
	 2MmC6WV3zf0a1Gda9/CX+vv6nVkecCmvG2CqzjBQ79zz5YDbxfYQ5Emp2Nnc1JXw/O
	 ICCQ0jVdXxVUA==
Date: Mon, 29 Apr 2024 08:55:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Brian Foster <bfoster@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Sam Sun <samsun1006219@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: restrict the h_size fixup in
 xlog_do_recovery_pass
Message-ID: <20240429155544.GE360919@frogsfrogsfrogs>
References: <20240429070200.1586537-1-hch@lst.de>
 <20240429070200.1586537-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429070200.1586537-3-hch@lst.de>

On Mon, Apr 29, 2024 at 09:01:59AM +0200, Christoph Hellwig wrote:
> The reflink and rmap features require a fixed xfsprogs, so don't allow
> this fixup for them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log_recover.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index bb8957927c3c2e..d73bec65f93b46 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3040,10 +3040,14 @@ xlog_do_recovery_pass(
>  		 * Detect this condition here. Use lsunit for the buffer size as
>  		 * long as this looks like the mkfs case. Otherwise, return an
>  		 * error to avoid a buffer overrun.
> +		 *
> +		 * Reject the invalid size if the file system has new enough
> +		 * features that require a fixed mkfs.
>  		 */
>  		h_size = be32_to_cpu(rhead->h_size);
>  		h_len = be32_to_cpu(rhead->h_len);
> -		if (h_len > h_size && h_len <= log->l_mp->m_logbsize &&
> +		if (!xfs_has_reflink(log->l_mp) && xfs_has_reflink(log->l_mp) &&
> +		    h_len > h_size && h_len <= log->l_mp->m_logbsize &&
>  		    rhead->h_num_logops == cpu_to_be32(1)) {

Same comment about do you want to test for rmap and reflink here?

I also wonder if this multiline predicate should turn into a static
inline helper.  I nearly wrote you one, but then I realize that I don't
remember enough about the xfsprogs problem to know if the problem was
limited to mkfs, or if xfs_repair zeroing the log would also write out a
bad h_size?

--D

>  			xfs_warn(log->l_mp,
>  		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
> -- 
> 2.39.2
> 
> 
