Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0805B7F58
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 15:32:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 97951AC006
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 13:32:35 -0700 (PDT)
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151]) by
	cuda.sgi.com with ESMTP id wDUHmvD5cBMWnXXC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 12 Jul 2013 13:32:31 -0700 (PDT)
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 12 Jul 2013 20:32:30 -0000
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 352561FF001F
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 14:27:10 -0600 (MDT)
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r6CKWSPS141746 for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 14:32:29 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r6CKZ3NQ032478
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 14:35:03 -0600
Subject: Re: [PATCH] xfs: Start using pquotaino from the superblock.
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130712183030.GE20932@sgi.com>
References: <1373593707.20769.11.camel@chandra-dt.ibm.com>
	<20130712183030.GE20932@sgi.com>
Date: Fri, 12 Jul 2013 15:32:27 -0500
Message-ID: <1373661147.20769.25.camel@chandra-dt.ibm.com>
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
Cc: Jan Kara <jack@suse.cz>, adas@redhat.com, Steven Whitehouse <swhiteho@redhat.com>, XFS mailing list <xfs@oss.sgi.com>

On Fri, 2013-07-12 at 13:30 -0500, Ben Myers wrote:
> Hey Chandra,
> 
<snip>

> > @@ -591,6 +599,19 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
> >  		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
> >  					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
> >  	sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
> > +
> > +	if ((sbp->sb_qflags & XFS_PQUOTA_ACCT) &&
> > +			(sbp->sb_gquotino != NULLFSINO)) {
> 
> If project quota accounting bit is set in the super block 
> and 
> the group quot ino is not nullfsino..
> 
> That's weird.  I would have expected to be able to assume that sb_gquotino is
> not NULLFSINO if project quota accounting is on.  Why was the check necessary?

Thinking now, I should not have added the second part.
(sbp->sb_qflags & XFS_PQUOTA_ACCT) should be sufficient.

> 
> > +		/*
> > +		 * On disk superblock only has sb_gquotino, and incore
> > +		 * superblock has both sb_gquotino and sb_pquotino.
> > +		 * But, only one of them is supported at any point of time.
> > +		 * So, if PQUOTA is set in disk superblock, copy over
> > +		 * sb_gquotino to sb_pquotino.
> > +		 */
> > +		sbp->sb_pquotino = sbp->sb_gquotino;
> > +		sbp->sb_gquotino = NULLFSINO;
> > +	}
> >  }
> >  
> >  void
> > 
<snip>

> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index d320794..1e2361d 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -834,6 +834,36 @@ xfs_qm_qino_alloc(
> >  	int		error;
> >  	int		committed;
> >  
> > +	*ip = NULL;
> > +	/*
> > +	 * With superblock that doesn't have separate pquotino, we
> > +	 * share an inode between gquota and pquota. If the on-disk
> > +	 * superblock has GQUOTA and the filesystem is now mounted
> > +	 * with PQUOTA, just use sb_gquotino for sb_pquotino and
> > +	 * vice-versa.
> > +	 */
> > +	if (!xfs_sb_version_has_pquotino(&mp->m_sb) &&
> > +			(flags & (XFS_QMOPT_PQUOTA|XFS_QMOPT_GQUOTA))) {
> > +		xfs_ino_t ino = NULLFSINO;
> > +
> > +		if ((flags & XFS_QMOPT_PQUOTA) &&
> > +			     (mp->m_sb.sb_gquotino != NULLFSINO)) {
> > +			ino = mp->m_sb.sb_gquotino;
> > +			ASSERT(mp->m_sb.sb_pquotino == NULLFSINO);
> > +		} else if ((flags & XFS_QMOPT_GQUOTA) &&
> > +			     (mp->m_sb.sb_pquotino != NULLFSINO)) {
> > +			ino = mp->m_sb.sb_pquotino;
> > +			ASSERT(mp->m_sb.sb_gquotino == NULLFSINO);
> > +		}
> > +		if (ino != NULLFSINO) {
> > +			error = xfs_iget(mp, NULL, ino, 0, 0, ip);
> > +			if (error)
> > +				return error;
> > +			mp->m_sb.sb_gquotino = NULLFSINO;
> > +			mp->m_sb.sb_pquotino = NULLFSINO;
> > +		}
> > +	}
> 
> Looks like this is a new addition.  I'm not completely clear on why you
> needed to add it.  Maybe if the user had switched from using project
> quotas to group quotas there would be an old inode left out there from
> the project quotas?  Is that why you added this?  If so, wouldn't you

Yes. that is correct. 
> want to truncate the old contents away before using it?

Yikes, now I realize it is needed. Was just maintaining the earlier
behavior (reuse the inode and nothing more), and did not realize
truncate was missing.

> 
> > +
> >  	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_QINOCREATE);
> >  	if ((error = xfs_trans_reserve(tp,
> >  				      XFS_QM_QINOCREATE_SPACE_RES(mp),

<snip>

> > diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> > index e4f8b2d..8f4b8bc 100644
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
> >  	struct xfs_quotainfo	*q = mp->m_quotainfo;
> >  	struct xfs_inode	*uip = NULL;
> >  	struct xfs_inode	*gip = NULL;
> > +	struct xfs_inode	*pip = NULL;
> >  	bool                    tempuqip = false;
> >  	bool                    tempgqip = false;
> > +	bool                    temppqip = false;
> >  
> >  	memset(out, 0, sizeof(fs_quota_stat_t));
> >  
> > @@ -424,6 +428,12 @@ xfs_qm_scall_getqstat(
> >  		out->qs_gquota.qfs_ino = NULLFSINO;
> >  		return (0);
> >  	}
> > +
> > +	/* Q_XGETQSTAT doesn't have room for both group and project quotas */
> > +	if ((mp->m_qflags & (XFS_PQUOTA_ACCT | XFS_GQUOTA_ACCT)) ==
> > +					(XFS_PQUOTA_ACCT | XFS_GQUOTA_ACCT))
> > +		return -EINVAL;
> > +
> 
> Lets keep the rest of the crew in the loop with what we do on the
> quotactls.
> 
> On our call, I found myself in agreement that the idea of returning
> -EINVAL in the old interface when user, group, and project quotas are
> turned on simultaneously would be ok.  But today I'm not so sure.
> Classic bpm waffling...  ;)

:)
> 
> The quota rpm is separate from xfsprogs and could be much older; I think
> that there are those who will consider returning EINVAL here to be an
> API breakage.

> 
> Maybe there are other options?
> - A sysctl to control which quota you get through the old group
> interface, when all three are turned on.

this would be changing the existing API, wouldn't it ?

> - Only report user and qroup quotas through the old interface, even when
> all three are turned on. 
> 
> Probably the old interface should still work in some fashion with a
> newer filesystem, but there don't seem to be many wonderful solutions.
> 
> Anyway, I'd like to have Dave's reviewed-by and Jan's ack at a minimum
> before pulling in these -EINVAL bits.  If this really is ok, lets have
> everybodys sig to make it official.

I understand.
> 
> Thanks,
> 	Ben
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
