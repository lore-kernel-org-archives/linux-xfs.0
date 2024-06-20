Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C288D1B151D;
	Thu, 20 Jun 2024 16:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718902527; cv=none; b=NvJVl8Kn3zYDRJH0CE0d3dB+BLo19j27+V5pmFWWt/o0UjJe+ubetk2ubBhPhuRNGmdwLI7LQAYGWrMLCJ4QfLRRULZw1zYcikjBK4qBpt544cp/gBVCxHCLgAocnzo1vsyrTGXxnS4eozDUmiHFMgsucIdYX3SrrE1KfLqjBww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718902527; c=relaxed/simple;
	bh=6G++sZcuPiHoj4fnI8UmWmkWrq3ow1/7dxb6rPQSdlk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rdQgw8srcvwe6YZn4J5J81VtcZ7f6mmILTTrRTme6VnQ9FGrJkFgF6LU6JyNBLt5UnUaFiFJUDJxOAZpHsFRCynUNPFu8LODZqELWvBpidUkZc73yiHEIgRtX7vaG/lAcfVquUEU3xtFxEfSC1l7j30v54Qfnsb2qkprgHcxFFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r0L9EDTw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r0L9EDTw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578F5C2BD10;
	Thu, 20 Jun 2024 16:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718902527;
	bh=6G++sZcuPiHoj4fnI8UmWmkWrq3ow1/7dxb6rPQSdlk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r0L9EDTwoiYMknRNb3UzGaizFAaq1P+jDVtx+8gTjcG7Wr8VDKpt1OmKO4eseysuL
	 PUpfighxwMY8bq7t/Aa6d1NbkSAyxAROlmwvAXJiw14z5O62PDebnYsAQb7Om5SO4J
	 CVNZI+SxXb2mkwH4FiRx/03bhf/XcicBYHUknLQV7SBaUfIqi1k/lt2OcaGmNUQv25
	 7HPPGIWX/7mCmPi7qUkON0oFzdp1ulBV5h+Mzl+tx6HJ8pBS99J/wSYAK943BZmVj8
	 MRaaeB4Gl8EkMvH2QVzsKSP8iKZY6VXmFFaKnCcNOv6N2+86+c+QBRBYqqrds7zal7
	 yFjoh8yzaXi9g==
Date: Thu, 20 Jun 2024 09:55:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] generic/710: repurpose this for exchangerange vs.
 quota testing
Message-ID: <20240620165526.GW103034@frogsfrogsfrogs>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
 <171867145344.793463.2045134533110555641.stgit@frogsfrogsfrogs>
 <ZnJ15ZG1nWsCkxiG@infradead.org>
 <20240619172318.GR103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240619172318.GR103034@frogsfrogsfrogs>

On Wed, Jun 19, 2024 at 10:23:18AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 18, 2024 at 11:08:37PM -0700, Christoph Hellwig wrote:
> > On Mon, Jun 17, 2024 at 05:47:32PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > The exchange-range implementation is now completely separate from the
> > > old swapext ioctl.  We're deprecating the old swapext ioctl, so let's
> > > move this test to use exchangerange.
> > 
> > Do we really want to lost the swapext test coverage?  Even if it is
> > deprecated, it will be with us for a long time.  My vote for copy and
> > pasting this into a new test for exchrange.
> 
> Yeah, you're right that we should retain this test for the old swapext
> ioctl.  I'll fork the test into two -- one for swapext, another for
> exchangerange.

...except that the swapext ioctl doesn't support swapping forks if quota
is enabled and any of the user/group/project ids are different:


	/* User/group/project quota ids must match if quotas are enforced. */
	if (XFS_IS_QUOTA_ON(ip->i_mount) &&
	    (!uid_eq(VFS_I(ip)->i_uid, VFS_I(tip)->i_uid) ||
	     !gid_eq(VFS_I(ip)->i_gid, VFS_I(tip)->i_gid) ||
	     ip->i_projid != tip->i_projid))
		return -EINVAL;

I'll amend the commit message:

"There's no point in maintaining this test for the legacy swapext code
because it returns EINVAL if any quota is enabled and the two files have
different user/group/project ids.  Originally I had forward ported the
old swapext ioctl to use commitrange as its backend, but that will be
dropped in favor of porting xfs_fsr to use commitrange directly."

--D
