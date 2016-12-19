Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from forward2.bravehost.com ([65.39.211.66]:35116 "EHLO
        forward2.bravehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751171AbcLSBK1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2016 20:10:27 -0500
Received: from webmail.bravehost.com (unknown [172.16.0.199])
        (Authenticated sender: ncoulson-ml@ncoulson.com)
        by forward2.bravehost.com (Postfix) with ESMTPA id E8119DE9
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2016 17:03:47 -0800 (PST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 18 Dec 2016 17:03:47 -0800
From: ncoulson-ml@ncoulson.com
Subject: Switching from group to project quota's
Message-ID: <8f374ce3da8517c472b897b07ec28517@ncoulson.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We are currently using user and group quota's on multiple xfs 
filesystem.  When trying to switch to Project Quota's, it attempts to 
perform a quotacheck.

Tested on a lvm snapshot of a live volume,  it was still not mounted 
after about a week (and couldn't find a way to cancel the attempted 
mount.  dmesg did mention quotacheck, but I can't say it was doing the 
quotacheck for the full week).

Is there a way to convert from Group Quota's to Project Quota's while 
avoiding the quotacheck?  (There are currently no project quota's 
defined).  Outside of that, I was curious what scenario's would cause 
quotacalc to recalculate.

Thank You



1TB Volumes, Reviewing one of them, we are using 67G of 934GB (they vary 
from 400GB free to 50GB Free).

Inode usage seems to range from 5000000 to 8000000.

Using the 2.6.32 kernel from Centos 6.8, but was doing my tests with a 
snapshot of the volume on a centos 7.2 host (kernel 3.10)

I thought I may be able to work around this by removing the group quota 
information,  but xfs_quota -x, remove -g with and without group quota's 
on failed to work.    Everytime I received XFS_QUOTARM: Invalid argument


User quota state on /test (/dev/sda)
   Accounting: ON
   Enforcement: OFF
   Inode: #131 (1663 blocks, 1639 extents)
Group quota state on /test (/dev/sda)
   Accounting: ON
   Enforcement: OFF
   Inode: #132 (1664 blocks, 1648 extents)
Project quota state on /test (/dev/sda)
   Accounting: OFF
   Enforcement: OFF
   Inode: #132 (1664 blocks, 1648 extents)
Blocks grace time: [7 days 00:00:30]
Inodes grace time: [7 days 00:00:30]
Realtime Blocks grace time: [7 days 00:00:30]


Nathan Coulson.
