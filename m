Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8203C7F37
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 17:54:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7224A304043
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 15:54:51 -0700 (PDT)
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id jkNJvE28NWR89NhD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Jul 2013 15:54:50 -0700 (PDT)
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 15 Jul 2013 16:54:49 -0600
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id CF21719D8046
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 16:54:35 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r6FMskY2144216 for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 16:54:46 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r6FMsjeH031950
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 16:54:46 -0600
Subject: Re: [PATCH] xfs: Initialize all quota inodes to be NULLFSINO
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130713021349.GH3438@dastard>
References: <1373593665.20769.10.camel@chandra-dt.ibm.com>
	<20130713021349.GH3438@dastard>
Date: Mon, 15 Jul 2013 17:54:45 -0500
Message-ID: <1373928885.20769.42.camel@chandra-dt.ibm.com>
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
Cc: XFS mailing list <xfs@oss.sgi.com>

On Sat, 2013-07-13 at 12:13 +1000, Dave Chinner wrote:
> On Thu, Jul 11, 2013 at 08:47:45PM -0500, Chandra Seetharaman wrote:
> > 
> > mkfs doesn't initialize the quota inodes to NULLFSINO as it
> > does for the other internal inodes. This leads to check for two
> > values (0 and NULLFSINO) to make sure if a quota inode is
> > valid.
> > 
> > Solve that problem by initializing the values to NULLFSINO
> > if they are 0.
> > 
> > Note that these values are not written back to on-disk
> > superblock unless some quota is enabled on the filesystem.
> > 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > ---
> >  fs/xfs/xfs_mount.c |   12 ++++++++++++
> >  1 files changed, 12 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 2b0ba35..8b95933 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -572,6 +572,18 @@ out_unwind:
> >  static void
> >  xfs_sb_quota_from_disk(struct xfs_sb *sbp)
> >  {
> > +	/*
> > +	 * older mkfs doesn't initialize quota inodes to NULLFSINO,
> > +	 * which leads to two values for a quota inode to be invalid:
> > +	 * 0 and NULLFSINO. Fix it.
> > +	 */
> > +	if (sbp->sb_uquotino == 0)
> > +		sbp->sb_uquotino = NULLFSINO;
> > +	if (sbp->sb_gquotino == 0)
> > +		sbp->sb_gquotino = NULLFSINO;
> > +	if (sbp->sb_pquotino == 0)
> > +		sbp->sb_pquotino = NULLFSINO;
> 
> There coment needs to point out that this is changing the in-memory
> superblock value right here, so we don't need to make changing
> sb_pquotino dependent on the superblock having support for this
> feature.

But, we are not just changing just for sb_pquotino, right ?

Since we are changing all the fields independent of superblock
supporting sb_pquotino, I thought the comment should be generic.

> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
