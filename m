Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B3470830
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 16:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744303263; cv=none; b=fIqptd0BfhLmBCjfQLLFGILMnBZaiG0SMxzUltneHS6F/B91VhcaKP+S35cfyoWgvMz1u+CK3sy6ONDFV4PwA20A51oN1LmRPfZtWx+AgTMGOnUif2yQxHYW30xjD1ytkZ0O0sTcBIUiOMdLf35dPdbWH6+KeWPgJsXH7PWm21o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744303263; c=relaxed/simple;
	bh=+m5PDMNoiub7V7y58uaGEAPWtXQaHbmZdXfQM5tx6oo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gf5Fn6K81pTg+rnsbeGizUVLOia8k3P1VkYiKKaPehU8kQDZ/C6x8PrhM7kEJlAwVM23dHyEPSp+ZiBaMpF8Kt1mHxqd7wGnr0bZoDpwicYiTMULYrsW4UXyR+sTFEMjmqwD8TguRF1ezr5vBDtfUJcPKMRO8ziHRktsipQk3Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bk0lOQ74; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bk0lOQ74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D903CC4CEE9;
	Thu, 10 Apr 2025 16:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744303262;
	bh=+m5PDMNoiub7V7y58uaGEAPWtXQaHbmZdXfQM5tx6oo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bk0lOQ74ih8HGpuBv/nCYjaCUbI5INOrc2FmOJNn+Sz3Vbg9PG2B7SNIIKGcsZGv9
	 QJ4sG2kug0o5BwnYplqT2ukoZQRCI2Kd9aLI19DGlKUcmIRlk8KV7+EXXT/03q09Ma
	 3CVm9pvKSEVzHVJg0wUZE7Xv8qAcrWdeFfGziHGNvvwFAkeXznFy7uwHrQ9MXbUr++
	 WmApODAzMUNKDApOqq+z9NZ6GM9KD6XCO1KHVDNiaYmEm9WlT89kpRVQN5Bn2zsYRf
	 OcIVBIGgqdZergKy/wymVTtvdl9NrhDWTBFFLKe9cSPmiI1JgY3ReDdfTONXnqpLBa
	 3mQjSqn2UBxMQ==
Date: Thu, 10 Apr 2025 09:41:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/45] xfs_repair: support repairing zoned file systems
Message-ID: <20250410164101.GZ6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-28-hch@lst.de>
 <20250409161012.GC6283@frogsfrogsfrogs>
 <20250410062749.GB31075@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410062749.GB31075@lst.de>

On Thu, Apr 10, 2025 at 08:27:49AM +0200, Christoph Hellwig wrote:
> On Wed, Apr 09, 2025 at 09:10:12AM -0700, Darrick J. Wong wrote:
> > On Wed, Apr 09, 2025 at 09:55:30AM +0200, Christoph Hellwig wrote:
> > > Note really much to do here.  Mostly ignore the validation and
> > > regeneration of the bitmap and summary inodes.  Eventually this
> > > could grow a bit of validation of the hardware zone state.
> > 
> > What do we actually do about the hardware zone state?  If the write
> > pointer is lower than wherever the rtrmapbt thinks it is, then we're
> > screwed, right?
> 
> Yes.  See offlist discussion with Hans.

To summarize -- in the ideal world we'd have another file mapping extent
state for "damaged".  Then we could amend the media error handler (aka
the stuff in xfs_notify_failure.c) to set all the mappings to damaged
and set an inode flag saying that the file lost data.  Reads to the
damaged areas would return EIO.  We'd also be able to report to
userspace exactly what was lost.

Unfortunately we don't really have that, so all we can do with the
current ondisk format is ... remove the mappings?

> > Does it matter if the hw write pointer is higher than where the rtrmapbt
> > thinks it is?  In that case, a new write will be beyond the last write
> > that the filesystem knows about, but the device will tell us the disk
> > address so it's all good aside from the freertx counters being wrong.  I
> > think?
> 
> Yes.  That's actually a totally expected case for an unclean shutdown
> with data I/O in flight.  freertx is recalculate at each mount, and
> the space not recorded in the rmapbt is simply marked as reclaimable
> through garbage collection.

<nod> Ok, that's what I thought was going on, thanks for the reminder.

--D
