Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 16:43:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m75Nh1YC025562
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 16:43:01 -0700
Received: from mars.unix.geek.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 532D4F05BE5
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2008 16:44:15 -0700 (PDT)
Received: from mars.unix.geek.nz ([116.90.133.99]) by cuda.sgi.com with ESMTP id Sq5uSYRJrbOGKSgV for <xfs@oss.sgi.com>; Tue, 05 Aug 2008 16:44:15 -0700 (PDT)
Subject: Re: XFS noikeep remount in 2.6.27-rc1-next-20080730
From: Jasper Bryant-Greene <jasper@amiton.co.nz>
In-Reply-To: <20080805233956.GI21635@disturbed>
References: <1217553598.3860.16.camel@luna.unix.geek.nz>
	 <20080801073033.GF6201@disturbed> <20080801193133.GA838@lst.de>
	 <20080805110357.GL21873@nb.net.home>  <20080805233956.GI21635@disturbed>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 11:44:22 +1200
Message-Id: <1217979862.2887.39.camel@luna.unix.geek.nz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Karel Zak <kzak@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, util-linux-ng@vger.kernel.org

On Wed, 2008-08-06 at 09:39 +1000, Dave Chinner wrote:
> We're seeing the second case where mount is merging all the options in
> /etc/fstab into the options passed into the remount command. How is
> the filesystem expected to behave in these difference cases? The
> first simply changes the ro/rw status, the second potentially
> asks for the filesystem to change a bunch of other mount options
> as well, which it may not be able to do.
> 
> So what is the correct behaviour? Should the filesystem *silently
> ignore* unchangable options in the remount command, or should it
> fail the remount and warn the user that certain options are not
> allowed in remount?

(forgive me, I'm an XFS user, not an XFS developer, so this might be
ignorant)

The filesystem presumably knows what options it was originally mounted
with.

Thus if you take the difference of the set of options you were mounted
with, and the set of options you are now being asked to remount with,
you have the options which are being asked to change.

If changing any of them is unsupported I would expect an error, but in
this case the result of taking the above set difference would be merely
replacing ro with rw, and thus the filesystem is presumably capable of
doing the remount.

-jasper
