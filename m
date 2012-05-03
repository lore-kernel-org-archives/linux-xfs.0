Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q43KHxIr197888 for <xfs@oss.sgi.com>; Thu, 3 May 2012 15:17:59 -0500
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153]) by
	cuda.sgi.com with ESMTP id rFPsBM4cRaFmkuz9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 May 2012 13:17:58 -0700 (PDT)
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 3 May 2012 14:17:55 -0600
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 2218E19D804A
	for <xfs@oss.sgi.com>; Thu,  3 May 2012 14:16:50 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q43KGQ1V063162 for <xfs@oss.sgi.com>; Thu, 3 May 2012 14:16:33 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id q43KGNvc000317
	for <xfs@oss.sgi.com>; Thu, 3 May 2012 14:16:23 -0600
Subject: Re: [RFC v5 PATCH 3/4] xfs: Add pquotaino to on-disk super block
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20120503171608.GP16881@sgi.com>
References: <20120314202623.17044.90045.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120314202641.17044.32835.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120503171608.GP16881@sgi.com>
Date: Thu, 03 May 2012 15:16:22 -0500
Message-ID: <1336076182.1118.73.camel@chandra-lucid.austin.ibm.com>
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

On Thu, 2012-05-03 at 12:16 -0500, Ben Myers wrote:
> Chandra,
> 
> On Wed, Mar 14, 2012 at 03:26:42PM -0500, Chandra Seetharaman wrote:
> > >From 9d32afb9cc284b2511951c45b47f6a73dfd0a7e1 Mon Sep 17 00:00:00 2001
> > From: Chandra Seetharaman <sekharan@us.ibm.com>
> > Date: Wed, 14 Mar 2012 14:26:20 -0500
> > Subject: [PATCH 3/4] Add a new field to the superblock to add support for seperate pquota
> >  with a specific version.
> > 
> > No change made yet to gather both project and group quota with quotactl.
> 
> This note that you're going to do in the next patch is useful, but please also
> put a description of what you're doing in this patch.  ;)
> 

You want more info than the line above it ? (Add a new field to the
superblock to add support for seperate pquota with a specific version.)

I can do it.
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> ...
> 
> > @@ -1055,19 +1057,22 @@ xfs_qm_qino_alloc(
> >  		ASSERT((sbfields & (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> >  				   XFS_SB_GQUOTINO | XFS_SB_QFLAGS)) ==
> >  		       (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> > -			XFS_SB_GQUOTINO | XFS_SB_QFLAGS));
> > +			XFS_SB_GQUOTINO | XFS_SB_PQUOTINO | XFS_SB_QFLAGS));
> >  
> >  		xfs_sb_version_addquota(&mp->m_sb);
> >  		mp->m_sb.sb_uquotino = NULLFSINO;
> >  		mp->m_sb.sb_gquotino = NULLFSINO;
> > +		mp->m_sb.sb_pquotino = NULLFSINO;
> >  
> >  		/* qflags will get updated _after_ quotacheck */
> >  		mp->m_sb.sb_qflags = 0;
> >  	}
> >  	if (flags & XFS_QMOPT_UQUOTA)
> >  		mp->m_sb.sb_uquotino = (*ip)->i_ino;
> > -	else
> > +	else if (flags & XFS_QMOPT_GQUOTA)
> >  		mp->m_sb.sb_gquotino = (*ip)->i_ino;
> > +	else
> 
> Maybe?
> 	     {
> 		ASSERT(flags & XFS_QMOPT_PQUOTA);
> > +		mp->m_sb.sb_pquotino = (*ip)->i_ino;

will do.

> 	}
> ...
> 
> > @@ -439,10 +441,13 @@ xfs_qm_scall_getqstat(
> >  	out->qs_pad = 0;
> >  	out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
> >  	out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
> > +	if (&out->qs_gquota != &out->qs_pquota)
> > +		out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
> 
> I was a little surprised not to get a warning for that test.  

Yeah, compiler is happy with it :)

> 
> ...
> 
> > @@ -1317,6 +1311,15 @@ xfs_fs_fill_super(
> >  	if (error)
> >  		goto out_destroy_counters;
> >  
> > +	if ((mp->m_qflags & (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE)) &&
> > +	    (mp->m_qflags & (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE)) &&
> > +	    !xfs_sb_version_has_no_oquota(&mp->m_sb)) {
> > +		xfs_warn(mp, "Super block does not support "
> > +				 "project and group quota together");
> > +		error = EINVAL;
> > +		goto out_free_sb;
> > +	}
> > +
> 
> You'd see this warning if you have an old superblock with the new flags.  Maybe
> it is worth writing a test for that.

You mean old superblock with this code and -opquota,gquota on mount,
correct ? Then yes, I can add that.


> 
> ...
> 
> > diff --git a/include/linux/dqblk_xfs.h b/include/linux/dqblk_xfs.h
> > index 8655280..f17e3bb 100644
> > --- a/include/linux/dqblk_xfs.h
> > +++ b/include/linux/dqblk_xfs.h
> > @@ -155,6 +155,7 @@ typedef struct fs_quota_stat {
> >  	__s8		qs_pad;		/* unused */
> >  	fs_qfilestat_t	qs_uquota;	/* user quota storage information */
> >  	fs_qfilestat_t	qs_gquota;	/* group quota storage information */
> > +#define qs_pquota	qs_gquota
> 
> Cool.  This #define goes away in the next patch.
> 
> I've been over this and it is looking pretty good to me...  I'm thinking about
> what basic xfstests would be good to have for this feature.
> 
> Old sb_version with new flags, 
> new sb_version with old flags, etc.

I am little confused about what you mean by flags here. From the user
point of view, they can either use pquota and gquota together or not.

With old version using them together would fail with one message  
"cannot mount with both project and group quota"

with new code it will fail with a different message
"Super block does not support project and group quota together"

> 
> I'll revisit that shortly.
> 
> -Ben
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
