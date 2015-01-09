Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9FE1C7F60
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 17:37:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8CF598F8040
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 15:37:10 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Kg5Nw0YLsgXi7KDV for <xfs@oss.sgi.com>;
	Fri, 09 Jan 2015 15:37:07 -0800 (PST)
Date: Sat, 10 Jan 2015 10:36:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: remove bitfield based superblock updates
Message-ID: <20150109233651.GM31508@dastard>
References: <1420667465-7453-1-git-send-email-david@fromorbit.com>
	<1420667465-7453-2-git-send-email-david@fromorbit.com>
	<20150109203501.GA2233@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150109203501.GA2233@laptop.bfoster>
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

On Fri, Jan 09, 2015 at 03:35:01PM -0500, Brian Foster wrote:
> On Thu, Jan 08, 2015 at 08:51:03AM +1100, Dave Chinner wrote:
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
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
....
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
> FYI... it looks like the above hunk causes a regression due to resetting
> sb_gquotaino when one of the in-core inodes is set. I'm seeing
> disconnected quota inode messages on some xfstests (e.g., xfs/108) on v4
> filesystems. I'm about to put a patch on the list to go back to the
> original logic...

Interesting, I'm not seeing that in any of my v4 testing. hmmm - I
wonder if that's a result of using config sections and the test
device is not being remade with the changing format. I'll look into
it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
