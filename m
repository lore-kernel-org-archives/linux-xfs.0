Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456032DC328
	for <linux-xfs@vger.kernel.org>; Fri, 17 Oct 2025 12:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760704864; cv=none; b=Tj12vKQIXOu6Cw8qb2qRSCACo1JRKswkvjeghULvbMBubzpuQj1wMJJYdAhfLPwzSdta+ZvN+FI0Y8/TKj75IKKhpNnSn7vwWabkoKkKs7Df8a/HRrj8GW9iCcqyYor0g6PT9cGtgOgfyPqcvX42GK5hX13mLgrdKCjLsGUU40A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760704864; c=relaxed/simple;
	bh=zR0c26gqIkeLCwj5eaPX+hiQQY7O2jA2kUcZFse9IiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FHJypuZVz3VcmD6zCQGxKrbpd+iNs0RIdBvTXFM67U0vgkFDHPbcTET+voM2xkUu9mfBMMTvDqh8BmJIhTTCg8zQdQobSWdm8vAR9wzfqgmcxEdpYS1rYpAAxiPO5kpyElEtw0p6zuOl7Tbon6wWOKo6yIXBypi2JYUJDXTsSYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fg/lHW1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fg/lHW1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB8EC4CEE7;
	Fri, 17 Oct 2025 12:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760704864;
	bh=zR0c26gqIkeLCwj5eaPX+hiQQY7O2jA2kUcZFse9IiI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fg/lHW1du+eRBiNygoYs2M5SaedKqC38ugbRXSph8nEjm0l+fg4Yr/kUoon3ZtqnX
	 eKCH5ai1RiRbdsBUJRN+qfSKnvaWAV/DpIs1co32RGBHsskQAIEIrY/MhoG7qOiAgh
	 pRCPVkAYRClM3pec3ehPSNIUhFaKsMZl5vQgZQcGMkPMcIbI3o4mmOuaTq5PXR/xiP
	 g3AR1J3gJMKGag4yvhxxRhgEVvOhtH3stBRBjjYXQ3CmvjG53LRqw3IVXzhn78O4Y9
	 xPsg6aXa2PF3vBLPni26B8FGnYZgKhs0ZSKcKR7mNe5NNDuupb/iP3NnC36hxNMhGP
	 W/jVEwIE8RRig==
Date: Fri, 17 Oct 2025 14:40:59 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: document another racy GC case in
 xfs_zoned_map_extent
Message-ID: <rv7li6ibtbqnoebnp4aclywienqnrtnqnrau42sbbvxscoyzh7@wi3veeulel5e>
References: <20251017060710.696868-1-hch@lst.de>
 <zUuAOMu8B7TdCLjevdEv4NDCds5yicmJNUfZbzPL96uVofCJnseV1G8GSMHLIlvVEI0tq0ck1oU4rtQA1e53-Q==@protonmail.internalid>
 <20251017060710.696868-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017060710.696868-3-hch@lst.de>

On Fri, Oct 17, 2025 at 08:07:03AM +0200, Christoph Hellwig wrote:
> Besides blocks being invalidated, there is another case when the original
> mapping could have changed between querying the rmap for GC and calling
> xfs_zoned_map_extent.  Document it there as it took us quite some time
> to figure out what is going on while developing the multiple-GC
> protection fix.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_zone_alloc.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index e7e439918f6d..2790001ee0f1 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -246,6 +246,14 @@ xfs_zoned_map_extent(
>  	 * If a data write raced with this GC write, keep the existing data in
>  	 * the data fork, mark our newly written GC extent as reclaimable, then
>  	 * move on to the next extent.
> +	 *
> +	 * Note that this can also happen when racing with operations that do
> +	 * not actually invalidate the data, but just move it to a different
> +	 * inode (XFS_IOC_EXCHANGE_RANGE), or to a different offset inside the
> +	 * inode (FALLOC_FL_COLLAPSE_RANGE / FALLOC_FL_INSERT_RANGE).  If the
> +	 * data was just moved around, GC fails to free the zone, but the zone
> +	 * becomes a GC candidate again as soon as all previous GC I/O has
> +	 * finished and these blocks will be moved out eventually.
>  	 */
>  	if (old_startblock != NULLFSBLOCK &&
>  	    old_startblock != data.br_startblock)
> --
> 2.47.3

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
