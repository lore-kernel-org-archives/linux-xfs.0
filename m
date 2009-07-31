Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6VMJSek175933 for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 17:19:28 -0500
Received: from bifrost.lang.hm (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A407312A9587
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 15:29:19 -0700 (PDT)
Received: from bifrost.lang.hm (mail.lang.hm [64.81.33.126]) by cuda.sgi.com
	with ESMTP id 8DZalvTaVHxFuZHB for <xfs@oss.sgi.com>;
	Fri, 31 Jul 2009 15:29:19 -0700 (PDT)
Date: Fri, 31 Jul 2009 15:20:12 -0700 (PDT)
From: david@lang.hm
Subject: RE: need troubleshooting help to track down a xfsdatad or hardware
	problem
In-Reply-To: <46F2C60C4F4D4F4687C6DFCE5DC4630D01CF579A@CA-EVS02.pelco.org>
Message-ID: <alpine.DEB.1.10.0907311519180.28013@asgard.lang.hm>
References: <alpine.DEB.1.10.0907311433270.28013@asgard.lang.hm>
	<46F2C60C4F4D4F4687C6DFCE5DC4630D01CF579A@CA-EVS02.pelco.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Neff, Bryan" <BNeff@pelco.com>
Cc: xfs@oss.sgi.com

On Fri, 31 Jul 2009, Neff, Bryan wrote:

> This is an issue with your controller disabling write cache - not an XFS
> issue.
>
> If your 3Ware Battery Backup Unit is not working, or is not sufficiently
> charged, the controller will disable drive write cache.
> Also, if your array is in a degraded state, the controller will disable
> write cache.
> You can change this behavior by changing the storsave policy.

thanks, the $#%@#$ vendor shipped all 20 systems without battery backup, 
and apparently couldn't even configure them consistantly.

David Lang

> -----Original Message-----
> From: xfs-bounces@oss.sgi.com [mailto:xfs-bounces@oss.sgi.com] On Behalf
> Of david@lang.hm
> Sent: Friday, July 31, 2009 2:37 PM
> To: xfs@oss.sgi.com
> Subject: need troubleshooting help to track down a xfsdatad or hardware
> problem
>
> I have 20 identical boxes that have a 16 drive raid 6 array (3ware
> controller), on 17 of the boxes everything seems fine, but on 3 of the
> boxes the xfsdatad process appears to be having problems writing to the
> drive (iostat shows 5MB throughput), and a huge amount of data ends up
> buffered in memory, but cannot get written out to the disk.
>
> what can I do to figure out if the problem is somewhere in software or
> in
> hardware (and if hardware, any ideas how to figure out what is happening
>
> on these 3 boxes)
>
> David Lang
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>
> - ------------------------------------------------------------------------------
> Confidentiality Notice: The information contained in this transmission is legally privileged and confidential, intended only for the use of the individual(s) or entities named above. This email and any files transmitted with it are the property of Pelco. If the reader of this message is not the intended recipient, or an employee or agent responsible for delivering this message to the intended recipient, you are hereby notified that any review, disclosure, copying, distribution, retention, or any action taken or omitted to be taken in reliance on it is prohibited and may be unlawful. If you receive this communication in error, please notify us immediately by telephone call to +1-559-292-1981 or forward the e-mail to administrator@pelco.com and then permanently delete the e-mail and destroy all soft and hard copies of the message and any attachments. Thank you for your cooperation.
> - ------------------------------------------------------------------------------
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
