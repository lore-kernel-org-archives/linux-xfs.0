Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n02IabgY021743 for <xfs@oss.sgi.com>; Fri, 2 Jan 2009 12:36:39 -0600
Received: from web30802.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id CDE0B1BFA36F
	for <xfs@oss.sgi.com>; Fri,  2 Jan 2009 10:36:35 -0800 (PST)
Received: from web30802.mail.mud.yahoo.com (web30802.mail.mud.yahoo.com
	[68.142.200.145]) by cuda.sgi.com with SMTP id YxQdfmq63OGW50K4
	for <xfs@oss.sgi.com>; Fri, 02 Jan 2009 10:36:35 -0800 (PST)
Date: Fri, 2 Jan 2009 10:36:34 -0800 (PST)
From: Mike Myers <mikesm559@yahoo.com>
Subject: Recovering XFS data froma  RAID failure
MIME-Version: 1.0
Message-ID: <703541.49128.qm@web30802.mail.mud.yahoo.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs@oss.sgi.com

Hello everyone. I seem to have run into a spate of bad luck on New Year's day morning, and would love some assistance.

I have (had) a 12 TB XFS filesystem running on top of a single LVM volume running on top of 2 7 TB software RAID5 sets (this is under opensuse 11.0).  One of the RAID5 sets suffered a disk fault that had it go into degraded mode, and then suffered another disk fault while trying to restripe a new disk and a hardware SATA controller fault that occured all at the same time. Yes, I know the odds of this happening, and I am trying to discern what grevious sin I have committed to warrant this sort of treament.  I don't even work on Wall Street!

Anyways, I have a new SATA controller online and the disks are now talking to the system again, and I am working hard to try and salvage the array, but it looks pretty likely that RAID set may not be recoverable.  About 9 TB of data was present in the XFS volume, and the 2nd  7 TB RAID5 volume is working just fine.  I was wondering if there was any way to salvage data from the XFS volume so that any files who are intact on the half of the volume that is still there could be recovered?

I'm not trying to get back data that was rm'd, but if I can't recover one of the RAID5 volumes, it would be good to try and pull things off whatever is left.

Any ideas for me?

Thx
mike


      

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
