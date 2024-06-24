Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37FF19B3CE
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 15:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719243704; cv=none; b=GJBWK1LpmbvJyBRvl8nLQCcJG4yGB7lJCRE0ik5UNVNRfsnY7InuLZkmW3HP9IDTQDvvjhQVfAKzc7okGpqj0jjr3oN+qBIEvNLHH9cXXILJNUGqwP/M6NV5LE8nNjLmwPpmiV9oM2FiySPTBuCLGX00b9Ln1cHdQGDrqvzhzFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719243704; c=relaxed/simple;
	bh=n2RSD2EnFu2vw8sBENh4Wn4YM0jwUQwsMP9pr6k2aNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BtGQz6GTedBREFjgrTX4nHUfOJn1pcvIQhwJ4ViuS9fDQCio+q6m9UGdeAiGXaM0z1+KoP9jkPMNIphn3UIFos1s38QkrIrczz7ec7J//K07fCURfM+k6c50Sof0Oh+ogWLyiYJ/a1r0eslef7chCjMs56hkki+esLhfUonsVv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gdKED692; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gdKED692"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23401C32782;
	Mon, 24 Jun 2024 15:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719243704;
	bh=n2RSD2EnFu2vw8sBENh4Wn4YM0jwUQwsMP9pr6k2aNg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gdKED692BY45VQtraVdBcOsoppnU2ixOylKFDZkXzd7LClD+DRluR7mYGJn05krhm
	 A45AyGzS4L/63POVhivzvIgBh1ThfvYyQZmdP8F3GQ8Q9Mdap9MFyCedphFPNgB4GE
	 SxAPZwLkbtTLxRHs1so7zDkaaH+SLYH1yFfZL110CX42Sv0bcs37Xcp+pcRYdHgiHB
	 Jcm9T3qY4tGc3KhooXRN5JAVqUx52CzhdewIMfEQosWJ3RZ2hU1Lh20loLxEp0GanJ
	 4TdPzzrQZVPGOPLVou5SrxV+WjJrYnZKcXXQiruz2BjVspUhk0YfQQUtss7GW/8iSC
	 8KejHIwDeAl2w==
Date: Mon, 24 Jun 2024 08:41:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs: skip all of xfs_file_release when shut down
Message-ID: <20240624154143.GI3058325@frogsfrogsfrogs>
References: <20240623053532.857496-1-hch@lst.de>
 <20240623053532.857496-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240623053532.857496-6-hch@lst.de>

On Sun, Jun 23, 2024 at 07:34:50AM +0200, Christoph Hellwig wrote:
> There is no point in trying to free post-EOF blocks when the file system
> is shutdown, as it will just error out ASAP.  Instead return instantly
> when xfs_file_shutdown is called on a shut down file system.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 7b91cbab80da55..0380e0b1d9c6c7 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1198,8 +1198,11 @@ xfs_file_release(
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
>  
> -	/* If this is a read-only mount, don't generate I/O */
> -	if (xfs_is_readonly(mp))
> +	/*
> +	 * If this is a read-only mount or the file system has been shut down,
> +	 * don't generate I/O.
> +	 */
> +	if (xfs_is_readonly(mp) || xfs_is_shutdown(mp))
>  		return 0;
>  
>  	/*
> @@ -1211,8 +1214,7 @@ xfs_file_release(
>  	 * is significantly reducing the time window where we'd otherwise be
>  	 * exposed to that problem.
>  	 */
> -	if (!xfs_is_shutdown(mp) &&
> -	    xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED)) {
> +	if (xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED)) {
>  		xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
>  		if (ip->i_delayed_blks > 0)
>  			filemap_flush(inode->i_mapping);
> -- 
> 2.43.0
> 
> 
