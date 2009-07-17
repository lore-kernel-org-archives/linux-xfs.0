Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6HAZae7081051 for <xfs@oss.sgi.com>; Fri, 17 Jul 2009 05:35:37 -0500
Received: from hattara.pcuf.fi (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9A98736BFEC
	for <xfs@oss.sgi.com>; Fri, 17 Jul 2009 03:36:16 -0700 (PDT)
Received: from hattara.pcuf.fi (hattara.pcuf.fi [194.100.34.36]) by
	cuda.sgi.com with ESMTP id v1GKnGNWaYWMxlpX for
	<xfs@oss.sgi.com>; Fri, 17 Jul 2009 03:36:16 -0700 (PDT)
Received: from pcuf.fi (pcuf.fi [194.100.34.1])
	by hattara.pcuf.fi (Postfix) with ESMTP id 9A9531700BE
	for <xfs@oss.sgi.com>; Fri, 17 Jul 2009 13:35:53 +0300 (EEST)
Received: from localhost (localhost [127.0.0.1])
	by pcuf.fi (Postfix) with ESMTP id C720B13F6F4
	for <xfs@oss.sgi.com>; Fri, 17 Jul 2009 13:35:52 +0300 (EEST)
Date: Fri, 17 Jul 2009 13:35:52 +0300 (EEST)
From: =?ISO-8859-15?Q?J_P=E4lve?= <xtc@pcuf.fi>
Subject: Write barriers and hardware RAID
Message-ID: <alpine.LRH.1.10.0907171259590.8586@pcuf.fi>
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

Hi,

I'm setting up a server to provide storage for a couple of VMware ESXi 
servers. I'm using the latest stable Debian and I'm leaning towards using 
NFS with XFS. However, I'm concerned about data integrity in the event of 
power-out (we have UPS but they only last so long). Here are the specific 
questions I have:

- The XFS FAQ states that with battery backup'd RAID hardware, both write 
barriers and individual disk cache should be turned off. However, I'm 
getting better benchmark results with both turned on. What I'm wondering 
is, will write barriers work as intended when used with hardware RAID 
controller (PERC 6/E)? Googling only turned up results relating to 
software RAID.

- The XFS FAQ also states that virtualization products prevent write 
barriers from working correctly. Is this still the case (specifically with 
ESXi 3.5 and later) and is there anything that can be done about it? Does 
VMFS somehow work around this, or is the problem then just "out of sight, 
out of mind"?

Bregs,
   JPa

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
