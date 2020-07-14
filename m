Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9EF8C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 18:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C399220656
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 18:05:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GFjo0YJr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgGNSFV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 14:05:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38940 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgGNSFU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 14:05:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EHq5ov034515;
        Tue, 14 Jul 2020 18:05:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=iAJ42icORCuCkjnl16tNbuxApGCgA/dJvxMhlrkC0E8=;
 b=GFjo0YJrErItlRUHsPUzCmpTYJwLcWeV/hvwZSQ6440+WJgpyuD+Fxx3ivJH5nBn7nXs
 KOP31ki+f+TqlZTZlj97ceKfgQhyfOIyMMW7HB6x14ke2/I7mM7WSC0wNl89NNEQO+M+
 bg2EFCQBMJXlM8ws/pElk+OB8FiVJtc6vqy1Bf5+sxgdM1g33vJvLjxA9qftlZjr4/Hg
 yoaoKckcm1J1oaTqJ5MrpNS1YpdBhPCZ94rm7/Bck0j/Z3LEFqFBjEDucXLzlkG/f3Z2
 wZ9bisFbb1mxnLddfJ1DpOjw+PsTNsHI1u88YaaQMEziqhylkHtyEqaJRTjycB160cZY kA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3274ur71ga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 18:05:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EHrc4E087199;
        Tue, 14 Jul 2020 18:05:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 327q0pptgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 18:05:10 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06EI53rX006900;
        Tue, 14 Jul 2020 18:05:03 GMT
Received: from localhost (/10.159.135.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 11:05:03 -0700
Date:   Tue, 14 Jul 2020 11:05:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/26] xfs: split the incore dquot type into a separate
 field
Message-ID: <20200714180502.GB7606@magnolia>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
 <159469032038.2914673.4780928031076025099.stgit@magnolia>
 <20200714075756.GB19883@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714075756.GB19883@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 14, 2020 at 08:57:56AM +0100, Christoph Hellwig wrote:
> On Mon, Jul 13, 2020 at 06:32:00PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a new type (xfs_dqtype_t) to represent the type of an incore
> > dquot.  Break the type field out from the dq_flags field of the incore
> > dquot.
> 
> I don't understand why we need separate in-core vs on-disk values for
> the type.  Why not something like this on top of the whole series:

I want to keep the ondisk d_type values separate from the incore q_type
values because they don't describe exactly the same concepts:

First, the incore qtype has a NONE value that we can pass to the dquot
core verifier when we don't actually know if this is a user, group, or
project dquot.  This should never end up on disk.

Second, xfs_dqtype_t is a (barely concealed) enumeration type for quota
callers to tell us that they want to perform an action on behalf of
user, group, or project quotas.  The incore q_flags and the ondisk
d_type contain internal state that should not be exposed to quota
callers.

I feel a need to reiterate that I'm about to start adding more flags to
d_type (for y2038+ time support), for which it will be very important to
keep d_type and q_{type,flags} separate.

I will change the series to define the DQTYPE flags to match the DDQTYPE
flags when they do overlap so that I can drop xfs_dquot_type_to_disk,
but I'm not going to separate the flag/type/whatever namespaces just to
combine them again.

--D

> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index 889e34b1a03335..ef9b8559ff6197 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -62,15 +62,14 @@ xfs_dquot_verify(
>  	if (ddq->d_version != XFS_DQUOT_VERSION)
>  		return __this_address;
>  
> -	if (ddq->d_type & ~XFS_DDQTYPE_ANY)
> +	if (ddq->d_type & ~XFS_DQTYPE_ANY)
>  		return __this_address;
> -	ddq_type = ddq->d_type & XFS_DDQTYPE_REC_MASK;
> -	if (type != XFS_DQTYPE_NONE &&
> -	    ddq_type != xfs_dquot_type_to_disk(type))
> +	ddq_type = ddq->d_type & XFS_DQTYPE_REC_MASK;
> +	if (type != XFS_DQTYPE_NONE && ddq_type != type)
>  		return __this_address;
> -	if (ddq_type != XFS_DDQTYPE_USER &&
> -	    ddq_type != XFS_DDQTYPE_PROJ &&
> -	    ddq_type != XFS_DDQTYPE_GROUP)
> +	if (ddq_type != XFS_DQTYPE_USER &&
> +	    ddq_type != XFS_DQTYPE_PROJ &&
> +	    ddq_type != XFS_DQTYPE_GROUP)
>  		return __this_address;
>  
>  	if (id != -1 && id != be32_to_cpu(ddq->d_id))
> @@ -129,7 +128,7 @@ xfs_dqblk_repair(
>  
>  	dqb->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
>  	dqb->dd_diskdq.d_version = XFS_DQUOT_VERSION;
> -	dqb->dd_diskdq.d_type = xfs_dquot_type_to_disk(type);
> +	dqb->dd_diskdq.d_type = type;
>  	dqb->dd_diskdq.d_id = cpu_to_be32(id);
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index eed0c4d5baddbe..e4178c804abf06 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1150,16 +1150,25 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>  #define XFS_DQUOT_MAGIC		0x4451		/* 'DQ' */
>  #define XFS_DQUOT_VERSION	(uint8_t)0x01	/* latest version number */
>  
> -#define XFS_DDQTYPE_USER	0x01		/* user dquot record */
> -#define XFS_DDQTYPE_PROJ	0x02		/* project dquot record */
> -#define XFS_DDQTYPE_GROUP	0x04		/* group dquot record */
> +#define XFS_DQTYPE_NONE		0
> +#define XFS_DQTYPE_USER		0x01		/* user dquot record */
> +#define XFS_DQTYPE_PROJ		0x02		/* project dquot record */
> +#define XFS_DQTYPE_GROUP	0x04		/* group dquot record */
> +
> +#define XFS_DQTYPE_STRINGS \
> +	{ XFS_DQTYPE_NONE,	"NONE" }, \
> +	{ XFS_DQTYPE_USER,	"USER" }, \
> +	{ XFS_DQTYPE_PROJ,	"PROJ" }, \
> +	{ XFS_DQTYPE_GROUP,	"GROUP" }
>  
>  /* bitmask to determine if this is a user/group/project dquot */
> -#define XFS_DDQTYPE_REC_MASK	(XFS_DDQTYPE_USER | \
> -				 XFS_DDQTYPE_PROJ | \
> -				 XFS_DDQTYPE_GROUP)
> +#define XFS_DQTYPE_REC_MASK	(XFS_DQTYPE_USER | \
> +				 XFS_DQTYPE_PROJ | \
> +				 XFS_DQTYPE_GROUP)
> +
> +#define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK)
>  
> -#define XFS_DDQTYPE_ANY		(XFS_DDQTYPE_REC_MASK)
> +typedef uint8_t		xfs_dqtype_t;
>  
>  /*
>   * This is the main portion of the on-disk representation of quota
> @@ -1170,7 +1179,7 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>  struct xfs_disk_dquot {
>  	__be16		d_magic;	/* dquot magic = XFS_DQUOT_MAGIC */
>  	__u8		d_version;	/* dquot version */
> -	__u8		d_type;		/* XFS_DDQTYPE_* */
> +	xfs_dqtype_t	d_type;		/* XFS_DQTYPE_* */
>  	__be32		d_id;		/* user,project,group id */
>  	__be64		d_blk_hardlimit;/* absolute limit on disk blks */
>  	__be64		d_blk_softlimit;/* preferred limit on disk blks */
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index 0650fa71fa2bcf..6edd249fdef4ea 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -18,36 +18,6 @@
>  typedef uint64_t	xfs_qcnt_t;
>  typedef uint16_t	xfs_qwarncnt_t;
>  
> -typedef uint8_t		xfs_dqtype_t;
> -
> -#define XFS_DQTYPE_NONE		(0)
> -#define XFS_DQTYPE_USER		(1)
> -#define XFS_DQTYPE_PROJ		(2)
> -#define XFS_DQTYPE_GROUP	(3)
> -
> -#define XFS_DQTYPE_STRINGS \
> -	{ XFS_DQTYPE_NONE,	"NONE?" }, \
> -	{ XFS_DQTYPE_USER,	"USER" }, \
> -	{ XFS_DQTYPE_PROJ,	"PROJ" }, \
> -	{ XFS_DQTYPE_GROUP,	"GROUP" }
> -
> -static inline __u8
> -xfs_dquot_type_to_disk(
> -	xfs_dqtype_t		type)
> -{
> -	switch (type) {
> -	case XFS_DQTYPE_USER:
> -		return XFS_DDQTYPE_USER;
> -	case XFS_DQTYPE_GROUP:
> -		return XFS_DDQTYPE_GROUP;
> -	case XFS_DQTYPE_PROJ:
> -		return XFS_DDQTYPE_PROJ;
> -	default:
> -		ASSERT(0);
> -		return 0;
> -	}
> -}
> -
>  /*
>   * flags for q_flags field in the dquot.
>   */
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index dd150f8bbf5a2a..c2f19d35e05dbd 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -548,11 +548,11 @@ xlog_recover_do_dquot_buffer(
>  
>  	type = 0;
>  	if (buf_f->blf_flags & XFS_BLF_UDQUOT_BUF)
> -		type |= XFS_DDQTYPE_USER;
> +		type |= XFS_DQTYPE_USER;
>  	if (buf_f->blf_flags & XFS_BLF_PDQUOT_BUF)
> -		type |= XFS_DDQTYPE_PROJ;
> +		type |= XFS_DQTYPE_PROJ;
>  	if (buf_f->blf_flags & XFS_BLF_GDQUOT_BUF)
> -		type |= XFS_DDQTYPE_GROUP;
> +		type |= XFS_DQTYPE_GROUP;
>  	/*
>  	 * This type of quotas was turned off, so ignore this buffer
>  	 */
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 14b0c62943d54e..0581cb930cd75e 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -182,7 +182,7 @@ xfs_qm_init_dquot_blk(
>  		d->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
>  		d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
>  		d->dd_diskdq.d_id = cpu_to_be32(curid);
> -		d->dd_diskdq.d_type = xfs_dquot_type_to_disk(type);
> +		d->dd_diskdq.d_type = type;
>  		if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  			uuid_copy(&d->dd_uuid, &mp->m_sb.sb_meta_uuid);
>  			xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
> @@ -481,13 +481,13 @@ xfs_dquot_from_disk(
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_disk_dquot	*ddqp = bp->b_addr + dqp->q_bufoffset;
> -	__u8			ddq_type = xfs_dquot_type_to_disk(dqp->q_type);
> +	__u8			ddq_type = dqp->q_type;
>  
>  	/*
>  	 * Ensure that we got the type and ID we were looking for.
>  	 * Everything else was checked by the dquot buffer verifier.
>  	 */
> -	if ((ddqp->d_type & XFS_DDQTYPE_REC_MASK) != ddq_type ||
> +	if ((ddqp->d_type & XFS_DQTYPE_REC_MASK) != ddq_type ||
>  	    be32_to_cpu(ddqp->d_id) != dqp->q_id) {
>  		xfs_alert_tag(bp->b_mount, XFS_PTAG_VERIFIER_ERROR,
>  			  "Metadata corruption detected at %pS, quota %u",
> @@ -537,7 +537,7 @@ xfs_dquot_to_disk(
>  {
>  	ddqp->d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
>  	ddqp->d_version = XFS_DQUOT_VERSION;
> -	ddqp->d_type = xfs_dquot_type_to_disk(dqp->q_type);
> +	ddqp->d_type = dqp->q_type;
>  	ddqp->d_id = cpu_to_be32(dqp->q_id);
>  	ddqp->d_pad0 = 0;
>  	ddqp->d_pad = 0;
> diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
> index 0955f183a02758..b5afb9fb8cd4fd 100644
> --- a/fs/xfs/xfs_dquot_item_recover.c
> +++ b/fs/xfs/xfs_dquot_item_recover.c
> @@ -39,7 +39,7 @@ xlog_recover_dquot_ra_pass2(
>  	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot))
>  		return;
>  
> -	type = recddq->d_type & XFS_DDQTYPE_REC_MASK;
> +	type = recddq->d_type & XFS_DQTYPE_REC_MASK;
>  	ASSERT(type);
>  	if (log->l_quotaoffs_flag & type)
>  		return;
> @@ -91,7 +91,7 @@ xlog_recover_dquot_commit_pass2(
>  	/*
>  	 * This type of quotas was turned off, so ignore this record.
>  	 */
> -	type = recddq->d_type & XFS_DDQTYPE_REC_MASK;
> +	type = recddq->d_type & XFS_DQTYPE_REC_MASK;
>  	ASSERT(type);
>  	if (log->l_quotaoffs_flag & type)
>  		return 0;
> @@ -185,11 +185,11 @@ xlog_recover_quotaoff_commit_pass1(
>  	 * group/project quotaoff or both.
>  	 */
>  	if (qoff_f->qf_flags & XFS_UQUOTA_ACCT)
> -		log->l_quotaoffs_flag |= XFS_DDQTYPE_USER;
> +		log->l_quotaoffs_flag |= XFS_DQTYPE_USER;
>  	if (qoff_f->qf_flags & XFS_PQUOTA_ACCT)
> -		log->l_quotaoffs_flag |= XFS_DDQTYPE_PROJ;
> +		log->l_quotaoffs_flag |= XFS_DQTYPE_PROJ;
>  	if (qoff_f->qf_flags & XFS_GQUOTA_ACCT)
> -		log->l_quotaoffs_flag |= XFS_DDQTYPE_GROUP;
> +		log->l_quotaoffs_flag |= XFS_DQTYPE_GROUP;
>  
>  	return 0;
>  }
