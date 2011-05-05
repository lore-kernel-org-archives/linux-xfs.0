Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4523pD2106600 for <xfs@oss.sgi.com>; Wed, 4 May 2011 21:03:51 -0500
Received: from trent.utfs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4CF05FBF027
	for <xfs@oss.sgi.com>; Wed,  4 May 2011 19:07:28 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [194.246.123.103]) by
	cuda.sgi.com with ESMTP id VsftkLgHKOX3WCR3 for
	<xfs@oss.sgi.com>; Wed, 04 May 2011 19:07:28 -0700 (PDT)
Date: Wed, 4 May 2011 19:07:27 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110504231549.GA25956@dastard>
Message-ID: <alpine.DEB.2.01.1105041901380.18728@trent.utfs.org>
References: <20110501080149.GD13542@dastard>
	<alpine.DEB.2.01.1105012135260.18728@trent.utfs.org>
	<20110502121958.GA2978@dastard>
	<alpine.DEB.2.01.1105021247410.18728@trent.utfs.org>
	<20110503005114.GE2978@dastard>
	<alpine.DEB.2.01.1105031345090.18728@trent.utfs.org>
	<alpine.DEB.2.01.1105031740460.18728@trent.utfs.org>
	<20110504073615.GD9114@dastard> <20110504111211.GF9114@dastard>
	<alpine.DEB.2.01.1105041205340.18728@trent.utfs.org>
	<20110504231549.GA25956@dastard>
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
Cc: minchan.kim@gmail.com, LKML <linux-kernel@vger.kernel.org>, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs@oss.sgi.com

On Thu, 5 May 2011 at 09:15, Dave Chinner wrote:
> I'll push the fix through the XFS tree to mainline. Thanks for all
> your effort helping me understand and debug the problem, Christian.

OK, I gave it some more testing and compiled the kernel wit UP and 
TINY_RCU again and with your patch applied to -rc6 I could not reproduce 
the issue any more. Plain -rc6 still has the OOM problem.

Feel free to add:

  Tested-By: Christian Kujau <lists@nerdbynature.de>

Again, thanks so much for staying with me and guiding me through all the 
debug steps. And all your effort fixing such a rare setup. I hope more 
people will share the joy :-)

Christian.
-- 
BOFH excuse #164:

root rot

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
