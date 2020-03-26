Return-Path: <SRS0=JvtZ=5L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	TVD_PH_BODY_ACCOUNTS_PRE,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D6AC43331
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 04:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C6CE206E6
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 04:49:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cgb/imCC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgCZEto (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 00:49:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59602 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbgCZEto (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Mar 2020 00:49:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02Q4nZ7a160823;
        Thu, 26 Mar 2020 04:49:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=D5vqPe371sqV0hLNvkPqzxk/sWuUia9CH+Q4pQa6CAQ=;
 b=cgb/imCCpB1MuPKErpaq3RAioYzxZb8O3niLh7zls33KGdqfNCCxZTXyI6W+nvt1ZYiY
 c/sDCJKjXlXE9/NguY3mMSUTj6JBzeNRopqzoTSX2QkihL9GDXrmJ47KMbg1bmfXpfFq
 4gBxV3qKahe6qzUH4U6IzCnkd7lQC0PSrVd1ZMkJbqZHJFYJUK2YxyxnW2YYaKdQWWmc
 XVUq2r58sUfja41yhzQ1etuscBoC1ABy9zIW/DlxKxL0vxEooxo1FUkiXle35oViTJwI
 ZGt8jyPxafs3hzUIfYDMyZ69HemT67duPLyPl4twDwzIw5smGh5SpzgsVIcD2gQCAFJ/ Cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3005kvcfw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Mar 2020 04:49:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02Q4moR7122713;
        Thu, 26 Mar 2020 04:49:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30073c7dvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Mar 2020 04:49:34 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02Q4nVpe028936;
        Thu, 26 Mar 2020 04:49:31 GMT
Received: from localhost (/10.159.237.96)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Mar 2020 21:49:30 -0700
Date:   Wed, 25 Mar 2020 21:49:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 1/8] xfs: don't try to write a start record into every
 iclog
Message-ID: <20200326044929.GZ29339@magnolia>
References: <20200325184305.1361872-1-hch@lst.de>
 <20200325184305.1361872-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325184305.1361872-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9571 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=2 mlxscore=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003260029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9571 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=2 impostorscore=0 spamscore=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003260029
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 25, 2020 at 07:42:58PM +0100, Christoph Hellwig wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The xlog_write() function iterates over iclogs until it completes
> writing all the log vectors passed in. The ticket tracks whether
> a start record has been written or not, so only the first iclog gets
> a start record. We only ever pass single use tickets to
> xlog_write() so we only ever need to write a start record once per
> xlog_write() call.
> 
> Hence we don't need to store whether we should write a start record
> in the ticket as the callers provide all the information we need to
> determine if a start record should be written. For the moment, we
> have to ensure that we clear the XLOG_TIC_INITED appropriately so
> the code in xfs_log_done() still works correctly for committing
> transactions.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> [hch: pass an explicit need_start_rec argument]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c      | 77 +++++++++++++++++++++----------------------
>  fs/xfs/xfs_log_cil.c  |  2 +-
>  fs/xfs/xfs_log_priv.h | 12 +++----
>  3 files changed, 42 insertions(+), 49 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 2a90a483c2d6..617b393272de 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -921,7 +921,7 @@ xfs_log_write_unmount_record(
>  	/* remove inited flag, and account for space used */
>  	tic->t_flags = 0;
>  	tic->t_curr_res -= sizeof(magic);
> -	error = xlog_write(log, &vec, tic, &lsn, NULL, flags);
> +	error = xlog_write(log, &vec, tic, &lsn, NULL, flags, false);

/me vaguely doesn't like the look of flags and a boolean, but teaching
this mess to have separate flags namespaces and mask them out
appropriately seems like a much more confusing mess...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  	/*
>  	 * At this point, we're umounting anyway, so there's no point in
>  	 * transitioning log state to IOERROR. Just continue...
> @@ -1541,7 +1541,7 @@ xlog_commit_record(
>  
>  	ASSERT_ALWAYS(iclog);
>  	error = xlog_write(log, &vec, ticket, commitlsnp, iclog,
> -					XLOG_COMMIT_TRANS);
> +					XLOG_COMMIT_TRANS, false);
>  	if (error)
>  		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
>  	return error;
> @@ -2112,23 +2112,21 @@ xlog_print_trans(
>  }
>  
>  /*
> - * Calculate the potential space needed by the log vector.  Each region gets
> - * its own xlog_op_header_t and may need to be double word aligned.
> + * Calculate the potential space needed by the log vector.  We may need a start
> + * record, and each region gets its own struct xlog_op_header and may need to be
> + * double word aligned.
>   */
>  static int
>  xlog_write_calc_vec_length(
>  	struct xlog_ticket	*ticket,
> -	struct xfs_log_vec	*log_vector)
> +	struct xfs_log_vec	*log_vector,
> +	bool			need_start_rec)
>  {
>  	struct xfs_log_vec	*lv;
> -	int			headers = 0;
> +	int			headers = need_start_rec ? 1 : 0;
>  	int			len = 0;
>  	int			i;
>  
> -	/* acct for start rec of xact */
> -	if (ticket->t_flags & XLOG_TIC_INITED)
> -		headers++;
> -
>  	for (lv = log_vector; lv; lv = lv->lv_next) {
>  		/* we don't write ordered log vectors */
>  		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED)
> @@ -2150,27 +2148,16 @@ xlog_write_calc_vec_length(
>  	return len;
>  }
>  
> -/*
> - * If first write for transaction, insert start record  We can't be trying to
> - * commit if we are inited.  We can't have any "partial_copy" if we are inited.
> - */
> -static int
> +static void
>  xlog_write_start_rec(
>  	struct xlog_op_header	*ophdr,
>  	struct xlog_ticket	*ticket)
>  {
> -	if (!(ticket->t_flags & XLOG_TIC_INITED))
> -		return 0;
> -
>  	ophdr->oh_tid	= cpu_to_be32(ticket->t_tid);
>  	ophdr->oh_clientid = ticket->t_clientid;
>  	ophdr->oh_len = 0;
>  	ophdr->oh_flags = XLOG_START_TRANS;
>  	ophdr->oh_res2 = 0;
> -
> -	ticket->t_flags &= ~XLOG_TIC_INITED;
> -
> -	return sizeof(struct xlog_op_header);
>  }
>  
>  static xlog_op_header_t *
> @@ -2359,7 +2346,8 @@ xlog_write(
>  	struct xlog_ticket	*ticket,
>  	xfs_lsn_t		*start_lsn,
>  	struct xlog_in_core	**commit_iclog,
> -	uint			flags)
> +	uint			flags,
> +	bool			need_start_rec)
>  {
>  	struct xlog_in_core	*iclog = NULL;
>  	struct xfs_log_iovec	*vecp;
> @@ -2375,23 +2363,22 @@ xlog_write(
>  
>  	*start_lsn = 0;
>  
> -	len = xlog_write_calc_vec_length(ticket, log_vector);
>  
>  	/*
> -	 * Region headers and bytes are already accounted for.
> -	 * We only need to take into account start records and
> -	 * split regions in this function.
> +	 * Region headers and bytes are already accounted for.  We only need to
> +	 * take into account start records and split regions in this function.
>  	 */
> -	if (ticket->t_flags & XLOG_TIC_INITED)
> -		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> +	if (ticket->t_flags & XLOG_TIC_INITED) {
> +		ticket->t_curr_res -= sizeof(struct xlog_op_header);
> +		ticket->t_flags &= ~XLOG_TIC_INITED;
> +	}
>  
>  	/*
> -	 * Commit record headers need to be accounted for. These
> -	 * come in as separate writes so are easy to detect.
> +	 * Commit record headers and unmount records need to be accounted for.
> +	 * These come in as separate writes so are easy to detect.
>  	 */
> -	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
> -		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> -
> +	if (!need_start_rec)
> +		ticket->t_curr_res -= sizeof(struct xlog_op_header);
>  	if (ticket->t_curr_res < 0) {
>  		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
>  		     "ctx ticket reservation ran out. Need to up reservation");
> @@ -2399,6 +2386,8 @@ xlog_write(
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  	}
>  
> +	len = xlog_write_calc_vec_length(ticket, log_vector, need_start_rec);
> +
>  	index = 0;
>  	lv = log_vector;
>  	vecp = lv->lv_iovecp;
> @@ -2425,7 +2414,6 @@ xlog_write(
>  		while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
>  			struct xfs_log_iovec	*reg;
>  			struct xlog_op_header	*ophdr;
> -			int			start_rec_copy;
>  			int			copy_len;
>  			int			copy_off;
>  			bool			ordered = false;
> @@ -2441,11 +2429,15 @@ xlog_write(
>  			ASSERT(reg->i_len % sizeof(int32_t) == 0);
>  			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
>  
> -			start_rec_copy = xlog_write_start_rec(ptr, ticket);
> -			if (start_rec_copy) {
> -				record_cnt++;
> +			/*
> +			 * Before we start formatting log vectors, we need to
> +			 * write a start record. Only do this for the first
> +			 * iclog we write to.
> +			 */
> +			if (need_start_rec) {
> +				xlog_write_start_rec(ptr, ticket);
>  				xlog_write_adv_cnt(&ptr, &len, &log_offset,
> -						   start_rec_copy);
> +						sizeof(struct xlog_op_header));
>  			}
>  
>  			ophdr = xlog_write_setup_ophdr(log, ptr, ticket, flags);
> @@ -2477,8 +2469,13 @@ xlog_write(
>  				xlog_write_adv_cnt(&ptr, &len, &log_offset,
>  						   copy_len);
>  			}
> -			copy_len += start_rec_copy + sizeof(xlog_op_header_t);
> +			copy_len += sizeof(struct xlog_op_header);
>  			record_cnt++;
> +			if (need_start_rec) {
> +				copy_len += sizeof(struct xlog_op_header);
> +				record_cnt++;
> +				need_start_rec = false;
> +			}
>  			data_cnt += contwr ? copy_len : 0;
>  
>  			error = xlog_write_copy_finish(log, iclog, flags,
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 64cc0bf2ab3b..e0aeb316ce6c 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -801,7 +801,7 @@ xlog_cil_push_work(
>  	lvhdr.lv_iovecp = &lhdr;
>  	lvhdr.lv_next = ctx->lv_chain;
>  
> -	error = xlog_write(log, &lvhdr, tic, &ctx->start_lsn, NULL, 0);
> +	error = xlog_write(log, &lvhdr, tic, &ctx->start_lsn, NULL, 0, true);
>  	if (error)
>  		goto out_abort_free_ticket;
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 2b0aec37e73e..b895e16460ee 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -439,14 +439,10 @@ xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
>  
>  void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
>  void	xlog_print_trans(struct xfs_trans *);
> -int
> -xlog_write(
> -	struct xlog		*log,
> -	struct xfs_log_vec	*log_vector,
> -	struct xlog_ticket	*tic,
> -	xfs_lsn_t		*start_lsn,
> -	struct xlog_in_core	**commit_iclog,
> -	uint			flags);
> +int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
> +		struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
> +		struct xlog_in_core **commit_iclog, uint flags,
> +		bool need_start_rec);
>  
>  /*
>   * When we crack an atomic LSN, we sample it first so that the value will not
> -- 
> 2.25.1
> 
