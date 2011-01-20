Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0KKd1eV143643 for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 14:39:01 -0600
Received: from mx-out.facebook.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 25995148A6BD
	for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 12:41:20 -0800 (PST)
Received: from mx-out.facebook.com (outmail008.snc4.facebook.com
	[66.220.144.140]) by cuda.sgi.com with ESMTP id
	0QKH64kr3YyFwmyT for <xfs@oss.sgi.com>;
	Thu, 20 Jan 2011 12:41:20 -0800 (PST)
From: Peter Vajgel <pv@fb.com>
Subject: allocsize mount option
Date: Thu, 20 Jan 2011 20:41:19 +0000
Message-ID: <3F5ACD12257C714E9C0535D0A83917180288FB@SC-MBX02-2.TheFacebook.com>
Content-Language: en-US
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

We write about 100 100GB files into a single 10TB volume with xfs. We are using allocsize=1g to limit the fragmentation with a great success. We also need to reserve some space (~200GB) on each filesystem for processing the files and writing new versions of the files. Once we have only 200GB available we stop writing to the files. However with allocsize it's not that easy - we see +/- 100GB added or taken depending if there are still writes going and if the file was reopened ... Is there a way to programmatically disable allocsize speculative preallocation once we exceed certain threshold and also return the current speculative preallocation back to the free space (without closing the file)?

Thx

Peter Vajgel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
