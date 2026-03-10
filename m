Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC173D0906
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 20:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773173188; cv=none; b=fijmjPJYRSGZg4Y7zXRJ/FK/wRsW+OLBsRgDsk0DF5QIxXoHo+vBLTWznD0Lt4IQ8Ritw7J+Eyux2GmQHkEzBMhh6kXFvoc5+1bNu+E4T+OVCZjG1yQi7pmgrf/uzvy0MZ7vCiCVitNOSME50x3lxam3XSxIy5sSWRksKDjDQ4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773173188; c=relaxed/simple;
	bh=RFRL2YT7EQhKFxjwJgN9nWW75kqD7nFc/B2SZt14Crs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T/oIrmH0UHWubMVTsgmjX1RviLp3uYy9838nPafC+L1H6RQgpezT4wufsSXat/D6r6rJyMqmhftPRcvOvy4AynesaHIoFowqxCBmqk7BVxaMpJLCfQOmpCtNOJcKdExn+HJiGMmQBt16A+l+XxisJsl14ZAbKdap8TJHYu33nXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YF2auV/k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YF2auV/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BB4C2BCB2;
	Tue, 10 Mar 2026 20:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773173187;
	bh=RFRL2YT7EQhKFxjwJgN9nWW75kqD7nFc/B2SZt14Crs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YF2auV/k9sQ0s+H1Bm7jUxPS5T8i64r+opWY3zwpHEp1AWi5eV0s/sX7foQiLv8Wo
	 w53zfOfwD8O6p0BLB71z4ORCu5dMByIu5xkikUWLF7xoCTCOi9Nlz9phF4P1ZqyrBI
	 hePL5Ogklw1+UcEMbC2wn5y+u+7jTckhnoFWZEm1bx07O6LUMtLwMygFTYm3E/f6Be
	 EVTRtDwF6G6HdHVEVNreHVznDb0gw44pbZTBCXNJ+qXwxtw7EkY7LLd+tgJGI6NLhZ
	 c3PRTs/K/6iU2gbEbuJqYwOhrng0wXGexUOrtNHZ35kJ4/QJdtd6VorFwPP9Na9hBP
	 T+yoYPIHYtR9g==
Date: Tue, 10 Mar 2026 13:06:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/28] xfs_healer: use statmount to find moved
 filesystems even faster
Message-ID: <20260310200626.GU1105363@frogsfrogsfrogs>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
 <177311401806.1183235.3840165745930552108.stgit@frogsfrogsfrogs>
 <aa_kSzpFeT7nuJeW@infradead.org>
 <20260310185622.GT1105363@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310185622.GT1105363@frogsfrogsfrogs>

On Tue, Mar 10, 2026 at 11:56:22AM -0700, Darrick J. Wong wrote:
> On Tue, Mar 10, 2026 at 02:28:43AM -0700, Christoph Hellwig wrote:
> > > 
> > > However, this is really slow if there are a lot of filesystems because
> > > we end up wading through a lot of irrelevant information.  However,
> > > statmount() can help us here because as of Linux 7.0 we can open the
> > > passed-in path at startup, call statmount() on it to retrieve the
> > > mnt_id, and then call it again later with that same mnt_id to find the
> > > mountpoint.  Luckily xfs_healthmon didn't get merged until 7.0 so it's
> > > more or less guaranteed to be there if XFS_IOC_HEALTH_MONITOR succeeds.
> > > 
> > > Obviously if this doesn't work, we can fall back to the slow walk.
> > 
> > Can we kill the fallback and instead just have a good error message
> > if someone messes up their backports?
> 
> Yes we could, though the risk with dropping the previous patch is that
> someone could introduce a third-party seccomp policy that forbids
> statmount() even on kernels that support it, and then xfs_healer would
> just fail if the mount moves.
> 
> That would be totally stupid because the only reason you'd encounter
> that is because either (a) your distro screwed up their security policy
> or (b) your paranoid IT department deploys an Enterprise Security Model
> written by a ven-duh who hasn't gotten around to evaluating the new
> syscalls and blocks anything they've not read about.
> 
> I'd rather keep the getmntent stuff around since that's the classic way
> linux programs (including xfsprogs) have handled scanning the mount
> tables.  But if you feel strongly about not having getmntent it's not
> hard to pull it out.

Actually, ignore all this, I found a much better reason for keeping both
versions:

Each bind mount gets a new mnt_id, so getmntent is the only way to find
a different vfsmount of the same filesystem.  If you do this:

mount /dev/sda /mnt
xfs_healer /mnt &
mount /mnt /opt --bind
umount /mnt

the filesystem itself never gets unmounted, but statmount() won't be
able to find /opt without scanning the mount table.  Observe that the
bind mount gets a different vfsmount object, and hence a different
mnt_id:

# mount /dev/sda /mnt
# xfs_io -c statmount /mnt | grep mnt_id:
        mnt_id: 0x80004775
# mount /mnt /opt --bind
# xfs_io -c statmount /opt | grep mnt_id:
        mnt_id: 0x8000477a

The statmount reconnection thing, however, works for mount --move
because the vfsmount object doesn't go away, it merely moves around:

# mount -t tmpfs urk /mnt
# mount --make-rprivate /mnt
# mkdir -p /mnt/a /mnt/b
# mount /dev/sda /mnt/a
# xfs_io -c statmount /mnt/a | grep mnt_id:
        mnt_id: 0x800048a9
# mount --move /mnt/a /mnt/b
# xfs_io -c statmount /mnt/b | grep mnt_id:
        mnt_id: 0x800048a9

I'm not sure when anyone would really do this, but it's certainly
possible to do this, and every other process in the same mount namespace
will see it.  I'll go write a new test to exercise this, since I forgot
to do that earlier.

--D
