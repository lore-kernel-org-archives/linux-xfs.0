Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3TJsuhW079148 for <xfs@oss.sgi.com>; Fri, 29 Apr 2011 14:54:56 -0500
Received: from trent.utfs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84C9D1560B19
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2011 12:58:28 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [194.246.123.103]) by
	cuda.sgi.com with ESMTP id 01GJ8uvqrlO7lLAE for
	<xfs@oss.sgi.com>; Fri, 29 Apr 2011 12:58:28 -0700 (PDT)
Date: Fri, 29 Apr 2011 12:58:26 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110428233751.GR12436@dastard>
Message-ID: <alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
	<20110424234655.GC12436@dastard>
	<alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
	<alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
	<20110427022655.GE12436@dastard>
	<alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
	<20110427102824.GI12436@dastard>
	<alpine.DEB.2.01.1104281008320.18728@trent.utfs.org>
	<20110428233751.GR12436@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: minchan.kim@gmail.com, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, 29 Apr 2011 at 09:37, Dave Chinner wrote:
> Did you read the email that pointed to CONFIG_TINY_RCU as the
> ptotential source of the problem? Can you change to CONFIG_TREE_RCU
> and see if the problem goes away?

Tried with TREE_RCU, unfortunately the problem persists. However, the OOM 
messages did not make it to the disk this time. Syslog continued to work 
until 11:51 (local time), the slabinfo-8-TREE_RCU.txt file was written to 
until 11:57, the machine was already unusable at that point. At 12:07 I 
took a "screenshot" and then powercycled the machine:

  http://nerdbynature.de/bits/2.6.39-rc4/oom/
  (The files marked with -8 are the current ones)

Btw, the xfs filesystem I'm du'ing over is still mounted with "noatime".

Any ideas? Patches to try?

Thanks,
Christian.
-- 
BOFH excuse #70:

nesting roaches shorted out the ether cable

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
