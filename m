Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:35581 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754973AbdCWAPp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Mar 2017 20:15:45 -0400
Received: by mail-yw0-f194.google.com with SMTP id h11so21896419ywa.2
        for <linux-xfs@vger.kernel.org>; Wed, 22 Mar 2017 17:15:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170322221912.GE17542@dastard>
References: <CAJCQCtQ8aZn5y7WjCC=PamChxSw9Fd=0D7o2+S_GEbifV1h+ig@mail.gmail.com>
 <20170315072349.GZ5280@birch.djwong.org> <CAJCQCtR8RLOBxK7S9Ck0ATT_5vVY6T9rmLtKrYGLPJTrsDRdNQ@mail.gmail.com>
 <20170315191355.GF5280@birch.djwong.org> <20170315193040.GG5280@birch.djwong.org>
 <CAJCQCtRt7_WpEp0npF=k1JJHFLE2sfc9ktB4YakuCZ5CNfZTTg@mail.gmail.com>
 <CAJCQCtRVuKiOMdtGLb3QbR8uCTXbhFMnNQgPzzZWG7y6URawHQ@mail.gmail.com>
 <20170322043438.GD17542@dastard> <CAJCQCtQ6VXd4s=SZcMuSbEhN7yRKRk0GULY2isbg2ZAh5RW+=w@mail.gmail.com>
 <20170322221912.GE17542@dastard>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 22 Mar 2017 18:15:42 -0600
Message-ID: <CAJCQCtRes2OiqH1-UP9A_L1DLAZcXJbG--o669G+0XK1fmK8BQ@mail.gmail.com>
Subject: Re: boot failure after kernel update, imap claims in-use inode 661690
 is free, would correct imap
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Murphy <lists@colorremedies.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs list <linux-xfs@vger.kernel.org>

On Wed, Mar 22, 2017 at 4:19 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Mar 22, 2017 at 09:36:21AM -0600, Chris Murphy wrote:

>> OK. It looks to me like systemd eventually gives up on the remount-ro,
>> and then just reboots. That strikes me as a flawed design. Systemd
>> needs to wait longer (which is vague advice), or maybe after the 3rd
>> failed remount-ro, insert a freeze/unfreeze, then reboot. How does
>> that sound?
>
> Sounds supremely fragile and fucked up. Sure, lets add another
> layers of hacks to systemd to work around the problem that systemd
> can't remount-ro the root filesystem because systemd holds open
> write fds on the root fs. Fix the problem that causes open write fds
> on the root fs at the end of shutdown? Nah, that's stupid talk -
> just hack a bandaid over the top....

That's adorable, no really. I thought you were on vacation?

Anyway, there isn't enough information from systemd's debugging to
know exactly why it's failing to remount-ro. The trail of breadcrumbs
we have implicates plymouth, not systemd which I reported in the 2nd
message of this thread.

Process 304 (plymouthd) has been marked to be excluded from killing.
It is running from the root file system, and thus likely to block
re-mounting of the root file system to read-only. Please consider
moving it into an initrd file system instead.

I already suggested elsewhere that this is a distribution problem, and
dracut needs to always stuff plymouth into the initramfs. When I do
this manually, the reported problem does not happen; where if plymouth
is running from root fs *and* /boot is a directory on that same root
fs, this problem always happens.

So plymouth blames itself and dracut, pretty much. Is there some
additional technical reason to blame systemd for this problem?



> And let's also ignore the fact that, in this case, the remount-ro is
> effectively working around bootloader updates not providing
> durability guarantees.  i.e. the bootloader doesn't do guaranteed
> safe updates and requires 3rd party action to provide update
> integrity.  The distro update scripts are all different because the
> bootloader doesn't provide the necessary update infrastructure the
> distros require, and it's extremely naive to expect the developers
> of those scripts to understand that they need to provide integrity
> guarantees that the bootloader itself doesn't provide.

The only bootloader that has a script for updating its configuration
file is GRUB, and has I previously explained that's grub-mkconfig and
it's not used at all on Fedora (or CentOS or RHEL). For at least 10
years it has been the job of grubby, going back to grub legacy. And it
doesn't matter what the bootloader being used is, grubby directly
modifies (read-modify-write) the configuration file for grub,
systemd-boot, extlinux, lilo, u-boot, and a pile of others.

> Really, the bootloader needs fixing, then we can go back to
> blissfully ignoring all the stupid bugs in the steaming pile we know
> as systemd...

If I thought that bitching about the deplorable state of bootloaders
on Linux, the total lack of cooperation among the distributions when
it comes to the basic task of booting a fucking computer in 2017, when
this shit was solved fucking 25 goddamn years ago by Microsoft and
Apple, and they don't have the myriad problems and bugs I'm constantly
finding on just Fedora release to release? I would have done it a long
time ago.

But I sincerely doubt anyone on this list gives a flying fuck about
bootloader problems. Actually, characterizing the distros as
uncooperative is too polite. They actively sabotage each other. It's
so bad, they even sabotage themselves (try doing back to back side by
side installations of Fedora). Each distro's grub is effectively a
fork. Fedora ostensibly uses mostly upstream stuff, but with grub the
upstream copy has 200+ hacks that are Fedora specific, SUSE has more
and more invasive hacks, both of them are mutually incompatible. The
distros don't agree. They're different operating systems that just so
happen to share a kernel (or an init service). This fact isn't going
to get solved on this list.

So if you have something else for me to actually act on, I'm happy to
try and push this forward so a teeny tiny handful of users can
actually do single volume XFS booting and not end up face planted when
they do offline updates. Thanks.


-- 
Chris Murphy
