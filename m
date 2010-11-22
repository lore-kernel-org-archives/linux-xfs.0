Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAMLwF0X113886 for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 15:58:15 -0600
Received: from ssec.wisc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B01711C675FD
	for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 13:59:52 -0800 (PST)
Received: from ssec.wisc.edu (mahogany.ssec.wisc.edu [128.104.110.2]) by
	cuda.sgi.com with ESMTP id WKHGOWsgm3UMoQ0i for
	<xfs@oss.sgi.com>; Mon, 22 Nov 2010 13:59:52 -0800 (PST)
Received: from arthur.ssec.wisc.edu (account jstroik@ssec.wisc.edu
	[128.104.111.93] verified)
	by ssec.wisc.edu (CommuniGate Pro SMTP 5.3.9)
	with ESMTPSA id 52365420 for xfs@oss.sgi.com;
	Mon, 22 Nov 2010 15:59:52 -0600
Message-ID: <4CEAE7D7.6050401@ssec.wisc.edu>
Date: Mon, 22 Nov 2010 15:59:51 -0600
From: Jesse Stroik <jstroik@ssec.wisc.edu>
MIME-Version: 1.0
Subject: Improving XFS file system inode performance
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
To: Linux XFS <xfs@oss.sgi.com>

XFS community,

I have a couple of medium-sized file systems on an ftp server (10TB file 
system mounted within a 20TB file system).  The load on these file 
systems is getting pretty high because we have many users mirroring 
datasets from the server.  As far as I can tell, the main issue is with 
inode performance.  For example, an 'ls' on a directory may take 20 
seconds to complete.  At any given time, there is > 50 ftp STAT, LIST or 
NLST commands some of which list entire directories or wildcards.

Sadly, the file system was created with 32 bit inodes.  I've remounted 
it with the inode64 option, but I assume performance will be boosted 
primarily when old files are replaced with new files.  Is there anything 
I can do to improve performance now?

I'm also using noatime and logbufs=8.

Performance was fine before the file system was filled -- last week ~8TB 
showed up and filled the 20TB file system.  Since, it has been 
performing poorly.

I'd also be interested in inode cache tuning options specific to XFS. 
i've been having trouble finding documentation on this particular issue.

This is a production file system so please frame your suggestions with 
respect to that.  It is a RHEL 5.5 system running xfsprogs-2.9.4.1 
centos and redhat kernel version 2.6.18-194.17.1 which includes a 
variety of backported xfs fixes.

Best,
Jesse

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
