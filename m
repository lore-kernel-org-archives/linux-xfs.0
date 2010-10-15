Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9FBw1BR126684 for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 06:58:01 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4623B11F2FA4
	for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 05:13:43 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	lg55Nmo20Er3iWxd for <xfs@oss.sgi.com>;
	Fri, 15 Oct 2010 05:13:43 -0700 (PDT)
Date: Fri, 15 Oct 2010 22:59:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: allocsize mount option, was: [PATCH 1/2] xfs: dynamic
	speculative EOF preallocation
Message-ID: <20101015115907.GJ4681@dastard>
References: <1286187236-16682-1-git-send-email-david@fromorbit.com>
	<1287076965.2362.520.camel@doink> <20101014213325.GF4681@dastard>
	<201010150851.25327@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201010150851.25327@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Fri, Oct 15, 2010 at 08:51:24AM +0200, Michael Monnerie wrote:
> On Donnerstag, 14. Oktober 2010 Dave Chinner wrote:
> > > I guess the reason one might want the "allocsize" mount
> > > option now becomes the opposite of why one might have
> > > wanted it before.  I.e., it would be used to reduce
> > > the size of the preallocated range beyond EOF, which I
> > > could envision might be reasonable in some circumstances.
> > 
> > It now becomes the minimum preallocation size, rather than both the
> > minimum and the maximum....
> 
> Until now, I often set allocsize to be <nr of data disks>*<stripe size>, 
> i.e. in a 8 disk RAID-6 with 64KB stripe size = 6*64 = 384KB
> I guess this should provide the best performance.

It's not doing what you think it is:

> Is my assumption true?

No.

allocsize=size
        Sets the buffered I/O end-of-file preallocation size when
        doing delayed allocation writeout (default size is 64KiB).
        Valid values for this option are page size (typically 4KiB)
        through to 1GiB, inclusive, in power-of-2 increments.
                                    ^^^^^^^^^^^^^^^^^^^^^^^^^

The code will round the value down to the nearest power of 2, which
means you're actually telling it to preallocate 256k at a time.

> Will it change with the new code?

Entirely possible. We can and do change behaviour of mount options
when it results in an improvement.

> Does XFS automatically use allocsize=<1 full stripe> so I can skip my 
> manual allocsize options?

No. I will refer you to the swalloc mount option, though:

  swalloc
        Data allocations will be rounded up to stripe width boundaries
        when the current end of file is being extended and the file
        size is larger than the stripe width size.

Which affects both delayed allocation (after speculative prealloc
has been calculated) and physical allocation for direct IO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
