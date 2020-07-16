Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D32C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 07:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5E10206F4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:59:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HsGEK6H+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgGPG77 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 02:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgGPG77 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 02:59:59 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0547C061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 23:59:58 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id s26so3237563pfm.4
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 23:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8whBGKO0p+aSgJoAeWMEo65ADkrEYJOB3AdK+srGBWQ=;
        b=HsGEK6H+1bswrFvgNZ7QDcG2h0id6BAAQesj3lPALoei2qXxVE0rpgr0VFMpSNsDj6
         /z/JoIcAKzA56xjLnOIHyW8y88XPbePYooVTR3+UYs91Fgjpza5VamupuGdZun0qRKed
         YMCUONNI79JjhsK3OV410pvioNyT9rrfpfltRKJ4qH1c4cUX1nwl140CKLSc3k5T4nZA
         IFvyLjpWze8WpE7cJ/+OJ/kskyCZeO0w/YNHQ0pORiFZHQuyBxYHEe3ooRYR899YDTwG
         FsEsT8vmI477MLk2G/LusmQL+QlLfwL+vgpnCM69Yg+e7mHh6QAzHCRz09xdFZruRenm
         JeEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8whBGKO0p+aSgJoAeWMEo65ADkrEYJOB3AdK+srGBWQ=;
        b=PW6oSNgiF4T5GrTfu8wTTAKkmPliAuQiy/4dqDRqvbYe7vd6HB+1WNoPh3b+x1ZGli
         miJHS2KRYGouY/fUVGrNPAYYIzTOlESuOuDk6UhvOpWJ/49lBp1nfOZakaZ4HWNJVvL0
         bzLhGQMlQA4ov1/EYtfjKmY9WD+4T3aYU3wbLvIdF7hPQpu1Ef3WlBjRh8OMMEF1+Hj0
         joBf/Zox+nIpBygn4S1L3WdGX24LAd0Ke1fYVCMSNFOCEfgkDz5g80Mo8kg2NxdBYKpk
         o0e0k7mS8qhdkQk0Q16EBqhvT3rHvzDENoR+irbb8PILyKtgSAz9Kn1fwiIXPXLmWxIw
         kGtA==
X-Gm-Message-State: AOAM533ejFUcICyTGQJk3Y7C93gaRMR0/nG9kSKPzLCcGd9L55TvfHxZ
        +40FpeF1DdG7xQcO10t3Ao7UDqYf
X-Google-Smtp-Source: ABdhPJxIS1t4VYyKet4vrgT+15tllRJxAdVkotWSUk3pfwHpD1AvzVcJvrUPPoJRs/zS4FzkRrW6rw==
X-Received: by 2002:aa7:9f8f:: with SMTP id z15mr2410114pfr.73.1594882798094;
        Wed, 15 Jul 2020 23:59:58 -0700 (PDT)
Received: from garuda.localnet ([122.167.32.2])
        by smtp.gmail.com with ESMTPSA id y11sm2481798pfp.73.2020.07.15.23.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 23:59:57 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/26] xfs: split the incore dquot type into a separate field
Date:   Thu, 16 Jul 2020 12:29:20 +0530
Message-ID: <6765262.D3Jhb8C5AV@garuda>
In-Reply-To: <159477786811.3263162.5484532928763674639.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia> <159477786811.3263162.5484532928763674639.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 15 July 2020 7:21:08 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a new type (xfs_dqtype_t) to represent the type of an incore
> dquot (user, group, project, or none).  Break the type field out from
> the dq_flags field of the incore dquot.  We add an explicit NONE value
> for the handful of users (the dquot buffer verifier) that cannot always
> know what quota type we're dealing with.
> 
> This allows us to replace all the "uint type" arguments to the quota
> functions with "xfs_dqtype_t type", to make it obvious when we're
> passing a quota type argument into a function.
> 
> Decoupling q_type from dq_flags in the incore dquot helps us streamline
> the quota code even further -- the quota functions can perform direct
> comparisons against q_type without having to do any pesky bitmasking.
> 
> Note that the incore state flags and the ondisk flags remain separate
> namespaces from xfs_dqtype_t because they contain internal dquot state
> that should never be exposed to quota callers.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c   |   21 ++++++----
>  fs/xfs/libxfs/xfs_quota_defs.h  |   19 ++++++++-
>  fs/xfs/scrub/quota.c            |   19 +++++----
>  fs/xfs/scrub/repair.c           |   10 ++---
>  fs/xfs/scrub/repair.h           |    4 +-
>  fs/xfs/xfs_buf_item_recover.c   |    2 -
>  fs/xfs/xfs_dquot.c              |   75 ++++++++++++++++++++----------------
>  fs/xfs/xfs_dquot.h              |   63 +++++++++++++++++-------------
>  fs/xfs/xfs_dquot_item_recover.c |    2 -
>  fs/xfs/xfs_icache.c             |    4 +-
>  fs/xfs/xfs_iomap.c              |   36 +++++++++--------
>  fs/xfs/xfs_qm.c                 |   82 ++++++++++++++++++++-------------------
>  fs/xfs/xfs_qm.h                 |   55 ++++++++++++--------------
>  fs/xfs/xfs_qm_bhv.c             |    2 -
>  fs/xfs/xfs_qm_syscalls.c        |   25 +++++-------
>  fs/xfs/xfs_quota.h              |   10 ++---
>  fs/xfs/xfs_quotaops.c           |    8 ++--
>  fs/xfs/xfs_trace.h              |    5 ++
>  fs/xfs/xfs_trans_dquot.c        |   17 ++++++--
>  19 files changed, 248 insertions(+), 211 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index bedc1e752b60..3b20b82a775b 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -38,8 +38,10 @@ xfs_dquot_verify(
>  	struct xfs_mount	*mp,
>  	struct xfs_disk_dquot	*ddq,
>  	xfs_dqid_t		id,
> -	uint			type)	/* used only during quotacheck */
> +	xfs_dqtype_t		type)	/* used only during quotacheck */
>  {
> +	uint8_t			ddq_type;
> +
>  	/*
>  	 * We can encounter an uninitialized dquot buffer for 2 reasons:
>  	 * 1. If we crash while deleting the quotainode(s), and those blks got
> @@ -60,11 +62,12 @@ xfs_dquot_verify(
>  	if (ddq->d_version != XFS_DQUOT_VERSION)
>  		return __this_address;
>  
> -	if (type && ddq->d_flags != type)
> +	ddq_type = ddq->d_flags & XFS_DQ_ALLTYPES;
> +	if (type != XFS_DQTYPE_NONE && ddq_type != type)
>  		return __this_address;
> -	if (ddq->d_flags != XFS_DQ_USER &&
> -	    ddq->d_flags != XFS_DQ_PROJ &&
> -	    ddq->d_flags != XFS_DQ_GROUP)
> +	if (ddq_type != XFS_DQ_USER &&
> +	    ddq_type != XFS_DQ_PROJ &&
> +	    ddq_type != XFS_DQ_GROUP)
>  		return __this_address;
>  
>  	if (id != -1 && id != be32_to_cpu(ddq->d_id))
> @@ -95,8 +98,8 @@ xfs_failaddr_t
>  xfs_dqblk_verify(
>  	struct xfs_mount	*mp,
>  	struct xfs_dqblk	*dqb,
> -	xfs_dqid_t	 	id,
> -	uint		 	type)	/* used only during quotacheck */
> +	xfs_dqid_t		id,
> +	xfs_dqtype_t		type)	/* used only during quotacheck */
>  {
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
>  	    !uuid_equal(&dqb->dd_uuid, &mp->m_sb.sb_meta_uuid))
> @@ -113,7 +116,7 @@ xfs_dqblk_repair(
>  	struct xfs_mount	*mp,
>  	struct xfs_dqblk	*dqb,
>  	xfs_dqid_t		id,
> -	uint			type)
> +	xfs_dqtype_t		type)
>  {
>  	/*
>  	 * Typically, a repair is only requested by quotacheck.
> @@ -205,7 +208,7 @@ xfs_dquot_buf_verify(
>  		if (i == 0)
>  			id = be32_to_cpu(ddq->d_id);
>  
> -		fa = xfs_dqblk_verify(mp, &dqb[i], id + i, 0);
> +		fa = xfs_dqblk_verify(mp, &dqb[i], id + i, XFS_DQTYPE_NONE);
>  		if (fa) {
>  			if (!readahead)
>  				xfs_buf_verifier_error(bp, -EFSCORRUPTED,
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index 56d9dd787e7b..aaf85a47ae5f 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -18,6 +18,19 @@
>  typedef uint64_t	xfs_qcnt_t;
>  typedef uint16_t	xfs_qwarncnt_t;
>  
> +typedef uint8_t		xfs_dqtype_t;
> +
> +#define XFS_DQTYPE_NONE		(0)
> +#define XFS_DQTYPE_USER		(XFS_DQ_USER)
> +#define XFS_DQTYPE_PROJ		(XFS_DQ_PROJ)
> +#define XFS_DQTYPE_GROUP	(XFS_DQ_GROUP)
> +
> +#define XFS_DQTYPE_STRINGS \
> +	{ XFS_DQTYPE_NONE,	"NONE" }, \
> +	{ XFS_DQTYPE_USER,	"USER" }, \
> +	{ XFS_DQTYPE_PROJ,	"PROJ" }, \
> +	{ XFS_DQTYPE_GROUP,	"GROUP" }
> +
>  /*
>   * flags for q_flags field in the dquot.
>   */
> @@ -137,11 +150,11 @@ typedef uint16_t	xfs_qwarncnt_t;
>  #define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
>  
>  extern xfs_failaddr_t xfs_dquot_verify(struct xfs_mount *mp,
> -		struct xfs_disk_dquot *ddq, xfs_dqid_t id, uint type);
> +		struct xfs_disk_dquot *ddq, xfs_dqid_t id, xfs_dqtype_t type);
>  extern xfs_failaddr_t xfs_dqblk_verify(struct xfs_mount *mp,
> -		struct xfs_dqblk *dqb, xfs_dqid_t id, uint type);
> +		struct xfs_dqblk *dqb, xfs_dqid_t id, xfs_dqtype_t type);
>  extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
>  extern void xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
> -		xfs_dqid_t id, uint type);
> +		xfs_dqid_t id, xfs_dqtype_t type);
>  
>  #endif	/* __XFS_QUOTA_H__ */
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index 905a34558361..cece9f69bbfb 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -18,19 +18,20 @@
>  #include "scrub/common.h"
>  
>  /* Convert a scrub type code to a DQ flag, or return 0 if error. */
> -static inline uint
> +static inline xfs_dqtype_t
>  xchk_quota_to_dqtype(
>  	struct xfs_scrub	*sc)
>  {
>  	switch (sc->sm->sm_type) {
>  	case XFS_SCRUB_TYPE_UQUOTA:
> -		return XFS_DQ_USER;
> +		return XFS_DQTYPE_USER;
>  	case XFS_SCRUB_TYPE_GQUOTA:
> -		return XFS_DQ_GROUP;
> +		return XFS_DQTYPE_GROUP;
>  	case XFS_SCRUB_TYPE_PQUOTA:
> -		return XFS_DQ_PROJ;
> +		return XFS_DQTYPE_PROJ;
>  	default:
> -		return 0;
> +		ASSERT(0);
> +		return XFS_DQTYPE_NONE;
>  	}
>  }
>  
> @@ -40,7 +41,7 @@ xchk_setup_quota(
>  	struct xfs_scrub	*sc,
>  	struct xfs_inode	*ip)
>  {
> -	uint			dqtype;
> +	xfs_dqtype_t		dqtype;
>  	int			error;
>  
>  	if (!XFS_IS_QUOTA_RUNNING(sc->mp) || !XFS_IS_QUOTA_ON(sc->mp))
> @@ -73,7 +74,7 @@ struct xchk_quota_info {
>  STATIC int
>  xchk_quota_item(
>  	struct xfs_dquot	*dq,
> -	uint			dqtype,
> +	xfs_dqtype_t		dqtype,
>  	void			*priv)
>  {
>  	struct xchk_quota_info	*sqi = priv;
> @@ -109,7 +110,7 @@ xchk_quota_item(
>  	sqi->last_id = id;
>  
>  	/* Did we get the dquot type we wanted? */
> -	if (dqtype != (d->d_flags & XFS_DQ_ALLTYPES))
> +	if (d->d_flags != dqtype)
>  		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
>  
>  	if (d->d_pad0 != cpu_to_be32(0) || d->d_pad != cpu_to_be16(0))
> @@ -235,7 +236,7 @@ xchk_quota(
>  	struct xchk_quota_info	sqi;
>  	struct xfs_mount	*mp = sc->mp;
>  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> -	uint			dqtype;
> +	xfs_dqtype_t		dqtype;
>  	int			error = 0;
>  
>  	dqtype = xchk_quota_to_dqtype(sc);
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index db3cfd12803d..25e86c71e7b9 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -899,11 +899,11 @@ xrep_find_ag_btree_roots(
>  void
>  xrep_force_quotacheck(
>  	struct xfs_scrub	*sc,
> -	uint			dqtype)
> +	xfs_dqtype_t		type)
>  {
>  	uint			flag;
>  
> -	flag = xfs_quota_chkd_flag(dqtype);
> +	flag = xfs_quota_chkd_flag(type);
>  	if (!(flag & sc->mp->m_qflags))
>  		return;
>  
> @@ -939,11 +939,11 @@ xrep_ino_dqattach(
>  "inode %llu repair encountered quota error %d, quotacheck forced.",
>  				(unsigned long long)sc->ip->i_ino, error);
>  		if (XFS_IS_UQUOTA_ON(sc->mp) && !sc->ip->i_udquot)
> -			xrep_force_quotacheck(sc, XFS_DQ_USER);
> +			xrep_force_quotacheck(sc, XFS_DQTYPE_USER);
>  		if (XFS_IS_GQUOTA_ON(sc->mp) && !sc->ip->i_gdquot)
> -			xrep_force_quotacheck(sc, XFS_DQ_GROUP);
> +			xrep_force_quotacheck(sc, XFS_DQTYPE_GROUP);
>  		if (XFS_IS_PQUOTA_ON(sc->mp) && !sc->ip->i_pdquot)
> -			xrep_force_quotacheck(sc, XFS_DQ_PROJ);
> +			xrep_force_quotacheck(sc, XFS_DQTYPE_PROJ);
>  		/* fall through */
>  	case -ESRCH:
>  		error = 0;
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index 04a47d45605b..fe77de01abe0 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -6,6 +6,8 @@
>  #ifndef __XFS_SCRUB_REPAIR_H__
>  #define __XFS_SCRUB_REPAIR_H__
>  
> +#include "xfs_quota_defs.h"
> +
>  static inline int xrep_notsupported(struct xfs_scrub *sc)
>  {
>  	return -EOPNOTSUPP;
> @@ -49,7 +51,7 @@ struct xrep_find_ag_btree {
>  
>  int xrep_find_ag_btree_roots(struct xfs_scrub *sc, struct xfs_buf *agf_bp,
>  		struct xrep_find_ag_btree *btree_info, struct xfs_buf *agfl_bp);
> -void xrep_force_quotacheck(struct xfs_scrub *sc, uint dqtype);
> +void xrep_force_quotacheck(struct xfs_scrub *sc, xfs_dqtype_t type);
>  int xrep_ino_dqattach(struct xfs_scrub *sc);
>  
>  /* Metadata repairers */
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 74c851f60eee..682d1ed78894 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -494,7 +494,7 @@ xlog_recover_do_reg_buffer(
>  				goto next;
>  			}
>  			fa = xfs_dquot_verify(mp, item->ri_buf[i].i_addr,
> -					       -1, 0);
> +					       -1, XFS_DQTYPE_NONE);
>  			if (fa) {
>  				xfs_alert(mp,
>  	"dquot corrupt at %pS trying to replay into block 0x%llx",
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 7503c6695569..8230faa9f66e 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -76,7 +76,7 @@ xfs_qm_adjust_dqlimits(
>  	int			prealloc = 0;
>  
>  	ASSERT(d->d_id);
> -	defq = xfs_get_defquota(q, xfs_dquot_type(dq));
> +	defq = xfs_get_defquota(q, dq->q_type);
>  
>  	if (defq->bsoftlimit && !d->d_blk_softlimit) {
>  		d->d_blk_softlimit = cpu_to_be64(defq->bsoftlimit);
> @@ -122,7 +122,7 @@ xfs_qm_adjust_dqtimers(
>  	struct xfs_def_quota	*defq;
>  
>  	ASSERT(d->d_id);
> -	defq = xfs_get_defquota(qi, xfs_dquot_type(dq));
> +	defq = xfs_get_defquota(qi, dq->q_type);
>  
>  #ifdef DEBUG
>  	if (d->d_blk_hardlimit)
> @@ -214,7 +214,7 @@ xfs_qm_init_dquot_blk(
>  	struct xfs_trans	*tp,
>  	struct xfs_mount	*mp,
>  	xfs_dqid_t		id,
> -	uint			type,
> +	xfs_dqtype_t		type,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_quotainfo	*q = mp->m_quotainfo;
> @@ -246,15 +246,22 @@ xfs_qm_init_dquot_blk(
>  		}
>  	}
>  
> -	if (type & XFS_DQ_USER) {
> +	switch (type) {
> +	case XFS_DQTYPE_USER:
>  		qflag = XFS_UQUOTA_CHKD;
>  		blftype = XFS_BLF_UDQUOT_BUF;
> -	} else if (type & XFS_DQ_PROJ) {
> +		break;
> +	case XFS_DQTYPE_PROJ:
>  		qflag = XFS_PQUOTA_CHKD;
>  		blftype = XFS_BLF_PDQUOT_BUF;
> -	} else {
> +		break;
> +	case XFS_DQTYPE_GROUP:
>  		qflag = XFS_GQUOTA_CHKD;
>  		blftype = XFS_BLF_GDQUOT_BUF;
> +		break;
> +	default:
> +		ASSERT(0);
> +		break;
>  	}
>  
>  	xfs_trans_dquot_buf(tp, bp, blftype);
> @@ -322,14 +329,14 @@ xfs_dquot_disk_alloc(
>  	struct xfs_trans	*tp = *tpp;
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_buf		*bp;
> -	struct xfs_inode	*quotip = xfs_quota_inode(mp, dqp->dq_flags);
> +	struct xfs_inode	*quotip = xfs_quota_inode(mp, dqp->q_type);
>  	int			nmaps = 1;
>  	int			error;
>  
>  	trace_xfs_dqalloc(dqp);
>  
>  	xfs_ilock(quotip, XFS_ILOCK_EXCL);
> -	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
> +	if (!xfs_this_quota_on(dqp->q_mount, dqp->q_type)) {
>  		/*
>  		 * Return if this type of quotas is turned off while we didn't
>  		 * have an inode lock
> @@ -367,7 +374,7 @@ xfs_dquot_disk_alloc(
>  	 * the entire thing.
>  	 */
>  	xfs_qm_init_dquot_blk(tp, mp, be32_to_cpu(dqp->q_core.d_id),
> -			      dqp->dq_flags & XFS_DQ_ALLTYPES, bp);
> +			dqp->q_type, bp);
>  	xfs_buf_set_ref(bp, XFS_DQUOT_REF);
>  
>  	/*
> @@ -414,13 +421,13 @@ xfs_dquot_disk_read(
>  {
>  	struct xfs_bmbt_irec	map;
>  	struct xfs_buf		*bp;
> -	struct xfs_inode	*quotip = xfs_quota_inode(mp, dqp->dq_flags);
> +	struct xfs_inode	*quotip = xfs_quota_inode(mp, dqp->q_type);
>  	uint			lock_mode;
>  	int			nmaps = 1;
>  	int			error;
>  
>  	lock_mode = xfs_ilock_data_map_shared(quotip);
> -	if (!xfs_this_quota_on(mp, dqp->dq_flags)) {
> +	if (!xfs_this_quota_on(mp, dqp->q_type)) {
>  		/*
>  		 * Return if this type of quotas is turned off while we
>  		 * didn't have the quota inode lock.
> @@ -472,13 +479,13 @@ STATIC struct xfs_dquot *
>  xfs_dquot_alloc(
>  	struct xfs_mount	*mp,
>  	xfs_dqid_t		id,
> -	uint			type)
> +	xfs_dqtype_t		type)
>  {
>  	struct xfs_dquot	*dqp;
>  
>  	dqp = kmem_zone_zalloc(xfs_qm_dqzone, 0);
>  
> -	dqp->dq_flags = type;
> +	dqp->q_type = type;
>  	dqp->q_core.d_id = cpu_to_be32(id);
>  	dqp->q_mount = mp;
>  	INIT_LIST_HEAD(&dqp->q_lru);
> @@ -504,13 +511,13 @@ xfs_dquot_alloc(
>  	 * quotas.
>  	 */
>  	switch (type) {
> -	case XFS_DQ_USER:
> +	case XFS_DQTYPE_USER:
>  		/* uses the default lock class */
>  		break;
> -	case XFS_DQ_GROUP:
> +	case XFS_DQTYPE_GROUP:
>  		lockdep_set_class(&dqp->q_qlock, &xfs_dquot_group_class);
>  		break;
> -	case XFS_DQ_PROJ:
> +	case XFS_DQTYPE_PROJ:
>  		lockdep_set_class(&dqp->q_qlock, &xfs_dquot_project_class);
>  		break;
>  	default:
> @@ -536,7 +543,7 @@ xfs_dquot_from_disk(
>  	 * Ensure that we got the type and ID we were looking for.
>  	 * Everything else was checked by the dquot buffer verifier.
>  	 */
> -	if ((ddqp->d_flags & XFS_DQ_ALLTYPES) != dqp->dq_flags ||
> +	if ((ddqp->d_flags & XFS_DQ_ALLTYPES) != dqp->q_type ||
>  	    ddqp->d_id != dqp->q_core.d_id) {
>  		xfs_alert_tag(bp->b_mount, XFS_PTAG_VERIFIER_ERROR,
>  			  "Metadata corruption detected at %pS, quota %u",
> @@ -607,7 +614,7 @@ static int
>  xfs_qm_dqread(
>  	struct xfs_mount	*mp,
>  	xfs_dqid_t		id,
> -	uint			type,
> +	xfs_dqtype_t		type,
>  	bool			can_alloc,
>  	struct xfs_dquot	**dqpp)
>  {
> @@ -655,7 +662,7 @@ xfs_qm_dqread(
>  static int
>  xfs_dq_get_next_id(
>  	struct xfs_mount	*mp,
> -	uint			type,
> +	xfs_dqtype_t		type,
>  	xfs_dqid_t		*id)
>  {
>  	struct xfs_inode	*quotip = xfs_quota_inode(mp, type);
> @@ -779,21 +786,21 @@ xfs_qm_dqget_cache_insert(
>  static int
>  xfs_qm_dqget_checks(
>  	struct xfs_mount	*mp,
> -	uint			type)
> +	xfs_dqtype_t		type)
>  {
>  	if (WARN_ON_ONCE(!XFS_IS_QUOTA_RUNNING(mp)))
>  		return -ESRCH;
>  
>  	switch (type) {
> -	case XFS_DQ_USER:
> +	case XFS_DQTYPE_USER:
>  		if (!XFS_IS_UQUOTA_ON(mp))
>  			return -ESRCH;
>  		return 0;
> -	case XFS_DQ_GROUP:
> +	case XFS_DQTYPE_GROUP:
>  		if (!XFS_IS_GQUOTA_ON(mp))
>  			return -ESRCH;
>  		return 0;
> -	case XFS_DQ_PROJ:
> +	case XFS_DQTYPE_PROJ:
>  		if (!XFS_IS_PQUOTA_ON(mp))
>  			return -ESRCH;
>  		return 0;
> @@ -811,7 +818,7 @@ int
>  xfs_qm_dqget(
>  	struct xfs_mount	*mp,
>  	xfs_dqid_t		id,
> -	uint			type,
> +	xfs_dqtype_t		type,
>  	bool			can_alloc,
>  	struct xfs_dquot	**O_dqpp)
>  {
> @@ -861,7 +868,7 @@ int
>  xfs_qm_dqget_uncached(
>  	struct xfs_mount	*mp,
>  	xfs_dqid_t		id,
> -	uint			type,
> +	xfs_dqtype_t		type,
>  	struct xfs_dquot	**dqpp)
>  {
>  	int			error;
> @@ -877,14 +884,14 @@ xfs_qm_dqget_uncached(
>  xfs_dqid_t
>  xfs_qm_id_for_quotatype(
>  	struct xfs_inode	*ip,
> -	uint			type)
> +	xfs_dqtype_t		type)
>  {
>  	switch (type) {
> -	case XFS_DQ_USER:
> +	case XFS_DQTYPE_USER:
>  		return i_uid_read(VFS_I(ip));
> -	case XFS_DQ_GROUP:
> +	case XFS_DQTYPE_GROUP:
>  		return i_gid_read(VFS_I(ip));
> -	case XFS_DQ_PROJ:
> +	case XFS_DQTYPE_PROJ:
>  		return ip->i_d.di_projid;
>  	}
>  	ASSERT(0);
> @@ -899,7 +906,7 @@ xfs_qm_id_for_quotatype(
>  int
>  xfs_qm_dqget_inode(
>  	struct xfs_inode	*ip,
> -	uint			type,
> +	xfs_dqtype_t		type,
>  	bool			can_alloc,
>  	struct xfs_dquot	**O_dqpp)
>  {
> @@ -985,7 +992,7 @@ int
>  xfs_qm_dqget_next(
>  	struct xfs_mount	*mp,
>  	xfs_dqid_t		id,
> -	uint			type,
> +	xfs_dqtype_t		type,
>  	struct xfs_dquot	**dqpp)
>  {
>  	struct xfs_dquot	*dqp;
> @@ -1294,7 +1301,7 @@ xfs_qm_exit(void)
>  int
>  xfs_qm_dqiterate(
>  	struct xfs_mount	*mp,
> -	uint			dqtype,
> +	xfs_dqtype_t		type,
>  	xfs_qm_dqiterate_fn	iter_fn,
>  	void			*priv)
>  {
> @@ -1303,13 +1310,13 @@ xfs_qm_dqiterate(
>  	int			error;
>  
>  	do {
> -		error = xfs_qm_dqget_next(mp, id, dqtype, &dq);
> +		error = xfs_qm_dqget_next(mp, id, type, &dq);
>  		if (error == -ENOENT)
>  			return 0;
>  		if (error)
>  			return error;
>  
> -		error = iter_fn(dq, dqtype, priv);
> +		error = iter_fn(dq, type, priv);
>  		id = be32_to_cpu(dq->q_core.d_id);
>  		xfs_qm_dqput(dq);
>  		id++;
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 71e36c85e20b..077d0988cff9 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -34,6 +34,7 @@ struct xfs_dquot {
>  	uint			dq_flags;
>  	struct list_head	q_lru;
>  	struct xfs_mount	*q_mount;
> +	xfs_dqtype_t		q_type;
>  	uint			q_nrefs;
>  	xfs_daddr_t		q_blkno;
>  	int			q_bufoffset;
> @@ -101,28 +102,34 @@ static inline void xfs_dqunlock(struct xfs_dquot *dqp)
>  	mutex_unlock(&dqp->q_qlock);
>  }
>  
> -static inline int xfs_this_quota_on(struct xfs_mount *mp, int type)
> +static inline bool
> +xfs_this_quota_on(
> +	struct xfs_mount	*mp,
> +	xfs_dqtype_t		type)
>  {
> -	switch (type & XFS_DQ_ALLTYPES) {
> -	case XFS_DQ_USER:
> +	switch (type) {
> +	case XFS_DQTYPE_USER:
>  		return XFS_IS_UQUOTA_ON(mp);
> -	case XFS_DQ_GROUP:
> +	case XFS_DQTYPE_GROUP:
>  		return XFS_IS_GQUOTA_ON(mp);
> -	case XFS_DQ_PROJ:
> +	case XFS_DQTYPE_PROJ:
>  		return XFS_IS_PQUOTA_ON(mp);
>  	default:
> -		return 0;
> +		return false;
>  	}
>  }
>  
> -static inline struct xfs_dquot *xfs_inode_dquot(struct xfs_inode *ip, int type)
> +static inline struct xfs_dquot *
> +xfs_inode_dquot(
> +	struct xfs_inode	*ip,
> +	xfs_dqtype_t		type)
>  {
> -	switch (type & XFS_DQ_ALLTYPES) {
> -	case XFS_DQ_USER:
> +	switch (type) {
> +	case XFS_DQTYPE_USER:
>  		return ip->i_udquot;
> -	case XFS_DQ_GROUP:
> +	case XFS_DQTYPE_GROUP:
>  		return ip->i_gdquot;
> -	case XFS_DQ_PROJ:
> +	case XFS_DQTYPE_PROJ:
>  		return ip->i_pdquot;
>  	default:
>  		return NULL;
> @@ -146,9 +153,9 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
>  
>  #define XFS_DQ_IS_LOCKED(dqp)	(mutex_is_locked(&((dqp)->q_qlock)))
>  #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->dq_flags & XFS_DQ_DIRTY)
> -#define XFS_QM_ISUDQ(dqp)	((dqp)->dq_flags & XFS_DQ_USER)
> -#define XFS_QM_ISPDQ(dqp)	((dqp)->dq_flags & XFS_DQ_PROJ)
> -#define XFS_QM_ISGDQ(dqp)	((dqp)->dq_flags & XFS_DQ_GROUP)
> +#define XFS_QM_ISUDQ(dqp)	((dqp)->q_type == XFS_DQTYPE_USER)
> +#define XFS_QM_ISPDQ(dqp)	((dqp)->q_type == XFS_DQTYPE_PROJ)
> +#define XFS_QM_ISGDQ(dqp)	((dqp)->q_type == XFS_DQTYPE_GROUP)
>  
>  void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
>  int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf **bpp);
> @@ -157,18 +164,20 @@ void		xfs_qm_adjust_dqtimers(struct xfs_mount *mp,
>  						struct xfs_dquot *d);
>  void		xfs_qm_adjust_dqlimits(struct xfs_mount *mp,
>  						struct xfs_dquot *d);
> -xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip, uint type);
> +xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip,
> +				xfs_dqtype_t type);
>  int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
> -					uint type, bool can_alloc,
> -					struct xfs_dquot **dqpp);
> -int		xfs_qm_dqget_inode(struct xfs_inode *ip, uint type,
> -						bool can_alloc,
> -						struct xfs_dquot **dqpp);
> +				xfs_dqtype_t type, bool can_alloc,
> +				struct xfs_dquot **dqpp);
> +int		xfs_qm_dqget_inode(struct xfs_inode *ip,
> +				xfs_dqtype_t type,
> +				bool can_alloc, struct xfs_dquot **dqpp);
>  int		xfs_qm_dqget_next(struct xfs_mount *mp, xfs_dqid_t id,
> -					uint type, struct xfs_dquot **dqpp);
> -int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
> -						xfs_dqid_t id, uint type,
> -						struct xfs_dquot **dqpp);
> +				xfs_dqtype_t type,
> +				struct xfs_dquot **dqpp);
> +int		xfs_qm_dqget_uncached(struct xfs_mount *mp, xfs_dqid_t id,
> +				xfs_dqtype_t type,
> +				struct xfs_dquot **dqpp);
>  void		xfs_qm_dqput(struct xfs_dquot *dqp);
>  
>  void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
> @@ -183,9 +192,9 @@ static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
>  	return dqp;
>  }
>  
> -typedef int (*xfs_qm_dqiterate_fn)(struct xfs_dquot *dq, uint dqtype,
> -		void *priv);
> -int xfs_qm_dqiterate(struct xfs_mount *mp, uint dqtype,
> +typedef int (*xfs_qm_dqiterate_fn)(struct xfs_dquot *dq,
> +		xfs_dqtype_t type, void *priv);
> +int xfs_qm_dqiterate(struct xfs_mount *mp, xfs_dqtype_t type,
>  		xfs_qm_dqiterate_fn iter_fn, void *priv);
>  
>  #endif /* __XFS_DQUOT_H__ */
> diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
> index f9ea9f55aa7c..a39708879874 100644
> --- a/fs/xfs/xfs_dquot_item_recover.c
> +++ b/fs/xfs/xfs_dquot_item_recover.c
> @@ -108,7 +108,7 @@ xlog_recover_dquot_commit_pass2(
>  	 */
>  	dq_f = item->ri_buf[0].i_addr;
>  	ASSERT(dq_f);
> -	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, 0);
> +	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, XFS_DQTYPE_NONE);
>  	if (fa) {
>  		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
>  				dq_f->qlf_id, fa);
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 58a750ce689c..3c6e936d2f99 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1424,7 +1424,7 @@ __xfs_inode_free_quota_eofblocks(
>  	eofb.eof_flags = XFS_EOF_FLAGS_UNION|XFS_EOF_FLAGS_SYNC;
>  
>  	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
> -		dq = xfs_inode_dquot(ip, XFS_DQ_USER);
> +		dq = xfs_inode_dquot(ip, XFS_DQTYPE_USER);
>  		if (dq && xfs_dquot_lowsp(dq)) {
>  			eofb.eof_uid = VFS_I(ip)->i_uid;
>  			eofb.eof_flags |= XFS_EOF_FLAGS_UID;
> @@ -1433,7 +1433,7 @@ __xfs_inode_free_quota_eofblocks(
>  	}
>  
>  	if (XFS_IS_GQUOTA_ENFORCED(ip->i_mount)) {
> -		dq = xfs_inode_dquot(ip, XFS_DQ_GROUP);
> +		dq = xfs_inode_dquot(ip, XFS_DQTYPE_GROUP);
>  		if (dq && xfs_dquot_lowsp(dq)) {
>  			eofb.eof_gid = VFS_I(ip)->i_gid;
>  			eofb.eof_flags |= XFS_EOF_FLAGS_GID;
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index b9a8c3798e08..ac2cc2680d2a 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -293,11 +293,11 @@ xfs_iomap_write_direct(
>  
>  STATIC bool
>  xfs_quota_need_throttle(
> -	struct xfs_inode *ip,
> -	int type,
> -	xfs_fsblock_t alloc_blocks)
> +	struct xfs_inode	*ip,
> +	xfs_dqtype_t		type,
> +	xfs_fsblock_t		alloc_blocks)
>  {
> -	struct xfs_dquot *dq = xfs_inode_dquot(ip, type);
> +	struct xfs_dquot	*dq = xfs_inode_dquot(ip, type);
>  
>  	if (!dq || !xfs_this_quota_on(ip->i_mount, type))
>  		return false;
> @@ -315,15 +315,15 @@ xfs_quota_need_throttle(
>  
>  STATIC void
>  xfs_quota_calc_throttle(
> -	struct xfs_inode *ip,
> -	int type,
> -	xfs_fsblock_t *qblocks,
> -	int *qshift,
> -	int64_t	*qfreesp)
> +	struct xfs_inode	*ip,
> +	xfs_dqtype_t		type,
> +	xfs_fsblock_t		*qblocks,
> +	int			*qshift,
> +	int64_t			*qfreesp)
>  {
> -	int64_t freesp;
> -	int shift = 0;
> -	struct xfs_dquot *dq = xfs_inode_dquot(ip, type);
> +	struct xfs_dquot	*dq = xfs_inode_dquot(ip, type);
> +	int64_t			freesp;
> +	int			shift = 0;
>  
>  	/* no dq, or over hi wmark, squash the prealloc completely */
>  	if (!dq || dq->q_res_bcount >= dq->q_prealloc_hi_wmark) {
> @@ -450,14 +450,14 @@ xfs_iomap_prealloc_size(
>  	 * Check each quota to cap the prealloc size, provide a shift value to
>  	 * throttle with and adjust amount of available space.
>  	 */
> -	if (xfs_quota_need_throttle(ip, XFS_DQ_USER, alloc_blocks))
> -		xfs_quota_calc_throttle(ip, XFS_DQ_USER, &qblocks, &qshift,
> +	if (xfs_quota_need_throttle(ip, XFS_DQTYPE_USER, alloc_blocks))
> +		xfs_quota_calc_throttle(ip, XFS_DQTYPE_USER, &qblocks, &qshift,
>  					&freesp);
> -	if (xfs_quota_need_throttle(ip, XFS_DQ_GROUP, alloc_blocks))
> -		xfs_quota_calc_throttle(ip, XFS_DQ_GROUP, &qblocks, &qshift,
> +	if (xfs_quota_need_throttle(ip, XFS_DQTYPE_GROUP, alloc_blocks))
> +		xfs_quota_calc_throttle(ip, XFS_DQTYPE_GROUP, &qblocks, &qshift,
>  					&freesp);
> -	if (xfs_quota_need_throttle(ip, XFS_DQ_PROJ, alloc_blocks))
> -		xfs_quota_calc_throttle(ip, XFS_DQ_PROJ, &qblocks, &qshift,
> +	if (xfs_quota_need_throttle(ip, XFS_DQTYPE_PROJ, alloc_blocks))
> +		xfs_quota_calc_throttle(ip, XFS_DQTYPE_PROJ, &qblocks, &qshift,
>  					&freesp);
>  
>  	/*
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 938023dd8ce5..9c455ebd20cb 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -47,7 +47,7 @@ STATIC void	xfs_qm_dqfree_one(struct xfs_dquot *dqp);
>  STATIC int
>  xfs_qm_dquot_walk(
>  	struct xfs_mount	*mp,
> -	int			type,
> +	xfs_dqtype_t		type,
>  	int			(*execute)(struct xfs_dquot *dqp, void *data),
>  	void			*data)
>  {
> @@ -161,7 +161,7 @@ xfs_qm_dqpurge(
>  	xfs_dqfunlock(dqp);
>  	xfs_dqunlock(dqp);
>  
> -	radix_tree_delete(xfs_dquot_tree(qi, dqp->q_core.d_flags),
> +	radix_tree_delete(xfs_dquot_tree(qi, dqp->q_type),
>  			  be32_to_cpu(dqp->q_core.d_id));
>  	qi->qi_dquots--;
>  
> @@ -190,11 +190,11 @@ xfs_qm_dqpurge_all(
>  	uint			flags)
>  {
>  	if (flags & XFS_QMOPT_UQUOTA)
> -		xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge, NULL);
> +		xfs_qm_dquot_walk(mp, XFS_DQTYPE_USER, xfs_qm_dqpurge, NULL);
>  	if (flags & XFS_QMOPT_GQUOTA)
> -		xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_dqpurge, NULL);
> +		xfs_qm_dquot_walk(mp, XFS_DQTYPE_GROUP, xfs_qm_dqpurge, NULL);
>  	if (flags & XFS_QMOPT_PQUOTA)
> -		xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_dqpurge, NULL);
> +		xfs_qm_dquot_walk(mp, XFS_DQTYPE_PROJ, xfs_qm_dqpurge, NULL);
>  }
>  
>  /*
> @@ -251,7 +251,7 @@ STATIC int
>  xfs_qm_dqattach_one(
>  	struct xfs_inode	*ip,
>  	xfs_dqid_t		id,
> -	uint			type,
> +	xfs_dqtype_t		type,
>  	bool			doalloc,
>  	struct xfs_dquot	**IO_idqpp)
>  {
> @@ -332,7 +332,7 @@ xfs_qm_dqattach_locked(
>  
>  	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
>  		error = xfs_qm_dqattach_one(ip, i_uid_read(VFS_I(ip)),
> -				XFS_DQ_USER, doalloc, &ip->i_udquot);
> +				XFS_DQTYPE_USER, doalloc, &ip->i_udquot);
>  		if (error)
>  			goto done;
>  		ASSERT(ip->i_udquot);
> @@ -340,15 +340,15 @@ xfs_qm_dqattach_locked(
>  
>  	if (XFS_IS_GQUOTA_ON(mp) && !ip->i_gdquot) {
>  		error = xfs_qm_dqattach_one(ip, i_gid_read(VFS_I(ip)),
> -				XFS_DQ_GROUP, doalloc, &ip->i_gdquot);
> +				XFS_DQTYPE_GROUP, doalloc, &ip->i_gdquot);
>  		if (error)
>  			goto done;
>  		ASSERT(ip->i_gdquot);
>  	}
>  
>  	if (XFS_IS_PQUOTA_ON(mp) && !ip->i_pdquot) {
> -		error = xfs_qm_dqattach_one(ip, ip->i_d.di_projid, XFS_DQ_PROJ,
> -				doalloc, &ip->i_pdquot);
> +		error = xfs_qm_dqattach_one(ip, ip->i_d.di_projid,
> +				XFS_DQTYPE_PROJ, doalloc, &ip->i_pdquot);
>  		if (error)
>  			goto done;
>  		ASSERT(ip->i_pdquot);
> @@ -546,7 +546,7 @@ xfs_qm_shrink_count(
>  STATIC void
>  xfs_qm_set_defquota(
>  	struct xfs_mount	*mp,
> -	uint			type,
> +	xfs_dqtype_t		type,
>  	struct xfs_quotainfo	*qinf)
>  {
>  	struct xfs_dquot	*dqp;
> @@ -559,7 +559,7 @@ xfs_qm_set_defquota(
>  		return;
>  
>  	ddqp = &dqp->q_core;
> -	defq = xfs_get_defquota(qinf, xfs_dquot_type(dqp));
> +	defq = xfs_get_defquota(qinf, type);
>  
>  	/*
>  	 * Timers and warnings have been already set, let's just set the
> @@ -578,7 +578,7 @@ xfs_qm_set_defquota(
>  static void
>  xfs_qm_init_timelimits(
>  	struct xfs_mount	*mp,
> -	uint			type)
> +	xfs_dqtype_t		type)
>  {
>  	struct xfs_quotainfo	*qinf = mp->m_quotainfo;
>  	struct xfs_def_quota	*defq;
> @@ -670,16 +670,16 @@ xfs_qm_init_quotainfo(
>  
>  	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
>  
> -	xfs_qm_init_timelimits(mp, XFS_DQ_USER);
> -	xfs_qm_init_timelimits(mp, XFS_DQ_GROUP);
> -	xfs_qm_init_timelimits(mp, XFS_DQ_PROJ);
> +	xfs_qm_init_timelimits(mp, XFS_DQTYPE_USER);
> +	xfs_qm_init_timelimits(mp, XFS_DQTYPE_GROUP);
> +	xfs_qm_init_timelimits(mp, XFS_DQTYPE_PROJ);
>  
>  	if (XFS_IS_UQUOTA_RUNNING(mp))
> -		xfs_qm_set_defquota(mp, XFS_DQ_USER, qinf);
> +		xfs_qm_set_defquota(mp, XFS_DQTYPE_USER, qinf);
>  	if (XFS_IS_GQUOTA_RUNNING(mp))
> -		xfs_qm_set_defquota(mp, XFS_DQ_GROUP, qinf);
> +		xfs_qm_set_defquota(mp, XFS_DQTYPE_GROUP, qinf);
>  	if (XFS_IS_PQUOTA_RUNNING(mp))
> -		xfs_qm_set_defquota(mp, XFS_DQ_PROJ, qinf);
> +		xfs_qm_set_defquota(mp, XFS_DQTYPE_PROJ, qinf);
>  
>  	qinf->qi_shrinker.count_objects = xfs_qm_shrink_count;
>  	qinf->qi_shrinker.scan_objects = xfs_qm_shrink_scan;
> @@ -829,10 +829,10 @@ xfs_qm_qino_alloc(
>  
>  STATIC void
>  xfs_qm_reset_dqcounts(
> -	xfs_mount_t	*mp,
> -	xfs_buf_t	*bp,
> -	xfs_dqid_t	id,
> -	uint		type)
> +	struct xfs_mount	*mp,
> +	struct xfs_buf		*bp,
> +	xfs_dqid_t		id,
> +	xfs_dqtype_t		type)
>  {
>  	struct xfs_dqblk	*dqb;
>  	int			j;
> @@ -907,11 +907,11 @@ xfs_qm_reset_dqcounts_all(
>  {
>  	struct xfs_buf		*bp;
>  	int			error;
> -	int			type;
> +	xfs_dqtype_t		type;
>  
>  	ASSERT(blkcnt > 0);
> -	type = flags & XFS_QMOPT_UQUOTA ? XFS_DQ_USER :
> -		(flags & XFS_QMOPT_PQUOTA ? XFS_DQ_PROJ : XFS_DQ_GROUP);
> +	type = flags & XFS_QMOPT_UQUOTA ? XFS_DQTYPE_USER :
> +		(flags & XFS_QMOPT_PQUOTA ? XFS_DQTYPE_PROJ : XFS_DQTYPE_GROUP);
>  	error = 0;
>  
>  	/*
> @@ -1070,7 +1070,7 @@ xfs_qm_reset_dqcounts_buf(
>  STATIC int
>  xfs_qm_quotacheck_dqadjust(
>  	struct xfs_inode	*ip,
> -	uint			type,
> +	xfs_dqtype_t		type,
>  	xfs_qcnt_t		nblks,
>  	xfs_qcnt_t		rtblks)
>  {
> @@ -1187,21 +1187,21 @@ xfs_qm_dqusage_adjust(
>  	 * and quotaoffs don't race. (Quotachecks happen at mount time only).
>  	 */
>  	if (XFS_IS_UQUOTA_ON(mp)) {
> -		error = xfs_qm_quotacheck_dqadjust(ip, XFS_DQ_USER, nblks,
> +		error = xfs_qm_quotacheck_dqadjust(ip, XFS_DQTYPE_USER, nblks,
>  				rtblks);
>  		if (error)
>  			goto error0;
>  	}
>  
>  	if (XFS_IS_GQUOTA_ON(mp)) {
> -		error = xfs_qm_quotacheck_dqadjust(ip, XFS_DQ_GROUP, nblks,
> +		error = xfs_qm_quotacheck_dqadjust(ip, XFS_DQTYPE_GROUP, nblks,
>  				rtblks);
>  		if (error)
>  			goto error0;
>  	}
>  
>  	if (XFS_IS_PQUOTA_ON(mp)) {
> -		error = xfs_qm_quotacheck_dqadjust(ip, XFS_DQ_PROJ, nblks,
> +		error = xfs_qm_quotacheck_dqadjust(ip, XFS_DQTYPE_PROJ, nblks,
>  				rtblks);
>  		if (error)
>  			goto error0;
> @@ -1325,18 +1325,18 @@ xfs_qm_quotacheck(
>  	 * down to disk buffers if everything was updated successfully.
>  	 */
>  	if (XFS_IS_UQUOTA_ON(mp)) {
> -		error = xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_flush_one,
> -					  &buffer_list);
> +		error = xfs_qm_dquot_walk(mp, XFS_DQTYPE_USER,
> +				xfs_qm_flush_one, &buffer_list);
>  	}
>  	if (XFS_IS_GQUOTA_ON(mp)) {
> -		error2 = xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_flush_one,
> -					   &buffer_list);
> +		error2 = xfs_qm_dquot_walk(mp, XFS_DQTYPE_GROUP,
> +				xfs_qm_flush_one, &buffer_list);
>  		if (!error)
>  			error = error2;
>  	}
>  	if (XFS_IS_PQUOTA_ON(mp)) {
> -		error2 = xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_flush_one,
> -					   &buffer_list);
> +		error2 = xfs_qm_dquot_walk(mp, XFS_DQTYPE_PROJ,
> +				xfs_qm_flush_one, &buffer_list);
>  		if (!error)
>  			error = error2;
>  	}
> @@ -1598,7 +1598,7 @@ xfs_qm_dqfree_one(
>  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
>  
>  	mutex_lock(&qi->qi_tree_lock);
> -	radix_tree_delete(xfs_dquot_tree(qi, dqp->q_core.d_flags),
> +	radix_tree_delete(xfs_dquot_tree(qi, dqp->q_type),
>  			  be32_to_cpu(dqp->q_core.d_id));
>  
>  	qi->qi_dquots--;
> @@ -1674,7 +1674,7 @@ xfs_qm_vop_dqalloc(
>  			 */
>  			xfs_iunlock(ip, lockflags);
>  			error = xfs_qm_dqget(mp, from_kuid(user_ns, uid),
> -					XFS_DQ_USER, true, &uq);
> +					XFS_DQTYPE_USER, true, &uq);
>  			if (error) {
>  				ASSERT(error != -ENOENT);
>  				return error;
> @@ -1698,7 +1698,7 @@ xfs_qm_vop_dqalloc(
>  		if (!gid_eq(inode->i_gid, gid)) {
>  			xfs_iunlock(ip, lockflags);
>  			error = xfs_qm_dqget(mp, from_kgid(user_ns, gid),
> -					XFS_DQ_GROUP, true, &gq);
> +					XFS_DQTYPE_GROUP, true, &gq);
>  			if (error) {
>  				ASSERT(error != -ENOENT);
>  				goto error_rele;
> @@ -1714,8 +1714,8 @@ xfs_qm_vop_dqalloc(
>  	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
>  		if (ip->i_d.di_projid != prid) {
>  			xfs_iunlock(ip, lockflags);
> -			error = xfs_qm_dqget(mp, (xfs_dqid_t)prid, XFS_DQ_PROJ,
> -					true, &pq);
> +			error = xfs_qm_dqget(mp, (xfs_dqid_t)prid,
> +					XFS_DQTYPE_PROJ, true, &pq);
>  			if (error) {
>  				ASSERT(error != -ENOENT);
>  				goto error_rele;
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 7b0e771fcbce..27789272da95 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -83,14 +83,14 @@ struct xfs_quotainfo {
>  static inline struct radix_tree_root *
>  xfs_dquot_tree(
>  	struct xfs_quotainfo	*qi,
> -	int			type)
> +	xfs_dqtype_t		type)
>  {
>  	switch (type) {
> -	case XFS_DQ_USER:
> +	case XFS_DQTYPE_USER:
>  		return &qi->qi_uquota_tree;
> -	case XFS_DQ_GROUP:
> +	case XFS_DQTYPE_GROUP:
>  		return &qi->qi_gquota_tree;
> -	case XFS_DQ_PROJ:
> +	case XFS_DQTYPE_PROJ:
>  		return &qi->qi_pquota_tree;
>  	default:
>  		ASSERT(0);
> @@ -99,14 +99,14 @@ xfs_dquot_tree(
>  }
>  
>  static inline struct xfs_inode *
> -xfs_quota_inode(xfs_mount_t *mp, uint dq_flags)
> +xfs_quota_inode(struct xfs_mount *mp, xfs_dqtype_t type)
>  {
> -	switch (dq_flags & XFS_DQ_ALLTYPES) {
> -	case XFS_DQ_USER:
> +	switch (type) {
> +	case XFS_DQTYPE_USER:
>  		return mp->m_quotainfo->qi_uquotaip;
> -	case XFS_DQ_GROUP:
> +	case XFS_DQTYPE_GROUP:
>  		return mp->m_quotainfo->qi_gquotaip;
> -	case XFS_DQ_PROJ:
> +	case XFS_DQTYPE_PROJ:
>  		return mp->m_quotainfo->qi_pquotaip;
>  	default:
>  		ASSERT(0);
> @@ -114,17 +114,6 @@ xfs_quota_inode(xfs_mount_t *mp, uint dq_flags)
>  	return NULL;
>  }
>  
> -static inline int
> -xfs_dquot_type(struct xfs_dquot *dqp)
> -{
> -	if (XFS_QM_ISUDQ(dqp))
> -		return XFS_DQ_USER;
> -	if (XFS_QM_ISGDQ(dqp))
> -		return XFS_DQ_GROUP;
> -	ASSERT(XFS_QM_ISPDQ(dqp));
> -	return XFS_DQ_PROJ;
> -}
> -
>  extern void	xfs_trans_mod_dquot(struct xfs_trans *tp, struct xfs_dquot *dqp,
>  				    uint field, int64_t delta);
>  extern void	xfs_trans_dqjoin(struct xfs_trans *, struct xfs_dquot *);
> @@ -166,24 +155,30 @@ extern void		xfs_qm_dqrele_all_inodes(struct xfs_mount *, uint);
>  
>  /* quota ops */
>  extern int		xfs_qm_scall_trunc_qfiles(struct xfs_mount *, uint);
> -extern int		xfs_qm_scall_getquota(struct xfs_mount *, xfs_dqid_t,
> -					uint, struct qc_dqblk *);
> -extern int		xfs_qm_scall_getquota_next(struct xfs_mount *,
> -					xfs_dqid_t *, uint, struct qc_dqblk *);
> -extern int		xfs_qm_scall_setqlim(struct xfs_mount *, xfs_dqid_t, uint,
> -					struct qc_dqblk *);
> +extern int		xfs_qm_scall_getquota(struct xfs_mount *mp,
> +					xfs_dqid_t id,
> +					xfs_dqtype_t type,
> +					struct qc_dqblk *dst);
> +extern int		xfs_qm_scall_getquota_next(struct xfs_mount *mp,
> +					xfs_dqid_t *id,
> +					xfs_dqtype_t type,
> +					struct qc_dqblk *dst);
> +extern int		xfs_qm_scall_setqlim(struct xfs_mount *mp,
> +					xfs_dqid_t id,
> +					xfs_dqtype_t type,
> +					struct qc_dqblk *newlim);
>  extern int		xfs_qm_scall_quotaon(struct xfs_mount *, uint);
>  extern int		xfs_qm_scall_quotaoff(struct xfs_mount *, uint);
>  
>  static inline struct xfs_def_quota *
> -xfs_get_defquota(struct xfs_quotainfo *qi, int type)
> +xfs_get_defquota(struct xfs_quotainfo *qi, xfs_dqtype_t type)
>  {
>  	switch (type) {
> -	case XFS_DQ_USER:
> +	case XFS_DQTYPE_USER:
>  		return &qi->qi_usr_default;
> -	case XFS_DQ_GROUP:
> +	case XFS_DQTYPE_GROUP:
>  		return &qi->qi_grp_default;
> -	case XFS_DQ_PROJ:
> +	case XFS_DQTYPE_PROJ:
>  		return &qi->qi_prj_default;
>  	default:
>  		ASSERT(0);
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index fc2fa418919f..72c2c2595132 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -60,7 +60,7 @@ xfs_qm_statvfs(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_dquot	*dqp;
>  
> -	if (!xfs_qm_dqget(mp, ip->i_d.di_projid, XFS_DQ_PROJ, false, &dqp)) {
> +	if (!xfs_qm_dqget(mp, ip->i_d.di_projid, XFS_DQTYPE_PROJ, false, &dqp)) {
>  		xfs_fill_statvfs_from_dquot(statp, dqp);
>  		xfs_qm_dqput(dqp);
>  	}
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 35fad348e3a2..c7cb8a356c88 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -443,7 +443,7 @@ int
>  xfs_qm_scall_setqlim(
>  	struct xfs_mount	*mp,
>  	xfs_dqid_t		id,
> -	uint			type,
> +	xfs_dqtype_t		type,
>  	struct qc_dqblk		*newlim)
>  {
>  	struct xfs_quotainfo	*q = mp->m_quotainfo;
> @@ -479,7 +479,7 @@ xfs_qm_scall_setqlim(
>  		goto out_unlock;
>  	}
>  
> -	defq = xfs_get_defquota(q, xfs_dquot_type(dqp));
> +	defq = xfs_get_defquota(q, dqp->q_type);
>  	xfs_dqunlock(dqp);
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_setqlim, 0, 0, 0, &tp);
> @@ -614,7 +614,7 @@ xfs_qm_scall_setqlim(
>  static void
>  xfs_qm_scall_getquota_fill_qc(
>  	struct xfs_mount	*mp,
> -	uint			type,
> +	xfs_dqtype_t		type,
>  	const struct xfs_dquot	*dqp,
>  	struct qc_dqblk		*dst)
>  {
> @@ -644,21 +644,18 @@ xfs_qm_scall_getquota_fill_qc(
>  	 * gets turned off. No need to confuse the user level code,
>  	 * so return zeroes in that case.
>  	 */
> -	if ((!XFS_IS_UQUOTA_ENFORCED(mp) &&
> -	     dqp->q_core.d_flags == XFS_DQ_USER) ||
> -	    (!XFS_IS_GQUOTA_ENFORCED(mp) &&
> -	     dqp->q_core.d_flags == XFS_DQ_GROUP) ||
> -	    (!XFS_IS_PQUOTA_ENFORCED(mp) &&
> -	     dqp->q_core.d_flags == XFS_DQ_PROJ)) {
> +	if ((!XFS_IS_UQUOTA_ENFORCED(mp) && dqp->q_type == XFS_DQTYPE_USER) ||
> +	    (!XFS_IS_GQUOTA_ENFORCED(mp) && dqp->q_type == XFS_DQTYPE_GROUP) ||
> +	    (!XFS_IS_PQUOTA_ENFORCED(mp) && dqp->q_type == XFS_DQTYPE_PROJ)) {
>  		dst->d_spc_timer = 0;
>  		dst->d_ino_timer = 0;
>  		dst->d_rt_spc_timer = 0;
>  	}
>  
>  #ifdef DEBUG
> -	if (((XFS_IS_UQUOTA_ENFORCED(mp) && type == XFS_DQ_USER) ||
> -	     (XFS_IS_GQUOTA_ENFORCED(mp) && type == XFS_DQ_GROUP) ||
> -	     (XFS_IS_PQUOTA_ENFORCED(mp) && type == XFS_DQ_PROJ)) &&
> +	if (((XFS_IS_UQUOTA_ENFORCED(mp) && type == XFS_DQTYPE_USER) ||
> +	     (XFS_IS_GQUOTA_ENFORCED(mp) && type == XFS_DQTYPE_GROUP) ||
> +	     (XFS_IS_PQUOTA_ENFORCED(mp) && type == XFS_DQTYPE_PROJ)) &&
>  	    dqp->q_core.d_id != 0) {
>  		if ((dst->d_space > dst->d_spc_softlimit) &&
>  		    (dst->d_spc_softlimit > 0)) {
> @@ -677,7 +674,7 @@ int
>  xfs_qm_scall_getquota(
>  	struct xfs_mount	*mp,
>  	xfs_dqid_t		id,
> -	uint			type,
> +	xfs_dqtype_t		type,
>  	struct qc_dqblk		*dst)
>  {
>  	struct xfs_dquot	*dqp;
> @@ -715,7 +712,7 @@ int
>  xfs_qm_scall_getquota_next(
>  	struct xfs_mount	*mp,
>  	xfs_dqid_t		*id,
> -	uint			type,
> +	xfs_dqtype_t		type,
>  	struct qc_dqblk		*dst)
>  {
>  	struct xfs_dquot	*dqp;
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index c92ae5e02ce8..06b22e35fc90 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -39,14 +39,14 @@ struct xfs_buf;
>  
>  static inline uint
>  xfs_quota_chkd_flag(
> -	uint		dqtype)
> +	xfs_dqtype_t		type)
>  {
> -	switch (dqtype) {
> -	case XFS_DQ_USER:
> +	switch (type) {
> +	case XFS_DQTYPE_USER:
>  		return XFS_UQUOTA_CHKD;
> -	case XFS_DQ_GROUP:
> +	case XFS_DQTYPE_GROUP:
>  		return XFS_GQUOTA_CHKD;
> -	case XFS_DQ_PROJ:
> +	case XFS_DQTYPE_PROJ:
>  		return XFS_PQUOTA_CHKD;
>  	default:
>  		return 0;
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index 0868e6ee2219..963c253558b3 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -85,16 +85,16 @@ xfs_fs_get_quota_state(
>  	return 0;
>  }
>  
> -STATIC int
> +STATIC xfs_dqtype_t
>  xfs_quota_type(int type)
>  {
>  	switch (type) {
>  	case USRQUOTA:
> -		return XFS_DQ_USER;
> +		return XFS_DQTYPE_USER;
>  	case GRPQUOTA:
> -		return XFS_DQ_GROUP;
> +		return XFS_DQTYPE_GROUP;
>  	default:
> -		return XFS_DQ_PROJ;
> +		return XFS_DQTYPE_PROJ;
>  	}
>  }
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 50c478374a31..f19e66da6646 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -864,6 +864,7 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(u32, id)
> +		__field(xfs_dqtype_t, type)
>  		__field(unsigned, flags)
>  		__field(unsigned, nrefs)
>  		__field(unsigned long long, res_bcount)
> @@ -877,6 +878,7 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
>  	TP_fast_assign(
>  		__entry->dev = dqp->q_mount->m_super->s_dev;
>  		__entry->id = be32_to_cpu(dqp->q_core.d_id);
> +		__entry->type = dqp->q_type;
>  		__entry->flags = dqp->dq_flags;
>  		__entry->nrefs = dqp->q_nrefs;
>  		__entry->res_bcount = dqp->q_res_bcount;
> @@ -891,11 +893,12 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
>  		__entry->ino_softlimit =
>  			be64_to_cpu(dqp->q_core.d_ino_softlimit);
>  	),
> -	TP_printk("dev %d:%d id 0x%x flags %s nrefs %u res_bc 0x%llx "
> +	TP_printk("dev %d:%d id 0x%x type %s flags %s nrefs %u res_bc 0x%llx "
>  		  "bcnt 0x%llx bhardlimit 0x%llx bsoftlimit 0x%llx "
>  		  "icnt 0x%llx ihardlimit 0x%llx isoftlimit 0x%llx]",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->id,
> +		  __print_symbolic(__entry->type, XFS_DQTYPE_STRINGS),
>  		  __print_flags(__entry->flags, "|", XFS_DQ_FLAGS),
>  		  __entry->nrefs,
>  		  __entry->res_bcount,
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index ed0ce8b301b4..964f69a444a3 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -549,14 +549,21 @@ xfs_quota_warn(
>  	struct xfs_dquot	*dqp,
>  	int			type)
>  {
> -	enum quota_type qtype;
> +	enum quota_type		qtype;
>  
> -	if (dqp->dq_flags & XFS_DQ_PROJ)
> +	switch (dqp->q_type) {
> +	case XFS_DQTYPE_PROJ:
>  		qtype = PRJQUOTA;
> -	else if (dqp->dq_flags & XFS_DQ_USER)
> +		break;
> +	case XFS_DQTYPE_USER:
>  		qtype = USRQUOTA;
> -	else
> +		break;
> +	case XFS_DQTYPE_GROUP:
>  		qtype = GRPQUOTA;
> +		break;
> +	default:
> +		return;
> +	}
>  
>  	quota_send_warning(make_kqid(&init_user_ns, qtype,
>  				     be32_to_cpu(dqp->q_core.d_id)),
> @@ -591,7 +598,7 @@ xfs_trans_dqresv(
>  
>  	xfs_dqlock(dqp);
>  
> -	defq = xfs_get_defquota(q, xfs_dquot_type(dqp));
> +	defq = xfs_get_defquota(q, dqp->q_type);
>  
>  	if (flags & XFS_TRANS_DQ_RES_BLKS) {
>  		hardlimit = be64_to_cpu(dqp->q_core.d_blk_hardlimit);
> 
> 


-- 
chandan



