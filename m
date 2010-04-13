Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D4N2H9189801 for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 23:23:03 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4DEF7FF4617
	for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 21:24:54 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	sF8hkWKNh1HklEj0 for <xfs@oss.sgi.com>;
	Mon, 12 Apr 2010 21:24:54 -0700 (PDT)
Date: Tue, 13 Apr 2010 14:24:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.34-rc3: inode 0x401afe0 background reclaim flush failed
	with 11
Message-ID: <20100413042451.GQ2493@dastard>
References: <alpine.DEB.2.01.1004091348010.29272@bogon.housecafe.de>
	<20100413024946.GP2493@dastard>
	<alpine.DEB.2.01.1004121950510.29272@bogon.housecafe.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1004121950510.29272@bogon.housecafe.de>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com

On Mon, Apr 12, 2010 at 07:57:26PM -0700, Christian Kujau wrote:
> On Tue, 13 Apr 2010 at 12:49, Dave Chinner wrote:
> > No.
> > 
> > http://git.kernel.org/?p=linux/kernel/git/dgc/xfs.git;a=commit;h=7bb6049804717d4aa1f43f2abb50691c0df1d9f2
> 
> Ah, thanks. It's not in -rc4 yet, will it be included in the next release?

It's not even in the xfs-dev tree yet. I'm about to gather all the
outstanding reviewed patches into a branch so that they can get
there, but there's a few patches that need to go to linus, too...

> > > PS: Why is the inode shown in hex and not in decimal? Would something 
> > > like this do:
> > 
> > Because I find that large inode numbers in hex are much easier to
> > understand than huge decimal numbers. The inode number is a direct
> > encoding of it's location on disk and these days I can generally
> > decode them in my head direct from the hex value.
> 
> Hehe, OK. Will learn how to do that too :-)
> 
> > IOWs, the first
> > thing I almost always do when looking at an inode number is convert
> > it to hex, so I don't see any point in printing them in decimal...
> 
> I was tempted to "find . -inum" to find out which data might be in trouble 
> but then noticed that I had to convert it to decimal first.

Hmmm - I'd never realised that find doesn't decode hex numbers.
I guess I rarely use find for that purpose. I'll keep that in mind
when adding new output.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
