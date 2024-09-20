Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2361A1E87B;
	Fri, 20 Sep 2024 14:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726841810; cv=none; b=Twnp2uOFfdlZgD9WLC98J6b8WoUO0fdgdbFvUHQotqyJUwyM1sL+HPW1gjtlQ/ZApGYDjFtgeYyyJ5Mclqkl52DYSJ8CEKDOGAVkBDXV5mjyCKJx61q/yqLeV9bhv5dllGOZq8mLMEOC5sNaKlqnFZR6F1pcQEARmcHe+/0wVPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726841810; c=relaxed/simple;
	bh=LFSR1KM6NBNg/EUxYxK5zFLouHs+EvtpS181cfnIPTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QOmHu2Ob5URy/k4Zmh1UwJ6RAHz4rD1PsSYUO0+0CFKrYbTNgE09mTouTbihFQH9kH9Gj9qvebo3N9PFD5QoNIjzrcSHh3JcTnovGMoQ5dGZebg3H4t+t5PqR7jaGr77k9bd2Do006OqxGOYM304sa1ZFCPMz9tS56o1U4eO49E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b4BCuSKL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b4BCuSKL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5QVqlGwC2x1bl9KnAIFHQcujnfGAKS+hUr0XeTHqPS8=; b=b4BCuSKL/UOUDX+/Ta3zTEB4Zd
	lpxG8KlMm0D2qb38byctbh4oXMj4Ua8HoKl4YxFFQ2cBuTmVJCrBu1UmRYdLdVOBh6Aw7P9bKTzJ/
	0/SzqHSlhrKfN2PtbstGpWyCYwbcqvY/EwsqjgRZ/PVBkRy2A8xi0yMLfPzCte0AnOxuTT0bBqeRR
	OqbbKwrP9ggEXrSSXYaqsCKZe0H3TaExrRfUL4jpDK0Je4DLTcqhMdpcZjVhrnQjodigfvNDYg1IL
	6rK40/v97n2f5buxBx3WzovXeTQhwZohFynwr9EUsXeW9kFQrjGsg25aYWT65qcNPkO+ipHFFsoCp
	YDaQEL/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1sreRE-0000000CMO9-1uDN;
	Fri, 20 Sep 2024 14:16:48 +0000
Date: Fri, 20 Sep 2024 07:16:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH] xfs: Use try_cmpxchg() in xlog_cil_insert_pcp_aggregate()
Message-ID: <Zu2D0AamCdaTUUhZ@infradead.org>
References: <20240919081432.23431-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240919081432.23431-1-ubizjak@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Sep 19, 2024 at 10:14:05AM +0200, Uros Bizjak wrote:
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -171,13 +171,12 @@ xlog_cil_insert_pcp_aggregate(
>  	 * structures that could have a nonzero space_used.
>  	 */
>  	for_each_cpu(cpu, &ctx->cil_pcpmask) {
> -		int	old, prev;
> +		int	old;
>  
>  		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
> +		old = READ_ONCE(cilpcp->space_used);

Maybe it is just me, but this would probably look nicer if the cilpcp
variable moved into the loop scope, and both were initialized at
declaration time:

		struct xlog_cil_pcp	*cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
		int			old = READ_ONCE(cilpcp->space_used);


>  		do {
> +		} while (!try_cmpxchg(&cilpcp->space_used, &old, 0));

And this also looks a bit odd.  Again, probably preference, but a:

		while (!try_cmpxchg(&cilpcp->space_used, &old, 0))
			;

looks somewhat more normal (although still not pretty).

Sorry for not having anything more substantial to see, but the diff
just looked a bit odd..

