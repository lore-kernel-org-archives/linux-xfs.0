Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F88FC6196
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 22:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95F7E21882
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 22:24:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HdEvfN+R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbfKHWYi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 17:24:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55378 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727701AbfKHWYi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 17:24:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8MJOrZ032821;
        Fri, 8 Nov 2019 22:24:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=iy9oEniys5ZgNcDc4517TVsggbgfdtE1WvXA3bpVzEQ=;
 b=HdEvfN+ROvTYaoSmXHBcCrsHB5D819IQczPLyq1dapPovGBfIoYQmIuw7VoB1j+YsHsb
 sGQr5ULT1XJrjhC0VbMHXmJZ/i2J4yDlksU5lYOiR6WC6Bv008lyyAlwXnlW4d9A8bTd
 1gukZn/OQWBdMaM9/09xzT46yG1EqVqRNrRDHqToSBIAmGQ1beeKqGHYE/WzwfkSbhE4
 N9IQyH/kfFBRLEJ/yaE4dqR5ALOp7EVV+ahK9s5lgHzoD+bLDiLTDvZm6PNdbczr7TVw
 emOtffPBUBapF4RxfWulZDEl12+VVLON11bDuj/koYS73XNwsrUGzTzxjwqZQ/u1mrH6 ng== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w41w17ycf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 22:24:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8MOBZD142323;
        Fri, 8 Nov 2019 22:24:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w5bmqh2j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 22:24:19 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA8MOFjN030143;
        Fri, 8 Nov 2019 22:24:15 GMT
Received: from localhost (/10.159.140.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 14:24:15 -0800
Date:   Fri, 8 Nov 2019 14:24:14 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 3/4] xfs: remove the xfs_dq_logitem_t typedef
Message-ID: <20191108222414.GM6219@magnolia>
References: <20191108210612.423439-1-preichl@redhat.com>
 <20191108210612.423439-4-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108210612.423439-4-preichl@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080215
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080215
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 08, 2019 at 10:06:11PM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  fs/xfs/xfs_dquot.c      |  2 +-
>  fs/xfs/xfs_dquot.h      | 18 +++++++++---------
>  fs/xfs/xfs_dquot_item.h |  4 ++--
>  3 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 5b089afd7087..4df8ffb9906f 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1018,7 +1018,7 @@ xfs_qm_dqflush_done(
>  	struct xfs_buf		*bp,
>  	struct xfs_log_item	*lip)
>  {
> -	xfs_dq_logitem_t	*qip = (struct xfs_dq_logitem *)lip;
> +	struct xfs_dq_logitem	*qip = (struct xfs_dq_logitem *)lip;
>  	struct xfs_dquot	*dqp = qip->qli_dquot;
>  	struct xfs_ail		*ailp = lip->li_ailp;
>  
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index a6bb264d71ce..1defab19d550 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -39,15 +39,15 @@ struct xfs_dquot {
>  	int		  q_bufoffset;	/* off of dq in buffer (# dquots) */
>  	xfs_fileoff_t	  q_fileoffset;	/* offset in quotas file */
>  
> -	struct xfs_disk_dquot	q_core;	/* actual usage & quotas */
> -	xfs_dq_logitem_t  q_logitem;	/* dquot log item */
> -	xfs_qcnt_t	  q_res_bcount;	/* total regular nblks used+reserved */
> -	xfs_qcnt_t	  q_res_icount;	/* total inos allocd+reserved */
> -	xfs_qcnt_t	  q_res_rtbcount;/* total realtime blks used+reserved */
> -	xfs_qcnt_t	  q_prealloc_lo_wmark;/* prealloc throttle wmark */
> -	xfs_qcnt_t	  q_prealloc_hi_wmark;/* prealloc disabled wmark */
> -	int64_t		  q_low_space[XFS_QLOWSP_MAX];
> -	struct mutex	  q_qlock;	/* quota lock */
> +	struct xfs_disk_dquot	 q_core;	/* actual usage & quotas */
> +	struct xfs_dq_logitem	 q_logitem;	/* dquot log item */
> +	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
> +	xfs_qcnt_t	 q_res_icount;	/* total inos allocd+reserved */
> +	xfs_qcnt_t	 q_res_rtbcount;/* total realtime blks used+reserved */
> +	xfs_qcnt_t	 q_prealloc_lo_wmark;/* prealloc throttle wmark */
> +	xfs_qcnt_t	 q_prealloc_hi_wmark;/* prealloc disabled wmark */
> +	int64_t		 q_low_space[XFS_QLOWSP_MAX];
> +	struct mutex	 q_qlock;	/* quota lock */
>  	struct completion q_flush;	/* flush completion queue */

These look like they're more misaligned than the previous patch.

Please consider reformatting the structure from:

	some_type	some_variable; /* squashed comment */

into:

	/* not as squashed of a comment */
	some_type	some_variable;

Because that's a lot less cluttered, and it means that you can actually
make all the field names line up without having to worry about how much
that will screw up the comments.

--D

>  	atomic_t	  q_pincount;	/* dquot pin count */
>  	wait_queue_head_t q_pinwait;	/* dquot pinning wait queue */
> diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
> index 1aed34ccdabc..e0a24eb7a545 100644
> --- a/fs/xfs/xfs_dquot_item.h
> +++ b/fs/xfs/xfs_dquot_item.h
> @@ -11,11 +11,11 @@ struct xfs_trans;
>  struct xfs_mount;
>  struct xfs_qoff_logitem;
>  
> -typedef struct xfs_dq_logitem {
> +struct xfs_dq_logitem {
>  	struct xfs_log_item	 qli_item;	   /* common portion */
>  	struct xfs_dquot	*qli_dquot;	   /* dquot ptr */
>  	xfs_lsn_t		 qli_flush_lsn;	   /* lsn at last flush */
> -} xfs_dq_logitem_t;
> +};
>  
>  typedef struct xfs_qoff_logitem {
>  	struct xfs_log_item	 qql_item;	/* common portion */
> -- 
> 2.23.0
> 
