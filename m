Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5AB8C7F37
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 21:17:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 363C98F8035
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 19:17:51 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	CHbBSvqmlk8oCbfD for <xfs@oss.sgi.com>;
	Fri, 12 Jul 2013 19:17:49 -0700 (PDT)
Date: Sat, 13 Jul 2013 12:17:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Start using pquotaino from the superblock.
Message-ID: <20130713021746.GI3438@dastard>
References: <1373593707.20769.11.camel@chandra-dt.ibm.com>
	<20130712183030.GE20932@sgi.com>
	<1373661147.20769.25.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373661147.20769.25.camel@chandra-dt.ibm.com>
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
Cc: Ben Myers <bpm@sgi.com>, adas@redhat.com, Jan Kara <jack@suse.cz>, Steven Whitehouse <swhiteho@redhat.com>, XFS mailing list <xfs@oss.sgi.com>

On Fri, Jul 12, 2013 at 03:32:27PM -0500, Chandra Seetharaman wrote:
> On Fri, 2013-07-12 at 13:30 -0500, Ben Myers wrote:
> > Hey Chandra,
> > 
> <snip>
> 
> > > @@ -591,6 +599,19 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
> > >  		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
> > >  					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
> > >  	sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
> > > +
> > > +	if ((sbp->sb_qflags & XFS_PQUOTA_ACCT) &&
> > > +			(sbp->sb_gquotino != NULLFSINO)) {
> > 
> > If project quota accounting bit is set in the super block 
> > and 
> > the group quot ino is not nullfsino..
> > 
> > That's weird.  I would have expected to be able to assume that sb_gquotino is
> > not NULLFSINO if project quota accounting is on.  Why was the check necessary?
> 
> Thinking now, I should not have added the second part.
> (sbp->sb_qflags & XFS_PQUOTA_ACCT) should be sufficient.
> 
> > 
> > > +		/*
> > > +		 * On disk superblock only has sb_gquotino, and incore
> > > +		 * superblock has both sb_gquotino and sb_pquotino.
> > > +		 * But, only one of them is supported at any point of time.
> > > +		 * So, if PQUOTA is set in disk superblock, copy over
> > > +		 * sb_gquotino to sb_pquotino.
> > > +		 */
> > > +		sbp->sb_pquotino = sbp->sb_gquotino;
> > > +		sbp->sb_gquotino = NULLFSINO;
> > > +	}
> > >  }
> > >  
> > >  void
> > > 
> <snip>
> 
> > > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > > index d320794..1e2361d 100644
> > > --- a/fs/xfs/xfs_qm.c
> > > +++ b/fs/xfs/xfs_qm.c
> > > @@ -834,6 +834,36 @@ xfs_qm_qino_alloc(
> > >  	int		error;
> > >  	int		committed;
> > >  
> > > +	*ip = NULL;
> > > +	/*
> > > +	 * With superblock that doesn't have separate pquotino, we
> > > +	 * share an inode between gquota and pquota. If the on-disk
> > > +	 * superblock has GQUOTA and the filesystem is now mounted
> > > +	 * with PQUOTA, just use sb_gquotino for sb_pquotino and
> > > +	 * vice-versa.
> > > +	 */
> > > +	if (!xfs_sb_version_has_pquotino(&mp->m_sb) &&
> > > +			(flags & (XFS_QMOPT_PQUOTA|XFS_QMOPT_GQUOTA))) {
> > > +		xfs_ino_t ino = NULLFSINO;
> > > +
> > > +		if ((flags & XFS_QMOPT_PQUOTA) &&
> > > +			     (mp->m_sb.sb_gquotino != NULLFSINO)) {
> > > +			ino = mp->m_sb.sb_gquotino;
> > > +			ASSERT(mp->m_sb.sb_pquotino == NULLFSINO);
> > > +		} else if ((flags & XFS_QMOPT_GQUOTA) &&
> > > +			     (mp->m_sb.sb_pquotino != NULLFSINO)) {
> > > +			ino = mp->m_sb.sb_pquotino;
> > > +			ASSERT(mp->m_sb.sb_gquotino == NULLFSINO);
> > > +		}
> > > +		if (ino != NULLFSINO) {
> > > +			error = xfs_iget(mp, NULL, ino, 0, 0, ip);
> > > +			if (error)
> > > +				return error;
> > > +			mp->m_sb.sb_gquotino = NULLFSINO;
> > > +			mp->m_sb.sb_pquotino = NULLFSINO;
> > > +		}
> > > +	}
> > 
> > Looks like this is a new addition.  I'm not completely clear on why you
> > needed to add it.  Maybe if the user had switched from using project
> > quotas to group quotas there would be an old inode left out there from
> > the project quotas?  Is that why you added this?  If so, wouldn't you
> 
> Yes. that is correct. 
> > want to truncate the old contents away before using it?
> 
> Yikes, now I realize it is needed. Was just maintaining the earlier
> behavior (reuse the inode and nothing more), and did not realize
> truncate was missing.

It's not needed - the current code doesn't do a truncation when
switching from group to project and vice versa. quotacheck already
handles it - it zeros the existing dquots in the quota file first
before recalculating everything, so there is no problems with
"stale" contents being used whent eh swap occurs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
