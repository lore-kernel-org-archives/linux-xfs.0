Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0F4343888
	for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 05:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779945251; cv=none; b=cv00myM37r/GriB9Y4mKzknoBRIILYYd7+vYAniPU7YogZeDxqYlcUqPKqOGobBt+QrjiQSO7rcq9CSTcLe6O1nI8qdx+hYkdRTDfZKSPpQH4nLF5iFKnwTsjxPuX7exhGdD66P09DS8Qv63J7w4SAgp20FBU4SMKkeNAXkQWos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779945251; c=relaxed/simple;
	bh=9OtKVb8N4Dxlk1u7FKx/1Ueim89wS78rDyzvJRudME4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f1vQFLXnDwUdKRNiBSgGtSKsl8/XmqsFWCxsEZ+PlfEZXVQCMWzo0JMLMNyVppetsFAXZ1xxuQewlwVBYTkvNjRXK0wIto2kHziK63dNOEBCJSUqAQqanScf59H3HbayX9AuqmmBoNhLsRJYjnBWWHUoGzYP8qZBPWzVCv1xhLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=djqU26Kf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="djqU26Kf"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6CA361F000E9;
	Thu, 28 May 2026 05:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779945250;
	bh=14bN99RH1D7Juv7COJeVolGX+8mRFEGXCnk/aHO+Pws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=djqU26Kf4hwIJbyTQqz5MThYFVHXFdzyuczqzqhZsyRffP3wrVfAabSgP6tg+KyBH
	 l9SGFnYv9l0a1/rk6kVG2bUnDaBKpBhel3fC6baB/bP6ovkjWN+NG6qf2tnvgs2u6B
	 kVQJkyILdS9GG+4Uc6QR1a7fEZrN9V6RJT+3SFWx8emF60K5SaT+4q8k23e3Qc5GtD
	 e/5pfrCjQ90tQUBrQDErfmdYYW5gBLutjemiyIl3IlqENjL3fxEJMCaz4QUcqU+ND3
	 M7nH7X7GI1jBvpUnI1Lagn9YDlsKXPd8ifXvjJC0yGxY91ArvytxLDnESIssdPzznd
	 gx+EIohQjHCPA==
Date: Wed, 27 May 2026 22:14:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: abort mount if xfs_fs_reserve_ag_blocks fails
Message-ID: <20260528051410.GI6078@frogsfrogsfrogs>
References: <20260527123243.2316101-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527123243.2316101-1-hch@lst.de>

On Wed, May 27, 2026 at 02:32:37PM +0200, Christoph Hellwig wrote:
> xfs_mountfs currently ignores all errors from xfs_fs_reserve_ag_blocks,
> which can lead to the mount path continuing on corruption errors.
> Fix the check to only ignore -ENOSPC as in other callers, and unwind for
> all other errors.
> 

Cc: <stable@vger.kernel.org> # v5.14

> Fixes: 81ed94751b15 ("xfs: fix log intent recovery ENOSPC shutdowns when inactivating inodes")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yeah, we shouldn't be continuing the mount when weird errors happen.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_mount.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index b24195f570cd..7aa51826b1ca 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1149,9 +1149,12 @@ xfs_mountfs(
>  	 * blocks.
>  	 */
>  	error = xfs_fs_reserve_ag_blocks(mp);
> -	if (error && error == -ENOSPC)
> +	if (error) {
> +		if (error != -ENOSPC)
> +			goto out_rtunmount;
>  		xfs_warn(mp,
> -	"ENOSPC reserving per-AG metadata pool, log recovery may fail.");
> +"ENOSPC reserving per-AG metadata pool, log recovery may fail.");
> +	}
>  	error = xfs_log_mount_finish(mp);
>  	xfs_fs_unreserve_ag_blocks(mp);
>  	if (error) {
> -- 
> 2.53.0
> 
> 
