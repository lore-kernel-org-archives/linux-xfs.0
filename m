Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 13:24:14 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8EKO94p015841
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 13:24:11 -0700
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1IWHRM-0005t8-Kk
	for linux-xfs@oss.sgi.com; Fri, 14 Sep 2007 13:07:00 -0700
Message-ID: <12682767.post@talk.nabble.com>
Date: Fri, 14 Sep 2007 13:07:00 -0700 (PDT)
From: Hxsrmeng <hxsrmeng@gmail.com>
Subject: Newbie question about xfs_db with the response message "unexpected
 XFS SB magic number 0x2e524d46"
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


OpenSUSE10.2. and 2.6.22-rc7-default XFS
1)
I'd like to run "xfs_db -f -c "sb 0" -c "p" ./myfile | egrep
'agcount|inopblog|agblklog'" to see the three values.
I mounted my xfs_disk.
Then I run : 
               xfs_db -f -c "sb 0" -c "p" ./loop | egrep
'agcount|inopblog|agblklog'
It said:
               xfs_db: unexpected XFS SB magic number 0x2e524d46
               Floating point exception
I don't know what the problem is.
But if I umount my xfs_disk, 
Then I run 
              xfs_db {my_xfs_device}
              xfs_db>sb
              xfs_db>p
It's OK.But I can not see things about ./myfile now, since my xfs_disk is
umounted.
2)
I have to umount my xfs_disk before I use xfs_db, correct?
3)
If I want to read the inode content of a file, say, myfile, I should 
"ls -li myfile" to get the inode number of myfile
Then 
"xfs_db> inode <inode number>" to read the content of inode
Is what I said correct?
Thanks in advance.



-- 
View this message in context: http://www.nabble.com/Newbie-question-about-xfs_db-with-the-response-message-%22unexpected-XFS-SB-magic-number-0x2e524d46%22-tf4444973.html#a12682767
Sent from the linux-xfs mailing list archive at Nabble.com.
