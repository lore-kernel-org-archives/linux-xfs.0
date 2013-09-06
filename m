Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1E3A17F54
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 16:50:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E44C2AC001
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 14:50:41 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	oltv5I29CntYftSg for <xfs@oss.sgi.com>;
	Fri, 06 Sep 2013 14:50:40 -0700 (PDT)
Date: Sat, 7 Sep 2013 07:50:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 40/55] xfs: make struct xfs_perag kernel only
Message-ID: <20130906215037.GF12541@dastard>
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-41-git-send-email-david@fromorbit.com>
	<522A199D.9040509@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <522A199D.9040509@sgi.com>
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

On Fri, Sep 06, 2013 at 01:06:21PM -0500, Mark Tinguely wrote:
> On 09/04/13 17:05, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >The struct xfs_perag has many kernel-only definitions in it,
> >requiring a __KERNEL__ guard so userspace can use it to. Move it to
> >xfs_mount.h so that it it kernel-only, and let userspace redefine
> >it's own version of the structure containing only what it needs.
> >This gets rid of another __KERNEL__ check in the XFS header files.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> 
> Yeah, this is the end of the kernel / user sync part of the series.
> Thanks Dave.
> 
> The major difference seem to come from this series user patch 31/55.
> 
> Other differences between kernel/user header/sources are in:
> include major difference to TOT:
> struct xfs_perag is in xfs_ag.h user and xfs_mount.h in kernel.

It is in include/libxfs.h in userspace, as it is different to the
version that the kernel uses.

> some differences between
> xfs_alloc_btree.c xfs_bmap_btree.c

btree trace code is the difference here - that needs to be unified
but userspace has different infrastructure right now. Not important
right now.

> xfs_btree.c

readahead functions are missing. userspace defined readhead to a
nop, so not a high priority. It should be done, though.

> xfs_ialloc_btree.c

btree trace code again.

> xfs_inode_buf.c

Doesn't have the new log readahead verifier support, and doesn't do
the "no inode read on create" shortcut which we shouldn't do in
userspace, anyway. Minor differences, not immediately important.

Oh, uuid/platform_uuid thingy. Will need to clean that up, too, on
the next round of updates.

> xfs_rtalloc.c

Not yet split up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
