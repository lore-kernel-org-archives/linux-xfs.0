Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0VLQw2o127950 for <xfs@oss.sgi.com>; Mon, 31 Jan 2011 15:26:58 -0600
Received: from asmtpout013.mac.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0551B2A097A
	for <xfs@oss.sgi.com>; Mon, 31 Jan 2011 13:29:25 -0800 (PST)
Received: from asmtpout013.mac.com (asmtpout013.mac.com [17.148.16.88]) by
	cuda.sgi.com with ESMTP id A1QHWqYXYTyLyVjn for
	<xfs@oss.sgi.com>; Mon, 31 Jan 2011 13:29:25 -0800 (PST)
MIME-version: 1.0
Received: from [172.16.1.32] ([74.95.156.201])
	by asmtp013.mac.com (Oracle Communications Messaging Exchange Server
	7u4-20.01 64bit (built Nov 21 2010)) with ESMTPSA id
	<0LFW00HG7P0TZZ80@asmtp013.mac.com>
	for xfs@oss.sgi.com; Mon, 31 Jan 2011 13:29:19 -0800 (PST)
Message-id: <86FBE6A1-CDCD-4FA3-B389-8D8C75A67CAB@mac.com>
From: Dale Stephenson <dalestephenson@mac.com>
Subject: Possible memory corruption in xfs_buf_iomove()
Date: Mon, 31 Jan 2011 16:29:16 -0500
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

At Snap Appliance, we were running into appeared to be random oops  
when setting/reading large attributes.  Trevor Heathorn was able to  
trace the problem down to the function xfs_buf_iomove() in linux-2.6- 
xfs/xfs_buf.c.  The size of the copy within the loop is calculated as  
a minimum of the page size and bp->b_count_desired, minus the  
applicable offsets.  This can result in a copy size greater than the  
remaining size of the data length, which in the case of a read caused  
whatever else is in the buffer to be written past the end of the data  
area we had allocated.  He found that this fix prevented the oops:

--- xfs_buf.c	17 Sep 2009 00:19:49 -0000	1.4
+++ xfs_buf.c	31 Jan 2011 20:22:59 -0000	1.5
@@ -1313,6 +1313,7 @@
  			      PAGE_CACHE_SIZE-cpoff, bp->b_count_desired-boff);

  		ASSERT(((csize + cpoff) <= PAGE_CACHE_SIZE));
+		csize = min(csize, (bend - boff));

  		switch (mode) {
  		case XBRW_ZERO:

This fix also keeps the write from copying past the end of the buffer,  
though at least in that case it won't be written to unallocated  
memory.  It also may keep the zero from zeroing to the end of the  
buffer if the bsize passed in doesn't justify it, though I'm not sure  
if there are any callers of this function that do not want it zeroed  
to the end.

Dale J. Stephenson
dstephenson@overlandstorage.com
dalestephenson@mac.com 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
