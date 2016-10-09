Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:9861 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751072AbcJIVy6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Oct 2016 17:54:58 -0400
Date: Mon, 10 Oct 2016 08:54:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT]
 splice_read reworked)
Message-ID: <20161009215454.GM9806@dastard>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <874538236.682217.1475693824077.JavaMail.zimbra@redhat.com>
 <20161005200522.GE19539@ZenIV.linux.org.uk>
 <119370333.805584.1475756417736.JavaMail.zimbra@redhat.com>
 <1860793605.807021.1475756759147.JavaMail.zimbra@redhat.com>
 <20161007070838.GA16260@quack2.suse.cz>
 <1720038662.1062048.1475851398433.JavaMail.zimbra@redhat.com>
 <1267347639.1072505.1475854075552.JavaMail.zimbra@redhat.com>
 <1337864351.1107846.1475866582573.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337864351.1107846.1475866582573.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: CAI Qian <caiqian@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, tj <tj@kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>

On Fri, Oct 07, 2016 at 02:56:22PM -0400, CAI Qian wrote:
> 
> 
> ----- Original Message -----
> > From: "CAI Qian" <caiqian@redhat.com>
> > To: "Jan Kara" <jack@suse.cz>, "Miklos Szeredi" <miklos@szeredi.hu>, "tj" <tj@kernel.org>, "Al Viro"
> > <viro@ZenIV.linux.org.uk>, "Linus Torvalds" <torvalds@linux-foundation.org>, "Dave Chinner" <david@fromorbit.com>
> > Cc: "linux-xfs" <linux-xfs@vger.kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "Nick Piggin" <npiggin@gmail.com>,
> > linux-fsdevel@vger.kernel.org, "Dave Jones" <davej@codemonkey.org.uk>
> > Sent: Friday, October 7, 2016 11:27:55 AM
> > Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT] splice_read reworked)
> > 
> > 
> > 
> > > Hmm, this round of trinity triggered a different hang.
> > This hang is reproducible so far with the command below on a overlayfs/xfs,
> Another data point is that this hang can also be reproduced using device-mapper thinp
> as the docker backend.

Again, no evidence that the system is actually hung. Waiting on
locks, yes, but nothing to indicate there is a deadlock in those
waiters.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
