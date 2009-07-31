Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6VLaFLB173271 for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 16:36:15 -0500
Received: from bifrost.lang.hm (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E3CE12A9115
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 14:46:05 -0700 (PDT)
Received: from bifrost.lang.hm (mail.lang.hm [64.81.33.126]) by cuda.sgi.com
	with ESMTP id kGX71FQFIkLNxowS for <xfs@oss.sgi.com>;
	Fri, 31 Jul 2009 14:46:05 -0700 (PDT)
Received: from asgard.lang.hm (asgard.lang.hm [10.0.0.100])
	by bifrost.lang.hm (8.13.4/8.13.4/Debian-3) with ESMTP id
	n6VLb2kr004676 for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 14:37:02 -0700
Date: Fri, 31 Jul 2009 14:37:02 -0700 (PDT)
From: david@lang.hm
Subject: need troubleshooting help to track down a xfsdatad or hardware problem
Message-ID: <alpine.DEB.1.10.0907311433270.28013@asgard.lang.hm>
MIME-Version: 1.0
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

I have 20 identical boxes that have a 16 drive raid 6 array (3ware 
controller), on 17 of the boxes everything seems fine, but on 3 of the 
boxes the xfsdatad process appears to be having problems writing to the 
drive (iostat shows 5MB throughput), and a huge amount of data ends up 
buffered in memory, but cannot get written out to the disk.

what can I do to figure out if the problem is somewhere in software or in 
hardware (and if hardware, any ideas how to figure out what is happening 
on these 3 boxes)

David Lang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
