Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:36035 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752189AbdETA1y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 May 2017 20:27:54 -0400
Received: by mail-yb0-f195.google.com with SMTP id n198so2981085yba.3
        for <linux-xfs@vger.kernel.org>; Fri, 19 May 2017 17:27:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170519210040.GL4519@birch.djwong.org>
References: <20170518012618.GT4519@birch.djwong.org> <20170518013242.GW4519@birch.djwong.org>
 <20170518083405.GQ17542@dastard> <20170518223053.GD4519@birch.djwong.org>
 <CAJCQCtTj-7BovZbXyZu9=Dhh4ROR-AJ6Dpsw1GKbM-a2fr+uVw@mail.gmail.com> <20170519210040.GL4519@birch.djwong.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 19 May 2017 18:27:53 -0600
Message-ID: <CAJCQCtRWyb-zMWJLoa1GK3PtVg2x=ySU2KiUZaGK4Lw1=t=sYA@mail.gmail.com>
Subject: Re: [PATCH 3/3] xfs: freeze rw filesystems just prior to reboot
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Chris Murphy <lists@colorremedies.com>, Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Fri, May 19, 2017 at 3:00 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:


> Would it help if I mentioned this --
>
> *sync() -> write data to disk, write metadata to log
> FIFREEZE() -> sync() and write log contents to fs.
> unmount() -> sync() write log contents to fs.
> reboot() -> sync() and reboot.
>
> So if you're going to write data to a filesystem that has to be read by
> a piece of software that /ignores dirty logs/, you have to write the log
> to disk before you reboot.  This can be unmount or freeze, take your
> pick.  You cannot sync, because sync only ensures that everything is
> /somewhere/ on the stable medium.  It does not guarantee that log
> contents have been written to the fs.

Yes that helps quite a bit.


> Frankly, all you have to do is tweak the grub config file writer to
> "fsfreeze -f /boot && fsfreeze -u /boot" after it writes the grub.cfg and
> before it exits.  That's both grubby and grub-mkconfig.

I am willing to bet that their assumption has been, since ancient
times, that PID 1 umounts the file system before reboot, thereby
writing log contents to the file system. And it's not just these two
programs, there's probably bunches of kernel updates that are done by
myriad scripts that likewise assume on umount happening before reboot.


For sure systemd devs did not previously understand that sync() does
not write the log contents to the file system, and I think they are
open to the idea of falling back to FIFREEZE if remount-ro or umount
fail, before doing a reboot. That is functionally equivalent to what
they thought sync() was doing, after all.

Does that that alter your assessment of where to fix this?


> Or systemd/sysvinit could always ensure that the fs containing the boot
> files is unmounted no matter what.

systemd has an explicit feature allowing programs to opt out and so
far the feature can be abused contrary to documentation. So it's
definitely not reasonable (anymore) that PID 1 guarantees remount-ro
or umount prior to reboot.


>Or systemd/sysvinit could freeze the
> fs for us before asking for a reboot.

I think that's very plausible, but I do not speak for the systemd folks.

>Or the kernel could freeze the fs
> for us before actually doing the reboot.  Any one of those options is
> sufficient, but not one of them is reliably performed by any of the
> pieces.  systemd *almost* always succeed at unmounting /boot, which is
> why few people see this problem.

I can't assess what is better, systemd doing freeze, vs the kernel, vs
bootloader scripts. I think the path of least resistance is systemd
doing it, that more closely mimics historical assumptions anyway.

If there is a better way of doing it than history proposes, that's
fine also. But I think the fsdevel folks should actually have a direct
conversation with the systemd folks, to arrest the wrong assumptions
about sync() vs FIFREEZE(), and avoid duplicate efforts.

-- 
Chris Murphy
