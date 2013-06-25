Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1D8507F37
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 00:32:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F16E98F8033
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 22:32:33 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	KEKJCA8dxZ24jptL for <xfs@oss.sgi.com>;
	Mon, 24 Jun 2013 22:32:32 -0700 (PDT)
Date: Tue, 25 Jun 2013 15:32:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v9 2/6] xfs: Remove incore use of XFS_OQUOTA_ENFD and
	XFS_OQUOTA_CHKD
Message-ID: <20130625053227.GS29376@dastard>
References: <1372042107-27332-1-git-send-email-sekharan@us.ibm.com>
	<1372042107-27332-3-git-send-email-sekharan@us.ibm.com>
	<20130624055921.GM29376@dastard>
	<1372112724.22504.77.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372112724.22504.77.camel@chandra-dt.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 24, 2013 at 05:25:24PM -0500, Chandra Seetharaman wrote:
> On Mon, 2013-06-24 at 15:59 +1000, Dave Chinner wrote:
> > On Sun, Jun 23, 2013 at 09:48:23PM -0500, Chandra Seetharaman wrote:
> > > Remove all incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD. Instead,
> > > start using XFS_GQUOTA_.* XFS_PQUOTA_.* counterparts for GQUOTA and
> > > PQUOTA respectively.
> > > 
> > > On-disk copy still uses XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD.
> > > 
> > > Read and write of the superblock does the conversion from *OQUOTA*
> > > to *[PG]QUOTA*.
> > > 
> > > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > > ---
> > >  fs/xfs/xfs_mount.c       |   46 ++++++++++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/xfs_qm.c          |    9 ++++++---
> > >  fs/xfs/xfs_qm_syscalls.c |   39 +++++++++++++++++++++------------------
> > >  fs/xfs/xfs_quota.h       |   42 ++++++++++++++++++++++++++++--------------
> > >  fs/xfs/xfs_quotaops.c    |    6 ++++--
> > >  fs/xfs/xfs_super.c       |   16 ++++++++--------
> > >  fs/xfs/xfs_trans_dquot.c |    4 ++--
> > >  7 files changed, 115 insertions(+), 47 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > index 6a19434..e2e14cb 100644
> > > --- a/fs/xfs/xfs_mount.c
> > > +++ b/fs/xfs/xfs_mount.c
> > > @@ -336,6 +336,14 @@ xfs_mount_validate_sb(
> > >  		return XFS_ERROR(EWRONGFS);
> > >  	}
> > >  
> > > +	if ((sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) &&
> > > +			(sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
> > > +				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))) {
> > > +		xfs_notice(mp,
> > > +"Super block has XFS_OQUOTA bits along with XFS_PQUOTA and/or XFS_GQUOTA bits.\n");
> > > +		return XFS_ERROR(EFSCORRUPTED);
> > > +	}
> > > +
> > >  	/*
> > >  	 * Version 5 superblock feature mask validation. Reject combinations the
> > >  	 * kernel cannot support up front before checking anything else. For
> > > @@ -622,6 +630,35 @@ xfs_sb_from_disk(
> > >  	to->sb_lsn = be64_to_cpu(from->sb_lsn);
> > >  }
> > >  
> > > +static inline void
> > > +xfs_handle_quota_to_disk(
> > > +	xfs_dsb_t	*to,
> > > +	xfs_sb_t	*from,
> > > +	__int64_t	*fields)
> > 
> > An "XFS handle" has meaning in the namespace (i.e. an XFS filehandle
> > as used in xfs_ioctl.c and defined in xfs_fs.h, so this is not a
> > good name.
> > 
> > Realistically, xfs_sb_qflags_to_disk() is more appropriate for it's
> > function....
> 
> I agree with your "handle" comment.
> 
> As you can see in patch 4/6, PQUOTINO logic is also added to this
> function. Can you suggest a name inclusive of that ?

xfs_sb_quota_to/from_disk()?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
