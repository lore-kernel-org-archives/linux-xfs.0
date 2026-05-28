Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BB5379980
	for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 08:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779956637; cv=none; b=XLvJpDugwf17/XcHZM3kuKjLasPPSqoZy/PE5QSSebwHRPzxJibWRVbnxQJqZBRpnMlneAVBGFAJL24sdYN8HucmsRtqnNJZ0w0rHbfWsZA+072vfdYLii+E+KzX3uowzoX/juMCP1hsIo3ilaf1QBZHE95S0t8yw6vsBHGnt7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779956637; c=relaxed/simple;
	bh=wYhUSOPF5qqV66cf1v59MeyHX4GfUhX7DRwZYTJZqQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KMsIXCr0OURYnTBiFYrn1A5xlsFoe5XC2FIyaIZpy4wOCOgwAkd5g7d+V/lC9l8AICzb1FNTs/4xvV1zJEMmIFh2ToMyaolPkUFpurnETBfN+s1W2DgcTjBv0DHvQoaeOsLu8VKbzbC23q4iZZuv4RJTZsuiw4ydibKwxwLi9R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JwNTprlZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JwNTprlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BF11F000E9;
	Thu, 28 May 2026 08:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779956632;
	bh=tf7SNuIOE0pTOoBLII0Z5Cq9SNBWVo+zFvnjYHNwVnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JwNTprlZMTJsgvRAW4H+VHpU05Z7/XQyV8x8LZP5cbccSsbzKm9BP/48xqNCAvufl
	 PrpDhEx19Aq41I/p7TFKuT1hZUERT5DhsmeIu5XXFJHNfza5rMWieppy2e3gvt7Wp2
	 dp0A9FjBqk0VexxwD1L07i8R574wrgPevpJ6EZdGpKvUFMgdKXyTs+WziL3fDyFNa9
	 vxI8/HXOWFYLCJiB6GT4uCn6otdVRowJzoP8Y78o3Pdo/wEcK1EVJdw4UFB344gFJE
	 3fC3WMLpAsDnJAb6XTqH2um1MSeqQ28nuQN4pmJJnXinUyjgqof0KaUM5R2Fp9t46o
	 9vwJ9bMEOBHVw==
Date: Thu, 28 May 2026 10:23:48 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: abort mount if xfs_fs_reserve_ag_blocks fails
Message-ID: <ahf7jeQcRwEhkgWC@nidhogg.toxiclabs.cc>
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
> Fixes: 81ed94751b15 ("xfs: fix log intent recovery ENOSPC shutdowns when inactivating inodes")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

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
