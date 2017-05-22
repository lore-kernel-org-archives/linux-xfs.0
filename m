Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:35434 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933464AbdEVUqp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 May 2017 16:46:45 -0400
Received: by mail-yw0-f180.google.com with SMTP id l74so65699960ywe.2
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2017 13:46:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170522020112.GV17542@dastard>
References: <20170518012618.GT4519@birch.djwong.org> <20170518013242.GW4519@birch.djwong.org>
 <20170518083405.GQ17542@dastard> <20170518223053.GD4519@birch.djwong.org>
 <CAJCQCtTj-7BovZbXyZu9=Dhh4ROR-AJ6Dpsw1GKbM-a2fr+uVw@mail.gmail.com>
 <20170519210040.GL4519@birch.djwong.org> <20170522020112.GV17542@dastard>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 22 May 2017 14:46:42 -0600
Message-ID: <CAJCQCtTj4it6o-Fop6vm3s_HFbRemF5o_H9w-tvS6wmFfVwKBA@mail.gmail.com>
Subject: Re: [PATCH 3/3] xfs: freeze rw filesystems just prior to reboot
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Chris Murphy <lists@colorremedies.com>, xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Sun, May 21, 2017 at 8:01 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, May 19, 2017 at 02:00:40PM -0700, Darrick J. Wong wrote:
>> On Fri, May 19, 2017 at 01:09:31PM -0600, Chris Murphy wrote:
>> > On Thu, May 18, 2017 at 4:30 PM, Darrick J. Wong
>> > <darrick.wong@oracle.com> wrote:
>> > > On Thu, May 18, 2017 at 06:34:05PM +1000, Dave Chinner wrote:
>> > >> On Wed, May 17, 2017 at 06:32:42PM -0700, Darrick J. Wong wrote:
>> > >> > Apparently there are certain system software configurations that do odd
>> > >> > things like update the kernel and reboot without umounting the /boot fs
>> > >> > or remounting it readonly, either of which would push all the AIL items
>> > >> > out to disk.  As a result, a subsequent invocation of something like
>> > >> > grub (which has a frightening willingness to read a fs with a dirty log)
>> > >> > can read stale disk contents and/or miss files the metadata for which
>> > >> > have been written to the log but not checkpointed into the filesystem.
>> > >>
>> > >> > Granted, most of the time /boot is a separate partition and
>> > >> > systemd/sysvinit/whatever actually /do/ unmount /boot before rebooting.
>> > >> > This "fix" is only needed for people who have one giant filesystem.
>> > >>
>> > >> Let me guess the series of events: grub calls "sync" and says "I'm
>> > >
>> > > dpkg/rpm/systemd/CABEXTRACT.EXE/whatever, but yes :)
>> >
>> >
>> > It has nothing to do with GRUB. The exact same problem would happen
>> > regardless of bootloader because the thing writing out bootloader
>> > configuration prior to reboot is grubby, which is not at all in any
>> > way related to GRUB.
>
> Chris, I've told you previously this is wrong (it's incorrect for
> lilo) and too narrow (grubby is not the only update infrastructure
> around), but I'll repeat it again because we need to move past your
> single-distro focus on grubby and discuss the underlying problems.


And I'm trying to get you to move past your ancient legacy bootloader
focus and discuss things that matter in 2017.

First, nothing works like LILO, not even ELILO works like LILO.

Second, I have only been able to reproduce this problem with grubby +
XFS. If I manually do grub2-mkconfig + reboot -f instead, the problem
does not happen. It might be that I'm too slow, and the marginal
amount of extra time permits the new grub.cfg to fully commit, but I
don't know.

Third, basic bootloader concepts:

The bootloader is the executable that's loaded by the firmware after POST.

The bootloader installer is not the bootloader. /sbin/lilo,
/sbin/extlinux, /sbin/grub-install are not bootloaders, they are
bootloader installers. Only lilo totally reinstalls the bootloader
binary when configurations change. GRUB, extlinux, uboot, zipl don't
do that. Their configuration files change and that's it, and they do
not depend on boot sectors for this, they don't write outside the file
system to the drive like lilo. They depend on the file system.

So what you are stuck with, what you have in 2017, are bootloaders
that do not work the way you describe, and will not ever work like
what you describe.



> However, IMO problem does indeed lie with the bootloader and not the
> distro packaging mechanism/scripts, and so we need to talk a bit out
> the architectural differences between bootloaders like lilo and
> grub/petitboot and why I consider update durability to be something
> the bootloader needs to provide, not thrid party packagers or the
> init system.

Either the bootloader needs to learn how to read dirty logs, or there
can be no dirty log entries related to three things: kernel,
initramfs, and bootloader configuration. If any of those three things
are not fully committed to the file system metadata,  the bootloader
will fail to find them.

GRUB, extlinux, uboot - they are reading the file system to find their
configuration files, the kernel and the initramfs. That's not how LILO
works. And putting it on some pedestal as if that's how these other
bootloader ought to work in order to be fail safe, is ridiculous on
its face. It's basically demanding they do a total architectural
change and rewrite from scratch.

If GRUB or grubby are not being used, then the bootloader
configuration file is most likely modified by a script in the kernel
package. How do you avoid burdening the kernel package from update
durability when it is responsible for writing the kernel, initramfs,
and the third most likely thing to modify the bootloader
configuration?

You're also saying that sync() is not sufficient, and also haven't
answered the question if it's sane for the kernel package manager as
well as the bootloader configuration modifier (be it the kernel
package, grubby, or grub-mkconfig) to assume that something else is
going to reliably remount-ro or umount or freeze the file system and
thus fully commit these changes.

If that is not sane, then you're burdening all of them with freeze
because they aren't in a position to remount or umount.


>> > Now originally they were blaming the file systems, saying that sync()
>> > is supposed to guarantee everything, data and metadata is completely
>> > written to stable media. But I think that definition of sync()
>> > predates journaled file systems, so now there's broad understanding in
>> > fs circles that journaled file systems only guarantee the journal and
>> > data are committed to stable media, not the fs metadata itself.
>>
>> Right.  Everything's committed to stable media /somewhere/, but the
>> metadata isn't necessarily where an fs driver will find it if that
>> driver ignores the dirty log.
>
> Right. ISTR that early FS journalling papers from the late 80s
> talked about this in detail, and why they didn't need to write back
> metadata to provide sync(1) guarantees.  All journalling filesystems
> since then have simply written the data+journal on sync(1).  These
> sorts of basic OS concepts should be known by *everyone* writing low
> level OS infrastructure...



*shrug* ok well there's evidence they do not in fact know this. So
start imagining what other confusion exists from wrong assumptions
about basic concepts, and how to go about mitigating this.







>> > This whole LILO thing is irritating. I don't know how many times I
>> > have to say it...
>> >
>> > grubby is the sole thing responsible for writing bootloader
>> > configuration changes, no matter the bootloader, on Red Hat and Fedora
>> > systems. There is absolutely no difference between LILO and GRUB
>> > bootloader configuration changes on these distros.
>>
>> I'm tired of getting beat over the head about this.  There's no grubby
>> on Debian!
>
> I've told Chris that several times, too. He's still shouting at me
> (and you!) about grubby, though...
>
>> (No *sync(), huh?)
> ...
>> (we only fsync the grubenv file??)
>
> Yikes! It's worse than I thought.
>
> So, with that all out of the way, lets look at a lilo update.
> My laptop (debian) running lilo:
>
> $ sudo vi /etc/lilo.conf
> <modify and save new config file to simulate dpkg installing a new
>  kernel package, updating /boot and various links and modifying the
>  /etc/lilo.conf file>
> $ sudo strace -o t.t lilo
> Added Linux  *
> Added Linux.old
> $ grep sync t.t
> sync()                                  = 0
> fdatasync(6)                            = 0
> fdatasync(6)                            = 0
> fdatasync(6)                            = 0
> fdatasync(6)                            = 0
> fdatasync(6)                            = 0
> fdatasync(6)                            = 0
> fdatasync(6)                            = 0
> fdatasync(6)                            = 0
> fdatasync(6)                            = 0
> fdatasync(6)                            = 0
> fdatasync(6)                            = 0
> fdatasync(6)                            = 0
> fdatasync(6)                            = 0
> fdatasync(6)                            = 0
> fdatasync(6)                            = 0
> fdatasync(6)                            = 0
> fdatasync(6)                            = 0
> sync()                                  = 0
> sync()                                  = 0
> $
>
> The files decriptors of note are:
>
> open("/dev/disk/by-id/ata-C400-MTFDDAK256MAM_000000001305036641EA", O_RDWR) = 5
> open("/boot/map~", O_RDWR)              = 6
>
> And here's the last ~10 operations done:
>
> write(6, "\353N\0\0\0\0LILO\30\2\3360\"Y\2\3\0\0\266\0\0\0\0\0\225;\340V\2\0", 32) = 32
> close(6)                                = 0
> lseek(5, 0, SEEK_SET)                   = 0
> sync()                                  = 0
> write(5, "\372\353!\1\264\1LILO\30\2\3360\"Y\0\0\0\0\303\3049Q\224\236\7\0\241\0\200`"..., 512) = 512
> close(5)                                = 0
> rename("/boot/map~", "/boot/map")       = 0
> sync()                                  = 0
> close(4)                                = 0
> exit_group(0)
>
> This says that lilo uses a safe overwrite proceedure to do the
> on-disk bootloader update. i.e. the initial sync ensures all the new
> kernel updates and config file mods are written to disk. It then
> maps all the files and writes the /boot/map~ file and syncs
> everything. At this point, the new boot information is on the block
> device. It then writes the new boot sector, renames /boot/map~ to it's
> proper name, then runs sync. This atomic update of the boot sector
> switches to the new boot map and makes the switch permanent.
>
> Hence when the lilo binary exits, the information required by the
> bootloader is *completely on stable storage*. At each stage, right
> up to the atomic boot sector overwrite, a crash or failure leaves
> the old boot map and boot sector intact. IOWs, lilo has a *fail-safe
> update procedure*.
>
> As a result, you do *not* need to call sync or freeze the filesystem
> after running the lilo command because it has already guaranteed the
> updated bootloader information is on stable storage.  And because
> you have to run lilo to update the bootloader, distro package
> managers *can't fuck it up* because the bootloader has full control
> of the update process.

Haha. Well it can't fuck it up because it's doing a total end run
around the file system. Not even ELILO can do that. There is no such
thing as boot sectors, and writing data outside the file system on a
UEFI computer.




>
> IOWs, Lilo updates are based on a fool-proof design.  It's also
> fail-safe on many levels because not only is the update mechanism
> fail-safe, config errors/failures will be caught during update
> rather before the system is restarted rather than when the config
> files are parsed during bootloader execution when it errors may be
> difficult/impossible to fix.
>
> Grub, unfortunately, does not have a fail-safe update procedure, and
> it clearly does not have a fool-proof update architecture (as this
> thread demonstrates). If we expect distro packaging tools to do
> reliable boot loader updates, then the bootloader needs to provide
> both fail-safe updates and do it via a fool-proof mechanism. It's no
> good having a fail-safe update mechanism if it does not get used to
> do updates. Grub currently fails on both accounts....


Fool proof design because it doesn't trust the file system, at all, for writing.

Actually GRUB has a functional equivalent, it's just that it's not the
upstream default, and no distro appears to want to use it by default:
create configuration file, create core image with that configuration
file baked into it, and then install new core.img to MBR gap or
bios-grub partition. And this can be done atomically and fail safe if
the gap is big enough, with the last step being to write a new
boot.img in the first 440 bytes of LBA 0 to point to the new core.img.

That works and is fail safe why? Because it depends on the file system
as much as lilo. Zero.




>
>> > So to be consistent you have to blame RPM for not ensuring its writes
>> > are safely on stable storage either, before reboot.
>> >
>> > Jesus Christ...
>> >
>> > I want Dave to write "this problem has nothing to do with GRUB" 50
>> > times on a chalkboard.
>>
>> Frankly, all you have to do is tweak the grub config file writer to
>> "fsfreeze -f /boot && fsfreeze -u /boot" after it writes the grub.cfg and
>> before it exits.  That's both grubby and grub-mkconfig.
>
> Yup, that's the work-around I've previously suggested should be
> added to grub and distro update mechanisms.  It doesn't fix the
> underlying architectural issues grub has (e.g. updates are still
> not fail-safe), but it provides the durability guarantee that is
> required if the whole update process completes.

It assumes that the kernel package executes grub-mkconfig or grubby
only once the kernel and initramfs have finished writing. I've seen
this happen in parallel with RPM and new-kernel-package, so you could
conceivably get this scenario:

1. kernel is written and sync()
2. initramfs is opened and dracut is creating it
3. grub-mkconfig runs and then fifreeze/fiunfreeze
4. dracut continues to append to initramfs then completes
5. reboot without remount-ro or umount

And now you have a borked boot because the initramfs isn't fully
committed, part of its writes are only in the journal which the
bootloader will not see. So it'll end up loading only part of the
initramfs into memory.


>
>> Or systemd/sysvinit could always ensure that the fs containing the boot
>> files is unmounted no matter what.  Or systemd/sysvinit could freeze the
>> fs for us before asking for a reboot.  Or the kernel could freeze the fs
>> for us before actually doing the reboot.  Any one of those options is
>> sufficient, but not one of them is reliably performed by any of the
>> pieces.  systemd *almost* always succeed at unmounting /boot, which is
>> why few people see this problem.
>
> Design principles of modularity and coupling say it's really up to
> the bootloader to provide the durability mechanisms it needs.  IOWs,
> the *bootloader update infrastructure* needs to provide the
> durability guarantee/mechanism the bootloader infrastructure
> requires (as per the lilo example) and not the init system.


The lilo example needs to be banned from the discussion. Nothing else
works like it does, nor will it. And it also ignores the fact that the
kernel or initramfs could possibly only be in the dirty log, without
being in fs metadata itself and thus not locatable by the bootloader.



Chris Murphy
