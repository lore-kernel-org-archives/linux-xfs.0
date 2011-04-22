Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3MHc1Gc226259 for <xfs@oss.sgi.com>; Fri, 22 Apr 2011 12:38:02 -0500
Received: from trent.utfs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF647403E96
	for <xfs@oss.sgi.com>; Fri, 22 Apr 2011 10:41:29 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [194.246.123.103]) by
	cuda.sgi.com with ESMTP id wFswsU8rrB5HAiCB for
	<xfs@oss.sgi.com>; Fri, 22 Apr 2011 10:41:29 -0700 (PDT)
Date: Fri, 22 Apr 2011 10:41:26 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <BANLkTi=P5z4iON+ULiUEAeuuCJCJ_nMxWw@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.1104221033220.18728@trent.utfs.org>
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
Cc: rientjes@google.com, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, 22 Apr 2011 at 11:58, Minchan Kim wrote:
> You would try to allocate a page from DMA as you don't have a normal zone.
> 
> Although free pages in DMA zone is about 3M, free pages of zone is
> below min of DMA zone. So zone_watermark_ok would be failed.
> 
> But I wonder why VM can't reclaim the pages. As I see the log, there
> are lots of slab pages(710M) in DMA zone while LRU pages are very
> small. SLAB pages are things VM has a trouble to reclaim. I am not
> sure 710M of SLAB is reasonable size. Don't you have experience same
> problem in old kernel?
> If you see the problem first in 2.6.39-rc4, maybe it would be a
> regression(ex, might be slab memory leak)
> Could you get the information about slabinfo(ex, cat /proc/slabinfo)
> right before OOM happens.
> It could say culprit.

It happened again, and again it's du(1) invoking the OOM killer (I'm 
running du(1) accross a few directories every 6hrs). This time I got 
/proc/slabinfo as well:

  http://nerdbynature.de/bits/2.6.39-rc4/oom/
  * NOTE: slabinfo.txt.gz deflates to ~40MB!)
  * messages-2.txt contains the messages of last night's OOM, which
   started at Apr 22 00:10:16 PDT

Thanks for looking into it.

Christian.
-- 
BOFH excuse #140:

LBNC (luser brain not connected)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
