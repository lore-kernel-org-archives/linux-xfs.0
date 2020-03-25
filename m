Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48446C1975A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 04:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B66120719
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 04:42:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JgMwsOxj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbgCYEm4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 00:42:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40134 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgCYEm4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 00:42:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P4d8nY067072;
        Wed, 25 Mar 2020 04:42:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Ysalu/Hx6oJgbhKWlcumvWG4tDE0vYcCARIYg85djAI=;
 b=JgMwsOxjWjRZ1bs7X8R0MUwiIXRkmtleJNICBykF+cjjPZU+XMwaCF/EGGXJ3dBufprH
 uyNlcHj5OEdIRpBBHVZEZvSTUVWOakgSaR13WSAP34AoT91O1we7v0kCF8fDaoxM614m
 4n7E2hGKs9hueARZnRumNT5oIC+b7tOFk1pzMkLoU918a9mFZnOu4IrZUMycS2p63L6W
 CD9CfbwqT8b5E2xPHxB+fclVjrk3toEY9M5FVIQRaAgQR+lxNRd4uptZwMHuLSRs2Epf
 GAW8Zd3QLLYp6xUs4noeD+RumDUkUAgBGvm4Nnlm22HVyXVlHQTfKX9u7XwD74N+3fyh lQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ywavm7r7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 04:42:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P4SflC163652;
        Wed, 25 Mar 2020 04:42:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2yxw4qpnjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 04:42:53 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02P4gqKu013437;
        Wed, 25 Mar 2020 04:42:52 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 21:42:52 -0700
Subject: Re: [PATCH 4/8] xfs: Improve metadata buffer reclaim accountability
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20200325014205.11843-1-david@fromorbit.com>
 <20200325014205.11843-5-david@fromorbit.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <874e94af-446b-9163-3b40-74b68cff32f8@oracle.com>
Date:   Tue, 24 Mar 2020 21:42:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200325014205.11843-5-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=2
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250038
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 suspectscore=2 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003250038
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/24/20 6:42 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The buffer cache shrinker frees more than just the xfs_buf slab
> objects - it also frees the pages attached to the buffers. Make sure
> the memory reclaim code accounts for this memory being freed
> correctly, similar to how the inode shrinker accounts for pages
> freed from the page cache due to mapping invalidation.
> 
> We also need to make sure that the mm subsystem knows these are
> reclaimable objects. We provide the memory reclaim subsystem with a
> a shrinker to reclaim xfs_bufs, so we should really mark the slab
> that way.
> 
> We also have a lot of xfs_bufs in a busy system, spread them around
> like we do inodes.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok, makes sense
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_buf.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f880141a22681..9ec3eaf1c618f 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -327,6 +327,9 @@ xfs_buf_free(
>   
>   			__free_page(page);
>   		}
> +		if (current->reclaim_state)
> +			current->reclaim_state->reclaimed_slab +=
> +							bp->b_page_count;
>   	} else if (bp->b_flags & _XBF_KMEM)
>   		kmem_free(bp->b_addr);
>   	_xfs_buf_free_pages(bp);
> @@ -2114,9 +2117,11 @@ xfs_buf_delwri_pushbuf(
>   int __init
>   xfs_buf_init(void)
>   {
> -	xfs_buf_zone = kmem_cache_create("xfs_buf",
> -					 sizeof(struct xfs_buf), 0,
> -					 SLAB_HWCACHE_ALIGN, NULL);
> +	xfs_buf_zone = kmem_cache_create("xfs_buf", sizeof(struct xfs_buf), 0,
> +					 SLAB_HWCACHE_ALIGN |
> +					 SLAB_RECLAIM_ACCOUNT |
> +					 SLAB_MEM_SPREAD,
> +					 NULL);
>   	if (!xfs_buf_zone)
>   		goto out;
>   
> 
