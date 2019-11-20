Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A988FC43215
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 16:43:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D67420895
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 16:43:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D07iTBo1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732884AbfKTQnc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 11:43:32 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52144 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732883AbfKTQnb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 11:43:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKGdQGK104445;
        Wed, 20 Nov 2019 16:43:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=dyCP/HmmhPu3GEA6wO8yYeZKfxmk+huL9k79Yzgy7Fc=;
 b=D07iTBo1h2lr49m/da2tO9gKDqGfc8b9zELJ1n+Yc/iDaWHqhxIyWSBzh7nRvuQ40dEK
 ZJ+Moc0C60+uwW/HQ4ByXROBf0tDAxskFYCfjzDc0LJcS+uVFLSaUSw25xjLwupWvPiz
 typYYkOuvYOFfmaZnP1YrLRp76ZHA0LASOKM9dWsXpKdofY9BTBqlTUDbyY14tCGhXWP
 kjeNL2FZNiQtzoFrVcQ3DNARkj3L41h7s7sW3DzalVqI96Fp0v7mYLU/UMTva1qf9K1f
 AJmmygmbo1YglRkrP/1mWk1z/nd/Uh9vyemoHA2XQlQWVHQuqC5LJ5DE1GlErtFhC7rM Gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wa8htxt9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 16:43:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKGcaDB135155;
        Wed, 20 Nov 2019 16:43:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2wcemgq2tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 16:43:25 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAKGhP6f007239;
        Wed, 20 Nov 2019 16:43:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 08:43:24 -0800
Date:   Wed, 20 Nov 2019 08:43:23 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: report ag header corruption errors to the
 health tracking system
Message-ID: <20191120164323.GJ6219@magnolia>
References: <157375555426.3692735.1357467392517392169.stgit@magnolia>
 <157375556683.3692735.8136460417251028810.stgit@magnolia>
 <20191120142047.GC15542@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120142047.GC15542@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 09:20:47AM -0500, Brian Foster wrote:
> On Thu, Nov 14, 2019 at 10:19:26AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Whenever we encounter a corrupt AG header, we should report that to the
> > health monitoring system for later reporting.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c    |    6 ++++++
> >  fs/xfs/libxfs/xfs_health.h   |    6 ++++++
> >  fs/xfs/libxfs/xfs_ialloc.c   |    3 +++
> >  fs/xfs/libxfs/xfs_refcount.c |    5 ++++-
> >  fs/xfs/libxfs/xfs_rmap.c     |    5 ++++-
> >  fs/xfs/libxfs/xfs_sb.c       |    2 ++
> >  fs/xfs/xfs_health.c          |   17 +++++++++++++++++
> >  fs/xfs/xfs_inode.c           |    9 +++++++++
> >  8 files changed, 51 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index c284e10af491..e75e3ae6c912 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -26,6 +26,7 @@
> >  #include "xfs_log.h"
> >  #include "xfs_ag_resv.h"
> >  #include "xfs_bmap.h"
> > +#include "xfs_health.h"
> >  
> >  extern kmem_zone_t	*xfs_bmap_free_item_zone;
> >  
> > @@ -699,6 +700,8 @@ xfs_alloc_read_agfl(
> >  			mp, tp, mp->m_ddev_targp,
> >  			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
> >  			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_agfl_buf_ops);
> > +	if (xfs_metadata_is_sick(error))
> > +		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGFL);
> 
> Any reason we couldn't do some of these in verifiers? I'm assuming we'd
> still need calls in various external corruption checks, but at least we
> wouldn't add a requirement to check all future buffer reads, etc.

I thought about that.  It would be wonderful if C had a syntactically
slick method to package a function + execution scope and pass that
through other functions to be called later. :)

For the per-AG stuff it wouldn't be hard to make the verifier functions
derive the AG number and call xfs_agno_mark_sick directly in the
verifier.  For per-inode metadata, we'd have to find a way to pass the
struct xfs_inode pointer to the verifier, which means that we'd have to
add that to struct xfs_buf.

xfs_buf is ~384 bytes so maybe adding another pointer for read context
wouldn't be terrible?  That would add a fair amount of ugly special
casing in the btree code to decide if we have an inode to pass through,
though it would solve the problem of the bmbt verifier not being able to
check the owner field in the btree block header.

OTOH that's 8 bytes of overhead that we can never get rid of even though
we only really need it the first time the buffer gets read in from disk.

Thoughts?

> >  	if (error)
> >  		return error;
> >  	xfs_buf_set_ref(bp, XFS_AGFL_REF);
> > @@ -722,6 +725,7 @@ xfs_alloc_update_counters(
> >  	if (unlikely(be32_to_cpu(agf->agf_freeblks) >
> >  		     be32_to_cpu(agf->agf_length))) {
> >  		xfs_buf_corruption_error(agbp);
> > +		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > @@ -2952,6 +2956,8 @@ xfs_read_agf(
> >  			mp, tp, mp->m_ddev_targp,
> >  			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
> >  			XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
> > +	if (xfs_metadata_is_sick(error))
> > +		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGF);
> >  	if (error)
> >  		return error;
> >  	if (!*bpp)
> > diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
> > index 3657a9cb8490..ce8954a10c66 100644
> > --- a/fs/xfs/libxfs/xfs_health.h
> > +++ b/fs/xfs/libxfs/xfs_health.h
> > @@ -123,6 +123,8 @@ void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
> >  void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
> >  		unsigned int *checked);
> >  
> > +void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
> > +		unsigned int mask);
> >  void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
> >  void xfs_ag_mark_checked(struct xfs_perag *pag, unsigned int mask);
> >  void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
> > @@ -203,4 +205,8 @@ void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
> >  void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
> >  void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
> >  
> > +#define xfs_metadata_is_sick(error) \
> > +	(unlikely((error) == -EFSCORRUPTED || (error) == -EIO || \
> > +		  (error) == -EFSBADCRC))
> 
> Why is -EIO considered sick? My understanding is that once something is
> marked sick, scrub is the only way to clear that state. -EIO can be
> transient, so afaict that means we could mark a persistent in-core state
> based on a transient/resolved issue.

I think it sounds reasonable that if the fs hits a metadata IO error
then the administrator should scrub that data structure to make sure
it's ok, and if so, clear the sick state.

Though I realized just now that if scrub isn't enabled then it's an
unfixable dead end so the EIO check should be gated on
CONFIG_XFS_ONLINE_SCRUB=y.

> Along similar lines, what's the expected behavior in the event of any of
> these errors for a kernel that might not support
> CONFIG_XFS_ONLINE_[SCRUB|REPAIR]? Just set the states that are never
> used for anything? If so, that seems Ok I suppose.. but it's a little
> awkward if we'd see the tracepoints and such associated with the state
> changes.

Even if scrub is disabled, the kernel will still set the sick state, and
later the administrator can query the filesystem with xfs_spaceman to
observe that sick state.

In the future, I will also use the per-AG sick states to steer
allocations away from known problematic AGs to try to avoid
unexpected shutdown in the middle of a transaction.

--D

> 
> Brian
> 
> > +
> >  #endif	/* __XFS_HEALTH_H__ */
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index 988cde7744e6..c401512a4350 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -27,6 +27,7 @@
> >  #include "xfs_trace.h"
> >  #include "xfs_log.h"
> >  #include "xfs_rmap.h"
> > +#include "xfs_health.h"
> >  
> >  /*
> >   * Lookup a record by ino in the btree given by cur.
> > @@ -2635,6 +2636,8 @@ xfs_read_agi(
> >  	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
> >  			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
> >  			XFS_FSS_TO_BB(mp, 1), 0, bpp, &xfs_agi_buf_ops);
> > +	if (xfs_metadata_is_sick(error))
> > +		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
> >  	if (error)
> >  		return error;
> >  	if (tp)
> > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> > index d7d702ee4d1a..25c87834e42a 100644
> > --- a/fs/xfs/libxfs/xfs_refcount.c
> > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > @@ -22,6 +22,7 @@
> >  #include "xfs_bit.h"
> >  #include "xfs_refcount.h"
> >  #include "xfs_rmap.h"
> > +#include "xfs_health.h"
> >  
> >  /* Allowable refcount adjustment amounts. */
> >  enum xfs_refc_adjust_op {
> > @@ -1177,8 +1178,10 @@ xfs_refcount_finish_one(
> >  				XFS_ALLOC_FLAG_FREEING, &agbp);
> >  		if (error)
> >  			return error;
> > -		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
> > +		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
> > +			xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGF);
> >  			return -EFSCORRUPTED;
> > +		}
> >  
> >  		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
> >  		if (!rcur) {
> > diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> > index ff9412f113c4..a54a3c129cce 100644
> > --- a/fs/xfs/libxfs/xfs_rmap.c
> > +++ b/fs/xfs/libxfs/xfs_rmap.c
> > @@ -21,6 +21,7 @@
> >  #include "xfs_errortag.h"
> >  #include "xfs_error.h"
> >  #include "xfs_inode.h"
> > +#include "xfs_health.h"
> >  
> >  /*
> >   * Lookup the first record less than or equal to [bno, len, owner, offset]
> > @@ -2400,8 +2401,10 @@ xfs_rmap_finish_one(
> >  		error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
> >  		if (error)
> >  			return error;
> > -		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
> > +		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
> > +			xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGF);
> >  			return -EFSCORRUPTED;
> > +		}
> >  
> >  		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
> >  		if (!rcur) {
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index 0ac69751fe85..4a923545465d 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -1169,6 +1169,8 @@ xfs_sb_read_secondary(
> >  	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
> >  			XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> >  			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
> > +	if (xfs_metadata_is_sick(error))
> > +		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_SB);
> >  	if (error)
> >  		return error;
> >  	xfs_buf_set_ref(bp, XFS_SSB_REF);
> > diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> > index 860dc70c99e7..36c32b108b39 100644
> > --- a/fs/xfs/xfs_health.c
> > +++ b/fs/xfs/xfs_health.c
> > @@ -200,6 +200,23 @@ xfs_rt_measure_sickness(
> >  	spin_unlock(&mp->m_sb_lock);
> >  }
> >  
> > +/* Mark unhealthy per-ag metadata given a raw AG number. */
> > +void
> > +xfs_agno_mark_sick(
> > +	struct xfs_mount	*mp,
> > +	xfs_agnumber_t		agno,
> > +	unsigned int		mask)
> > +{
> > +	struct xfs_perag	*pag = xfs_perag_get(mp, agno);
> > +
> > +	/* per-ag structure not set up yet? */
> > +	if (!pag)
> > +		return;
> > +
> > +	xfs_ag_mark_sick(pag, mask);
> > +	xfs_perag_put(pag);
> > +}
> > +
> >  /* Mark unhealthy per-ag metadata. */
> >  void
> >  xfs_ag_mark_sick(
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 401da197f012..a2812cea748d 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -35,6 +35,7 @@
> >  #include "xfs_log.h"
> >  #include "xfs_bmap_btree.h"
> >  #include "xfs_reflink.h"
> > +#include "xfs_health.h"
> >  
> >  kmem_zone_t *xfs_inode_zone;
> >  
> > @@ -787,6 +788,8 @@ xfs_ialloc(
> >  	 */
> >  	if ((pip && ino == pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
> >  		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
> > +		xfs_agno_mark_sick(mp, XFS_INO_TO_AGNO(mp, ino),
> > +				XFS_SICK_AG_INOBT);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > @@ -2137,6 +2140,7 @@ xfs_iunlink_update_bucket(
> >  	 */
> >  	if (old_value == new_agino) {
> >  		xfs_buf_corruption_error(agibp);
> > +		xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGI);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > @@ -2203,6 +2207,7 @@ xfs_iunlink_update_inode(
> >  	if (!xfs_verify_agino_or_null(mp, agno, old_value)) {
> >  		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> >  				sizeof(*dip), __this_address);
> > +		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
> >  		error = -EFSCORRUPTED;
> >  		goto out;
> >  	}
> > @@ -2217,6 +2222,7 @@ xfs_iunlink_update_inode(
> >  		if (next_agino != NULLAGINO) {
> >  			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> >  					dip, sizeof(*dip), __this_address);
> > +			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
> >  			error = -EFSCORRUPTED;
> >  		}
> >  		goto out;
> > @@ -2271,6 +2277,7 @@ xfs_iunlink(
> >  	if (next_agino == agino ||
> >  	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
> >  		xfs_buf_corruption_error(agibp);
> > +		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > @@ -2408,6 +2415,7 @@ xfs_iunlink_map_prev(
> >  			XFS_CORRUPTION_ERROR(__func__,
> >  					XFS_ERRLEVEL_LOW, mp,
> >  					*dipp, sizeof(**dipp));
> > +			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
> >  			error = -EFSCORRUPTED;
> >  			return error;
> >  		}
> > @@ -2454,6 +2462,7 @@ xfs_iunlink_remove(
> >  	if (!xfs_verify_agino(mp, agno, head_agino)) {
> >  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> >  				agi, sizeof(*agi));
> > +		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > 
> 
