Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3P9kq7V109718 for <xfs@oss.sgi.com>; Mon, 25 Apr 2011 04:46:53 -0500
Received: from trent.utfs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21AFDC35104
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2011 02:50:22 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [194.246.123.103]) by
	cuda.sgi.com with ESMTP id jKYligpz6oLDuMB2 for
	<xfs@oss.sgi.com>; Mon, 25 Apr 2011 02:50:22 -0700 (PDT)
Date: Mon, 25 Apr 2011 02:50:12 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <alpine.DEB.2.01.1104250053590.18728@trent.utfs.org>
Message-ID: <alpine.DEB.2.01.1104250246520.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
	<20110424234655.GC12436@dastard>
	<alpine.DEB.2.01.1104250053590.18728@trent.utfs.org>
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
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, 25 Apr 2011 at 01:02, Christian Kujau wrote:
> On Mon, 25 Apr 2011 at 09:46, Dave Chinner wrote:
> > BTW, what are your mount options? If it is the problem I suspect it
> > is, then using noatime with stop it from occurring....
> 
> When mounted with noatime, running du(1) accross the XFS volume still 
> triggered the OOM killer, but the backtrace looked somewhat different 
> this time:

Tried again with noatime, this time no OOM message got logged to the disk 
(but may have been logged to the console early on). As it's reproducible, 
I started du(1) across the XFS volume and after a while my SSH connection 
to the box was lost. That's all I got this time:

  http://nerdbynature.de/bits/2.6.39-rc4/oom/oom-6.JPG
  http://nerdbynature.de/bits/2.6.39-rc4/oom/slabinfo-6.txt.bz2

Christian.
-- 
BOFH excuse #272:

Netscape has crashed

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
