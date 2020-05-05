Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0813C47256
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 04:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB5A620721
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 04:32:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EGdALnTp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgEEEcN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 00:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725766AbgEEEcM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 00:32:12 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED66C061A0F
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 21:32:12 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id f7so287036pfa.9
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 21:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Iq+Jlb7sJ/NW7CaTPEgwK62EVhW/LA4f9MrCw9CUEiE=;
        b=EGdALnTpwUgopVSTNOTrlR4ijgEkPWJ2ykktrv8zdNh495Lw3FMxtf9GVcVkwhOYyM
         PHUHUQcGZ4RCdVVI/SHBuaHScNC5j+6dsPbnHJTp2ZmRlaknMsNMaAAVviB9kDX+75+B
         075siZriYQC2A9RLAwROJRfXWvEOODFHm/y8+5++xgsugWwHz0QTDBRJYMnGGRk89ozs
         Y7icBEmlQW0h695CQZdca4hb6/xbjAoHmik+gONPwFsT2x7GtzUo63COPujLoaFTbZld
         aX6a7bwiOq4e1Tn7LTNm7UbF7cOIdzdkj8HnAyXRgTkTDUEFLGHVzP1bKdntINi/WLi3
         JI5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Iq+Jlb7sJ/NW7CaTPEgwK62EVhW/LA4f9MrCw9CUEiE=;
        b=mc1CNqBH+TNmBSk+H6XNwPwU5wzahscebpvS0Meeqnegaj4GmwX/vqOWZLRytWyl72
         lcO1c7EKSEg4W8lRYsBwUqZuiIWl/+EPuxiQMDOUZdc9tdSEqhVvnsdnQDoJb8OFJaaQ
         i+6n5OV7AYRkJ5k5MIcRvj+BDwBG27QLMtp/TATXciHVkrgi9T+Rp9XOtyYRX0c/GVIE
         J8l3+pZ0qOv7IYDgx/tNSEiN/g/sc6lXJzziWnKO3VNPlJXxxwvgYfoZdZBNay3i8zyP
         VueBFlGTreAj8aeENEUU/m/QoTyEQmvqZS4FBlAWKpjGYvpALOtV1kV7U/bfGAQDLoDD
         cnOQ==
X-Gm-Message-State: AGi0PuY820MzpMJtzUgr3aDJ1Edq2BmN7iYp4eRAM65uwfbu9rx/ev/l
        42D5/ay1IdKC5KAJsyhl6lL/0mKrDBk=
X-Google-Smtp-Source: APiQypJvJx2kqI7QZTZkIDk1h6z7zQc863vjp6+W6stEP5vuPKAF1SHHLBP4hy0HBJeB2YcjxWMtvA==
X-Received: by 2002:a63:ea4f:: with SMTP id l15mr1367997pgk.58.1588653131992;
        Mon, 04 May 2020 21:32:11 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.206])
        by smtp.gmail.com with ESMTPSA id o40sm525103pjb.18.2020.05.04.21.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 21:32:11 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/28] xfs: refactor log recovery item dispatch for pass2 readhead functions
Date:   Tue, 05 May 2020 10:02:08 +0530
Message-ID: <2019775.Dxmdr8bm5S@garuda>
In-Reply-To: <158864105149.182683.6318302965348913819.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864105149.182683.6318302965348913819.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:40:51 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the pass2 readhead code into the per-item source code files and use
> the dispatch function to call them.
>

Buf, Inode and Dquot items were read ahead before the patch modifications.
These are the only items on which readahead is started in this patch.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_log_recover.h |    6 ++
>  fs/xfs/xfs_buf_item_recover.c   |   11 +++++
>  fs/xfs/xfs_dquot_item_recover.c |   34 ++++++++++++++
>  fs/xfs/xfs_inode_item_recover.c |   19 ++++++++
>  fs/xfs/xfs_log_recover.c        |   95 +--------------------------------------
>  5 files changed, 73 insertions(+), 92 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
> index 271b0741f1e1..ff80871138bb 100644
> --- a/fs/xfs/libxfs/xfs_log_recover.h
> +++ b/fs/xfs/libxfs/xfs_log_recover.h
> @@ -31,6 +31,9 @@ struct xlog_recover_item_ops {
>  	 * values mean.
>  	 */
>  	enum xlog_recover_reorder (*reorder)(struct xlog_recover_item *item);
> +
> +	/* Start readahead for pass2, if provided. */
> +	void (*ra_pass2)(struct xlog *log, struct xlog_recover_item *item);
>  };
>  
>  extern const struct xlog_recover_item_ops xlog_icreate_item_ops;
> @@ -92,4 +95,7 @@ struct xlog_recover {
>  #define	XLOG_RECOVER_PASS1	1
>  #define	XLOG_RECOVER_PASS2	2
>  
> +void xlog_buf_readahead(struct xlog *log, xfs_daddr_t blkno, uint len,
> +		const struct xfs_buf_ops *ops);
> +
>  #endif	/* __XFS_LOG_RECOVER_H__ */
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index def19025512e..a1327196b690 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -32,7 +32,18 @@ xlog_recover_buf_reorder(
>  	return XLOG_REORDER_BUFFER_LIST;
>  }
>  
> +STATIC void
> +xlog_recover_buf_ra_pass2(
> +	struct xlog                     *log,
> +	struct xlog_recover_item        *item)
> +{
> +	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
> +
> +	xlog_buf_readahead(log, buf_f->blf_blkno, buf_f->blf_len, NULL);
> +}
> +
>  const struct xlog_recover_item_ops xlog_buf_item_ops = {
>  	.item_type		= XFS_LI_BUF,
>  	.reorder		= xlog_recover_buf_reorder,
> +	.ra_pass2		= xlog_recover_buf_ra_pass2,
>  };
> diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
> index 78fe644e9907..215274173b70 100644
> --- a/fs/xfs/xfs_dquot_item_recover.c
> +++ b/fs/xfs/xfs_dquot_item_recover.c
> @@ -20,8 +20,42 @@
>  #include "xfs_log_priv.h"
>  #include "xfs_log_recover.h"
>  
> +STATIC void
> +xlog_recover_dquot_ra_pass2(
> +	struct xlog			*log,
> +	struct xlog_recover_item	*item)
> +{
> +	struct xfs_mount	*mp = log->l_mp;
> +	struct xfs_disk_dquot	*recddq;
> +	struct xfs_dq_logformat	*dq_f;
> +	uint			type;
> +
> +	if (mp->m_qflags == 0)
> +		return;
> +
> +	recddq = item->ri_buf[1].i_addr;
> +	if (recddq == NULL)
> +		return;
> +	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot))
> +		return;
> +
> +	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
> +	ASSERT(type);
> +	if (log->l_quotaoffs_flag & type)
> +		return;
> +
> +	dq_f = item->ri_buf[0].i_addr;
> +	ASSERT(dq_f);
> +	ASSERT(dq_f->qlf_len == 1);
> +
> +	xlog_buf_readahead(log, dq_f->qlf_blkno,
> +			XFS_FSB_TO_BB(mp, dq_f->qlf_len),
> +			&xfs_dquot_buf_ra_ops);
> +}
> +
>  const struct xlog_recover_item_ops xlog_dquot_item_ops = {
>  	.item_type		= XFS_LI_DQUOT,
> +	.ra_pass2		= xlog_recover_dquot_ra_pass2,
>  };
>  
>  const struct xlog_recover_item_ops xlog_quotaoff_item_ops = {
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index b19a151efb10..a132cacd8d48 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -21,6 +21,25 @@
>  #include "xfs_log_priv.h"
>  #include "xfs_log_recover.h"
>  
> +STATIC void
> +xlog_recover_inode_ra_pass2(
> +	struct xlog                     *log,
> +	struct xlog_recover_item        *item)
> +{
> +	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
> +		struct xfs_inode_log_format	*ilfp = item->ri_buf[0].i_addr;
> +
> +		xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
> +				   &xfs_inode_buf_ra_ops);
> +	} else {
> +		struct xfs_inode_log_format_32	*ilfp = item->ri_buf[0].i_addr;
> +
> +		xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
> +				   &xfs_inode_buf_ra_ops);
> +	}
> +}
> +
>  const struct xlog_recover_item_ops xlog_inode_item_ops = {
>  	.item_type		= XFS_LI_INODE,
> +	.ra_pass2		= xlog_recover_inode_ra_pass2,
>  };
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 0ef0d81fd190..ea566747d8e1 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2023,7 +2023,7 @@ xlog_put_buffer_cancelled(
>  	return true;
>  }
>  
> -static void
> +void
>  xlog_buf_readahead(
>  	struct xlog		*log,
>  	xfs_daddr_t		blkno,
> @@ -3890,96 +3890,6 @@ xlog_recover_do_icreate_pass2(
>  				     length, be32_to_cpu(icl->icl_gen));
>  }
>  
> -STATIC void
> -xlog_recover_buffer_ra_pass2(
> -	struct xlog                     *log,
> -	struct xlog_recover_item        *item)
> -{
> -	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
> -
> -	xlog_buf_readahead(log, buf_f->blf_blkno, buf_f->blf_len, NULL);
> -}
> -
> -STATIC void
> -xlog_recover_inode_ra_pass2(
> -	struct xlog                     *log,
> -	struct xlog_recover_item        *item)
> -{
> -	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
> -		struct xfs_inode_log_format	*ilfp = item->ri_buf[0].i_addr;
> -
> -		xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
> -				   &xfs_inode_buf_ra_ops);
> -	} else {
> -		struct xfs_inode_log_format_32	*ilfp = item->ri_buf[0].i_addr;
> -
> -		xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
> -				   &xfs_inode_buf_ra_ops);
> -	}
> -}
> -
> -STATIC void
> -xlog_recover_dquot_ra_pass2(
> -	struct xlog			*log,
> -	struct xlog_recover_item	*item)
> -{
> -	struct xfs_mount	*mp = log->l_mp;
> -	struct xfs_disk_dquot	*recddq;
> -	struct xfs_dq_logformat	*dq_f;
> -	uint			type;
> -
> -	if (mp->m_qflags == 0)
> -		return;
> -
> -	recddq = item->ri_buf[1].i_addr;
> -	if (recddq == NULL)
> -		return;
> -	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot))
> -		return;
> -
> -	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
> -	ASSERT(type);
> -	if (log->l_quotaoffs_flag & type)
> -		return;
> -
> -	dq_f = item->ri_buf[0].i_addr;
> -	ASSERT(dq_f);
> -	ASSERT(dq_f->qlf_len == 1);
> -
> -	xlog_buf_readahead(log, dq_f->qlf_blkno,
> -			XFS_FSB_TO_BB(mp, dq_f->qlf_len),
> -			&xfs_dquot_buf_ra_ops);
> -}
> -
> -STATIC void
> -xlog_recover_ra_pass2(
> -	struct xlog			*log,
> -	struct xlog_recover_item	*item)
> -{
> -	switch (ITEM_TYPE(item)) {
> -	case XFS_LI_BUF:
> -		xlog_recover_buffer_ra_pass2(log, item);
> -		break;
> -	case XFS_LI_INODE:
> -		xlog_recover_inode_ra_pass2(log, item);
> -		break;
> -	case XFS_LI_DQUOT:
> -		xlog_recover_dquot_ra_pass2(log, item);
> -		break;
> -	case XFS_LI_EFI:
> -	case XFS_LI_EFD:
> -	case XFS_LI_QUOTAOFF:
> -	case XFS_LI_RUI:
> -	case XFS_LI_RUD:
> -	case XFS_LI_CUI:
> -	case XFS_LI_CUD:
> -	case XFS_LI_BUI:
> -	case XFS_LI_BUD:
> -	default:
> -		break;
> -	}
> -}
> -
>  STATIC int
>  xlog_recover_commit_pass1(
>  	struct xlog			*log,
> @@ -4116,7 +4026,8 @@ xlog_recover_commit_trans(
>  			error = xlog_recover_commit_pass1(log, trans, item);
>  			break;
>  		case XLOG_RECOVER_PASS2:
> -			xlog_recover_ra_pass2(log, item);
> +			if (item->ri_ops->ra_pass2)
> +				item->ri_ops->ra_pass2(log, item);
>  			list_move_tail(&item->ri_list, &ra_list);
>  			items_queued++;
>  			if (items_queued >= XLOG_RECOVER_COMMIT_QUEUE_MAX) {
> 
> 


-- 
chandan



