Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CA1DB7F3F
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 19:48:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B93768F8049
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 17:48:18 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	BLdrvZiiUlMK1SSK for <xfs@oss.sgi.com>;
	Mon, 23 Sep 2013 17:48:14 -0700 (PDT)
Date: Tue, 24 Sep 2013 10:48:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] xfs: lookaside cache for xfs_buf_find
Message-ID: <20130924004803.GZ9901@dastard>
References: <1378690396-15792-1-git-send-email-david@fromorbit.com>
	<52404D7F.1080308@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52404D7F.1080308@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Sep 23, 2013 at 09:17:35AM -0500, Mark Tinguely wrote:
> On 09/08/13 20:33, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >CPU overhead of buffer lookups dominate most metadata intensive
> >workloads. The thing is, most such workloads are hitting a
> >relatively small number of buffers repeatedly, and so caching
> >recently hit buffers is a good idea.
> >
> ...
> 
> I think this needs more testing.

Yes, that's what an "RFC" implies. It's an idea, it's not
fully baked and it's not ready for inclusion - it's a proof of
concept that needs further work, and I't being posted for discussion
to determine if it's worth pursuing further.

Indeed, I haven't proposed it for inclusion yet because I'm
still finding problems caused by the patch - it's still just a
prototype at this point.

> I got the same panic running xfstest 319 with the patch at:
>    http://oss.sgi.com/archives/xfs/2013-09/msg00578.html
> once it hung on a xfs_buf lock before the panic.
> 
> And these are the only tests that I threw at this patch.

Sure. The version I have in my stack at the moment has some more
ixes in it, like handling of length mismatches due to stale buffers
on lookaside lookups, and other such things.

i.e. early feedback on prototype code is exactly what [RFC] patches
are for...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
