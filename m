Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D2316F27D
	for <linux-xfs@vger.kernel.org>; Fri,  5 Apr 2024 15:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712331115; cv=none; b=Q8nfLEAKRUswj0WfVT5C+/1fbAxEAHZIw7j7jd5bgIixbKYHXMNUEUCj7JH9KXUWTabYDzmEEJeBR2ivPobcBHo74ChQqsyM6FNSPaIjjHDKUoZ8xTk6RkjDgx59MDWVUkvYJoje+NU6MDuSn+w9EZdHUfWttTalhoPs3vgCgeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712331115; c=relaxed/simple;
	bh=PQIjzd3vRv9Q2V3T0o3/H/zYVz2SWxHh6nnrhSaw0ME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QlH6JHUSo0SAeJWFF1h9pSFIXzp7a7a3T8Ge2ASM/mQvK1MH02OWXPwT83MQpZ1F/m92XrDaEC5kEewkXko6rVMVuNvGzeQGrF9sEfl90LL7hadRALWpb31AYnI9d1A409aPJMC09Quw4bBv2/ZM6CUBUXdaiqzypBeZboDgWmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qx0BW3Gq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qx0BW3Gq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A25C433F1;
	Fri,  5 Apr 2024 15:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712331115;
	bh=PQIjzd3vRv9Q2V3T0o3/H/zYVz2SWxHh6nnrhSaw0ME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qx0BW3Gq9DHwr5muJrKNwBPkjPiibG6ZpbDHbFg2oIiyPVJk6qaJ0Q4LBubdj08ug
	 plO1w/5c3ID4RiZi2ZR3AzTQQVgCVyEIqXwk+3Vrnv3zm2PpLUuyv2R7PQZFbbNNCQ
	 4FG9YANYfBVhonVo4riF2n6aGOQj8lZBNjfpSaC1FEEmRLMFiLPtDrDBQ9dzmCpcnk
	 Mw0idYwEWYxMbb1v3nyDViEA80k9CaWad60OdqY7idWt3hlT1Vh8FpkQeFrYd6w0w/
	 CBO5AtZIKqVoySmdeh77XmnuxkxkasnXDzZbhBrW9KXVYN4Jw6v2DfbV7IsQ25eRfx
	 KJ2bNU6poZS+A==
Date: Fri, 5 Apr 2024 08:31:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: remove the unused xfs_extent_busy_enomem trace
 event
Message-ID: <20240405153154.GY6390@frogsfrogsfrogs>
References: <20240405060710.227096-1-hch@lst.de>
 <20240405060710.227096-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405060710.227096-4-hch@lst.de>

On Fri, Apr 05, 2024 at 08:07:10AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

If only we got compiler warnings about unused tracepoints -- I've been
wondering how many more of these are lurking.

Nonetheless, this looks good so
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_trace.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index aea97fc074f8de..62ef0888398b09 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1654,7 +1654,6 @@ DEFINE_EVENT(xfs_extent_busy_class, name, \
>  		 xfs_agblock_t agbno, xfs_extlen_t len), \
>  	TP_ARGS(mp, agno, agbno, len))
>  DEFINE_BUSY_EVENT(xfs_extent_busy);
> -DEFINE_BUSY_EVENT(xfs_extent_busy_enomem);
>  DEFINE_BUSY_EVENT(xfs_extent_busy_force);
>  DEFINE_BUSY_EVENT(xfs_extent_busy_reuse);
>  DEFINE_BUSY_EVENT(xfs_extent_busy_clear);
> -- 
> 2.39.2
> 
> 
