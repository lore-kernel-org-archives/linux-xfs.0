Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7142C46B91
	for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2024 16:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724170796; cv=none; b=XYOZ3zWMMDLRnElYNdGiIuwDPSsRilG/HCnTjofDvO1PlIfBoBRBovItCEawlMFJY5yuaovsXvOAD26H5uryU0oMi8ChxkC8QnSFJ6qrGUHDbamGVGUmmfYhpkZRVVKsBikeTfA7LGLVDNyXPurh+kCvBSIIxoqqIvfhISDvhxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724170796; c=relaxed/simple;
	bh=S58AEbs3kCF0Gab+PgZf39SiWMBOUZP1+WaqadXGK54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CwMu9hEkQtuoAfuQiGxozNludjiPo0QZqOaIBcH2NZkwg1sbUybIEglIYqT6WhAuAWnUJwoBj3bUMZtdbHepQ8my2KmnS/HwUXO5vUVd3NfZuwU/WBZABIKJ49lsmcpIsHw5T36WgpOR61OTI3l3U8ryYxTE/L+i+tax5SjmQf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EnbDpFeH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EnbDpFeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5EEC4AF0C;
	Tue, 20 Aug 2024 16:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724170795;
	bh=S58AEbs3kCF0Gab+PgZf39SiWMBOUZP1+WaqadXGK54=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EnbDpFeH34Y6qvGzCGEZztp0Mk60oV9/AdUeoGvpvT+1c6goISwgfz6ed4UAZcrN9
	 /sIU+9V8TDMOdIEqLNeFqChNjIdW10F4d6ITVVJcG9sfgr+/6f+SQWyy5weZVyCb3i
	 9T6/SZCQKyMgbe36EqNm3IPW1tYtIbrvpIJn9hgHnqGWZQwkudN1eoIc7VsB/P5oYO
	 lx3WJK4UZXpV0r4YyQ+5obiLm2xSI7CFOVC1ZsPPpugKF0bzhZ0GVxMrK9UJSmSTGy
	 m6Uah8opePsoJqw46hRWLmJG+V6xwshXZNvPzcQUu558/zOXTyRQ/agAemO9wB8RV/
	 EyBXGUMRGIDtg==
Date: Tue, 20 Aug 2024 09:19:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: don't extend the FITRIM range if the rt device
 does not support discard
Message-ID: <20240820161955.GF6082@frogsfrogsfrogs>
References: <20240816081908.467810-1-hch@lst.de>
 <20240816081908.467810-3-hch@lst.de>
 <20240816215017.GK865349@frogsfrogsfrogs>
 <20240819124407.GA6610@lst.de>
 <20240819150030.GO865349@frogsfrogsfrogs>
 <20240819150804.GA17283@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819150804.GA17283@lst.de>

On Mon, Aug 19, 2024 at 05:08:04PM +0200, Christoph Hellwig wrote:
> On Mon, Aug 19, 2024 at 08:00:30AM -0700, Darrick J. Wong wrote:
> > > This works.  OTOH it will break again with the zoned RT subvolume
> > > which can't support FITRIM even on devices that claim it.  And for
> > > actual users that care (and not just xfstests) these kinds of hacks
> > > don't seem very palatable..
> > 
> > What does discard do on a zoned device?  Is that how you reset the write
> > pointer?  And does that mean that either you tell the device to discard
> > everything it's written in a zone, or it will do nothing?
> 
> On an actual zone device it will probably do nothing.  But at least for
> NVMe the command used to implement discard is mandatory, so all
> devices will show support.  We also support the zoned mode on
> conventional devices, but instead of through FITRIM we want to issue
> it instad of a zone reset when the whole rtg has been garbage collected.
> 
> > Hmm.  No manpage for FITRIM.  Why don't we return the number of bytes
> > in the space map that we iterated as range.len?  Or perhaps leave it
> > unchanged?
> 
> The above would seem sensible.  Not sure if we can still pull it
> off, though.

It seems to have survived testing on TOT overnight, so I'll bake it into
djwong-dev when I go through and remove the rtgroups/rtsb feature bits
today.  And I guess the rtgroups xarray conversion too.

--D
