Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0E0FC7CBF
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 12:14:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 83C1AAC007
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 10:14:08 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id PXR3HbxbcrDe9awo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Jul 2013 10:14:07 -0700 (PDT)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 3 Jul 2013 13:14:06 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id F2877C90026
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 13:14:01 -0400 (EDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r63HE00g099178 for <xfs@oss.sgi.com>; Wed, 3 Jul 2013 13:14:02 -0400
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r63HC9si004617
	for <xfs@oss.sgi.com>; Wed, 3 Jul 2013 11:12:10 -0600
Subject: Re: [PATCH v10 09/11] xfs: Start using pquotaino from the superblock.
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1372701567.9777.164.camel@chandra-dt.ibm.com>
References: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
	<1372371914-11370-10-git-send-email-sekharan@us.ibm.com>
	<20130701020634.GE27780@dastard>
	<1372701567.9777.164.camel@chandra-dt.ibm.com>
Date: Wed, 03 Jul 2013 12:12:07 -0500
Message-ID: <1372871528.9777.170.camel@chandra-dt.ibm.com>
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

Any comments ?

Thanks

Chandra
On Mon, 2013-07-01 at 12:59 -0500, Chandra Seetharaman wrote:
> On Mon, 2013-07-01 at 12:06 +1000, Dave Chinner wrote:
> > On Thu, Jun 27, 2013 at 05:25:12PM -0500, Chandra Seetharaman wrote:
> > > Start using pquotino and define a macro to check if the
> > > superblock has pquotino.
> > > 
> > > Keep backward compatibilty by alowing mount of older superblock
> > > with no separate pquota inode.
> > > 
> > > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > 
> > This is unchanged from the previous version, so all of my review
> > comments from here:
> > 
> > http://oss.sgi.com/pipermail/xfs/2013-June/027637.html
> > 
> > are still unaddressed.
> 
> See the other email I sent on this context.
> > 
> > Also:
> > 
> > > @@ -885,6 +905,18 @@ reread:
> > >  	 */
> > >  	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
> > >  
> > > +	if (!xfs_sb_version_has_pquota(&mp->m_sb) && (XFS_IS_PQUOTA_ON(mp))) {
> > > +		/*
> > > +		 * On disk superblock only has sb_gquotino, and incore
> > > +		 * superblock has both sb_gquotino and sb_pquotino.
> > > +		 * But, only one them is supported at any point of time.
> > > +		 * So, if PQUOTA is set in disk superblock, copy over
> > > +		 * sb_gquotino to sb_pquotino.
> > > +		 */
> > > +		mp->m_sb.sb_pquotino = mp->m_sb.sb_gquotino;
> > > +		mp->m_sb.sb_gquotino = NULLFSINO;
> > > +	}
> > > +
> > >  	xfs_sb_quota_from_disk(&mp->m_sb);
> > 
> > This code should be inside xfs_sb_quota_from_disk()....
> 
> will move.
> > 
> > Cheers,
> > 
> > Dave.
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
