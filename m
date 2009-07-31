Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6VMAg2U175363 for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 17:10:43 -0500
Received: from mail137.messagelabs.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 8AF7E39B732
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 15:11:29 -0700 (PDT)
Received: from mail137.messagelabs.com (mail137.messagelabs.com
	[216.82.249.19]) by cuda.sgi.com with SMTP id ZzQhRXMNXuPu3Ngo
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 15:11:29 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: need troubleshooting help to track down a xfsdatad or hardware
	problem
Date: Fri, 31 Jul 2009 15:10:55 -0700
Message-ID: <46F2C60C4F4D4F4687C6DFCE5DC4630D01CF579A@CA-EVS02.pelco.org>
In-Reply-To: <alpine.DEB.1.10.0907311433270.28013@asgard.lang.hm>
References: <alpine.DEB.1.10.0907311433270.28013@asgard.lang.hm>
From: "Neff, Bryan" <BNeff@pelco.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: david@lang.hm, xfs@oss.sgi.com

This is an issue with your controller disabling write cache - not an XFS
issue.

If your 3Ware Battery Backup Unit is not working, or is not sufficiently
charged, the controller will disable drive write cache.
Also, if your array is in a degraded state, the controller will disable
write cache.
You can change this behavior by changing the storsave policy.  

-----Original Message-----
From: xfs-bounces@oss.sgi.com [mailto:xfs-bounces@oss.sgi.com] On Behalf
Of david@lang.hm
Sent: Friday, July 31, 2009 2:37 PM
To: xfs@oss.sgi.com
Subject: need troubleshooting help to track down a xfsdatad or hardware
problem

I have 20 identical boxes that have a 16 drive raid 6 array (3ware 
controller), on 17 of the boxes everything seems fine, but on 3 of the 
boxes the xfsdatad process appears to be having problems writing to the 
drive (iostat shows 5MB throughput), and a huge amount of data ends up 
buffered in memory, but cannot get written out to the disk.

what can I do to figure out if the problem is somewhere in software or
in 
hardware (and if hardware, any ideas how to figure out what is happening

on these 3 boxes)

David Lang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

- ------------------------------------------------------------------------------
Confidentiality Notice: The information contained in this transmission is legally privileged and confidential, intended only for the use of the individual(s) or entities named above. This email and any files transmitted with it are the property of Pelco. If the reader of this message is not the intended recipient, or an employee or agent responsible for delivering this message to the intended recipient, you are hereby notified that any review, disclosure, copying, distribution, retention, or any action taken or omitted to be taken in reliance on it is prohibited and may be unlawful. If you receive this communication in error, please notify us immediately by telephone call to +1-559-292-1981 or forward the e-mail to administrator@pelco.com and then permanently delete the e-mail and destroy all soft and hard copies of the message and any attachments. Thank you for your cooperation. 
- ------------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
