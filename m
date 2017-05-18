Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32821 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932489AbdERWbJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2017 18:31:09 -0400
Date: Thu, 18 May 2017 15:30:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs: freeze rw filesystems just prior to reboot
Message-ID: <20170518223053.GD4519@birch.djwong.org>
References: <20170518012618.GT4519@birch.djwong.org>
 <20170518013242.GW4519@birch.djwong.org>
 <20170518083405.GQ17542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170518083405.GQ17542@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Thu, May 18, 2017 at 06:34:05PM +1000, Dave Chinner wrote:
> On Wed, May 17, 2017 at 06:32:42PM -0700, Darrick J. Wong wrote:
> > Apparently there are certain system software configurations that do odd
> > things like update the kernel and reboot without umounting the /boot fs
> > or remounting it readonly, either of which would push all the AIL items
> > out to disk.  As a result, a subsequent invocation of something like
> > grub (which has a frightening willingness to read a fs with a dirty log)
> > can read stale disk contents and/or miss files the metadata for which
> > have been written to the log but not checkpointed into the filesystem.
> 
> > Granted, most of the time /boot is a separate partition and
> > systemd/sysvinit/whatever actually /do/ unmount /boot before rebooting.
> > This "fix" is only needed for people who have one giant filesystem.
> 
> Let me guess the series of events: grub calls "sync" and says "I'm

dpkg/rpm/systemd/CABEXTRACT.EXE/whatever, but yes :)

> done", then user runs an immediate reboot/shutdown and something
> still running after init has killed everything but PID 1 has an open

Worse than that, actually -- it was plymouthd, aka the splash screen.
If plymouthd isn't running, then the ro remount succeeds (not that
systemd actually checks) and grub is fine afterwards.

> writeable file descriptor causing the remount-ro of / to return
> EBUSY and so it just shuts down/restarts with an unflushed log?

Yes, it's /that/ problem again, that you and I were going 'round and
'round about a month or two ago.  I decided that I could at least try to
get something merged to reduce the user pain, even if the real problem
is herpy derpy userspace.

> > Therefore, add a reboot hook to freeze the rw filesystems (which
> > checkpoints the log) just prior to reboot.  This is an unfortunate and
> > insufficient workaround for multiple layers of inadequate external
> > software, but at least it will reduce boot time surprises for the "OS
> > updater failed to disengage the filesystem before rebooting" case.
> > 
> > Seeing as grub is unlikely ever to learn to replay the XFS log (and we
> > probably don't want it doing that),
> 
> If anything other than XFS code modifies the filesystem (log,
> metadata or data) then we have a tainted, unsuportable filesystem
> image.....

Indeed.

> > *LILO has been discontinued for at least 18 months,
> 
> Yet Lilo still works just fine.

Ok fine it's been /totally stable/ for 18 months. ;)
https://lilo.alioth.debian.org/

FWIW lilo isn't compatible with reflinked inodes (admittedly unlikely on
/boot) but 

> > and we're not quite to the point of putting kernel
> > files directly on the EFI System Partition,
> 
> Really? How have we not got there yet - we were doing this almost
> 15 years ago with ia64 and elilo via mounting the EFI partition on
> /boot....

elilo also seems dead, according to its SF page.
https://sourceforge.net/projects/elilo/

I'm not sure why we don't just drop kernel+initrd into the ESP and
create a bootloader entry via efibootmgr, other than the ages ago
reports about EFI firmwares bricking if the nvram fills up with data:
https://mjg59.dreamwidth.org/22855.html

Though I imagine certain distros don't want to have to get their kernels
signed by Microsoft so that Secure Boot works or whatever, etc. etc.
I guess elilo was a nice shim for that.

> > this seems like the least
> > crappy solution to this problem.
> > 
> > Yes, you're still screwed in grub if the system crashes. :)
> 
> This really sounds like the perennial "grub doesn't ensure the
> information it requires to boot is safely on stable storage before
> reboot" problem combined with some sub-optimal init behaviour to
> expose the grub issue....

Yep!  Anyway Christoph is right, this isn't something that plagues only
XFS; Ted was also musing that ext4 likely needs the same workaround, so
I'll go move this to fsdevel. :)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
