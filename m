Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q43KQgt1198510 for <xfs@oss.sgi.com>; Thu, 3 May 2012 15:26:42 -0500
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id p5PiXR5bbXesP2MB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 May 2012 13:26:42 -0700 (PDT)
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 3 May 2012 14:26:41 -0600
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com
	[9.17.195.107])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 4145619D804E
	for <xfs@oss.sgi.com>; Thu,  3 May 2012 14:26:28 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q43KQKvj205308 for <xfs@oss.sgi.com>; Thu, 3 May 2012 14:26:28 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id q43KQI7D025907
	for <xfs@oss.sgi.com>; Thu, 3 May 2012 14:26:18 -0600
Subject: Re: [PATCH 1/4] xfsprogs: Remove incore use of XFS_OQUOTA_ENFD and
	XFS_OQUOTA_CHKD
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20120503200457.GQ16881@sgi.com>
References: <20120123173243.31735.37262.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120123173249.31735.17660.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120503200457.GQ16881@sgi.com>
Date: Thu, 03 May 2012 15:26:17 -0500
Message-ID: <1336076777.1118.80.camel@chandra-lucid.austin.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, 2012-05-03 at 15:04 -0500, Ben Myers wrote:
> On Mon, Jan 23, 2012 at 11:32:49AM -0600, Chandra Seetharaman wrote:
> > >From ba28fc49821079a734f24af05671155f6b32b20c Mon Sep 17 00:00:00 2001
> > From: Chandra Seetharaman <sekharan@us.ibm.com>
> > Date: Tue, 13 Dec 2011 15:55:34 -0600
> > Subject: [PATCH 1/4] Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD. Instead,
> >  start using XFS_GQUOTA_.* XFS_PQUOTA_.* counterparts.
> > 
> > No changes is made to the on-disk version of the superblock yet. On-disk
>              are						   The 
> 
will fix
 
> > copy still uses XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD.
> <

<snip>
> >  
> > +static inline int xfs_sb_version_hasnooquota(xfs_sb_t *sbp)
> 
> IIRC, in the kernel you used xfs_sb_version_has_no_oquota.  I think you should
> use the same name in xfsprogs.

yes, will fix.
> 
> > +{
> > +	return xfs_sb_version_hasmorebits(sbp) &&
> > +		(sbp->sb_features2 & XFS_SB_VERSION2_NO_OQUOTA);
> > +}
> > +
> > +static inline void xfs_sb_version_addnooquota(xfs_sb_t *sbp)
> > +{
> > +	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
> > +	sbp->sb_features2 |= XFS_SB_VERSION2_PROJID32BIT;
> 
> I'm not sure about this.  I don't think addnooquota necessarily implies a 32
> bit project id.  What say you?

It is cut-n-paste issue, it should be XFS_SB_VERSION2_NO_OQUOTA
will fix it.
> 
> Else, the patch looks pretty good.
> 
> -Ben
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
