Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C79C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:38:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8137D2064B
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:38:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oW6utfYU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgGOSit (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 14:38:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51756 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgGOSis (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 14:38:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FIWSr6050452;
        Wed, 15 Jul 2020 18:38:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=+ssFusMxYEOIjBH5HYtBRJcbGrs8IOZkfQXawpvAmEs=;
 b=oW6utfYUxa08Fuqp+GAAdRu3s1mbHh88Cn+Gbp+6fs9Ht9r9yK6OYyuL2QC2iOiB7BNz
 IPuXLcjukBZPic4YDbqrt4HUL0hXdFDftlMskzC1s4IlVo5AkQj0V41oGlNpTbMzL/Jh
 mhcNe+Lg5maXTVi8/kzKIMKXmkWCC+WIwlGsREH0AnWCgmAUG3W6sbWy1OYTldmvIVaq
 Krw1FWu1yIQmrQPwmPPUqE9ZvOGctco+4IRfFTli8dvMcqUUCE1QHxPCPYwTvcaiTQw2
 1fQ2cXnQCArxz5ilCOXrdmUTFXJ535hBMi9A7OWH3SLYto7HB4b5ZpDq4eL7BN3d8ZyK RQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3274urd6cy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 18:38:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FIWhi2193150;
        Wed, 15 Jul 2020 18:38:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 327qc1gapf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 18:38:41 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06FIcdqm001628;
        Wed, 15 Jul 2020 18:38:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 11:38:39 -0700
Date:   Wed, 15 Jul 2020 11:38:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/26] xfs: split the incore dquot type into a separate
 field
Message-ID: <20200715183838.GD3151642@magnolia>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
 <159469032038.2914673.4780928031076025099.stgit@magnolia>
 <20200714075756.GB19883@infradead.org>
 <20200714180502.GB7606@magnolia>
 <20200715174340.GB11239@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715174340.GB11239@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 06:43:40PM +0100, Christoph Hellwig wrote:
> On Tue, Jul 14, 2020 at 11:05:02AM -0700, Darrick J. Wong wrote:
> > On Tue, Jul 14, 2020 at 08:57:56AM +0100, Christoph Hellwig wrote:
> > > On Mon, Jul 13, 2020 at 06:32:00PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Create a new type (xfs_dqtype_t) to represent the type of an incore
> > > > dquot.  Break the type field out from the dq_flags field of the incore
> > > > dquot.
> > > 
> > > I don't understand why we need separate in-core vs on-disk values for
> > > the type.  Why not something like this on top of the whole series:
> > 
> > I want to keep the ondisk d_type values separate from the incore q_type
> > values because they don't describe exactly the same concepts:
> > 
> > First, the incore qtype has a NONE value that we can pass to the dquot
> > core verifier when we don't actually know if this is a user, group, or
> > project dquot.  This should never end up on disk.
> 
> Which we can trivially verify.  Or just get rid of NONE, which actually
> cleans things up a fair bit (patch on top of my previous one below)

Ok, I'll get rid of that usage.

> > Second, xfs_dqtype_t is a (barely concealed) enumeration type for quota
> > callers to tell us that they want to perform an action on behalf of
> > user, group, or project quotas.  The incore q_flags and the ondisk
> > d_type contain internal state that should not be exposed to quota
> > callers.
> 
> I don't think that is an argument, as we do the same elsewhere.
> 
> > 
> > I feel a need to reiterate that I'm about to start adding more flags to
> > d_type (for y2038+ time support), for which it will be very important to
> > keep d_type and q_{type,flags} separate.
> 
> Why?  We'll just OR the bigtime flag in before writing to disk.

Ugh, fine, I'll rework the whole series yet again, since it doesn't look
like anyone else is going to have the time to review a 27 patch cleanup
series.

--D

> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index ef9b8559ff6197..c48b77c223073e 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -37,11 +37,8 @@ xfs_failaddr_t
>  xfs_dquot_verify(
>  	struct xfs_mount	*mp,
>  	struct xfs_disk_dquot	*ddq,
> -	xfs_dqid_t		id,
> -	xfs_dqtype_t		type)	/* used only during quotacheck */
> +	xfs_dqid_t		id)
>  {
> -	uint8_t			ddq_type;
> -
>  	/*
>  	 * We can encounter an uninitialized dquot buffer for 2 reasons:
>  	 * 1. If we crash while deleting the quotainode(s), and those blks got
> @@ -64,13 +61,14 @@ xfs_dquot_verify(
>  
>  	if (ddq->d_type & ~XFS_DQTYPE_ANY)
>  		return __this_address;
> -	ddq_type = ddq->d_type & XFS_DQTYPE_REC_MASK;
> -	if (type != XFS_DQTYPE_NONE && ddq_type != type)
> -		return __this_address;
> -	if (ddq_type != XFS_DQTYPE_USER &&
> -	    ddq_type != XFS_DQTYPE_PROJ &&
> -	    ddq_type != XFS_DQTYPE_GROUP)
> +	switch (ddq->d_type & XFS_DQTYPE_REC_MASK) {
> +	case XFS_DQTYPE_USER:
> +	case XFS_DQTYPE_PROJ:
> +	case XFS_DQTYPE_GROUP:
> +		break;
> +	default:
>  		return __this_address;
> +	}
>  
>  	if (id != -1 && id != be32_to_cpu(ddq->d_id))
>  		return __this_address;
> @@ -100,14 +98,12 @@ xfs_failaddr_t
>  xfs_dqblk_verify(
>  	struct xfs_mount	*mp,
>  	struct xfs_dqblk	*dqb,
> -	xfs_dqid_t		id,
> -	xfs_dqtype_t		type)	/* used only during quotacheck */
> +	xfs_dqid_t		id)
>  {
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
>  	    !uuid_equal(&dqb->dd_uuid, &mp->m_sb.sb_meta_uuid))
>  		return __this_address;
> -
> -	return xfs_dquot_verify(mp, &dqb->dd_diskdq, id, type);
> +	return xfs_dquot_verify(mp, &dqb->dd_diskdq, id);
>  }
>  
>  /*
> @@ -210,7 +206,7 @@ xfs_dquot_buf_verify(
>  		if (i == 0)
>  			id = be32_to_cpu(ddq->d_id);
>  
> -		fa = xfs_dqblk_verify(mp, &dqb[i], id + i, XFS_DQTYPE_NONE);
> +		fa = xfs_dqblk_verify(mp, &dqb[i], id + i);
>  		if (fa) {
>  			if (!readahead)
>  				xfs_buf_verifier_error(bp, -EFSCORRUPTED,
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index e4178c804abf06..ec472131ea4b15 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1150,13 +1150,11 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>  #define XFS_DQUOT_MAGIC		0x4451		/* 'DQ' */
>  #define XFS_DQUOT_VERSION	(uint8_t)0x01	/* latest version number */
>  
> -#define XFS_DQTYPE_NONE		0
>  #define XFS_DQTYPE_USER		0x01		/* user dquot record */
>  #define XFS_DQTYPE_PROJ		0x02		/* project dquot record */
>  #define XFS_DQTYPE_GROUP	0x04		/* group dquot record */
>  
>  #define XFS_DQTYPE_STRINGS \
> -	{ XFS_DQTYPE_NONE,	"NONE" }, \
>  	{ XFS_DQTYPE_USER,	"USER" }, \
>  	{ XFS_DQTYPE_PROJ,	"PROJ" }, \
>  	{ XFS_DQTYPE_GROUP,	"GROUP" }
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index 6edd249fdef4ea..5e3d6b49981707 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -129,9 +129,9 @@ typedef uint16_t	xfs_qwarncnt_t;
>  #define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
>  
>  extern xfs_failaddr_t xfs_dquot_verify(struct xfs_mount *mp,
> -		struct xfs_disk_dquot *ddq, xfs_dqid_t id, xfs_dqtype_t type);
> +		struct xfs_disk_dquot *ddq, xfs_dqid_t id);
>  extern xfs_failaddr_t xfs_dqblk_verify(struct xfs_mount *mp,
> -		struct xfs_dqblk *dqb, xfs_dqid_t id, xfs_dqtype_t type);
> +		struct xfs_dqblk *dqb, xfs_dqid_t id);
>  extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
>  extern void xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
>  		xfs_dqid_t id, xfs_dqtype_t type);
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index f045895f28ffb1..a8eace16fdae74 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -31,7 +31,7 @@ xchk_quota_to_dqtype(
>  		return XFS_DQTYPE_PROJ;
>  	default:
>  		ASSERT(0);
> -		return XFS_DQTYPE_NONE;
> +		return 0;
>  	}
>  }
>  
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index c2f19d35e05dbd..e4f37c064497aa 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -494,8 +494,7 @@ xlog_recover_do_reg_buffer(
>  					item->ri_buf[i].i_len, __func__);
>  				goto next;
>  			}
> -			fa = xfs_dquot_verify(mp, item->ri_buf[i].i_addr,
> -					       -1, XFS_DQTYPE_NONE);
> +			fa = xfs_dquot_verify(mp, item->ri_buf[i].i_addr, -1);
>  			if (fa) {
>  				xfs_alert(mp,
>  	"dquot corrupt at %pS trying to replay into block 0x%llx",
> diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
> index b5afb9fb8cd4fd..2df6238ed19abc 100644
> --- a/fs/xfs/xfs_dquot_item_recover.c
> +++ b/fs/xfs/xfs_dquot_item_recover.c
> @@ -108,7 +108,7 @@ xlog_recover_dquot_commit_pass2(
>  	 */
>  	dq_f = item->ri_buf[0].i_addr;
>  	ASSERT(dq_f);
> -	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, XFS_DQTYPE_NONE);
> +	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id);
>  	if (fa) {
>  		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
>  				dq_f->qlf_id, fa);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 96171f4406e978..716b91b582ff56 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -828,7 +828,6 @@ xfs_qm_reset_dqcounts(
>  {
>  	struct xfs_dqblk	*dqb;
>  	int			j;
> -	xfs_failaddr_t		fa;
>  
>  	trace_xfs_reset_dqcounts(bp, _RET_IP_);
>  
> @@ -853,8 +852,8 @@ xfs_qm_reset_dqcounts(
>  		 * find uninitialised dquot blks. See comment in
>  		 * xfs_dquot_verify.
>  		 */
> -		fa = xfs_dqblk_verify(mp, &dqb[j], id + j, type);
> -		if (fa)
> +		if (xfs_dqblk_verify(mp, &dqb[j], id + j, type) ||
> +		    dqb[j].d_type != type)
>  			xfs_dqblk_repair(mp, &dqb[j], id + j, type);
>  
>  		/*
