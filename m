Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E17F1B95B;
	Wed, 22 Jan 2025 04:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737518743; cv=none; b=cdK2uGBT6cgel3M8ZShoSCeBCxGP+lVzpa+atuyq6Ar8CBr2PJ40HNfUCRI7T9UHmEokJwUscqZWJ3XY/wCKL3RrW847nhYrFIXP405zKtrlPXE4URl2OrjNUGzhgcyVQ7obmHIc3JD/X/Xz9Z1eOyDHucPM1lXQJvjFt7pc+eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737518743; c=relaxed/simple;
	bh=jZOs7oSYJ/j7MZgIQ268Qgksfv/gsPdPpQspZzBu7B8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tmGsLa21XT8jjORLbP6Ve83L37UElDGHb48rLfLc59+JN7qm6TaR9aA4wGjKRk22VMsoyakajpB+JMRBTOiXYteJKnC/Q3gmG2fGXiDTZmZJjkt6yGPMH/dSFD5kz5YE9XdnlmregQ0JCyDAU1lGTRakOnmpQNgh32OvyomapoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ABG3I2lD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ABG3I2lD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDDCC4CED6;
	Wed, 22 Jan 2025 04:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737518742;
	bh=jZOs7oSYJ/j7MZgIQ268Qgksfv/gsPdPpQspZzBu7B8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ABG3I2lDNwWTooUrVIdM6JfKB/857fw0q4POkuNLRcLOSrbXk3PsTiuWrr8pyfABC
	 C26Bq/1ApNu4krAVvtVGR+noZYFccKPPd+hWnC+/iKmRwb/tbL2LTlNlj5COprPQfB
	 p43aijE+mIX33D99Y+AUF9/GBksc+kGouRVo6tH1NDV6RhDbnzTr23AjcCh4UvKiEc
	 c0QdFx6E/KNyFrrab+h8FKngWRlh+RiCudon1t5EQDvgij9pmijK96QJWekqHBj5ch
	 1QvK5QmoiP6TCpOVckF3ROGu6lEELj2uPmUxrGtjZ2YccSmKBqueyu0ycXIm/EuwgZ
	 BkQvyl88stpHA==
Date: Tue, 21 Jan 2025 20:05:42 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/23] common/xfs: find loop devices for non-blockdevs
 passed to _prepare_for_eio_shutdown
Message-ID: <20250122040542.GV1611770@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974243.1927324.9105721327110864014.stgit@frogsfrogsfrogs>
 <Z48kffpLwUr1xMmT@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z48kffpLwUr1xMmT@dread.disaster.area>

On Tue, Jan 21, 2025 at 03:37:17PM +1100, Dave Chinner wrote:
> On Thu, Jan 16, 2025 at 03:28:02PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > xfs/336 does this somewhat sketchy thing where it mdrestores into a
> > regular file, and then does this to validate the restored metadata:
> > 
> > SCRATCH_DEV=$TEST_DIR/image _scratch_mount
> 
> That's a canonical example of what is called "stepping on a
> landmine".

60% of fstests is written in bash, all of it is a friggin land mine
because bash totally lets us do variable substitution at any time, and
any time you make a change you have to exhaustively test the whole mess
to make sure nothing broke...

(Yeah, I hate bash)

> We validate that the SCRATCH_DEV is a block device at the start of
> check and each section it reads and runs (via common/config), and
> then make the assumption in all the infrastructure that SCRATCH_DEV
> always points to a valid block device.

We do?  Can you point me to the sentence in doc/ that says this
explicitly?  There's nothing I can find in the any docs and
_try_scratch_mount does not check SCRATCH_DEV is a bdev for XFS.
That needs to be documented.

> Now we have one new test that overwrites SCRATCH_DEV temporarily
> with a file and so we have to add checks all through the
> infrastructure to handle this one whacky test?
> 
> > Unfortunately, commit 1a49022fab9b4d causes the following regression:
> > 
> >  --- /tmp/fstests/tests/xfs/336.out      2024-11-12 16:17:36.733447713 -0800
> >  +++ /var/tmp/fstests/xfs/336.out.bad    2025-01-04 19:10:39.861871114 -0800
> >  @@ -5,4 +5,5 @@ Create big file
> >   Explode the rtrmapbt
> >   Create metadump file
> >   Restore metadump
> >  -Check restored fs
> >  +Usage: _set_fs_sysfs_attr <mounted_device> <attr> <content>
> >  +(see /var/tmp/fstests/xfs/336.full for details)
> > 
> > This is due to the fact that SCRATCH_DEV is temporarily reassigned to
> > the regular file.  That path is passed straight through _scratch_mount
> > to _xfs_prepare_for_eio_shutdown, but that helper _fails because the
> > "dev" argument isn't actually a path to a block device.
> 
> _scratch_mount assumes that SCRATCH_DEV points to a valid block
> device. xfs/336 is the problem here, not the code that assumes
> SCRATCH_DEV points to a block device....
> 
> Why are these hacks needed? Why can't _xfs_verify_metadumps()
> loopdev usage be extended to handle the new rt rmap code that this
> test is supposed to be exercising? 

Because _xfs_verify_metadumps came long after xfs/336.  336 itself was
merged long ago when I was naïve and didn't think it would take quite so
long to merge the rtrmap code.

> > Fix this by detecting non-bdevs and finding (we hope) the loop device
> > that was created to handle the mount. 
> 
> What loop device? xfs/336 doesn't use loop devices at all.
> 
> Oh, this is assuming that mount will silently do a loopback mount
> when passed a file rather than a block device. IOWs, it's relying on
> some third party to do the loop device creation and hence allow it
> to be mounted.
> 
> IOWs, this change is addressing a landmine by adding another
> landmine.

Some would say that mount adding the ability to set up a loop dev was
itself *avoiding* a landmine from 90s era util-linux.

> I really think that xfs/336 needs to be fixed - one off test hacks
> like this, while they may work, only make modifying and maintaining
> the fstests infrastructure that much harder....

Yeah, it'll get cleaned up for the rtrmap fstests merge.

> > While we're at it, have the
> > helper return the exit code from mount, not _prepare_for_eio_shutdown.
> 
> That should be a separate patch.

Ok.

--D

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
