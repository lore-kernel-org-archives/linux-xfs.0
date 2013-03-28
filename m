Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 967FE7CBF
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 20:36:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 16B5EAC010
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 18:36:31 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	VZ0KnMbSPsX4hY8z for <xfs@oss.sgi.com>;
	Wed, 27 Mar 2013 18:36:29 -0700 (PDT)
Date: Thu, 28 Mar 2013 12:36:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 21/21] xfs: add CRC checks to the superblock
Message-ID: <20130328013626.GA6369@dastard>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
	<1363091454-8852-22-git-send-email-david@fromorbit.com>
	<1364331527.32345.135.camel@chandra-dt.ibm.com>
	<20130327010625.GM6369@dastard>
	<1364425621.32345.177.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1364425621.32345.177.camel@chandra-dt.ibm.com>
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

On Wed, Mar 27, 2013 at 06:07:01PM -0500, Chandra Seetharaman wrote:
> Hi Dave,
> 
> Thanks for patiently explaining the details.
> 
> Please see my comments below.
> 
> On Wed, 2013-03-27 at 12:06 +1100, Dave Chinner wrote:
> > On Tue, Mar 26, 2013 at 03:58:47PM -0500, Chandra Seetharaman wrote:
> > > On Tue, 2013-03-12 at 23:30 +1100, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > With the addition of CRCs, there is such a wide and varied change to
> > > > the on disk format that it makes sense to bump the superblock
> > > > version number rather than try to use feature bits for all the new
> > > > functionality.
> > > > 
> > > > This commit introduces all the new superblock fields needed for all
> > > > the new functionality: feature masks similar to ext4, separate
> > > > project quota inodes, a LSN field for recovery and the CRC field.
> > > > 
> > > > This commit does not bump the superblock version number, however.
> > > > That will be done as a separate commit at the end of the series
> > > > after all the new functionality is present so we switch it all on in
> > > > one commit. This means that we can slowly introduce the changes
> > > > without them being active and hence maintain bisectability of the
> > > > tree.
> > > > 
> > > > This patch is based on a patch originally written by myself back
> > > > from SGI days, which was subsequently modified by Christoph Hellwig.
> > > > There is relatively little of that patch remaining, but the history
> > > > of the patch still should be acknowledged here.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_buf_item.h    |    4 +-
> > > >  fs/xfs/xfs_log_recover.c |    8 ++++
> > > >  fs/xfs/xfs_mount.c       |   97 ++++++++++++++++++++++++++++++++++++--------
> > > >  fs/xfs/xfs_mount.h       |    1 +
> > > >  fs/xfs/xfs_sb.h          |  100 ++++++++++++++++++++++++++++++++--------------
> > > >  5 files changed, 164 insertions(+), 46 deletions(-)
> > > 
> > > <snip>
> > .....
> > > > @@ -276,6 +303,11 @@ typedef enum {
> > > >  #define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
> > > >  #define XFS_SB_FEATURES2	XFS_SB_MVAL(FEATURES2)
> > > >  #define XFS_SB_BAD_FEATURES2	XFS_SB_MVAL(BAD_FEATURES2)
> > > > +#define XFS_SB_FEATURES_COMPAT	XFS_SB_MVAL(FEATURES_COMPAT)
> > > > +#define XFS_SB_FEATURES_RO_COMPAT XFS_SB_MVAL(FEATURES_RO_COMPAT)
> > > > +#define XFS_SB_FEATURES_INCOMPAT XFS_SB_MVAL(FEATURES_INCOMPAT)
> > > > +#define XFS_SB_CRC		XFS_SB_MVAL(CRC)
> > > > +#define XFS_SB_PQUOTINO		XFS_SB_MVAL(PQUOTINO)
> > > 
> > > missing define for XFS_SB_LSN ?!
> > 
> > No, not at all. We only have bits for variables that get logged. The
> > LSn of the object is never logged as it is stamped into the object
> > when it is being written back. i.e. it is an indication of when the
> > object was last modified, not a field that is recorded during
> > modifications.
> 
> Hmm. may be I misunderstood. Aren't these bits to inform the low level
> function (that selects which fields in superblocks are updated) which
> fields we want to update on the disk ? 

They are bit fields fed to xfs_mod_sb() for transactional updates
and to xfs_sb_to_disk() for copying specific fields from the in-core
superblock to the on-disk superblock.

The LSN is written by neither of these methods - the LSN is pulled
from the xfs_buf_log_item attached to the superblock buffer at
writeback time and inserted directly into the buffer just prior to
writeback. Hence it is not a field that should be visible to either
xfs_mod_sb() or xfs_sb_to_disk().

Same goes for the CRC field.

> > > > @@ -325,6 +358,8 @@ static inline int xfs_sb_good_version(xfs_sb_t *sbp)
> > > > 
> > > >  		return 1;
> > > >  	}
> > > > +	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
> > > > +		return 1;
> > > > 
> > > >  	return 0;
> > > >  }
> > > > @@ -365,7 +400,7 @@ static inline int xfs_sb_version_hasattr(xfs_sb_t *sbp)
> > > >  {
> > > >  	return sbp->sb_versionnum == XFS_SB_VERSION_2 ||
> > > >  		sbp->sb_versionnum == XFS_SB_VERSION_3 ||
> > > > -		(XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> > > > +		(XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
> > > >  		 (sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT));
> > > >  }
> > > 
> > > Do you expect version 5 and later have this bit to be exclusively set to
> > > use attribues ? (i.e can't we just assume version 5 and later would have
> > > attributes ?)
> > 
> > This just indicates that there are inodes with attributes in the
> > filesystem. It's not an "enabling" feature at all. If it's not
> > present when the first attribute is created, then the kernel code
> > will set it. Hence all this does it maintain the existing
> > behaviour....
> > 
> > > Since we are changing the version, can't we get rid of some on these
> > > bits (i.e slowly deprecate them) ? 
> > 
> > No, because we still support version 4 superblocks and hence all
> > these bit for the indefinite future (i.e. forever).
> 
> Sorry. I used a wrong word "deprecate". That is not what I meant.
> 
> I wanted to see if by deliberately making few of the bits in
> versionnum/features2 implicit in version 5 can we start using the _same_
> bits in version 5 for new features.

Insanity lies that way. A feature bit is for a single feature only.
Forever. Version 5 superblocks add new feature fields for v5+ only
features. The existing feature fields are needed for shared v4/v5
feature additions, and as they are shared, we cannot make them mean
different things for different versions....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
