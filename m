Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A97957F37
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 06:35:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 97D8830405F
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 04:35:46 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	lqYDTzL5lUzqF8wy for <xfs@oss.sgi.com>;
	Tue, 30 Apr 2013 04:35:41 -0700 (PDT)
Date: Tue, 30 Apr 2013 21:35:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Don't keep silent if sunit/swidth can not be
	changed via mount
Message-ID: <20130430113514.GA10481@dastard>
References: <517E5D12.5010809@oracle.com> <20130430073659.GH23072@dastard>
	<517F78D2.5020503@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <517F78D2.5020503@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Apr 30, 2013 at 03:54:58PM +0800, Jeff Liu wrote:
> On 04/30/2013 03:36 PM, Dave Chinner wrote:
> > On Mon, Apr 29, 2013 at 07:44:18PM +0800, Jeff Liu wrote:
> >> ---
> >>  fs/xfs/xfs_mount.c |    7 +++++++
> >>  1 file changed, 7 insertions(+)
> >>
> >> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> >> index 3806088..bc7fdd4 100644
> >> --- a/fs/xfs/xfs_mount.c
> >> +++ b/fs/xfs/xfs_mount.c
> >> @@ -924,6 +924,13 @@ xfs_update_alignment(xfs_mount_t *mp)
> >>  				sbp->sb_width = mp->m_swidth;
> >>  				mp->m_update_flags |= XFS_SB_WIDTH;
> >>  			}
> >> +		} else {
> >> +			xfs_warn(mp, "can not change alignment: "
> >> +				"no data alignment on superblock");
> >> +			if (mp->m_flags & XFS_MOUNT_RETERR)
> >> +				return XFS_ERROR(EINVAL);
> >> +			mp->m_dalign = 0;
> >> +			mp->m_swidth = 0;
> > 
> > Can someone tell me why the XFS_MOUNT_RETERR flag exists?
> This is really a very opportune response because I also worked out
> another tiny patch for removing XFS_MOUNT_RETERR a few minutes ago,
> just hesitating if I missed anything or not.

Excellent - you're one step ahead of me :)

> > It looks like dead code to me as the only time mp->m_dalign is set
> > prior to calling xfs_update_alignment() is the same code that sets
> > XFS_MOUNT_RETERR in xfs_parseargs().
> > 
> > IOWs, any time we enter this "if (mp->m_dalign)" branch in
> > xfs_update_alignment(), XFS_MOUNT_RETERR is going to be set and so
> > we should always be emitting a warning and returning an error.
> Yes, I realized that as I can not trigger a warning only, it always
> returning an error to me. :(
> > 
> > If this is correct, Jeff, can you remove the XFS_MOUNT_RETERR flag
> > and get rid of all the dead code in xfs_update_alignment() at the
> > same time, please?
> Sure, I'll post this patch tonight together with another initial patch
> for fixing transaction space over-reservation we have discussed two
> weeks ago, xfstests is running now.

I'll have a look when it appears on the list ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
