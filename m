Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DB91BC3C
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 03:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712115964; cv=none; b=S7+lgxmfDVTTNgdzbngBm0cimlg9FA0TqtcSPX4odvrGlxzAODvn9nXHALrbCotncAfUo0SWaIa7kOENT5jLxv04VQqsdflLe+8NbDUsIuHAI/lxNsKXz5w1KA27zjAvcfJlsCu2g3fxiHJ2JghEAQKr875ZnWS21ZseSnV00XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712115964; c=relaxed/simple;
	bh=92avr28a42XoqQP3ukWY56khd9qKjFOreWS7YJDtmqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rFS4c8Go0XhtNEQey9ZAvfEseIfQXI4tKs6NbZd69xO5dXDxurXsZUhCYy1F6CoGYCyvpbrp95RwYGA5fsiUlHO2xrMTLMHzN1VrkUCA4KyyfVilRTtVGzsCfJrBx5yytBcq8yJDU0nTD62cCwIONuvBYdLkBI4MnEeaQplB73I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fh+S7fS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fh+S7fS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C67AC433C7;
	Wed,  3 Apr 2024 03:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712115964;
	bh=92avr28a42XoqQP3ukWY56khd9qKjFOreWS7YJDtmqg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fh+S7fS+ohUVmsWjIVLcJzZBUiaAWriFhVsHhGzL6WwZwKSIq7DFCOvYDOEnSGX29
	 CEiY214/uUB7ilAFKaLCsfdo2MCH6EddYTVSA58v748TIpnUM1TBPamk+eZBJWKaqr
	 SmF/VLqXxLO5Ynh/53g7qogb3IrkAOJCyAqPBTk91XiBREJfk/32V+nJ0Pfjckz0wq
	 PSfN61ywox8c8CzFx1F4E/7VdQpiqiL6gtMeTdWE/sOMWZ402QQaBocgq6xrmDtoVp
	 wo1EU24JOHsMzgzcmJON3C1N13DrKgytrJwpajUX7UJuJWbiBmOatFJACXXMG7IbGr
	 VeTR8I6gTbU9w==
Date: Tue, 2 Apr 2024 20:46:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfs: xfs_alloc_file_space() fails to detect ENOSPC
Message-ID: <20240403034603.GJ6390@frogsfrogsfrogs>
References: <20240402221127.1200501-1-david@fromorbit.com>
 <20240402221127.1200501-3-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402221127.1200501-3-david@fromorbit.com>

[explicitly cc hch]

On Wed, Apr 03, 2024 at 08:38:17AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_alloc_file_space ends up in an endless loop when
> xfs_bmapi_write() returns nimaps == 0 at ENOSPC. The process is
> unkillable, and so just runs around in a tight circle burning CPU
> until the system is rebooted.
> 
> This is a regression introduced by commit 35dc55b9e80c ("xfs: handle
> nimaps=0 from xfs_bmapi_write in xfs_alloc_file_space") which
> specifically removed ENOSPC detection from xfs_alloc_file_space()
> and replaces it with an endless loop. This attempts to fix an issue
> converting a delalloc extent when not enough contiguous free space
> is available to convert the entire delalloc extent.
> 
> Right now just revert the change as it only manifested on code under
> development and isn't currently a real-world problem.
> 
> Fixes: 35dc55b9e80c ("xfs: handle nimaps=0 from xfs_bmapi_write in xfs_alloc_file_space")

Shouldn't Christoph be cc'd if you're reverting his patch?

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 19e11d1da660..262557735d4d 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -735,19 +735,13 @@ xfs_alloc_file_space(
>  		if (error)
>  			break;
>  
> -		/*
> -		 * If the allocator cannot find a single free extent large
> -		 * enough to cover the start block of the requested range,
> -		 * xfs_bmapi_write will return 0 but leave *nimaps set to 0.
> -		 *
> -		 * In that case we simply need to keep looping with the same
> -		 * startoffset_fsb so that one of the following allocations
> -		 * will eventually reach the requested range.
> -		 */
> -		if (nimaps) {
> -			startoffset_fsb += imapp->br_blockcount;
> -			allocatesize_fsb -= imapp->br_blockcount;
> +		if (nimaps == 0) {
> +			error = ENOSPC;

-ENOSPC.

--D

> +			break;
>  		}
> +
> +		startoffset_fsb += imapp->br_blockcount;
> +		allocatesize_fsb -= imapp->br_blockcount;
>  	}
>  
>  	return error;
> -- 
> 2.43.0
> 
> 
