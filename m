Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C3EC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E32BB21D6C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:20:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZWcK6RjL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfKHAUY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 19:20:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50444 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfKHAUY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 19:20:24 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80Ik55144671;
        Fri, 8 Nov 2019 00:20:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=WUhLwAru6HUKxQsyiwenbrC5ZwuTasUCzHLkeF17pI4=;
 b=ZWcK6RjLOP7ujFWSrnZGaiE6RSQ7yyf9kpmslgnNY2DNP2oz4ZKcMUbofPZSLRngFUzU
 7T413X/zVsZgXgaNJewrnNRaLwctla2MejH7rHreq5IA0lHUuPvux+rmdz6qkUvgo+yD
 KtEhTs0bB5vjqE3yMYczHPdQxgxyzkGYqFehj7ZhPLnZMlDJ3FY8PXV6haIInQhx5wfg
 wVD1s3ooDINpkKUEXbkwc2eCxoE44FhSdaHxKEZWYyGdlpYgleyjkMofsz/t4E7qKO2L
 yFCvH1NIWP2i9KofaIfS1BNt4e/+XaB92DV6deyALa452LdX2hl1E1HE97eeFRDPF/h9 pQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w41w11tc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:20:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80IwM6081408;
        Fri, 8 Nov 2019 00:20:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2w41wg80bg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:20:10 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA80K9W8012527;
        Fri, 8 Nov 2019 00:20:09 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 16:20:09 -0800
Date:   Thu, 7 Nov 2019 16:20:09 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: remove the xfs_dq_logitem_t typedef
Message-ID: <20191108002009.GP6219@magnolia>
References: <20191107113549.110129-1-preichl@redhat.com>
 <20191107113549.110129-5-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107113549.110129-5-preichl@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080002
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 12:35:48PM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_dquot.c      | 2 +-
>  fs/xfs/xfs_dquot.h      | 4 ++--
>  fs/xfs/xfs_dquot_item.h | 4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 04e38ed97f5f..209d5e4b5850 100644
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
> index 330ba888e74a..f1e7cc6a383f 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -39,8 +39,8 @@ struct xfs_dquot {
>  	int		 q_bufoffset;	/* off of dq in buffer (# dquots) */
>  	xfs_fileoff_t	 q_fileoffset;	/* offset in quotas file */
>  
> -	struct xfs_disk_dquot	q_core;	/* actual usage & quotas */
> -	xfs_dq_logitem_t q_logitem;	/* dquot log item */
> +	struct xfs_disk_dquot	 q_core;	/* actual usage & quotas */
> +	struct xfs_dq_logitem	 q_logitem;	/* dquot log item */
>  	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
>  	xfs_qcnt_t	 q_res_icount;	/* total inos allocd+reserved */
>  	xfs_qcnt_t	 q_res_rtbcount;/* total realtime blks used+reserved */
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
