Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HJ5Fem103487 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 13:05:15 -0600
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id Pjp5iJSsx5I3uIw4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Feb 2012 11:05:14 -0800 (PST)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 17 Feb 2012 14:05:14 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id CE8BE38C8080
	for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 14:05:11 -0500 (EST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q1HJ5BQL321264 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 14:05:11 -0500
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id q1HJ56h9019573
	for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 12:05:07 -0700
Subject: Re: [RFC v3 PATCH 1/4] xfs: Remove incore use of XFS_OQUOTA_ENFD
	and XFS_OQUOTA_CHKD
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20120217160915.GD7762@sgi.com>
References: <20120123173158.31640.30333.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120123173204.31640.53918.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120217160915.GD7762@sgi.com>
Date: Fri, 17 Feb 2012 13:05:05 -0600
Message-ID: <1329505505.2213.59.camel@chandra-lucid.austin.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

oops. will clean up and resend.

sorry.
On Fri, 2012-02-17 at 10:09 -0600, Ben Myers wrote:
> Hi Chandra,
> 
> Here are some cleanups caught by the script in 
> scripts/checkpatch.pl
> 
> On Mon, Jan 23, 2012 at 11:32:04AM -0600, Chandra Seetharaman wrote:
> > Define new macros XFS_GQUOTA_ENFD, XFS_GQUOTA_CHKD, XFS_PQUOTA_ENFD, and
> > XFS_PQUOTA_CHKD.
> > 
> > Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD. Instead,
> > start using XFS_GQUOTA_.* XFS_PQUOTA_.* counterparts. 
> > 
> > No changes is made to the on-disk version of the superblock yet. On-disk
> > copy still uses XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD.
> >  
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > ---
> >  fs/xfs/xfs_mount.c       |   30 ++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_qm.c          |    9 ++++++---
> >  fs/xfs/xfs_qm_syscalls.c |   26 ++++++++++++++------------
> >  fs/xfs/xfs_quota.h       |   36 +++++++++++++++++++++++++-----------
> >  fs/xfs/xfs_quotaops.c    |    6 ++++--
> >  fs/xfs/xfs_super.c       |   16 ++++++++--------
> >  fs/xfs/xfs_trans_dquot.c |    4 ++--
> >  7 files changed, 89 insertions(+), 38 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> > index b50ec5b..d7205b0 100644
> > --- a/fs/xfs/xfs_quota.h
> > +++ b/fs/xfs/xfs_quota.h
> > @@ -152,19 +152,34 @@ typedef struct xfs_qoff_logformat {
> >  #define XFS_GQUOTA_ACCT	0x0040  /* group quota accounting ON */
> >  
> >  /*
> > + * Start differentiating group quota and project quota in-core
> > + * using distinct flags, instead of using the combined OQUOTA flags.
> > + *
> > + * Conversion to and from the combined OQUOTA flag (if necessary)
> > + * is done only in xfs_sb_{to,from}_disk()
> > + */
> > +#define XFS_GQUOTA_ENFD	0x0080  /* group quota limits enforced */
> > +#define XFS_GQUOTA_CHKD	0x0100  /* quotacheck run on group quotas */
> > +#define XFS_PQUOTA_ENFD	0x0200  /* project quota limits enforced */
> > +#define XFS_PQUOTA_CHKD	0x0400  /* quotacheck run on project quotas */
> > +
> > +/*
> >   * Quota Accounting/Enforcement flags
> >   */
> >  #define XFS_ALL_QUOTA_ACCT	\
> >  		(XFS_UQUOTA_ACCT | XFS_GQUOTA_ACCT | XFS_PQUOTA_ACCT)
> > -#define XFS_ALL_QUOTA_ENFD	(XFS_UQUOTA_ENFD | XFS_OQUOTA_ENFD)
> > -#define XFS_ALL_QUOTA_CHKD	(XFS_UQUOTA_CHKD | XFS_OQUOTA_CHKD)
> > +#define XFS_ALL_QUOTA_ENFD	\
> > +		(XFS_UQUOTA_ENFD | XFS_GQUOTA_ENFD | XFS_PQUOTA_ENFD)
> > +#define XFS_ALL_QUOTA_CHKD	\
> > +		(XFS_UQUOTA_CHKD | XFS_GQUOTA_CHKD | XFS_PQUOTA_CHKD)
> >  
> >  #define XFS_IS_QUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
> >  #define XFS_IS_UQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_UQUOTA_ACCT)
> >  #define XFS_IS_PQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_PQUOTA_ACCT)
> >  #define XFS_IS_GQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_GQUOTA_ACCT)
> >  #define XFS_IS_UQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_UQUOTA_ENFD)
> > -#define XFS_IS_OQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_OQUOTA_ENFD)
> > +#define XFS_IS_PQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_PQUOTA_ENFD)
> > +#define XFS_IS_GQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_GQUOTA_ENFD)
> >  
> >  /*
> >   * Incore only flags for quotaoff - these bits get cleared when quota(s)
> > @@ -259,24 +274,23 @@ typedef struct xfs_qoff_logformat {
> >  	((XFS_IS_UQUOTA_ON(mp) && \
> >  		(mp->m_sb.sb_qflags & XFS_UQUOTA_CHKD) == 0) || \
> >  	 (XFS_IS_GQUOTA_ON(mp) && \
> > -		((mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD) == 0 || \
> > -		 (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT))) || \
> > +		(mp->m_sb.sb_qflags & XFS_GQUOTA_CHKD) == 0) || \
> >  	 (XFS_IS_PQUOTA_ON(mp) && \
> > -		((mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD) == 0 || \
> > -		 (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT))))
> > +		(mp->m_sb.sb_qflags & XFS_PQUOTA_CHKD) == 0))
> >  
> >  #define XFS_MOUNT_QUOTA_SET1	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
> >  				 XFS_UQUOTA_CHKD|XFS_PQUOTA_ACCT|\
> > -				 XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD)
> > +				 XFS_PQUOTA_ENFD|XFS_PQUOTA_CHKD)
> >  
> >  #define XFS_MOUNT_QUOTA_SET2	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
> >  				 XFS_UQUOTA_CHKD|XFS_GQUOTA_ACCT|\
> > -				 XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD)
> > +				 XFS_GQUOTA_ENFD|XFS_GQUOTA_CHKD)
> >  
> >  #define XFS_MOUNT_QUOTA_ALL	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
> >  				 XFS_UQUOTA_CHKD|XFS_PQUOTA_ACCT|\
> > -				 XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD|\
> > -				 XFS_GQUOTA_ACCT)
> > +				 XFS_PQUOTA_ENFD|XFS_PQUOTA_CHKD|\
> > +				 XFS_GQUOTA_ACCT|XFS_GQUOTA_ENFD|\
> > +				 XFS_GQUOTA_CHKD)
> >  
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 25e9908..64313e4 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -593,6 +593,20 @@ xfs_sb_from_disk(
> >  	to->sb_uquotino = be64_to_cpu(from->sb_uquotino);
> >  	to->sb_gquotino = be64_to_cpu(from->sb_gquotino);
> >  	to->sb_qflags = be16_to_cpu(from->sb_qflags);
> > +	if ((to->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) &&
> > +			(to->sb_qflags & (XFS_PQUOTA_ENFD |XFS_GQUOTA_ENFD |
> 
> ERROR: need consistent spacing around '|' (ctx:WxV)
> #115: FILE: fs/xfs/xfs_mount.c:597:
> +                       (to->sb_qflags & (XFS_PQUOTA_ENFD |XFS_GQUOTA_ENFD |
>                                                           ^
> 
> > +				XFS_PQUOTA_CHKD| XFS_GQUOTA_CHKD))) {
> 
> ERROR: need consistent spacing around '|' (ctx:VxW)
> #116: FILE: fs/xfs/xfs_mount.c:598:
> +                               XFS_PQUOTA_CHKD| XFS_GQUOTA_CHKD))) {
>                                                ^
> 
> 
> > +		xfs_notice(mp, "Super block has XFS_OQUOTA bits along with "
> > +			"XFS_PQUOTA and/or XFS_GQUOTA bits. Fixing it.\n");
> > +	}
> > +	if (to->sb_qflags & XFS_OQUOTA_ENFD)
> > +		to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
> > +					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
> > +	if (to->sb_qflags & XFS_OQUOTA_CHKD)
> > +		to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
> > +					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
> > +	to->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
> > +
> >  	to->sb_flags = from->sb_flags;
> >  	to->sb_shared_vn = from->sb_shared_vn;
> >  	to->sb_inoalignmt = be32_to_cpu(from->sb_inoalignmt);
> > @@ -622,11 +636,26 @@ xfs_sb_to_disk(
> >  	xfs_sb_field_t	f;
> >  	int		first;
> >  	int		size;
> > +	__be16		saved_qflags;
> >  
> >  	ASSERT(fields);
> >  	if (!fields)
> >  		return;
> >  
> > +	/*
> > +	 * in-core version of qflags do not have XFS_OQUOTA.*, whereas the
> > + 	 * on-disk version does. So, save the in-core sb_qflags and restore
> 
> ERROR: code indent should use tabs where possible
> #143: FILE: fs/xfs/xfs_mount.c:647:
> + ^I * on-disk version does. So, save the in-core sb_qflags and restore$
> 
> WARNING: please, no space before tabs
> #143: FILE: fs/xfs/xfs_mount.c:647:
> + ^I * on-disk version does. So, save the in-core sb_qflags and restore$
> 
> 
> 
> > +	 * it after we modify and copy it to the buffer to be copied to
> > +	 * disk.
> > +	 */
> > +	saved_qflags = from->sb_qflags;
> > +
> > +	if (from->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
> > +		from->sb_qflags |= XFS_OQUOTA_ENFD;
> > +	if (from->sb_qflags & (XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))
> > +		from->sb_qflags |= XFS_OQUOTA_CHKD;
> > +	from->sb_qflags &= ~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
> > +					XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
> >  	while (fields) {
> >  		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
> >  		first = xfs_sb_info[f].offset;
> > @@ -657,6 +686,7 @@ xfs_sb_to_disk(
> >  
> >  		fields &= ~(1LL << f);
> >  	}
> > +	from->sb_qflags = saved_qflags;
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index 1b2f5b3..bb8c2ac 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -313,8 +313,10 @@ xfs_qm_mount_quotas(
> >  	 */
> >  	if (!XFS_IS_UQUOTA_ON(mp))
> >  		mp->m_qflags &= ~XFS_UQUOTA_CHKD;
> > -	if (!(XFS_IS_GQUOTA_ON(mp) || XFS_IS_PQUOTA_ON(mp)))
> > -		mp->m_qflags &= ~XFS_OQUOTA_CHKD;
> > +	if (!XFS_IS_GQUOTA_ON(mp))
> > +		mp->m_qflags &= ~XFS_GQUOTA_CHKD;
> > +	if (!XFS_IS_PQUOTA_ON(mp))
> > +		mp->m_qflags &= ~XFS_PQUOTA_CHKD;
> >  
> >   write_changes:
> >  	/*
> > @@ -1449,7 +1451,8 @@ xfs_qm_quotacheck(
> >  					XFS_QMOPT_GQUOTA : XFS_QMOPT_PQUOTA);
> >  		if (error)
> >  			goto error_return;
> > -		flags |= XFS_OQUOTA_CHKD;
> > +		flags |= XFS_IS_GQUOTA_ON(mp) ?
> > +					XFS_GQUOTA_CHKD : XFS_PQUOTA_CHKD;
> >  	}
> >  
> >  	do {
> > diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> > index eafbcff..d43c68c 100644
> > --- a/fs/xfs/xfs_qm_syscalls.c
> > +++ b/fs/xfs/xfs_qm_syscalls.c
> > @@ -121,11 +121,11 @@ xfs_qm_scall_quotaoff(
> >  	}
> >  	if (flags & XFS_GQUOTA_ACCT) {
> >  		dqtype |= XFS_QMOPT_GQUOTA;
> > -		flags |= (XFS_OQUOTA_CHKD | XFS_OQUOTA_ENFD);
> > +		flags |= (XFS_GQUOTA_CHKD | XFS_GQUOTA_ENFD);
> >  		inactivate_flags |= XFS_GQUOTA_ACTIVE;
> >  	} else if (flags & XFS_PQUOTA_ACCT) {
> >  		dqtype |= XFS_QMOPT_PQUOTA;
> > -		flags |= (XFS_OQUOTA_CHKD | XFS_OQUOTA_ENFD);
> > +		flags |= (XFS_PQUOTA_CHKD | XFS_PQUOTA_ENFD);
> >  		inactivate_flags |= XFS_PQUOTA_ACTIVE;
> >  	}
> >  
> > @@ -349,9 +349,11 @@ xfs_qm_scall_quotaon(
> >  	    ||
> >  	    ((flags & XFS_PQUOTA_ACCT) == 0 &&
> >  	    (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) == 0 &&
> > -	    (flags & XFS_GQUOTA_ACCT) == 0 &&
> > +	    (flags & XFS_PQUOTA_ENFD))
> > +	    ||
> > +	    ((flags & XFS_GQUOTA_ACCT) == 0 &&
> >  	    (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) == 0 &&
> > -	    (flags & XFS_OQUOTA_ENFD))) {
> > +	    (flags & XFS_GQUOTA_ENFD))) {
> >  		xfs_debug(mp,
> >  			"%s: Can't enforce without acct, flags=%x sbflags=%x\n",
> >  			__func__, flags, mp->m_sb.sb_qflags);
> > @@ -801,8 +803,8 @@ xfs_qm_export_dquot(
> >  	 * so return zeroes in that case.
> >  	 */
> >  	if ((!XFS_IS_UQUOTA_ENFORCED(mp) && src->d_flags == XFS_DQ_USER) ||
> > -	    (!XFS_IS_OQUOTA_ENFORCED(mp) &&
> > -			(src->d_flags & (XFS_DQ_PROJ | XFS_DQ_GROUP)))) {
> > +	    (!XFS_IS_PQUOTA_ENFORCED(mp) && src->d_flags == XFS_DQ_PROJ) || 
> 
> ERROR: trailing whitespace
> #231: FILE: fs/xfs/xfs_qm_syscalls.c:806:
> +^I    (!XFS_IS_PQUOTA_ENFORCED(mp) && src->d_flags == XFS_DQ_PROJ) || $
> 
> I suggest you run the script on your other patches as well... 
> 
> Regards,
> 	Ben
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
