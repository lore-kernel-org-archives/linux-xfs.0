Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p195lgUK190014 for <xfs@oss.sgi.com>; Tue, 8 Feb 2011 23:47:42 -0600
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 034E11A72CBF
	for <xfs@oss.sgi.com>; Tue,  8 Feb 2011 21:50:15 -0800 (PST)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	Vf9mdP7qz4ev83Ug for <xfs@oss.sgi.com>;
	Tue, 08 Feb 2011 21:50:15 -0800 (PST)
Received: by iyj8 with SMTP id 8so4462817iyj.26
	for <xfs@oss.sgi.com>; Tue, 08 Feb 2011 21:50:15 -0800 (PST)
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 9 Feb 2011 00:49:54 -0500
Message-ID: <AANLkTi=sp8w3F=x7LteBMx6hzZY6+smQQsO=YQSA3KRd@mail.gmail.com>
Subject: xfssyncd keeps disks awake
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

I have an XFS filesystem on RAID5 (actually XFS on LVM on dm-crypt on
RAID5, but I doubt that matters).  Every few seconds, xfssyncd writes
something, so my disks never spin down.  As far as I can tell, there
is nothing at all accessing that partition.  (I can even unmount it.)

block_dump shows things like this:

xfssyncd/dm-4(957): WRITE block 1181327312 on dm-4 (2 sectors)
md1_raid5(842): WRITE block 0 on sda2 (2 sectors)
md1_raid5(842): WRITE block 0 on sdb2 (2 sectors)
md1_raid5(842): WRITE block 0 on sdc2 (2 sectors)
md1_raid5(842): WRITE block 0 on sda2 (2 sectors)
md1_raid5(842): WRITE block 0 on sdb2 (2 sectors)
md1_raid5(842): WRITE block 0 on sdc2 (2 sectors)
xfssyncd/dm-4(957): WRITE block 1181327314 on dm-4 (2 sectors)
md1_raid5(842): WRITE block 0 on sda2 (2 sectors)
md1_raid5(842): WRITE block 0 on sdb2 (2 sectors)
md1_raid5(842): WRITE block 0 on sdc2 (2 sectors)
md1_raid5(842): WRITE block 0 on sda2 (2 sectors)
md1_raid5(842): WRITE block 0 on sdb2 (2 sectors)
md1_raid5(842): WRITE block 0 on sdc2 (2 sectors)

I have this problem on Fedora's 2.6.35 and on kernel.org's 2.6.37.  Any ideas?

--Andy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
