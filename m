Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7M74VIm037789 for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 02:04:31 -0500
Received: from eamp.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66C901DA255B
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 00:04:30 -0700 (PDT)
Received: from eamp.org (eamp.org [67.202.107.33]) by cuda.sgi.com with ESMTP
	id T5iYPw64DgEQkKZ1 for <xfs@oss.sgi.com>;
	Mon, 22 Aug 2011 00:04:30 -0700 (PDT)
Message-Id: <E1QvOYe-0005SK-95@eamp.org>
From: Robert Jacobs <debbtsb06@eamp.org>
Subject: Re: Bug#638158: xfsprogs: Damaged filesystem causes xfs_repair to
	sometimes (but not always) segfault
In-reply-to: <20110822032849.GD3162@dastard>
References: <E1QtbO1-0005u8-5N@eamp.org> <201108171518.53374@zmi.at>
	<E1QvGzO-0001aI-4l@eamp.org> <20110822012705.GC3162@dastard>
	<20110822032849.GD3162@dastard>
Date: Mon, 22 Aug 2011 00:04:28 -0700
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> On Mon, Aug 22, 2011 at 11:27:05AM +1000, Dave Chinner wrote:
> > On Sun, Aug 21, 2011 at 03:59:34PM -0700, Robert Jacobs wrote:
> > > > On Mittwoch, 17. August 2011 Robert Jacobs wrote:
> > > > > I've attached the outputs of xfs_check and three different runs of
> > > > > xfs_repair (with backtrace, when available).
> > > > 
> > > > Can you provide a XFS metadump? That should help devs to reproduce the 
> > > > error. 
> > > 
> > > I've uploaded it to <http://eamp.org/metadumpf.lzma>. It's 9MB but I
> > > have somewhat limited upload quota. I noticed that some filenames
> > > weren't obscured so I obscured them by hand -- if this is a problem,
> > > please tell me. 
> > 
> > The metadump image you have provided does not trigger problems on
> > either 3.1.5 on a current xfs_repair build out of the xfsprogs-dev
> > repository on my machines. Can you restore the image and run
> > xfs_repair on the image and confirm it still crashes?
> 
> I stand corrected - it doesn't crash on x86-64, but does crash on
> i686. I get several different random crashes, so it looks like some
> kind of heap corruption is occurring. Running under valgrind shows
> that the inode extent blkmaps are getting out of bound reads and
> writes. I think the problem is this:

[...]

> As it is, I'd recommend upgrading to x86-64 anyway - XFS on i686
> doesn't receive a lot of developer testing...

Sadly, I can't upgrade to x86-64 because this is a i686 machine that I
have not yet outgrown. Someday soon... 

But thank you very much! I now have a functioning filesystem again.

 - Robert Jacobs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
