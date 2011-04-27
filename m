Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3R7hM4D205167 for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 02:43:23 -0500
Received: from trent.utfs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D556C13332A0
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 00:46:53 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [194.246.123.103]) by
	cuda.sgi.com with ESMTP id sO7HOUjQcIGOg7nC for
	<xfs@oss.sgi.com>; Wed, 27 Apr 2011 00:46:53 -0700 (PDT)
Date: Wed, 27 Apr 2011 00:46:51 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110427022655.GE12436@dastard>
Message-ID: <alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
	<20110424234655.GC12436@dastard>
	<alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
	<alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
	<20110427022655.GE12436@dastard>
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

On Wed, 27 Apr 2011 at 12:26, Dave Chinner wrote:
> What this shows is that VFS inode cache memory usage increases until
> about the 550 sample mark before the VM starts to reclaim it with
> extreme prejudice. At that point, I'd expect the XFS inode cache to
> then shrink, and it doesn't. I've got no idea why the either the

Do you remember any XFS changes past 2.6.38 that could be related to 
something like this?

Bisecting is pretty slow on this machine. Could I somehow try to run 
2.6.39-rc4 but w/o the XFS changes merged after 2.6.38? (Does someone know 
how to do this via git?)

> Can you check if there are any blocked tasks nearing OOM (i.e. "echo
> w > /proc/sysrq-trigger") so we can see if XFS inode reclaim is
> stuck somewhere?

Will do, tomorrow.

Should I open a regression bug, so we don't loose track of this thing?

Thanks,
Christian.
-- 
BOFH excuse #425:

stop bit received

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
