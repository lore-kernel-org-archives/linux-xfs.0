Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.208
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792673038;
	b=tPXxBGqp1zyAY4vPkrrKtMRhDLv1nXL7CslKbih0lB8qk44ZM0Vv9pp0QYV3Y65DDoOG
	 joVFLoP/p7LWbiykYYpez18lljxlRY9M//LsAjT+kJy971oJ9KQhtd+8Bt9Shv2YueLH+
	 Dp8t7n8m0CWhXAICr2XkdAKc7f6srvh9dTOI3HcvAvQ++hW3SjU+k9Jpt1fZ0nJnqIK4W
	 lJCjClt1cy/Dcx011JNIftmrV3OcugZrr6xvThfjYtwThQtXsZWJ+NAT1YCMxPO2wd+E5
	 mqAIjlJ2jO/HJOj53YrJEyIMsxhIOF9Ep0pUnTX4g0IcP4tnN7sdU8EFO9swa3AzsiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792673038;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=UkGp6BXx3IuoHMShnEhbwsGFOzhfzFScR0VSZnp16i4=;
	b=2YU3BB8DJgj6OY6yQ00xytLNlQPYAusv07z7UKVeradUbbmmShbRjxXenYXUfbYf0etZ
	 dYeMQB+GyrYRLDNRp0bL4xIlnQNcgOORPKMfNYPS1IB0OI+qn91lY5r9mcvu+4vjQdmdu
	 v+tpValdH8RtUCVu++42BhoYYYhq3/pTttRi6t5Ha9wfMsC9pwLpleBtfgtk8H81LC7ZN
	 e/MNq2juHjjBfNTSHJd/PVr1Tl6TIVYjQVhYO05yNIAoaalsLAez12bWa9TFXhVvQNXB3
	 Im6xAP3LwGfLvZQ0Znjf6wDyYtddV0nZ+IoDhFDe4m0PE/cMHzxYpXgmGo93fN4guQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uxw2kJqi;
	arc=none smtp.remote-ip=95.215.58.208
Received: from mta1.migadu.com (out-208.mta1.migadu.com [95.215.58.208])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E740606A319
	for <linux-xfs@vger.kernel.org>; Thu, 22 Oct 2026 12:43:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E740606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uxw2kJqi
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=w2pJzoKE8UHSFd+7kOrW3IFF8LKzi7qBZip0c8TTrbg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792673035; v=1; x=1793277835;
 b=uxw2kJqiiGGHUBaLnBFDFZyIi/7wwupJu8dX2QV9ndJ0t+zO+9wwx9WcXPmZM3OQ2N4r9X6A
 FUzbHWDTLBQsPZosc7IpvZvBTCxkVF4MVaPqtvv2+dBVAMLmmwCzQiO3qPmjHoZU/dqzNtTmi34
 BFHGSMUG8b4EUoTpOfEWaCgQ=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5534752695d82903;
	Thu, 22 Oct 2026 12:43:55 +0000
X-Mizu-Trace-ID: 5534752695d82903
X-Migadu-Flow: FLOW_OUT
Date: Thu, 22 Oct 2026 14:43:50 +0200
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Daejun Park <daejun7.park@samsung.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
	Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Sergey Bashirov <sergeybashirov@gmail.com>, 
	Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v4 2/9] xfs: add a flag to convert unwritten extents
 without allocating blocks
Message-ID: <atoEubjhGZgA2WQk@quentin>
References: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
 <20261020-xfs-pnfs-batch-v4-2-9230fa2ca4a4@samsung.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020-xfs-pnfs-batch-v4-2-9230fa2ca4a4@samsung.com>

On Tue, Oct 20, 2026 at 12:08:45PM +0900, Daejun Park wrote:
> xfs_bmapi_write() with XFS_BMAPI_CONVERT converts unwritten extents to
> written ones, and allocates blocks for any hole or delalloc extent it
> finds in the range. A caller that may only convert blocks that are
> already allocated has to look at the mapping first, and the mapping can
> change once the ILOCK is dropped.
> 
> Add XFS_BMAPI_CONVERT_ONLY. With it, xfs_bmapi_write() stops at a hole
> or a delalloc extent instead of allocating blocks and returns the
> mappings that it converted before it. If the range starts with a hole or
> a delalloc extent, it returns -ENOSR, as it does when a delalloc
> conversion maps nothing in the range. Nothing has been changed then, and
> the caller decides what to do with its transaction.
> 
> A flag of this name was removed by commit 26b91c728b2d ("xfs: make COW
> fork unwritten extent conversions more robust"). That one skipped the
> allocation and still mapped the hole; this one stops before it.
> 
> "xfs: refuse a pNFS LAYOUTCOMMIT of a range without blocks" uses it,
> which is why this is marked for stable.
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Link: https://lore.kernel.org/r/20261013120359.GB2944@lst.de
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 14 ++++++++++++--
>  fs/xfs/libxfs/xfs_bmap.h | 10 +++++++++-
>  2 files changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index ca49bf4a50..95c0178b44 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4130,6 +4130,8 @@ xfs_bmapi_finish(
>   * Returns a negative error code on failure, including -ENOSPC when it could not
>   * allocate any blocks and -ENOSR when it did allocate blocks to convert a
>   * delalloc range, but those blocks were before the passed in range.
> + * With XFS_BMAPI_CONVERT_ONLY, it stops at a hole or a delalloc extent instead
> + * of allocating blocks, and returns -ENOSR if it stops before mapping anything.
>   */
>  int
>  xfs_bmapi_write(
> @@ -4189,6 +4191,8 @@ xfs_bmapi_write(
>  	 */
>  	ASSERT((flags & (XFS_BMAPI_PREALLOC | XFS_BMAPI_ZERO)) !=
>  			(XFS_BMAPI_PREALLOC | XFS_BMAPI_ZERO));
> +	ASSERT(!(flags & XFS_BMAPI_CONVERT_ONLY) ||
> +	       (flags & XFS_BMAPI_CONVERT));
>  
>  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
>  	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
> @@ -4237,6 +4241,9 @@ xfs_bmapi_write(
>  		 * that we found, if any.
>  		 */
>  		if (need_alloc || wasdelay) {
> +			if (flags & XFS_BMAPI_CONVERT_ONLY)
> +				break;
> +
>  			bma.eof = eof;
>  			bma.conv = !!(flags & XFS_BMAPI_CONVERT);
>  			bma.wasdel = wasdelay;
> @@ -4332,10 +4339,13 @@ xfs_bmapi_write(
>  	 *
>  	 * To avoid a successful return with *nmap set to 0, return the magic
>  	 * -ENOSR error code for this particular case so that the caller can
> -	 * handle it.
> +	 * handle it. The same goes for XFS_BMAPI_CONVERT_ONLY stopping at a
> +	 * hole or a delalloc extent at the start of the range, in which case
> +	 * nothing has been changed.
>  	 */
>  	if (!n) {
> -		ASSERT(bma.nallocs >= *nmap);
> +		ASSERT(bma.nallocs >= *nmap ||
> +		       (flags & XFS_BMAPI_CONVERT_ONLY));
Minor nit:

The following might be more explicit here:

ASSERT((flags & XFS_BMAPI_CONVERT_ONLY) ? bma.nallocs == 0 :
                                         bma.nallocs >= *nmap);

Otherwise, the patch looks good.
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>

-- 
Pankaj
