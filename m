Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:16179 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756212AbdCWXDY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Mar 2017 19:03:24 -0400
Date: Fri, 24 Mar 2017 10:01:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: boot failure after kernel update, imap claims in-use inode
 661690 is free, would correct imap
Message-ID: <20170323230157.GG17542@dastard>
References: <20170315072349.GZ5280@birch.djwong.org>
 <CAJCQCtR8RLOBxK7S9Ck0ATT_5vVY6T9rmLtKrYGLPJTrsDRdNQ@mail.gmail.com>
 <20170315191355.GF5280@birch.djwong.org>
 <20170315193040.GG5280@birch.djwong.org>
 <CAJCQCtRt7_WpEp0npF=k1JJHFLE2sfc9ktB4YakuCZ5CNfZTTg@mail.gmail.com>
 <CAJCQCtRVuKiOMdtGLb3QbR8uCTXbhFMnNQgPzzZWG7y6URawHQ@mail.gmail.com>
 <20170322043438.GD17542@dastard>
 <CAJCQCtQ6VXd4s=SZcMuSbEhN7yRKRk0GULY2isbg2ZAh5RW+=w@mail.gmail.com>
 <20170322221912.GE17542@dastard>
 <CAJCQCtRes2OiqH1-UP9A_L1DLAZcXJbG--o669G+0XK1fmK8BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtRes2OiqH1-UP9A_L1DLAZcXJbG--o669G+0XK1fmK8BQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs list <linux-xfs@vger.kernel.org>

On Wed, Mar 22, 2017 at 06:15:42PM -0600, Chris Murphy wrote:
> On Wed, Mar 22, 2017 at 4:19 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Mar 22, 2017 at 09:36:21AM -0600, Chris Murphy wrote:
> 
> >> OK. It looks to me like systemd eventually gives up on the remount-ro,
> >> and then just reboots. That strikes me as a flawed design. Systemd
> >> needs to wait longer (which is vague advice), or maybe after the 3rd
> >> failed remount-ro, insert a freeze/unfreeze, then reboot. How does
> >> that sound?
> >
> > Sounds supremely fragile and fucked up. Sure, lets add another
> > layers of hacks to systemd to work around the problem that systemd
> > can't remount-ro the root filesystem because systemd holds open
                                                 ^^^^^^^
Meant to say "something" here, not "systemd".

> > write fds on the root fs. Fix the problem that causes open write fds
> > on the root fs at the end of shutdown? Nah, that's stupid talk -
> > just hack a bandaid over the top....

<snip misdirected rant about it not being systemd's fault>

> > Really, the bootloader needs fixing, then we can go back to
> > blissfully ignoring all the stupid bugs in the steaming pile we know
> > as systemd...
> 
> If I thought that bitching about the deplorable state of bootloaders
> on Linux, the total lack of cooperation among the distributions when
> it comes to the basic task of booting a fucking computer in 2017, when
> this shit was solved fucking 25 goddamn years ago by Microsoft and
> Apple, and they don't have the myriad problems and bugs I'm constantly
> finding on just Fedora release to release? I would have done it a long
> time ago.

We solved reliable booting 20 years ago - it's a simple as "set up
separate boot partition and use Lilo". Been working reliably for me
and all the systems I've installed and managed since 1995.... :/

<feel free to insert you own "rocking chairs and lawn" comments :P>

> But I sincerely doubt anyone on this list gives a flying fuck about
> bootloader problems.

Nobody should care, because in future we should be replacing the
bootloader with "copy kernels into EFI partition and boot from EFI".
i.e. bypassing the need for a bootloader altogether. Worked
perfectly well for booting ia64 machines 10-15 years ago....

> Actually, characterizing the distros as
> uncooperative is too polite. They actively sabotage each other. It's
> so bad, they even sabotage themselves (try doing back to back side by
> side installations of Fedora). Each distro's grub is effectively a
> fork. Fedora ostensibly uses mostly upstream stuff, but with grub the
> upstream copy has 200+ hacks that are Fedora specific, SUSE has more
> and more invasive hacks, both of them are mutually incompatible. The
> distros don't agree. They're different operating systems that just so
> happen to share a kernel (or an init service). This fact isn't going
> to get solved on this list.

Yup, that's exactly what I was implying is the problem - everyone
has their own special snowflake rather than working together to
produce one simple, robust, reliable solution to a well known problem...

> So if you have something else for me to actually act on, I'm happy to
> try and push this forward so a teeny tiny handful of users can
> actually do single volume XFS booting and not end up face planted when
> they do offline updates. Thanks.

*As I always say*: fix the root cause of the problem, don't hack
around it because that almost always makes things worse in the long
run. Hacking code into systemd to work around a distro-specific
and/or bootloader bug is simply not a viable long term solution to
the collaboration problems that have been pointed out here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
