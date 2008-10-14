Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Oct 2008 19:03:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9E236Be007806
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 19:03:09 -0700
Received: from mailgw2a.lmco.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 12CC413F2363
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 19:04:41 -0700 (PDT)
Received: from mailgw2a.lmco.com (mailgw2a.lmco.com [192.91.147.7]) by cuda.sgi.com with ESMTP id GSsBXCJbQwM0kbHR for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 19:04:41 -0700 (PDT)
Date: Mon, 13 Oct 2008 22:04:27 -0400
From: "Ngo, Andrew" <andrew.ngo@lmco.com>
Subject: RE: Stale XFS mount for Kernel 2.6.25.14
In-reply-to: <8604545CB7815D419F5FF108D3E434BA3BD628@emss04m05.us.lmco.com>
Message-id: <8604545CB7815D419F5FF108D3E434BA3BD62F@emss04m05.us.lmco.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-class: urn:content-classes:message
References: <8604545CB7815D419F5FF108D3E434BA3BD626@emss04m05.us.lmco.com> <20081013035939.GB10716@disturbed>
 <8604545CB7815D419F5FF108D3E434BA3BD628@emss04m05.us.lmco.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, v9fs-developer@lists.sourceforge.net
Cc: xfs@oss.sgi.com, "Johnson, Je" <je.johnson@lmco.com>, "Ngo, Andrew" <andrew.ngo@lmco.com>


Dave,

Do you know of a solution to this problem?  Currently this is a major
impact for my system.  Thanks in advance.

Andy Ngo

-----Original Message-----
From: Ngo, Andrew 
Sent: Monday, October 13, 2008 8:07 AM
To: 'Dave Chinner'
Cc: xfs@oss.sgi.com; Johnson, Je; Ngo, Andrew
Subject: RE: Stale XFS mount for Kernel 2.6.25.14

No.  There is no oops in the /var/log/messages when the mount command
hangs.

Andy Ngo 

-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com]
Sent: Monday, October 13, 2008 12:00 AM
To: Ngo, Andrew
Cc: xfs@oss.sgi.com; Johnson, Je
Subject: Re: Stale XFS mount for Kernel 2.6.25.14

On Sun, Oct 12, 2008 at 10:10:54PM -0400, Ngo, Andrew wrote:
> Hi,
>  
> This is my first attempt to report a stale mount problem.  If this is 
> not the relevant mail list, please let me know.  I suspect that my 
> problem is xfs related, thus I select this mailing list.
>  
> I have a system that recently upgraded it's kernel to 2.6.25.14.  The 
> system's previous kernel was 2.6.18.-8.el5.  With the previous kernel,

> I have no problem with executing the following commands when the 
> system is in operation.  Note that the /mnt/mountpoint is mounted on a

> XFS file system.
>  
> mount -o rw,remount /mnt/mountpoint
> mount -o ro,remount /mnt/mountpoint
>  
> With kernel 2.6.25.14, however, the mount command may be hang when 
> changing from rw to ro.  When this happen, system is very sluggish.

That's because the remount,ro is actually flushing all the dirty data to
disk in 2.6.25. There is also a check to catch when the remount,ro fails
to clean everything that is dirty - that's probably what is triggering.
Do you have an oops in the dmesg log when mount hangs?

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com
