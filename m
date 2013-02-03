Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E1AD67F52
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2013 14:37:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B01158F8033
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2013 12:37:09 -0800 (PST)
Received: from jive.SoftHome.net (jive.SoftHome.net [66.54.152.27]) by
	cuda.sgi.com with SMTP id Z5fCJEyQ8C0yDvEa for
	<xfs@oss.sgi.com>; Sun, 03 Feb 2013 12:37:08 -0800 (PST)
From: rkj@softhome.net
Subject: Looking for Linux XFS file system performance tuning tips for LSI
	9271-8i + 8 SSD's RAID0
Date: Sun, 03 Feb 2013 13:36:48 -0700
Mime-Version: 1.0
Message-ID: <courier.510ECA60.00003A99@softhome.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


I am working with hardware RAID0 using LSI 9271-8i + 8 SSD's.  I am using 
CentOS 6.3 on a Supermicro X9SAE-V motherboard with Intel Xeon E3-1275V2 CPU 
and 32GB 1600 MHz ECC RAM.  My application is fast sensor data store and 
forward with UDP based file transfer using multiple 10GbE interfaces.  So I 
do not have any concurrent loading, I am mainly interested in optimizing 
sequential read/write performance. 

Raw performance as measured by Gnome Disk Utility is around 4GB/s sustained 
read/write.  With XFS buffer IO, my sequential writes max out at about  2.5 
GB/s.  With Direct IO, the sequential writes are around 3.5 GB/s but I 
noticed a drop-off in sequential reads for smaller record sizes.  I am 
trying to get the XFS sequential read/writes as close to 4 GB/s as possible. 

I have documented all of the various mkfs.xfs options I have tried, fstab 
mount options, iozone results, etc. in this forum thread: 

http://www.xtremesystems.org/forums/showthread.php?284853-Looking-for-Linux- 
file-system-performance-tuning-tips-for-LSI-9271-8i-8-SSD-s-RAID0 

Please let me know if you have any suggestions.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
