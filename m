Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 746CB7F4E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 16:14:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1B6C68F808F
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 14:14:23 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	NMNTqWSHA21dryZ5 for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 14:14:20 -0700 (PDT)
Date: Wed, 28 May 2014 07:14:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/3] xfs: run an eofblocks scan on ENOSPC/EDQUOT
Message-ID: <20140527211416.GB6677@dastard>
References: <1400845950-41435-1-git-send-email-bfoster@redhat.com>
	<1400845950-41435-3-git-send-email-bfoster@redhat.com>
	<20140526225755.GR18954@dastard>
	<20140527124755.GC63281@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140527124755.GC63281@bfoster.bfoster>
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

On Tue, May 27, 2014 at 08:47:55AM -0400, Brian Foster wrote:
> On Tue, May 27, 2014 at 08:57:55AM +1000, Dave Chinner wrote:
> > On Fri, May 23, 2014 at 07:52:29AM -0400, Brian Foster wrote:
> > > +/*
> > > + * Run eofblocks scans on the quotas applicable to the inode. For inodes with
> > > + * multiple quotas, we don't know exactly which quota caused an allocation
> > > + * failure. We make a best effort by running scans for each quota considered
> > > + * to be under low free space conditions (less than 1% available free space).
> > > + */
> > > +int
> > > +xfs_inode_free_quota_eofblocks(
> > > +	struct xfs_inode *ip)
> > > +{
> > > +	int scanned = 0;
> > > +	struct xfs_eofblocks eofb = {0,};
> > > +	struct xfs_dquot *dq;
> > > +
> > > +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> > > +
> > > +	/* set the scan owner to avoid potential livelock */
> > > +	eofb.eof_scan_owner = ip->i_ino;
> > > +
> > > +	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
> > > +		dq = xfs_inode_dquot(ip, XFS_DQ_USER);
> > > +		if (dq && xfs_dquot_lowsp(dq)) {
> > > +			eofb.eof_uid = VFS_I(ip)->i_uid;
> > > +			eofb.eof_flags = XFS_EOF_FLAGS_SYNC|
> > > +					 XFS_EOF_FLAGS_UID;
> > > +			xfs_icache_free_eofblocks(ip->i_mount, &eofb);
> > > +			scanned = 1;
> > > +		}
> > > +	}
> > > +
> > > +	if (XFS_IS_GQUOTA_ENFORCED(ip->i_mount)) {
> > > +		dq = xfs_inode_dquot(ip, XFS_DQ_GROUP);
> > > +		if (dq && xfs_dquot_lowsp(dq)) {
> > > +			eofb.eof_gid = VFS_I(ip)->i_gid;
> > > +			eofb.eof_flags = XFS_EOF_FLAGS_SYNC|
> > > +					 XFS_EOF_FLAGS_GID;
> > > +			xfs_icache_free_eofblocks(ip->i_mount, &eofb);
> > > +			scanned = 1;
> > > +		}
> > > +	}
> > 
> > Rather that doing two scans here, wouldn't it be more efficient
> > to do:
> > 
> > 	eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
> > 	scan = false;
> > 	if (uquota is low) {
> > 		eofb.eof_uid = VFS_I(ip)->i_uid;
> > 		eofb.eof_flags |= XFS_EOF_FLAGS_UID;
> > 		scan = true;
> > 	}
> > 	if (gquota is low) {
> > 		eofb.eof_gid = VFS_I(ip)->i_gid;
> > 		eofb.eof_flags |= XFS_EOF_FLAGS_GID;
> > 		scan = true;
> > 	}
> > 	if (scan)
> > 		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
> > 
> > and change xfs_inode_match_id() to be able to check against multiple
> > flags on a single inode? That way we only scan the inode cache
> > once, regardless of the number of quota types that are enabled and
> > are tracking low space thresholds.
> > 
> 
> Yeah, that would certainly be better from this perspective. We don't
> care so much about the characteristics of the inode as much as the
> quotas that are associated with it. If I recall, I was somewhat on the
> fence about this behavior when we first added the userspace interface
> here. IOWs, should the combination of flags define an intersection of
> the set of inodes to scan or a union? The more I think about it, I think
> the interface kind of suggests the former (from an interface/aesthetic
> perspective). E.g., I probably wouldn't expect to add a GID flag to a
> UID flag and have my scan become more broad, rather than more
> restrictive. Otherwise, the existence of a uid, gid and prid in the
> request structure seems kind of arbitrary (as opposed to a list/set of
> generic IDs, for example).
> 
> I'm not against union behavior in general (and still probably not 100%
> against switching the default). I suppose another option could be to add
> a set of union/intersection flags that control the behavior here. I'd
> be slightly concerned about making this interface too convoluted, but it
> is a relatively low level thing, I suppose, without much generic use. We
> could also decide not to expose those extra controls to userspace for
> the time being.
> 
> I need to think about this some more. Thoughts on any of that?

What we expose to userspace is orthoganol to what we implment
internally. It makes sense to limit the userspace interface to a
single type at a time, but when we are doing internal cleaner work
it makes sense to match all criteria in a single cache pass.

i.e. Restrict the capability of the user interface at the input
layer rather than restricting the capability of the infrastructure
to do work efficiently...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
