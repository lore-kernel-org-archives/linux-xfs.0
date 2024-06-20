Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B955C22EED;
	Thu, 20 Jun 2024 19:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718911240; cv=none; b=Wfi77drUY8gt6ySBCrivPK1iQfd7Pg11ddECfY1GxhKYOotcT3K/ACnhivhDHU//O5qJHZ3n5REXoysUo1vRnxQXYDOV/lAIm7mHfS69YeXI8vCdp8hxJsCBt36cVMSPDG6LNPB3GTGv5/kHg287ADScyYOEDLgRfbKQ1obTUyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718911240; c=relaxed/simple;
	bh=cNRSZ7wKYPkk+fJbigsnhPo3nm07P3rtzxFDDr9yUpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z/sEQDjhvrrzEFx9/fPU9wYTheUWAR0+EZO3vNbwbhpb4de2wM9kKeNBnuLqhap7aR4+wd7O1G3kf7jfbozp3YgAswQ8xRArnqolnhhN2ZIRnKPzAqVU6BSNQdFPEyhIkdoImPtMCzD/jsxECsMpEpyZjJd0vIM/dlsBL5g5nTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dR2D+J9w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dR2D+J9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB87C2BD10;
	Thu, 20 Jun 2024 19:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718911240;
	bh=cNRSZ7wKYPkk+fJbigsnhPo3nm07P3rtzxFDDr9yUpk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dR2D+J9wVmpSPmHs20J6F+GSutsbfKXkfnAXRYSfy0vfZSZwiokZfFqr/kmfYJoTf
	 vqKBC1TGfsn7z7cGvUHu8ud59E1A5YxThQF4UCTpoEFEPaxoDPIGaxgyUfYY4kx9P6
	 YEPHfv2OHt9vWegPqGjsOqoQUSyIoOkX6csQFJbUKH97tFZa+vfQd/L2rHzCdMCYDO
	 /+9wuZ4e3oQPVtpTXpshnH3wfoJ+QBMs8+A6cysuPiHg0qYxcnBGGHjadW/XuCce7C
	 axrb9Y5zdpkSOBiwGCCs66ZxNrYV3BCXOt4MFldCPyeHKWlGQtS7baXAflSa17FytC
	 zOUXUbFTafSIg==
Date: Thu, 20 Jun 2024 12:20:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] generic/710: repurpose this for exchangerange vs.
 quota testing
Message-ID: <20240620192039.GB103020@frogsfrogsfrogs>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
 <171867145344.793463.2045134533110555641.stgit@frogsfrogsfrogs>
 <ZnJ15ZG1nWsCkxiG@infradead.org>
 <20240619172318.GR103034@frogsfrogsfrogs>
 <20240620165526.GW103034@frogsfrogsfrogs>
 <20240620190628.onmsffjtscuoa2ca@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620190628.onmsffjtscuoa2ca@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Fri, Jun 21, 2024 at 03:06:28AM +0800, Zorro Lang wrote:
> On Thu, Jun 20, 2024 at 09:55:26AM -0700, Darrick J. Wong wrote:
> > On Wed, Jun 19, 2024 at 10:23:18AM -0700, Darrick J. Wong wrote:
> > > On Tue, Jun 18, 2024 at 11:08:37PM -0700, Christoph Hellwig wrote:
> > > > On Mon, Jun 17, 2024 at 05:47:32PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > The exchange-range implementation is now completely separate from the
> > > > > old swapext ioctl.  We're deprecating the old swapext ioctl, so let's
> > > > > move this test to use exchangerange.
> > > > 
> > > > Do we really want to lost the swapext test coverage?  Even if it is
> > > > deprecated, it will be with us for a long time.  My vote for copy and
> > > > pasting this into a new test for exchrange.
> > > 
> > > Yeah, you're right that we should retain this test for the old swapext
> > > ioctl.  I'll fork the test into two -- one for swapext, another for
> > > exchangerange.
> > 
> > ...except that the swapext ioctl doesn't support swapping forks if quota
> > is enabled and any of the user/group/project ids are different:
> > 
> > 
> > 	/* User/group/project quota ids must match if quotas are enforced. */
> > 	if (XFS_IS_QUOTA_ON(ip->i_mount) &&
> > 	    (!uid_eq(VFS_I(ip)->i_uid, VFS_I(tip)->i_uid) ||
> > 	     !gid_eq(VFS_I(ip)->i_gid, VFS_I(tip)->i_gid) ||
> > 	     ip->i_projid != tip->i_projid))
> > 		return -EINVAL;
> > 
> > I'll amend the commit message:
> > 
> > "There's no point in maintaining this test for the legacy swapext code
> > because it returns EINVAL if any quota is enabled and the two files have
> > different user/group/project ids.  Originally I had forward ported the
> > old swapext ioctl to use commitrange as its backend, but that will be
> > dropped in favor of porting xfs_fsr to use commitrange directly."
> 
> Hi Darrick,
> 
> I can help to change the patch [4/10] and [10/10] if you need. But for this
> one, will you re-send this patch or the whole patchset?

I plan on resending this patchset, since I've found a couple more
swapext tests that need correcting.

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> 
> 
