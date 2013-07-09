Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 964757F53
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 20:21:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 690188F8035
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 18:21:44 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1fgeEYVsF2WmTKwD for <xfs@oss.sgi.com>;
	Mon, 08 Jul 2013 18:21:41 -0700 (PDT)
Date: Tue, 9 Jul 2013 11:21:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v9 4/6] xfs: Start using pquotaino from the superblock.
Message-ID: <20130709012137.GF3438@dastard>
References: <1372042107-27332-1-git-send-email-sekharan@us.ibm.com>
	<1372042107-27332-5-git-send-email-sekharan@us.ibm.com>
	<20130625063135.GU29376@dastard>
	<1372693830.9777.4.camel@chandra-dt.ibm.com>
	<20130704011208.GR14996@dastard>
	<1373325630.9777.286.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373325630.9777.286.camel@chandra-dt.ibm.com>
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

On Mon, Jul 08, 2013 at 06:20:30PM -0500, Chandra Seetharaman wrote:
> On Thu, 2013-07-04 at 11:12 +1000, Dave Chinner wrote:
> > On Mon, Jul 01, 2013 at 10:50:30AM -0500, Chandra Seetharaman wrote:
> > > Hi Dave,
> > > 
> > > I sent this email on 6/25 (just before my reply on 5/6 w.r.t adding the
> > > test to xfstests). Since I didn't get any response from you on this and
> > > got reply on the other one, I concluded that you accepted my
> > > justification/clarification.
> > > 
> > > I just looked at the archives and do not see my original email :(... but
> > > is intact in my sent folder!!
> > > 
> > > Please see if my justification below is valid.
> > > 
> > > Chandra
> > > 
> > > On Tue, 2013-06-25 at 16:31 +1000, Dave Chinner wrote:
> > > > On Sun, Jun 23, 2013 at 09:48:25PM -0500, Chandra Seetharaman wrote:
> > > > > Start using pquotino and define a macro to check if the
> > > > > superblock has pquotino.
> > > > > 
> > > > > Keep backward compatibilty by alowing mount of older superblock
> > > > > with no separate pquota inode.
> > > > > 
> > > > > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > > > > ---
> > > > >  fs/xfs/xfs_fsops.c             |    3 +-
> > > > >  fs/xfs/xfs_mount.c             |   51 +++++++++++++++++++++++++++++++--------
> > > > >  fs/xfs/xfs_qm.c                |   22 +++++++++--------
> > > > >  fs/xfs/xfs_qm_syscalls.c       |   24 ++++++++++++++++--
> > > > >  fs/xfs/xfs_quota.h             |    8 ------
> > > > >  fs/xfs/xfs_sb.h                |   16 +++++++++++-
> > > > >  fs/xfs/xfs_super.c             |   14 ++++++----
> > > > >  include/uapi/linux/dqblk_xfs.h |    1 +
> > > > >  8 files changed, 99 insertions(+), 40 deletions(-)
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > > > > index 614eb0c..3bf05f4 100644
> > > > > --- a/fs/xfs/xfs_fsops.c
> > > > > +++ b/fs/xfs/xfs_fsops.c
> > > > > @@ -501,7 +501,8 @@ xfs_growfs_data_private(
> > > > >  				error, agno);
> > > > >  			break;
> > > > >  		}
> > > > > -		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, XFS_SB_ALL_BITS);
> > > > > +		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb,
> > > > > +				xfs_sb_all_bits(&mp->m_sb));
> > > > 
> > > > I think you could still pass XFS_SB_ALL_BITS to xfs_sb_to_disk(),
> > > > and do the XFS_SB_PQUOTINO filtering inside xfs_sb_quota_to_disk().
> > > > 
> > > > Actually xfs_sb_all_bits() is only used here, and it seems to me
> > > > that it is not necessary as we do a pquota support check inside
> > > > xfs_sb_to_disk() and can handle this in that place...
> > > 
> > > Yes, this is the only place that uses XFS_SB_ALL_BITS, and the purpose
> > > is to copy over the superblock to secondary.
> > > 
> > > The change I made ensures that the caller does what is correct. i.e if
> > > it is copying an earlier version of superblock, it does not try to copy
> > > the pquotino, and if it uses the newer version of superblock it copies
> > > over the pquotino.
> > 
> > The caller does not need to know anything about how the quota bits
> > are encoded in the superblock.
> 
> Caller doesn't need to know about quota bits, that is why I encapsulated
> it into the function xfs_sb_all_bits().

Requiring a function at the caller site to filter bits out is saying
"the caller needs to know it has to filter certain options out".

What happens if we add a new piece of optional functionality that is
conditional for superblock writeback? So sometimes we need to filter
only PQUOTINO_BIT, sometimes we nee dto filter  FOO_BIT, sometimes
we need to filter BAR_BIT, and so on?

What you are proposing effectively sets us down the path of having
to do this in future:

	if (xfs_sb_version_hasfoo)
		xfs_sb_to_disk(XFS_SB_FOO_BIT)
	if (xfs_sb_version_hasbar)
		xfs_sb_to_disk(XFS_SB_BAR_BIT)
	xfs_sb_to_disk((XFS_SB_ALL_BITS & ~(XFS_SB_FOO_BIT|XFS_SB_BAR_BIT)));

All this needs to be handled in xfs_sb_to_disk().

> > That's the reason for encapsulating such on-disk format conversion
> > inside xfs_sb_to/from_disk(). Same with all the mount flags and so on
> > - the differences between what the code uses and what is on disk is
> > all encapsulated inside xfs_sb_quota_to/from_disk.
> 
> Encapsulation in xfs_sb_to_disk() is not enough for this situation. If
> both PQUOTINO and GQUOTINO is set for version 4 of the superblock,
> xfs_sb_to_disk will not be able to know if it has to treat PQUOTINO as
> valid or GQUOTINO as valid.

The contents of from->sb_qflags tells you which one is valid.
Indeed, you have to look at from->sb_qflags to set the OQUOTA flags
correctly in to->sb_qflags, so I don't see why you can't use
from->sb_qflags to determine which of G/PQUOTINO needs to copied
across to to->sb_gquotino....

> > > > >  	/*
> > > > >  	 * If quotas is completely disabled, close shop.
> > > > >  	 */
> > > > > -	if (((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_SET1) ||
> > > > > -	    ((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_SET2)) {
> > > > > +	if ((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_ALL) {
> > > > >  		mutex_unlock(&q->qi_quotaofflock);
> > > > >  		xfs_qm_destroy_quotainfo(mp);
> > > > >  		return (0);
> > > > 
> > > > This makes the assumption that userspace passes all three quota
> > > > types into the kernel in a single quota off call as the only way to
> > > > turn quotas off completely. What happens if they are turned off one
> > > > at a time? Shouldn't we detect when no more quotas are actually
> > > > enabled and then do this?
> > > 
> > > Yes, I agree that there is a difference in behavior if the user turns
> > > off quota one-by-one Vs turns off all quota at once. But, the behavior
> > > difference is not seen by the user space.  And, I did not make the
> > > change :)
> > > 
> > > I just included project quota into the fold.
> > 
> > Sure, but my point still stands - if userspace currently expects
> > quota to be turned off by turning of user+group quota at the same
> > time, or user+project quota at the same time, then this will no
> > longer turn quotas off even if u/g or u/p were the only quotas
> > enabled. It's an unexpected change of behaviour, especially for
> > filesystems that don't support the separate pquota inode...
> 
> IIUC, user space will not see any difference in behavior even if this
> specific code block is not present in this function. Whatever is being
> done in xfs_qm_destroy_quotainfo() is done by the code just below the
> above block in xfs_qm_scall_quotaoff(). Only additional thing
> xfs_qm_destroy_quotainfo() does is to clean up all other in-kernel data
> structures associated with quota for this mount point.
> 
> The behavior was that if _all_ the quotas are turned off at the same
> time, clean up all in-kernel data structures associated with quota. If
> the quotas were turned off one at a time, leave the in-kernel stuff even
> when the last quota is turned off.
> 
> I maintained the same behavior.

That's where I disagree. You kept the same /line of reasoning/ as the
original code, not the same behaviour. What I'm saying is that
the line of reasoning is wrong to begin with, and hence keeping it
is not the right thing to do.

Indeed, code archeology shows this line of reasoning is zero-day
Irix behaviour:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=blob;f=fs/xfs/xfs_qm_syscalls.c;hb=0d5ad8383061fbc0a9804fbb98218750000fe032

 730         /*      
 731          * If quotas is completely disabled, close shop.
 732          */
 733         if ((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_ALL) {
 734                 mutex_unlock(&mp->QI_QOFFLOCK);
 735                 xfs_qm_destroy_quotainfo(mp);   
 736                 return (0);
 737         }

Hmmm, looks kind of familiar, doesn't it? But what's the caller
context?

 155              case Q_QUOTAOFF:
 156                 /*  */
 157                 flags = addr? 
 158                         xfs_qm_import_flags((uint *)addr) : 
 159                         XFS_ALL_QUOTA_ACCT_ENFD;
 160                 error = xfs_qm_scall_quotaoff(mp, flags);
 161  

And from xfs_dquot.h:

  95 #define XFS_ALL_QUOTA_ACCT_ENFD (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
  96				      XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD)

If no parameter was passed, the default behaviour is to turn off
all quotas. IOWs, this logic made sense Irix, but the linux case has no
such default behaviour - it only passes what userspace says to turn
off.

And that's exactly my point - these semantics made sense for Irix all
those years ago, but they simply don't make sense now. Hence while
we are touching this code we should fix it up.  i.e. if we've turned
off all the quotas, clean up properly.

> I understand your point that _all_ mean u/g or u/p in older version of
> superblock. But, the difference in behavior is not drastic and is not
> seen by the user space at all.
> 
> If still unconvinced, is this the code you want to see there ?
> 
> if (((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_ALL) &&
>          	xfs_sb_version_has_pquota(&mp->sb)) ||
>         ((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_SET1) ||  
>         ((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_SET2)) {
> :
> :
> }

No. If, as a result of turning off quotas, there are no active
quotas then turn off the quota subsystem.  mp->m_qflags will tell us
exactly what quota is still running when we get to this point...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
