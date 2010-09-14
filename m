Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8E4T08E105867 for <xfs@oss.sgi.com>; Mon, 13 Sep 2010 23:29:01 -0500
Received: from kuber.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 286126EEC4
	for <xfs@oss.sgi.com>; Mon, 13 Sep 2010 21:29:48 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158]) by
	cuda.sgi.com with ESMTP id 00lDAsCoDO2uxBJT for
	<xfs@oss.sgi.com>; Mon, 13 Sep 2010 21:29:48 -0700 (PDT)
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>) id 1OvN9Q-0000KY-7a
	for xfs@oss.sgi.com; Mon, 13 Sep 2010 21:29:48 -0700
Message-ID: <29705139.post@talk.nabble.com>
Date: Mon, 13 Sep 2010 21:29:48 -0700 (PDT)
From: pbrunnen <PBrunnen@bccnetworks.net>
Subject: Re: XFS Filesystem not mounting
In-Reply-To: <20100914012151.GF411@dastard>
MIME-Version: 1.0
References: <29704010.post@talk.nabble.com> <20100914012151.GF411@dastard>
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
To: xfs@oss.sgi.com


Hi Dave,


> What kernel version is that?
1.6.18.2-34-smp 32bit PAE

> What sort of hardware is it on? (raid controller, raid level, etc)
Hardware looks good...  Its an LSI MegaRaid (PERC 5/E) SAS controller.  The
RAID 6 passes all the hardware diags, no failed disks, and latest firmware.

The other xfs volumes on the array are fine, btw.

> There's a good chance your storage is in a bad state. Can you send the
> output
> of "echo w > /proc/sysrq-trigger" when the system is hung?

Working on that...
Just copying the data off from the norecovery mount.  Will let you know what
i find when its done copying.


FYI... I noticed a typo in my original post.
"xfs_df -i -p xfs_check -c check /dev/sdd1"
...should actually read...
"xfs_db -i -p xfs_check -c check /dev/sdd1"


Thanks so much for your help!
-Cheers, Peter.

-- 
View this message in context: http://old.nabble.com/XFS-Filesystem-not-mounting-tp29704010p29705139.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
