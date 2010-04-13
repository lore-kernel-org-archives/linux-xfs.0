Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3DBX6Kp225099 for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 06:33:06 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE95B125940D
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 04:34:58 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	AFRl6YYM4Swet4K1 for <xfs@oss.sgi.com>;
	Tue, 13 Apr 2010 04:34:58 -0700 (PDT)
Date: Tue, 13 Apr 2010 21:34:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Kernel crash in xfs_iflush_cluster (was Somebody take a look
	please!...)
Message-ID: <20100413113445.GZ2493@dastard>
References: <20100404103701.GX3335@dastard>
	<2bd101cad4ec$5a425f30$0400a8c0@dcccs>
	<20100405224522.GZ3335@dastard>
	<3a5f01cad6c5$8a722c00$0400a8c0@dcccs>
	<20100408025822.GL11036@dastard>
	<11b701cad9c8$93212530$0400a8c0@dcccs>
	<20100412001158.GA2493@dastard>
	<18b101cadadf$5edbb660$0400a8c0@dcccs>
	<20100413083931.GW2493@dastard>
	<190201cadaeb$02ec22c0$0400a8c0@dcccs>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <190201cadaeb$02ec22c0$0400a8c0@dcccs>
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

On Tue, Apr 13, 2010 at 11:23:36AM +0200, Janos Haar wrote:
> >If you run:
> >
> >$ xfs_db -r -c "inode 474253940" -c p /dev/sdb2
> >
> >Then I can can confirm whether there is corruption on disk or not.
> >Probably best to sample multiple of the inode numbers from the above
> >list of bad inodes.
> 
> Here is the log:
> http://download.netcenter.hu/bughunt/20100413/debug.log

There are multiple fields in the inode that are corrupted.
I am really surprised that xfs-repair - even an old version - is not
picking up the corruption....

> The xfs_db does segmentation fault. :-)

Yup, it probably ran off into la-la land chasing corrupted
extent pointers.

> Btw memory corruption:
> In the beginnig of march, one of my bets was memory problem too, but
> the server was offline for 7 days, and all the time runs the
> memtest86 on the hw, and passed all the 8GB 74 times without any bit
> error.
> I don't think it is memory problem, additionally the server can
> create big size  .tar.gz files without crc problem.

Ok.

> If i force my mind to think to hw memory problem, i can think only
> for the raid card's cache memory, wich i can't test with memtest86.
> Or the cache of the HDD's pcb...

Yes, it could be something like that, too, but the only way to test
it is to swap out the card....

> In the other hand, i have seen more people reported memory
> corruption about these kernel versions, can we check this and surely
> select wich is the problem? (hw or sw)?

I haven't heard of any significant memory corruption problems in
2.6.32 or 2.6.33, but it is a possibility given the nature of the
corruption. However, I may have only happened once and be completely
unreproducable.

I'd suggest fixing the existing corruption first, and then seeing if
it re-appears. If it does reappear, then we know there's a
reproducable problem we need to dig out....

> I mean, if i am right, the hw memory problem makes only 1-2 bit
> corruption seriously, and the sw page handling problem makes bad
> memory pages, no?

RAM ECC guarantees correction of single bit errors and detection of
double bit errors (which cause the kernel to panic, IIRC). I can't
tell you what happens when larger errors occur, though...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
