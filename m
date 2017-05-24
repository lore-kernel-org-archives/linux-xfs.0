Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:35786 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966402AbdEXIGv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 May 2017 04:06:51 -0400
Received: by mail-yw0-f196.google.com with SMTP id p144so12366101ywp.2
        for <linux-xfs@vger.kernel.org>; Wed, 24 May 2017 01:06:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170524031935.GZ17542@dastard>
References: <20170518012618.GT4519@birch.djwong.org> <20170518013242.GW4519@birch.djwong.org>
 <20170518083405.GQ17542@dastard> <20170518223053.GD4519@birch.djwong.org>
 <CAJCQCtTj-7BovZbXyZu9=Dhh4ROR-AJ6Dpsw1GKbM-a2fr+uVw@mail.gmail.com>
 <20170519210040.GL4519@birch.djwong.org> <20170522020112.GV17542@dastard>
 <CAJCQCtTj4it6o-Fop6vm3s_HFbRemF5o_H9w-tvS6wmFfVwKBA@mail.gmail.com> <20170524031935.GZ17542@dastard>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 24 May 2017 02:06:49 -0600
Message-ID: <CAJCQCtQH5H15pEEdwx+pZkDHsYiU3FXqE-zWvm9eYUmDYzk=mg@mail.gmail.com>
Subject: Re: [PATCH 3/3] xfs: freeze rw filesystems just prior to reboot
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Murphy <lists@colorremedies.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Tue, May 23, 2017 at 9:19 PM, Dave Chinner <david@fromorbit.com> wrote:



>
>> they don't write outside the file
>> system to the drive like lilo.
>
> Hmmm - I demonstrated this assertion to be false in the email you
> replied to.

They = grubby, grub-mkconfig. They do not write a block list outside
the file system like lilo does. All they do is modify the bootloader
configuration file, via the file system, they do not write directly to
the block device like lilo.


>
> The Lilo installer gets the physical location information from the
> filesystem via the OS provided FIBMAP ioctl(), which it then writes
> it into a file in the filesysetm (boot.map), which it then it maps
> with FIBMAP and writes that map into the boot sector on the block
> device.  At no point does it "go around the filesystem" to obtain or
> write this information to stable storage for the bootloader
> executable to use. The bootloader executable then just reads the
> block map information directly from the block device to load the
> kernel.


Yes it's basically a block list and it has no idea what a file system
is. i get that. When I say do an end run around the file system, I
mean it writes that block list direct to the block device, not as a
file in the file system. When the computer boots, it reads a sequence
of blocks without any understanding of the file system, again it goes
around the file system.


> The grub installer writes a config file and that's about it.

 grub-install only writes out boot.img to LBA 0, and core.img to the
MBR gap or bios-grub partition, and copies its additional support
modules from /usr to /boot. That's it. No configuration file is
created with grub-install.

grub-mkconfig only writes a config file, it does not modify any binary data.

LILO is combining these functions to make its blocklist, the whole
thing is written out each time.


 On
> boot, the stage 1 loader in the boot sector bootstraps
> the larger stage 2 loader. That then loads all the modules needed to
> probe the booting block device contents and load the modules needed
> to traverse the metadata structure it contains to find the block
> map/extent list of the config file.  Then it decodes the block map,
> reads the config file direct from the block device and parses it. It
> then repeats this metadata traversal and extent list decoding for
> each file it needs to read to boot.
>
> IOWs, the information they use is exactly the same, but LILO avoids
> all the bootloader executable complexity by doing all the mapping
> work n the installer through generic, filesystem agnostic OS
> interfaces before reboot.
>
> In contrast, the "parse the block device" architecture of grub and
> similar bootloaders ensures that the bootloader executable is locked
> into an endless game of whack-a-mole as filesystems, volume managers
> and other storage management applications change formats and
> behaviours.....


Yes, I'm aware.

Here is the difference. I'm accepting reality, and you keep
complaining about reality while pining for the glory days of LILO and
how everything else is Doing It Wrong (TM). It doesn't matter. We have
what we have.



>> > However, IMO problem does indeed lie with the bootloader and not the
>> > distro packaging mechanism/scripts, and so we need to talk a bit out
>> > the architectural differences between bootloaders like lilo and
>> > grub/petitboot and why I consider update durability to be something
>> > the bootloader needs to provide, not thrid party packagers or the
>> > init system.
>>
>> Either the bootloader needs to learn how to read dirty logs,
>
> I don't think anyone wants to expend the time and effort needed to
> do this for each filesystem that the grub bootloader supports,
> especially as it is not necessary.
>
>> or there
>> can be no dirty log entries related to three things: kernel,
>> initramfs, and bootloader configuration. If any of those three things
>> are not fully committed to the file system metadata,  the bootloader
>> will fail to find them.
>
> Yup - I've been trying to tell you that these are the exact
> guarantees that freezing the fs will provide the bootloader
> installer....

Except the bootloader can't do that. And yet you've been trying to pin
the entire problem on grub, and even if that's a generic term, it
isn't the bootloader generally that can do anything about this.

As far as I know, only GRUB comes with a utility for updating its
bootloader configuration file and it could be modified to do fsfreeze.
Other bootloaders depend on the kernel package postinstall script (I
assume) to modify the bootloader configuration. For sure extlinux
doesn't come with such a utility.




>
>> If GRUB or grubby are not being used, then the bootloader
>> configuration file is most likely modified by a script in the kernel
>> package. How do you avoid burdening the kernel package from update
>> durability when it is responsible for writing the kernel, initramfs,
>> and the third most likely thing to modify the bootloader
>> configuration?
>
> Solved problem via post-inst package scripts.

Ergo it is not the problem of the bootloader and no solution can be
found there like I've been saying this whole damn time.

OK so you're saying that every kernel package post install script
needs to do fsfreeze, rather than systemd doing it when remount-ro or
umount fail? Really? You really think they're all going to do this? I
would be shocked if it took systemd folks more than a month to
implement this, and shocked if it took less than a year for either
grubby or GRUB folks, let alone myriad kernel packaging teams to grok
the reason for this. I can just hear it now: What? sync doesn't do it?
Fuck!!! times every distro...

Yeah solved problem. Hilarious.






>> Haha. Well it can't fuck it up because it's doing a total end run
>> around the file system.
>
> FYI: the canonical example of "doing a total end run around the
> filesystem" is to write your own filesystem parsers to directly walk
> filesystem structures on a block device without going through the
> supported OS filesystem channels for accessing that filesystem
> information.

Yeah well you're coming at it from a certain perspective and I'm
coming at it from another. You see the code as the file system. When I
say the file system, i mean the file system volume, the actual
instance of a file system on a drive. That's what's being run around
by writing directly to blocks, and directly reading blocks.


>
>> Actually GRUB has a functional equivalent, it's just that it's not the
>> upstream default, and no distro appears to want to use it by default:
>
> IIRC, that's the "filesystem install" mode and there's good reason
> it's not used: LBA 0 of the block device belongs to the filesystem
> on that device, not the bootloader. Hence if you have a filesystem
> that uses LBA 0 (e.g. XFS), using grub in this mode on that block
> device will trash it and then you've got bigger problems....

No, the baking in of the configuration file is available regardless of
whether the installation happens to the whole block device or to a
partition/volume. The file system install mode is basically block
listing the core.img file rather than it being embedded in the MBR
gap. I am not a fan of this complexity but it still has a bunch of
fanboys from a bygone era...

The first sector of the block device, and each partition, is really
owned by the firmware on x86. It's the boot sector, has been since
ancient times. It is the only sectors the firmware will blindly read
at boot time. It's the original way multiboot worked, jump code in LBA
0 plus an active bit on a partition told the firmware to read and
execute the contents of the first sector at that partition's CHS
address. To switch OS's, you only needed to change the active bit to a
different partition.


-- 
Chris Murphy
