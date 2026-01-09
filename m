Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A46E5CDF1
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 16:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767975618; cv=none; b=Ol558zb3d+4MAnXie+hIcaQqagK0AxXw0gQgCdKqBHJMAHVKZCmilTzTV1BBQitILaqKoVhH37v/iuaZv644QhFA9fr0aAcuxGwwU6hNKnaT3dkbIeb+a4G7oxoqdUDMLiMRc4tlY3RumYhca8GGfybZ0CH8Uxkn0wx9IMsZd34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767975618; c=relaxed/simple;
	bh=3iWI65kgEt4FnGhbkPOEdYnZV8VLoELM5AKyPlm9+4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A3R9Y3y5o6J/azb/0bA3Ctz2NBD9jXczr5JTTZynEgHrU5LZj1UXr/JwCixMXhRvHkkHHW8XBsJBQS1j41QWk3zkKiK3dcHL9e43NiQ3q4FPRYyoe3/wWb3yhRtGhj9dauZfMBxrbO98K+fXaAwZDWkwcHx0ejVk0qi+o27PlnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ATUC09Si; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ATUC09Si"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CFBC4CEF1;
	Fri,  9 Jan 2026 16:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767975618;
	bh=3iWI65kgEt4FnGhbkPOEdYnZV8VLoELM5AKyPlm9+4o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ATUC09SiBibaWQsIzR3os8H4Sx+eXY8DGCrINdmQqQhyt8tA+ubJrto5Qhmd9GxJJ
	 urrgLowN1NrqlI80qpqjF5Iq4tqglySn7Z97ypT2EJv4XbC8b+7yqoWTWVl8t8PG3E
	 QD8+sXeBxPmMtkgC3KlVaD2KXNzt9dE3uuTN7H75neb//B66dDTrZbXFFjd/XB6S67
	 k0m0VZITIWhPTdqtjSRObXDdKfZRBaypNwzX+8v911mVHor2H5bMbSrJcrhc0stMQB
	 THK8iDLz9mnIWH+sS6JBZWbAMWQhu8pzOXEQeW4d1HigKYAhijX1sGA60QoYPDILeA
	 6VfTIjH12MVIw==
Date: Fri, 9 Jan 2026 08:20:17 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: improve the assert at the top of xfs_log_cover
Message-ID: <20260109162017.GO15551@frogsfrogsfrogs>
References: <20260109151827.2376883-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109151827.2376883-1-hch@lst.de>

On Fri, Jan 09, 2026 at 04:18:21PM +0100, Christoph Hellwig wrote:
> Move each condition into a separate assert so that we can see which
> on triggered.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yes that's really helpful for observability;
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 511756429336..8ddd25970471 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1138,9 +1138,11 @@ xfs_log_cover(
>  	int			error = 0;
>  	bool			need_covered;
>  
> -	ASSERT((xlog_cil_empty(mp->m_log) && xlog_iclogs_empty(mp->m_log) &&
> -	        !xfs_ail_min_lsn(mp->m_log->l_ailp)) ||
> -		xlog_is_shutdown(mp->m_log));
> +	if (!xlog_is_shutdown(mp->m_log)) {
> +		ASSERT(xlog_cil_empty(mp->m_log));
> +		ASSERT(xlog_iclogs_empty(mp->m_log));
> +		ASSERT(!xfs_ail_min_lsn(mp->m_log->l_ailp));
> +	}
>  
>  	if (!xfs_log_writable(mp))
>  		return 0;
> -- 
> 2.47.3
> 
> 
