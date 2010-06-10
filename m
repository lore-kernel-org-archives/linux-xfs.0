Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5A0iXZE042216 for <xfs@oss.sgi.com>; Wed, 9 Jun 2010 19:44:33 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF64714AFEFE
	for <xfs@oss.sgi.com>; Wed,  9 Jun 2010 17:47:04 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	wGkgZzGQRTojSE09 for <xfs@oss.sgi.com>;
	Wed, 09 Jun 2010 17:47:04 -0700 (PDT)
Date: Thu, 10 Jun 2010 10:47:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs, 2.6.27=>.32 sync write 10 times slowdown [was: xfs,
	aacraid 2.6.27 => 2.6.32 results in 6 times slowdown]
Message-ID: <20100610004701.GN7869@dastard>
References: <4C0E13A7.20402@msgid.tls.msk.ru> <20100608122919.GC7869@dastard>
	<4C0EA938.9000104@msgid.tls.msk.ru> <20100608231845.GG7869@dastard>
	<4C0F3819.4000409@msgid.tls.msk.ru> <20100609074741.GJ7869@dastard>
	<4C0FE779.8010603@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C0FE779.8010603@msgid.tls.msk.ru>
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
Cc: Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Jun 09, 2010 at 11:11:53PM +0400, Michael Tokarev wrote:
> 09.06.2010 11:47, Dave Chinner wrote:
> >On Wed, Jun 09, 2010 at 10:43:37AM +0400, Michael Tokarev wrote:
> >>09.06.2010 03:18, Dave Chinner wrote:
> >>>On Wed, Jun 09, 2010 at 12:34:00AM +0400, Michael Tokarev wrote:
> >>[]
> >>>>Simple test doing random reads or writes of 4k blocks in a 1Gb
> >>>>file located on an xfs filesystem, Mb/sec:
> >>>>
> >>>>                      sync  direct
> >>>>              read   write   write
> >>>>2.6.27 xfs   1.17    3.69    3.80
> >>>>2.6.32 xfs   1.26    0.52    5.10
> >>>>                     ^^^^
> >>>>2.6.32 ext3  1.19    4.91    5.02
> >
> >Out of curiousity, what does 2.6.34 get on this workload?
> 
> 2.6.34 works quite well:
>      2.6.34 xfs    1.14   4.75    5.00

Ok, so we are looking at a fixed regression, then. What stable
version of 2.6.32 are you testing? A large number of XFS fixes went
into 2.6.32.12 (IIRC, it might have been .13), so maybe the problem
is fixed there. Alternatively, can you use 2.6.34 rather than
2.6.32, or bisect the regression down to a specific set of fixes so
we can consider whether a backport is worth the effort?

> The same is with -o osyncisosync (in .34).  Actually,
> osyncis[od]sync mount options does not change anything, not
> in .32 nor in .34.

I think only osyncisosync exists, and it doesn't do anything
anymore.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
