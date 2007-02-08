Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Feb 2007 16:00:54 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1800hm7015331
	for <xfs@oss.sgi.com>; Wed, 7 Feb 2007 16:00:45 -0800
Message-Id: <200702080000.LAA22767@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: xfs_growfs(?)
Date: Thu, 8 Feb 2007 11:04:14 +1100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.64.0702071431300.29324@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Justin Piszcz' <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com

Hi Justin, 

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Justin Piszcz
> Sent: Thursday, 8 February 2007 6:32 AM
> To: xfs@oss.sgi.com
> Subject: xfs_growfs(?)
> 
> Anyone know the answer to this one?


You can change the sunit/swidth for XFS at any time by modifying the
mount options:

>From the mount(8) man page:

-o sunit=<value>,swidth=<value>

Used to specify the stripe unit and width for a RAID device or a stripe
volume.  value must be specified in 512-byte block units.  If  this
option  is not  specified  and the filesystem was made on a stripe
volume or the stripe width or unit were specified for the RAID device
at  mkfs  time,  then  the mount  system call will restore the value
from the superblock.  For filesystems that are made directly on RAID
devices, these options can  be  used  to override  the  information  in
the superblock if the underlying disk layout changes after the
filesystem  has  been  created.   The  swidth  option  is required  if
the sunit option has been specified, and must be a multiple of the sunit
value.

Barry.
 
> I have wondered the same thing.
> 
> ---------- Forwarded message ----------
> Date: Wed, 7 Feb 2007 12:16:55 -0600
> From: "Discussion@SR" <webmaster@storagereview.com>
> To: jpiszcz@lucidpixels.com
> Subject: Topic Subscription Reply Notification ( Discussion@SR )
> 
> jpiszcz,
> 
> poodel has just posted a reply to a topic that you have 
> subscribed to titled "RAID5 fileserver recommendations".
> 
> ----------------------------------------------------------------------
> QUOTE(jpiszcz @ Jan 3 2007, 12:08 PM) [snapback]237616[/snapback]
> 
> Growing the XFS filesystem is a breeze:
> 
> # xfs_growfs /raid5
> 
> 
> -----------------------------
> 
> 
> 
> Just thought of one thing... when you add another disk to the 
> set, doesn't that mess with the XFS parameters. Ideally, they 
> would be tuned to your number of hard disks at creation time, 
> but now they won't be?
> 
> Is there a way to tune the XFS after creation?
> ----------------------------------------------------------------------
> 
> The topic can be found here:
> http://forums.storagereview.net/index.php?showtopic=24099&view
=getnewpost
> 
> 
> 
> If you have configured in your control panel to recieve 
> immediate topic reply notifications, you may receive an
> email for each reply made to this topic.  Otherwise, only 1 
> email is sent per board visit for each subscribed topic.
> This is to limit the amount of mail that is sent to your inbox.
> 
> Unsubscribing:
> --------------
> 
> You can unsubscribe at any time by logging into your control 
> panel and clicking on the "View Subscriptions" link.
> 
> Regards,
> 
> The Discussion@SR team.
> http://forums.storagereview.net/index.php
> 
> 
