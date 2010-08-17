Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7H0UqbW011593 for <xfs@oss.sgi.com>; Mon, 16 Aug 2010 19:30:53 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 58087171E0AB
	for <xfs@oss.sgi.com>; Mon, 16 Aug 2010 17:31:19 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	Tmzp7HUmtqBzBqST for <xfs@oss.sgi.com>;
	Mon, 16 Aug 2010 17:31:19 -0700 (PDT)
Date: Tue, 17 Aug 2010 10:31:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Alignment size?
Message-ID: <20100817003116.GM10429@dastard>
References: <4C64715F.8060000@msgid.tls.msk.ru>
	<20100812234911.GC10429@dastard>
	<4C64E52E.2060806@msgid.tls.msk.ru>
	<20100813113915.GD10429@dastard>
	<4C69D554.4010407@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C69D554.4010407@msgid.tls.msk.ru>
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
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: xfs@oss.sgi.com

On Tue, Aug 17, 2010 at 04:18:28AM +0400, Michael Tokarev wrote:
> 13.08.2010 15:39, Dave Chinner wrote:
> > On Fri, Aug 13, 2010 at 10:24:46AM +0400, Michael Tokarev wrote:
> []
> >> And a related question, -- is there a way to create
> >> xfs fs with the right sector size?  The filesystem
> >> were ok in years, not only on this machine, and I'm
> >> quite afraid to replace it with something else (e.g.
> >> ext4) in a hurry without good prior testing.
> > 
> > # mkfs.xfs -s <size> ....
> > 
> > if you want to set it manually. YOu shouldn't need to with any
> > relatively recent mkfs.xfs...
> 
> Um.  It appears that mkfs.xfs ignores -s size=512 on this
> raid5 array, and silently creates a filesystem with 4096
> sector size, regardless of various -s size=nn and -s log=mm
> options.
> 
> This is xfsprogs  3.1.2-1 (debian squeeze package).
> 
> So the question stands...

IIRC, the current debian xfsprogs package is still being built with
the old detection library. If you install libblkid and build
xfsprogs yourself, it should use the newer detection code and
behave as expected.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
