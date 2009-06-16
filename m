Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5G0I9h5134223
	for <linux-xfs@oss.sgi.com>; Mon, 15 Jun 2009 19:18:09 -0500
Received: from kuber.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BEA31AD8965
	for <linux-xfs@oss.sgi.com>; Mon, 15 Jun 2009 17:18:32 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158]) by
	cuda.sgi.com with ESMTP id b97xgBfJQjz1ABtH for
	<linux-xfs@oss.sgi.com>; Mon, 15 Jun 2009 17:18:32 -0700 (PDT)
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>) id 1MGMNk-0003jp-0L
	for linux-xfs@oss.sgi.com; Mon, 15 Jun 2009 17:18:32 -0700
Message-ID: <24042506.post@talk.nabble.com>
Date: Mon, 15 Jun 2009 17:18:32 -0700 (PDT)
From: Smit Shah <getsmit@gmail.com>
Subject: XFS Preallocate using ALLOCSP
MIME-Version: 1.0
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
To: linux-xfs@oss.sgi.com


Hi, 

I wanted to preallocate the file using the ALLOCSP so that the preallocated
space is zeroed out. Hence i used the xfsctl but the problem is that i
cannot execute  it as a non-root user.  So i tried using fallocate but when
i saw the xfs implementation of kernel it uses the RESVP cmd and  since the
unwritten flag is set i am assuming that the performance of writing to the
preallocated space will suffer because of the metadata updates. So is there
a way to preallocate using ALLOCSP as a non-root user or else i would be
required to modify the kernel ??

TIA, 
Smit 
-- 
View this message in context: http://www.nabble.com/XFS-Preallocate-using-ALLOCSP-tp24042506p24042506.html
Sent from the linux-xfs mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
