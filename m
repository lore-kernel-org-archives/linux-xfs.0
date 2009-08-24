Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7OJP4Rp144306 for <xfs@oss.sgi.com>; Mon, 24 Aug 2009 14:25:14 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76F541526305
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2009 12:25:54 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by
	cuda.sgi.com with ESMTP id 1CTNLFXtEHfgpejJ for
	<xfs@oss.sgi.com>; Mon, 24 Aug 2009 12:25:54 -0700 (PDT)
Received: from [192.168.3.11] (Athena [192.168.3.11])
	by Ishtar.sc.tlinx.org (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7OJPMpx012911 for <xfs@oss.sgi.com>; Mon, 24 Aug 2009 12:25:24 -0700
Message-ID: <4A92E922.2030404@tlinx.org>
Date: Mon, 24 Aug 2009 12:25:22 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: xfs logbufs default, (also noatime,
	lazy-count(of partition formatter)...32767b v. 32768b...
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
To: xfs-oss <xfs@oss.sgi.com>

Is there a reason why logbufs=8 should't become the default?
Isn't it the best choice for most users given today's memory
constraints (or lack thereof?)

I saw a message about xfs parameter tuning and still see the 
mention to:
'logbufs=8,noatime' having to be specified on every mount.

If the desire is to provide default optimal tuning, maybe a 
default of logbufs to 8 would be a good idea, and maybe a
mkfs flag to default to 'noatime' and a 64MB internal log
size would be good ideas for *most* users?

How much of problem is defaulting to a 64MB internal log
size when file partitions are measured in the 100GB range?

I'm not sure how much use it is to even remember typing lazy-count=1
on the size partition each time.

One more 'nit', while I think of it...for a 64MB log buffer size,
one should be able to specify 32768b, but last I tried, that gave
a 'too large' error...isn't 32768*4=64MB, not 32767b?

What's really created when I use the 32767b max?  64MB or 
"64MB-4K"? (maybe it doesn't matter, but if a log process
wrote exactly 16MB chunks, it would be a bit short on the 4th
write..)...

-l

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
