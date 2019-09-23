Return-Path: <SRS0=UWJz=XS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CFBDC432C2
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 23:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FC2721D56
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 23:49:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UArRlufB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408395AbfIWXto (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Sep 2019 19:49:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36476 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729276AbfIWXtn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Sep 2019 19:49:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8NNnPTQ189533;
        Mon, 23 Sep 2019 23:49:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=FYMY+cI/PmsZwvLs45dVg/QKZsWiR7u/XOxkr4eSaWs=;
 b=UArRlufBGyHdZjB/Zr4wQ1681xyRt1qAlylyxWzZmcaEpFTXSkPO3JIn2+bP2tMfqh0k
 PnJ2pWAfiKQzbveWBeG+0cR8SH7ktGRMDBN0T3+q+ciXfdTr7dVR9nCkWF3Q2vRIX4vB
 SzPls98aJTSrZmQyraeyQ/4ZO0VNq8JwsqWbvDFKXhlVBSVDI8EnnGL0urrd3NF1JJG4
 tMMbs2AmrRuTfWh1yv7qKU6smxRmsRCshQA6k9esr4sYB3DnXtlRL7STveRhOMRDCSLo
 cCM8n4WrlYWdYZn1fisJlZXKLxvoTpFBfsSAYn9ySTUyi8nbshy/jsd+jL6ndILRc4RC /A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2v5b9tj6ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Sep 2019 23:49:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8NNnIW6071745;
        Mon, 23 Sep 2019 23:49:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2v6yvnw2b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Sep 2019 23:49:22 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8NNmh4G008872;
        Mon, 23 Sep 2019 23:48:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Sep 2019 16:48:43 -0700
Date:   Mon, 23 Sep 2019 16:48:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Aliasgar Surti <aliasgar.surti500@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH] fs:xfs:scrub: Removed unneeded variable.
Message-ID: <20190923234842.GV2229799@magnolia>
References: <1568985464-31258-1-git-send-email-aliasgar.surti500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568985464-31258-1-git-send-email-aliasgar.surti500@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909230204
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909230204
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 20, 2019 at 06:47:44PM +0530, Aliasgar Surti wrote:
> From: Aliasgar Surti <aliasgar.surti500@gmail.com>
> 
> Returned value directly instead of using variable as it wasn't updated.
> 
> Signed-off-by: Aliasgar Surti <aliasgar.surti500@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/scrub/alloc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
> index a43d181..5533e48 100644
> --- a/fs/xfs/scrub/alloc.c
> +++ b/fs/xfs/scrub/alloc.c
> @@ -97,7 +97,6 @@ xchk_allocbt_rec(
>  	xfs_agnumber_t		agno = bs->cur->bc_private.a.agno;
>  	xfs_agblock_t		bno;
>  	xfs_extlen_t		len;
> -	int			error = 0;
>  
>  	bno = be32_to_cpu(rec->alloc.ar_startblock);
>  	len = be32_to_cpu(rec->alloc.ar_blockcount);
> @@ -109,7 +108,7 @@ xchk_allocbt_rec(
>  
>  	xchk_allocbt_xref(bs->sc, bno, len);
>  
> -	return error;
> +	return 0;
>  }
>  
>  /* Scrub the freespace btrees for some AG. */
> -- 
> 2.7.4
> 
