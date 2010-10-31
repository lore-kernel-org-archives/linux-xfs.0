Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9V7qv4X115679 for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 02:52:57 -0500
Received: from ucsc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D460C1400F4
	for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 00:54:18 -0700 (PDT)
Received: from ucsc.edu (email-prod-out-1.ucsc.edu [128.114.129.85]) by
	cuda.sgi.com with ESMTP id IzVcRv6dXG45bExQ for
	<xfs@oss.sgi.com>; Sun, 31 Oct 2010 00:54:18 -0700 (PDT)
Received: from [128.114.125.112] (HELO ucsc.edu)
	by email-prod-out-1.ucsc.edu (CommuniGate Pro SMTP 5.2.13)
	with ESMTPS id 25146513 for xfs@oss.sgi.com;
	Sun, 31 Oct 2010 00:54:18 -0700
Received: from [71.198.233.81] (account ermorris@ucsc.edu HELO [10.0.1.4])
	by email-prod-fe-1.ucsc.edu (CommuniGate Pro SMTP 5.2.13)
	with ESMTPSA id 375278665 for xfs@oss.sgi.com;
	Sun, 31 Oct 2010 00:54:13 -0700
From: Eli Morris <ermorris@ucsc.edu>
Subject: xfs_repair of critical volume
Date: Sun, 31 Oct 2010 00:54:13 -0700
Message-Id: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
Mime-Version: 1.0 (Apple Message framework v1081)
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

Hi,

I have a large XFS filesystem (60 TB) that is composed of 5 hardware RAID 6 volumes. One of those volumes had several drives fail in a very short time and we lost that volume. However, four of the volumes seem OK. We are in a worse state because our backup unit failed a week later when four drives simultaneously went offline. So we are in a bad very state. I am able to mount the filesystem that consists of the four remaining volumes. I was thinking about running xfs_repair on the filesystem in hopes it would recover all the files that were not on the bad volume, which are obviously gone. Since our backup is gone, I'm very concerned about doing anything to lose the data that will still have. I ran xfs_repair with the -n flag and I have a lengthly file of things that program would do to our filesystem. I don't have the expertise to decipher the output and figure out if xfs_repair would fix the filesystem in a way that would retain our remaining data or if it would, let's say t!
 runcate the filesystem at the data loss boundary (our lost volume was the middle one of the five volumes), returning 2/5 of the filesystem or some other undesirable result. I would post the xfs_repair -n output here, but it is more than a megabyte. I'm hoping some one of you xfs gurus will take pity on me and let me send you the output to look at or give me an idea as to what they think xfs_repair is likely to do if I should run it or if anyone has any suggestions as to how to get back as much data as possible in this recovery.

thanks very much,

Eli


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
