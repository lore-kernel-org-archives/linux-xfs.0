Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AB422C6C5
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733532107; cv=none; b=gUIjVArkGowkT+TRRh+2ULWWX7tAqHF9sIirj5MyTJmnp3e6i5hvvCwxdbdDRrt+ghs0nT2Mu+aE1IFp4OrPZ+DdillS28pWK0HQSFeiYeuSxSjZZXAwBsnBSujcqXsKMkp8FioNdjUi3MnEe6ItUOqqlN1b6G0izigF1+0J8B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733532107; c=relaxed/simple;
	bh=2uUW45Z8lDJuAcUVHu63d2KFkvlnzpLPHjbxYlhyGFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TixnsrYqPNvMenhfal1fGfhWiMFv5JGCKN9KMNhJStKD7FZQeMAuu0WtBs5cd+xa/3IdGi5LksGVwlpMMiH82PyeN1GF6FxA9cRk8xBnfN7Z/uKzaaFIJ7LPay9jF5TThcNQWbD17J7aloLJOQ7KB1pvcOBqCVrlh+AJI38m3Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ya1gykUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ya1gykUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11E1C4CED1;
	Sat,  7 Dec 2024 00:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733532106;
	bh=2uUW45Z8lDJuAcUVHu63d2KFkvlnzpLPHjbxYlhyGFA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ya1gykURsQsFUoplW/ebmU9Z56peK2Dv9dO299B5VeNO9qDimuRQmUxc72ik9ts4t
	 iNZR/nYWfguIr9H+aqiP+EGBrzKmzJ/VFYjNMfX3lRTO9qy0RuSzdyEyI0Tf5YX9uR
	 x1l5lG6X2bDCAQTBzpc9FqzNupW66NGQLKUaW7Vmqce/GVWpHCUnVdMQYSrVu6hP2C
	 V+717Wx8LiOQviq4vITDGWP8X5eWFbMzQBKqlgKoWkc8HyRRQagM7Zji0f+Dd8rpCi
	 2fhkN0RwX5cUeCYbvJ4f/83BfpTPA6h4Qjh7WxKxSIxudvq4IyRh8GmXxRhLgVw71T
	 5xld7YrswCBXA==
Date: Fri, 6 Dec 2024 16:41:45 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/21] xfs: fix sb_spino_align checks for large fsblock
 sizes
Message-ID: <Z1OZyQebhKLU1p1V@bombadil.infradead.org>
References: <20241126011838.GI9438@frogsfrogsfrogs>
 <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
 <20241126202619.GO9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241126202619.GO9438@frogsfrogsfrogs>

On Tue, Nov 26, 2024 at 12:26:19PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> For a sparse inodes filesystem, mkfs.xfs computes the values of
> sb_spino_align and sb_inoalignmt with the following code:
> 
> 	int     cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
> 
> 	if (cfg->sb_feat.crcs_enabled)
> 		cluster_size *= cfg->inodesize / XFS_DINODE_MIN_SIZE;
> 
> 	sbp->sb_spino_align = cluster_size >> cfg->blocklog;
> 	sbp->sb_inoalignmt = XFS_INODES_PER_CHUNK *
> 			cfg->inodesize >> cfg->blocklog;
> 
> On a V5 filesystem with 64k fsblocks and 512 byte inodes, this results
> in cluster_size = 8192 * (512 / 256) = 16384.  As a result,
> sb_spino_align and sb_inoalignmt are both set to zero.  Unfortunately,
> this trips the new sb_spino_align check that was just added to
> xfs_validate_sb_common, and the mkfs fails:
> 
> # mkfs.xfs -f -b size=64k, /dev/sda
> meta-data=/dev/sda               isize=512    agcount=4, agsize=81136 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
>          =                       exchange=0   metadir=0
> data     =                       bsize=65536  blocks=324544, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=65536  ascii-ci=0, ftype=1, parent=0
> log      =internal log           bsize=65536  blocks=5006, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=65536  blocks=0, rtextents=0
>          =                       rgcount=0    rgsize=0 extents
> Discarding blocks...Sparse inode alignment (0) is invalid.
> Metadata corruption detected at 0x560ac5a80bbe, xfs_sb block 0x0/0x200
> libxfs_bwrite: write verifier failed on xfs_sb bno 0x0/0x1
> mkfs.xfs: Releasing dirty buffer to free list!
> found dirty buffer (bulk) on free list!
> Sparse inode alignment (0) is invalid.
> Metadata corruption detected at 0x560ac5a80bbe, xfs_sb block 0x0/0x200
> libxfs_bwrite: write verifier failed on xfs_sb bno 0x0/0x1
> mkfs.xfs: writing AG headers failed, err=22
> 
> Prior to commit 59e43f5479cce1 this all worked fine, even if "sparse"
> inodes are somewhat meaningless when everything fits in a single
> fsblock.  Adjust the checks to handle existing filesystems.
> 
> Fixes: 59e43f5479cce1 ("xfs: sb_spino_align is not verified")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Tested-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
