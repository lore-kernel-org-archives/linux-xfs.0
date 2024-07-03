Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07B54502F
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 04:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719982541; cv=none; b=uWZfELAsQofrpcpVjADsScZA2xLYSsU7ifqFzwwfJk7iCJ9GKFO1TRjsH98x73adTLMFek4HfqUw/k7/+OqFA7Hi6k9k3aNa2Bx81VqVimzqg17DkKQLEDly5G+X5PDZ9NaCl8ZLNJslN2wMU6hbmetVzmgplpLXBZn/Q4KGVVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719982541; c=relaxed/simple;
	bh=MgFbMBYdSzymYreC4ea3YZ2IJL06JoOC/btCOi0yduM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cNJEvL38AfWp13KhMaJo4LS3czrFsMFUL+hPCq7K6Z83fAWmPsMrSGeQ4ml21W8LoL3v15NztxXLCYJoxnoP76GdsXDDwI2ptUDv0FSPIgAck0PNtxkClEQ22trLgKpE6xDC49NzB6N/XQgiMnBohHBHLFvE2KbrM2USKnVcVTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jirIZOdu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jirIZOdu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F905C4AF0A;
	Wed,  3 Jul 2024 04:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719982540;
	bh=MgFbMBYdSzymYreC4ea3YZ2IJL06JoOC/btCOi0yduM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jirIZOduhmov0EAftBIcLiTjDhxl/wPRBRsu2IyqB+Qm+Hz1//Rr7HI9hTY9MY7wD
	 lVPN/UtVHUG+X/LCwsVXA9xje86EV/u5hGHHQqmkPRXhnnbV297s9NK63TkjemyHNq
	 sQ9t43rNuELwM6nITwRHKXJ4+ZRrgsytN3AxXmExi9u4Taz+XiV27rTAx5Cl6ZB6sV
	 uI7PbXiWx1JKaqa2iG/V7Ia++VZbzZlJJcbpsV5XEPC0EEYZ+wu3tvLr2cwe/rPFy5
	 fJTp/B87UTNLbY4Nwe198tZ3VkMHXvYgTf6q3/A6kQRjzNnC0EkkBdSBNnDtv/iSSD
	 biMkdYuBkDABQ==
Date: Tue, 2 Jul 2024 21:55:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs_scrub: tune fstrim minlen parameter based on
 free space histograms
Message-ID: <20240703045539.GZ612460@frogsfrogsfrogs>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs>
 <171988118687.2007921.1260012940783338117.stgit@frogsfrogsfrogs>
 <20240702053627.GN22804@lst.de>
 <20240703022914.GT612460@frogsfrogsfrogs>
 <20240703042922.GB24160@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703042922.GB24160@lst.de>

On Wed, Jul 03, 2024 at 06:29:22AM +0200, Christoph Hellwig wrote:
> On Tue, Jul 02, 2024 at 07:29:14PM -0700, Darrick J. Wong wrote:
> > Oooh, that's a good idea.  Let me fiddle with that & tack it on the end?
> > 
> > Hmm.  How do we query the discard granularity from a userspace program?
> > I can try to guess the /sys/block/XXX root from the devices passed in,
> > or maybe libblkid will tell me?  And then I'd have to go open
> > queue/discard_granularity underneath that to read that.
> 
> Good question.  As far as I can tell there is no simply ioctl for it.
> I really wonder if we need an extensible block topology ioctl that we
> can keep adding files for new queue limits, to make it easy to query
> them from userspace without all that sysfs mess..

Yeah.  Or implement FS_IOC_GETSYSFSPATH for block devices? :P

> > That's going to take a day or so, I suspect. :/
> 
> No rush, just noticed it.  Note that for the discard granularity
> we should also look at the alignment and not just the size.

<nod> AFAICT the xfs discard code doesn't check the alignment.  Maybe
the block layer does, but ... weirdly we've now refactored
xfs_discard_extents so that it /never/ reports errors of any kind in the
submit loop because __blkdev_issue_discard always returns 0, and the
endio doesn't check the bio status either.

--D
