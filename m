Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0DLKPG1187337 for <xfs@oss.sgi.com>; Thu, 13 Jan 2011 15:20:26 -0600
Received: from zixvpm02.zixvpm.davisvision.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC0A71D2F21E
	for <xfs@oss.sgi.com>; Thu, 13 Jan 2011 13:22:38 -0800 (PST)
Received: from zixvpm02.zixvpm.davisvision.com
	(zixvpm02.zixvpm.davisvision.com [65.213.99.45]) by
	cuda.sgi.com with ESMTP id JxLEtq4VqiQf7H72 for
	<xfs@oss.sgi.com>; Thu, 13 Jan 2011 13:22:38 -0800 (PST)
Received: from zixvpm02.zixvpm.davisvision.com (ZixVPM [127.0.0.1])
	by Outbound.davisvision.com (Proprietary) with ESMTP id 6B7A05DC014
	for <xfs@oss.sgi.com>; Thu, 13 Jan 2011 16:22:37 -0500 (EST)
Received: from riley.davisvision.com (unknown [10.51.11.112])
	by zixvpm02.zixvpm.davisvision.com (Proprietary) with ESMTP id
	0184B1F4020
	for <xfs@oss.sgi.com>; Thu, 13 Jan 2011 16:22:37 -0500 (EST)
Received: from riley.davisvision.com (localhost [127.0.0.1])
	by localhost (Postfix) with SMTP id E63D42463A
	for <xfs@oss.sgi.com>; Thu, 13 Jan 2011 16:22:36 -0500 (EST)
Received: from [192.168.148.68] (ccoager-linux.davisvision.com
	[192.168.148.68])
	by riley.davisvision.com (Postfix) with ESMTP id C9E4D24637
	for <xfs@oss.sgi.com>; Thu, 13 Jan 2011 16:22:36 -0500 (EST)
Message-ID: <3205_1294953756_4D2F6D1C_3205_1943_1_4D2F6D1C.2060409@davisvision.com>
Date: Thu, 13 Jan 2011 16:22:36 -0500
From: Cory Coager <ccoager@davisvision.com>
MIME-Version: 1.0
Subject: extremely slow write performance plaintext
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
To: xfs@oss.sgi.com

Hardware is 2x 2.6ghz cpu, 6gb RAM, 2 SAS arrays consisting of 24 drives 
in hardware RAID 6, 5.87tb total.  The two arrays were added to a volume 
group and multiple logical volumes were created.  I am getting over 
180MB/s read speeds and 40MB/s write speeds on all the LV's except one. 
  One of the LV's is getting ~1MB/s write speeds, however read speeds 
are fine.  There are NO snapshots.

meta-data=/dev/mapper/vg0-shared isize=1024   agcount=32, 
agsize=17616096 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=563715072, imaxpct=25
          =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# dd if=/dev/zero of=zero bs=1k count=1048576
1048576+0 records in
1048576+0 records out
1073741824 bytes (1.1 GB) copied, 2089.95 seconds, 514 kB/s

# dd if=zero of=/dev/null bs=1k
1048576+0 records in
1048576+0 records out
1073741824 bytes (1.1 GB) copied, 4.70878 seconds, 228 MB/s

Any idea what is wrong with this and how to fix it?



------------------------------------------------------------------------
The information contained in this communication is intended
only for the use of the recipient(s) named above. It may
contain information that is privileged or confidential, and
may be protected by State and/or Federal Regulations. If
the reader of this message is not the intended recipient,
you are hereby notified that any dissemination,
distribution, or copying of this communication, or any of
its contents, is strictly prohibited. If you have received
this communication in error, please return it to the sender
immediately and delete the original message and any copy
of it from your computer system. If you have any questions
concerning this message, please contact the sender.
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
