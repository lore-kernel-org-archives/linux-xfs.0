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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A9DAC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 20:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BFAD2070A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 20:39:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kfT0Sav2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgCXUjg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 16:39:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52270 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgCXUjg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 16:39:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKcMd3036755;
        Tue, 24 Mar 2020 20:39:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=r0JNyHTYHRn0ctxmM1EP4spuHnDzWeaC2Oac2/6/RUY=;
 b=kfT0Sav2j7JO1MuhrEoW37JCc6X7sRrnGS/VpgqrK/hnEHqaL6R8rFqdfAqLwcznM2d4
 bAqa6H1OLGkSHmGoz5Trm/XocBzzyo5VsXSsdmL68ZSXykJ6+VPie6+UvqEpozs0sbvN
 eFCMAw8HEdKT3dhUoMDB9vgpsU0f9Do+/6MnTUdX8x3WE5pouCo5Cqsx3bpo9Zoe/0o9
 i1IXu8r8+VToehOj/TZYtsGN3SRsOheAW1lCdxFjp84zHrO2tnvSv+jN6W7s+4QttXDg
 HIJDkbWWOLbc9mv3naIItlrnmi/FQRJO+WCQhBVvHNq1jU09gM3ybyJzgIhw4oq0atq2 8Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yx8ac3hsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:39:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKcMNY037600;
        Tue, 24 Mar 2020 20:39:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2yxw4q0q0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:39:28 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02OKdRrn030786;
        Tue, 24 Mar 2020 20:39:27 GMT
Received: from localhost (/10.159.142.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 13:39:27 -0700
Date:   Tue, 24 Mar 2020 13:39:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/8] xfs: re-order initial space accounting checks in
 xlog_write
Message-ID: <20200324203926.GI29339@magnolia>
References: <20200324174459.770999-1-hch@lst.de>
 <20200324174459.770999-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324174459.770999-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240103
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 06:44:53PM +0100, Christoph Hellwig wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Commit and unmount records records do not need start records to be
> written, so rearrange the logic in xlog_write() to remove the need
> to check for XLOG_TIC_INITED to determine if we should account for
> the space used by a start record.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks pretty straightforward,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 38 ++++++++++++--------------------------
>  1 file changed, 12 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index bf071552094a..116f59b16b04 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2349,39 +2349,27 @@ xlog_write(
>  	uint			flags)
>  {
>  	struct xlog_in_core	*iclog = NULL;
> -	struct xfs_log_iovec	*vecp;
> -	struct xfs_log_vec	*lv;
> +	struct xfs_log_vec	*lv = log_vector;
> +	struct xfs_log_iovec	*vecp = lv->lv_iovecp;
> +	int			index = 0;
>  	int			len;
> -	int			index;
>  	int			partial_copy = 0;
>  	int			partial_copy_len = 0;
>  	int			contwr = 0;
>  	int			record_cnt = 0;
>  	int			data_cnt = 0;
>  	int			error = 0;
> -	bool			need_start_rec = true;
> -
> -	*start_lsn = 0;
> -
> +	bool			need_start_rec;
>  
>  	/*
> -	 * Region headers and bytes are already accounted for.
> -	 * We only need to take into account start records and
> -	 * split regions in this function.
> +	 * If this is a commit or unmount transaction, we don't need a start
> +	 * record to be written. We do, however, have to account for the
> +	 * commit or unmount header that gets written. Hence we always have
> +	 * to account for an extra xlog_op_header here.
>  	 */
> -	if (ticket->t_flags & XLOG_TIC_INITED) {
> -		ticket->t_curr_res -= sizeof(struct xlog_op_header);
> +	ticket->t_curr_res -= sizeof(struct xlog_op_header);
> +	if (ticket->t_flags & XLOG_TIC_INITED)
>  		ticket->t_flags &= ~XLOG_TIC_INITED;
> -	}
> -
> -	/*
> -	 * Commit record headers need to be accounted for. These
> -	 * come in as separate writes so are easy to detect.
> -	 */
> -	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
> -		ticket->t_curr_res -= sizeof(struct xlog_op_header);
> -		need_start_rec = false;
> -	}
>  
>  	if (ticket->t_curr_res < 0) {
>  		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
> @@ -2390,11 +2378,9 @@ xlog_write(
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  	}
>  
> +	need_start_rec = !(flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS));
>  	len = xlog_write_calc_vec_length(ticket, log_vector, need_start_rec);
> -
> -	index = 0;
> -	lv = log_vector;
> -	vecp = lv->lv_iovecp;
> +	*start_lsn = 0;
>  	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
>  		void		*ptr;
>  		int		log_offset;
> -- 
> 2.25.1
> 
