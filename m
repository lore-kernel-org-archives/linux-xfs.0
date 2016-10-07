Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:52510 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752300AbcJGJ10 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Oct 2016 05:27:26 -0400
Date: Fri, 7 Oct 2016 20:27:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT]
 splice_read reworked)
Message-ID: <20161007092704.GH9806@dastard>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <1812816839.401734.1475602751170.JavaMail.zimbra@redhat.com>
 <20161004214219.GN4205@htj.duckdns.org>
 <1238277728.610186.1475676579513.JavaMail.zimbra@redhat.com>
 <20161005153014.GC26977@htj.duckdns.org>
 <270577901.647921.1475682888765.JavaMail.zimbra@redhat.com>
 <874538236.682217.1475693824077.JavaMail.zimbra@redhat.com>
 <20161005200522.GE19539@ZenIV.linux.org.uk>
 <119370333.805584.1475756417736.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <119370333.805584.1475756417736.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: CAI Qian <caiqian@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, tj <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org

On Thu, Oct 06, 2016 at 08:20:17AM -0400, CAI Qian wrote:
> 
> 
> ----- Original Message -----
> > From: "Al Viro" <viro@ZenIV.linux.org.uk>
> > To: "CAI Qian" <caiqian@redhat.com>
> > Cc: "tj" <tj@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>, "Dave Chinner" <david@fromorbit.com>,
> > "linux-xfs" <linux-xfs@vger.kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "Nick Piggin" <npiggin@gmail.com>,
> > linux-fsdevel@vger.kernel.org
> > Sent: Wednesday, October 5, 2016 4:05:22 PM
> > Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT] splice_read reworked)
> > 
> > On Wed, Oct 05, 2016 at 02:57:04PM -0400, CAI Qian wrote:
> > 
> > > Not sure if this related, and there is always a lockdep regards procfs
> > > happened
> > > below unless masking by other lockdep issues before the cgroup hang. Also,
> > > this
> > > hang is always reproducible.
> > 
> > Sigh...  Let's get the /proc/*/auxv out of the way - this should deal with
> > it:
> So I applied both this and the sanity patch, and both original sanity and the
> proc warnings went away. However, the cgroup hang can still be reproduced as
> well as this new xfs internal error below,
> 
> [16921.141233] XFS (dm-0): Internal error XFS_WANT_CORRUPTED_RETURN at line 5619 of file fs/xfs/libxfs/xfs_bmap.c.  Caller xfs_bmap_shift_extents+0x1cc/0x3a0 [xfs]
> [16921.157694] CPU: 9 PID: 52920 Comm: trinity-c108 Not tainted 4.8.0-rc8-splice-fixw-proc+ #4

iIt found a delayed allocation extent in the extent map after
flushing all the dirty data in the file. Something else has gone
wrong, this corruption detection is just the messenger. Maybe
memory corruption?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
