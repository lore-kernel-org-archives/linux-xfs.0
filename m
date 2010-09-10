Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8AEeg9O152762 for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 09:40:43 -0500
Received: from mail.kickstone.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E5AB1E634FE
	for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 07:41:27 -0700 (PDT)
Received: from mail.kickstone.com (87-194-183-70.dsl.cnl.uk.net
	[87.194.183.70]) by cuda.sgi.com with ESMTP id fQ2l4NCpLQEjW1xf
	for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 07:41:27 -0700 (PDT)
Received: from 79-69-137-97.dynamic.dsl.as9105.com ([79.69.137.97]:52669
	helo=[192.168.6.15]) by mail.kickstone.com with esmtpa (Exim 4.69)
	(envelope-from <john.lister@kickstone.com>) id 1Ou4Wl-0001wN-BB
	for xfs@oss.sgi.com; Fri, 10 Sep 2010 15:24:31 +0100
Message-ID: <4C8A4395.5070702@kickstone.com>
Date: Fri, 10 Sep 2010 15:41:25 +0100
From: John Lister <john.lister@kickstone.com>
MIME-Version: 1.0
Subject: XFS defragmentation issue
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

  Hi, using ubuntu 9.04, kernel version 2.6.28-18 and xfsprog v2.10.2-1 
I'm trying to defragment a drive. If I use xfs_db to check for 
fragmentation it shows for example that a file has 20k+ fragments:
inode 578505506 actual 23240 ideal 1

mapping the inode to the file and running xfs_frs states that the file 
is fully defragmented.

Also running xfs_frs says the drive is defragmented while xfs_db for 
example reports 300k fragments.

Which is right? and is it possible to defragment the file assuming it is 
fragmented so badly, if so how?

Thanks

John

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
