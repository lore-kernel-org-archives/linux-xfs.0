Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7M1RHZA016924 for <xfs@oss.sgi.com>; Sun, 21 Aug 2011 20:27:18 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5803913881AB
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2011 18:29:47 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	N98oZBBw6sj2miHl for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2011 18:29:47 -0700 (PDT)
Date: Mon, 22 Aug 2011 11:27:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bug#638158: xfsprogs: Damaged filesystem causes xfs_repair to
	sometimes (but not always) segfault
Message-ID: <20110822012705.GC3162@dastard>
References: <E1QtbO1-0005u8-5N@eamp.org> <201108171518.53374@zmi.at>
	<E1QvGzO-0001aI-4l@eamp.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <E1QvGzO-0001aI-4l@eamp.org>
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
To: Robert Jacobs <debbtsb06@eamp.org>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On Sun, Aug 21, 2011 at 03:59:34PM -0700, Robert Jacobs wrote:
> > On Mittwoch, 17. August 2011 Robert Jacobs wrote:
> > > I've attached the outputs of xfs_check and three different runs of
> > > xfs_repair (with backtrace, when available).
> > 
> > Can you provide a XFS metadump? That should help devs to reproduce the 
> > error. 
> 
> I've uploaded it to <http://eamp.org/metadumpf.lzma>. It's 9MB but I
> have somewhat limited upload quota. I noticed that some filenames
> weren't obscured so I obscured them by hand -- if this is a problem,
> please tell me. 

The metadump image you have provided does not trigger problems on
either 3.1.5 on a current xfs_repair build out of the xfsprogs-dev
repository on my machines. Can you restore the image and run
xfs_repair on the image and confirm it still crashes?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
