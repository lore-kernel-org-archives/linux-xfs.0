Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89285391833;
	Mon, 17 Aug 2026 07:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786950585; cv=none; b=FOw1vC/x1vNkrbgDdGCmVg6FGvtvArOCsT6NXaBjaXfgaFaMuQ/5aSF3uO1Y6vLw34VkjLzQky08StW25uc5SfsKMayFB4hHh77uXf7sQ/RYtEtPwdeP8UUONSl3a7aBKEK0njUoDvx8GlAAS+RSrXIpJh2GtoXeF7kr8MOuh/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786950585; c=relaxed/simple;
	bh=yiqNUM6N45B5uZLBMXomQWei/LLZ40SJchQMe68ZhHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YJfje1sxjds9ncpws4/iYl6IX+v1gsIrIF8ozcQY5pt+vQUb/y8ADOdHBsLNsw1yp5CyBoesUzQiqCuLLxxtDYejf8prRaMSZjezSIVUkMl7G5JMw6Ss1viv5jnY9leBwGnYkY/Kf0LZQmw2rlu++t0kpjk2QiWWHxUF/YC36k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DEC2F68CFE; Mon, 17 Aug 2026 09:09:39 +0200 (CEST)
Date: Mon, 17 Aug 2026 09:09:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: djwong@kernel.org, ebiggers@kernel.org, hch@lst.de,
	Jens Axboe <axboe@kernel.dk>, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
	david@fromorbit.com, Tal Zussman <tz2294@columbia.edu>
Subject: Re: [PATCH v15 18/25] xfs: make xfs_free_eofblocks() work with
 fsverity inodes
Message-ID: <20260817070939.GB17371@lst.de>
References: <20260814092448.1818082-1-aalbersh@kernel.org> <20260814092448.1818082-19-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814092448.1818082-19-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Aug 14, 2026 at 11:24:35AM +0200, Andrey Albershteyn wrote:
> xfs_free_eofblocks() removes any preallocations and unwritten extents
> beyond EOF.

This reads a bit confusing.  I simple removes all extents past EOF
unless the XFS_DIFLAG_PREALLOC or XFS_DIFLAG_APPEND flags are set.

> Add XFS_BMAPI_UNWRITTEN and change xfs_bunmapi_range to remove only
> unwritten extents sitting beyond EOF and set it for fsverity inodes.

Maybe split that from the use of this flag for fsverity?

> -	while (unmap_len > 0) {
> -		ASSERT((*tpp)->t_highest_agno == NULLAGNUMBER);
> -		error = __xfs_bunmapi(*tpp, ip, startoff, &unmap_len, flags,
> -				XFS_ITRUNC_MAX_EXTENTS);
> +	while (startoff < endoff) {
> +		nimaps = 1;
> +
> +		error = xfs_bmapi_read(ip, startoff, endoff - startoff + 1,
> +				&imap, &nimaps, read_flags);
>  		if (error)
>  			goto out;

This gets us extra lookups in the iext tree, which is a bit annoying.
I'd pass the new flag down to __xfs_bunmapi and skip non-unwritten
extents there.  That should also be less code and less churn than
trying to do that in the caller.

