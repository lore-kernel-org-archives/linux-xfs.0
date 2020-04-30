Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC07C4724C
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 119B92073E
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:56:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AeWgjp6/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgD3S46 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 14:56:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54550 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgD3S46 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 14:56:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UInQl3079620;
        Thu, 30 Apr 2020 18:56:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=MOf455vv4Mx7lIcfJgzmMmEFOLbdRznmwYAWkO8WLPM=;
 b=AeWgjp6/7BIMZ+kfP0koxN87Ur3vPTGe81l2tk7deB/9eQI8GN+aVVjb4Gr+qxyjiX/s
 RH5oBGECWh6dx2CEZeb1+c+AoBsbph7gWDtXdghVysugazCj2Hg7mEFPVHoVlz3vtcTA
 rTXQlvRj/4/3xVskKQq2qPBVAJ6S2BRzyCcATAu91idkcL7pAV7HDmOQ0bmka0d4C/NK
 ELstSKnCLsPrW7OrAsnSgYwOYtLzBEKltxGk2bBjnOyHPDAoNaw7T77Efzs+91nrQuW/
 U7gU50+z3AvVuEuGY60kk2MR9mm8Bd6CezY6OjmuWbOCq6kjoOFkOwo/FxlVsk5ssMFN Xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30p01p3tpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:56:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UIksgC112478;
        Thu, 30 Apr 2020 18:54:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30qtf88x9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:54:54 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UIsrRP018336;
        Thu, 30 Apr 2020 18:54:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 11:54:53 -0700
Date:   Thu, 30 Apr 2020 11:54:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 11/17] xfs: use delete helper for items expected to be
 in AIL
Message-ID: <20200430185452.GL6742@magnolia>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-12-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-12-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 phishscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=2 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:47PM -0400, Brian Foster wrote:
> Various intent log items call xfs_trans_ail_remove() with a log I/O
> error shutdown type, but this helper historically checks whether an
> item is in the AIL before calling xfs_trans_ail_delete(). This means
> the shutdown check is essentially a no-op for users of
> xfs_trans_ail_remove().
> 
> It is possible that some items might not be AIL resident when the
> AIL remove attempt occurs, but this should be isolated to cases
> where the filesystem has already shutdown. For example, this
> includes abort of the transaction committing the intent and I/O
> error of the iclog buffer committing the intent to the log.
> Therefore, update these callsites to use xfs_trans_ail_delete() to
> provide AIL state validation for the common path of items being
> released and removed when associated done items commit to the
> physical log.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Seems pretty straightforward
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_bmap_item.c     | 2 +-
>  fs/xfs/xfs_extfree_item.c  | 2 +-
>  fs/xfs/xfs_refcount_item.c | 2 +-
>  fs/xfs/xfs_rmap_item.c     | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index ee6f4229cebc..909221a4a8ab 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -51,7 +51,7 @@ xfs_bui_release(
>  {
>  	ASSERT(atomic_read(&buip->bui_refcount) > 0);
>  	if (atomic_dec_and_test(&buip->bui_refcount)) {
> -		xfs_trans_ail_remove(&buip->bui_item, SHUTDOWN_LOG_IO_ERROR);
> +		xfs_trans_ail_delete(&buip->bui_item, SHUTDOWN_LOG_IO_ERROR);
>  		xfs_bui_item_free(buip);
>  	}
>  }
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 6ea847f6e298..cd98eba24884 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -55,7 +55,7 @@ xfs_efi_release(
>  {
>  	ASSERT(atomic_read(&efip->efi_refcount) > 0);
>  	if (atomic_dec_and_test(&efip->efi_refcount)) {
> -		xfs_trans_ail_remove(&efip->efi_item, SHUTDOWN_LOG_IO_ERROR);
> +		xfs_trans_ail_delete(&efip->efi_item, SHUTDOWN_LOG_IO_ERROR);
>  		xfs_efi_item_free(efip);
>  	}
>  }
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 8eeed73928cd..712939a015a9 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -50,7 +50,7 @@ xfs_cui_release(
>  {
>  	ASSERT(atomic_read(&cuip->cui_refcount) > 0);
>  	if (atomic_dec_and_test(&cuip->cui_refcount)) {
> -		xfs_trans_ail_remove(&cuip->cui_item, SHUTDOWN_LOG_IO_ERROR);
> +		xfs_trans_ail_delete(&cuip->cui_item, SHUTDOWN_LOG_IO_ERROR);
>  		xfs_cui_item_free(cuip);
>  	}
>  }
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 4911b68f95dd..ff949b32c051 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -50,7 +50,7 @@ xfs_rui_release(
>  {
>  	ASSERT(atomic_read(&ruip->rui_refcount) > 0);
>  	if (atomic_dec_and_test(&ruip->rui_refcount)) {
> -		xfs_trans_ail_remove(&ruip->rui_item, SHUTDOWN_LOG_IO_ERROR);
> +		xfs_trans_ail_delete(&ruip->rui_item, SHUTDOWN_LOG_IO_ERROR);
>  		xfs_rui_item_free(ruip);
>  	}
>  }
> -- 
> 2.21.1
> 
