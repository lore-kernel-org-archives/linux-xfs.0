Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036731F8182
	for <linux-xfs@vger.kernel.org>; Thu, 24 Oct 2024 16:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729787886; cv=none; b=KUVwVOAjQlFJcZ0xxMFAaA58Zsun4qVGqxgYZHxAF9uMPe5p+uJQQo5itfxCxYhzqOpOUHE0MLHAD+cVzKJDTU3ilJI3xYHW7zxlJ/UcMYQpwbp9TD2sYN+tnltoXHm1Sg2TKv2+qABp2YEooGTrfm6vYqcKH5ZR79XXBcKvjqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729787886; c=relaxed/simple;
	bh=aZm/+ceY7M4etlk0nlbJ0J0e25I033Xvg/ep/qE1G6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EKWN86Sf81wk01AOjZ8ZCf7KNFF69Sl36VuT7WmsljSJADB8JvFVasJHzXx9w5VhBnv06MXTCB2hrljJUEoIwOaGxXGuTJGyvFRavOkt3V8Nck5txvwq7yBtWRH4lSZACOSWIxSvwo+IZf70p+yPgrhgbolXhiXwbD/cBig3YGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=crRSHf2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="crRSHf2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E77AC4CEC7;
	Thu, 24 Oct 2024 16:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729787885;
	bh=aZm/+ceY7M4etlk0nlbJ0J0e25I033Xvg/ep/qE1G6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=crRSHf2v6PFdEd0Wto1hRnm0AGyTN6fHZTabVrRRNHPtNiWMqFVMkSVd2W0sR05VA
	 C/FyFlDtXhminLQzefNwoEBgNk8IsqLy0Mn5zGcOZHPqOQ+Fyv4W8xxWtHoN4hm8DW
	 2xirHEkaBoLVOyndVUtmWBFZckzvFXYDV7feQdsB4eXoV+tBeTUkEIpuJn6S3aVTkO
	 NZeMlV4MI5Z+H2Pciiv8IzV3KDx+rXRRp2UsbwxJ9F+S2eTLECZpKJ4IMb8kks4fv1
	 my1Iza4e++hsQKBXTpcTuzBB7Mw92KSbfyQAWCRxxAgHBanadQcpKgb41pXUUNiiS8
	 uy1xizaU6iKQA==
Date: Thu, 24 Oct 2024 09:38:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/3] xfs: sparse inodes overlap end of filesystem
Message-ID: <20241024163804.GH21853@frogsfrogsfrogs>
References: <20241024025142.4082218-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024025142.4082218-1-david@fromorbit.com>

On Thu, Oct 24, 2024 at 01:51:02PM +1100, Dave Chinner wrote:
> We have had a large number of recent reports about cloud filesystems
> with "corrupt" inode records recently. They are all the same, and
> feature a filesystem that has been grown from a small size to a
> larger size (to 30G or 50G). In all cases, they have a very small
> runt AG at the end of the filesystem.  In the case of the 30GB
> filesystems, this is 1031 blocks long.
> 
> These filesystems start issuing corruption warnings when trying to
> allocate an in a sparse cluster at block 1024 of the runt AG. At
> this point, there shouldn't be a sparse inode cluster because there
> isn't space to fit an entire inode chunk (8 blocks) at block 1024.
> i.e. it is only 7 blocks from the end of the AG.
> 
> Hence the first bug is that we allowed allocation of a sparse inode
> cluster in this location when it should not have occurred. The first
> patch in the series addresses this.
> 
> However, there is actually nothing corrupt in the on-disk sparse
> inode record or inode cluster at agbno 1024. It is a 32 inode
> cluster, which means it is 4 blocks in length, so sits entirely
> within the AG and every inode in the record is addressable and
> accessible. The only thing we can't do is make the sparse inode
> record whole - the inode allocation code cannot allocate another 4
> blocks that span beyond the end of the AG. Hence this inode record
> and cluster remain sparse until all the inodes in it are freed and
> the cluster removed from disk.
> 
> The second bug is that we don't consider inodes beyond inode cluster
> alignment at the end of an AG as being valid. When sparse inode
> alignment is in use, we set the in-memory inode cluster alignment to
> match the inode chunk alignment, and so the maximum valid inode
> number is inode chunk aligned, not inode cluster aligned. Hence when
> we have an inode cluster at the end of the AG - so the max inode
> number is cluster aligned - we reject that entire cluster as being
> invalid. 
> 
> As stated above, there is nothing corrupt about the sparse inode
> cluster at the end of the AG, it just doesn't match an arbitrary
> alignment validation restriction for inodes at the end of the AG.
> Given we have production filesystems out there with sparse inode
> clusters allocated with cluster alignment at the end of the AG, we
> need to consider these inodes as valid and not error out with a
> corruption report.  The second patch addresses this.
> 
> The third issue I found is that we never validate the
> sb->sb_spino_align valid when we mount the filesystem. It could have
> any value and we just blindly use it when calculating inode
> allocation geometry. The third patch adds sb->sb_spino_align range
> validation to the superblock verifier.
> 
> There is one question that needs to be resolved in this patchset: if
> we take patch 2 to allow sparse inodes at the end of the AG, why
> would we need the change in patch 1? Indeed, at this point I have to
> ask why we even need the min/max agbno guidelines to the inode chunk
> allocation as we end up allowing any aligned location in the AG to
> be used by sparse inodes. i.e. if we take patch 2, then patch 1 is
> unnecessary and now we can remove a bunch of code (min/max_agbno
> constraints) from the allocator paths...

Yeah, I think we can only adjust the codebase to allow chunks that cross
EOAG as long as the clusters don't.

> I'd prefer that we take the latter path: ignore the first patch.
> This results in more flexible behaviour, allows existing filesystems
> with this issue to work without needing xfs_repair to fix them, and
> we get to remove complexity from the code.

Do xfs_repair/scrub trip over these sparse chunks that cross EOAG,
or are they ok?

--D

> Thoughts?
> 
