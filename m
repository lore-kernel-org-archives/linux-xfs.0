Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N0PSk1088197 for <xfs@oss.sgi.com>; Wed, 22 Aug 2012 19:25:28 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GyBf13mfC7unuVQD for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 17:26:13 -0700 (PDT)
Date: Thu, 23 Aug 2012 10:25:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v6 PATCH 3/5] xfs: Add pquotaino to on-disk super block
Message-ID: <20120823002553.GT19235@dastard>
References: <20120720230202.20477.69766.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120720230241.20477.50076.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120815020936.GS2877@dastard>
	<1345678248.2260.31.camel@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1345678248.2260.31.camel@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 22, 2012 at 06:30:48PM -0500, Chandra Seetharaman wrote:
> On Wed, 2012-08-15 at 12:09 +1000, Dave Chinner wrote:
> > On Fri, Jul 20, 2012 at 06:02:41PM -0500, Chandra Seetharaman wrote:
.....
> > > +		if (to->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
> > > +			xfs_notice(mp, "Super block has XFS_OQUOTA bits with "
> > > +			"version NO_OQUOTA. Fixing it.\n");
> > > +			to->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
> > > +		}
> > > +		to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
> > 
> > So we have a feature bit set, but old quota bits set. How can that
> > happen?
> > 
> > If it does occur, doesn't that mean we cannot trust the group or
> > project quotas to be correct, so at minimum this case needs to
> > trigger a quotacheck for both group and project quotas?
> 
> Sure, will do a quotacheck here. I just call xfs_qm_quotacheck() and
> fail if it fails ?

The quotacheck occurs later in the mount process. IIRC, just
clearing the relevant XFS_[UGP]QUOTA_CHKD flag will cause a quota
check to be done at the appropriate time.

> > > +		}
> > > +		if (to->sb_qflags & XFS_OQUOTA_ENFD)
> > > +			to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
> > > +					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
> > > +		if (to->sb_qflags & XFS_OQUOTA_CHKD)
> > > +			to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
> > > +					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
> > 
> > what do you do if both XFS_PQUOTA_ACCT and XFS_GQUOTA_ACCT are set?
> > i.e. both quotas were active even though the feature bit wasn't set?
> 
> I will do a check on both flags being set and do a quotacheck ?

Yes, I think that will be sufficient with an appropriate warning.

> > >  		} else {
> > >  			switch (size) {
> > >  			case 2:
> > > @@ -759,6 +803,12 @@ reread:
> > >  		goto reread;
> > >  	}
> > >  
> > > +	if (!xfs_sb_version_has_no_oquota(&mp->m_sb) &&
> > > +			XFS_IS_PQUOTA_ON(mp)) {
> > > +		mp->m_sb.sb_pquotino = mp->m_sb.sb_gquotino;
> > > +		mp->m_sb.sb_gquotino = NULLFSINO;
> > > +	}
> > 
> > why this is necessary? Didn't the earlier xfs_sb_from_disk() call
> > deal with this?
> 
> The call in xfs_sb_from_disk() only sets if the superblock has pquota
> already. 
> 
> This sets up the fields when superblock didn't have it, but the user
> specified pquota as a mount option.

Ah, so it is the same as the previous case I mentioned needs a
comment. Can you document this here as well?

> > > @@ -838,19 +840,22 @@ xfs_qm_qino_alloc(
> > >  		ASSERT((sbfields & (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> > >  				   XFS_SB_GQUOTINO | XFS_SB_QFLAGS)) ==
> > >  		       (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> > > -			XFS_SB_GQUOTINO | XFS_SB_QFLAGS));
> > > +			XFS_SB_GQUOTINO | XFS_SB_PQUOTINO | XFS_SB_QFLAGS));
> > 
> > Did you test this with CONFIG_XFS_DEBUG=y? It will always fail
> > because you didn't add XFS_SB_PQUOTINO to the sbfields mask....
> 
> In my box, I always had problems with DEBUG :(... So, I stopped testing
> with it.

Hmmm. DEBUG shouldn't cause you any extra problems unless there
really is something wrong - I run almost exclusively with DEBUG
enabled and I rarely have problems with spurious ASSERT()s
triggering. It's better to report spurious/unrelated ASSERT()
failures than to ignore them. 

[ FWIW, the only time I turnoff DEBUG is when I'm doing performance
benchmarking to get maximum numbers - DEBUG drops metadata
throughput by about 25% and changes allocation patterns to improve
code coverage, so the results of performance testing with DEBUG are
not really representative. ]

In the mean time, run with DEBUG without your patches and exclude
all the tests that trigger problems on a vanilla kernel (e.g. via
'echo 068 >> expunged') and then run with you patches. Any new
failures are likely to be caused by your patches and need to be
analysed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
