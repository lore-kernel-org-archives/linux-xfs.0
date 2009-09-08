Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n88FYr1H078410 for <xfs@oss.sgi.com>; Tue, 8 Sep 2009 10:35:04 -0500
Received: from lvps87-230-0-242.dedicated.hosteurope.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C940243426A
	for <xfs@oss.sgi.com>; Tue,  8 Sep 2009 08:35:31 -0700 (PDT)
Received: from lvps87-230-0-242.dedicated.hosteurope.de
	(lvps87-230-0-242.dedicated.hosteurope.de [87.230.0.242]) by
	cuda.sgi.com with ESMTP id EeAThF9kWEEzQj1X for
	<xfs@oss.sgi.com>; Tue, 08 Sep 2009 08:35:31 -0700 (PDT)
Date: Tue, 8 Sep 2009 17:34:46 +0200
From: Michael Guntsche <mike@it-loops.com>
Subject: xfs_repair speedups
Message-ID: <20090908153446.GA517@trillian.comsick.at>
MIME-Version: 1.0
Content-Disposition: inline
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

Hi list,

I just tested the repair speedups on my setup here and could see a
big speed improvement.

The setup is an old Pentium IV 1.7GHz with 512MB RAM and a 1.2 TB XFS on
lvm2 on RAID-5.

time xfs_repair -n  Version 3.0.2

real    0m27.983s
user    0m20.641s
sys     0m4.436s


time xfs_repair -n  Version 3.0.3-repair-speedups

real    0m8.599s
user    0m2.444s
sys     0m0.228s


Especially Phase 4 is a lot faster on my setup here.

Kind regards,
     Michael


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
