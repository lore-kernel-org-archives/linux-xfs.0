Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD9F6C49EA7
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Jun 2021 08:58:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FA9A61988
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Jun 2021 08:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhF1JA4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Jun 2021 05:00:56 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:33048 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232200AbhF1JAz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Jun 2021 05:00:55 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15S8uvp8032729;
        Mon, 28 Jun 2021 08:58:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=Lv2mDaSAZj3I2L9IC4i6KU8CCdiH+Grq8Jy9eVPKODo=;
 b=sb7wRACFu7pX35192iVCWE3tKGQUi2TwOz0ufas525R3q148zmbNThuUELKNiKcAQH2E
 2l02IccZtyU0mArAOwwIDJH3H4GIwOcLWatRMGCj7yZ4Mq5k4V8kZ0mXnjDe/DuvZfmI
 +X7gilkd9aegG4/GL7ZTbXe5dYIK7E+bhvkjzkEm/EymPBJQBtW/e8jsDlTw2UfBmB/U
 IbzXoAMhc+I26Htvn143ntefAlRpIMgUM3jphn9dGKXfTTBDjSRQA9+iXi7UkpdFCmRr
 nsh6KAEtX8aO3wQScLhy/93sHs0ph9crJIXS0KKEqCHD1xiYIeZ3pl8F8KYndt+NHBDm og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f6y3ghpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Jun 2021 08:58:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15S8njUW078327;
        Mon, 28 Jun 2021 08:58:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 39ee0s1j0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Jun 2021 08:58:26 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15S8wP45103067;
        Mon, 28 Jun 2021 08:58:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 39ee0s1hyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Jun 2021 08:58:25 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.14.4) with ESMTP id 15S8wNAP016501;
        Mon, 28 Jun 2021 08:58:23 GMT
Received: from kadam (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Jun 2021 01:58:22 -0700
Date:   Mon, 28 Jun 2021 11:58:15 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Dave Chinner <david@fromorbit.com>,
        linux-xfs@vger.kernel.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org
Subject: Re: [PATCH 4/8] xfs: pass a CIL context to xlog_write()
Message-ID: <202106270717.0cDJhbXU-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617082617.971602-5-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: oruSvM2RqQD3fyYaluT3PfNwkyHUEDHM
X-Proofpoint-ORIG-GUID: oruSvM2RqQD3fyYaluT3PfNwkyHUEDHM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

url:    https://github.com/0day-ci/linux/commits/Dave-Chinner/xfs-log-fixes-for-for-next/20210617-162640
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
config: h8300-randconfig-m031-20210625 (attached as .config)
compiler: h8300-linux-gcc (GCC) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

New smatch warnings:
fs/xfs/xfs_log_cil.c:1130 xlog_cil_push_work() error: uninitialized symbol 'commit_lsn'.


vim +/commit_lsn +1130 fs/xfs/xfs_log_cil.c

c7cc296ddd1f6d Christoph Hellwig 2020-03-20   861  static void
c7cc296ddd1f6d Christoph Hellwig 2020-03-20   862  xlog_cil_push_work(
c7cc296ddd1f6d Christoph Hellwig 2020-03-20   863  	struct work_struct	*work)
71e330b593905e Dave Chinner      2010-05-21   864  {
facd77e4e38b8f Dave Chinner      2021-06-04   865  	struct xfs_cil_ctx	*ctx =
facd77e4e38b8f Dave Chinner      2021-06-04   866  		container_of(work, struct xfs_cil_ctx, push_work);
facd77e4e38b8f Dave Chinner      2021-06-04   867  	struct xfs_cil		*cil = ctx->cil;
c7cc296ddd1f6d Christoph Hellwig 2020-03-20   868  	struct xlog		*log = cil->xc_log;
71e330b593905e Dave Chinner      2010-05-21   869  	struct xfs_log_vec	*lv;
71e330b593905e Dave Chinner      2010-05-21   870  	struct xfs_cil_ctx	*new_ctx;
71e330b593905e Dave Chinner      2010-05-21   871  	struct xlog_in_core	*commit_iclog;
66fc9ffa8638be Dave Chinner      2021-06-04   872  	int			num_iovecs = 0;
66fc9ffa8638be Dave Chinner      2021-06-04   873  	int			num_bytes = 0;
71e330b593905e Dave Chinner      2010-05-21   874  	int			error = 0;
877cf3473914ae Dave Chinner      2021-06-04   875  	struct xlog_cil_trans_hdr thdr;
a47518453bf958 Dave Chinner      2021-06-08   876  	struct xfs_log_vec	lvhdr = {};
71e330b593905e Dave Chinner      2010-05-21   877  	xfs_lsn_t		commit_lsn;
                                                                                ^^^^^^^^^^

4c2d542f2e7865 Dave Chinner      2012-04-23   878  	xfs_lsn_t		push_seq;
0279bbbbc03f2c Dave Chinner      2021-06-03   879  	struct bio		bio;
0279bbbbc03f2c Dave Chinner      2021-06-03   880  	DECLARE_COMPLETION_ONSTACK(bdev_flush);
e12213ba5d909a Dave Chinner      2021-06-04   881  	bool			push_commit_stable;
e469cbe84f4ade Dave Chinner      2021-06-08   882  	struct xlog_ticket	*ticket;
71e330b593905e Dave Chinner      2010-05-21   883  
facd77e4e38b8f Dave Chinner      2021-06-04   884  	new_ctx = xlog_cil_ctx_alloc();
71e330b593905e Dave Chinner      2010-05-21   885  	new_ctx->ticket = xlog_cil_ticket_alloc(log);
71e330b593905e Dave Chinner      2010-05-21   886  
71e330b593905e Dave Chinner      2010-05-21   887  	down_write(&cil->xc_ctx_lock);
71e330b593905e Dave Chinner      2010-05-21   888  
4bb928cdb900d0 Dave Chinner      2013-08-12   889  	spin_lock(&cil->xc_push_lock);
4c2d542f2e7865 Dave Chinner      2012-04-23   890  	push_seq = cil->xc_push_seq;
4c2d542f2e7865 Dave Chinner      2012-04-23   891  	ASSERT(push_seq <= ctx->sequence);
e12213ba5d909a Dave Chinner      2021-06-04   892  	push_commit_stable = cil->xc_push_commit_stable;
e12213ba5d909a Dave Chinner      2021-06-04   893  	cil->xc_push_commit_stable = false;
71e330b593905e Dave Chinner      2010-05-21   894  
0e7ab7efe77451 Dave Chinner      2020-03-24   895  	/*
3682277520d6f4 Dave Chinner      2021-06-04   896  	 * As we are about to switch to a new, empty CIL context, we no longer
3682277520d6f4 Dave Chinner      2021-06-04   897  	 * need to throttle tasks on CIL space overruns. Wake any waiters that
3682277520d6f4 Dave Chinner      2021-06-04   898  	 * the hard push throttle may have caught so they can start committing
3682277520d6f4 Dave Chinner      2021-06-04   899  	 * to the new context. The ctx->xc_push_lock provides the serialisation
3682277520d6f4 Dave Chinner      2021-06-04   900  	 * necessary for safely using the lockless waitqueue_active() check in
3682277520d6f4 Dave Chinner      2021-06-04   901  	 * this context.
3682277520d6f4 Dave Chinner      2021-06-04   902  	 */
3682277520d6f4 Dave Chinner      2021-06-04   903  	if (waitqueue_active(&cil->xc_push_wait))
c7f87f3984cfa1 Dave Chinner      2020-06-16   904  		wake_up_all(&cil->xc_push_wait);
0e7ab7efe77451 Dave Chinner      2020-03-24   905  
4c2d542f2e7865 Dave Chinner      2012-04-23   906  	/*
4c2d542f2e7865 Dave Chinner      2012-04-23   907  	 * Check if we've anything to push. If there is nothing, then we don't
4c2d542f2e7865 Dave Chinner      2012-04-23   908  	 * move on to a new sequence number and so we have to be able to push
4c2d542f2e7865 Dave Chinner      2012-04-23   909  	 * this sequence again later.
4c2d542f2e7865 Dave Chinner      2012-04-23   910  	 */
0d11bae4bcf4aa Dave Chinner      2021-06-04   911  	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags)) {
4c2d542f2e7865 Dave Chinner      2012-04-23   912  		cil->xc_push_seq = 0;
4bb928cdb900d0 Dave Chinner      2013-08-12   913  		spin_unlock(&cil->xc_push_lock);
a44f13edf0ebb4 Dave Chinner      2010-08-24   914  		goto out_skip;
4c2d542f2e7865 Dave Chinner      2012-04-23   915  	}
4c2d542f2e7865 Dave Chinner      2012-04-23   916  
a44f13edf0ebb4 Dave Chinner      2010-08-24   917  
cf085a1b5d2214 Joe Perches       2019-11-07   918  	/* check for a previously pushed sequence */
facd77e4e38b8f Dave Chinner      2021-06-04   919  	if (push_seq < ctx->sequence) {
8af3dcd3c89aef Dave Chinner      2014-09-23   920  		spin_unlock(&cil->xc_push_lock);
df806158b0f6eb Dave Chinner      2010-05-17   921  		goto out_skip;
8af3dcd3c89aef Dave Chinner      2014-09-23   922  	}
8af3dcd3c89aef Dave Chinner      2014-09-23   923  
8af3dcd3c89aef Dave Chinner      2014-09-23   924  	/*
8af3dcd3c89aef Dave Chinner      2014-09-23   925  	 * We are now going to push this context, so add it to the committing
8af3dcd3c89aef Dave Chinner      2014-09-23   926  	 * list before we do anything else. This ensures that anyone waiting on
8af3dcd3c89aef Dave Chinner      2014-09-23   927  	 * this push can easily detect the difference between a "push in
8af3dcd3c89aef Dave Chinner      2014-09-23   928  	 * progress" and "CIL is empty, nothing to do".
8af3dcd3c89aef Dave Chinner      2014-09-23   929  	 *
8af3dcd3c89aef Dave Chinner      2014-09-23   930  	 * IOWs, a wait loop can now check for:
8af3dcd3c89aef Dave Chinner      2014-09-23   931  	 *	the current sequence not being found on the committing list;
8af3dcd3c89aef Dave Chinner      2014-09-23   932  	 *	an empty CIL; and
8af3dcd3c89aef Dave Chinner      2014-09-23   933  	 *	an unchanged sequence number
8af3dcd3c89aef Dave Chinner      2014-09-23   934  	 * to detect a push that had nothing to do and therefore does not need
8af3dcd3c89aef Dave Chinner      2014-09-23   935  	 * waiting on. If the CIL is not empty, we get put on the committing
8af3dcd3c89aef Dave Chinner      2014-09-23   936  	 * list before emptying the CIL and bumping the sequence number. Hence
8af3dcd3c89aef Dave Chinner      2014-09-23   937  	 * an empty CIL and an unchanged sequence number means we jumped out
8af3dcd3c89aef Dave Chinner      2014-09-23   938  	 * above after doing nothing.
8af3dcd3c89aef Dave Chinner      2014-09-23   939  	 *
8af3dcd3c89aef Dave Chinner      2014-09-23   940  	 * Hence the waiter will either find the commit sequence on the
8af3dcd3c89aef Dave Chinner      2014-09-23   941  	 * committing list or the sequence number will be unchanged and the CIL
8af3dcd3c89aef Dave Chinner      2014-09-23   942  	 * still dirty. In that latter case, the push has not yet started, and
8af3dcd3c89aef Dave Chinner      2014-09-23   943  	 * so the waiter will have to continue trying to check the CIL
8af3dcd3c89aef Dave Chinner      2014-09-23   944  	 * committing list until it is found. In extreme cases of delay, the
8af3dcd3c89aef Dave Chinner      2014-09-23   945  	 * sequence may fully commit between the attempts the wait makes to wait
8af3dcd3c89aef Dave Chinner      2014-09-23   946  	 * on the commit sequence.
8af3dcd3c89aef Dave Chinner      2014-09-23   947  	 */
8af3dcd3c89aef Dave Chinner      2014-09-23   948  	list_add(&ctx->committing, &cil->xc_committing);
8af3dcd3c89aef Dave Chinner      2014-09-23   949  	spin_unlock(&cil->xc_push_lock);
df806158b0f6eb Dave Chinner      2010-05-17   950  
71e330b593905e Dave Chinner      2010-05-21   951  	/*
0279bbbbc03f2c Dave Chinner      2021-06-03   952  	 * The CIL is stable at this point - nothing new will be added to it
0279bbbbc03f2c Dave Chinner      2021-06-03   953  	 * because we hold the flush lock exclusively. Hence we can now issue
0279bbbbc03f2c Dave Chinner      2021-06-03   954  	 * a cache flush to ensure all the completed metadata in the journal we
0279bbbbc03f2c Dave Chinner      2021-06-03   955  	 * are about to overwrite is on stable storage.
0279bbbbc03f2c Dave Chinner      2021-06-03   956  	 */
0279bbbbc03f2c Dave Chinner      2021-06-03   957  	xfs_flush_bdev_async(&bio, log->l_mp->m_ddev_targp->bt_bdev,
0279bbbbc03f2c Dave Chinner      2021-06-03   958  				&bdev_flush);
0279bbbbc03f2c Dave Chinner      2021-06-03   959  
a8613836d99e62 Dave Chinner      2021-06-08   960  	xlog_cil_pcp_aggregate(cil, ctx);
a8613836d99e62 Dave Chinner      2021-06-08   961  
1f18c0c4b78cfb Dave Chinner      2021-06-08   962  	while (!list_empty(&ctx->log_items)) {
71e330b593905e Dave Chinner      2010-05-21   963  		struct xfs_log_item	*item;
71e330b593905e Dave Chinner      2010-05-21   964  
1f18c0c4b78cfb Dave Chinner      2021-06-08   965  		item = list_first_entry(&ctx->log_items,
71e330b593905e Dave Chinner      2010-05-21   966  					struct xfs_log_item, li_cil);
a47518453bf958 Dave Chinner      2021-06-08   967  		lv = item->li_lv;
a1785f597c8b06 Dave Chinner      2021-06-08   968  		lv->lv_order_id = item->li_order_id;
a47518453bf958 Dave Chinner      2021-06-08   969  		num_iovecs += lv->lv_niovecs;
66fc9ffa8638be Dave Chinner      2021-06-04   970  		/* we don't write ordered log vectors */
66fc9ffa8638be Dave Chinner      2021-06-04   971  		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
66fc9ffa8638be Dave Chinner      2021-06-04   972  			num_bytes += lv->lv_bytes;
a47518453bf958 Dave Chinner      2021-06-08   973  
a47518453bf958 Dave Chinner      2021-06-08   974  		list_add_tail(&lv->lv_list, &ctx->lv_chain);
a1785f597c8b06 Dave Chinner      2021-06-08   975  		list_del_init(&item->li_cil);
a1785f597c8b06 Dave Chinner      2021-06-08   976  		item->li_order_id = 0;
a1785f597c8b06 Dave Chinner      2021-06-08   977  		item->li_lv = NULL;
71e330b593905e Dave Chinner      2010-05-21   978  	}
71e330b593905e Dave Chinner      2010-05-21   979  
71e330b593905e Dave Chinner      2010-05-21   980  	/*
facd77e4e38b8f Dave Chinner      2021-06-04   981  	 * Switch the contexts so we can drop the context lock and move out
71e330b593905e Dave Chinner      2010-05-21   982  	 * of a shared context. We can't just go straight to the commit record,
71e330b593905e Dave Chinner      2010-05-21   983  	 * though - we need to synchronise with previous and future commits so
71e330b593905e Dave Chinner      2010-05-21   984  	 * that the commit records are correctly ordered in the log to ensure
71e330b593905e Dave Chinner      2010-05-21   985  	 * that we process items during log IO completion in the correct order.
71e330b593905e Dave Chinner      2010-05-21   986  	 *
71e330b593905e Dave Chinner      2010-05-21   987  	 * For example, if we get an EFI in one checkpoint and the EFD in the
71e330b593905e Dave Chinner      2010-05-21   988  	 * next (e.g. due to log forces), we do not want the checkpoint with
71e330b593905e Dave Chinner      2010-05-21   989  	 * the EFD to be committed before the checkpoint with the EFI.  Hence
71e330b593905e Dave Chinner      2010-05-21   990  	 * we must strictly order the commit records of the checkpoints so
71e330b593905e Dave Chinner      2010-05-21   991  	 * that: a) the checkpoint callbacks are attached to the iclogs in the
71e330b593905e Dave Chinner      2010-05-21   992  	 * correct order; and b) the checkpoints are replayed in correct order
71e330b593905e Dave Chinner      2010-05-21   993  	 * in log recovery.
71e330b593905e Dave Chinner      2010-05-21   994  	 *
71e330b593905e Dave Chinner      2010-05-21   995  	 * Hence we need to add this context to the committing context list so
71e330b593905e Dave Chinner      2010-05-21   996  	 * that higher sequences will wait for us to write out a commit record
71e330b593905e Dave Chinner      2010-05-21   997  	 * before they do.
f876e44603ad09 Dave Chinner      2014-02-27   998  	 *
f39ae5297c5ce2 Dave Chinner      2021-06-04   999  	 * xfs_log_force_seq requires us to mirror the new sequence into the cil
f876e44603ad09 Dave Chinner      2014-02-27  1000  	 * structure atomically with the addition of this sequence to the
f876e44603ad09 Dave Chinner      2014-02-27  1001  	 * committing list. This also ensures that we can do unlocked checks
f876e44603ad09 Dave Chinner      2014-02-27  1002  	 * against the current sequence in log forces without risking
f876e44603ad09 Dave Chinner      2014-02-27  1003  	 * deferencing a freed context pointer.
71e330b593905e Dave Chinner      2010-05-21  1004  	 */
4bb928cdb900d0 Dave Chinner      2013-08-12  1005  	spin_lock(&cil->xc_push_lock);
facd77e4e38b8f Dave Chinner      2021-06-04  1006  	xlog_cil_ctx_switch(cil, new_ctx);
4bb928cdb900d0 Dave Chinner      2013-08-12  1007  	spin_unlock(&cil->xc_push_lock);
71e330b593905e Dave Chinner      2010-05-21  1008  	up_write(&cil->xc_ctx_lock);
71e330b593905e Dave Chinner      2010-05-21  1009  
a1785f597c8b06 Dave Chinner      2021-06-08  1010  	/*
a1785f597c8b06 Dave Chinner      2021-06-08  1011  	 * Sort the log vector chain before we add the transaction headers.
a1785f597c8b06 Dave Chinner      2021-06-08  1012  	 * This ensures we always have the transaction headers at the start
a1785f597c8b06 Dave Chinner      2021-06-08  1013  	 * of the chain.
a1785f597c8b06 Dave Chinner      2021-06-08  1014  	 */
a1785f597c8b06 Dave Chinner      2021-06-08  1015  	list_sort(NULL, &ctx->lv_chain, xlog_cil_order_cmp);
a1785f597c8b06 Dave Chinner      2021-06-08  1016  
71e330b593905e Dave Chinner      2010-05-21  1017  	/*
71e330b593905e Dave Chinner      2010-05-21  1018  	 * Build a checkpoint transaction header and write it to the log to
71e330b593905e Dave Chinner      2010-05-21  1019  	 * begin the transaction. We need to account for the space used by the
71e330b593905e Dave Chinner      2010-05-21  1020  	 * transaction header here as it is not accounted for in xlog_write().
a47518453bf958 Dave Chinner      2021-06-08  1021  	 * Add the lvhdr to the head of the lv chain we pass to xlog_write() so
a47518453bf958 Dave Chinner      2021-06-08  1022  	 * it gets written into the iclog first.
71e330b593905e Dave Chinner      2010-05-21  1023  	 */
877cf3473914ae Dave Chinner      2021-06-04  1024  	xlog_cil_build_trans_hdr(ctx, &thdr, &lvhdr, num_iovecs);
66fc9ffa8638be Dave Chinner      2021-06-04  1025  	num_bytes += lvhdr.lv_bytes;
a47518453bf958 Dave Chinner      2021-06-08  1026  	list_add(&lvhdr.lv_list, &ctx->lv_chain);
71e330b593905e Dave Chinner      2010-05-21  1027  
0279bbbbc03f2c Dave Chinner      2021-06-03  1028  	/*
0279bbbbc03f2c Dave Chinner      2021-06-03  1029  	 * Before we format and submit the first iclog, we have to ensure that
0279bbbbc03f2c Dave Chinner      2021-06-03  1030  	 * the metadata writeback ordering cache flush is complete.
0279bbbbc03f2c Dave Chinner      2021-06-03  1031  	 */
0279bbbbc03f2c Dave Chinner      2021-06-03  1032  	wait_for_completion(&bdev_flush);
0279bbbbc03f2c Dave Chinner      2021-06-03  1033  
877cf3473914ae Dave Chinner      2021-06-04  1034  	/*
877cf3473914ae Dave Chinner      2021-06-04  1035  	 * The LSN we need to pass to the log items on transaction commit is the
877cf3473914ae Dave Chinner      2021-06-04  1036  	 * LSN reported by the first log vector write, not the commit lsn. If we
877cf3473914ae Dave Chinner      2021-06-04  1037  	 * use the commit record lsn then we can move the tail beyond the grant
877cf3473914ae Dave Chinner      2021-06-04  1038  	 * write head.
877cf3473914ae Dave Chinner      2021-06-04  1039  	 */
fc3370002b56bc Dave Chinner      2021-06-17  1040  	error = xlog_write(log, ctx, &ctx->lv_chain, ctx->ticket,
a47518453bf958 Dave Chinner      2021-06-08  1041  				NULL, num_bytes);
a47518453bf958 Dave Chinner      2021-06-08  1042  
a47518453bf958 Dave Chinner      2021-06-08  1043  	/*
a47518453bf958 Dave Chinner      2021-06-08  1044  	 * Take the lvhdr back off the lv_chain as it should not be passed
a47518453bf958 Dave Chinner      2021-06-08  1045  	 * to log IO completion.
a47518453bf958 Dave Chinner      2021-06-08  1046  	 */
a47518453bf958 Dave Chinner      2021-06-08  1047  	list_del(&lvhdr.lv_list);
71e330b593905e Dave Chinner      2010-05-21  1048  	if (error)
7db37c5e6575b2 Dave Chinner      2011-01-27  1049  		goto out_abort_free_ticket;
71e330b593905e Dave Chinner      2010-05-21  1050  
71e330b593905e Dave Chinner      2010-05-21  1051  	/*
71e330b593905e Dave Chinner      2010-05-21  1052  	 * now that we've written the checkpoint into the log, strictly
71e330b593905e Dave Chinner      2010-05-21  1053  	 * order the commit records so replay will get them in the right order.
71e330b593905e Dave Chinner      2010-05-21  1054  	 */
71e330b593905e Dave Chinner      2010-05-21  1055  restart:
4bb928cdb900d0 Dave Chinner      2013-08-12  1056  	spin_lock(&cil->xc_push_lock);
71e330b593905e Dave Chinner      2010-05-21  1057  	list_for_each_entry(new_ctx, &cil->xc_committing, committing) {
ac983517ec5941 Dave Chinner      2014-05-07  1058  		/*
ac983517ec5941 Dave Chinner      2014-05-07  1059  		 * Avoid getting stuck in this loop because we were woken by the
ac983517ec5941 Dave Chinner      2014-05-07  1060  		 * shutdown, but then went back to sleep once already in the
ac983517ec5941 Dave Chinner      2014-05-07  1061  		 * shutdown state.
ac983517ec5941 Dave Chinner      2014-05-07  1062  		 */
ac983517ec5941 Dave Chinner      2014-05-07  1063  		if (XLOG_FORCED_SHUTDOWN(log)) {
ac983517ec5941 Dave Chinner      2014-05-07  1064  			spin_unlock(&cil->xc_push_lock);
ac983517ec5941 Dave Chinner      2014-05-07  1065  			goto out_abort_free_ticket;
ac983517ec5941 Dave Chinner      2014-05-07  1066  		}
ac983517ec5941 Dave Chinner      2014-05-07  1067  
71e330b593905e Dave Chinner      2010-05-21  1068  		/*
71e330b593905e Dave Chinner      2010-05-21  1069  		 * Higher sequences will wait for this one so skip them.
ac983517ec5941 Dave Chinner      2014-05-07  1070  		 * Don't wait for our own sequence, either.
71e330b593905e Dave Chinner      2010-05-21  1071  		 */
71e330b593905e Dave Chinner      2010-05-21  1072  		if (new_ctx->sequence >= ctx->sequence)
71e330b593905e Dave Chinner      2010-05-21  1073  			continue;
71e330b593905e Dave Chinner      2010-05-21  1074  		if (!new_ctx->commit_lsn) {
71e330b593905e Dave Chinner      2010-05-21  1075  			/*
71e330b593905e Dave Chinner      2010-05-21  1076  			 * It is still being pushed! Wait for the push to
71e330b593905e Dave Chinner      2010-05-21  1077  			 * complete, then start again from the beginning.
71e330b593905e Dave Chinner      2010-05-21  1078  			 */
4bb928cdb900d0 Dave Chinner      2013-08-12  1079  			xlog_wait(&cil->xc_commit_wait, &cil->xc_push_lock);
71e330b593905e Dave Chinner      2010-05-21  1080  			goto restart;
71e330b593905e Dave Chinner      2010-05-21  1081  		}
71e330b593905e Dave Chinner      2010-05-21  1082  	}
4bb928cdb900d0 Dave Chinner      2013-08-12  1083  	spin_unlock(&cil->xc_push_lock);
71e330b593905e Dave Chinner      2010-05-21  1084  
fc3370002b56bc Dave Chinner      2021-06-17  1085  	error = xlog_cil_write_commit_record(ctx, &commit_iclog);
dd401770b0ff68 Dave Chinner      2020-03-25  1086  	if (error)
dd401770b0ff68 Dave Chinner      2020-03-25  1087  		goto out_abort_free_ticket;
dd401770b0ff68 Dave Chinner      2020-03-25  1088  
89ae379d564c5d Christoph Hellwig 2019-06-28  1089  	spin_lock(&commit_iclog->ic_callback_lock);
1858bb0bec612d Christoph Hellwig 2019-10-14  1090  	if (commit_iclog->ic_state == XLOG_STATE_IOERROR) {
89ae379d564c5d Christoph Hellwig 2019-06-28  1091  		spin_unlock(&commit_iclog->ic_callback_lock);
e469cbe84f4ade Dave Chinner      2021-06-08  1092  		goto out_abort_free_ticket;
89ae379d564c5d Christoph Hellwig 2019-06-28  1093  	}
89ae379d564c5d Christoph Hellwig 2019-06-28  1094  	ASSERT_ALWAYS(commit_iclog->ic_state == XLOG_STATE_ACTIVE ||
89ae379d564c5d Christoph Hellwig 2019-06-28  1095  		      commit_iclog->ic_state == XLOG_STATE_WANT_SYNC);
89ae379d564c5d Christoph Hellwig 2019-06-28  1096  	list_add_tail(&ctx->iclog_entry, &commit_iclog->ic_callbacks);
89ae379d564c5d Christoph Hellwig 2019-06-28  1097  	spin_unlock(&commit_iclog->ic_callback_lock);
71e330b593905e Dave Chinner      2010-05-21  1098  
71e330b593905e Dave Chinner      2010-05-21  1099  	/*
71e330b593905e Dave Chinner      2010-05-21  1100  	 * now the checkpoint commit is complete and we've attached the
71e330b593905e Dave Chinner      2010-05-21  1101  	 * callbacks to the iclog we can assign the commit LSN to the context
71e330b593905e Dave Chinner      2010-05-21  1102  	 * and wake up anyone who is waiting for the commit to complete.
71e330b593905e Dave Chinner      2010-05-21  1103  	 */
4bb928cdb900d0 Dave Chinner      2013-08-12  1104  	spin_lock(&cil->xc_push_lock);
eb40a87500ac2f Dave Chinner      2010-12-21  1105  	wake_up_all(&cil->xc_commit_wait);
4bb928cdb900d0 Dave Chinner      2013-08-12  1106  	spin_unlock(&cil->xc_push_lock);
71e330b593905e Dave Chinner      2010-05-21  1107  
e469cbe84f4ade Dave Chinner      2021-06-08  1108  	/*
e469cbe84f4ade Dave Chinner      2021-06-08  1109  	 * Pull the ticket off the ctx so we can ungrant it after releasing the
e469cbe84f4ade Dave Chinner      2021-06-08  1110  	 * commit_iclog. The ctx may be freed by the time we return from
e469cbe84f4ade Dave Chinner      2021-06-08  1111  	 * releasing the commit_iclog (i.e. checkpoint has been completed and
e469cbe84f4ade Dave Chinner      2021-06-08  1112  	 * callback run) so we can't reference the ctx after the call to
e469cbe84f4ade Dave Chinner      2021-06-08  1113  	 * xlog_state_release_iclog().
e469cbe84f4ade Dave Chinner      2021-06-08  1114  	 */
e469cbe84f4ade Dave Chinner      2021-06-08  1115  	ticket = ctx->ticket;
e469cbe84f4ade Dave Chinner      2021-06-08  1116  
5fd9256ce156ef Dave Chinner      2021-06-03  1117  	/*
815753dc16bbca Dave Chinner      2021-06-17  1118  	 * If the checkpoint spans multiple iclogs, wait for all previous iclogs
815753dc16bbca Dave Chinner      2021-06-17  1119  	 * to complete before we submit the commit_iclog. We can't use state
815753dc16bbca Dave Chinner      2021-06-17  1120  	 * checks for this - ACTIVE can be either a past completed iclog or a
815753dc16bbca Dave Chinner      2021-06-17  1121  	 * future iclog being filled, while WANT_SYNC through SYNC_DONE can be a
815753dc16bbca Dave Chinner      2021-06-17  1122  	 * past or future iclog awaiting IO or ordered IO completion to be run.
815753dc16bbca Dave Chinner      2021-06-17  1123  	 * In the latter case, if it's a future iclog and we wait on it, the we
815753dc16bbca Dave Chinner      2021-06-17  1124  	 * will hang because it won't get processed through to ic_force_wait
815753dc16bbca Dave Chinner      2021-06-17  1125  	 * wakeup until this commit_iclog is written to disk.  Hence we use the
815753dc16bbca Dave Chinner      2021-06-17  1126  	 * iclog header lsn and compare it to the commit lsn to determine if we
815753dc16bbca Dave Chinner      2021-06-17  1127  	 * need to wait on iclogs or not.
5fd9256ce156ef Dave Chinner      2021-06-03  1128  	 */
5fd9256ce156ef Dave Chinner      2021-06-03  1129  	spin_lock(&log->l_icloglock);
cb1acb3f324636 Dave Chinner      2021-06-04 @1130  	if (ctx->start_lsn != commit_lsn) {
                                                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Never initialized.

815753dc16bbca Dave Chinner      2021-06-17  1131  		struct xlog_in_core	*iclog;
815753dc16bbca Dave Chinner      2021-06-17  1132  
815753dc16bbca Dave Chinner      2021-06-17  1133  		for (iclog = commit_iclog->ic_prev;
815753dc16bbca Dave Chinner      2021-06-17  1134  		     iclog != commit_iclog;
815753dc16bbca Dave Chinner      2021-06-17  1135  		     iclog = iclog->ic_prev) {
815753dc16bbca Dave Chinner      2021-06-17  1136  			xfs_lsn_t	hlsn;
815753dc16bbca Dave Chinner      2021-06-17  1137  
815753dc16bbca Dave Chinner      2021-06-17  1138  			/*
815753dc16bbca Dave Chinner      2021-06-17  1139  			 * If the LSN of the iclog is zero or in the future it
815753dc16bbca Dave Chinner      2021-06-17  1140  			 * means it has passed through IO completion and
815753dc16bbca Dave Chinner      2021-06-17  1141  			 * activation and hence all previous iclogs have also
815753dc16bbca Dave Chinner      2021-06-17  1142  			 * done so. We do not need to wait at all in this case.
815753dc16bbca Dave Chinner      2021-06-17  1143  			 */
815753dc16bbca Dave Chinner      2021-06-17  1144  			hlsn = be64_to_cpu(iclog->ic_header.h_lsn);
815753dc16bbca Dave Chinner      2021-06-17  1145  			if (!hlsn || XFS_LSN_CMP(hlsn, commit_lsn) > 0)
815753dc16bbca Dave Chinner      2021-06-17  1146  				break;
815753dc16bbca Dave Chinner      2021-06-17  1147  
815753dc16bbca Dave Chinner      2021-06-17  1148  			/*
815753dc16bbca Dave Chinner      2021-06-17  1149  			 * If the LSN of the iclog is older than the commit lsn,
815753dc16bbca Dave Chinner      2021-06-17  1150  			 * we have to wait on it. Waiting on this via the
815753dc16bbca Dave Chinner      2021-06-17  1151  			 * ic_force_wait should also order the completion of all
815753dc16bbca Dave Chinner      2021-06-17  1152  			 * older iclogs, too, but we leave checking that to the
815753dc16bbca Dave Chinner      2021-06-17  1153  			 * next loop iteration.
815753dc16bbca Dave Chinner      2021-06-17  1154  			 */
815753dc16bbca Dave Chinner      2021-06-17  1155  			ASSERT(XFS_LSN_CMP(hlsn, commit_lsn) < 0);
815753dc16bbca Dave Chinner      2021-06-17  1156  			xlog_wait_on_iclog(iclog);
cb1acb3f324636 Dave Chinner      2021-06-04  1157  			spin_lock(&log->l_icloglock);
815753dc16bbca Dave Chinner      2021-06-17  1158  		}
815753dc16bbca Dave Chinner      2021-06-17  1159  
815753dc16bbca Dave Chinner      2021-06-17  1160  		/*
815753dc16bbca Dave Chinner      2021-06-17  1161  		 * Regardless of whether we need to wait or not, the the
815753dc16bbca Dave Chinner      2021-06-17  1162  		 * commit_iclog write needs to issue a pre-flush so that the
815753dc16bbca Dave Chinner      2021-06-17  1163  		 * ordering for this checkpoint is correctly preserved down to
815753dc16bbca Dave Chinner      2021-06-17  1164  		 * stable storage.
815753dc16bbca Dave Chinner      2021-06-17  1165  		 */
cb1acb3f324636 Dave Chinner      2021-06-04  1166  		commit_iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
5fd9256ce156ef Dave Chinner      2021-06-03  1167  	}
5fd9256ce156ef Dave Chinner      2021-06-03  1168  
cb1acb3f324636 Dave Chinner      2021-06-04  1169  	/*
cb1acb3f324636 Dave Chinner      2021-06-04  1170  	 * The commit iclog must be written to stable storage to guarantee
cb1acb3f324636 Dave Chinner      2021-06-04  1171  	 * journal IO vs metadata writeback IO is correctly ordered on stable
cb1acb3f324636 Dave Chinner      2021-06-04  1172  	 * storage.
e12213ba5d909a Dave Chinner      2021-06-04  1173  	 *
e12213ba5d909a Dave Chinner      2021-06-04  1174  	 * If the push caller needs the commit to be immediately stable and the
e12213ba5d909a Dave Chinner      2021-06-04  1175  	 * commit_iclog is not yet marked as XLOG_STATE_WANT_SYNC to indicate it
e12213ba5d909a Dave Chinner      2021-06-04  1176  	 * will be written when released, switch it's state to WANT_SYNC right
e12213ba5d909a Dave Chinner      2021-06-04  1177  	 * now.
cb1acb3f324636 Dave Chinner      2021-06-04  1178  	 */
cb1acb3f324636 Dave Chinner      2021-06-04  1179  	commit_iclog->ic_flags |= XLOG_ICL_NEED_FUA;
e12213ba5d909a Dave Chinner      2021-06-04  1180  	if (push_commit_stable && commit_iclog->ic_state == XLOG_STATE_ACTIVE)
e12213ba5d909a Dave Chinner      2021-06-04  1181  		xlog_state_switch_iclogs(log, commit_iclog, 0);
e469cbe84f4ade Dave Chinner      2021-06-08  1182  	xlog_state_release_iclog(log, commit_iclog, ticket);
cb1acb3f324636 Dave Chinner      2021-06-04  1183  	spin_unlock(&log->l_icloglock);
e469cbe84f4ade Dave Chinner      2021-06-08  1184  
e469cbe84f4ade Dave Chinner      2021-06-08  1185  	xfs_log_ticket_ungrant(log, ticket);
c7cc296ddd1f6d Christoph Hellwig 2020-03-20  1186  	return;
71e330b593905e Dave Chinner      2010-05-21  1187  
71e330b593905e Dave Chinner      2010-05-21  1188  out_skip:
71e330b593905e Dave Chinner      2010-05-21  1189  	up_write(&cil->xc_ctx_lock);
71e330b593905e Dave Chinner      2010-05-21  1190  	xfs_log_ticket_put(new_ctx->ticket);
71e330b593905e Dave Chinner      2010-05-21  1191  	kmem_free(new_ctx);
c7cc296ddd1f6d Christoph Hellwig 2020-03-20  1192  	return;
71e330b593905e Dave Chinner      2010-05-21  1193  
7db37c5e6575b2 Dave Chinner      2011-01-27  1194  out_abort_free_ticket:
877cf3473914ae Dave Chinner      2021-06-04  1195  	xfs_log_ticket_ungrant(log, ctx->ticket);
12e6a0f449d585 Christoph Hellwig 2020-03-20  1196  	ASSERT(XLOG_FORCED_SHUTDOWN(log));
12e6a0f449d585 Christoph Hellwig 2020-03-20  1197  	xlog_cil_committed(ctx);
4c2d542f2e7865 Dave Chinner      2012-04-23  1198  }

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

