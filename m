Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 79BA27F37
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 09:50:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CAD80AC006
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 07:50:21 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id F2YYIVBXSxQl6NYS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 12 Jul 2013 07:50:17 -0700 (PDT)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 12 Jul 2013 10:50:16 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 86612C9003E
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 10:50:12 -0400 (EDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r6CEoDJr307822 for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 10:50:13 -0400
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r6CEoCuQ032721
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 08:50:12 -0600
Subject: Re: [PATCH] xfs: Initialize all quota inodes to be NULLFSINO
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130712142751.GA11446@andromeda.usersys.redhat.com>
References: <1373593665.20769.10.camel@chandra-dt.ibm.com>
	<20130712142751.GA11446@andromeda.usersys.redhat.com>
Date: Fri, 12 Jul 2013 09:50:11 -0500
Message-ID: <1373640611.20769.13.camel@chandra-dt.ibm.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Fri, 2013-07-12 at 11:27 -0300, Carlos Maiolino wrote:
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
> > +
> >  	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
> >  		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
> >  					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
> > -- 
> > 1.7.1
> > 
> Hi,
> 
> in this case, wouldn't be better to make mkfs initialize the quota inodes with
> NULLFSINO instead of need to convert it into kernel?

Hi Carlos,

Yes. I will send a patch for mkfs also (to initialize it to NULLFSINO).

We still need the kernel fix for the already existing filessytems.

Chadnra
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
