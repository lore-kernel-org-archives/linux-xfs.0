Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1E82D780A
	for <linux-xfs@vger.kernel.org>; Mon,  9 Feb 2026 06:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770617237; cv=none; b=p5CEuFh9FoSEijq5FGSTc518fWsAeQ4EBd4h6upcrLlKb11ZN+Y6W08vZjlHn4cyOycAvyqmeFsDpFfGbF/RttjbRdnC1gs1X01zcdQFS39oAqtnYr6bP6/AMAysTIXEtkznmf6vVm1E/T9dzbuF9el65qu2+AHiZRPVF8v45zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770617237; c=relaxed/simple;
	bh=PTcIwLdVoKms5jv8BFqlnoSBLf46D/B6x/iHpdBk4u4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LnuT+yTY0hJJCiQ2w12wbuUE+edzfsYAgWXxleD6nK5PdNAo7yEbF8dMPEjoCV3OI9J+YkDV+ORhHOLlEe49jYknFoTyKElr0zWQXKD12UcI39W7epsbzDtQ7yMDVRITDq/KGCldKOu1XkoW93T4U7vFfflEBHKTrmEiVHF7LR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mD1Qwbqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mD1Qwbqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16527C116C6;
	Mon,  9 Feb 2026 06:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770617237;
	bh=PTcIwLdVoKms5jv8BFqlnoSBLf46D/B6x/iHpdBk4u4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mD1Qwbqco6Cv+aELn37kJRxer4+fY4nV+GcoZlbq6eXMnB++5WYKBaMPDD4MwnNQx
	 prWHcFymz6MGnjhMYxAuJaQhtpAaXfxul4RUPy9kejaODvnBx/E2cPX9z08NJ6xPSv
	 1UwJ3oY2jNSjOqAAkLJwNJC80YiTfE0DFIQACpXT+0ycmS+WafpDqghehATVtCI1Wn
	 upMDqBzDSRpzYzuC/qJzYiaObFbLY0hhuHe+uYsB+Aj1E+9JmXEXnF0VxukbzvygJM
	 dQWBj+mAjFcZ+Nt0CmVj/wRq+pEAtet7g6hyoO/qIUa1WJ+aCvuOsVwkUSJoiCjzVt
	 pSATrxYcBhHMA==
Date: Sun, 8 Feb 2026 22:07:16 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	hch <hch@lst.de>
Subject: Re: [bug report] xfs/802 failure due to mssing fstype report by lsblk
Message-ID: <20260209060716.GL1535390@frogsfrogsfrogs>
References: <aYWobEmDn0jSPzqo@shinmob>
 <20260206173805.GY7712@frogsfrogsfrogs>
 <aYlHZ4bBQI3Vpb3N@shinmob>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYlHZ4bBQI3Vpb3N@shinmob>

On Mon, Feb 09, 2026 at 02:50:00AM +0000, Shinichiro Kawasaki wrote:
> On Feb 06, 2026 / 09:38, Darrick J. Wong wrote:
> > On Fri, Feb 06, 2026 at 08:40:07AM +0000, Shinichiro Kawasaki wrote:
> > > Hello Darrick,
> > > 
> > > Recently, my fstests run for null_blk (8GiB size) as SCRATCH_DEV failed at
> > > xfs/802 [3]. I took a look and observed following points:
> > > 
> > > 1) xfs_scrub_all command ran as expected. Even though SCRATCH_DEV is mounted,
> > >    it did not scrub SCRATCH_DEV. Hence the failure.
> > > 2) xfs_scrub_all uses lsblk command to list all mounted xfs filesystems [1].
> > >    However, lsblk command does not report that SCRATCH_DEV is mounted as xfs.
> > > 3) I leanred that lsblk command refers to udev database [2], and udev database
> > >    sometimes fails to update the filesystem information. This is the case for
> > >    the null_blk as SCRATCH_DEV on my test nodes.
> > 
> > Hrm.  I wonder if we're starting xfs_scrub_all too soon after the
> > _scratch_cycle_mount?  It's possible that if udev is running slowly,
> > it won't yet have poked blkid to update its cache, in which case lsblk
> > won't show it.
> > 
> > If you add _udev_wait after _scratch_cycle_mount, does the "Health
> > status has not beel collected" problem go away?  I couldn't reproduce
> > this specific problem on my test VMs, but the "udev hasn't caught up and
> > breaks fstests" pattern is very familiar. :/
> 
> Unfortunately, no. I made the change below in the test case, but I still see
> the "Health status has not beel collected" message.
> 
> diff --git a/tests/xfs/802 b/tests/xfs/802
> index fc4767a..77e09f8 100755
> --- a/tests/xfs/802
> +++ b/tests/xfs/802
> @@ -131,6 +131,8 @@ systemctl cat "$new_scruball_svc" >> $seqres.full
>  # Cycle mounts to clear all the incore CHECKED bits.
>  _scratch_cycle_mount
>  
> +_udev_wait $SCRATCH_DEV
> +
>  echo "Scrub Everything"
>  run_scrub_service "$new_scruball_svc"
>  
> 
> I also manually mounted the null_blk device with xfs, and ran "udevadm settle".
> Then still lsblk was failing to report fstype for the null_blk device (FYI, I
> use Fedora 43 to recreate the failure).

Waitaminute, how can you even format xfs on nullblk to run fstests?
Isn't that the bdev that silently discards everything written to it, and
returns zero on reads??

--D

> > 
> > > Based on these observations, I think there are two points to improve:
> > > 
> > > 1) I found "blkid -p" command reports that null_blk is mounted as xfs, even when
> > >    lsblk does not report it. I think xfs_scrub_all can be modified to use
> > >    "blkid -p" instead of lsblk to find out xfs filesystems mounted.
> > > 2) When there are other xfs filesystems on the test node than TEST_DEV or
> > >    SCRATCH_DEV, xfs_scrub_all changes the status of them. This does not sound
> > >    good to me since it affects system status out of the test targets block
> > >    devices. I think he test case can be improved to check that there is no other
> > >    xfs filesystems mounted other than TEST_DEV or SCRATCH_DEV/s. If not, the
> > >    test case should be skipped.
> > 
> > I wonder if a better solution would be to add to xfs_scrub_all a
> > --restrict $SCRATCH_MNT --restrict $TEST_DIR option so that it ignores
> > mounts that aren't under test?
> 
> Yes, I agree that it will be the better solution since the test case will not be
> skipped even when there are other xfs filesystems mounted.
