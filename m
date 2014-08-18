Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 631367F54
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2014 22:29:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 42F318F8037
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2014 20:29:26 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id Cu3E0fiuYkI5IsMQ
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2014 20:29:22 -0700 (PDT)
Subject: inode64 directory placement determinism
MIME-Version: 1.0
Date: Sun, 17 Aug 2014 22:29:21 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
Message-ID: <e1eeba7b0fb97c63e41f40ed9ac162d7@localhost>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Say I have a single 4TB disk in an md linear device.  The md device has a
filesystem on it formatted with defaults.  It has 4 AGs, 0-3.  I have
created 4 directories.  Each should reside in a different AG, the first in
AG0.  Now I expand the linear device with an identical 4TB disk and execute
xfs_growfs.  I now have 4 more AGs, 4-7.  I create 4 more directories.

Will these 4 new dirs be created sequentially in AGs 4-7, or in the first
4 AGs?  Is this deterministic, or is there any chance involved?  On the
real system these 4TB drives are actually 48TB LUNs.  I'm after
deterministic parallel bandwidth to subsequently added RAIDs after each
grow operation by simply writing to the proper directory.

Currently we have kernel 3.4.26 to work with if that's relevant.  I may be
able to get the kernel team to go for 3.4.103 for the bugfixes, but I don't
know about anything newer.  This is an embedded type development process.

Thanks,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
