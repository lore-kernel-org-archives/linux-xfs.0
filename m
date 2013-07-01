Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D44C67F55
	for <xfs@oss.sgi.com>; Mon,  1 Jul 2013 10:50:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A0C668F8037
	for <xfs@oss.sgi.com>; Mon,  1 Jul 2013 08:50:46 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id c517jjZMn1QNVidk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Jul 2013 08:50:45 -0700 (PDT)
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 1 Jul 2013 09:50:44 -0600
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id B792419D8043
	for <xfs@oss.sgi.com>; Mon,  1 Jul 2013 09:50:33 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r61FoVgX140866 for <xfs@oss.sgi.com>; Mon, 1 Jul 2013 09:50:40 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r61FoU2N012008
	for <xfs@oss.sgi.com>; Mon, 1 Jul 2013 09:50:30 -0600
Subject: Re: [PATCH v9 4/6] xfs: Start using pquotaino from the superblock.
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130625063135.GU29376@dastard>
References: <1372042107-27332-1-git-send-email-sekharan@us.ibm.com>
	<1372042107-27332-5-git-send-email-sekharan@us.ibm.com>
	<20130625063135.GU29376@dastard>
Date: Mon, 01 Jul 2013 10:50:30 -0500
Message-ID: <1372693830.9777.4.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

I sent this email on 6/25 (just before my reply on 5/6 w.r.t adding the
test to xfstests). Since I didn't get any response from you on this and
got reply on the other one, I concluded that you accepted my
justification/clarification.

I just looked at the archives and do not see my original email :(... but
is intact in my sent folder!!

Please see if my justification below is valid.

Chandra

On Tue, 2013-06-25 at 16:31 +1000, Dave Chinner wrote:
> On Sun, Jun 23, 2013 at 09:48:25PM -0500, Chandra Seetharaman wrote:
> > Start using pquotino and define a macro to check if the
> > superblock has pquotino.
> > 
> > Keep backward compatibilty by alowing mount of older superblock
> > with no separate pquota inode.
> > 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > ---
> >  fs/xfs/xfs_fsops.c             |    3 +-
> >  fs/xfs/xfs_mount.c             |   51 +++++++++++++++++++++++++++++++--------
> >  fs/xfs/xfs_qm.c                |   22 +++++++++--------
> >  fs/xfs/xfs_qm_syscalls.c       |   24 ++++++++++++++++--
> >  fs/xfs/xfs_quota.h             |    8 ------
> >  fs/xfs/xfs_sb.h                |   16 +++++++++++-
> >  fs/xfs/xfs_super.c             |   14 ++++++----
> >  include/uapi/linux/dqblk_xfs.h |    1 +
> >  8 files changed, 99 insertions(+), 40 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index 614eb0c..3bf05f4 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -501,7 +501,8 @@ xfs_growfs_data_private(
> >  				error, agno);
> >  			break;
> >  		}
> > -		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, XFS_SB_ALL_BITS);
> > +		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb,
> > +				xfs_sb_all_bits(&mp->m_sb));
> 
> I think you could still pass XFS_SB_ALL_BITS to xfs_sb_to_disk(),
> and do the XFS_SB_PQUOTINO filtering inside xfs_sb_quota_to_disk().
> 
> Actually xfs_sb_all_bits() is only used here, and it seems to me
> that it is not necessary as we do a pquota support check inside
> xfs_sb_to_disk() and can handle this in that place...

Yes, this is the only place that uses XFS_SB_ALL_BITS, and the purpose
is to copy over the superblock to secondary.

The change I made ensures that the caller does what is correct. i.e if
it is copying an earlier version of superblock, it does not try to copy
the pquotino, and if it uses the newer version of superblock it copies
over the pquotino.

At some point (in my internal tree) I did have the way you suggested.
But, doing it that way looked like a band-aid/hack, and felt this is the
right way to do it (since the caller should provide appropriate
information to the function).
> 
> >  
> >  		/*
> >  		 * If we get an error writing out the alternate superblocks,
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index e2e14cb..bb7b23e 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -336,12 +336,17 @@ xfs_mount_validate_sb(
> >  		return XFS_ERROR(EWRONGFS);
> >  	}
> >  
> > -	if ((sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) &&
> > -			(sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
> > -				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))) {
> > -		xfs_notice(mp,
> > -"Super block has XFS_OQUOTA bits along with XFS_PQUOTA and/or XFS_GQUOTA bits.\n");
> > -		return XFS_ERROR(EFSCORRUPTED);
> > +	if (xfs_sb_version_has_pquota(sbp)) {
> > +		if (sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
> > +			xfs_notice(mp,
> > +			   "Version 5 of Super block has XFS_OQUOTA bits.\n");
> > +			return XFS_ERROR(EFSCORRUPTED);
> > +		}
> > +	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
> > +				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
> > +			xfs_notice(mp,
> > +"Superblock earlier than Version 5 has XFS_[PQ]UOTA_{ENFD|CHKD} bits.\n");
> > +			return XFS_ERROR(EFSCORRUPTED);
> 
> [ xfs_alert() for those, I think. ]

will do.

> 
> > @@ -638,6 +643,13 @@ xfs_handle_quota_to_disk(
> >  {
> >  	__uint16_t	qflags = from->sb_qflags;
> >  
> > +	/*
> > +	 * We need to do these manipilations only if we are working
> > +	 * with an older version of on-disk superblock.
> > +	 */
> > +	if (xfs_sb_version_has_pquota(from))
> > +		return;
> > +
> >  	if (*fields & XFS_SB_QFLAGS) {
> >  		/*
> >  		 * The in-core version of sb_qflags do not have
> 
> xfs_sb_all_bits() does:
> 
> 	if (xfs_sb_version_has_pquota(sbp))
> 		return XFS_SB_ALL_BITS;
> 	return XFS_SB_ALL_BITS & ~XFS_SB_PQUOTINO;
> 
> which means that we enter xfs_handle_quota_to_disk() with
> XFS_SB_ALL_BITS intact for the pquota case, but without it in the
> non-pquota case. Hence if we don't have pquota set, we continue
> onwards and....
> 
> > @@ -657,6 +669,10 @@ xfs_handle_quota_to_disk(
> >  		to->sb_qflags = cpu_to_be16(qflags);
> >  		*fields &= ~XFS_SB_QFLAGS;
> >  	}
> > +	if (*fields & XFS_SB_PQUOTINO) {
> > +		to->sb_gquotino = cpu_to_be64(from->sb_pquotino);
> > +		*fields &= ~XFS_SB_PQUOTINO;
> > +	}
> 
> We will never do this because we've already cleared XFS_SB_PQUOTINO
> before we entered xfs_sb_to_disk(). That doesn't seem right to me... 

Yes, if we are using a version of superblock where pquotino should not
be used, we do not want to get into this block.

If we are using PQUOTA in the superblock, that inode information will be
in gquotino and will be converted over appropriately in
xfs_sb_to_disk().

> 
> > @@ -1524,8 +1524,10 @@ xfs_qm_init_quotainos(
> >  		flags &= ~XFS_QMOPT_SBVERSION;
> >  	}
> >  	if (XFS_IS_PQUOTA_ON(mp) && pip == NULL) {
> > +		if (!xfs_sb_version_has_pquota(&mp->m_sb))
> > +			sbflags &= ~XFS_SB_GQUOTINO;
> 
> That's taken me a while to work out - it needs a comment explaining
> why XFS_SB_GQUOTINO is being cleared here.

will do.
> 
> >  		error = xfs_qm_qino_alloc(mp, &pip,
> > -					  sbflags | XFS_SB_GQUOTINO,
> > +					  sbflags | XFS_SB_PQUOTINO,
> >  					  flags | XFS_QMOPT_PQUOTA);
> >  		if (error)
> >  			goto error_rele;
> > diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> > index ed7cd55..d664a2d 100644
> > --- a/fs/xfs/xfs_qm_syscalls.c
> > +++ b/fs/xfs/xfs_qm_syscalls.c
> > @@ -201,8 +201,7 @@ xfs_qm_scall_quotaoff(
> >  	/*
> >  	 * If quotas is completely disabled, close shop.
> >  	 */
> > -	if (((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_SET1) ||
> > -	    ((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_SET2)) {
> > +	if ((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_ALL) {
> >  		mutex_unlock(&q->qi_quotaofflock);
> >  		xfs_qm_destroy_quotainfo(mp);
> >  		return (0);
> 
> This makes the assumption that userspace passes all three quota
> types into the kernel in a single quota off call as the only way to
> turn quotas off completely. What happens if they are turned off one
> at a time? Shouldn't we detect when no more quotas are actually
> enabled and then do this?

Yes, I agree that there is a difference in behavior if the user turns
off quota one-by-one Vs turns off all quota at once. But, the behavior
difference is not seen by the user space.  And, I did not make the
change :)

I just included project quota into the fold.

> 
> Cheers,
> 
> Dave.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
