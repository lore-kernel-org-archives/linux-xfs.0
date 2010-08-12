Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7CNmvtd261233 for <xfs@oss.sgi.com>; Thu, 12 Aug 2010 18:48:58 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7166614CDE55
	for <xfs@oss.sgi.com>; Thu, 12 Aug 2010 16:58:11 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	NM7xhdKpRdVH3CnU for <xfs@oss.sgi.com>;
	Thu, 12 Aug 2010 16:58:11 -0700 (PDT)
Date: Fri, 13 Aug 2010 09:49:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Alignment size?
Message-ID: <20100812234911.GC10429@dastard>
References: <4C64715F.8060000@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C64715F.8060000@msgid.tls.msk.ru>
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

On Fri, Aug 13, 2010 at 02:10:39AM +0400, Michael Tokarev wrote:
> Hello.
> 
> I used XFS for a long time on many different
> servers, and it works well.  But now I encountered
> an.. unexpected problem.
> 
> The question is: on one of our servers, XFS requires
> different alignment size for O_DIRECT operations than
> on others.  Usually it's 512 bytes, but on this server
> it is 4096 - both min_io and alignment (this is from
> XFS_IOC_DIOINFO ioctl).

It'll be a filesystem set up with a 4k sector size, then.  Check the
output of xfs_info.

> I'm not sure what the reason for this is.
> On this server, the underlying block device is raid5
> (linux sw raid), but we had other machines with raid5
> which didn't have that alignment requiriments.
> 
> The problem with that is that Oracle db, which we use
> with XFS alot, refuses to work on this machine, or,
> rather, XFS refuses to process I/O in 512-byte chunks
> from oracle (control files and redolog files).

A clear case of application failure. I guess Oracle have some work
to do to support 4k sector drives where they won't be able to do 512
byte direct IOs at all....

> Is there a way to remedy this somehow, without
> reformatting whole 600+ gb?

Not really. If it is 4k sector size, then there is some extremely
dangerous voodoo that you could do to realign and resize the AG
headers, followed by a full xfs_repair run to fix up all the block
accounting. This is not something I'd recommend anyone ever does,
and for only 600GB of data it would probably take more time to work
out how to do it correctly (using disposable filesystem images) than
it would to dump, mkfs and restore...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
