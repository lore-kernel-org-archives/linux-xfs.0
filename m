Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CB2F17F37
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 20:10:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8A8508F8035
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 18:10:05 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id NtLcE3AXyESZy6pS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Jul 2013 18:10:04 -0700 (PDT)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 11 Jul 2013 21:10:03 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id AFAD96E803C
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 21:09:55 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r6C1A0hA380352 for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 21:10:00 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r6C1A0Yf031381 for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 22:10:00 -0300
Subject: Re: [PATCH v11 2/4] xfs: Start using pquotaino from the superblock.
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130711211610.GC20932@sgi.com>
References: <1373518843-1492-1-git-send-email-sekharan@us.ibm.com>
	<1373518843-1492-3-git-send-email-sekharan@us.ibm.com>
	<20130711211610.GC20932@sgi.com>
Date: Thu, 11 Jul 2013 20:09:58 -0500
Message-ID: <1373591398.20769.9.camel@chandra-dt.ibm.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, 2013-07-11 at 16:16 -0500, Ben Myers wrote:
> Hey Chandra,
> 
> On Thu, Jul 11, 2013 at 12:00:41AM -0500, Chandra Seetharaman wrote:
> > Start using pquotino and define a macro to check if the
> > superblock has pquotino.
> > 
> > Keep backward compatibilty by alowing mount of older superblock
> > with no separate pquota inode.
> > 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> Here are a few notes from my review.
> 
> > ---
> >  fs/xfs/xfs_mount.c             |   62 ++++++++++++++++++++++++++++++++++-----
> >  fs/xfs/xfs_qm.c                |   28 +++++++++--------
> >  fs/xfs/xfs_qm_syscalls.c       |   21 +++++++++++++-
> >  fs/xfs/xfs_sb.h                |    9 +++++-
> >  fs/xfs/xfs_super.c             |   19 ++++++------
> >  include/uapi/linux/dqblk_xfs.h |    1 +
> >  6 files changed, 108 insertions(+), 32 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 2b0ba35..b8a633b 100644
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
> 
> xfs_sb_version_has_pquotino might be a better name for this.

will fix
> 
> > +		if (sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
> > +			xfs_notice(mp,
> > +			   "Version 5 of Super block has XFS_OQUOTA bits.\n");
> > +			return XFS_ERROR(EFSCORRUPTED);
> > +		}
> 
> If I'm reading that right... Now if you had a v5 super block with oquota
> bits it will become unmountable.  Could that happen if you were using
> crcs and quotas with a 3.10 kernel and then upgrade?

yes. My thinking is that v5 (with crc) is still experimental and not
supported yet. Not true ?

Previously this was being fixed without failing. But, Dave suggested
that this certainly would be an inconsistent state and hence need to be
failed. I agreed and changed the code.

The problem you stated can be fixed by adding functionality to
xfs_repair. 
> 
> > +	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
> > +				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
> > +			xfs_notice(mp,
> > +"Superblock earlier than Version 5 has XFS_[PQ]UOTA_{ENFD|CHKD} bits.\n");
> > +			return XFS_ERROR(EFSCORRUPTED);
> >  	}
> >  
> >  	/*
> > @@ -570,8 +575,13 @@ out_unwind:
> >  }
> >  
> >  static void
> > -xfs_sb_quota_from_disk(struct xfs_sb *sbp)
> > +xfs_sb_quota_from_disk(struct xfs_mount *mp)
> >  {
> > +	struct xfs_sb *sbp = &mp->m_sb;
> > +
> > +	if (xfs_sb_version_has_pquota(sbp))
> > +		return;
> > +
> >  	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
> >  		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
> >  					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
> > @@ -579,6 +589,18 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
> >  		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
> >  					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
> >  	sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
> > +
> > +	if (!xfs_sb_version_has_pquota(sbp) && (XFS_IS_PQUOTA_ON(mp))) {
> 	    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> I think you already checked for that up above.

will fix.
> 
> > +		/*
> > +		 * On disk superblock only has sb_gquotino, and incore
> > +		 * superblock has both sb_gquotino and sb_pquotino.
> > +		 * But, only one them is supported at any point of time.
> 			only one of them 
> 
> > +		 * So, if PQUOTA is set in disk superblock, copy over
> > +		 * sb_gquotino to sb_pquotino.
> > +		 */
> > +		mp->m_sb.sb_pquotino = mp->m_sb.sb_gquotino;
> > +		mp->m_sb.sb_gquotino = NULLFSINO;
> > +	}
> >  }
> >  
> >  void
> > @@ -650,6 +672,13 @@ xfs_sb_quota_to_disk(
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
> > @@ -669,6 +698,23 @@ xfs_sb_quota_to_disk(
> >  		to->sb_qflags = cpu_to_be16(qflags);
> >  		*fields &= ~XFS_SB_QFLAGS;
> >  	}
> > +
> > +	if (*fields & XFS_SB_PQUOTINO && *fields & XFS_SB_GQUOTINO) {
> > +		/*
> > +		 * PQUOTINO and GQUOTINO cannot be used together in versions
> > +		 * of superblock that do not have pquotino. If used, use
> > +		 * sb_flags to resolve which one should be set.
> > +		*/
> > +		if (from->sb_qflags & XFS_PQUOTA_ACCT)
> > +			*fields &= ~XFS_SB_GQUOTINO;
> > +		else
> > +			*fields &= ~XFS_SB_PQUOTINO;
> > +	}
> > +
> > +	if (*fields & XFS_SB_PQUOTINO) {
> > +		to->sb_gquotino = cpu_to_be64(from->sb_pquotino);
> > +		*fields &= ~XFS_SB_PQUOTINO;
> > +	}
> >  }
> >  
> >  /*
> > @@ -885,7 +931,7 @@ reread:
> >  	 */
> >  	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
> >  
> > -	xfs_sb_quota_from_disk(&mp->m_sb);
> > +	xfs_sb_quota_from_disk(mp);
> >  	/*
> >  	 * We must be able to do sector-sized and sector-aligned IO.
> >  	 */
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index d320794..ba12dc4 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -860,21 +860,24 @@ xfs_qm_qino_alloc(
> >  	if (flags & XFS_QMOPT_SBVERSION) {
> >  		ASSERT(!xfs_sb_version_hasquota(&mp->m_sb));
> >  		ASSERT((sbfields & (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> > -				   XFS_SB_GQUOTINO | XFS_SB_QFLAGS)) ==
> > -		       (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> > -			XFS_SB_GQUOTINO | XFS_SB_QFLAGS));
> > +			XFS_SB_GQUOTINO | XFS_SB_PQUOTINO | XFS_SB_QFLAGS)) ==
> > +				(XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> > +                        XFS_SB_GQUOTINO | XFS_SB_PQUOTINO | XFS_SB_QFLAGS));
> 	^^^^^^^^^^^^^^^^
> Looks like some unwanted spaces in there.
will fix

> 
> >  		xfs_sb_version_addquota(&mp->m_sb);
> >  		mp->m_sb.sb_uquotino = NULLFSINO;
> >  		mp->m_sb.sb_gquotino = NULLFSINO;
> > +		mp->m_sb.sb_pquotino = NULLFSINO;
> >  
> > -		/* qflags will get updated _after_ quotacheck */
> > -		mp->m_sb.sb_qflags = 0;
> > +		/* qflags will get updated fully _after_ quotacheck */
> > +		mp->m_sb.sb_qflags = mp->m_qflags & XFS_ALL_QUOTA_ACCT;
> 
> I didn't quite catch why you changed from 0 to ALL_QUOTA_ACCT here, will
> take another look.

We wanted to move all (well, almost all :) the logic of managing
PQUOTINO/GQUOTINO in older superblock in just the two functions
xfs_sb_quota_to/from_disk(). In order to do that I had to use sb_qflags
(you can see that in xfs_sb_quota_to_disk()). So, we have to have
sb_qflags valid before we try to write these fields to the disk. Hence
this change.

> 
> >  	}
> >  	if (flags & XFS_QMOPT_UQUOTA)
> >  		mp->m_sb.sb_uquotino = (*ip)->i_ino;
> > -	else
> > +	else if (flags & XFS_QMOPT_GQUOTA)
> >  		mp->m_sb.sb_gquotino = (*ip)->i_ino;
> > +	else
> > +		mp->m_sb.sb_pquotino = (*ip)->i_ino;
> >  	spin_unlock(&mp->m_sb_lock);
> >  	xfs_mod_sb(tp, sbfields);
> >  
> > @@ -1484,11 +1487,10 @@ xfs_qm_init_quotainos(
> >  			if (error)
> >  				goto error_rele;
> >  		}
> > -		/* XXX: Use gquotino for now */
> >  		if (XFS_IS_PQUOTA_ON(mp) &&
> > -		    mp->m_sb.sb_gquotino != NULLFSINO) {
> > -			ASSERT(mp->m_sb.sb_gquotino > 0);
> > -			error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
> > +		    mp->m_sb.sb_pquotino != NULLFSINO) {
> > +			ASSERT(mp->m_sb.sb_pquotino > 0);
> > +			error = xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
> >  					     0, 0, &pip);
> >  			if (error)
> >  				goto error_rele;
> > @@ -1496,7 +1498,8 @@ xfs_qm_init_quotainos(
> >  	} else {
> >  		flags |= XFS_QMOPT_SBVERSION;
> >  		sbflags |= (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> > -			    XFS_SB_GQUOTINO | XFS_SB_QFLAGS);
> > +			    XFS_SB_GQUOTINO | XFS_SB_PQUOTINO |
> > +			    XFS_SB_QFLAGS);
> >  	}
> >  
> >  	/*
> > @@ -1524,9 +1527,8 @@ xfs_qm_init_quotainos(
> >  		flags &= ~XFS_QMOPT_SBVERSION;
> >  	}
> >  	if (XFS_IS_PQUOTA_ON(mp) && pip == NULL) {
> > -		/* XXX: Use XFS_SB_GQUOTINO for now */
> >  		error = xfs_qm_qino_alloc(mp, &pip,
> > -					  sbflags | XFS_SB_GQUOTINO,
> > +					  sbflags | XFS_SB_PQUOTINO,
> >  					  flags | XFS_QMOPT_PQUOTA);
> >  		if (error)
> >  			goto error_rele;
> > diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> > index e4f8b2d..132e811 100644
> > --- a/fs/xfs/xfs_qm_syscalls.c
> > +++ b/fs/xfs/xfs_qm_syscalls.c
> > @@ -296,8 +296,10 @@ xfs_qm_scall_trunc_qfiles(
> >  
> >  	if (flags & XFS_DQ_USER)
> >  		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_uquotino);
> > -	if (flags & (XFS_DQ_GROUP|XFS_DQ_PROJ))
> > +	if (flags & XFS_DQ_GROUP)
> >  		error2 = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_gquotino);
> > +	if (flags & XFS_DQ_PROJ)
> > +		error2 = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_pquotino);
> >  
> >  	return error ? error : error2;
> >  }
> > @@ -413,8 +415,10 @@ xfs_qm_scall_getqstat(
> 
> As we discussed on the call:  Now that you've decided to write a new
> interface for this, you can be really light touch here in
> xfs_qm_scall_getqstat().  The new macro in dqblk_xfs.h can also go away.

yes
> 
> Looking good.
> 
> Regards,
> Ben
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
