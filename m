Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70B71891A9
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 19:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738957445; cv=none; b=MWIC/yQAydu5qktcA9AHbdATwBxW4CG9Xqlg23wiBy1FSM98TTvNuBZ5PUkJN2KY7i9Ysz+yFRp2h9egvhuGJXnU1OqwGGc12NJvEyMNX5o13oEY2Xc6Cu9cdn0zTEL6fS8KBTj897l3FpVQMJN3D6ghzgibW+NkOFB84ISyli8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738957445; c=relaxed/simple;
	bh=XerWHPz2Gr/HmAjw5RwxUAIbGUdEWvZRXiFYsePm3h8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uzYNEYsdhEQbhlAowuSydymIC9gAYCwgXLuhBFkOGR/AupoqXcBhp4ne6ltu6K0B9gZdICjBeTZndYAaA2guGRD4lr/yfTXGzekP3uE0Rhqdm0AmFwUM7HlP55Gz+tzNzcWH0SlDXUg8AJxEV48X7ldQIPhTpKOXy1TwMwIQyHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R713xLvH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R713xLvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA47BC4CED1;
	Fri,  7 Feb 2025 19:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738957445;
	bh=XerWHPz2Gr/HmAjw5RwxUAIbGUdEWvZRXiFYsePm3h8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R713xLvHfBMQES9YO9D+OHCiA0+33vVUHFKixnoVj7/KD5H1uAz+mL1XPXetkkK26
	 Ah8H2CA4iojhag+OFxJWNle3zvyMmW5QxY9XWR4oGZ9u3nxiQRC1iMy8npv8ziKbha
	 mE3U+yGnjFPEmWTHUCJSeQTA5hDlbLkvoyQFipQwNSPLRB1UtBUvJqCOyt1r226+8j
	 OgXcuYiIV61J8iQfNBvQi8KA/ahqBBR6lxgkBG431+Tq+jAlNKx/5r0wrJ6wCjJ1Za
	 hohB4uCeb17hoJUsSIBmArncrA+X8kMRa+xqydoTatQQMkUCZ9pMJ+yLmskXAoDBK3
	 tuK2lo+IpXNRQ==
Date: Fri, 7 Feb 2025 11:44:03 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: da.gomez@kernel.org, linux-xfs@vger.kernel.org,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com
Subject: Re: [PATCH] mkfs: use stx_blksize for dev block size by default
Message-ID: <Z6Zig_qq926rL6gO@bombadil.infradead.org>
References: <20250206-min-io-default-blocksize-v1-1-2312e0bb8809@samsung.com>
 <20250206222716.GB21808@frogsfrogsfrogs>
 <Z6ZeXJc3jw-kHKGa@bombadil.infradead.org>
 <20250207193117.GC3028674@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250207193117.GC3028674@frogsfrogsfrogs>

On Fri, Feb 07, 2025 at 11:31:17AM -0800, Darrick J. Wong wrote:
> On Fri, Feb 07, 2025 at 11:26:20AM -0800, Luis Chamberlain wrote:
> > On Thu, Feb 06, 2025 at 02:27:16PM -0800, Darrick J. Wong wrote:
> > > NAME                     MIN-IO
> > > sda                         512
> > > ├─sda1                      512
> > > ├─sda2                      512
> > > │ └─node0.boot              512
> > > ├─sda3                      512
> > > │ └─node0.swap              512
> > > └─sda4                      512
> > >   └─node0.lvm               512
> > >     └─node0-root            512
> > > sdb                        4096
> > > └─sdb1                     4096
> > > nvme1n1                     512
> > > └─md0                    524288
> > >   └─node0.raid           524288
> > >     └─node0_raid-storage 524288
> > > nvme0n1                     512
> > > └─md0                    524288
> > >   └─node0.raid           524288
> > >     └─node0_raid-storage 524288
> > > nvme2n1                     512
> > > └─md0                    524288
> > >   └─node0.raid           524288
> > >     └─node0_raid-storage 524288
> > > nvme3n1                     512
> > > └─md0                    524288
> > >   └─node0.raid           524288
> > >     └─node0_raid-storage 524288
> > 
> > Can you try this for each of these:
> > 
> > stat --print=%o 
> > 
> > I believe that without that new patch I posted [0] you will get 4 KiB
> > here. Then the blocksize passed won't be the min-io until that patch
> > gets applied.
> 
> Yes, that returns 4K on 6.13.0 for every device in the list.  I think
> you're saying that stat will start returning 512K for the blocksize if
> your patch is merged?

Yes, as that *is* min-io for block devices.

> > The above is:
> > 
> > statx(AT_FDCWD, "/dev/nvme0n1", AT_STATX_SYNC_AS_STAT|AT_SYMLINK_NOFOLLOW|AT_NO_AUTOMOUNT, 0,
> > {stx_mask=STATX_BASIC_STATS|STATX_MNT_ID, stx_attributes=0,
> > stx_mode=S_IFBLK|0660, stx_size=0, ...}) = 0
> > 
> > So if we use this instead at mkfs, then even older kernels will get 4
> > KiB, and if distros want to automatically lift the value at mkfs, they
> > could cherry pick that simple patch.
> 
> How well does that work if the gold master image creator machine has a
> new kernel and a RAID setup, but the kernel written into the gold master
> image is something older than a 6.12 kernel?

I think you're asking about an image creator for an old release and that
old release uses an old kernel. Isn't that the same concern as what if
the same new kernel creates a filesystem on an image for an old release?
If so the risk is the new kernel defaults take precedence.

And the only thing I can think of for this case an option to ignore this
heuristic for blocksize, which could be used on configs to override
defaults for older target kernels.

  Luis
