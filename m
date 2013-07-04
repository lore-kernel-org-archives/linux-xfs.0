Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5FCC47CBF
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 20:12:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4C294304059
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 18:12:16 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Eo1q2Lhe3nvTr1iU for <xfs@oss.sgi.com>;
	Wed, 03 Jul 2013 18:12:14 -0700 (PDT)
Date: Thu, 4 Jul 2013 11:12:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v9 4/6] xfs: Start using pquotaino from the superblock.
Message-ID: <20130704011208.GR14996@dastard>
References: <1372042107-27332-1-git-send-email-sekharan@us.ibm.com>
	<1372042107-27332-5-git-send-email-sekharan@us.ibm.com>
	<20130625063135.GU29376@dastard>
	<1372693830.9777.4.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372693830.9777.4.camel@chandra-dt.ibm.com>
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

On Mon, Jul 01, 2013 at 10:50:30AM -0500, Chandra Seetharaman wrote:
> Hi Dave,
> 
> I sent this email on 6/25 (just before my reply on 5/6 w.r.t adding the
> test to xfstests). Since I didn't get any response from you on this and
> got reply on the other one, I concluded that you accepted my
> justification/clarification.
> 
> I just looked at the archives and do not see my original email :(... but
> is intact in my sent folder!!
> 
> Please see if my justification below is valid.
> 
> Chandra
> 
> On Tue, 2013-06-25 at 16:31 +1000, Dave Chinner wrote:
> > On Sun, Jun 23, 2013 at 09:48:25PM -0500, Chandra Seetharaman wrote:
> > > Start using pquotino and define a macro to check if the
> > > superblock has pquotino.
> > > 
> > > Keep backward compatibilty by alowing mount of older superblock
> > > with no separate pquota inode.
> > > 
> > > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > > ---
> > >  fs/xfs/xfs_fsops.c             |    3 +-
> > >  fs/xfs/xfs_mount.c             |   51 +++++++++++++++++++++++++++++++--------
> > >  fs/xfs/xfs_qm.c                |   22 +++++++++--------
> > >  fs/xfs/xfs_qm_syscalls.c       |   24 ++++++++++++++++--
> > >  fs/xfs/xfs_quota.h             |    8 ------
> > >  fs/xfs/xfs_sb.h                |   16 +++++++++++-
> > >  fs/xfs/xfs_super.c             |   14 ++++++----
> > >  include/uapi/linux/dqblk_xfs.h |    1 +
> > >  8 files changed, 99 insertions(+), 40 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > > index 614eb0c..3bf05f4 100644
> > > --- a/fs/xfs/xfs_fsops.c
> > > +++ b/fs/xfs/xfs_fsops.c
> > > @@ -501,7 +501,8 @@ xfs_growfs_data_private(
> > >  				error, agno);
> > >  			break;
> > >  		}
> > > -		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, XFS_SB_ALL_BITS);
> > > +		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb,
> > > +				xfs_sb_all_bits(&mp->m_sb));
> > 
> > I think you could still pass XFS_SB_ALL_BITS to xfs_sb_to_disk(),
> > and do the XFS_SB_PQUOTINO filtering inside xfs_sb_quota_to_disk().
> > 
> > Actually xfs_sb_all_bits() is only used here, and it seems to me
> > that it is not necessary as we do a pquota support check inside
> > xfs_sb_to_disk() and can handle this in that place...
> 
> Yes, this is the only place that uses XFS_SB_ALL_BITS, and the purpose
> is to copy over the superblock to secondary.
> 
> The change I made ensures that the caller does what is correct. i.e if
> it is copying an earlier version of superblock, it does not try to copy
> the pquotino, and if it uses the newer version of superblock it copies
> over the pquotino.

The caller does not need to know anything about how the quota bits
are encoded in the superblock.

> At some point (in my internal tree) I did have the way you suggested.
> But, doing it that way looked like a band-aid/hack, and felt this is the
> right way to do it (since the caller should provide appropriate
> information to the function).

The caller should not have to know anything about the specific
on-disk encoding the filesystem is currently using

That's the reason for encapsulating such on-disk format conversion
inside xfs_sb_to/from_disk(). Same with all the mount flags and so on
- the differences between what the code uses and what is on disk is
all encapsulated inside xfs_sb_quota_to/from_disk.

IOWs, from the outside, XFS_SB_ALL_BITS is all a caller needs to
pass into xfs_sb_to_disk() to get everything written to disk. Making
the caller have to be aware of the on-disk format when the function
being called is supposed to hide the details of the on-disk format
from the callers is, well, a bit silly.

> > > +	if (*fields & XFS_SB_PQUOTINO) {
> > > +		to->sb_gquotino = cpu_to_be64(from->sb_pquotino);
> > > +		*fields &= ~XFS_SB_PQUOTINO;
> > > +	}
> > 
> > We will never do this because we've already cleared XFS_SB_PQUOTINO
> > before we entered xfs_sb_to_disk(). That doesn't seem right to me... 
> 
> Yes, if we are using a version of superblock where pquotino should not
> be used, we do not want to get into this block.

Why not? this code is executing the conversion from in-memory format
to the old on-disk format. This is exactly where such conversion
should be handled. This code looks right, but if you strip
XFS_SB_PQUOTINO at a high level, then it doesn't *ever* get used.

> If we are using PQUOTA in the superblock, that inode information will be
> in gquotino and will be converted over appropriately in
> xfs_sb_to_disk().

Sorry, I don't follow. You mean OQUOTA, yes?

Besides, all quota format conversions should be done in
xfs_sb_quota_to_disk(), not split between that function and
xfs_sb_to_disk()...

> > > @@ -201,8 +201,7 @@ xfs_qm_scall_quotaoff(
> > >  	/*
> > >  	 * If quotas is completely disabled, close shop.
> > >  	 */
> > > -	if (((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_SET1) ||
> > > -	    ((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_SET2)) {
> > > +	if ((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_ALL) {
> > >  		mutex_unlock(&q->qi_quotaofflock);
> > >  		xfs_qm_destroy_quotainfo(mp);
> > >  		return (0);
> > 
> > This makes the assumption that userspace passes all three quota
> > types into the kernel in a single quota off call as the only way to
> > turn quotas off completely. What happens if they are turned off one
> > at a time? Shouldn't we detect when no more quotas are actually
> > enabled and then do this?
> 
> Yes, I agree that there is a difference in behavior if the user turns
> off quota one-by-one Vs turns off all quota at once. But, the behavior
> difference is not seen by the user space.  And, I did not make the
> change :)
> 
> I just included project quota into the fold.

Sure, but my point still stands - if userspace currently expects
quota to be turned off by turning of user+group quota at the same
time, or user+project quota at the same time, then this will no
longer turn quotas off even if u/g or u/p were the only quotas
enabled. It's an unexpected change of behaviour, especially for
filesystems that don't support the separate pquota inode...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
