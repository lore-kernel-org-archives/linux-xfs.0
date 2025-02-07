Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDC123C8CE
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 19:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738956678; cv=none; b=OygIDXhBa55i46KT4YVrO/Gch+Yhi8SDAtaT9cqq/nX+SB35DYhycGtbrAgjq6Z3yySND/uTjZylzEKHxHHdr3nXicMCLhVU2DNzhguItJgAb5xkKuf5JgIqP3wmzzYHQ7tfzZ/oG/uqHOEbMUBe5t4wgOeyZ1/hiRZ3tBHx8A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738956678; c=relaxed/simple;
	bh=ff2tNO+dyXrI6KiVXgcrVu9iSQLmOOgHLdGIZKgtZvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jf+oR/ZaOX0pgyk9DeWDP6sNJbovSGSPGV1B9ZjeSQzgGuTdn2N3lKPqzJ4CUIYWcI0QAwnEFObjdgwuw0D0yFEp+Ro3lKbDl7jo86X50k918m3e5Mrlb9XrXq+W5N2lV3V7x8f0KjFCM8RoBs4A2IV0bSQBxbqm2BmTrr9dwck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d6RoO6t9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d6RoO6t9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE664C4CED1;
	Fri,  7 Feb 2025 19:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738956677;
	bh=ff2tNO+dyXrI6KiVXgcrVu9iSQLmOOgHLdGIZKgtZvg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d6RoO6t9Yy9lYpzO3SjfOmNzK8D2htngPdm2PwHZscV+ezg5F5xVh9vS/QcJ62uq9
	 Oedow9Jm6oymhXd1FGM9NVP2O+Anl0lX3h7oKauk/Pyo+HypaaeSztmj36mnx3dk4f
	 89AqBy5FzAjJK4FOkr496dVXC5Fdd5G9srYaL4BOKIdbWYC5ZzeOY3iJnczisn1ldl
	 1l8MP2MZPqoITB2pEAQZw2O0iyWLPt8EwkJEnfSJwjqQLnA0XyRtp7uLDTL6gZn6g0
	 aWOY14rWllHVMJL8Qlljwumdd6Utnlut5t9676fV4sxuZy4d19kUPGNOrpFuB26ZPP
	 GsrAjv1nyLgFA==
Date: Fri, 7 Feb 2025 11:31:17 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: da.gomez@kernel.org, linux-xfs@vger.kernel.org,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com
Subject: Re: [PATCH] mkfs: use stx_blksize for dev block size by default
Message-ID: <20250207193117.GC3028674@frogsfrogsfrogs>
References: <20250206-min-io-default-blocksize-v1-1-2312e0bb8809@samsung.com>
 <20250206222716.GB21808@frogsfrogsfrogs>
 <Z6ZeXJc3jw-kHKGa@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z6ZeXJc3jw-kHKGa@bombadil.infradead.org>

On Fri, Feb 07, 2025 at 11:26:20AM -0800, Luis Chamberlain wrote:
> On Thu, Feb 06, 2025 at 02:27:16PM -0800, Darrick J. Wong wrote:
> > NAME                     MIN-IO
> > sda                         512
> > ├─sda1                      512
> > ├─sda2                      512
> > │ └─node0.boot              512
> > ├─sda3                      512
> > │ └─node0.swap              512
> > └─sda4                      512
> >   └─node0.lvm               512
> >     └─node0-root            512
> > sdb                        4096
> > └─sdb1                     4096
> > nvme1n1                     512
> > └─md0                    524288
> >   └─node0.raid           524288
> >     └─node0_raid-storage 524288
> > nvme0n1                     512
> > └─md0                    524288
> >   └─node0.raid           524288
> >     └─node0_raid-storage 524288
> > nvme2n1                     512
> > └─md0                    524288
> >   └─node0.raid           524288
> >     └─node0_raid-storage 524288
> > nvme3n1                     512
> > └─md0                    524288
> >   └─node0.raid           524288
> >     └─node0_raid-storage 524288
> 
> Can you try this for each of these:
> 
> stat --print=%o 
> 
> I believe that without that new patch I posted [0] you will get 4 KiB
> here. Then the blocksize passed won't be the min-io until that patch
> gets applied.

Yes, that returns 4K on 6.13.0 for every device in the list.  I think
you're saying that stat will start returning 512K for the blocksize if
your patch is merged?

> The above is:
> 
> statx(AT_FDCWD, "/dev/nvme0n1", AT_STATX_SYNC_AS_STAT|AT_SYMLINK_NOFOLLOW|AT_NO_AUTOMOUNT, 0,
> {stx_mask=STATX_BASIC_STATS|STATX_MNT_ID, stx_attributes=0,
> stx_mode=S_IFBLK|0660, stx_size=0, ...}) = 0
> 
> So if we use this instead at mkfs, then even older kernels will get 4
> KiB, and if distros want to automatically lift the value at mkfs, they
> could cherry pick that simple patch.

How well does that work if the gold master image creator machine has a
new kernel and a RAID setup, but the kernel written into the gold master
image is something older than a 6.12 kernel?

--D

> 
> [0] https://lkml.kernel.org/r/20250204231209.429356-9-mcgrof@kernel.org
> 
>   Luis
