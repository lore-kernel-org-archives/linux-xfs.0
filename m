Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 17:52:51 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m760qiAZ032043
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 17:52:45 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A935D198F977
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2008 17:53:57 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id LCSDpqHvoprOn7t0 for <xfs@oss.sgi.com>; Tue, 05 Aug 2008 17:53:57 -0700 (PDT)
Date: Wed, 6 Aug 2008 10:53:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS noikeep remount in 2.6.27-rc1-next-20080730
Message-ID: <20080806005354.GL21635@disturbed>
References: <1217553598.3860.16.camel@luna.unix.geek.nz> <20080801073033.GF6201@disturbed> <20080801193133.GA838@lst.de> <20080805110357.GL21873@nb.net.home> <20080805233956.GI21635@disturbed> <1217979862.2887.39.camel@luna.unix.geek.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217979862.2887.39.camel@luna.unix.geek.nz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jasper Bryant-Greene <jasper@amiton.co.nz>
Cc: Karel Zak <kzak@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, util-linux-ng@vger.kernel.org

On Wed, Aug 06, 2008 at 11:44:22AM +1200, Jasper Bryant-Greene wrote:
> On Wed, 2008-08-06 at 09:39 +1000, Dave Chinner wrote:
> > We're seeing the second case where mount is merging all the options in
> > /etc/fstab into the options passed into the remount command. How is
> > the filesystem expected to behave in these difference cases? The
> > first simply changes the ro/rw status, the second potentially
> > asks for the filesystem to change a bunch of other mount options
> > as well, which it may not be able to do.
> > 
> > So what is the correct behaviour? Should the filesystem *silently
> > ignore* unchangable options in the remount command, or should it
> > fail the remount and warn the user that certain options are not
> > allowed in remount?
> 
> (forgive me, I'm an XFS user, not an XFS developer, so this might be
> ignorant)
> 
> The filesystem presumably knows what options it was originally mounted
> with.
> 
> Thus if you take the difference of the set of options you were mounted
> with, and the set of options you are now being asked to remount with,
> you have the options which are being asked to change.

Sure. But that does not answer my question about what to do with
options that can't be changed. Options can come from more than just
/etc/fstab - they can come from the mount command line itself as
entered by the admin. What do we do if an option is specified that
we do not support in a remount?

The problem is the way mount combines command line options with
options in fstab. I'm not questioning what you did - I'm asking what
the expected behaviour is supposed to be so we can make it behave
the same way as all the other filesystems.

> If changing any of them is unsupported I would expect an error, but in
> this case the result of taking the above set difference would be merely
> replacing ro with rw, and thus the filesystem is presumably capable of
> doing the remount.

Use the full device/directory syntax for the remount command and it
will do just that. The command you issued was not a "pure" remount,rw,
it was silently changed by mount....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
