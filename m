Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4442346FAD
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 22:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772749339; cv=none; b=TvyZOTXTwr334+oBn474gtRXJQyyr3Fp7A9W/tuxtvEO1kHPGKffYFeb2Ux9iGDrYDew5OC7TciNXUfBdEeJKA015L6J1NOg472BF/P2GjE0spM6tSp+pkcwBy3hXyU11VHH+HYzCAgaKHcuGl4eLuUjpAzbYfaLLYT7CMK6QdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772749339; c=relaxed/simple;
	bh=PmG+qRNFv5V9VS8owErMUV+K87UmQBQs0FXK4udvQH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ng9YFRFUbsnummVg26ijrrdKe0+pUQLnyroPIoWAPhZ9Z36FQ9K0gk411l/Vl72qH81PSbW1l9YHrI834JkGTkYRt76N9ABO6L3f9CjGgxER+x/+CtpT1cpkkDJXdwrspnBqGYnc2MkwEU2LbPtAmGoLHvVg3jiwJF9WjPju9GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NHBC8O03; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NHBC8O03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C5AC116C6;
	Thu,  5 Mar 2026 22:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772749339;
	bh=PmG+qRNFv5V9VS8owErMUV+K87UmQBQs0FXK4udvQH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NHBC8O03gyRbTsDJFWj4WV9a3aGtvIn6U0tTzQm1rbX8I2rflFderLnnJ9gkTp5yP
	 1b573a9k2Q64HXTl4GvpCKkpFI2guFlMamsp6xD2suzigCunvYB+wvZwgLzdQxOf61
	 R9973jTn2Ib91tNY6c7BlPWwllXszw8SG5s60CVSndS5CkrOkJ3qohI4kVIrsStF3b
	 t0BtwU6kJ1Y5c9j5KdvYHC+KIhfSMPKNdPNZQ7qxW7zgc6Hji12tpmlx9A+MIgXpsx
	 YvbX8CqjrWoQkpd0OfgrzwI3KQf1Oy1g1hWc7iPqGSjRcPXnk14auuxN3vBW/2NmFM
	 2Hli6Jj3slA2A==
Date: Thu, 5 Mar 2026 14:22:18 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/26] mkfs: enable online repair if all backrefs are
 enabled
Message-ID: <20260305222218.GJ57948@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783730.482027.15356275256378511742.stgit@frogsfrogsfrogs>
 <aacFDgyTFG8OhJOM@infradead.org>
 <20260303173203.GS57948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303173203.GS57948@frogsfrogsfrogs>

On Tue, Mar 03, 2026 at 09:32:03AM -0800, Darrick J. Wong wrote:
> On Tue, Mar 03, 2026 at 07:58:06AM -0800, Christoph Hellwig wrote:
> > On Mon, Mar 02, 2026 at 04:40:05PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > If all backreferences are enabled in the filesystem, then enable online
> > > repair by default if the user didn't supply any other autofsck setting.
> > > Users might as well get full self-repair capability if they're paying
> > > for the extra metadata.
> > 
> > Does this cause scrub to run by default or just healer on demand?
> > People might not be happy about the former.
> 
> Ultimately it's up to the distro to decide if (a) they turn on the
> kernel support and (b) enable the systemd services by default.  Setting
> the fsproperty just means that you'll get different levels of
> online repair functionality if the user/sysadmin/crond actually invoke
> the services.
> 
> (That said, I was wondering if it was time to get rid of all the Kconfig
> options...)

And here's where I'll add the note about distro policies:

"mkfs: enable online repair if all backrefs are enabled

"If all backreferences are enabled in the filesystem, then enable online
repair by default if the user didn't supply any other autofsck setting.
Users might as well get full self-repair capability if they're paying
for the extra metadata.

"Note that it's up to each distro to enable the systemd services
according to their own service activation policies.  Debian policy is to
enable all systemd services at package installation but they don't
enable online fsck in their Kconfig so the services won't activate.
RHEL and SUSE policy requires sysadmins to enable them explicitly unless
the OS vendor also ships a systemd preset file enabling the services.
Distros without systemd won't get any of the systemd services,
obviously."

--D
