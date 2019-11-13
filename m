Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95EDCC43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 04:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66A61222D3
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 04:44:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CEvmx79w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfKMEoc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 23:44:32 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54460 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfKMEob (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 23:44:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD4iBbq183217;
        Wed, 13 Nov 2019 04:44:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=2ceE59qXxhnXPvlo8nPa0hXdHmR7lMbX2r+MhO6nGPw=;
 b=CEvmx79wWZYd+5ROGcQormi78YnAq/86HEm5Wsrfou4kxAH8T7eAd6ccRmUEjygfI4M5
 eSquiglUI+i8BB3e6vUhU1A4ZGbkd5vCXo7799xfsKaizqzUn0/dYQcb/Oqi7TtKfLad
 1+Hjhoo3em+d+PL1FVhA+8xnLcay07UhLAhRY0OjgfugUGsBgAlWaKwQAWOkvUdLmDuN
 ZTI+DYC/tSTj2mlMjMqLidxC18+OtbvREAdrvEt4ekb/qMf4JDA55mkdx/4kTV4w4Vp2
 Q/EtRSyZfmpFLIOxnSjTKJdEuOtyQRyZeQOCjQkdiimnGt4Mge+jd/zONIdzl9zk5s5s bQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w5mvtsmkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 04:44:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD4i2tn096146;
        Wed, 13 Nov 2019 04:44:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2w7khmm998-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 04:44:27 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAD4iRsQ021989;
        Wed, 13 Nov 2019 04:44:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 20:44:27 -0800
Date:   Tue, 12 Nov 2019 20:44:25 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 3/5] xfs: remove the xfs_dq_logitem_t typedef
Message-ID: <20191113044425.GN6219@magnolia>
References: <20191112213310.212925-1-preichl@redhat.com>
 <20191112213310.212925-4-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112213310.212925-4-preichl@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130041
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 10:33:08PM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_dquot.c      |  2 +-
>  fs/xfs/xfs_dquot.h      |  2 +-
>  fs/xfs/xfs_dquot_item.h | 10 +++++-----
>  3 files changed, 7 insertions(+), 7 deletions(-)
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
> index 831e4270cf65..fe3e46df604b 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -40,7 +40,7 @@ struct xfs_dquot {
>  	xfs_fileoff_t		q_fileoffset;
>  
>  	struct xfs_disk_dquot	q_core;
> -	xfs_dq_logitem_t	q_logitem;
> +	struct xfs_dq_logitem	q_logitem;
>  	/* total regular nblks used+reserved */
>  	xfs_qcnt_t		q_res_bcount;
>  	/* total inos allocd+reserved */
> diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
> index 1aed34ccdabc..3a64a7fd3b8a 100644
> --- a/fs/xfs/xfs_dquot_item.h
> +++ b/fs/xfs/xfs_dquot_item.h
> @@ -11,11 +11,11 @@ struct xfs_trans;
>  struct xfs_mount;
>  struct xfs_qoff_logitem;
>  
> -typedef struct xfs_dq_logitem {
> -	struct xfs_log_item	 qli_item;	   /* common portion */
> -	struct xfs_dquot	*qli_dquot;	   /* dquot ptr */
> -	xfs_lsn_t		 qli_flush_lsn;	   /* lsn at last flush */
> -} xfs_dq_logitem_t;
> +struct xfs_dq_logitem {
> +	struct xfs_log_item	 qli_item;	/* common portion */
> +	struct xfs_dquot	*qli_dquot;	/* dquot ptr */
> +	xfs_lsn_t		 qli_flush_lsn;	/* lsn at last flush */
> +};
>  
>  typedef struct xfs_qoff_logitem {
>  	struct xfs_log_item	 qql_item;	/* common portion */
> -- 
> 2.23.0
> 
