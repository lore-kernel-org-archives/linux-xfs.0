Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Dec 2007 02:16:38 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBVAGXmT008675
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 02:16:35 -0800
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF23A2C01B0
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 02:16:45 -0800 (PST)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.182]) by cuda.sgi.com with ESMTP id ssXu665mvHyM5Xxp for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 02:16:45 -0800 (PST)
Received: by wa-out-1112.google.com with SMTP id k22so8134817waf.18
        for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 02:16:43 -0800 (PST)
Message-ID: <cdcb615e0712310209t29c2408dt703521c53b93c16d@mail.gmail.com>
Date: Mon, 31 Dec 2007 02:09:36 -0800
From: "Aaron Blew" <aaronblew@gmail.com>
Subject: xfs_repair gone wrong
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

After a recent Debian dist-upgrade on my home server, I finally rebooted the
machine to take advantage of the new kernel that had been installed.
Unfortunately upon reboot, my first md array wasn't coming online
successfully.

I finally rebuilt the md array and got LVM back online (the VG and single LV
are comprised of two 3 disk software RAID-5 arrays, md0 and md1), the
filesystem wouldn't mount, much to my dismay.  xfs_check seemed to segfault,
so I ended up running xfs_repair without the -n option (OOPS), which made
all sorts of changes to the filesystem, leaving me with 18GB of my original
650GB dataset (1.2TB filesystem).

I'm willing to bet the majority of my data is still there, but is there a
tool to crawl the device looking for files/data?  Any ideas would be
appreciated!

Thanks much,
-Aaron


[[HTML alternate version deleted]]
