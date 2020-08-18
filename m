Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE102C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C37212065D
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:48:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oQx31Vhe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgHRWsX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:48:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36796 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbgHRWsW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 18:48:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMGGvL135026;
        Tue, 18 Aug 2020 22:48:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=OGAskjtyD332sg7snfZnpTzd3jVB8WXD6c8Yide51Zo=;
 b=oQx31Vhe7qkLLSrN+/ByOMoZ9IbQNxITwb2n99X0vqD3vmDoTYMRGrkJE+BYpC2E1bRf
 PmYLG/mqrW+QBaaEqNBLxSlvo9M+wUMyYDHoJ+rTz8Mf2l/3NPSLfgDdiLNLkFdj5NbX
 PT7f3+yibNRElmCjtX48waD8BZYztHahIhL72SAz0cRlftHbrW30f5ZFwY4eisn97czv
 MeAO+G57Qi/u9x08xbn8kcgCd+b87Zg+cmsl21R9MsaTQDaIaFbogg4GR1tBClP4wZA0
 TNZkenuPjDFxS+93FRGYOF4Gn2yFDSJo65XmzzlkP6CNDZwWiUAgbBdnD18cSvrij5tb sA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32x74r7nsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 22:48:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMHkMo056263;
        Tue, 18 Aug 2020 22:48:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 330pvhmq5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 22:48:18 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07IMmHG8030980;
        Tue, 18 Aug 2020 22:48:17 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 15:48:17 -0700
Date:   Tue, 18 Aug 2020 15:48:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/13] xfs: lift the XBF_IOEND_FAIL handling into
 xfs_buf_ioend_disposition
Message-ID: <20200818224815.GI6096@magnolia>
References: <20200709150453.109230-1-hch@lst.de>
 <20200709150453.109230-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709150453.109230-9-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=1 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180160
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 05:04:48PM +0200, Christoph Hellwig wrote:
> Keep all the error handling code together.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index e5592563dda6a1..e3e80615c5ed9e 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1285,6 +1285,14 @@ xfs_buf_ioend_disposition(
>  	}
>  
>  	/* Still considered a transient error. Caller will schedule retries. */
> +	if (bp->b_flags & _XBF_INODES)
> +		xfs_buf_inode_io_fail(bp);
> +	else if (bp->b_flags & _XBF_DQUOTS)
> +		xfs_buf_dquot_io_fail(bp);
> +	else
> +		ASSERT(list_empty(&bp->b_li_list));
> +	xfs_buf_ioerror(bp, 0);
> +	xfs_buf_relse(bp);
>  	return XBF_IOEND_FAIL;

Hm.  I was about to whine about turning a "decide the outcome" function
into a "decide the outcome and do some of it" function, but I guess the
advantage of lazy reviewing is that I can skip to the last patch and see
that this all gets swallowed into xfs_buf_ioend_handle_error, doesn't it?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  
>  resubmit:
> @@ -1338,14 +1346,6 @@ xfs_buf_ioend(
>  		case XBF_IOEND_DONE:
>  			return;
>  		case XBF_IOEND_FAIL:
> -			if (bp->b_flags & _XBF_INODES)
> -				xfs_buf_inode_io_fail(bp);
> -			else if (bp->b_flags & _XBF_DQUOTS)
> -				xfs_buf_dquot_io_fail(bp);
> -			else
> -				ASSERT(list_empty(&bp->b_li_list));
> -			xfs_buf_ioerror(bp, 0);
> -			xfs_buf_relse(bp);
>  			return;
>  		default:
>  			break;
> -- 
> 2.26.2
> 
