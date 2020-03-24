Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	TVD_PH_BODY_ACCOUNTS_PRE,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C64E1C43331
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 20:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 908AE20735
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 20:39:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GQMn9diP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgCXUjQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 16:39:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36090 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbgCXUjQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 16:39:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKd7GZ077903;
        Tue, 24 Mar 2020 20:39:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=+h+x8DDFTWZavSQwMJybkNv78WYu+TMmtnuYQUkFze8=;
 b=GQMn9diP+vQOibwwDa7RCqXm3eAfABsjafEyuivkhRvI8MRxv0siXh+HHUpG/jliqbtM
 ldnvjNL/QD90GKH0bpJTJlv+PCsqNXEqByCc4nJInE7WGUPYemu2mI7MQl+3nw+MkX9A
 cnBrtR0pQPOyaUYpgQdma3DjAvDzdxrCUBnqIiG6Tkz23f93wp4zZwxHY8icuCjISdUC
 dASLBOt4uPaWFbG3nA6PzRHwn2fQBMPGQYf3EPPYjhZh/ar1FcHHjeMQLDlkNNdqbJWg
 Mzg20pYfhyRuDNNEZ0L22+mM2+KNj6FmmzNwWe3avmiMbKi0t785X2Tv2wQOPWPnMcNZ 4Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ywavm6jna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:39:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKaOVh089007;
        Tue, 24 Mar 2020 20:39:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yymbub97k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:39:07 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02OKd2QQ021800;
        Tue, 24 Mar 2020 20:39:02 GMT
Received: from localhost (/10.159.142.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 13:39:01 -0700
Date:   Tue, 24 Mar 2020 13:39:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 1/8] xfs: don't try to write a start record into every
 iclog
Message-ID: <20200324203900.GH29339@magnolia>
References: <20200324174459.770999-1-hch@lst.de>
 <20200324174459.770999-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324174459.770999-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003240103
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 06:44:52PM +0100, Christoph Hellwig wrote:
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
> [hch: use an need_start_rec bool]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 63 ++++++++++++++++++++++++------------------------
>  1 file changed, 32 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 2a90a483c2d6..bf071552094a 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
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
> @@ -2372,25 +2359,29 @@ xlog_write(
>  	int			record_cnt = 0;
>  	int			data_cnt = 0;
>  	int			error = 0;
> +	bool			need_start_rec = true;
>  
>  	*start_lsn = 0;
>  
> -	len = xlog_write_calc_vec_length(ticket, log_vector);
>  
>  	/*
>  	 * Region headers and bytes are already accounted for.
>  	 * We only need to take into account start records and
>  	 * split regions in this function.
>  	 */
> -	if (ticket->t_flags & XLOG_TIC_INITED)
> -		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> +	if (ticket->t_flags & XLOG_TIC_INITED) {
> +		ticket->t_curr_res -= sizeof(struct xlog_op_header);
> +		ticket->t_flags &= ~XLOG_TIC_INITED;
> +	}
>  
>  	/*
>  	 * Commit record headers need to be accounted for. These
>  	 * come in as separate writes so are easy to detect.
>  	 */
> -	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
> -		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> +	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
> +		ticket->t_curr_res -= sizeof(struct xlog_op_header);
> +		need_start_rec = false;
> +	}
>  
>  	if (ticket->t_curr_res < 0) {
>  		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
> @@ -2399,6 +2390,8 @@ xlog_write(
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  	}
>  
> +	len = xlog_write_calc_vec_length(ticket, log_vector, need_start_rec);
> +
>  	index = 0;
>  	lv = log_vector;
>  	vecp = lv->lv_iovecp;
> @@ -2425,7 +2418,6 @@ xlog_write(
>  		while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
>  			struct xfs_log_iovec	*reg;
>  			struct xlog_op_header	*ophdr;
> -			int			start_rec_copy;
>  			int			copy_len;
>  			int			copy_off;
>  			bool			ordered = false;
> @@ -2441,11 +2433,15 @@ xlog_write(
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
> @@ -2477,8 +2473,13 @@ xlog_write(
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
> -- 
> 2.25.1
> 
