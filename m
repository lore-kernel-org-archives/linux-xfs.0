Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 350F4C432C3
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 16:13:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F345620674
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 16:13:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hUO+f6/O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbfKTQNG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 11:13:06 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56684 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729412AbfKTQNG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 11:13:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKFsQxf038659;
        Wed, 20 Nov 2019 16:13:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=0VChJ5F2Y/GobP+iYmPaS/EIdzYuLfreXwG0trrgps8=;
 b=hUO+f6/OK9J6K1czFlmR8i7U39zz9tRnvM6UmA6HGO0QGS5YvaFGTU1RlQXzlSS4m2Jd
 /UlMbkYlyKWbRz9cbu+pS1UpgoA01spA1Ef76MRGypApC6bBfteKsZTzW6qClzh0UH3+
 dO8Bq2JE83RXSDrTwom4s+kf7kRfLgMISYaUup+c1R4AJ07C0Epk0ztn8j5/50dA3Igd
 kQIfxfTYBjFM67Y5oY2MPISKuFn1TpXS4xRpLHXYqmHMeMM7z55hP4WhK01Yjin1djaa
 t7PEdwmb7xz30kw/kvpEBh8G9kwmN8ClWjgyna2f6AEdm0ZGMZUoeSJ1KNRNMbl8kQvA 1g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wa9rqpgkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 16:13:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKFxSf2070962;
        Wed, 20 Nov 2019 16:13:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2wd46wnryw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 16:13:00 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAKGD0Zr023829;
        Wed, 20 Nov 2019 16:13:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 08:12:59 -0800
Date:   Wed, 20 Nov 2019 08:12:57 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: separate the marking of sick and checked
 metadata
Message-ID: <20191120161257.GI6219@magnolia>
References: <157375555426.3692735.1357467392517392169.stgit@magnolia>
 <157375556076.3692735.11924756899356721108.stgit@magnolia>
 <20191120142035.GB15542@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120142035.GB15542@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 09:20:35AM -0500, Brian Foster wrote:
> On Thu, Nov 14, 2019 at 10:19:20AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Split the setting of the sick and checked masks into separate functions
> > as part of preparing to add the ability for regular runtime fs code
> > (i.e. not scrub) to mark metadata structures sick when corruptions are
> > found.  Improve the documentation of libxfs' requirements for helper
> > behavior.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_health.h |   24 ++++++++++++++++++----
> >  fs/xfs/scrub/health.c      |   20 +++++++++++-------
> >  fs/xfs/xfs_health.c        |   49 ++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_mount.c         |    5 ++++
> >  4 files changed, 85 insertions(+), 13 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
> > index 272005ac8c88..3657a9cb8490 100644
> > --- a/fs/xfs/libxfs/xfs_health.h
> > +++ b/fs/xfs/libxfs/xfs_health.h
> > @@ -26,9 +26,11 @@
> >   * and the "sick" field tells us if that piece was found to need repairs.
> >   * Therefore we can conclude that for a given sick flag value:
> >   *
> > - *  - checked && sick  => metadata needs repair
> > - *  - checked && !sick => metadata is ok
> > - *  - !checked         => has not been examined since mount
> > + *  - checked && sick   => metadata needs repair
> > + *  - checked && !sick  => metadata is ok
> > + *  - !checked && sick  => errors have been observed during normal operation,
> > + *                         but the metadata has not been checked thoroughly
> > + *  - !checked && !sick => has not been examined since mount
> >   */
> >  
> 
> I don't see this change in the provided repo. Which is the right patch?

Hmm, I guess I need to update the repo again. :/

> >  struct xfs_mount;
> > @@ -97,24 +99,38 @@ struct xfs_fsop_geom;
> >  				 XFS_SICK_INO_SYMLINK | \
> >  				 XFS_SICK_INO_PARENT)
> >  
> > -/* These functions must be provided by the xfs implementation. */
> > +/*
> > + * These functions must be provided by the xfs implementation.  Function
> > + * behavior with respect to the first argument should be as follows:
> > + *
> > + * xfs_*_mark_sick:    set the sick flags and do not set checked flags.
> 
> Nit: It's probably not necessary to say that we don't set the checked
> flags here given the comment/function below.

Ok.

--D

> Brian
> 
> > + * xfs_*_mark_checked: set the checked flags.
> > + * xfs_*_mark_healthy: clear the sick flags and set the checked flags.
> > + *
> > + * xfs_*_measure_sickness: return the sick and check status in the provided
> > + * out parameters.
> > + */
> >  
> >  void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask);
> > +void xfs_fs_mark_checked(struct xfs_mount *mp, unsigned int mask);
> >  void xfs_fs_mark_healthy(struct xfs_mount *mp, unsigned int mask);
> >  void xfs_fs_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
> >  		unsigned int *checked);
> >  
> >  void xfs_rt_mark_sick(struct xfs_mount *mp, unsigned int mask);
> > +void xfs_rt_mark_checked(struct xfs_mount *mp, unsigned int mask);
> >  void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
> >  void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
> >  		unsigned int *checked);
> >  
> >  void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
> > +void xfs_ag_mark_checked(struct xfs_perag *pag, unsigned int mask);
> >  void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
> >  void xfs_ag_measure_sickness(struct xfs_perag *pag, unsigned int *sick,
> >  		unsigned int *checked);
> >  
> >  void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask);
> > +void xfs_inode_mark_checked(struct xfs_inode *ip, unsigned int mask);
> >  void xfs_inode_mark_healthy(struct xfs_inode *ip, unsigned int mask);
> >  void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
> >  		unsigned int *checked);
> > diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
> > index 83d27cdf579b..a402f9026d5f 100644
> > --- a/fs/xfs/scrub/health.c
> > +++ b/fs/xfs/scrub/health.c
> > @@ -137,30 +137,34 @@ xchk_update_health(
> >  	switch (type_to_health_flag[sc->sm->sm_type].group) {
> >  	case XHG_AG:
> >  		pag = xfs_perag_get(sc->mp, sc->sm->sm_agno);
> > -		if (bad)
> > +		if (bad) {
> >  			xfs_ag_mark_sick(pag, sc->sick_mask);
> > -		else
> > +			xfs_ag_mark_checked(pag, sc->sick_mask);
> > +		} else
> >  			xfs_ag_mark_healthy(pag, sc->sick_mask);
> >  		xfs_perag_put(pag);
> >  		break;
> >  	case XHG_INO:
> >  		if (!sc->ip)
> >  			return;
> > -		if (bad)
> > +		if (bad) {
> >  			xfs_inode_mark_sick(sc->ip, sc->sick_mask);
> > -		else
> > +			xfs_inode_mark_checked(sc->ip, sc->sick_mask);
> > +		} else
> >  			xfs_inode_mark_healthy(sc->ip, sc->sick_mask);
> >  		break;
> >  	case XHG_FS:
> > -		if (bad)
> > +		if (bad) {
> >  			xfs_fs_mark_sick(sc->mp, sc->sick_mask);
> > -		else
> > +			xfs_fs_mark_checked(sc->mp, sc->sick_mask);
> > +		} else
> >  			xfs_fs_mark_healthy(sc->mp, sc->sick_mask);
> >  		break;
> >  	case XHG_RT:
> > -		if (bad)
> > +		if (bad) {
> >  			xfs_rt_mark_sick(sc->mp, sc->sick_mask);
> > -		else
> > +			xfs_rt_mark_checked(sc->mp, sc->sick_mask);
> > +		} else
> >  			xfs_rt_mark_healthy(sc->mp, sc->sick_mask);
> >  		break;
> >  	default:
> > diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> > index 8e0cb05a7142..860dc70c99e7 100644
> > --- a/fs/xfs/xfs_health.c
> > +++ b/fs/xfs/xfs_health.c
> > @@ -100,6 +100,18 @@ xfs_fs_mark_sick(
> >  
> >  	spin_lock(&mp->m_sb_lock);
> >  	mp->m_fs_sick |= mask;
> > +	spin_unlock(&mp->m_sb_lock);
> > +}
> > +
> > +/* Mark per-fs metadata as having been checked. */
> > +void
> > +xfs_fs_mark_checked(
> > +	struct xfs_mount	*mp,
> > +	unsigned int		mask)
> > +{
> > +	ASSERT(!(mask & ~XFS_SICK_FS_PRIMARY));
> > +
> > +	spin_lock(&mp->m_sb_lock);
> >  	mp->m_fs_checked |= mask;
> >  	spin_unlock(&mp->m_sb_lock);
> >  }
> > @@ -143,6 +155,19 @@ xfs_rt_mark_sick(
> >  
> >  	spin_lock(&mp->m_sb_lock);
> >  	mp->m_rt_sick |= mask;
> > +	spin_unlock(&mp->m_sb_lock);
> > +}
> > +
> > +/* Mark realtime metadata as having been checked. */
> > +void
> > +xfs_rt_mark_checked(
> > +	struct xfs_mount	*mp,
> > +	unsigned int		mask)
> > +{
> > +	ASSERT(!(mask & ~XFS_SICK_RT_PRIMARY));
> > +	trace_xfs_rt_mark_sick(mp, mask);
> > +
> > +	spin_lock(&mp->m_sb_lock);
> >  	mp->m_rt_checked |= mask;
> >  	spin_unlock(&mp->m_sb_lock);
> >  }
> > @@ -186,6 +211,18 @@ xfs_ag_mark_sick(
> >  
> >  	spin_lock(&pag->pag_state_lock);
> >  	pag->pag_sick |= mask;
> > +	spin_unlock(&pag->pag_state_lock);
> > +}
> > +
> > +/* Mark per-ag metadata as having been checked. */
> > +void
> > +xfs_ag_mark_checked(
> > +	struct xfs_perag	*pag,
> > +	unsigned int		mask)
> > +{
> > +	ASSERT(!(mask & ~XFS_SICK_AG_PRIMARY));
> > +
> > +	spin_lock(&pag->pag_state_lock);
> >  	pag->pag_checked |= mask;
> >  	spin_unlock(&pag->pag_state_lock);
> >  }
> > @@ -229,6 +266,18 @@ xfs_inode_mark_sick(
> >  
> >  	spin_lock(&ip->i_flags_lock);
> >  	ip->i_sick |= mask;
> > +	spin_unlock(&ip->i_flags_lock);
> > +}
> > +
> > +/* Mark inode metadata as having been checked. */
> > +void
> > +xfs_inode_mark_checked(
> > +	struct xfs_inode	*ip,
> > +	unsigned int		mask)
> > +{
> > +	ASSERT(!(mask & ~XFS_SICK_INO_PRIMARY));
> > +
> > +	spin_lock(&ip->i_flags_lock);
> >  	ip->i_checked |= mask;
> >  	spin_unlock(&ip->i_flags_lock);
> >  }
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index fca65109cf24..27aa143d524b 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -555,8 +555,10 @@ xfs_check_summary_counts(
> >  	if (XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
> >  	    (mp->m_sb.sb_fdblocks > mp->m_sb.sb_dblocks ||
> >  	     !xfs_verify_icount(mp, mp->m_sb.sb_icount) ||
> > -	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount))
> > +	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount)) {
> >  		xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
> > +		xfs_fs_mark_checked(mp, XFS_SICK_FS_COUNTERS);
> > +	}
> >  
> >  	/*
> >  	 * We can safely re-initialise incore superblock counters from the
> > @@ -1322,6 +1324,7 @@ xfs_force_summary_recalc(
> >  		return;
> >  
> >  	xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
> > +	xfs_fs_mark_checked(mp, XFS_SICK_FS_COUNTERS);
> >  }
> >  
> >  /*
> > 
> 
