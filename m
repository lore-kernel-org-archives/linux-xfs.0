Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BE23B5DEE;
	Thu, 30 Jul 2026 15:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423884; cv=none; b=SnRyI74joMAob73B8rzcqwPPLKPHbvl3V2d87ssarYEqVceGBS02Ddq3p2geEadjUZpBC93sTswyfA6QXWcIBYlkRBRC9+YM7BCNaW4TWGxVRwLghrhY4QQ3rNJ9P5wWvwrIZtJM7WHSAIcL+Um66o1Kna1VA3dukb1+znBrnCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423884; c=relaxed/simple;
	bh=EpW0x2798AoiDoKb9rArQXNO5ZqU7NimtPjPdjk1Nhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aaAElcj4FTcRoj5s3nK4feG2FN+j0Flma1Qys84VK1WzVTKbmFv14QKYDw7x7zU0yPthuE5Y5VY4lgs/DuaIZXtEcpS2SjDH53eO68kU921v+RqqEhrc46im9FmhqHgozDt3C53fBCRucowKgIypHN0jz061vbqJvsKX4ACd7CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=orxrvFtz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="orxrvFtz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EB2E41F00A3A;
	Thu, 30 Jul 2026 15:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785423883;
	bh=fM/xKUOc6YWd1++R4Gf8HPdAr9fdBpqR9uClIyw/OVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=orxrvFtzGIaoNQZh15Ai7XfGp1pb0Ti5Vy9zbxMHh/ZJzGA880eQ+cgkoKFaJTy7O
	 th65ms1sz2XbL+91LyXH55Ig5u4eHrWX60Gj8UzWVpgisnRNqy24UeC7DuQBMwNGN5
	 aNvB7YsnDfdkmoykeUh2akrUM7L87tSdIGhlIKA3fhQUBa/ss1dxolBowb8vg0AyrQ
	 MtQDlD1D42tD1RMkmrwh6UDISUNFTrn9ECtMAbvjLs9NdnJ1c0SRUZqxFnT+LkVYFw
	 DRO8yhJDxi3PhJEMzmRNiyIH6ck2Ko/ZNyoS7CB7Br804uKv6SHfyI2+qsppVha57L
	 bD8l4UzG5A6MQ==
Date: Thu, 30 Jul 2026 08:04:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: adjust datadev sector count to reflect internal
 rt volumes
Message-ID: <20260730150442.GA3556460@frogsfrogsfrogs>
References: <178538912844.4070956.17029198681620903700.stgit@frogsfrogsfrogs>
 <178538912986.4070956.14205556423461124701.stgit@frogsfrogsfrogs>
 <20260730082204.GE10558@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730082204.GE10558@lst.de>

On Thu, Jul 30, 2026 at 10:22:04AM +0200, Christoph Hellwig wrote:
> On Wed, Jul 29, 2026 at 10:27:20PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > A media scan of a filesystem containing an internal rt volume produced
> > an error in xfs_scrub phase 6 complaining about a truncated realtime
> > device.  The rt device wasn't truncated, but the media scan code thought
> > we were trying to start a scan past the end of m_rtdev_targp.  That in
> > turn is an alias for m_ddev_targp, but in xfs_configure_buftarg we set
> > nr_sectors to the size of the data section.  Oops.
> > 
> > On these filesystems, the internal rt section comes immediately after
> > the data section.  We need to set the sector count for the data device
> > buftarg to the size of both sections.  Without this, media scans don't
> > work and media failure notifications from the kernel will be discarded
> > silently.
> > 
> > We also need to fix the superblock buffer recovery code to do the same.
> 
> This feels wrong.  Nothing should acess the internal rtdev through
> the data device buftarg.

It's the only one available, because xfs_setup_devices aliases
ddev_targp to rtdev_targp for internal rt volumes:

	if (mp->m_sb.sb_rtstart) {
		if (mp->m_rtdev_targp) {
			xfs_warn(mp,
		"can't use internal and external rtdev at the same time");
			return -EINVAL;
		}
		mp->m_rtdev_targp = mp->m_ddev_targp;
	}

So we're doing that anyway.  We could separate them by creating a second
buftarg with a duplicate struct file, but that would involve a bunch of
rototillingi because a fair amount of code changes behavior on
rtdev==ddev now.

The only field that the media verification code uses is bt_nr_sectors,
which it uses to trim verification requests to wherever the filesystem
thinks is the end of the device.  I could change that to call
bdev_nr_sectors() to fix the bug, but then we'd have to deal with media
failures for LBAs outside of the filesystem, which didn't seem ideal.

Also, if someone asynchronously reports a media error in the internal
rtdev to us through fs_holder_ops, the report will mention a range that
is beyond bt_nr_sectors but actually within the filesystem.
xfs_dax_notify_failure currently does the right thing because it doesn't
check bt_nr_sectors, but that also feels wrong. ;)

So I went with making bt_nr_sectors bigger because that felt the least
awkward.  IIRC it's supposed to represent the location of the end of the
filesystem on a particular blockdev, not the highest LBA that the fs
can xfs_buf_read(), right?

> Is this an LLM report bug, or did you actually run it using scrub?  If
> so can you help with the reproducer?

I found it accidentally while triaging another bug that LOLLM found.
I turned on the tracepoints (and btrace) for debugging and noticed that
it wasn't issuing reads for the internal rt device:

# mkfs.xfs /dev/sda -r zoned=1
# mount /dev/sda /mnt/scratch
# trace-cmd <big ugly command line> &
# xfs_io -x -c 'verifymedia -r' /mnt/scratch

--D
