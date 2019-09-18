Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E3B8C4CEC4
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 20:46:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BC48207FC
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 20:46:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SVEakDOy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387458AbfIRUqs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 16:46:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37074 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbfIRUqr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 16:46:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IKhxtb056372;
        Wed, 18 Sep 2019 20:46:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Sw52EbD4wBCl5z4oNnl8gDsYjKWLym6moMxRO/IdWIc=;
 b=SVEakDOyohrYgeC44LA4Mw9rXQ0gzn5o0y7pvRzWvIzuHugJvAHAptGOphsjF7BUNs3E
 TxtyaY007b4KPLOCvbIpOYD1spGo+rmvMja8gF/7kQIk2OIUnYnkztAbG1MDkXNPQ0Rr
 l38UswMgAv8j3GgFQlnhw46qrI9njD55ON9XAt8mKf6PMq7w2dWqFWychS4TXQuWAwbo
 Pjo9jWf3vGH4YHpcxCeaiHU5FbqpAFz5X5V/nzoRWDFgC2Tio6PhXwBITNoa0UbYUG0L
 4qRmwP6zn8DXmtf+wHQMVMmuBZXhsdeyq2GjTdX35WqFubLQvROhVWZe0w9y5deeWJqy nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2v385dxde3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 20:46:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IKiH4F157633;
        Wed, 18 Sep 2019 20:44:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2v37ma9esp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 20:44:35 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8IKiX60030473;
        Wed, 18 Sep 2019 20:44:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 13:44:33 -0700
Date:   Wed, 18 Sep 2019 13:44:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 07/11] xfs: refactor allocation tree fixup code
Message-ID: <20190918204432.GW2229799@magnolia>
References: <20190916121635.43148-1-bfoster@redhat.com>
 <20190916121635.43148-8-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916121635.43148-8-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180178
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 08:16:31AM -0400, Brian Foster wrote:
> Both algorithms duplicate the same btree allocation code. Eliminate
> the duplication and reuse the fallback algorithm codepath.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 18 ++----------------
>  1 file changed, 2 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index edcec975c306..3eacc799c4cb 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1333,23 +1333,8 @@ xfs_alloc_ag_vextent_near(
>  		if (acur.len == 0)
>  			break;
>  
> -		/*
> -		 * Allocate at the bno/len tracked in the cursor.
> -		 */
> -		args->agbno = acur.bno;
> -		args->len = acur.len;
> -		ASSERT(acur.bno >= acur.rec_bno);
> -		ASSERT(acur.bno + acur.len <= acur.rec_bno + acur.rec_len);
> -		ASSERT(acur.rec_bno + acur.rec_len <=
> -		       be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
> -
> -		error = xfs_alloc_fixup_trees(acur.cnt, acur.bnolt,
> -				acur.rec_bno, acur.rec_len, acur.bno, acur.len,
> -				0);
> -		if (error)
> -			goto out;
>  		trace_xfs_alloc_near_first(args);
> -		goto out;
> +		goto alloc;
>  	}
>  
>  	/*
> @@ -1434,6 +1419,7 @@ xfs_alloc_ag_vextent_near(
>  		goto out;
>  	}
>  
> +alloc:
>  	args->agbno = acur.bno;
>  	args->len = acur.len;
>  	ASSERT(acur.bno >= acur.rec_bno);
> -- 
> 2.20.1
> 
