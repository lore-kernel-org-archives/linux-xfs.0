Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RLHFN5170521 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 16:17:15 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	oiMPL3uEJOM7tlFY for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 14:17:13 -0700 (PDT)
Date: Wed, 28 Mar 2012 08:16:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: check on-disk (not incore) btree root size in dfrag.c
Message-ID: <20120327211651.GD5091@dastard>
References: <4F7225BA.40200@redhat.com>
 <4F722828.4000102@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F722828.4000102@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Gabriel VLASIU <gabriel@vlasiu.net>, xfs-oss <xfs@oss.sgi.com>

On Tue, Mar 27, 2012 at 03:50:48PM -0500, Eric Sandeen wrote:
> On 3/27/12 3:40 PM, Eric Sandeen wrote:
> > xfs_swap_extents_check_format() contains checks to make sure that
> > original and the temporary files during defrag are compatible;
> > Gabriel VLASIU ran into a case where xfs_fsr returned EINVAL
> > because the tests found the btree root to be of size 120,
> > while the fork offset was only 104; IOW, they overlapped.
> > 
> > However, this is just due to an error in the
> > xfs_swap_extents_check_format() tests, because it is checking
> > the in-memory btree root size against the on-disk fork offset.
> > We should be checking the on-disk sizes in both cases.
> > 
> > This patch adds a new macro to calculate this size, and uses
> > it in the tests.
> > 
> > With this change, the filesystem image provided by Gabriel
> > allows for proper file degragmentation.
> 
> Hm, as usually happens right after finalizing this I stumbled
> on something else.  xfs_iroot_realloc() does essentially the same
> test, but uses a funky macro to resolve the incore/ondisk size
> difference:
> 
>         ASSERT(ifp->if_broot_bytes <=
>                 XFS_IFORK_SIZE(ip, whichfork) + XFS_BROOT_SIZE_ADJ);
> 
> so dfrag.c could be fixed up the same way, I suppose, using
> XFS_BROOT_SIZE_ADJ if desired (though I have no real love for that
> undocumented macro!)

I much prefer the addition of a XFS_BMAP_BMDR_SPACE() macro. Perhaps
it might be worthwhile to convert those uses of XFS_BROOT_SIZE_ADJ
to use your new macro, and get rid of the XFS_BROOT_SIZE_ADJ grot
altogether?

Anyway, consider your patch:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
