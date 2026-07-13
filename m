Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F8137A84A;
	Mon, 13 Jul 2026 10:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783937060; cv=none; b=Ju7Qq5LM5zThghY/yX3HWfhA1W8DPMv5j22Xhmdrp/pr5rK6kbvuJ+ax1KWk0vv7EddcYykM2VNFMoDk/Fo6CLkgPP/RSe+WuJ+g3Ig42TBP+8P9g1oCQQEVzBHeh75RKDup/Dd5jTYWoTEBHlAjR1tvAaw14Hzbd4+KRr7/wQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783937060; c=relaxed/simple;
	bh=VgBiPBWeo4HmSIIjDpKu69PrpGRLPzcwcVo89dqKRiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G0OmROj7v9WVnZYZrY+mbsdi1We401hNm38xZ3n5ZSU4lo2s6jUYrWWHET7H3RQQh5DGT8sYzt6j+ZkBFCy/6w32+mGv4DEXWQJft/VvBTPawfLhLmdc86hvu7SpZT13PFbLou9Np0VtXb/gros/Tmu4Rp7kzwfsRPV3lRUL7os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A65F468C4E; Mon, 13 Jul 2026 12:04:14 +0200 (CEST)
Date: Mon, 13 Jul 2026 12:04:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>, zlang@kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de, pankaj.raghav@linux.dev,
	fstests@vger.kernel.org, djwong@kernel.org, yi.zhang@huawei.com,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH v2] generic/795: add unaligned boundary test cases for
 WRITE_ZEROES
Message-ID: <20260713100414.GA11013@lst.de>
References: <20260709083048.3849610-1-p.raghav@samsung.com> <1adabe60-17d5-49ff-a6e6-33f90debf6fe@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1adabe60-17d5-49ff-a6e6-33f90debf6fe@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 10, 2026 at 04:23:27PM +0800, Zhang Yi wrote:
> Thank you for the test! The changes look good to me, and it works well
> with my ext4 fixes as well.
> 
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> 
> Unfortunately, I've found a bug in filefrag that causes delalloc extents
> to be reported with a length of 0. This means this test case can miss
> delalloc extents. The issue is in misc/filefrag.c's print_extent_info(),
> where ext_len is incorrectly set to 0 for the FIEMAP_EXTENT_UNKNOWN or
> EXT4_FIEMAP_EXTENT_HOLE cases. Could you please send a patch to fix this
> as well?

We can't really rely on having a bleeding edge filefrag for xfstests
(well, at least without a feature check for it, but even that
would not a good usability story).  I guess at least for now
we might have to add  a little tool that just calls FIEMAP for
us to xfstests?

