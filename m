Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:7292 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751854AbdCVWTW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Mar 2017 18:19:22 -0400
Date: Thu, 23 Mar 2017 09:19:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: boot failure after kernel update, imap claims in-use inode
 661690 is free, would correct imap
Message-ID: <20170322221912.GE17542@dastard>
References: <CAJCQCtQ8aZn5y7WjCC=PamChxSw9Fd=0D7o2+S_GEbifV1h+ig@mail.gmail.com>
 <20170315072349.GZ5280@birch.djwong.org>
 <CAJCQCtR8RLOBxK7S9Ck0ATT_5vVY6T9rmLtKrYGLPJTrsDRdNQ@mail.gmail.com>
 <20170315191355.GF5280@birch.djwong.org>
 <20170315193040.GG5280@birch.djwong.org>
 <CAJCQCtRt7_WpEp0npF=k1JJHFLE2sfc9ktB4YakuCZ5CNfZTTg@mail.gmail.com>
 <CAJCQCtRVuKiOMdtGLb3QbR8uCTXbhFMnNQgPzzZWG7y6URawHQ@mail.gmail.com>
 <20170322043438.GD17542@dastard>
 <CAJCQCtQ6VXd4s=SZcMuSbEhN7yRKRk0GULY2isbg2ZAh5RW+=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtQ6VXd4s=SZcMuSbEhN7yRKRk0GULY2isbg2ZAh5RW+=w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs list <linux-xfs@vger.kernel.org>

On Wed, Mar 22, 2017 at 09:36:21AM -0600, Chris Murphy wrote:
> On Tue, Mar 21, 2017 at 10:34 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > FYI, I've ranted previously over many years about how broken grub's
> > kernel update and retreival process is fundamentally broken, but
> > it's never been fixed(*). As a result, I don't use grub on any of my
> > systems, nor do I recommend that anyone else use it.
> 
> OK I follow all the previous comments, thanks, but here is where
> there's a departure.
> 
> On Ubuntu systems, maybe all Debian systems, they are using
> grub-mkconfig script, possibly in the form of update-grub, to create a
> completely new grub.cfg. That script writes out grub.cfg.new and then
> renames it to grub.cfg.
> 
> Fedora/RH systems don't use that at all. They don't use anything from
> upstream GRUB to do updates in fact. The kernel RPM uses
> new-kernel-pkg which in turn calls things like dracut, and eventually
> it has grubby modify the grub.cfg in place. The grubby package has no
> relationship at all with upstream grub. Directly modifying grub.cfg
> and overwriting it seems risky, but I'm pretty sure that's how it
> works.
> 
> 
> > (*) The simple fix for grub to freeze/unfreeze the filesystem rather
> > than/after calling sync() - this does the same thing as remount-ro,
> > but unlike remount-ro it does not fail if there are writable file
> > descriptors open.
> 
> 
> OK. It looks to me like systemd eventually gives up on the remount-ro,
> and then just reboots. That strikes me as a flawed design. Systemd
> needs to wait longer (which is vague advice), or maybe after the 3rd
> failed remount-ro, insert a freeze/unfreeze, then reboot. How does
> that sound?

Sounds supremely fragile and fucked up. Sure, lets add another
layers of hacks to systemd to work around the problem that systemd
can't remount-ro the root filesystem because systemd holds open
write fds on the root fs. Fix the problem that causes open write fds
on the root fs at the end of shutdown? Nah, that's stupid talk -
just hack a bandaid over the top....

And let's also ignore the fact that, in this case, the remount-ro is
effectively working around bootloader updates not providing
durability guarantees.  i.e. the bootloader doesn't do guaranteed
safe updates and requires 3rd party action to provide update
integrity.  The distro update scripts are all different because the
bootloader doesn't provide the necessary update infrastructure the
distros require, and it's extremely naive to expect the developers
of those scripts to understand that they need to provide integrity
guarantees that the bootloader itself doesn't provide.

Really, the bootloader needs fixing, then we can go back to
blissfully ignoring all the stupid bugs in the steaming pile we know
as systemd...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
