Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:55051 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935699AbdEXDTz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2017 23:19:55 -0400
Date: Wed, 24 May 2017 13:19:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: freeze rw filesystems just prior to reboot
Message-ID: <20170524031935.GZ17542@dastard>
References: <20170518012618.GT4519@birch.djwong.org>
 <20170518013242.GW4519@birch.djwong.org>
 <20170518083405.GQ17542@dastard>
 <20170518223053.GD4519@birch.djwong.org>
 <CAJCQCtTj-7BovZbXyZu9=Dhh4ROR-AJ6Dpsw1GKbM-a2fr+uVw@mail.gmail.com>
 <20170519210040.GL4519@birch.djwong.org>
 <20170522020112.GV17542@dastard>
 <CAJCQCtTj4it6o-Fop6vm3s_HFbRemF5o_H9w-tvS6wmFfVwKBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtTj4it6o-Fop6vm3s_HFbRemF5o_H9w-tvS6wmFfVwKBA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Mon, May 22, 2017 at 02:46:42PM -0600, Chris Murphy wrote:
> On Sun, May 21, 2017 at 8:01 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, May 19, 2017 at 02:00:40PM -0700, Darrick J. Wong wrote:
> >> On Fri, May 19, 2017 at 01:09:31PM -0600, Chris Murphy wrote:
> >> > On Thu, May 18, 2017 at 4:30 PM, Darrick J. Wong
> >> > <darrick.wong@oracle.com> wrote:
> >> > > On Thu, May 18, 2017 at 06:34:05PM +1000, Dave Chinner wrote:
> >> > >> On Wed, May 17, 2017 at 06:32:42PM -0700, Darrick J. Wong wrote:
> >> > >> > Apparently there are certain system software configurations that do odd
> >> > >> > things like update the kernel and reboot without umounting the /boot fs
> >> > >> > or remounting it readonly, either of which would push all the AIL items
> >> > >> > out to disk.  As a result, a subsequent invocation of something like
> >> > >> > grub (which has a frightening willingness to read a fs with a dirty log)
> >> > >> > can read stale disk contents and/or miss files the metadata for which
> >> > >> > have been written to the log but not checkpointed into the filesystem.
> >> > >>
> >> > >> > Granted, most of the time /boot is a separate partition and
> >> > >> > systemd/sysvinit/whatever actually /do/ unmount /boot before rebooting.
> >> > >> > This "fix" is only needed for people who have one giant filesystem.
> >> > >>
> >> > >> Let me guess the series of events: grub calls "sync" and says "I'm
> >> > >
> >> > > dpkg/rpm/systemd/CABEXTRACT.EXE/whatever, but yes :)
> >> >
> >> >
> >> > It has nothing to do with GRUB. The exact same problem would happen
> >> > regardless of bootloader because the thing writing out bootloader
> >> > configuration prior to reboot is grubby, which is not at all in any
> >> > way related to GRUB.
> >
> > Chris, I've told you previously this is wrong (it's incorrect for
> > lilo) and too narrow (grubby is not the only update infrastructure
> > around), but I'll repeat it again because we need to move past your
> > single-distro focus on grubby and discuss the underlying problems.
> 
> 
> And I'm trying to get you to move past your ancient legacy bootloader
> focus and discuss things that matter in 2017.
> 
> First, nothing works like LILO, not even ELILO works like LILO.

Yeah, Elilo just used the lilo config file format and parser and
threw everyhting else away. I learnt how simple it is when I first
started working on ia64 machines back in 2004. Or was it 2005? It's
so long ago now I can't remember exactly.

> Second, I have only been able to reproduce this problem with grubby +
> XFS. If I manually do grub2-mkconfig + reboot -f instead, the problem
> does not happen. It might be that I'm too slow, and the marginal
> amount of extra time permits the new grub.cfg to fully commit, but I
> don't know.

Yup, those are typical writeback/reboot race symptoms.

I think Darrick's traces also hinted at the possibility that
grub2-mkconfig doesn't run sync at the correct time so the new
config file may not have even made it to disk and so it may be that
you are seeing it boot from the old config which was still valid...

> Third, basic bootloader concepts:
> 
> The bootloader is the executable that's loaded by the firmware after POST.

> The bootloader installer is not the bootloader. /sbin/lilo,

Well, yes, it's usually obvious which bootloader part is being
discussed from the context of the discussion. But seeing as you seem
to have trouble with this sort of thing, I've taken the time to
specify which one I'm talking about...

> /sbin/extlinux, /sbin/grub-install are not bootloaders, they are
> bootloader installers. Only lilo totally reinstalls the bootloader
> binary when configurations change. GRUB, extlinux, uboot, zipl don't
> do that. Their configuration files change and that's it, and they do
> not depend on boot sectors for this,

Sure, but they still all depend on writing their bootloader
executable to the boot sector to be able to bootstrap the boot
process.  They are no different to LILO in this respect - the only
difference is that LILO also writes a pointer to the pre-processed
boot config into the boot sector...

> they don't write outside the file
> system to the drive like lilo.

Hmmm - I demonstrated this assertion to be false in the email you
replied to. You've used this reasoning to repeatedly dismiss my
comments with no other technical information, so I hope you just
misread/misunderstood my reply. I'll try again to make it absolutely
clear how lilo works below, because.....

> They depend on the file system.

.... all the bootloaders (except ELILO) depend on the filesystem to
provide them with the physical block mapping information needed to
read the kernel/initramfs to boot them.  The only real difference is
how they get that physical location information. To recap:

The Lilo installer gets the physical location information from the
filesystem via the OS provided FIBMAP ioctl(), which it then writes
it into a file in the filesysetm (boot.map), which it then it maps
with FIBMAP and writes that map into the boot sector on the block
device.  At no point does it "go around the filesystem" to obtain or
write this information to stable storage for the bootloader
executable to use. The bootloader executable then just reads the
block map information directly from the block device to load the
kernel.

The grub installer writes a config file and that's about it. On
boot, the stage 1 loader in the boot sector bootstraps
the larger stage 2 loader. That then loads all the modules needed to
probe the booting block device contents and load the modules needed
to traverse the metadata structure it contains to find the block
map/extent list of the config file.  Then it decodes the block map,
reads the config file direct from the block device and parses it. It
then repeats this metadata traversal and extent list decoding for
each file it needs to read to boot.

IOWs, the information they use is exactly the same, but LILO avoids
all the bootloader executable complexity by doing all the mapping
work n the installer through generic, filesystem agnostic OS
interfaces before reboot. 

In contrast, the "parse the block device" architecture of grub and
similar bootloaders ensures that the bootloader executable is locked
into an endless game of whack-a-mole as filesystems, volume managers
and other storage management applications change formats and
behaviours.....

> > However, IMO problem does indeed lie with the bootloader and not the
> > distro packaging mechanism/scripts, and so we need to talk a bit out
> > the architectural differences between bootloaders like lilo and
> > grub/petitboot and why I consider update durability to be something
> > the bootloader needs to provide, not thrid party packagers or the
> > init system.
> 
> Either the bootloader needs to learn how to read dirty logs,

I don't think anyone wants to expend the time and effort needed to
do this for each filesystem that the grub bootloader supports,
especially as it is not necessary.

> or there
> can be no dirty log entries related to three things: kernel,
> initramfs, and bootloader configuration. If any of those three things
> are not fully committed to the file system metadata,  the bootloader
> will fail to find them.

Yup - I've been trying to tell you that these are the exact
guarantees that freezing the fs will provide the bootloader
installer....

> If GRUB or grubby are not being used, then the bootloader
> configuration file is most likely modified by a script in the kernel
> package. How do you avoid burdening the kernel package from update
> durability when it is responsible for writing the kernel, initramfs,
> and the third most likely thing to modify the bootloader
> configuration?

Solved problem via post-inst package scripts.

$ sudo apt-get install linux-image-amd64
....
Preparing to unpack .../linux-image-4.9.0-3-amd64_4.9.25-1_amd64.deb ...
Unpacking linux-image-4.9.0-3-amd64 (4.9.25-1) ...
Preparing to unpack .../linux-image-amd64_4.9+80_amd64.deb ...
Unpacking linux-image-amd64 (4.9+80) over (4.9+78) ...
Setting up linux-image-4.9.0-3-amd64 (4.9.25-1) ...
I: /vmlinuz.old is now a symlink to boot/vmlinuz-4.9.0-1-amd64
I: /initrd.img.old is now a symlink to boot/initrd.img-4.9.0-1-amd64
I: /vmlinuz is now a symlink to boot/vmlinuz-4.9.0-3-amd64
I: /initrd.img is now a symlink to boot/initrd.img-4.9.0-3-amd64
/etc/kernel/postinst.d/initramfs-tools:
update-initramfs: Generating /boot/initrd.img-4.9.0-3-amd64
/etc/kernel/postinst.d/zz-runlilo:
Added Linux  *
Added Linux.old
Setting up linux-image-amd64 (4.9+80) ...
$

> > As a result, you do *not* need to call sync or freeze the filesystem
> > after running the lilo command because it has already guaranteed the
> > updated bootloader information is on stable storage.  And because
> > you have to run lilo to update the bootloader, distro package
> > managers *can't fuck it up* because the bootloader has full control
> > of the update process.
> 
> Haha. Well it can't fuck it up because it's doing a total end run
> around the file system.

FYI: the canonical example of "doing a total end run around the
filesystem" is to write your own filesystem parsers to directly walk
filesystem structures on a block device without going through the
supported OS filesystem channels for accessing that filesystem
information.

> Actually GRUB has a functional equivalent, it's just that it's not the
> upstream default, and no distro appears to want to use it by default:

IIRC, that's the "filesystem install" mode and there's good reason
it's not used: LBA 0 of the block device belongs to the filesystem
on that device, not the bootloader. Hence if you have a filesystem
that uses LBA 0 (e.g. XFS), using grub in this mode on that block
device will trash it and then you've got bigger problems....

The Lilo installer avoids this issue by asking the filesystem to map
the mapping file and writing it's LBA to the boot sector, hence
allowing the bootloader info to be placed anywhere in the block
device rather than being fixed to a hard coded location as per the
grub functionality...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
