Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE4314831D;
	Fri,  2 Feb 2024 16:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706892405; cv=none; b=pd5sENsqsd7Izt53Kvwx4Oz1cl8j1YkXkTaXLR6PfFuYvMzkuEHGBjtC2m6rJB661pvIdEZ/uGF16ebqxQp9Nmq7OooAN2BAv76ZJKUrus16LWNfyM5X5as9VZv/67YF6INbh43z7YxszSn0uhrCNo8apTkSWmlJe5jP39SA3I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706892405; c=relaxed/simple;
	bh=DEAZmva1PQ3B/T5btCRDPXjxktYtxemVIzPnV3SC6yA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jAt+aM3PjuSphFvQx6dRX2nRZ49Km1XaXr/3qTF/FQsyMPLS15x17ctQ/fkhsesXMJ0v1XFoQq3SQebhZ3q8dQf2DMMsv6qIZnXNkvA2/BtgVaZehaFuTg01UY74q9qchJnRutYfS3xawM0hkNk9BbMFkJW1qEPG/cCdRmar/yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W8cjSpoi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W8cjSpoi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A174DC433F1;
	Fri,  2 Feb 2024 16:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706892404;
	bh=DEAZmva1PQ3B/T5btCRDPXjxktYtxemVIzPnV3SC6yA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W8cjSpoiLKG/A3IwHqEgbjdVMfch5jnrREHXI9KM4eHkWBh25KN+W/iZT1XKKdfUI
	 6ueOHguVgny5wghTF8ob2KLwhRTzCGPm65SdDqbKWvR9GiQnZ6aiLR5cvfkH88NM7F
	 LlmFXDEk/tFdjqrOiezlyTxv/LEQNN0UxYOZhudnaCjXRbg626mQLukuA25FZmouKs
	 W0C0/MtryOMMcojvBITAEFPHuVhWfohlmDYCS/zNjTSmIPmhal5OJtoo9z1SAJHxHz
	 vsVjSfyz1ZwVXCeobP8jhvWGGk2lRTs+qdkZHKoqaAXS7n0xD64QZGOBXWXjjr8xOw
	 Pqt9D402/qzLg==
Date: Fri, 2 Feb 2024 08:46:44 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>, fstests@vger.kernel.org,
	zlang@redhat.com, Dave Chinner <david@fromorbit.com>,
	mcgrof@kernel.org, gost.dev@samsung.com, linux-xfs@vger.kernel.org,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: Re: fstest failure due to filesystem size for 16k, 32k and 64k FSB
Message-ID: <20240202164644.GK616564@frogsfrogsfrogs>
References: <CGME20240130131803eucas1p280d9355ca3f8dc94073aff54555e3820@eucas1p2.samsung.com>
 <fe7fec1c-3b08-430f-9c95-ea76b237acf4@samsung.com>
 <20240130195602.GJ1371843@frogsfrogsfrogs>
 <6bea58ad-5b07-4104-a6ff-a2c51a03bd2f@samsung.com>
 <20240131034851.GF6188@frogsfrogsfrogs>
 <yhuvl7u466fc6zznulfirtg35m7fteutzhar2dhunrxleterym@3qxydiupxnsx>
 <20240131182858.GG6188@frogsfrogsfrogs>
 <f5wwi5oqok5p6somhubriesmmhlvvid7csszy5cmjqem37jy4g@2of2bw4azlvx>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5wwi5oqok5p6somhubriesmmhlvvid7csszy5cmjqem37jy4g@2of2bw4azlvx>

On Thu, Feb 01, 2024 at 04:44:36PM +0100, Pankaj Raghav (Samsung) wrote:
> On Wed, Jan 31, 2024 at 10:28:58AM -0800, Darrick J. Wong wrote:
> > On Wed, Jan 31, 2024 at 03:05:48PM +0100, Pankaj Raghav (Samsung) wrote:
> > > > > 
> > > > > Thanks for the reply. So we can have a small `if` conditional block for xfs
> > > > > to have fs size = 500M in generic test cases.
> > > > 
> > > > I'd suggest creating a helper where you pass in the fs size you want and
> > > > it rounds that up to the minimum value.  That would then get passed to
> > > > _scratch_mkfs_sized or _scsi_debug_get_dev.
> > > > 
> > > > (testing this as we speak...)
> > > 
> > > I would be more than happy if you send a patch for
> > > this but I also know you are pretty busy, so let me know if you want me
> > > to send a patch for this issue.
> > > 
> > > You had something like this in mind?
> > 
> > Close, but something more like below.  It's not exhaustive; it merely
> > makes the xfs 64k bs tests pass:
> > 
> 
> I still see some errors in generic/081 and generic/108 that have been
> modified in your patch with the same issue.
> 
> This is the mkfs option I am using:
> -m reflink=1,rmapbt=1, -i sparse=1, -b size=64k
> 
> And with that:
> $ ./check -s 64k generic/042 generic/081 generic/108 generic/704 generic/730 generic/731 xfs/279
> 
> ...
> generic/081.out.bad:
>  +max log size 1732 smaller than min log size 2028, filesystem is too small
> ...
> generic/108.out.bad:
> +max log size 1876 smaller than min log size 2028, filesystem is too small
> ...
> SECTION       -- 64k
> =========================
> Ran: generic/042 generic/081 generic/108 generic/704 generic/730 generic/731 xfs/279
> Failures: generic/081 generic/108
> Failed 2 of 7 tests
> 
> **Increasing the size** to 600M fixes all the test in 64k system.

Huh.  Can you send me the mkfs output (or xfs_info after the fact) so I
can compare your setup with mine?  I'm curious about what's affecting
the layout here -- maybe you have -s size=4k or something?

(I don't want to stray too far from the /actual/ mkfs minimum fs size of
300M.)

--D

> 
> The patch itself including `_small_fs_size_mb()` looks good to me.
> 
> > From: Darrick J. Wong <djwong@kernel.org>
> > Subject: [PATCH] misc: fix test that fail formatting with 64k blocksize
> > 
> > There's a bunch of tests that fail the formatting step when the test run
> > is configured to use XFS with a 64k blocksize.  This happens because XFS
> > doesn't really support that combination due to minimum log size
> > constraints.  Fix the test to format larger devices in that case.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/rc         |   29 +++++++++++++++++++++++++++++
> >  tests/generic/042 |    9 +--------
> >  tests/generic/081 |    7 +++++--
> >  tests/generic/108 |    6 ++++--
> >  tests/generic/704 |    3 ++-
> >  tests/generic/730 |    3 ++-
> >  tests/generic/731 |    3 ++-
> >  tests/xfs/279     |    7 ++++---
> 
> As I indicated at the start of the thread, we need to also fix:
> generic/455 generic/457 generic/482 shared/298
> 
> Thanks!
> --
> Pankaj Raghav
> 
