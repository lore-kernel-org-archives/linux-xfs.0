Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C99C47247
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 23:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B29E206FA
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 23:17:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WuEPQ3x7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgEEXRq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 19:17:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57470 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728642AbgEEXRq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 19:17:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045NHhoI189748;
        Tue, 5 May 2020 23:17:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=W0SA5D9OWc4IzbPyMyd/uEEErHqIuPaSfPclCdEDFAU=;
 b=WuEPQ3x7F9wc7Fe3rQVprOcedO+AzEJSZ47tMNsP17cQBYIruvjCsp4PGw84qoZuzhFH
 5GjzJ3OuIrFiqr2MJsp4OP8FvcQ8TBqifw4+nFObi6DaPDrr4QwBAvMAPJ5kGYIG7tNw
 Wf1eT9sW4Rle6/AZ9ve/2fzkblReF6cO59UJ96Brzbhz9GgxmJfX4RPbzyDUgYA9LX34
 TznBhb1KlHUPnWUlx3IE2ynCXaGgB+Q9ff0C+ac1NOyyGHmXqNUN2SYIAvya+sgSDobF
 cfbVDcipPZ5+QQDssenkvyGJN9VCZOW4v/ZGlir0nczONaR2PWOg16BDOVIaNYu9lImK ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30s09r7hgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 23:17:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045NHQgI119673;
        Tue, 5 May 2020 23:17:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30sjng4ggg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 23:17:36 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 045NHY49021550;
        Tue, 5 May 2020 23:17:35 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 16:17:34 -0700
Subject: Re: [PATCH v4 11/17] xfs: use delete helper for items expected to be
 in AIL
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200504141154.55887-1-bfoster@redhat.com>
 <20200504141154.55887-12-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <bc0ac716-2989-0580-4caa-0ed68556a404@oracle.com>
Date:   Tue, 5 May 2020 16:17:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504141154.55887-12-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=2
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 7:11 AM, Brian Foster wrote:
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
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Looks OK:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_bmap_item.c     | 2 +-
>   fs/xfs/xfs_extfree_item.c  | 2 +-
>   fs/xfs/xfs_refcount_item.c | 2 +-
>   fs/xfs/xfs_rmap_item.c     | 2 +-
>   4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index ee6f4229cebc..909221a4a8ab 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -51,7 +51,7 @@ xfs_bui_release(
>   {
>   	ASSERT(atomic_read(&buip->bui_refcount) > 0);
>   	if (atomic_dec_and_test(&buip->bui_refcount)) {
> -		xfs_trans_ail_remove(&buip->bui_item, SHUTDOWN_LOG_IO_ERROR);
> +		xfs_trans_ail_delete(&buip->bui_item, SHUTDOWN_LOG_IO_ERROR);
>   		xfs_bui_item_free(buip);
>   	}
>   }
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 6ea847f6e298..cd98eba24884 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -55,7 +55,7 @@ xfs_efi_release(
>   {
>   	ASSERT(atomic_read(&efip->efi_refcount) > 0);
>   	if (atomic_dec_and_test(&efip->efi_refcount)) {
> -		xfs_trans_ail_remove(&efip->efi_item, SHUTDOWN_LOG_IO_ERROR);
> +		xfs_trans_ail_delete(&efip->efi_item, SHUTDOWN_LOG_IO_ERROR);
>   		xfs_efi_item_free(efip);
>   	}
>   }
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 8eeed73928cd..712939a015a9 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -50,7 +50,7 @@ xfs_cui_release(
>   {
>   	ASSERT(atomic_read(&cuip->cui_refcount) > 0);
>   	if (atomic_dec_and_test(&cuip->cui_refcount)) {
> -		xfs_trans_ail_remove(&cuip->cui_item, SHUTDOWN_LOG_IO_ERROR);
> +		xfs_trans_ail_delete(&cuip->cui_item, SHUTDOWN_LOG_IO_ERROR);
>   		xfs_cui_item_free(cuip);
>   	}
>   }
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 4911b68f95dd..ff949b32c051 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -50,7 +50,7 @@ xfs_rui_release(
>   {
>   	ASSERT(atomic_read(&ruip->rui_refcount) > 0);
>   	if (atomic_dec_and_test(&ruip->rui_refcount)) {
> -		xfs_trans_ail_remove(&ruip->rui_item, SHUTDOWN_LOG_IO_ERROR);
> +		xfs_trans_ail_delete(&ruip->rui_item, SHUTDOWN_LOG_IO_ERROR);
>   		xfs_rui_item_free(ruip);
>   	}
>   }
> 
