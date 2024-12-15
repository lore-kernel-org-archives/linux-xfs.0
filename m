Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310D11487F6
	for <linux-xfs@vger.kernel.org>; Sun, 15 Dec 2024 18:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734286570; cv=none; b=KfW+tysJ9m0e7fZ2zEFkO1etbvjJQfg4p/b2TRiU6LBhDaBSo5lLa9QYWHOFZkydl68EwEEkYaw3Tuya+spWmW5+t539pNFKCiErraU+7PRg2991sdI8LUmMENEYg56mYV0x68W9iMgWSIFOzGApTsM7svZCCdf3JMFlg2hLVRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734286570; c=relaxed/simple;
	bh=g6u1H0FiWWm2hKO1KXO2kg0KDZa0fB/Fy+OnZnVXJr8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UTjY1zZU9vLcm2ks6ZA4TCuwcl/rikqFrehpW5rLBtftcbdZ5hO/AdgOp10iamt3K+0jPCWI2tZdylCo2lWk8EHDZWg3zWf2MniCeuOkkXo5tQJPExxqQ99UjFfCuTE22dNq34GbxFtBn1NJUo0Dt802m+mgv55afQaycXBZB+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IO/1YOdm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IO/1YOdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3C7C4CECE;
	Sun, 15 Dec 2024 18:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734286569;
	bh=g6u1H0FiWWm2hKO1KXO2kg0KDZa0fB/Fy+OnZnVXJr8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IO/1YOdmPd6qlqGNLkcDBgG44sBxPB+CBMOJysA3+24KJDPensR23MNmE01lOhWEd
	 WVPtBLu1I4R20/jHsnVnsAwFbtnApNJ1JEgdF+Sl06hZYwvg2QORZZ68GplTJuQ0zN
	 WnWX3Thr5sSzC8W4wHGO0IV3heHhUJqGH842hA3YeX7vccnKsYHNgp9vG4DsKYtgaI
	 xm/Ha9XneLQQKsq3d7cf+J1G8/PwwRPFh2Rsu/89xehQd7GTQLVOSMYxkX/xchtl2f
	 aQ0In0UFSmP9SKiaXrY2H4sx+p7ZmpP1uECmQwp8RHDycMH8GjCWjR6lR/cFQoELF3
	 PfXHdeG7P0AEQ==
Date: Sun, 15 Dec 2024 10:16:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/43] xfs: don't take m_sb_lock in xfs_fs_statfs
Message-ID: <20241215181609.GC6174@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-6-hch@lst.de>
 <20241212214206.GX6678@frogsfrogsfrogs>
 <20241213050615.GC5630@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213050615.GC5630@lst.de>

On Fri, Dec 13, 2024 at 06:06:15AM +0100, Christoph Hellwig wrote:
> On Thu, Dec 12, 2024 at 01:42:06PM -0800, Darrick J. Wong wrote:
> > On Wed, Dec 11, 2024 at 09:54:30AM +0100, Christoph Hellwig wrote:
> > > The only non-constant value read under m_sb_lock in xfs_fs_statfs is
> > > sb_dblocks, and it could become stale right after dropping the lock
> > > anyway.  Remove the thus pointless lock section.
> > 
> > Is there a stronger reason later for removing the critical section?
> > Do we lose much by leaving the protection in place?
> 
> It makes a completely mess of xfs_fs_statfs, and as stated in the
> commit message about it's not actually useful at all.  I also don't
> think taking a global lock from a non-privileged operation is an
> old that good idea to start with if we can avoid it.

Ok, I'm convinced.  But perhaps you could leave a comment that we don't
care if the accesses are torn, to try to head off the inevitable kcsan/
dept/whatever patches?

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

