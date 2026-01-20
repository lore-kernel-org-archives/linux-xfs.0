Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D88E314D3F
	for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 17:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768930280; cv=none; b=DmWkR+BJixP3AFd7ZanI/6t+FJ7I+oMjY6p0Ll2ZgTRgaXg6NcC5XLPIwTwGSVhevydMKafFdvxjxdLah/Xu4IOHqygfOTkMiNCDlIiRMK1Q9yCaVc738v9oDv5+Pmock+al5Sw6B71eF7EALUP8GjHmEEwKPBVLNzOYt1XWclU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768930280; c=relaxed/simple;
	bh=v7QSd+oLWueG4i84CVgl9lG8Swc1CRyse5IWPSCB0C4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uDz9JTR8185scBz37pxanubIwtoW4//LN3rDo50ud+kBH5W8c7C3GA3qh/q2Mfuef/2Qn3OSJEJFlTMJDVnIk5ZFfdkLC8SUAQvSZ0deSHJQ/R9HBcn5pgVL07vH+FhnE/CR6xZ7ANNPsZa0PyFE68VGCLQQNB36wv3aF8yLvlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJXvcXzd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJXvcXzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7063C16AAE;
	Tue, 20 Jan 2026 17:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768930279;
	bh=v7QSd+oLWueG4i84CVgl9lG8Swc1CRyse5IWPSCB0C4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BJXvcXzdRv+Gn2KNO1OIGXunMYG2gNcPnh7pvs6Bj2yt1/92GVPG5gjDqzAu0s8p8
	 Q9zB7tBTo+OvTQ31+6/j2/lkNSOs/vFbZAuEiQXkLvzypH/mIRHR0nhb6boQc3jQ+H
	 warTm1lO2gB4iM8sIyUuT7of4TliS7jLr0u2GJ1dGt4cWjCaJRRdb1QdyTXsxfp20B
	 L2izr4RRwiicI8H782QtS8syRGa38aetW3sZBTy2ypQUMuW451bJLJvuacHKXlfbJJ
	 ybSM6NnZ4w2bk8mAHtGswcMmlj+fg9mReHEpOFvX5/AGxMTIIrNaOJINpX1KoeNFOo
	 D5yXQ5CjbGBRA==
Date: Tue, 20 Jan 2026 09:31:19 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/4] xfs: use blkdev_report_zones_cached()
Message-ID: <20260120173119.GS15551@frogsfrogsfrogs>
References: <20260109162324.2386829-1-hch@lst.de>
 <20260109162324.2386829-2-hch@lst.de>
 <yw6bc76kuh56avbb5nxlvdkrattk57s5z65defzbdoohp5wtvt@h346oio32jdk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yw6bc76kuh56avbb5nxlvdkrattk57s5z65defzbdoohp5wtvt@h346oio32jdk>

On Tue, Jan 20, 2026 at 03:28:29PM +0100, Andrey Albershteyn wrote:
> On 2026-01-09 17:22:52, Christoph Hellwig wrote:
> > From: Damien Le Moal <dlemoal@kernel.org>
> > 
> > Source kernel commit: e04ccfc28252f181ea8d469d834b48e7dece65b2
> > 
> > Modify xfs_mount_zones() to replace the call to blkdev_report_zones()
> > with blkdev_report_zones_cached() to speed-up mount operations.
> > Since this causes xfs_zone_validate_seq() to see zones with the
> > BLK_ZONE_COND_ACTIVE condition, this function is also modified to acept
> > this condition as valid.
> > 
> > With this change, mounting a freshly formatted large capacity (30 TB)
> > SMR HDD completes under 2s compared to over 4.7s before.
> > 
> > Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> > Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  include/platform_defs.h | 4 ++++
> >  libxfs/xfs_zones.c      | 1 +
> >  2 files changed, 5 insertions(+)
> > 
> > diff --git a/include/platform_defs.h b/include/platform_defs.h
> > index da966490b0f5..cfdaca642645 100644
> > --- a/include/platform_defs.h
> > +++ b/include/platform_defs.h
> > @@ -307,4 +307,8 @@ struct kvec {
> >  	size_t iov_len;
> >  };
> >  
> > +#ifndef BLK_ZONE_COND_ACTIVE /* added in Linux 6.19 */
> > +#define BLK_ZONE_COND_ACTIVE	0xff
> 
> hmm I think #ifndef doesn't work for enum member. Compiling against
> linux 6.19-rc6: 
> 
> ../include/platform_defs.h:311:33: error: expected identifier before numeric constant
>   311 | #define BLK_ZONE_COND_ACTIVE    0xff
>       |                                 ^~~~
> /linux-headers-v6.19-rc6/include/linux/blkzoned.h:84:9: note: in expansion of macro ‘BLK_ZONE_COND_ACTIVE’
>    84 |         BLK_ZONE_COND_ACTIVE    = 0xFF,
>       |         ^~~~~~~~~~~~~~~~~~~~

I hacked around this very crudely:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/commit/?h=djwong-wtf&id=d5d9b4bd2da95c7b9429112f1c1098a62f155270

Though I think one of hch's fix patches fixed that.  I cannot post a
lore link because the #@!%)*&!%!!! anubis b@%#%!!! is completely broken
and will not let me in.  But we did the review for the kernel-side fixes
within the last couple of weeks.

--D

> 
> -- 
> - Andrey
> 
> 
