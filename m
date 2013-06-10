Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 13E9B7F52
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 18:20:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 015798F8035
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 16:20:48 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	qbHl1yJGV8C32pqN for <xfs@oss.sgi.com>;
	Mon, 10 Jun 2013 16:20:47 -0700 (PDT)
Date: Tue, 11 Jun 2013 09:20:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v8 3/5] xfs: Start using pquotaino from the superblock
Message-ID: <20130610232045.GE29376@dastard>
References: <1368220889-25188-1-git-send-email-sekharan@us.ibm.com>
	<1368220889-25188-4-git-send-email-sekharan@us.ibm.com>
	<20130517044604.GO24635@dastard>
	<1369433343.9551.958.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369433343.9551.958.camel@chandra-dt.ibm.com>
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

On Fri, May 24, 2013 at 05:09:03PM -0500, Chandra Seetharaman wrote:
> On Fri, 2013-05-17 at 14:46 +1000, Dave Chinner wrote:
> > On Fri, May 10, 2013 at 04:21:27PM -0500, Chandra Seetharaman wrote:
> > > Define a macro to check if the superblock has pquotino.
> > > 
> > > Keep backward compatibilty by alowing mount of older superblock
> > > with no separate pquota inode.
> > ....
> > 
> > > @@ -657,27 +680,51 @@ xfs_sb_to_disk(
> > >  	int		first;
> > >  	int		size;
> > >  	__uint16_t	qflags = from->sb_qflags;
> > > +	xfs_ino_t	gquotino = from->sb_gquotino;
> > >  
> > >  	ASSERT(fields);
> > >  	if (!fields)
> > >  		return;
> > >  
> > > -	if (fields & XFS_SB_QFLAGS) {
> > > +	if (!xfs_sb_version_has_pquota(from)) {
> > 
> > This should be moved to a separate function, I think.
> > 
> > > +		if (fields & XFS_SB_QFLAGS) {
> > > +			/*
> > > +			 * The in-core version of sb_qflags do not have
> > > +			 * XFS_OQUOTA_* flags, whereas the on-disk version
> > > +			 * does.  So, convert incore XFS_{PG}QUOTA_* flags
> > > +			 * to on-disk XFS_OQUOTA_* flags.
> > > +			 */
> > > +			qflags &= ~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
> > > +					XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
> > > +
> > > +			if (from->sb_qflags &
> > > +					(XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
> > > +				qflags |= XFS_OQUOTA_ENFD;
> > > +			if (from->sb_qflags &
> > > +					(XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))
> > > +				qflags |= XFS_OQUOTA_CHKD;
> > 
> > Now that we have the new flags set correct, write it directly to
> > to->sb_qflags and clear XFS_SB_QFLAGS from the fields varaible.
> 
> So, you are suggesting to move this block of functionality to a new
> function, and set the fields in the "to" data structure in that function
> and clear the appropriate bits in the same function ?

Yes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
