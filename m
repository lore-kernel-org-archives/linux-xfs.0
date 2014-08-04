Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 530DA7F56
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2014 02:34:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4155B30404E
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2014 00:34:50 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	HrkCsRADCv69B2Rg for <xfs@oss.sgi.com>;
	Mon, 04 Aug 2014 00:34:47 -0700 (PDT)
Date: Mon, 4 Aug 2014 17:34:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] xfs: remove bitfield based superblock updates
Message-ID: <20140804073443.GX20518@dastard>
References: <1406791995-14723-1-git-send-email-david@fromorbit.com>
	<1406791995-14723-2-git-send-email-david@fromorbit.com>
	<20140801143751.GB3582@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140801143751.GB3582@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 01, 2014 at 10:37:51AM -0400, Brian Foster wrote:
> On Thu, Jul 31, 2014 at 05:33:10PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When we log changes to the superblock, we first have to write them
> > to the on-disk buffer, and then log that. Right now we have a
> > complex bitfield based arrangement to only write the modified field
> > to the buffer before we log it.
> > 
> > This used to be necessary as a performance optimisation because we
> > logged the superblock buffer in every extent or inode allocation or
> > freeing, and so performance was extremely important. We haven't done
> > this for years, however, ever since the lazy superblock counters
> > pulled the superblock logging out of the transaction commit
> > fast path.
> > 
> > Hence we have a bunch of complexity that is not necessary that makes
> > writing the in-core superblock to disk much more complex than it
> > needs to be. We only need to log the superblock now during
> > management operations (e.g. during mount, unmount or quota control
> > operations) so it is not a performance critical path anymore.
> > 
> > As such, remove the complex field based logging mechanism and
> > replace it with a simple conversion function similar to what we use
> > for all other on-disk structures.
> > 
> > This means we always log the entirity of the superblock, but again
> > because we rarely modify the superblock this is not an issue for log
> > bandwidth or CPU time. Indeed, if we do log the superblock
> > frequently, delayed logging will minimise the impact of this
> > overhead.
...
> > @@ -447,125 +384,119 @@ xfs_sb_from_disk(
> >  	to->sb_lsn = be64_to_cpu(from->sb_lsn);
> >  }
> >  
> > -static inline void
> > +static void
> >  xfs_sb_quota_to_disk(
> > -	xfs_dsb_t	*to,
> > -	xfs_sb_t	*from,
> > -	__int64_t	*fields)
> > +	struct xfs_dsb	*to,
> > +	struct xfs_sb	*from)
> >  {
> >  	__uint16_t	qflags = from->sb_qflags;
> >  
> > +	to->sb_uquotino = cpu_to_be64(from->sb_uquotino);
> > +	if (xfs_sb_version_has_pquotino(from)) {
> > +		to->sb_qflags = be16_to_cpu(from->sb_qflags);
> > +		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
> > +		to->sb_pquotino = cpu_to_be64(from->sb_pquotino);
> > +		return;
> > +	}
> > +
> 
> Ok, so we're inheriting the quota conversion from xfs_sb_to_disk()
> unconditionally (as opposed to previously being solely a has_pquotino()
> fixup function).

Right - that's one of the problems with this function - it modifies
some fields and modifies flags for other code to do the right thing.
It's kinda confusing to split it up like that rather than have all
the quota translation in one place.

> 
> >  	/*
> > -	 * We need to do these manipilations only if we are working
> > -	 * with an older version of on-disk superblock.
> > +	 * The in-core version of sb_qflags do not have XFS_OQUOTA_*
> > +	 * flags, whereas the on-disk version does.  So, convert incore
> > +	 * XFS_{PG}QUOTA_* flags to on-disk XFS_OQUOTA_* flags.
> >  	 */
> > -	if (xfs_sb_version_has_pquotino(from))
> > -		return;
> > +	qflags &= ~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
> > +			XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
> >  
> > -	if (*fields & XFS_SB_QFLAGS) {
> > -		/*
> > -		 * The in-core version of sb_qflags do not have
> > -		 * XFS_OQUOTA_* flags, whereas the on-disk version
> > -		 * does.  So, convert incore XFS_{PG}QUOTA_* flags
> > -		 * to on-disk XFS_OQUOTA_* flags.
> > -		 */
> > -		qflags &= ~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
> > -				XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
> > -
> > -		if (from->sb_qflags &
> > -				(XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
> > -			qflags |= XFS_OQUOTA_ENFD;
> > -		if (from->sb_qflags &
> > -				(XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))
> > -			qflags |= XFS_OQUOTA_CHKD;
> > -		to->sb_qflags = cpu_to_be16(qflags);
> > -		*fields &= ~XFS_SB_QFLAGS;
> > -	}
> > +	if (from->sb_qflags &
> > +			(XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
> > +		qflags |= XFS_OQUOTA_ENFD;
> > +	if (from->sb_qflags &
> > +			(XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))
> > +		qflags |= XFS_OQUOTA_CHKD;
> > +	to->sb_qflags = cpu_to_be16(qflags);
> >  
> >  	/*
> > -	 * GQUOTINO and PQUOTINO cannot be used together in versions of
> > -	 * superblock that do not have pquotino. from->sb_flags tells us which
> > -	 * quota is active and should be copied to disk. If neither are active,
> > -	 * make sure we write NULLFSINO to the sb_gquotino field as a quota
> > -	 * inode value of "0" is invalid when the XFS_SB_VERSION_QUOTA feature
> > -	 * bit is set.
> > +	 * GQUOTINO and PQUOTINO cannot be used together in versions
> > +	 * of superblock that do not have pquotino. from->sb_flags
> > +	 * tells us which quota is active and should be copied to
> > +	 * disk. If neither are active, we should NULL the inode.
> >  	 *
> > -	 * Note that we don't need to handle the sb_uquotino or sb_pquotino here
> > -	 * as they do not require any translation. Hence the main sb field loop
> > -	 * will write them appropriately from the in-core superblock.
> > +	 * In all cases, the separate pquotino must remain 0 because it
> > +	 * it beyond the "end" of the valid non-pquotino superblock.
> >  	 */
> > -	if ((*fields & XFS_SB_GQUOTINO) &&
> > -				(from->sb_qflags & XFS_GQUOTA_ACCT))
> > +	if (from->sb_qflags & XFS_GQUOTA_ACCT)
> >  		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
> > -	else if ((*fields & XFS_SB_PQUOTINO) &&
> > -				(from->sb_qflags & XFS_PQUOTA_ACCT))
> > +	else if (from->sb_qflags & XFS_PQUOTA_ACCT)
> >  		to->sb_gquotino = cpu_to_be64(from->sb_pquotino);
> > -	else {
> > -		/*
> > -		 * We can't rely on just the fields being logged to tell us
> > -		 * that it is safe to write NULLFSINO - we should only do that
> > -		 * if quotas are not actually enabled. Hence only write
> > -		 * NULLFSINO if both in-core quota inodes are NULL.
> > -		 */
> > -		if (from->sb_gquotino == NULLFSINO &&
> > -		    from->sb_pquotino == NULLFSINO)
> > -			to->sb_gquotino = cpu_to_be64(NULLFSINO);
> > -	}
> > +	else
> > +		to->sb_gquotino = cpu_to_be64(NULLFSINO);
> 
> I'll ask since I'm not 100% on the backwards compatibility fixup here...
> but this else condition is effectively the same logic as the previous
> NULLFSINO checks due to the *QUOTA_ACCT flags checks, yes? If so, the
> rest looks fine:

*nod*. The in-core NULLFSINO checks were required because we
couldn't trust either the superblock quota flags or the modified
fields mask to tell us if we needed to convert the gquotino field
from zero to NULLFSINO.

>From a compatibility POV on older kernels, if usr quota is turned on
but not grp/prj then the expected the value iof sb_gquotino is
NULLFSINO. If quota is turned off, then either 0 or NULLFSINO are
valid values. IOWs, the logic in the absence of the logging field
bitmask is much, much simpler: if we don't write a real inode number
to the field because quotas are not on then just write NULLFSINO.

Clear as mud, huh?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
