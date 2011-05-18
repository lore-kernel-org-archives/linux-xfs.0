Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4IKwlmL260816 for <xfs@oss.sgi.com>; Wed, 18 May 2011 15:58:47 -0500
Received: from e5.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C18921652A6A
	for <xfs@oss.sgi.com>; Wed, 18 May 2011 13:58:45 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145]) by
	cuda.sgi.com with ESMTP id 7geHCiwlVSqCWimN for
	<xfs@oss.sgi.com>; Wed, 18 May 2011 13:58:45 -0700 (PDT)
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4IKVjNQ029422
	for <xfs@oss.sgi.com>; Wed, 18 May 2011 16:31:45 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p4IKwbNJ741604 for <xfs@oss.sgi.com>; Wed, 18 May 2011 16:58:38 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p4IKwalR003429 for <xfs@oss.sgi.com>; Wed, 18 May 2011 16:58:36 -0400
Message-ID: <4DD432F6.7010308@linux.vnet.ibm.com>
Date: Wed, 18 May 2011 13:58:30 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: XFS Tests Punch Hole v3 Change Summary
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
To: xfs-oss <xfs@oss.sgi.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

Hi All,

Here is v3 for XFS Tests Punch Hole.  The first patch for fsx has not 
changed, but I've added another test (test number 254).  This test is 
based off the scripts that I used to test and develop punch hole for 
ext4.  It is not done yet, but I am sending it anyway because I need 
feed back.  Right now the test works for ext4, but if I run it on xfs, 
it fails, and Im not sure if it is because it found a bug in xfs, or if 
the test is just too ext4 specific.

The test runs through various corner cases, and each time a hole is 
punched, the file is analyzed to make sure the punch was successful. 
This includes looking at the number of free/used blocks and making sure 
the correct number of blocks are released.  It also looks at the 
filefrag to make sure there are no extents where the new hole is.

The failure happens on the test that punches out the last two blocks of 
a 10 block file.  The test shows that one extra block is released.  But 
may be this is because the block accounting for xfs is different?  I 
looked at the filefrag after the test, and I noticed that there appears 
to be an extra extent after the file.  So that made me think that maybe 
there is a problem going on.

If I modify the test to stop where it fails on the xfs file system , I 
can get the filefrag as it appears on the ext4 file system:
Filesystem type is: ef53
File size of /mnt/ext4MntPt2/254.11546 is 40960 (10 blocks, blocksize 4096)
  ext logical physical expected length flags
    0       0    32850               8
/mnt/ext4MntPt2/254.11546: 1 extent found

on the xfs filesystem, it looks like this:
Filesystem type is: 58465342
File size of /mnt/ext4MntPt2/254.5916 is 40960 (10 blocks, blocksize 4096)
  ext logical physical expected length flags
    0       0       28               8
    1      11       39       35      5 eof
/mnt/ext4MntPt2/254.5916: 2 extents found

Can someone help me figure out if I need to change my test, or if I need 
to report an xfs bug?  Thx!

Allison Henderson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
