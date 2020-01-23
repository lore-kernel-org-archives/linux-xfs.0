Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9612AC2D0DB
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 16:36:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67D2A21D7D
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 16:36:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fBeab9se"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbgAWQgT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 11:36:19 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53162 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbgAWQgS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 11:36:18 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00NGaHqE006310
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2020 16:36:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=QNE2IecM086Fkla/Id48ISwOJvpDAVomiDtgtn/yALU=;
 b=fBeab9seFQewbnwtpMgi07GULAEyIxxAgrqlTAoWp1ZC2eK/X9bKO2mCLzubq5HhaEV1
 I1cgjvt3P0iMU78FgUOfn2t2Bb/XcTWCB8jRNJIYuSP5I3CKcwnA7Aq4DDs6NXyHxuOd
 kYBZG6H+5ctvo4BXiFGdd0xEMQWtB7xV0DTwwLxktel2acVV2zm4FJiaazWM1Kiv1YDN
 wQkU8aOxmkG0i991DWv5qNrfAZDSkavYfoz8SUi4Rp8+CP5nH70FSrIkR+4rFkJ+9scP
 ROneX2hcxknTEYV/3jFFDn9sbMwgN1fk1juHUy3NfbaVbStZWufPI04OKj3GaRvLfIUg Ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xksyqkfcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2020 16:36:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00NGJ4wI085014
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2020 16:36:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xpt6ppqaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2020 16:36:13 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00NGaDD6032353
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2020 16:36:13 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 08:36:12 -0800
Subject: Re: [PATCH] xfs: fix uninitialized variable in
 xfs_attr3_leaf_inactive
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>
References: <20200123155552.GV8247@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <8184448c-4328-9b4d-95ae-8108a4b3de2e@oracle.com>
Date:   Thu, 23 Jan 2020 09:36:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200123155552.GV8247@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001230131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001230131
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/23/20 8:55 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Dan Carpenter pointed out that error is uninitialized.  While there
> never should be an attr leaf block with zero entries, let's not leave
> that logic bomb there.
> 
Looks fine to me.
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/xfs_attr_inactive.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index eddd5d311b0c..bbfa6ba84dcd 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -89,7 +89,7 @@ xfs_attr3_leaf_inactive(
>   	struct xfs_attr_leafblock	*leaf = bp->b_addr;
>   	struct xfs_attr_leaf_entry	*entry;
>   	struct xfs_attr_leaf_name_remote *name_rmt;
> -	int				error;
> +	int				error = 0;
>   	int				i;
>   
>   	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
> 
