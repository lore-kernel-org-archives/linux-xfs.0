Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229F0363C68
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 22:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772749117; cv=none; b=ea8GSalf6Wp3jrZSfVG+m/DstMELhMbPXnhcL9ysKGp7Q/WyYrpfFTA9ENvWBcqKHHWWo+FxS7pE8EkPPWkToHE1m9Ym3YFZM4gGB/75TSSU7rWDK0UNtrbfcGkb1H5QYUkuBdXeodIDhd9goJy58g0IwYW4g9NPlj3LtIrOfcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772749117; c=relaxed/simple;
	bh=ey9CyW+wd6igy6u2CDpzhwy5bguCNG1+/SMdgvOOBz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UxrNKQXe2Ruh+KtY/cy5IFCk2zjEA3zKgCUG6FcnksG/ba4qLPjzAjTu3QF7aYIwg8EJnXdUDS+oBiVpYEB2lW953ot4Tt3xJltRG2DkqD6F254lgkR1ocYb+mi4zVHJpLNN/2ejYQdAavwpGgnYSyyJpq3OCqXcKRhVWlFEiQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d35L1GwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d35L1GwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84141C116C6;
	Thu,  5 Mar 2026 22:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772749116;
	bh=ey9CyW+wd6igy6u2CDpzhwy5bguCNG1+/SMdgvOOBz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d35L1GwBrJqoMg3gMy9XG40Fja4R1KF516SPeYZvYC/NWJV5s+DzZSMDoZHJDP6V7
	 7tK9UtNm3+Dfw/Pddd76HXNHlgQT2GBa345yTnYao7oqUFbf7lY4WxNL0TftF/kxQX
	 6G/h0aI61GfpjUtF9w0i670a3HXnRzsTEwZE9igWBHVKRSYLVmRc0PGHnpKPsU4UaS
	 lePuKdxIpd67bYZp6trMuyXFNoZ/HEhq2vgmxwRz0VFBavv3lahTxLMhI/6RxoWZU7
	 mZTe52avUb5iEaP5VLMavt2KQhd+lzzNWzMBY2Jdpg720hrVOYcHEJjob3FEVqTynr
	 N1uNu71q3pAPQ==
Date: Thu, 5 Mar 2026 14:18:35 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/26] debian: enable xfs_healer on the root filesystem
 by default
Message-ID: <20260305221835.GI57948@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783748.482027.8553755838914398859.stgit@frogsfrogsfrogs>
 <aacFKgnRvvhSVsH_@infradead.org>
 <20260303171400.GP57948@frogsfrogsfrogs>
 <aagtR_YU0gOwAZCs@infradead.org>
 <20260305221050.GH57948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305221050.GH57948@frogsfrogsfrogs>

On Thu, Mar 05, 2026 at 02:10:50PM -0800, Darrick J. Wong wrote:
> On Wed, Mar 04, 2026 at 05:01:59AM -0800, Christoph Hellwig wrote:
> > On Tue, Mar 03, 2026 at 09:14:00AM -0800, Darrick J. Wong wrote:
> > > A lot depends on the distro -- RHEL and SUSE require the sysadmin to
> > > activate services.  Debian turns on any service shipping in a package by
> > > default, which is sort of funny since they don't enable online fsck in
> > > their kernel at all, so all the healer services fail the --supported
> > > checks and deactivate immediately.
> > 
> > So this patch doesn't make much sense right now?
> > 
> > Either way it really should have these details in the commit log.
> 
> <shrug> I'll amend the commit message:
> 
>     Note that this won't do much right now because Debian doesn't enable
>     online fsck in their kernels, so the ExecCondition will return false
>     and the service won't actually activate.

Though now I see that the first part of the commit message is also out
of date (we don't do udev anymore) so let's just replace the whole thing
with:

"debian: enable xfs_healer on the root filesystem by default

"Now that we're finished building autonomous repair, enable the healer
service on the root filesystem by default.  The root filesystem is
mounted by the initrd prior to starting systemd, which is why the
xfs_healer_start service cannot autostart the service for the root
filesystem.

"dh_installsystemd won't activate a template service (aka one with an
at-sign in the name) even if it provides a DefaultInstance directive to
make that possible.  Hence we enable this explicitly via the postinst
script.

"Note that Debian enables services by default upon package installation,
so this is consistent with their policies.  Their kernel doesn't enable
online fsck, so healer won't do much more than monitor for corruptions
and log them."

--D
