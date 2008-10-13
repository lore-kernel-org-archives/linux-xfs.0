Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Oct 2008 21:03:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9D43duO022401
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 21:03:39 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9CA414E9047
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 21:05:15 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id Y1d6DVj0TOmXCsjD for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 21:05:15 -0700 (PDT)
Date: Mon, 13 Oct 2008 14:59:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Stale XFS mount for Kernel 2.6.25.14
Message-ID: <20081013035939.GB10716@disturbed>
References: <8604545CB7815D419F5FF108D3E434BA3BD626@emss04m05.us.lmco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8604545CB7815D419F5FF108D3E434BA3BD626@emss04m05.us.lmco.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Ngo, Andrew" <andrew.ngo@lmco.com>
Cc: xfs@oss.sgi.com, "Johnson, Je" <je.johnson@lmco.com>

On Sun, Oct 12, 2008 at 10:10:54PM -0400, Ngo, Andrew wrote:
> Hi,  
>  
> This is my first attempt to report a stale mount problem.  If this is
> not the relevant mail list, please let me know.  I suspect that my
> problem is xfs related, thus I select this mailing list.
>  
> I have a system that recently upgraded it's kernel to 2.6.25.14.  The
> system's previous kernel was 2.6.18.-8.el5.  With the previous kernel, I
> have no problem with executing the following commands when the system is
> in operation.  Note that the /mnt/mountpoint is mounted on a XFS file
> system.
>  
> mount -o rw,remount /mnt/mountpoint
> mount -o ro,remount /mnt/mountpoint
>  
> With kernel 2.6.25.14, however, the mount command may be hang when
> changing from rw to ro.  When this happen, system is very sluggish.

That's because the remount,ro is actually flushing all the dirty
data to disk in 2.6.25. There is also a check to catch when the
remount,ro fails to clean everything that is dirty - that's probably
what is triggering. Do you have an oops in the dmesg log when
mount hangs?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
