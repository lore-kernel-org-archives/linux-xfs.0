Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D719C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 21:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A05322CEA
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 21:32:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ny3gqUKx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfH2VcI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 17:32:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36618 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbfH2VcI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 17:32:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLOCbw165604;
        Thu, 29 Aug 2019 21:31:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=meD1AJcjB58HSh5RiddbdpzMipNjFGRy49OPDOO89vk=;
 b=Ny3gqUKx1+mTUnu338pmlZELa9kXF+GvScLG/6j3UqY3HeFnT/K3kJJ5RAV5CDw5OaR1
 etvPJYWrgwK0oVU9/MlfUHHD+QpD3K+XiphAoGQvY00fFIIrutN66r9ZImAl6ur+LCsY
 FwMEV6S+UhTgoJM/QRL5jnouRhRZU0wqCK0RF/MCmWo3KwJXBSRpqQA20iqJ8pQqXmjA
 igqZ/JGPuCsnptfoXI+NYXNFP/j/y6K7s4RifTB27h7DR0YcvK1Cdso2uDQf6BVohrHA
 ZFjklM19CsWLeCFt69qyAQKvvNstHLsby5aRL5vxIGm8EkTpaR92ClPVd8KtB/GFrRk5 sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2uppjc01s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:31:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLTAao053713;
        Thu, 29 Aug 2019 21:31:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2unvu0mmy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:31:51 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TLVpQP031255;
        Thu, 29 Aug 2019 21:31:51 GMT
Received: from localhost (/10.145.178.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 14:31:51 -0700
Date:   Thu, 29 Aug 2019 14:31:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: log proper length of btree block in scrub/repair
Message-ID: <20190829213150.GS5354@magnolia>
References: <f66b01bb-b4ce-8713-c3db-fbbd39703737@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f66b01bb-b4ce-8713-c3db-fbbd39703737@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290215
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290215
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 27, 2019 at 02:17:36PM -0500, Eric Sandeen wrote:
> xfs_trans_log_buf() takes a final argument of the last byte to
> log in the buffer; b_length is in basic blocks, so this isn't
> the correct last byte.  Fix it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> just found by inspection/pattern matching, not tested TBH...
> 
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 4cfeec57fb05..7bcc755beb40 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -351,7 +351,7 @@ xrep_init_btblock(
>  	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
>  	xfs_btree_init_block(mp, bp, btnum, 0, 0, sc->sa.agno);
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_BTREE_BUF);
> -	xfs_trans_log_buf(tp, bp, 0, bp->b_length);
> +	xfs_trans_log_buf(tp, bp, 0, BBTOB(bp->b_length) - 1);
>  	bp->b_ops = ops;
>  	*bpp = bp;
>  
> 
