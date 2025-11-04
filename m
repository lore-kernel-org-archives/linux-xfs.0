Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551AF2D8DD3
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 23:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762299934; cv=none; b=jwNy4c49PV569GPOV+SnI1Maz6O7kvaDvQ/CNWqoIwiABrgrrU8q65Od31EC31UZjDLBYLEktunBMvj0zAKXEoBWEXuQ7RFRLhd6f+4YCLtbdz9c+bt+FVYTPpqjalG9R0DBJ8MM2rzkGrUmN6Gcbw6hxGQaYV86BrV/P6keBkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762299934; c=relaxed/simple;
	bh=YYYtA3I5UnRakWulbISXSy8PKGBU7FIq0Tjj3XUDveo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fDjec/VF3LgsI8CNQZc4XcuddyQXx7H9+f3+qS/amjXCG60qFZFlm1D18FXDcPvm+etFrhXqQy5DwqXt6ox5B88kmSRj0ykL/ztP+N3VK4QPO1zVucatbBbR4P2gvOJvdrFbf98yEX46UklaCEm4TawwhmPf+K06XF/FqsEeI2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P/QuC0mX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P/QuC0mX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3101AC4CEF7;
	Tue,  4 Nov 2025 23:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762299934;
	bh=YYYtA3I5UnRakWulbISXSy8PKGBU7FIq0Tjj3XUDveo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P/QuC0mXrxWB7rTb1KFQxnTy0KMa2qijRY1uE/a061ntLRphJB8fvWMx7Q5CgH9R1
	 Ci18Wy5DPSQ3Ks2WZ9wuV1jHyggB7WPBqztt97mLUNxc7ha4yMP5NMzXEbGYqsq837
	 b28Evzwf23IRxjdBb1Aad+ySAIeKGgl1RMVtJ88mc3S4pgV5r3CinMIHOFB4E71cd8
	 89WV4uqcLs8ZZW88R4GfAO0LXpcz2PwQb8M8OPP6qAinNqQFCeMZpSFuYylcahOwvJ
	 Sa2upB2/+TmpYa6CMWhNbMqMMt6Rjzz+CwA5DPneG4xOvkL46bCU7r9q/QBYd/ynw/
	 pvdcZ+1YIjY7g==
Date: Tue, 4 Nov 2025 15:45:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs: improve the iclog space assert in
 xlog_write_iovec
Message-ID: <20251104234533.GR196370@frogsfrogsfrogs>
References: <20251030144946.1372887-1-hch@lst.de>
 <20251030144946.1372887-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030144946.1372887-10-hch@lst.de>

On Thu, Oct 30, 2025 at 03:49:19PM +0100, Christoph Hellwig wrote:
> We need enough space for the length we copy into the iclog, not just
> some space, so tighten up the check a bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 7c751665bc44..8b8fdef6414d 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1889,7 +1889,7 @@ xlog_write_iovec(
>  	void			*buf,
>  	uint32_t		buf_len)
>  {
> -	ASSERT(xlog_write_space_left(data) > 0);
> +	ASSERT(xlog_write_space_left(data) >= buf_len);
>  	ASSERT(data->log_offset % sizeof(int32_t) == 0);
>  	ASSERT(buf_len % sizeof(int32_t) == 0);
>  
> -- 
> 2.47.3
> 
> 
