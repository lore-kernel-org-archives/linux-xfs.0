Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:35853 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbdESTJd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 May 2017 15:09:33 -0400
Received: by mail-yb0-f196.google.com with SMTP id n198so2791590yba.3
        for <linux-xfs@vger.kernel.org>; Fri, 19 May 2017 12:09:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170518223053.GD4519@birch.djwong.org>
References: <20170518012618.GT4519@birch.djwong.org> <20170518013242.GW4519@birch.djwong.org>
 <20170518083405.GQ17542@dastard> <20170518223053.GD4519@birch.djwong.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 19 May 2017 13:09:31 -0600
Message-ID: <CAJCQCtTj-7BovZbXyZu9=Dhh4ROR-AJ6Dpsw1GKbM-a2fr+uVw@mail.gmail.com>
Subject: Re: [PATCH 3/3] xfs: freeze rw filesystems just prior to reboot
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Thu, May 18, 2017 at 4:30 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Thu, May 18, 2017 at 06:34:05PM +1000, Dave Chinner wrote:
>> On Wed, May 17, 2017 at 06:32:42PM -0700, Darrick J. Wong wrote:
>> > Apparently there are certain system software configurations that do odd
>> > things like update the kernel and reboot without umounting the /boot fs
>> > or remounting it readonly, either of which would push all the AIL items
>> > out to disk.  As a result, a subsequent invocation of something like
>> > grub (which has a frightening willingness to read a fs with a dirty log)
>> > can read stale disk contents and/or miss files the metadata for which
>> > have been written to the log but not checkpointed into the filesystem.
>>
>> > Granted, most of the time /boot is a separate partition and
>> > systemd/sysvinit/whatever actually /do/ unmount /boot before rebooting.
>> > This "fix" is only needed for people who have one giant filesystem.
>>
>> Let me guess the series of events: grub calls "sync" and says "I'm
>
> dpkg/rpm/systemd/CABEXTRACT.EXE/whatever, but yes :)


It has nothing to do with GRUB. The exact same problem would happen
regardless of bootloader because the thing writing out bootloader
configuration prior to reboot is grubby, which is not at all in any
way related to GRUB.

I've explained this before, and now Dave's continued misstatements are
propagating to Darrick. If you guys want to believe in untrue things,
have at it. But please stop repeating untrue things.


>
>> done", then user runs an immediate reboot/shutdown and something
>> still running after init has killed everything but PID 1 has an open
>
> Worse than that, actually -- it was plymouthd, aka the splash screen.
> If plymouthd isn't running, then the ro remount succeeds (not that
> systemd actually checks) and grub is fine afterwards.
>
>> writeable file descriptor causing the remount-ro of / to return
>> EBUSY and so it just shuts down/restarts with an unflushed log?
>
> Yes, it's /that/ problem again, that you and I were going 'round and
> 'round about a month or two ago.  I decided that I could at least try to
> get something merged to reduce the user pain, even if the real problem
> is herpy derpy userspace.


Note that plymouth is doing the wrong thing per systemd's own
documentation. Plymouth has asked systemd to be exempt from being
killed, which systemd honors, but documentation says that programs
should not request such exemption on root file systems and should
instead run from the initramfs if they must be non-killable.

Both systemd and plymouth upstreams are aware of this and have been
looking into their own solution the problem, I don't know why they
consider the fix invasive, but that's how it's been characterized.

And I've argued to systemd folks that they need to take some
responsibility for this because this happens during their
offline-update.target which which a particular boot mode that is
explicitly designed for system software updates, and it's used because
it's supposed to be a safe, stable, known environment, compared to
doing updates while a bunch of stuff including a desktop environment
is running. And yet - poof - it yanks the file system out from under
itself.

Now originally they were blaming the file systems, saying that sync()
is supposed to guarantee everything, data and metadata is completely
written to stable media. But I think that definition of sync()
predates journaled file systems, so now there's broad understanding in
fs circles that journaled file systems only guarantee the journal and
data are committed to stable media, not the fs metadata itself. And do
require sync() to apply to fs metadata, I suspect means file systems
would become slower than molasses in winter.


>
>> > Therefore, add a reboot hook to freeze the rw filesystems (which
>> > checkpoints the log) just prior to reboot.  This is an unfortunate and
>> > insufficient workaround for multiple layers of inadequate external
>> > software, but at least it will reduce boot time surprises for the "OS
>> > updater failed to disengage the filesystem before rebooting" case.
>> >
>> > Seeing as grub is unlikely ever to learn to replay the XFS log (and we
>> > probably don't want it doing that),
>>
>> If anything other than XFS code modifies the filesystem (log,
>> metadata or data) then we have a tainted, unsuportable filesystem
>> image.....
>
> Indeed.

Doesn't mount -o ro still do journal replay but then doesn't write any
fixes back to stable media? Why can't the bootloader do this? GRUB2
for a rather long time now has a 4GiB memory limit on 32-bit and GRUB
devs have said this could be lifted higher on 64-bit. There is no
640KiB limit for GRUB.


>
>> > *LILO has been discontinued for at least 18 months,
>>
>> Yet Lilo still works just fine.
>
> Ok fine it's been /totally stable/ for 18 months. ;)
> https://lilo.alioth.debian.org/
>
> FWIW lilo isn't compatible with reflinked inodes (admittedly unlikely on
> /boot) but


This whole LILO thing is irritating. I don't know how many times I
have to say it...

grubby is the sole thing responsible for writing bootloader
configuration changes, no matter the bootloader, on Red Hat and Fedora
systems. There is absolutely no difference between LILO and GRUB
bootloader configuration changes on these distros.


>
>> > and we're not quite to the point of putting kernel
>> > files directly on the EFI System Partition,
>>
>> Really? How have we not got there yet - we were doing this almost
>> 15 years ago with ia64 and elilo via mounting the EFI partition on
>> /boot....
>
> elilo also seems dead, according to its SF page.
> https://sourceforge.net/projects/elilo/
>
> I'm not sure why we don't just drop kernel+initrd into the ESP and
> create a bootloader entry via efibootmgr,


I explained this too already.

So long as there is dual boot, this is a dead end. There isn't enough
room on ESP's for this, and it can't be grown, and it's unreliable to
have two ESPs on  the same system due to myriad UEFI bugs, and also it
confuses Windows. So it's not ever going to happen except on Linux
only systems.



>> This really sounds like the perennial "grub doesn't ensure the
>> information it requires to boot is safely on stable storage before
>> reboot" problem combined with some sub-optimal init behaviour to
>> expose the grub issue....
>
> Yep!  Anyway Christoph is right, this isn't something that plagues only
> XFS; Ted was also musing that ext4 likely needs the same workaround, so
> I'll go move this to fsdevel. :)


*facepalm* You guys are driving me crazy.

1. The grub.cfg is modified by grubby. Not grub. The same damn problem
would happen no matter what bootloader is used.
2. It's not just the grub.cfg that cannot be found by GRUB. It can't
find the new kernel file, any of its modules, or the new initramfs.
None of that has XFS file system metadata either. It's all simply not
there as far as the bootloader is concerned. And all of those things
were written by RPM.

So to be consistent you have to blame RPM for not ensuring its writes
are safely on stable storage either, before reboot.

Jesus Christ...

I want Dave to write "this problem has nothing to do with GRUB" 50
times on a chalkboard.

And then I want him to strace grub2-mkconfig (which grubby does not
use, which no Fedora or Red Hat system uses except one time during the
original installation of the system) to prove his claim that grub
isn't ensuring bootloader configuration info isn't getting to stable
storage. Otherwise this is just handwaiving without evidence. If the
GRUB folks are doing something wrong, seeing as all other distros do
rely upon it, then it needs to get fixed. But claiming things without
evidence is super shitty.

Now I just tried to strace grub2-mkconfig with -ff and I get literally
2880+ files. That is batshit crazy, but aside from that I think the
most relevant child process that writes out the actual final grub.cfg
is this:

https://paste.fedoraproject.org/paste/iksyeiYhxAIgbrbrugqOzV5M1UNdIGYhyRLivL9gydE=

I don't know what its not doing that it should be doing, but then also
RPM must also not being doing it.

-- 
Chris Murphy
