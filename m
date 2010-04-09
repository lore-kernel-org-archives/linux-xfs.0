Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o39LZlwu140685 for <xfs@oss.sgi.com>; Fri, 9 Apr 2010 16:35:48 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E20201BCFE4D
	for <xfs@oss.sgi.com>; Fri,  9 Apr 2010 14:37:39 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.9])
	by cuda.sgi.com with ESMTP id 8QZReGNbMoi0vN6I for
	<xfs@oss.sgi.com>; Fri, 09 Apr 2010 14:37:39 -0700 (PDT)
Date: Fri, 9 Apr 2010 14:37:15 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: Kernel crash in xfs_iflush_cluster (was Somebody take a look
	please!...)
In-Reply-To: <00bb01cad70d$a814c2c0$0400a8c0@dcccs>
Message-ID: <alpine.DEB.2.01.1004091435170.29272@bogon.housecafe.de>
References: <02c101cacbf8$d21d1650$0400a8c0@dcccs>
	<179901cad182$5f87f620$0400a8c0@dcccs>
	<t2h2375c9f91004010337p618c4d5yc739fa25b5f842fa@mail.gmail.com>
	<1fe901cad2b0$d39d0300$0400a8c0@dcccs>
	<20100402230905.GW3335@dastard>
	<22c901cad333$7a67db60$0400a8c0@dcccs>
	<20100404103701.GX3335@dastard> <2bd101cad4ec$5a425f30$0400a8c0@dcccs>
	<20100405224522.GZ3335@dastard>
	<3a5f01cad6c5$8a722c00$0400a8c0@dcccs>
	<20100408025822.GL11036@dastard>
	<00bb01cad70d$a814c2c0$0400a8c0@dcccs>
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
To: Janos Haar <janos.haar@netcenter.hu>
Cc: axboe@kernel.dk, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-mm@kvack.org, xiyou.wangcong@gmail.com, kamezawa.hiroyu@jp.fujitsu.com

On Thu, 8 Apr 2010 at 13:21, Janos Haar wrote:
> > Yeah, these still a fix that needs to be back ported to .33
> > to solve this problem. It's in the series for 2.6.32.x, so maybe
> > pulling the 2.6.32-stable-queue tree in the meantime is your best
> > bet.
> 
> Ok, thank you.
> But where can i find this tree?


Perhaps Dave meant the stable-queue?

http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git

Then again, 2.6.34-rc3 needs testing too! :-)

Christian.
-- 
BOFH excuse #98:

The vendor put the bug there.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
