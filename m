Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22188 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752608AbdESVBC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 May 2017 17:01:02 -0400
Date: Fri, 19 May 2017 14:00:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs: freeze rw filesystems just prior to reboot
Message-ID: <20170519210040.GL4519@birch.djwong.org>
References: <20170518012618.GT4519@birch.djwong.org>
 <20170518013242.GW4519@birch.djwong.org>
 <20170518083405.GQ17542@dastard>
 <20170518223053.GD4519@birch.djwong.org>
 <CAJCQCtTj-7BovZbXyZu9=Dhh4ROR-AJ6Dpsw1GKbM-a2fr+uVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtTj-7BovZbXyZu9=Dhh4ROR-AJ6Dpsw1GKbM-a2fr+uVw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Fri, May 19, 2017 at 01:09:31PM -0600, Chris Murphy wrote:
> On Thu, May 18, 2017 at 4:30 PM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > On Thu, May 18, 2017 at 06:34:05PM +1000, Dave Chinner wrote:
> >> On Wed, May 17, 2017 at 06:32:42PM -0700, Darrick J. Wong wrote:
> >> > Apparently there are certain system software configurations that do odd
> >> > things like update the kernel and reboot without umounting the /boot fs
> >> > or remounting it readonly, either of which would push all the AIL items
> >> > out to disk.  As a result, a subsequent invocation of something like
> >> > grub (which has a frightening willingness to read a fs with a dirty log)
> >> > can read stale disk contents and/or miss files the metadata for which
> >> > have been written to the log but not checkpointed into the filesystem.
> >>
> >> > Granted, most of the time /boot is a separate partition and
> >> > systemd/sysvinit/whatever actually /do/ unmount /boot before rebooting.
> >> > This "fix" is only needed for people who have one giant filesystem.
> >>
> >> Let me guess the series of events: grub calls "sync" and says "I'm
> >
> > dpkg/rpm/systemd/CABEXTRACT.EXE/whatever, but yes :)
> 
> 
> It has nothing to do with GRUB. The exact same problem would happen
> regardless of bootloader because the thing writing out bootloader
> configuration prior to reboot is grubby, which is not at all in any
> way related to GRUB.
> 
> I've explained this before, and now Dave's continued misstatements are
> propagating to Darrick. If you guys want to believe in untrue things,
> have at it. But please stop repeating untrue things.

I need to clarify here what I meant by
"dpkg/rpm/systemd/CABEXTRACT.EXE/whatever, but yes". is that the thing
that writes to the filesystem prior to the reboot -- the package manager
and the boot configuration file writer.  Not the grub stage1/2/3, not
the lilo binary, not any of the bootloaders.  I won't speak for Dave but
I think you and I are roughly on the same page here.

> >> done", then user runs an immediate reboot/shutdown and something
> >> still running after init has killed everything but PID 1 has an open
> >
> > Worse than that, actually -- it was plymouthd, aka the splash screen.
> > If plymouthd isn't running, then the ro remount succeeds (not that
> > systemd actually checks) and grub is fine afterwards.
> >
> >> writeable file descriptor causing the remount-ro of / to return
> >> EBUSY and so it just shuts down/restarts with an unflushed log?
> >
> > Yes, it's /that/ problem again, that you and I were going 'round and
> > 'round about a month or two ago.  I decided that I could at least try to
> > get something merged to reduce the user pain, even if the real problem
> > is herpy derpy userspace.
> 
> 
> Note that plymouth is doing the wrong thing per systemd's own
> documentation. Plymouth has asked systemd to be exempt from being
> killed, which systemd honors, but documentation says that programs
> should not request such exemption on root file systems and should
> instead run from the initramfs if they must be non-killable.
> 
> Both systemd and plymouth upstreams are aware of this and have been
> looking into their own solution the problem, I don't know why they
> consider the fix invasive, but that's how it's been characterized.
> 
> And I've argued to systemd folks that they need to take some
> responsibility for this because this happens during their
> offline-update.target which which a particular boot mode that is
> explicitly designed for system software updates, and it's used because
> it's supposed to be a safe, stable, known environment, compared to
> doing updates while a bunch of stuff including a desktop environment
> is running. And yet - poof - it yanks the file system out from under
> itself.
> 
> Now originally they were blaming the file systems, saying that sync()
> is supposed to guarantee everything, data and metadata is completely
> written to stable media. But I think that definition of sync()
> predates journaled file systems, so now there's broad understanding in
> fs circles that journaled file systems only guarantee the journal and
> data are committed to stable media, not the fs metadata itself.

Right.  Everything's committed to stable media /somewhere/, but the
metadata isn't necessarily where an fs driver will find it if that
driver ignores the dirty log.

> And do require sync() to apply to fs metadata, I suspect means file
> systems would become slower than molasses in winter.

Probably.

> >> > Therefore, add a reboot hook to freeze the rw filesystems (which
> >> > checkpoints the log) just prior to reboot.  This is an unfortunate and
> >> > insufficient workaround for multiple layers of inadequate external
> >> > software, but at least it will reduce boot time surprises for the "OS
> >> > updater failed to disengage the filesystem before rebooting" case.
> >> >
> >> > Seeing as grub is unlikely ever to learn to replay the XFS log (and we
> >> > probably don't want it doing that),
> >>
> >> If anything other than XFS code modifies the filesystem (log,
> >> metadata or data) then we have a tainted, unsuportable filesystem
> >> image.....
> >
> > Indeed.
> 
> Doesn't mount -o ro still do journal replay but then doesn't write any
> fixes back to stable media?

There are multiple opinions about what an ro mount means.  The most
common I've heard are "userspace cannot change files but the fs can
write to the underlying block device" and "userspace cannot change files
and the fs cannot write to the underlying block device".  XFS does the
second if the block device is ro, and the first if it is rw.

> Why can't the bootloader do this? GRUB2 for a rather long time now has
> a 4GiB memory limit on 32-bit and GRUB devs have said this could be
> lifted higher on 64-bit. There is no 640KiB limit for GRUB.

I don't think the XFS community will look fondly on a second competing
log implementation since the XFS log is rather more complex than jbd2.

> >> > *LILO has been discontinued for at least 18 months,
> >>
> >> Yet Lilo still works just fine.
> >
> > Ok fine it's been /totally stable/ for 18 months. ;)
> > https://lilo.alioth.debian.org/
> >
> > FWIW lilo isn't compatible with reflinked inodes (admittedly unlikely on
> > /boot) but
> 
> 
> This whole LILO thing is irritating. I don't know how many times I
> have to say it...
> 
> grubby is the sole thing responsible for writing bootloader
> configuration changes, no matter the bootloader, on Red Hat and Fedora
> systems. There is absolutely no difference between LILO and GRUB
> bootloader configuration changes on these distros.

I'm tired of getting beat over the head about this.  There's no grubby
on Debian!

# apt-cache search grubby
<nothing>

# dpkg -S /etc/kernel/postinst.d/zz-update-grub 
grub-efi-amd64: /etc/kernel/postinst.d/zz-update-grub

zz-update-grub calls update-grub:

# dpkg -S $(which update-grub)
grub2-common: /usr/sbin/update-grub

update-grub calls grub-mkconfig:

# dpkg -S $(which grub-mkconfig)
grub-common: /usr/sbin/grub-mkconfig

# head -n30 /usr/sbin/grub-mkconfig
head -n30 !$
head -n30 /usr/sbin/grub-mkconfig
#! /bin/sh
set -e

# Generate grub.cfg by inspecting /boot contents.
# Copyright (C) 2006,2007,2008,2009,2010 Free Software Foundation, Inc.
#
# GRUB is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# GRUB is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# strace -f -o /tmp/a update-grub
# egrep '(/boot.*cfg|sync)' /tmp/a
20879 execve("/usr/share/djwong-colorgcc/grub-mkconfig", ["grub-mkconfig", "-o", "/boot/grub/grub.cfg"], [/* 31 vars */]) = -1 ENOENT (No such file or directory)
20879 execve("/usr/local/sbin/grub-mkconfig", ["grub-mkconfig", "-o", "/boot/grub/grub.cfg"], [/* 31 vars */]) = -1 ENOENT (No such file or directory)
20879 execve("/usr/local/bin/grub-mkconfig", ["grub-mkconfig", "-o", "/boot/grub/grub.cfg"], [/* 31 vars */]) = -1 ENOENT (No such file or directory)
20879 execve("/usr/sbin/grub-mkconfig", ["grub-mkconfig", "-o", "/boot/grub/grub.cfg"], [/* 31 vars */]) = 0
20882 write(1, "/boot/grub/grub.cfg\n", 20 <unfinished ...>
20879 <... read resumed> "/boot/grub/grub.cfg\n", 128) = 20
20961 execve("/bin/rm", ["rm", "-f", "/boot/grub/grub.cfg.new"], [/* 50 vars */]) = 0
20961 newfstatat(AT_FDCWD, "/boot/grub/grub.cfg.new", 0x1f48948, AT_SYMLINK_NOFOLLOW) = -1 ENOENT (No such file or directory)
20961 unlinkat(AT_FDCWD, "/boot/grub/grub.cfg.new", 0) = -1 ENOENT (No such file or directory)
20879 open("/boot/grub/grub.cfg.new", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3
22199 execve("/bin/grep", ["grep", "^password", "/boot/grub/grub.cfg.new"], [/* 50 vars */]) = 0
22199 openat(AT_FDCWD, "/boot/grub/grub.cfg.new", O_RDONLY|O_NOCTTY) = 3
22200 execve("/bin/chmod", ["chmod", "444", "/boot/grub/grub.cfg.new"], [/* 50 vars */]) = 0
22200 stat("/boot/grub/grub.cfg.new", {st_mode=S_IFREG|0600, st_size=10329, ...}) = 0
22200 fchmodat(AT_FDCWD, "/boot/grub/grub.cfg.new", 0444) = 0
22201 execve("/usr/bin/grub-script-check", ["/usr/bin/grub-script-check", "/boot/grub/grub.cfg.new"], [/* 50 vars */]) = 0
22201 open("/boot/grub/grub.cfg.new", O_RDONLY) = 3
22202 execve("/bin/mv", ["mv", "-f", "/boot/grub/grub.cfg.new", "/boot/grub/grub.cfg"], [/* 50 vars */]) = 0
22202 stat("/boot/grub/grub.cfg", {st_mode=S_IFREG|0444, st_size=10329, ...}) = 0
22202 lstat("/boot/grub/grub.cfg.new", {st_mode=S_IFREG|0444, st_size=10329, ...}) = 0
22202 lstat("/boot/grub/grub.cfg", {st_mode=S_IFREG|0444, st_size=10329, ...}) = 0
22202 rename("/boot/grub/grub.cfg.new", "/boot/grub/grub.cfg") = 0

(No *sync(), huh?)

So, no, grub actually /does/ generate grub.cfg on Debian.  Let's go have
a look at RHEL7.3, which I agree does have grubby:

# rpm -qf /etc/kernel/postinst.d/51-dracut-rescue-postinst.sh 
dracut-config-rescue-033-463.0.2.el7.x86_64

51-dracut-rescue-postinst.sh calls new-kernel-pkg:

# rpm -qf $(which new-kernel-pkg)
grubby-8.28-21.0.1.el7_3.x86_64
# grub-mkconfig
-bash: grub-mkconfig: command not found
# strace -f -o /tmp/a grubby --update-kernel /boot/vmlinuz-3.10.0-514.16.1.el7.x86_64
...
# grep /boot.*cfg /tmp/a
14568 readlink("grub2.cfg", "../boot/grub2/grub.cfg", 256) = 22
14568 open("../boot/grub2/grub.cfg-", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3
14568 stat("../boot/grub2/grub.cfg", {st_mode=S_IFREG|0644, st_size=8731, ...}) = 0
14568 chmod("../boot/grub2/grub.cfg-", 0644) = 0
14572 fsync(4)
14568 rename("../boot/grub2/grub.cfg-", "../boot/grub2/grub.cfg") = 0

(we only fsync the grubenv file??)

So yes, grubby does handle things for RHEL and Fedora, but RHEL and
Fedora are not the entire universe.

> >> > and we're not quite to the point of putting kernel
> >> > files directly on the EFI System Partition,
> >>
> >> Really? How have we not got there yet - we were doing this almost
> >> 15 years ago with ia64 and elilo via mounting the EFI partition on
> >> /boot....
> >
> > elilo also seems dead, according to its SF page.
> > https://sourceforge.net/projects/elilo/
> >
> > I'm not sure why we don't just drop kernel+initrd into the ESP and
> > create a bootloader entry via efibootmgr,
> 
> 
> I explained this too already.
> 
> So long as there is dual boot, this is a dead end. There isn't enough
> room on ESP's for this, and it can't be grown, and it's unreliable to
> have two ESPs on  the same system due to myriad UEFI bugs, and also it
> confuses Windows. So it's not ever going to happen except on Linux
> only systems.

Fair enough.  Though truth be told, /boot can be small and unresizable
which just leads to problems if the distro doesn't take care of reaping
old kernel packages before installing new ones.

Though /boot tends to be bigger than the default ESPs I see.

> >> This really sounds like the perennial "grub doesn't ensure the
> >> information it requires to boot is safely on stable storage before
> >> reboot" problem combined with some sub-optimal init behaviour to
> >> expose the grub issue....
> >
> > Yep!  Anyway Christoph is right, this isn't something that plagues only
> > XFS; Ted was also musing that ext4 likely needs the same workaround, so
> > I'll go move this to fsdevel. :)
> 
> 
> *facepalm* You guys are driving me crazy.
> 
> 1. The grub.cfg is modified by grubby. Not grub.  The same damn
> problem would happen no matter what bootloader is used.
>
> 2. It's not just the grub.cfg that cannot be found by GRUB. It can't
> find the new kernel file, any of its modules, or the new initramfs.
> None of that has XFS file system metadata either.

Those new files /do/ have XFS metadata; the metadata is sitting
(uncheckpointed) in the log.

> It's all simply not there as far as the bootloader is concerned.

Yes, because the bootloader ignores dirty logs and goes looking for
directories and files, the metadata for which is sitting
(uncheckpointed) in the log.

> And all of those things were written by RPM.

Would it help if I mentioned this --

*sync() -> write data to disk, write metadata to log
FIFREEZE() -> sync() and write log contents to fs.
unmount() -> sync() write log contents to fs.
reboot() -> sync() and reboot.

So if you're going to write data to a filesystem that has to be read by
a piece of software that /ignores dirty logs/, you have to write the log
to disk before you reboot.  This can be unmount or freeze, take your
pick.  You cannot sync, because sync only ensures that everything is
/somewhere/ on the stable medium.  It does not guarantee that log
contents have been written to the fs.

> So to be consistent you have to blame RPM for not ensuring its writes
> are safely on stable storage either, before reboot.
> 
> Jesus Christ...
> 
> I want Dave to write "this problem has nothing to do with GRUB" 50
> times on a chalkboard.

Frankly, all you have to do is tweak the grub config file writer to
"fsfreeze -f /boot && fsfreeze -u /boot" after it writes the grub.cfg and
before it exits.  That's both grubby and grub-mkconfig.

Or systemd/sysvinit could always ensure that the fs containing the boot
files is unmounted no matter what.  Or systemd/sysvinit could freeze the
fs for us before asking for a reboot.  Or the kernel could freeze the fs
for us before actually doing the reboot.  Any one of those options is
sufficient, but not one of them is reliably performed by any of the
pieces.  systemd *almost* always succeed at unmounting /boot, which is
why few people see this problem.

> And then I want him to strace grub2-mkconfig (which grubby does not
> use, which no Fedora or Red Hat system uses except one time during the
> original installation of the system) to prove his claim that grub
> isn't ensuring bootloader configuration info isn't getting to stable
> storage. Otherwise this is just handwaiving without evidence. If the
> GRUB folks are doing something wrong, seeing as all other distros do
> rely upon it, then it needs to get fixed. But claiming things without
> evidence is super shitty.
> 
> Now I just tried to strace grub2-mkconfig with -ff and I get literally
> 2880+ files. That is batshit crazy, but aside from that I think the
> most relevant child process that writes out the actual final grub.cfg
> is this:
> 
> https://paste.fedoraproject.org/paste/iksyeiYhxAIgbrbrugqOzV5M1UNdIGYhyRLivL9gydE=
> 
> I don't know what its not doing that it should be doing, but then also
> RPM must also not being doing it.
> 
> -- 
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
