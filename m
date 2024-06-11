Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E98E328B6
	for <linux-xfs@vger.kernel.org>; Tue, 11 Jun 2024 17:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718125219; cv=none; b=CIlNSDoTFJfnWh64TSkKAJ5YmywbOuWP1H4OIDMF+jqGKqm8NMbDfuXnuXcdvQyNsN15fNOaJTJBkHCZFB/fr0MBR4bhJv0WTktvrXv+nfMWaJVQsvVrddvlTh996zYGpWrmbnvu/9TOVnwDasup/r+5Tw/2zKrbGsOWZwxpT5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718125219; c=relaxed/simple;
	bh=mmCLdLG1D71JTQ/0xP4Q5lNvNRy3boKKynVOcErMTXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NZvRvdcjXvuhEOi8kKQSC5yrpxAc1Vu9rPLkDSynO9a4bWsro2ApUSoM20aY3BjjOhLqU5t83WPM1DmpiuNFGPbz2EG/Q3Fu5UcY805jNm/4VtNHVSnRUGmSUmXMAfCD4gRhJ+J0jldva/SbT/2T80aAdtKtpl4sYJsMI7/0v4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MJD+CCTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MJD+CCTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E579C2BD10;
	Tue, 11 Jun 2024 17:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718125218;
	bh=mmCLdLG1D71JTQ/0xP4Q5lNvNRy3boKKynVOcErMTXQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MJD+CCTpXNuLdnCgGGbPORdNLzVkXufs6cVp8IFky14REgK6eejAavzSe27GBUcOH
	 KugzD42zOy9E7MZ1XVnZ7QCj2Br46GpTfSJR/xwcmmJizIzJvNgxOx9hEfcaJeWUwA
	 mrmFh44oMlBCtrsOSaU9Gc3fCpByS1tQglyXpk8CLWJcyLbZK4e9O9NRZHPPVKJr0Z
	 EE79rnSo+wQDHattFOZs7kdlDRM3d2OIUFWfmDu9rz6nSiK2lQKWO3RYsL5Q+yQ6os
	 JDtJG21TU+s6VDErxW39SuTzmcVU0SKtHLa6wPQR2N6B7Hyq6/H11tSVPUdG/tVuAu
	 6a40sEvHHag1g==
Date: Tue, 11 Jun 2024 10:00:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: dont remain new blocks in cowfork for unshare
Message-ID: <20240611170017.GY52987@frogsfrogsfrogs>
References: <20240517212621.9394-1-wen.gang.wang@oracle.com>
 <20240520180848.GI25518@frogsfrogsfrogs>
 <DA28C74B-7514-48E2-BC86-DA9A9824CDA5@oracle.com>
 <20240531160053.GQ52987@frogsfrogsfrogs>
 <B19C20F1-CFD1-47A3-B0F0-F69C66CD58F7@oracle.com>
 <03DE362C-9CB7-4D14-AAEF-AEB29DB37052@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <03DE362C-9CB7-4D14-AAEF-AEB29DB37052@oracle.com>

On Thu, Jun 06, 2024 at 06:16:23PM +0000, Wengang Wang wrote:
> 
> 
> > On May 31, 2024, at 10:53 AM, Wengang Wang <wen.gang.wang@oracle.com> wrote:
> > 
> > 
> > 
> >> On May 31, 2024, at 9:00 AM, Darrick J. Wong <djwong@kernel.org> wrote:
> >> 
> >> On Mon, May 20, 2024 at 10:42:02PM +0000, Wengang Wang wrote:
> >>> Thanks Darrick for review, pls see inlines:
> >>> 
> >>>> On May 20, 2024, at 11:08 AM, Darrick J. Wong <djwong@kernel.org> wrote:
> >>>> 
> >>>> On Fri, May 17, 2024 at 02:26:21PM -0700, Wengang Wang wrote:
> >>>>> Unsharing blocks is implemented by doing CoW to those blocks. That has a side
> >>>>> effect that some new allocatd blocks remain in inode Cow fork. As unsharing blocks
> >>>> 
> >>>>                     allocated
> >>>> 
> >>>>> has no hint that future writes would like come to the blocks that follow the
> >>>>> unshared ones, the extra blocks in Cow fork is meaningless.
> >>>>> 
> >>>>> This patch makes that no new blocks caused by unshare remain in Cow fork.
> >>>>> The change in xfs_get_extsz_hint() makes the new blocks have more change to be
> >>>>> contigurous in unshare path when there are multiple extents to unshare.
> >>>> 
> >>>> contiguous
> >>>> 
> >>> Sorry for typos.
> >>> 
> >>>> Aha, so you're trying to combat fragmentation by making unshare use
> >>>> delayed allocation so that we try to allocate one big extent all at once
> >>>> instead of doing this piece by piece.  Or maybe you also don't want
> >>>> unshare to preallocate cow extents beyond the range requested?
> >>>> 
> >>> 
> >>> Yes, The main purpose is for the later (avoid preallocating beyond).
> >> 
> >> But the user set an extent size hint, so presumably they want us to (try
> >> to) obey that even for unshare operations, right?
> > 
> > Yeah, user might set extsize for better IO performance. But they don’t really know
> > much details. Consider this case: 
> > writing to those over/beyond preallocated blocks would cause Cow. Cow includes
> > extra meta changes: releasing old blocks, inserting new extents to data fork and removing
> > staging extents from refcount tree.  That’s a lot, as I think, a Cow is slower than block over-write.
> > In above case, the Cow is caused by unshare, rather than by shared blocks. That might be
> > not what user expected by setting extsize.
> > 
> > 
> May I know if this is a good reason to skip extsize setting, or we
> anyways honor extsize?

I'm not sure -- if someone set (say) a 256k cowextsize and later wants
to unshare a single 4k block of that, they might think it's useful for
the fs to try to push surrounding writes to the same 256k region to
combat fragmentation.

OTOH if the cowextsize is (say) 2M (or 1G) then that might be excessive?
Particularly if the cow reservation shadows an already unshared data
fork block, in which case (as you point out) this turns a cheap
overwrite into an expensive cow.  IOWs, we're trading less fragmentation
for higher individual write times.

Hmm, maybe there's another aspect to think about -- for a directio cow
write, I think we skip the cowextsize thing and only allocate the exact
range the caller asked for.  If that's correct, then perhaps unshare
should follow the directio write allocation pattern if the struct file
has O_DIRECT set?

--D

> Thanks,
> Wengang
> 
