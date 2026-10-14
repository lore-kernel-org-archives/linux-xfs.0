Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3865250129F;
	Wed, 14 Oct 2026 13:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791982915; cv=none; b=mfd4CvvZEG0+uvCTgnFV8XTjK50oNlVmy1XNoE2EyGB7OKjZOY1HMT4TUOnYP4LXjG+UDAGqS6l0Boc8bHVuKSl5ZHDI5y7tf9HH+3BIMxO/+79FoIWYzDroLgCVRp2c33eWZq7HMUVOnv+mTNPu797P7x2bq40oQL7P8kNexlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791982915; c=relaxed/simple;
	bh=wBKV/mkN4uP+UHE8cDoW4YyqRHXsJLlDPxPFXlB209k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GwLpkfx94YbqxbKojjQ+BGZRTYEcxcPBD2UMffjOcP7F2pliSHvCQVpRYnf4pzFf+P6pUVJUdTsghUpgPBaz+bdw938ufiXlN9JgrhnGYsk2fd0iDblmOMAND42r6AGVqdV7aPkEu53tsuRvx1VvaZ2jeOnK7KXI28l/dotjxZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6903668BFE; Wed, 14 Oct 2026 15:01:48 +0200 (CEST)
Date: Wed, 14 Oct 2026 15:01:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Daejun Park <daejun7.park@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: (2) [PATCH] xfs: refuse a pNFS LAYOUTCOMMIT of a range without
 blocks
Message-ID: <20261014130147.GB15407@lst.de>
References: <20261013120359.GB2944@lst.de> <20261013-xfs-pnfs-commit-hole-v1-1-740912db9102@samsung.com> <CGME20261013120408epcas2p19974f8ffd4afa0b0cc5a4f19e9218004@epcms2p7> <20261014014017epcms2p7ab0ff4f1356d695c55514bd7ccaebadf@epcms2p7>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014014017epcms2p7ab0ff4f1356d695c55514bd7ccaebadf@epcms2p7>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 14, 2026 at 10:40:17AM +0900, Daejun Park wrote:
> The IOLOCK held across both keeps truncate, fallocate and blockgc out
> today, but the flag doesn't depend on that, so v2 does it that way:
> xfs_bmapi_write() takes a new XFS_BMAPI_CONVERT_ONLY flag that fails for
> a hole or a delalloc extent instead of allocating, and
> xfs_fs_commit_blocks() passes it through xfs_iomap_write_unwritten().
> 
> One difference from v1: a LAYOUTCOMMIT with a laid-out range followed by
> a hole now converts the laid-out range before it fails.
> xfs_fs_commit_blocks() already left earlier extents converted when a
> later one failed, and the Linux client resends all of its extents after
> a failed LAYOUTCOMMIT, so I don't think that matters.

I don't think that's an issue.
