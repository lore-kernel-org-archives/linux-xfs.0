Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7VNdChT089779 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 18:39:13 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0B8840D54
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 16:39:50 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	fX0RvZ9hfBIO5kCa for <xfs@oss.sgi.com>;
	Tue, 31 Aug 2010 16:39:50 -0700 (PDT)
Date: Wed, 1 Sep 2010 09:39:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: What should to do with ASSERT failed
Message-ID: <20100831233947.GN705@dastard>
References: <AANLkTin-zf0chkk68pGfwDRt03QaKmNdsP3=goDEUS+p@mail.gmail.com>
	<4C7C26E8.9070308@sandeen.net>
	<AANLkTinXDQoo7ZU+w2V7N7zBrxdS=Tc71MNZ7M4R5A9w@mail.gmail.com>
	<20100831003050.GL705@dastard>
	<AANLkTi=CVi5F4qMtWAgxneA_NcJgGSogK-G1x4awtOSz@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTi=CVi5F4qMtWAgxneA_NcJgGSogK-G1x4awtOSz@mail.gmail.com>
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
To: Mike Gao <ygao.linux@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 31, 2010 at 05:50:06PM -0500, Mike Gao wrote:
> What kind of logic there could be?
> 
> I notice that in old version, if page has no buffer in writepage, then xfs
> will create a empty buffer and attach to page. This logic there at least
> untill 2.6.33. But now xfs need this never happens (assert) when coming to
> writepage.  But I guess, when use mmap, there is no buffer attach to page
> because it operates on page directly on kernel. xfs should create buffer
> before submit bio. There must be sth I don't know. Maybe sbd can help me
> out.

mmap() pages used to be special because they weren't tagged
correctly when the page was dirtied. Nowdays the ->page_mkwrite
interface captures those and does the correct processing at page
fault time to set up the buffers. Hence we should never see an
unmapped dirty buffer in writeback. ->page-mkwrite was introduced
around 2.6.18 IIRC, but there has been changes to the way it works
since then. Maybe it is not functioning correctly on your kernel?

However, this is just one example of how buffers are handled
differently _outside XFS_ on older kernels. Nobody will be able to
give you a definitive list of what has changed - you'll only find
those by trolling git logs or testing and tripping over them.

As it is, I'm curious why you are backporting to such an old kernel
rather than just using a newer kernel. Using a newer kernel would
save you a lot of time and effort....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
