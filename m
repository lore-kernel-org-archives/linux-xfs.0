Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6PISsEF024647 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 13:28:54 -0500
Received: from b.mail.sonic.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E236124844C
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 11:28:53 -0700 (PDT)
Received: from b.mail.sonic.net (b.mail.sonic.net [64.142.19.5]) by
	cuda.sgi.com with ESMTP id A8DKemsEWC6sPzf7 for
	<xfs@oss.sgi.com>; Mon, 25 Jul 2011 11:28:53 -0700 (PDT)
Received: from localhost.localdomain (wombat.san-francisco.ca.us
	[75.101.60.64])
	by b.mail.sonic.net (8.13.8.Beta0-Sonic/8.13.7) with ESMTP id
	p6PISqXT014612 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 11:28:52 -0700
Date: Mon, 25 Jul 2011 11:28:51 -0700
From: Keith Keller <kkeller@sonic.net>
Subject: Re: xfs_growfs doesn't resize (update)
Message-ID: <20110725182851.GA30626@sonic.net>
References: <20110707182532.GA31319@sonic.net> <4E160A34.20902@sandeen.net>
	<20110707222350.GA776@sonic.net> <4E163396.2010707@sandeen.net>
	<20110720190819.GA14910@sonic.net>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110720190819.GA14910@sonic.net>
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

Hi again all,

I thought about this a bit more over the past few days, and did 
some more testing this morning.  I am currently thinking that I
really don't have as many paths to follow as I originally thought.

It seems like, whether I modify sb 0 with xfs_db or not, xfs_repair
still wants to see an 11TB filesystem--I did an mdrestore and mount
on the metadump image, which saw a 21TB filesystem, then did a umount
and xfs_repair, which modified the superblock.  On mounting again, the
filesystem was back to 11TB.  So I think there must be a definite
risk of data loss if I try to mount what the latest kernel thinks is
a 21TB filesystem, then need to run a repair at a later date, and
therefore I have to run an xfs_repair before trying to use the new
free space.

So, here is what I think is my plan for the actual filesystem:

--take another backup
--umount all XFS filesystems (the OS filesystems are ext3)
--remove the kmod-xfs CentOS package
--update to the latest CentOS kernel and reboot, making sure
  the target XFS fs does not have a mount attempted
--run xfs_repair from xfsprogs-3.1.5
--cross fingers :)
--mount and check what's in lost+found
--if all seems well, attempt another xfs_growfs using xfsprogs-3.1.5

Does this seem like a reasonable plan of attack?  If so, is there
a way to estimate how long the actual xfs_repair will take from my
xfs_repair sessions on the metadump image?  Obviously the hardware
isn't the same, but I'd just hope for a back of the envelope estimate,
not necessarily something terribly accurate.

Finally, are there other things I can try on the metadump image first
to give me more information on what'll happen on the live filesystem?

Thanks again!

--keith

-- 
kkeller@wombat.san-francisco.ca.us

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
