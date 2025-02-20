Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2167E1D5CDD
	for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 16:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740070673; cv=none; b=s/1xbI1BgAGIhT01ST/dfH1gNpfWn+xV+PWrluhlR0GlqTUJ7L02S5jIjDi4NVRRq/PmVrLgU1GekwVEzsrWRUABwqX2UkixP0x04mg5dP0W4wfkOAbOslHZtpV9r+rmR78YDEuIgXnJl93rhZHsiFJ17XVLTrt4IhrC5mrqWyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740070673; c=relaxed/simple;
	bh=jPldgbPfv7jdY/7ibcqc8bITCkSlDgwhyXDrKNREQ9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ba62CVwcbA2i1Zu7tJZL0MdGwDq9suvbCBl+zf1w56IK6fsnuroFIDA+E75vzUlHPP/P2LSa4K7+NZe5p/7mkxO+ncw4HP6W3k/ftrVVjMiVyPCPf6fEEfIJvKeA70g7LaihwwDDg7ROyuRyXcUMFjCndDHYkf/uXcAxpMEsa60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IymZeauy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IymZeauy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE0BC4CEE2;
	Thu, 20 Feb 2025 16:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740070672;
	bh=jPldgbPfv7jdY/7ibcqc8bITCkSlDgwhyXDrKNREQ9A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IymZeauymC/LWfOar2NTX6XeFHj+IgrvXBQ66jQ/qSCUv0xytnBI4x6AdJjCbEqMw
	 EeK+UTEb/1WRswV2C1WdRP3vbgtQGPzQnICNLUXmP6YUmnaEFWJkd+0Ckm1ddC1CwK
	 PWGz+hCU8w/ADNXMcttjsq9OPbtuGwPowsrAoK5vAiJOhs/iKrYZSH9y74ToYuMJLm
	 jOJbVOZR6hSV7Kblu8KDSFm5sj6AYOVhpS53oOOptoFSU+ULzgEW63YRB9UPbAP8KG
	 qngP9XmVK0SZj7H62xbgAPJperchG90f1KojDB0PRs0zNs3hRRq2scvAChYyHBpboN
	 TJ/OkFUXwev/Q==
Date: Thu, 20 Feb 2025 08:57:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/45] xfs: implement buffered writes to zoned RT devices
Message-ID: <20250220165751.GQ21808@frogsfrogsfrogs>
References: <20250218081153.3889537-1-hch@lst.de>
 <20250218081153.3889537-28-hch@lst.de>
 <20250219214727.GV21808@frogsfrogsfrogs>
 <20250220061604.GA28550@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220061604.GA28550@lst.de>

On Thu, Feb 20, 2025 at 07:16:05AM +0100, Christoph Hellwig wrote:
> On Wed, Feb 19, 2025 at 01:47:27PM -0800, Darrick J. Wong wrote:
> > I don't want to go adding opencoded logic loops all over the place, that
> > would be pretty horrid.  But what if xfs_zone_alloc_ctx were instead a
> > general freecounter reservation context?  Then we could hide all this
> > "try to reserve space, push a garbage collector once if we can't, and
> > try again once" logic into an xfs_reserve_space() function, and pass
> > that reservation through the iomap functions to ->iomap_begin.
> > 
> > But a subtlety here is that the code under iomap_file_buffered_write
> > might not actually need to create any delalloc reservations, in which
> > case a worst case reservation could fail with ENOSPC even though we
> > don't actually need to allocate a single byte.
> 
> I think the idea of per-reserving space before starting transactions
> is generally a good idea, and I'd be happy to look into reworking the
> conventional code towards that.  But I'd rather not do that as part
> of this series if I can avoid it.
> 
> > Having said that, this is like the 5th time I've read through this patch
> > and I don't see anything obviously wrong now, so my last question is:
> > Zoned files cannot have preallocations so that's why we don't do this
> > for FALLOC_FL_ALLOCATE_RANGE, right?
> 
> Exactly.  Should I add this to the commit log?  It's mentioned mostly
> in the cover letter at the moment.

That seems like a good idea.

--D
