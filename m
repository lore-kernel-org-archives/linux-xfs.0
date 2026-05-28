Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22D9377EC6
	for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 08:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779956457; cv=none; b=hoaa4nUytlxfsydJVJxw/N/FHPWK2B91z6U+U9CEuFj7d7svaYFFub9PnzEMWibN++TlAhr5X47+IPVS1G5ZforV4RSjJJDi+ACwp7HcmkS/KJq8lXP98WABirVL+wthjyKQTcQbBpu4mEi8Fbe4X3LwFm7CAeRXuQgQjCx44eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779956457; c=relaxed/simple;
	bh=AQzXsx1Bke8eIe6QWnLWAwSAjcNimGdMnh7GDHRym78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AN/fl0m2GoigC0RtWWr8KLfESh4JDchfT944rGJX/OEEp10hCv9IXovO6vNrbD4vRYx9G/M+8lOr0CWBnWzWTJlNWNSjKL+kdr9NPfaTINt5dLqbaT4TJZYoCQO1cjhJmtfH5vHQVlaH+ohFVzMkexhpuHAJ6IMFL9RHdntuhyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PH+vhqqv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PH+vhqqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D2B1F000E9;
	Thu, 28 May 2026 08:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779956456;
	bh=Tnh3tp3gRZ1+lCkLeoNB/kntI2bw2xWeD/gORT7wzPM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PH+vhqqvQSn9ZkPIDyynrgeIuWvmVDr0h0FW+n6ST4w96K/94yYG7lQuD41nIdtAF
	 khl3lkCyUsFeQYZ8U8w3430g71UdkTG+AbRraRYATKr1ofH9N/eWiytzm17zu6ATlm
	 yqWmofJA2pQTLsbxSVqmS4DaUUzrj9aF5yxcO0G+Kfebc57fiYgjLXlppHGdnM3tf/
	 cK0yeRGFm42+Hy3cQUCTobI1ZQ+JVLeMnXqVnx/wYOHgmGBG5hDtGfAyv3+yenpolB
	 FONLLI6c5HGYWY+ti3zLDEJV/i+IUzyugYiqGwNKF3WFOnWwxKNAj9a01M4nv8B27K
	 urkirecVyJo0A==
Date: Thu, 28 May 2026 10:20:52 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, 
	Wilfred Mallawa <wilfred.mallawa@wdc.com>, Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: drop the experimental warning for the zoned
 allocator
Message-ID: <ahf6Ahku3KY9W1Gy@nidhogg.toxiclabs.cc>
References: <20260527123941.2319377-1-hch@lst.de>
 <20260527123941.2319377-4-hch@lst.de>
 <4038eaae-4551-4a22-8f75-3b4037a6a5af@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4038eaae-4551-4a22-8f75-3b4037a6a5af@kernel.org>

On Thu, May 28, 2026 at 03:03:41AM +0900, Damien Le Moal wrote:
> On 2026/05/27 21:39, Christoph Hellwig wrote:
> > The zoned allocator has been released with 6.15 on May 25, 2025.  It has
> > seen constant maintenance and improvements and no major issues, so
> > promote it out of the experimental category.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Yeah !
> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> 
> One nit below (feel free to ignore).
> 
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index d964bae096ef..66a02d1b9ad7 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -580,8 +580,6 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
> >  #define XFS_OPSTATE_WARNED_METADIR	17
> >  /* Filesystem should use qflags to determine quotaon status */
> >  #define XFS_OPSTATE_RESUMING_QUOTAON	18
> > -/* Kernel has logged a warning about zoned RT device being used on this fs. */
> > -#define XFS_OPSTATE_WARNED_ZONED	19
> >  /* (Zoned) GC is in progress */
> >  #define XFS_OPSTATE_ZONEGC_RUNNING	20
> 
> Do we want to compact the numbering and change this to 19 ?

I'd agree with Christoph and not reuse the warn number but perhaps I'm
just being overly cautious as we don't have a 'stable' version which
zoned support would be backported to :P

> 
> 
> -- 
> Damien Le Moal
> Western Digital Research
> 
