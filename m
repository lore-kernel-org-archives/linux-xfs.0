Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:25299 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751743AbcJJWgm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 18:36:42 -0400
Date: Tue, 11 Oct 2016 08:57:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT]
 splice_read reworked)
Message-ID: <20161010215714.GF23194@dastard>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <119370333.805584.1475756417736.JavaMail.zimbra@redhat.com>
 <1860793605.807021.1475756759147.JavaMail.zimbra@redhat.com>
 <20161007070838.GA16260@quack2.suse.cz>
 <1720038662.1062048.1475851398433.JavaMail.zimbra@redhat.com>
 <1267347639.1072505.1475854075552.JavaMail.zimbra@redhat.com>
 <1337864351.1107846.1475866582573.JavaMail.zimbra@redhat.com>
 <20161009215454.GM9806@dastard>
 <988281682.41395.1476108629872.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <988281682.41395.1476108629872.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: CAI Qian <caiqian@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, tj <tj@kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>

On Mon, Oct 10, 2016 at 10:10:29AM -0400, CAI Qian wrote:
> 
> 
> ----- Original Message -----
> > From: "Dave Chinner" <david@fromorbit.com>
> > To: "CAI Qian" <caiqian@redhat.com>
> > Cc: "Jan Kara" <jack@suse.cz>, "Miklos Szeredi" <miklos@szeredi.hu>, "tj" <tj@kernel.org>, "Al Viro"
> > <viro@ZenIV.linux.org.uk>, "Linus Torvalds" <torvalds@linux-foundation.org>, "linux-xfs"
> > <linux-xfs@vger.kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "Nick Piggin" <npiggin@gmail.com>,
> > linux-fsdevel@vger.kernel.org, "Dave Jones" <davej@codemonkey.org.uk>
> > Sent: Sunday, October 9, 2016 5:54:55 PM
> > Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT] splice_read reworked)
> > 
> > Again, no evidence that the system is actually hung. Waiting on
> > locks, yes, but nothing to indicate there is a deadlock in those
> > waiters.
> Here you are,
> 
> http://people.redhat.com/qcai/tmp/dmesg

It's a page lock order bug in the XFS seek hole/data implementation.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
