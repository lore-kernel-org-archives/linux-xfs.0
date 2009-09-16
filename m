Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8GAQA90039632 for <xfs@oss.sgi.com>; Wed, 16 Sep 2009 05:26:10 -0500
Received: from ey-out-1920.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D18084572B7
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2009 03:27:22 -0700 (PDT)
Received: from ey-out-1920.google.com (ey-out-1920.google.com [74.125.78.145])
	by cuda.sgi.com with ESMTP id FEikxcqGbyMG96UD for
	<xfs@oss.sgi.com>; Wed, 16 Sep 2009 03:27:22 -0700 (PDT)
Received: by ey-out-1920.google.com with SMTP id 5so881567eyb.22
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2009 03:27:22 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 16 Sep 2009 12:27:21 +0200
Message-ID: <89c4f90c0909160327l1a1fdaa2g131cd7fa249ad529@mail.gmail.com>
Subject: 2.6.31 xfs_fs_destroy_inode: cannot reclaim
From: Tommy van Leeuwen <tommy@news-service.com>
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

Hello All,

We had this error reported on the list about 1 or 2 months ago. During
that time a lot of fixes were applied. However, we still experience
this problem with the recent 2.6.31 tree. We've also applied an extra
log entry to aid in debugging.

printk("XFS: inode_init_always failed to re-initialize inode\n");

However, we didn't see this logging!

Here's a screenshot of our latest crash:
http://www.news-service.com/tmp/sb06-20090916.jpg

Here's the config used just in case:
http://www.news-service.com/tmp/config-2.6.31.txt

For now we've downgraded to 2.6.28 again. Please let me know if we can
do something to better troubleshoot this. We have a set of 8 servers
which can easily reproduce this. It mostly happens within a few days
after a clean reboot.

Kind Regards,
Tommy van Leeuwen

-- 
**Warning** New Addres from May 25th, 2009!
News-Service.com - European Usenet Provider
Pobox 12026, 1100 AA Amsterdam, Netherlands
http://www.news-service.com - +3120-3981111

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
