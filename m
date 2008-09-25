Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 16:40:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8PNe1ls002707
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 16:40:01 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F0804853E0
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 16:41:34 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id OpNWT5LEgsV3kmWp for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 16:41:34 -0700 (PDT)
Date: Fri, 26 Sep 2008 09:41:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.27-rc7 no init found on the root partition?
Message-ID: <20080925234130.GD27997@disturbed>
References: <20080924192227.GC31582@ics.muni.cz> <20080924230326.GM5448@disturbed> <20080925111239.GF31582@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080925111239.GF31582@ics.muni.cz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Sep 25, 2008 at 01:12:40PM +0200, Lukas Hejtmanek wrote:
> On Thu, Sep 25, 2008 at 09:03:26AM +1000, Dave Chinner wrote:
> > On Wed, Sep 24, 2008 at 09:22:27PM +0200, Lukas Hejtmanek wrote:
> > > Hello,
> > > 
> > > I have a box that has XFS root partition, I have kernel
> > > 2.6.26.3 that boots pretty well on that box. Today, I've tried
> > > 2.6.27-rc7 (so that I can test NFSv4 over IPv6), but the
> > > kernel is unable to boot. It says that root partition is
> > > mounted, XFS file system but no init found.
> > 
> > Can you paste the error messages or send pointers to screen
> > shots of the error?
> 
> http://undomiel.ics.muni.cz/tmp/IMG_2962.JPG

Hmmm - the filesystem mounted without errors, but init was not
found. Strange.

> this one is if I pass init=/bin/bash
> http://undomiel.ics.muni.cz/tmp/IMG_2961.JPG

Same again, it's unable to run the init process.

Of course, kernel_execve() throws away any error that might
have occurred, so without hacking the init code we can't find out
why it failed.

> > If you go back to 2.6.26.3, does the kernel boot ok?
> 
> indeed.

Ok, is the 2.6.27 kernel based on the same config as the 2.6.26
kernel?

> this is a grub record:
> 
> title Linux 2.6.26.3 root (hd0,0) kernel /boot/vmlinuz-2.6.26.3
> root=/dev/sda1 ro console=tty0
> 
> title Linux 2.6.27-rc7 root (hd0,0) kernel
> /boot/vmlinuz-2.6.27-rc7 root=/dev/sda1 ro 

Does it boot if you take away the "ro" option?

Cheers,

Dave.
> 
> 
> -- Lukáš Hejtmánek
> 
> 
> 

-- 
Dave Chinner
david@fromorbit.com
