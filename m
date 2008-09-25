Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 04:10:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8PBAo8a022882
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 04:10:50 -0700
Received: from minas.ics.muni.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 79D9948126A
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 04:12:22 -0700 (PDT)
Received: from minas.ics.muni.cz (minas.ics.muni.cz [147.251.4.40]) by cuda.sgi.com with ESMTP id t8cIHACEZAELx8hQ for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 04:12:22 -0700 (PDT)
Date: Thu, 25 Sep 2008 13:12:40 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: 2.6.27-rc7 no init found on the root partition?
Message-ID: <20080925111239.GF31582@ics.muni.cz>
References: <20080924192227.GC31582@ics.muni.cz> <20080924230326.GM5448@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080924230326.GM5448@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Sep 25, 2008 at 09:03:26AM +1000, Dave Chinner wrote:
> On Wed, Sep 24, 2008 at 09:22:27PM +0200, Lukas Hejtmanek wrote:
> > Hello,
> > 
> > I have a box that has XFS root partition, I have kernel 2.6.26.3 that boots
> > pretty well on that box. Today, I've tried 2.6.27-rc7 (so that I can test
> > NFSv4 over IPv6), but the kernel is unable to boot. It says that root
> > partition is mounted, XFS file system but no init found.
> 
> Can you paste the error messages or send pointers to screen shots of
> the error?

http://undomiel.ics.muni.cz/tmp/IMG_2962.JPG

this one is if I pass init=/bin/bash
http://undomiel.ics.muni.cz/tmp/IMG_2961.JPG

> If you go back to 2.6.26.3, does the kernel boot ok?

indeed.


this is a grub record:

title Linux 2.6.26.3
root (hd0,0)
kernel /boot/vmlinuz-2.6.26.3 root=/dev/sda1 ro console=tty0

title Linux 2.6.27-rc7
root (hd0,0)
kernel /boot/vmlinuz-2.6.27-rc7 root=/dev/sda1 ro 


-- 
Luká¹ Hejtmánek
