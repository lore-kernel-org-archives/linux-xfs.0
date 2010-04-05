Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o35MhpXC026454 for <xfs@oss.sgi.com>; Mon, 5 Apr 2010 17:43:52 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CA4D29D12E
	for <xfs@oss.sgi.com>; Mon,  5 Apr 2010 15:45:39 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	vuvGynu1TugQrwzY for <xfs@oss.sgi.com>;
	Mon, 05 Apr 2010 15:45:39 -0700 (PDT)
Date: Tue, 6 Apr 2010 08:45:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Kernel crash in xfs_iflush_cluster (was Somebody take a look
	please!...)
Message-ID: <20100405224522.GZ3335@dastard>
References: <2375c9f91003242029p1efbbea1v8e313e460b118f14@mail.gmail.com>
	<20100325153110.6be9a3df.kamezawa.hiroyu@jp.fujitsu.com>
	<02c101cacbf8$d21d1650$0400a8c0@dcccs>
	<179901cad182$5f87f620$0400a8c0@dcccs>
	<t2h2375c9f91004010337p618c4d5yc739fa25b5f842fa@mail.gmail.com>
	<1fe901cad2b0$d39d0300$0400a8c0@dcccs>
	<20100402230905.GW3335@dastard>
	<22c901cad333$7a67db60$0400a8c0@dcccs>
	<20100404103701.GX3335@dastard>
	<2bd101cad4ec$5a425f30$0400a8c0@dcccs>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2bd101cad4ec$5a425f30$0400a8c0@dcccs>
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
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, xiyou.wangcong@gmail.com, kamezawa.hiroyu@jp.fujitsu.com

On Mon, Apr 05, 2010 at 08:17:27PM +0200, Janos Haar wrote:
> Dave,
> 
> Thank you for your answer.
> Like i sad before, this is a productive server with important service.
> Can you please send the fix for me as soon as it is done even for
> testing it....
> Or point me to the right direction to get it?

It's in 2.6.33 if you want to upgrade the kernel, or you if don't
want to wait for the next 2.6.32.x kernel, you can apply this series
of 19 patches yourself:

http://oss.sgi.com/archives/xfs/2010-03/msg00125.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
