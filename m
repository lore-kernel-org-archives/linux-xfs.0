Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:36136 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753379AbdCXFPw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Mar 2017 01:15:52 -0400
Received: by mail-yw0-f180.google.com with SMTP id i203so2577020ywc.3
        for <linux-xfs@vger.kernel.org>; Thu, 23 Mar 2017 22:15:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170323230157.GG17542@dastard>
References: <20170315072349.GZ5280@birch.djwong.org> <CAJCQCtR8RLOBxK7S9Ck0ATT_5vVY6T9rmLtKrYGLPJTrsDRdNQ@mail.gmail.com>
 <20170315191355.GF5280@birch.djwong.org> <20170315193040.GG5280@birch.djwong.org>
 <CAJCQCtRt7_WpEp0npF=k1JJHFLE2sfc9ktB4YakuCZ5CNfZTTg@mail.gmail.com>
 <CAJCQCtRVuKiOMdtGLb3QbR8uCTXbhFMnNQgPzzZWG7y6URawHQ@mail.gmail.com>
 <20170322043438.GD17542@dastard> <CAJCQCtQ6VXd4s=SZcMuSbEhN7yRKRk0GULY2isbg2ZAh5RW+=w@mail.gmail.com>
 <20170322221912.GE17542@dastard> <CAJCQCtRes2OiqH1-UP9A_L1DLAZcXJbG--o669G+0XK1fmK8BQ@mail.gmail.com>
 <20170323230157.GG17542@dastard>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 23 Mar 2017 23:15:50 -0600
Message-ID: <CAJCQCtTBcge03aVRkkdxp24YdvKaiHq6p7n3zJ+bcBhpLnXpXw@mail.gmail.com>
Subject: Re: boot failure after kernel update, imap claims in-use inode 661690
 is free, would correct imap
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Murphy <lists@colorremedies.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs list <linux-xfs@vger.kernel.org>

On Thu, Mar 23, 2017 at 5:01 PM, Dave Chinner <david@fromorbit.com> wrote:

>
> We solved reliable booting 20 years ago - it's a simple as "set up
> separate boot partition and use Lilo". Been working reliably for me
> and all the systems I've installed and managed since 1995.... :/

The problem doesn't happen with a separate boot volume; different
bootloader isn't necessary. No one is actively supporting LILO
anymore. There are apparently so many uses cases people want to
support that it doesn't support that no one cares to bring it up to
speed. It's like saying the old ice box works just fine since 1895,
just that it's someone else's fault they don't deliver ice blocks
anymore.



>
> <feel free to insert you own "rocking chairs and lawn" comments :P>
>
>> But I sincerely doubt anyone on this list gives a flying fuck about
>> bootloader problems.
>
> Nobody should care, because in future we should be replacing the
> bootloader with "copy kernels into EFI partition and boot from EFI".
> i.e. bypassing the need for a bootloader altogether. Worked
> perfectly well for booting ia64 machines 10-15 years ago....

Unworkable for dual boot, let alone multibooting. The ESP is too
small, no installer team is going to take responsibility for growing
it, Windows gets confused when there's more than one on a disk,  and
the UEFI spec has no standardization for firmware boot managers, so
there's no way to provide generic documentation for the built-in boot
manager: and thus the bootloader needs to also be a boot manager in
order to document it. And that leaves us right back to each distro
owning it's own bootloader even on UEFI systems, where they have no
idea WTF other distros have been installed (yes they will all see
Windows, but it won't discover each other because Windows is not
really a competitor, again leaving us with distros eating each others
babies, etc.)



>
>> Actually, characterizing the distros as
>> uncooperative is too polite. They actively sabotage each other. It's
>> so bad, they even sabotage themselves (try doing back to back side by
>> side installations of Fedora). Each distro's grub is effectively a
>> fork. Fedora ostensibly uses mostly upstream stuff, but with grub the
>> upstream copy has 200+ hacks that are Fedora specific, SUSE has more
>> and more invasive hacks, both of them are mutually incompatible. The
>> distros don't agree. They're different operating systems that just so
>> happen to share a kernel (or an init service). This fact isn't going
>> to get solved on this list.
>
> Yup, that's exactly what I was implying is the problem - everyone
> has their own special snowflake rather than working together to
> produce one simple, robust, reliable solution to a well known problem...

Unsolvable. Systemd folks wrote up the bootloaderspec, and about 10
minutes later there was a more sane fork by Matthew Garrett, and 10
minutes later there were three implementations, all of which are
mutually incompatible with each other. Still no cross distro
cooperation either.


>> So if you have something else for me to actually act on, I'm happy to
>> try and push this forward so a teeny tiny handful of users can
>> actually do single volume XFS booting and not end up face planted when
>> they do offline updates. Thanks.
>
> *As I always say*: fix the root cause of the problem, don't hack
> around it because that almost always makes things worse in the long
> run. Hacking code into systemd to work around a distro-specific
> and/or bootloader bug is simply not a viable long term solution to
> the collaboration problems that have been pointed out here...

OK well in three replies you're still vague on precisely how the
bootloader is even involved in this problem, seeing as it doesn't make
any changes to the disk during kernel update, at all. If you want to
implicate grubby for doing the wrong thing, that'll need more detailed
explanation. From what I can tell the problem is systemd initiates a
reboot, while root fs is still mounted rw, the kernel tolerates this
and leaves the fs dirty, and the bootloader can't handle the fallout
and can't be expected to handle it.

It's either systemd needs to not do reboots when root fs can't be
remounted-ro; and therefore must not have indefinite exemptions from
killing processes that don't hold rw mount on volumes. LIterally any
bad program could exist somewhere at sometime, not exit, and thus
cause this problem. So even if plymouth is an instigator in this case,
the central problem seems to be either systemd for the indefinite kill
exemption, or it's the kernel for doing a reboot when a file system is
still dirty. And I don't know nearly enough about the separation of
responsibilities between systemd and the kernel to have a clue whether
the root cause is systemd or the kernel.

But I'm unconvinced it's plymouth, dracut, grubby, or the bootloader,
even though all of them are instigators.

And by the way, the freeze/unfreeze idea was your idea. So to bring
that up, and then in the very next email say it's fucked up to
actually insert it somewhere if multiple remount attempts fail is
bizarre. Since it's sufficiently fucked up to get you to actually
write out the words fucked up, maybe the idea shouldn't have been
mentioned in the first place? Why mention a bag of dicks as a solution
if you're just doing to say oh shit that's a bag of dicks are you
fucking crazy? Don't do that!


-- 
Chris Murphy
