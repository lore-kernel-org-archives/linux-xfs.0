Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3M300lL192133 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 22:00:00 -0500
Received: from trent.utfs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 078BC1514469
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 20:03:28 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [194.246.123.103]) by
	cuda.sgi.com with ESMTP id eOwexVnNsE7lVwYY for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2011 20:03:28 -0700 (PDT)
Date: Thu, 21 Apr 2011 20:03:27 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <BANLkTi=P5z4iON+ULiUEAeuuCJCJ_nMxWw@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.1104212000420.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
	<BANLkTi=P5z4iON+ULiUEAeuuCJCJ_nMxWw@mail.gmail.com>
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
To: Minchan Kim <minchan.kim@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, 22 Apr 2011 at 11:58, Minchan Kim wrote:
> But I wonder why VM can't reclaim the pages. As I see the log, there
> are lots of slab pages(710M) in DMA zone while LRU pages are very
> small. SLAB pages are things VM has a trouble to reclaim. I am not
> sure 710M of SLAB is reasonable size. Don't you have experience same
> problem in old kernel?

No, I forgot to add 2.6.38 (and before) did not show that behaviour.

> If you see the problem first in 2.6.39-rc4, maybe it would be a
> regression(ex, might be slab memory leak)

I would think so. I'll try to bisect, but with one compilation taking 
~20min on this box, this might take a while.

> Could you get the information about slabinfo(ex, cat /proc/slabinfo)
> right before OOM happens.

When it happens again, I'll try to get this.

Thanks for replying,
Christian.
-- 
BOFH excuse #73:

Daemons did it

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
