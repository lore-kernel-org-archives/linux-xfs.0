Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E5D267CBF
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 16:46:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D1E22304039
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 14:46:07 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id 8jivOAZLDP2pf52F (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 24 May 2013 14:46:06 -0700 (PDT)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 24 May 2013 15:46:06 -0600
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id CAC7C6E803A
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 17:45:29 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r4OLjXbV285606 for <xfs@oss.sgi.com>; Fri, 24 May 2013 17:45:33 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r4OLjWNb028687 for <xfs@oss.sgi.com>; Fri, 24 May 2013 18:45:33 -0300
Subject: Re: [PATCH v8 1/5] xfs: Remove incore use of XFS_OQUOTA_ENFD and
	XFS_OQUOTA_CHKD
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130517025515.GM24635@dastard>
References: <1368220889-25188-1-git-send-email-sekharan@us.ibm.com>
	<1368220889-25188-2-git-send-email-sekharan@us.ibm.com>
	<20130517025515.GM24635@dastard>
Date: Fri, 24 May 2013 16:45:31 -0500
Message-ID: <1369431931.9551.933.camel@chandra-dt.ibm.com>
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

On Fri, 2013-05-17 at 12:55 +1000, Dave Chinner wrote: 
> On Fri, May 10, 2013 at 04:21:25PM -0500, Chandra Seetharaman wrote:
> > Remove all incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD. Instead,
> > start using XFS_GQUOTA_.* XFS_PQUOTA_.* counterparts for GQUOTA and
> > PQUOTA respectively.
> > 
> > On-disk copy still uses XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD.
> > 
> > Read and write of the superblock does the conversion from *OQUOTA*
> > to *[PG]QUOTA*.
> > 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_mount.c       |   41 +++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_qm.c          |    9 ++++++---
> >  fs/xfs/xfs_qm_syscalls.c |   39 +++++++++++++++++++++------------------
> >  fs/xfs/xfs_quota.h       |   42 ++++++++++++++++++++++++++++--------------
> >  fs/xfs/xfs_quotaops.c    |    6 ++++--
> >  fs/xfs/xfs_super.c       |   16 ++++++++--------
> >  fs/xfs/xfs_trans_dquot.c |    4 ++--
> >  7 files changed, 110 insertions(+), 47 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index f6bfbd7..1b79906 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -564,6 +564,8 @@ xfs_sb_from_disk(
> >  	struct xfs_sb	*to,
> >  	xfs_dsb_t	*from)
> >  {
> > +	bool force_quota_check = false;
> > +
> >  	to->sb_magicnum = be32_to_cpu(from->sb_magicnum);
> >  	to->sb_blocksize = be32_to_cpu(from->sb_blocksize);
> >  	to->sb_dblocks = be64_to_cpu(from->sb_dblocks);
> > @@ -599,6 +601,21 @@ xfs_sb_from_disk(
> >  	to->sb_uquotino = be64_to_cpu(from->sb_uquotino);
> >  	to->sb_gquotino = be64_to_cpu(from->sb_gquotino);
> >  	to->sb_qflags = be16_to_cpu(from->sb_qflags);
> > +	if ((to->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) &&
> > +			(to->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
> > +				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))) {
> > +		xfs_notice(NULL, "Super block has XFS_OQUOTA bits along with "
> > +		    "XFS_PQUOTA and/or XFS_GQUOTA bits. Quota check forced.\n");
> > +		force_quota_check = true;
> > +	}
> 
> We can't do these quota check manipulations to the superblock quota
> flags during disk->incore translation anymore - there is more than
> one place that converts the superblock from on-disk to incore format
> (e.g.  the verification callbacks) and so emitting this message when
> we are *writing* the superblock is not good.
> 
> Also, if the XFS_PQUOTA_CHKD/XFS_PQUOTA_ENFD flags are set and
> the superblock is not a V5 superblock, then I think we should refuse
> to mount the filesystem because that is an invalid state - those
> flags should only be set now on a V5 superblock, and never at any
> other time. Hence this specific check should probably be moved to
> xfs_mount_validate_sb() and cause an EFSCORRUPTED return if it
> fails. That will catch something setting the flags incorrectly (i.e.
> at superblock write) as well as prevent mounting in this situation.
> 
> I know, this is different to what I've said in the past, but the
> on-disk format checking is now a lot stricter and so I think that if
> the filesystem is in some kind of wierd state we should just throw
> an error and let the administrator work out how this problem
> happened and how to resolve it.
> 

will do.

> > +	if (to->sb_qflags & XFS_OQUOTA_ENFD)
> > +		to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
> > +					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
> > +	if (to->sb_qflags & XFS_OQUOTA_CHKD)
> > +		to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
> > +					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
> > +	to->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
> > +
> 
> This translation of the quota flags needs to be external to
> this function, and then only called in the mount path where we are
> initially setting up the in-core superblock (i.e. in xfs_readsb())
> because that is the only place where the incore values are
> permanently stored.
> 
> > @@ -636,11 +656,30 @@ xfs_sb_to_disk(
> >  	xfs_sb_field_t	f;
> >  	int		first;
> >  	int		size;
> > +	__uint16_t	qflags = from->sb_qflags;
> >  
> >  	ASSERT(fields);
> >  	if (!fields)
> >  		return;
> >  
> > +	if (fields & XFS_SB_QFLAGS) {
> > +		/*
> > +		 * The in-core version of sb_qflags do not have
> > +		 * XFS_OQUOTA_* flags, whereas the on-disk version
> > +		 * does.  So, convert incore XFS_{PG}QUOTA_* flags 
> > +		 * to on-disk XFS_OQUOTA_* flags.
> > +		 */
> > +		qflags &= ~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
> > +				XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
> > +
> > +		if (from->sb_qflags &
> > +				(XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
> > +			qflags |= XFS_OQUOTA_ENFD;
> > +		if (from->sb_qflags &
> > +				(XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))
> > +			qflags |= XFS_OQUOTA_CHKD;
> > +	}
> 
> Given that we have a new superblock version, we can write the new
> XFS_[PG]QUOTA_CHKD/XFS_[PG]QUOTA_ENFD flags directly into the
> sb_qflags knowing that we can't get an older kernel to interpret
> these new fields because they'll fail the superblck version test. So
> that would mean we only need to do this translation for filesystems
> for non-v5 superblock filesystems.
> 
> Ah, I see that in a later patch you introduce
> xfs_sb_version_has_pquota() and modify this code path to do
> something similar, and it becomes rather complex and nasty.
> 
> OK, I know this is a bit of work, but can you introduce
> xfs_sb_version_has_pquota() in this patch (as we already have the
> pquota inode defined in the on-disk format) as:
> 
> static inline int xfs_sb_version_haspquota(xfs_sb_t *sbp)
> {
>         return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
> }
> 
> and make these OQUOTA flag translations dependent on this not being
> set right from the start?

I am starting to use pquotino only in patch 3, and hence introduced the
above helper in that patch. IMO, it would be helpful w.r.t readability
and patch coherency, if I leave the introduction in patch 3.
> 
> Also, given how nasty this manipulation ends up, can you push it out
> into a function that is called from xfs_sb_to_disk(). That way
> xfs_sb_to_disk() doesn't end up mostly being 70% quota field
> manipulation code...

I will talk about this in patch 3. 
> 
> 
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
> 
> These become new on-disk fields for xfs_sb_version_haspquota()
> filesystems, so they are not specifically in-core values.

will fix. 
> 
> Other than these to/from disk changes, the patch looks fine.
> 
> Cheers,
> 
> Dave.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
