Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51524 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753327AbcK3AOo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Nov 2016 19:14:44 -0500
Subject: Re: Fwd: default mount options
References: <583E1488.7090502@tlinx.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6ecda11c-a993-3dd7-5b87-1947506953ff@sandeen.net>
Date: Tue, 29 Nov 2016 18:14:42 -0600
MIME-Version: 1.0
In-Reply-To: <583E1488.7090502@tlinx.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "L.A. Walsh" <xfs@tlinx.org>, linux-xfs@vger.kernel.org

On 11/29/16 5:51 PM, L.A. Walsh wrote:
> 
> Is it possible for the 'mount' man page to be enhanced to show
> what the defaults are?  Or if that's not possible,
> maybe the xfs(5) manpage?

xfs(5) covers xfs mount options now.  AFAIK, defaults are clearly
stated.  Is something missing?

i.e. -

"Barriers are enabled by default."

"For this reason, nodiscard is the default."

"For kernel v3.7 and later, inode64 is the default."

"noikeep is the default."

etc.

If there's something missing, please let us know (or send a patch).

> Also, I'm again "unclear" on barriers.
> 
> The xfs(5) man page says:
> 
> "barrier|nobarrier - Enables/disables the use of block layer write
> barriers... this allows for drive level write caching to be enabled.
> Barriers are enabled by default.
> 
> This seems to say that barriers are enabled.  Does that mean
> the the barriers are implemented in the HW of the disk, or that
> SW adds "barriers" for disks that don't have them implemented in HW?

It means that the xfs "barrier" mount option is enabled by default.  ;)

There is no "barrier implemented in hardware" - having barriers
turned on means that XFS will requeseet block device flushes at
appropriate times to maintain consistency, even with write caching.

> It also says drives may enable write-caching -- but this should
> only be done if they support write barriers.  How is this "decided"?
> I.e is it done "automatically" in HW? in SW? Or should the user "know"?

What this means is that if barriers are enabled, write-caching
on the drive can be safely enabled.

The user should leave barriers on.  Devices which don't need them
should ignore them.

Simplified, if turning barriers /off/ made your workload go faster,
that means you should have left them on in the first place.  If it
didn't, then there was no reason to turn the knob in the first place...

> Is this related to whether or not the drives support "state" over
> power interruptions?  By having non-volatile "write-cache" memory,
> battery-backed cache, or backed by a UPS?  Wouldn't SSD's be
> considers safe for this purpose (because their state is non-volatile?).

I'm not sure there is any universal answer for what SSDs may do
on a power loss, but I think it's certainly common for them to
have a volatile write cache as well.

> I seem to "get" this topic periodically, but after some time passes,
> and upon rereading the associated manpages, I realize I'm not
> real clear which way is what and realize the lack of defaults
> being specified and whether or not SSD's and/or UPS-backed disks
> were safe whether barriers were present or not was still vague.

Just leave the option at the default, and you'll be fine.  There is
rarely, if ever, a reason to change it.

-Eric

> 
> Thanks!
> -linda
