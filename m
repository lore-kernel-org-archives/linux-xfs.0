Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5715C1EA84
	for <linux-xfs@vger.kernel.org>; Sat, 14 Feb 2026 07:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771054774; cv=none; b=fTrMkzbT5OviFywiwufvUlIhcIFWMmGgLw/j35rtNPL2fiZ4EwxDCChAHvaXgtm+teFqqOf/ZPM8Tq7bYf/7EKJ6Bo4QNWtGWMuWs+7wfukfIpQKZzunm6ATxvNXECnS5b7sEKv7yf6sZkaVYC1DSX7JKIaleeEfNasLEN608Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771054774; c=relaxed/simple;
	bh=9TxshKJWzxKo5NdN6SnGQmMwZrLJxAopN9s2eVjot5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hw9Xr/6xVionrch5lnm31jvc9FMjTv9AVQCtcJHOoIdxHkjaDnszwG9W+SvjzAgVibb3Qib0qjGE/JlJDy+K93RbBYtNXBEB4e2ne+PUXoM9FkwqsqRXhrnL4shS5MNfe1ArdPp9G/pHslBglP9qf3iVVil9+/CziCreprvPF+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OKST9nu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OKST9nu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD9EC19421;
	Sat, 14 Feb 2026 07:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771054774;
	bh=9TxshKJWzxKo5NdN6SnGQmMwZrLJxAopN9s2eVjot5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OKST9nu1VA+tXqYMm3Emtrru1MfcvuTABlMOpvghGfaVnmW6vjuBJUtIRMJ/2Tbdv
	 Ijx1hH3BYqq0bk4e2W4CWAgUrQ/5OvzsDN5JjxS6sOfVFRb/MPlrvOwiNnadB2l+h8
	 cCf/1p/WqYWeD1DDJwM+8I+UQPa4RzVH43+TM+xHpvYs0c20Yxqap0iAm4/dYGEKN9
	 piXbS/lBGlZ7wlfr2lO8RZwFTWVPs+WpYMXVDJdku0bEeJbyQBPodfb1RjWAjdqoK5
	 T21cxF6h3OqcQ5mxRHIj9mMo7wyCtI4ZkVVEBzPxLRVKKIL998gn19C0Q4EHrZg7tW
	 gV0ZldFFSr4mQ==
Date: Fri, 13 Feb 2026 23:39:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: hch <hch@lst.de>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [bug report] xfs/802 failure due to mssing fstype report by lsblk
Message-ID: <20260214073933.GX1535390@frogsfrogsfrogs>
References: <aYWobEmDn0jSPzqo@shinmob>
 <20260206173805.GY7712@frogsfrogsfrogs>
 <aYlHZ4bBQI3Vpb3N@shinmob>
 <20260209060716.GL1535390@frogsfrogsfrogs>
 <20260209062821.GA9021@lst.de>
 <aYmRhwnL286jv550@shinmob>
 <20260210020040.GC7712@frogsfrogsfrogs>
 <aYrKf6ukceZrSRhJ@shinmob>
 <20260213221404.GH7712@frogsfrogsfrogs>
 <aZAU9J5nGAXQ6lyK@shinmob>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZAU9J5nGAXQ6lyK@shinmob>

On Sat, Feb 14, 2026 at 06:39:57AM +0000, Shinichiro Kawasaki wrote:
> On Feb 13, 2026 / 14:14, Darrick J. Wong wrote:
> [...]
> > Why doesn't udev record anything for
> > nullb0?  I suspect it has something to do with this hunk of
> > 60-block.rules:
> > 
> > ACTION!="remove", SUBSYSTEM=="block", \
> >   KERNEL=="loop*|mmcblk*[0-9]|msblk*[0-9]|mspblk*[0-9]|nvme*|sd*|vd*|xvd*|bcache*|cciss*|dasd*|ubd*|ubi*|scm*|pmem*|nbd*|zd*|rbd*|zram*|ublkb*", \
> >   OPTIONS+="watch"
> > 
> > This causes udev to establish an inotify watch on block devices.  When a
> > bdev is opened for write and closed, udev receives the inotify event and
> > synthesizes a change uevent.  Annoyingly, creating a new rule file with:
> > 
> > ACTION!="remove", SUBSYSTEM=="block", \
> >   KERNEL=="nullb*", \
> >   OPTIONS+="watch"
> > 
> > doesn't fix the problem, and I'm not familiar enough with the set of
> > udev rule files on a Debian 13 system to make any further diagnoses.  If
> > you're really interested in using nullblk as a ramdisk for this purpose
> > then I think you should file a bug against systemd to make lsblk work
> > properly for nullblk.
> 
> Darrick, thank you very much for digging it and sharing the interisting
> findings. Yes, it is really misterious why null_blk is not handled as other
> block devices. This motivated me to look into the udev rules, and I found that
> 60-persistent-storage.rules does this:
> 
> ...
> KERNEL!="loop*|mmcblk*[0-9]|msblk*[0-9]|mspblk*[0-9]|nvme*|sd*|sr*|vd*|xvd*|bcache*|cciss*|dasd*|ubd*|ubi*|scm*|pmem*|nbd*|zd*|rbd*|zram*|ublkb*", GOTO="persistent_storage_end"
> ...
> # probe filesystem metadata of disks
> KERNEL!="sr*|mmcblk[0-9]boot[0-9]", IMPORT{builtin}="blkid"
> ...
> LABEL="persistent_storage_end"
> 
> The "builtin-blkid" looks recording the block device attributes to the udev
> database. I added one more new rule file as follows on top of the rule file you
> added:
> 
> ACTION!="remove", SUBSYSTEM=="block", \
>   KERNEL=="nullb*", \
>   IMPORT{builtin}="blkid"
> 
> With this change, now lsblk reports that null_blk has xfs! I also confrimed that
> the test case xfs/802 passes.

Excellent!

> > > Anyway, I think blkid with --probe option is good for fstests usage, since it
> > > directly checks the superblock of the target block devices.
> > 
> > That's not an attractive option for fixing xfs/802.  The test fails
> > because xfs_scrub is never run against the scratch fs on the nullblk.
> > The scratch fs is not seen by xfs_scrub_all because lsblk doesn't see a
> > fstype for nullb0.  lsblk doesn't see that because (apparently) udev
> > doesn't touch nullb0.
> > 
> > The lsblk call is internal to xfs_scrub_all; it needs lsblk's json
> > output to find all mounted XFS filesystems on the system.  blkid doesn't
> > reveal anything about mount points.
> > 
> > Yes, we could change xfs_scrub_all to call blkid -p on every block
> > device for which lsblk doesn't find a fstype but does find a mountpoint,
> > but at that point I say xfs shouldn't be working around bugs in udev
> > that concern an ephemeral block device.
> 
> Thanks for the explanation. My take away is that systemd/udevd support is the
> prerequisite of fstests target block devices. I suggested blkid -p because I
> assumed that fstests would be independent from systemd/udevd. But the assumption
> was wrong.
> 
> My next action is to set up the udev rules for null_blk in my test environments.
> Thank you again for your effort.

If you decide to send a PR to systemd to fix the udev rules upstream,
please cc me if they push back.  Thanks for your persistence!

--D
