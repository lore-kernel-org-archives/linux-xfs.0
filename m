Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA3F455638
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 10:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789036855; cv=none; b=TTRWLSkzTLCBqck2LmN7vZIf33cv/6R6dOXBB2mc06ksqsLYNveLDv+ql2lUkqTzJLTk0l/AF7lTrCTLMhkKmVikB0d3HNK/oKe/RrVBRUG18OOWLz5kUvdX9SQZGVmUUZ45WqUmlr3u4KxFgxTNj+YzcxsirBVVVmFOeGj/9Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789036855; c=relaxed/simple;
	bh=LDJG0nPjeoT+MCcUtbFCO2gWsKjQAnZ4dusSE5TU2AQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NhYgUp3/qWrxN/sOva8v2BfFCpgTW9xCdLNT3rbiLtn1iuM2vkQvj7gWAIs+EsHeM7ftVk5LeK2Bga4xTjwDXB1Y708+TExUMBq+RSFDEuwCmbPJn4c9xkN36PsC9w3ylBzUUpiKDOTwgneE5qZpxEXyjfjOvZwQLZo7pOY/AHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VBkhlVlU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VBkhlVlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876AF1F000FF;
	Thu, 10 Sep 2026 10:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789036853;
	bh=ua6xWXTyhqfX8IEq3GyZ+wTgmiaf1zRFh6iBlcPSHP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VBkhlVlUIW05O1e4yO5Et7VpQUZrHRaEqE24+DYXvVY3u6a2l9sJ8htCp9eKYNH9J
	 OQve5KB24LfHPvQ3oMBwJrWfA5oMAbUoOdpspgQdn1TSSF0D6fEJjyNA5ddhWSeIrC
	 /1J1QmJklaAfWtuHnJMkHKMYswqiw+AeMQ9pjY6xsccnKGFDxY2BfcWd/DEfFW1xgE
	 KygFwh4Gbo23/jonERtrSYEO0ZZJJB9OKjT+eMIfEz+k3Z7oGDto/2JCC+Eyfq7fsU
	 njkszxhFgqq2TCdxqgKunO8MIUbru9voGAqeyTOHQF0N4vEznrztg5UO7xdG+gUe2L
	 UnMntyy14Y3jw==
Date: Thu, 10 Sep 2026 12:40:50 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 2/3] xfs: don't continue on error in xfs_fsync
Message-ID: <aqKJKvmUoZy-Q8gE@andromeda.toxiclabs.cc>
References: <20260907073427.719935-1-hch@lst.de>
 <20260907073427.719935-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907073427.719935-3-hch@lst.de>

On Mon, Sep 07, 2026 at 10:33:08AM +0300, Christoph Hellwig wrote:
> As soon as we get an error from cache flushing or log forcing, there
> is no point in continuing as the data integrity is already impacted.
> Return the error instead of continuing to do more work.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/xfs/xfs_file.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 426a67b813a7..0d31fea67a2c 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -130,8 +130,8 @@ xfs_file_fsync(
>  {
>  	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
>  	struct xfs_mount	*mp = ip->i_mount;
> -	int			error, err2;
>  	int			log_flushed = 0;
> +	int			error;
>  
>  	trace_xfs_file_fsync(ip);
>  
> @@ -154,15 +154,17 @@ xfs_file_fsync(
>  		error = blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
>  	else if (mp->m_logdev_targp != mp->m_ddev_targp)
>  		error = blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
> +	if (error)
> +		return error;
>  
>  	/*
>  	 * If the inode has a inode log item attached, it may need the journal
>  	 * flushed to persist any changes the log item might be tracking.
>  	 */
>  	if (ip->i_itemp) {
> -		err2 = xfs_fsync_flush_log(ip, datasync, &log_flushed);
> -		if (err2 && !error)
> -			error = err2;
> +		error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
> +		if (error)
> +			return error;
>  	}
>  
>  	/*
> @@ -178,14 +180,11 @@ xfs_file_fsync(
>  	if (!log_flushed) {
>  		struct xfs_buftarg *file_targp = xfs_inode_buftarg(ip);
>  
> -		if (mp->m_logdev_targp == file_targp) {
> -			err2 = blkdev_issue_flush(file_targp->bt_bdev);
> -			if (err2 && !error)
> -				error = err2;
> -		}
> +		if (mp->m_logdev_targp == file_targp)
> +			return blkdev_issue_flush(file_targp->bt_bdev);
>  	}
>  
> -	return error;
> +	return 0;
>  }
>  
>  static int
> -- 
> 2.53.0
> 
> 
