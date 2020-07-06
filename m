Return-Path: <SRS0=eqR3=AR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B606C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jul 2020 13:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5189820702
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jul 2020 13:42:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MZ5vSMZH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgGFNmK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jul 2020 09:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbgGFNmJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jul 2020 09:42:09 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF6EC061755
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jul 2020 06:42:09 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l63so18380152pge.12
        for <linux-xfs@vger.kernel.org>; Mon, 06 Jul 2020 06:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gkab7ST1SVylHXPZ+M4BphaZUjK/nHXmZaBn4JB+Nek=;
        b=MZ5vSMZHrOOvPP0ZsAgJhoDSDBTutwx7MvC736wlzse8AX/uJdJUqo5Lk+ZMDmJR2Z
         j38LfsfpastJBdk/P8IIlNgmeplpq2BRnY7fYQCfUH6j8sWd+Qx+HNbA17QcA5QhOOh1
         57PHjN0BxrlK9NZzsCB6mJUo+T4HThWglNNx8Hsxq8+DhU8E1IAkSfum4wKXRAJnNfjv
         CqIJennD+J/V01WpT1/UZE4o3dHOcpwGskVYChiNMS/4k+jc7AG3FSeDoOPpTQNInyMk
         S/T9fXIA1y48n1+5/rVSNH3XlZS5Fxfa/6+8mELCv65F16wIAxvY1qjcenjqta771+Bo
         a8uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gkab7ST1SVylHXPZ+M4BphaZUjK/nHXmZaBn4JB+Nek=;
        b=Xb3Ns94qGK6S3RBxh7htSIuvvZ7nfhBcILxPATIeX5r2zZWuRPKzWHO2dfSDbZNztq
         sFH3u1OohXtJ8nbTEpXqkiBOResDRgyvRutT9Yyfb5K5FXnKtrrCWpaDl1oshgYSEcbA
         aiQkO19VBFEq155k555bUNzWpAyMjXbiYrKxQASdbwdx7odC88YL/jArIndANQ15qXTA
         94nrht6wlzc3aqcktRPKMha0T2BoPUY3LEvP3L/pMhw9v8wuWcWzvltozIAJa9lRRkyc
         uFFu5mQdPgGKBZWh3gW0JxKbt0xKBXnjd+qzsQlc41F3axk07DXm1AGpXBRWt26ADlPo
         rOTQ==
X-Gm-Message-State: AOAM531s3QBYiQkMOsyVxzLSFrnxZDmmQBJLk7lALvZdfjcHZsNJnjQa
        rD1l/I+A9UmZpZ+23B+I4io=
X-Google-Smtp-Source: ABdhPJzUQ1oN7Y6mU2SCw+E9P5F84hztilYU6gqtxR7yol9XGF5Yre7lf6QMLmCHYAd6rSeANm07tQ==
X-Received: by 2002:a65:6447:: with SMTP id s7mr40894251pgv.320.1594042929146;
        Mon, 06 Jul 2020 06:42:09 -0700 (PDT)
Received: from garuda.localnet ([122.167.225.228])
        by smtp.gmail.com with ESMTPSA id v8sm12641135pjf.46.2020.07.06.06.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 06:42:08 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/18] xfs: add more dquot tracepoints
Date:   Mon, 06 Jul 2020 19:12:05 +0530
Message-ID: <5014612.gPqhYtlA3v@garuda>
In-Reply-To: <159353182503.2864738.13936001087522113609.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia> <159353182503.2864738.13936001087522113609.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 30 June 2020 9:13:45 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add all the xfs_dquot fields to the tracepoint for that type; add a new
> tracepoint type for the qtrx structure (dquot transaction deltas); and
> use our new tracepoints.  This makes it easier for the author to trace
> changes to dquot counters for debugging.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_trace.h       |  140 +++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_trans_dquot.c |   21 +++++++
>  2 files changed, 159 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 851f97dfe9e3..35b9dfd3984f 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -36,6 +36,7 @@ struct xfs_owner_info;
>  struct xfs_trans_res;
>  struct xfs_inobt_rec_incore;
>  union xfs_btree_ptr;
> +struct xfs_dqtrx;
>  
>  #define XFS_ATTR_FILTER_FLAGS \
>  	{ XFS_ATTR_ROOT,	"ROOT" }, \
> @@ -867,37 +868,59 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
>  		__field(unsigned, flags)
>  		__field(unsigned, nrefs)
>  		__field(unsigned long long, res_bcount)
> +		__field(unsigned long long, res_rtbcount)
> +		__field(unsigned long long, res_icount)
> +
>  		__field(unsigned long long, bcount)
> +		__field(unsigned long long, rtbcount)
>  		__field(unsigned long long, icount)
> +
>  		__field(unsigned long long, blk_hardlimit)
>  		__field(unsigned long long, blk_softlimit)
> +		__field(unsigned long long, rtb_hardlimit)
> +		__field(unsigned long long, rtb_softlimit)
>  		__field(unsigned long long, ino_hardlimit)
>  		__field(unsigned long long, ino_softlimit)
> -	), \
> +	),
>  	TP_fast_assign(
>  		__entry->dev = dqp->q_mount->m_super->s_dev;
>  		__entry->id = dqp->q_id;
>  		__entry->flags = dqp->dq_flags;
>  		__entry->nrefs = dqp->q_nrefs;
> +
>  		__entry->res_bcount = dqp->q_blk.reserved;
> +		__entry->res_rtbcount = dqp->q_rtb.reserved;
> +		__entry->res_icount = dqp->q_ino.reserved;
> +
>  		__entry->bcount = dqp->q_blk.count;
> +		__entry->rtbcount = dqp->q_rtb.count;
>  		__entry->icount = dqp->q_ino.count;
> +
>  		__entry->blk_hardlimit = dqp->q_blk.hardlimit;
>  		__entry->blk_softlimit = dqp->q_blk.softlimit;
> +		__entry->rtb_hardlimit = dqp->q_rtb.hardlimit;
> +		__entry->rtb_softlimit = dqp->q_rtb.softlimit;
>  		__entry->ino_hardlimit = dqp->q_ino.hardlimit;
>  		__entry->ino_softlimit = dqp->q_ino.softlimit;
>  	),
> -	TP_printk("dev %d:%d id 0x%x flags %s nrefs %u res_bc 0x%llx "
> +	TP_printk("dev %d:%d id 0x%x flags %s nrefs %u "
> +		  "res_bc 0x%llx res_rtbc 0x%llx res_ic 0x%llx "
>  		  "bcnt 0x%llx bhardlimit 0x%llx bsoftlimit 0x%llx "
> +		  "rtbcnt 0x%llx rtbhardlimit 0x%llx rtbsoftlimit 0x%llx "
>  		  "icnt 0x%llx ihardlimit 0x%llx isoftlimit 0x%llx]",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->id,
>  		  __print_flags(__entry->flags, "|", XFS_DQ_FLAGS),
>  		  __entry->nrefs,
>  		  __entry->res_bcount,
> +		  __entry->res_rtbcount,
> +		  __entry->res_icount,
>  		  __entry->bcount,
>  		  __entry->blk_hardlimit,
>  		  __entry->blk_softlimit,
> +		  __entry->rtbcount,
> +		  __entry->rtb_hardlimit,
> +		  __entry->rtb_softlimit,
>  		  __entry->icount,
>  		  __entry->ino_hardlimit,
>  		  __entry->ino_softlimit)
> @@ -928,6 +951,119 @@ DEFINE_DQUOT_EVENT(xfs_dqrele);
>  DEFINE_DQUOT_EVENT(xfs_dqflush);
>  DEFINE_DQUOT_EVENT(xfs_dqflush_force);
>  DEFINE_DQUOT_EVENT(xfs_dqflush_done);
> +DEFINE_DQUOT_EVENT(xfs_trans_apply_dquot_deltas_before);
> +DEFINE_DQUOT_EVENT(xfs_trans_apply_dquot_deltas_after);
> +
> +#define XFS_QMOPT_FLAGS \
> +	{ XFS_QMOPT_UQUOTA,		"UQUOTA" }, \
> +	{ XFS_QMOPT_PQUOTA,		"PQUOTA" }, \
> +	{ XFS_QMOPT_FORCE_RES,		"FORCE_RES" }, \
> +	{ XFS_QMOPT_SBVERSION,		"SBVERSION" }, \
> +	{ XFS_QMOPT_GQUOTA,		"GQUOTA" }, \
> +	{ XFS_QMOPT_INHERIT,		"INHERIT" }, \
> +	{ XFS_QMOPT_RES_REGBLKS,	"RES_REGBLKS" }, \
> +	{ XFS_QMOPT_RES_RTBLKS,		"RES_RTBLKS" }, \
> +	{ XFS_QMOPT_BCOUNT,		"BCOUNT" }, \
> +	{ XFS_QMOPT_ICOUNT,		"ICOUNT" }, \
> +	{ XFS_QMOPT_RTBCOUNT,		"RTBCOUNT" }, \
> +	{ XFS_QMOPT_DELBCOUNT,		"DELBCOUNT" }, \
> +	{ XFS_QMOPT_DELRTBCOUNT,	"DELRTBCOUNT" }, \
> +	{ XFS_QMOPT_RES_INOS,		"RES_INOS" }
> +
> +TRACE_EVENT(xfs_trans_mod_dquot,
> +	TP_PROTO(struct xfs_trans *tp, struct xfs_dquot *dqp,
> +		 unsigned int field, int64_t delta),
> +	TP_ARGS(tp, dqp, field, delta),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(unsigned int, dqflags)
> +		__field(unsigned int, dqid)
> +		__field(unsigned int, field)
> +		__field(int64_t, delta)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = tp->t_mountp->m_super->s_dev;
> +		__entry->dqflags = dqp->dq_flags;
> +		__entry->dqid = dqp->q_id;
> +		__entry->field = field;
> +		__entry->delta = delta;
> +	),
> +	TP_printk("dev %d:%d dquot %s id 0x%x %s delta %lld",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		   __print_flags(__entry->dqflags, "|", XFS_DQ_FLAGS),
> +		  __entry->dqid,
> +		   __print_flags(__entry->field, "|", XFS_QMOPT_FLAGS),
> +		  __entry->delta)
> +);
> +
> +DECLARE_EVENT_CLASS(xfs_dqtrx_class,
> +	TP_PROTO(struct xfs_dqtrx *qtrx),
> +	TP_ARGS(qtrx),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(unsigned int, dqflags)
> +		__field(u32, dqid)
> +
> +		__field(uint64_t, blk_res)
> +		__field(int64_t,  bcount_delta)
> +		__field(int64_t,  delbcnt_delta)
> +
> +		__field(uint64_t, rtblk_res)
> +		__field(uint64_t, rtblk_res_used)
> +		__field(int64_t,  rtbcount_delta)
> +		__field(int64_t,  delrtb_delta)
> +
> +		__field(uint64_t, ino_res)
> +		__field(uint64_t, ino_res_used)
> +		__field(int64_t,  icount_delta)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = qtrx->qt_dquot->q_mount->m_super->s_dev;
> +		__entry->dqflags = qtrx->qt_dquot->dq_flags;
> +		__entry->dqid = qtrx->qt_dquot->q_id;
> +
> +		__entry->blk_res = qtrx->qt_blk_res;
> +		__entry->bcount_delta = qtrx->qt_bcount_delta;
> +		__entry->delbcnt_delta = qtrx->qt_delbcnt_delta;
> +
> +		__entry->rtblk_res = qtrx->qt_rtblk_res;
> +		__entry->rtblk_res_used = qtrx->qt_rtblk_res_used;
> +		__entry->rtbcount_delta = qtrx->qt_rtbcount_delta;
> +		__entry->delrtb_delta = qtrx->qt_delrtb_delta;
> +
> +		__entry->ino_res = qtrx->qt_ino_res;
> +		__entry->ino_res_used = qtrx->qt_ino_res_used;
> +		__entry->icount_delta = qtrx->qt_icount_delta;
> +	),
> +	TP_printk("dev %d:%d dquot %s id 0x%x "
> +		  "blk_res %llu bcount_delta %lld delbcnt_delta %lld "
> +		  "rtblk_res %llu rtblk_res_used %llu rtbcount_delta %lld delrtb_delta %lld "
> +		  "ino_res %llu ino_res_used %llu icount_delta %lld",
> +		MAJOR(__entry->dev), MINOR(__entry->dev),
> +		__print_flags(__entry->dqflags, "|", XFS_DQ_FLAGS),
> +		__entry->dqid,
> +
> +		__entry->blk_res,
> +		__entry->bcount_delta,
> +		__entry->delbcnt_delta,
> +
> +		__entry->rtblk_res,
> +		__entry->rtblk_res_used,
> +		__entry->rtbcount_delta,
> +		__entry->delrtb_delta,
> +
> +		__entry->ino_res,
> +		__entry->ino_res_used,
> +		__entry->icount_delta)
> +)
> +
> +#define DEFINE_DQTRX_EVENT(name) \
> +DEFINE_EVENT(xfs_dqtrx_class, name, \
> +	TP_PROTO(struct xfs_dqtrx *qtrx), \
> +	TP_ARGS(qtrx))
> +DEFINE_DQTRX_EVENT(xfs_trans_apply_dquot_deltas);
> +DEFINE_DQTRX_EVENT(xfs_trans_mod_dquot_before);
> +DEFINE_DQTRX_EVENT(xfs_trans_mod_dquot_after);
>  
>  DECLARE_EVENT_CLASS(xfs_loggrant_class,
>  	TP_PROTO(struct xlog *log, struct xlog_ticket *tic),
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 701923ea6c04..5689d9f1b748 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -15,6 +15,7 @@
>  #include "xfs_trans_priv.h"
>  #include "xfs_quota.h"
>  #include "xfs_qm.h"
> +#include "xfs_trace.h"
>  
>  STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
>  
> @@ -203,6 +204,11 @@ xfs_trans_mod_dquot(
>  	if (qtrx->qt_dquot == NULL)
>  		qtrx->qt_dquot = dqp;
>  
> +	if (delta) {
> +		trace_xfs_trans_mod_dquot_before(qtrx);
> +		trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
> +	}
> +
>  	switch (field) {
>  
>  		/*
> @@ -266,6 +272,10 @@ xfs_trans_mod_dquot(
>  	      default:
>  		ASSERT(0);
>  	}
> +
> +	if (delta)
> +		trace_xfs_trans_mod_dquot_after(qtrx);
> +
>  	tp->t_flags |= XFS_TRANS_DQ_DIRTY;
>  }
>  
> @@ -391,6 +401,13 @@ xfs_trans_apply_dquot_deltas(
>  				qtrx->qt_delbcnt_delta;
>  			totalrtbdelta = qtrx->qt_rtbcount_delta +
>  				qtrx->qt_delrtb_delta;
> +
> +			if (totalbdelta != 0 || totalrtbdelta != 0 ||
> +			    qtrx->qt_icount_delta != 0) {
> +				trace_xfs_trans_apply_dquot_deltas_before(dqp);
> +				trace_xfs_trans_apply_dquot_deltas(qtrx);
> +			}
> +
>  #ifdef DEBUG
>  			if (totalbdelta < 0)
>  				ASSERT(dqp->q_blk.count >= -totalbdelta);
> @@ -410,6 +427,10 @@ xfs_trans_apply_dquot_deltas(
>  			if (totalrtbdelta)
>  				dqp->q_rtb.count += totalrtbdelta;
>  
> +			if (totalbdelta != 0 || totalrtbdelta != 0 ||
> +			    qtrx->qt_icount_delta != 0)
> +				trace_xfs_trans_apply_dquot_deltas_after(dqp);
> +
>  			/*
>  			 * Get any default limits in use.
>  			 * Start/reset the timer(s) if needed.
> 
> 


-- 
chandan



