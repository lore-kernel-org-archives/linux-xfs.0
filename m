Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 99B047F54
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 02:20:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6A633304071
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 00:20:29 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	leHZwFVwtNQITGQz for <xfs@oss.sgi.com>;
	Thu, 02 May 2013 00:20:27 -0700 (PDT)
Date: Thu, 2 May 2013 17:20:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2 v2] xfs: Don't keep silent if sunit/swidth can not be
	changed via mount
Message-ID: <20130502072024.GX10481@dastard>
References: <518125CF.3050806@oracle.com> <20130502011302.GS10481@dastard>
	<51820D8E.7040308@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51820D8E.7040308@oracle.com>
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
Cc: Mark Tinguely <tinguely@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, May 02, 2013 at 02:54:06PM +0800, Jeff Liu wrote:
> On 05/02/2013 09:13 AM, Dave Chinner wrote:
> > On Wed, May 01, 2013 at 10:25:19PM +0800, Jeff Liu wrote:
> >> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> >> index 29e8de8..2836ef6 100644
> >> --- a/fs/xfs/xfs_mount.c
> >> +++ b/fs/xfs/xfs_mount.c
> >> @@ -909,6 +909,10 @@ xfs_update_alignment(xfs_mount_t *mp)
> >>  				sbp->sb_width = mp->m_swidth;
> >>  				mp->m_update_flags |= XFS_SB_WIDTH;
> >>  			}
> >> +		} else {
> >> +			xfs_warn(mp, "cannot change alignment: "
> >> +				 "superblock does not support data alignment");
> > 
> > Same comment again about single line format strings. Otherwise it's
> > ok.
> Ah, sorry! I misunderstood the comments of Mark before. I was bluffed
> into believing that I should cut the length of log string as short as
> possible. :(

Thing of being able cut-n-paste the error message out of the log and
then being able to grep the source tree for it. i.e.

$ git grep "cannot change alignment: superblock does not support data alignment"

Will fail to find anything in the former case, but in the single
line case it will identify the file the error lies in immediately.
So the question I always ask myself is "is that format string easy
to find with grep?" :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
