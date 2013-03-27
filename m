Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 36D287F52
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 18:07:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 255DD30408C
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 16:07:07 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id cpUGheoo4Gba8FiQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 Mar 2013 16:07:06 -0700 (PDT)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 27 Mar 2013 19:07:05 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id CFBF9C9001A
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 19:07:03 -0400 (EDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r2RN73AE339968 for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 19:07:03 -0400
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r2RN72fb000767
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 17:07:03 -0600
Subject: Re: [PATCH 21/21] xfs: add CRC checks to the superblock
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130327010625.GM6369@dastard>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
	<1363091454-8852-22-git-send-email-david@fromorbit.com>
	<1364331527.32345.135.camel@chandra-dt.ibm.com>
	<20130327010625.GM6369@dastard>
Date: Wed, 27 Mar 2013 18:07:01 -0500
Message-ID: <1364425621.32345.177.camel@chandra-dt.ibm.com>
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

Hi Dave,

Thanks for patiently explaining the details.

Please see my comments below.

On Wed, 2013-03-27 at 12:06 +1100, Dave Chinner wrote:
> On Tue, Mar 26, 2013 at 03:58:47PM -0500, Chandra Seetharaman wrote:
> > On Tue, 2013-03-12 at 23:30 +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > With the addition of CRCs, there is such a wide and varied change to
> > > the on disk format that it makes sense to bump the superblock
> > > version number rather than try to use feature bits for all the new
> > > functionality.
> > > 
> > > This commit introduces all the new superblock fields needed for all
> > > the new functionality: feature masks similar to ext4, separate
> > > project quota inodes, a LSN field for recovery and the CRC field.
> > > 
> > > This commit does not bump the superblock version number, however.
> > > That will be done as a separate commit at the end of the series
> > > after all the new functionality is present so we switch it all on in
> > > one commit. This means that we can slowly introduce the changes
> > > without them being active and hence maintain bisectability of the
> > > tree.
> > > 
> > > This patch is based on a patch originally written by myself back
> > > from SGI days, which was subsequently modified by Christoph Hellwig.
> > > There is relatively little of that patch remaining, but the history
> > > of the patch still should be acknowledged here.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_buf_item.h    |    4 +-
> > >  fs/xfs/xfs_log_recover.c |    8 ++++
> > >  fs/xfs/xfs_mount.c       |   97 ++++++++++++++++++++++++++++++++++++--------
> > >  fs/xfs/xfs_mount.h       |    1 +
> > >  fs/xfs/xfs_sb.h          |  100 ++++++++++++++++++++++++++++++++--------------
> > >  5 files changed, 164 insertions(+), 46 deletions(-)
> > 
> > <snip>
> .....
> > > @@ -276,6 +303,11 @@ typedef enum {
> > >  #define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
> > >  #define XFS_SB_FEATURES2	XFS_SB_MVAL(FEATURES2)
> > >  #define XFS_SB_BAD_FEATURES2	XFS_SB_MVAL(BAD_FEATURES2)
> > > +#define XFS_SB_FEATURES_COMPAT	XFS_SB_MVAL(FEATURES_COMPAT)
> > > +#define XFS_SB_FEATURES_RO_COMPAT XFS_SB_MVAL(FEATURES_RO_COMPAT)
> > > +#define XFS_SB_FEATURES_INCOMPAT XFS_SB_MVAL(FEATURES_INCOMPAT)
> > > +#define XFS_SB_CRC		XFS_SB_MVAL(CRC)
> > > +#define XFS_SB_PQUOTINO		XFS_SB_MVAL(PQUOTINO)
> > 
> > missing define for XFS_SB_LSN ?!
> 
> No, not at all. We only have bits for variables that get logged. The
> LSn of the object is never logged as it is stamped into the object
> when it is being written back. i.e. it is an indication of when the
> object was last modified, not a field that is recorded during
> modifications.

Hmm. may be I misunderstood. Aren't these bits to inform the low level
function (that selects which fields in superblocks are updated) which
fields we want to update on the disk ? 

> 
> > > @@ -325,6 +358,8 @@ static inline int xfs_sb_good_version(xfs_sb_t *sbp)
> > > 
> > >  		return 1;
> > >  	}
> > > +	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
> > > +		return 1;
> > > 
> > >  	return 0;
> > >  }
> > > @@ -365,7 +400,7 @@ static inline int xfs_sb_version_hasattr(xfs_sb_t *sbp)
> > >  {
> > >  	return sbp->sb_versionnum == XFS_SB_VERSION_2 ||
> > >  		sbp->sb_versionnum == XFS_SB_VERSION_3 ||
> > > -		(XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> > > +		(XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
> > >  		 (sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT));
> > >  }
> > 
> > Do you expect version 5 and later have this bit to be exclusively set to
> > use attribues ? (i.e can't we just assume version 5 and later would have
> > attributes ?)
> 
> This just indicates that there are inodes with attributes in the
> filesystem. It's not an "enabling" feature at all. If it's not
> present when the first attribute is created, then the kernel code
> will set it. Hence all this does it maintain the existing
> behaviour....
> 
> > Since we are changing the version, can't we get rid of some on these
> > bits (i.e slowly deprecate them) ? 
> 
> No, because we still support version 4 superblocks and hence all
> these bit for the indefinite future (i.e. forever).

Sorry. I used a wrong word "deprecate". That is not what I meant.

I wanted to see if by deliberately making few of the bits in
versionnum/features2 implicit in version 5 can we start using the _same_
bits in version 5 for new features. Mainly to avoid added features3,
feature4... fields in the future. (my questions came from that point of
view).

Basically, assume if version 4 has features bit A B C D E F, and version
5 implicitly means A D E F are set (i.e we do not have to use those bits
in version 5 for those specific features), and B and C are optional
which could still be used in version 5.

>From your explanation, it is clear that some features are implicit in
version 5 (and hence setting the bit is not needed). ATTRBIT, NLINKBIT,
and QUOTABIT seems to be optional (and still could be used in version
5), and all others are implicit.

Even though some of the features are now implicit, and the corresponding
bits are not used, i see that the plan is to keep the bits as is
(without reusing). Is that correct ?

Do you see any value in reusing the bits ?

> 
> > > @@ -373,7 +408,7 @@ static inline void xfs_sb_version_addattr(xfs_sb_t *sbp)
> > >  {
> > >  	if (sbp->sb_versionnum == XFS_SB_VERSION_1)
> > >  		sbp->sb_versionnum = XFS_SB_VERSION_2;
> > > -	else if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
> > > +	else if (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4)
> > >  		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
> > >  	else
> > >  		sbp->sb_versionnum = XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT;
> > > @@ -382,7 +417,7 @@ static inline void xfs_sb_version_addattr(xfs_sb_t *sbp)
> > >  static inline int xfs_sb_version_hasnlink(xfs_sb_t *sbp)
> > >  {
> > >  	return sbp->sb_versionnum == XFS_SB_VERSION_3 ||
> > > -		 (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> > > +		 (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
> > >  		  (sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT));
> > 
> > Same here
> 
> This is for version 1/2 inodes and which formats are present in the
> filesystem. It has been set by default in mkfs for a long time.
> Version 5 superblocks don't change this. This bit can also be set on
> demand by the kernel if it is not present and an inode requires a
> link count of > 2^16.
> 
> Further, CRCs require v3 inodes, so this is only relevant for
> non-crc enabled filesystems.
> 
> > > @@ -396,13 +431,13 @@ static inline void xfs_sb_version_addnlink(xfs_sb_t *sbp)
> > > 
> > >  static inline int xfs_sb_version_hasquota(xfs_sb_t *sbp)
> > >  {
> > > -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> > > +	return XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
> > >  		(sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT);
> > 
> > same here
> 
> Set when quotas are turned on by the kernel. Behaves the same for
> v4/v5 superblocks.
> 
> > >  }
> > > 
> > >  static inline void xfs_sb_version_addquota(xfs_sb_t *sbp)
> > >  {
> > > -	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
> > > +	if (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4)
> > >  		sbp->sb_versionnum |= XFS_SB_VERSION_QUOTABIT;
> > >  	else
> > >  		sbp->sb_versionnum = xfs_sb_version_tonew(sbp->sb_versionnum) |
> > > @@ -411,13 +446,14 @@ static inline void xfs_sb_version_addquota(xfs_sb_t *sbp)
> > > 
> > >  static inline int xfs_sb_version_hasalign(xfs_sb_t *sbp)
> > >  {
> > > -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> > > -		(sbp->sb_versionnum & XFS_SB_VERSION_ALIGNBIT);
> > > +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
> > > +	       (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
> > > +		(sbp->sb_versionnum & XFS_SB_VERSION_ALIGNBIT));
> > >  }
> > 
> > same here
> 
> mkfs already sets this bit unconditionally for v4 superblocks, so V5
> makes it mandatory.
> 
> > >  static inline int xfs_sb_version_hasdalign(xfs_sb_t *sbp)
> > >  {
> > > -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> > > +	return XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
> > >  		(sbp->sb_versionnum & XFS_SB_VERSION_DALIGNBIT);
> > >  }
> > 
> > same here
> 
> Necessary to indicate sunit/swidth are set at mkfs time, indicating
> alignment restrictions are present on filesystem layout. Behaves the
> same for v4/v5 superblocks.
> 
> > > @@ -429,38 +465,42 @@ static inline int xfs_sb_version_hasshared(xfs_sb_t *sbp)
> > > 
> > >  static inline int xfs_sb_version_hasdirv2(xfs_sb_t *sbp)
> > >  {
> > > -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> > > -		(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
> > > +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
> > 
> > Why some places we have version == 5 and others (version == 5 && (XXX))
> 
> Because some things are simply set as supported on v5 superblocks,
> while other are still optional or indicative of on-disk formats in
> use.

Clear now.
> 
> > >  static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
> > >  {
> > > -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> > > -		(sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
> > > +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
> > > +	       (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> > > +		(sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT));
> > 
> > Gets more confusing here. version 5 means it has more bits ? (even if
> > the MOREBITSBIT is not set ?
> > 
> > May be we shouldn't add version 5 check here ?!
> 
> The MOREBITSBIT bit means that the sb_features2 field exists in the
> on disk structure. That is clearly true for all v5 superblocks, and
> so we don't need to care if the MOREBITSBIT is set or not.

Understood.
> 
> > > @@ -475,14 +515,16 @@ static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
> > > 
> > >  static inline int xfs_sb_version_haslazysbcount(xfs_sb_t *sbp)
> > >  {
> > > -	return xfs_sb_version_hasmorebits(sbp) &&
> > > -		(sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT);
> > > +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
> > > +	       (xfs_sb_version_hasmorebits(sbp) &&
> > > +		(sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT));
> > >  }
> > 
> > If we remove the version 5 check in xfs_sb_hasmorebits(), then this
> > change is correct. Otherwise, this change is not needed.
> 
> No, this change means lazy superblock counters are a fixed feature
> of v5 superblocks - it is not optional like it currently is. The
> check inside xfs_sb_version_hasmorebits() is to determine if the
> features2 field is present, not that the lazycount feature is
> supported....
> 
> > >  static inline int xfs_sb_version_hasattr2(xfs_sb_t *sbp)
> > >  {
> > > -	return xfs_sb_version_hasmorebits(sbp) &&
> > > -		(sbp->sb_features2 & XFS_SB_VERSION2_ATTR2BIT);
> > > +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
> > > +	       (xfs_sb_version_hasmorebits(sbp) &&
> > > +		(sbp->sb_features2 & XFS_SB_VERSION2_ATTR2BIT));
> > >  }
> > 
> > If we remove the version 5 check in xfs_sb_hasmorebits(), then this
> > change is correct. Otherwise, this change is not needed.
> 
> Same again - v5 implies attr2 behaviour is the only attr fork
> behaviour supported.
> 
> > >  static inline void xfs_sb_version_addattr2(xfs_sb_t *sbp)
> > > @@ -500,14 +542,14 @@ static inline void xfs_sb_version_removeattr2(xfs_sb_t *sbp)
> > > 
> > >  static inline int xfs_sb_version_hasprojid32bit(xfs_sb_t *sbp)
> > >  {
> > > -	return xfs_sb_version_hasmorebits(sbp) &&
> > > -		(sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT);
> > > +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
> > > +	       (xfs_sb_version_hasmorebits(sbp) &&
> > > +		(sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT));
> > >  }
> > If we remove the version 5 check in xfs_sb_hasmorebits(), then this
> > change is correct. Otherwise, this change is not needed.
> 
> Same again - v5 superblocks *always* support 32 bit project ids.
> 
> > >  static inline int xfs_sb_version_hascrc(xfs_sb_t *sbp)
> > >  {
> > > -	return (xfs_sb_version_hasmorebits(sbp) &&
> > > -		(sbp->sb_features2 & XFS_SB_VERSION2_CRCBIT));
> > > +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
> > 
> > what happens to the superblocks that already have version 4 and this bit
> > set ?
> 
> It makes the XFS_SB_VERSION2_CRCBIT an invalid feature bit - it has
> never, ever been used by anything - so any filesystem with that bit
> set will fail to mount.
> 
> > Also don't xfs_sb_version_toold() and xfs_sb_version_tonew() need
> > changes ?
> 
> No. the code that calls xfs_sb_version_tonew() only does so for
> superblocks whose version is <= 3. i.e. filesystems that came from
> Irix 6.2 or earlier....
> 
> > I see that xfs_sb_version_toold() is not used anywhere, can we remove
> > it ?
> 
> Used by userspace, and seeing as this file is common between kernel
> and userspace, it hasn't been removed as that simply imposes higher
> maintenance cost on us.
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
