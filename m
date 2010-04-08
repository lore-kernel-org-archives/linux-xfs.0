Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o382umRk245981 for <xfs@oss.sgi.com>; Wed, 7 Apr 2010 21:56:49 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2ECECFBF58F
	for <xfs@oss.sgi.com>; Wed,  7 Apr 2010 19:58:37 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	WAhvlSBhlO2Wv2kk for <xfs@oss.sgi.com>;
	Wed, 07 Apr 2010 19:58:37 -0700 (PDT)
Date: Thu, 8 Apr 2010 12:58:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Kernel crash in xfs_iflush_cluster (was Somebody take a look
	please!...)
Message-ID: <20100408025822.GL11036@dastard>
References: <02c101cacbf8$d21d1650$0400a8c0@dcccs>
	<179901cad182$5f87f620$0400a8c0@dcccs>
	<t2h2375c9f91004010337p618c4d5yc739fa25b5f842fa@mail.gmail.com>
	<1fe901cad2b0$d39d0300$0400a8c0@dcccs>
	<20100402230905.GW3335@dastard>
	<22c901cad333$7a67db60$0400a8c0@dcccs>
	<20100404103701.GX3335@dastard>
	<2bd101cad4ec$5a425f30$0400a8c0@dcccs>
	<20100405224522.GZ3335@dastard>
	<3a5f01cad6c5$8a722c00$0400a8c0@dcccs>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3a5f01cad6c5$8a722c00$0400a8c0@dcccs>
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

On Thu, Apr 08, 2010 at 04:45:13AM +0200, Janos Haar wrote:
> Hello,
> 
> Sorry, but still have the problem with 2.6.33.2.

Yeah, these still a fix that needs to be back ported to .33
to solve this problem. It's in the series for 2.6.32.x, so maybe
pulling the 2.6.32-stable-queue tree in the meantime is your best
bet.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
