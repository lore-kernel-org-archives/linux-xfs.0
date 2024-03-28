Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D507EF1E;
	Thu, 28 Mar 2024 15:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711638344; cv=none; b=rpTX9JFDQmVyf62FxKbdO+6poCAvqjIslgLWwElNrmHj5geixRdMjLInZG+sDJo/U7DzB3S4OfLtGNcdkd5ZmNGgBwQysKP0l8baW6t0YLwnWDJLB1d7PkvBjscpC1PHvsU3c4im9FXBzcX5pal+jS6RcPq+I9Bd7K6bUc9EvA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711638344; c=relaxed/simple;
	bh=AzVzQrAY2UOzddTs9EcW7mraOPjDjYJIy2BrGGSTGRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IcOMftxqNH1JkLURlBMKUPPhBWG+NRv4Ujjqig5k1shm3bLRM2GYg8uyfnHB28pTAnmZajVVeNYipADPSPymMN0Bldc8ITKcBe3XfBdIKhfCuHsC7B2BXQFQHWna3SwrX7+MwHcE7gp2Jfz64mfAnVkfuaLWXUnluieFHjV1omc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bONMFx/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bONMFx/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C48EC433C7;
	Thu, 28 Mar 2024 15:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711638343;
	bh=AzVzQrAY2UOzddTs9EcW7mraOPjDjYJIy2BrGGSTGRA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bONMFx/O/64at0Z1GWqlr+3+8JNcZX4gG6R9a3A3bdtbPkQOcO1xv/HWei1YNJo57
	 xFAQKcNkXfaeDZ6Uu8nbN1fuHa4I/7itCW3ELTziQcRhteQw0KadyIVcrkBR2cTx3Y
	 bGS+Iw0qcgkSKyGV5OvRsbpK0VTHWgV/nL3mw37T0HxBMf9hDBoqa60Qknj3aAWAZN
	 Od04JXAIbH43aHedw1bk/plo+0tUdMEYL9wBu0sCoQcE0Ty0Jww5c8MkOc/aFd6iil
	 uQVzjlFcPvlRxBCdxtPVCsB8xEGBTc1m0JWat6L0uJPS3SyFavht3JHVvmTYlMcwf7
	 63BIGFmRZ14Ug==
Date: Thu, 28 Mar 2024 08:05:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: don't run tests that require v4 file systems when
 not supported
Message-ID: <20240328150542.GD6379@frogsfrogsfrogs>
References: <20240328121749.15274-1-hch@lst.de>
 <20240328135905.fw27fzpixofpp4v7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240328145641.GA29197@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328145641.GA29197@lst.de>

On Thu, Mar 28, 2024 at 03:56:41PM +0100, Christoph Hellwig wrote:
> On Thu, Mar 28, 2024 at 09:59:05PM +0800, Zorro Lang wrote:
> > On Thu, Mar 28, 2024 at 01:17:49PM +0100, Christoph Hellwig wrote:
> > > Add a _require_xfs_nocrc helper that checks that we can mkfs and mount
> > > a crc=0 file systems before running tests that rely on it to avoid failures
> > > on kernels with CONFIG_XFS_SUPPORT_V4 disabled.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > 
> > This change makes sense to me, thanks for this update.
> > By searching "crc=0" in tests/xfs, I got x/096, x/078 and x/300 which
> > are not in this patch. Is there any reason about why they don't need it?
> 
> xfs/078 only forces crc=0 for block size <= 1024 bytes.  Would be
> kinds sad to disable it just to work around this case.

The crc=0 forcing case seems only to activate if
XFS_MKFS_HAS_NO_META_SUPPORT is non-empty, which happens only if
mkfs.xfs does /not/ support V5 filesystems.  Maybe we can drop that
case?

> xfs/096 requires an obsolete mkfs without input validation, but
> I guess adding the doesn't hurt

Why do we even keep this test then?  Do we care about xfsprogs 4.5?
4.19^H4 is the oldest LTS kernel...

--D

> xfs/300 needs the check, it doesn't run on my test setup because it
> requires selinux.
> 
> 
