Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E5B0C3A59F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 00:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29A4F21874
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 00:34:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YXj4I/iI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfH3AeA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 20:34:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41072 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfH3AeA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 20:34:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7U0U9t2126583;
        Fri, 30 Aug 2019 00:33:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=peeKM1ZM4illxoV1l9T+KakYxnOpu8XIl+nhtItwNF0=;
 b=YXj4I/iIiqPsQSOP+C1wTnp5UpTLyJiVsBx8iQq4YZSfFvtVuQX5fws4r7hj9zUQw1jG
 x5Y99MfZmNCibMsNpCsjWDiio6HnfWR1FNN4D7gKFdrdvZzm8Hnc3xS94cdb50V5nsZ5
 b84kNFJIpMPzRV3BsEnLV+L3HD0ZFe0QtK+VN5BQoPBm7a9anzwlNZBcfh2sruLoXfaq
 9P50WS7OTvw8PUM+dPBR6DyVOc7DizQAgjw0I8E3xhV6SpTV/vNgj9hDvSIN0gSAAymP
 EjmRjkFrswiiQkKQKsMFjMaXVInijdaYzyexXGgPc49UQqRVtYIEwHLsvktNMF8DEb/C 6w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2upsac80hf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 00:33:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7U0X4SC051829;
        Fri, 30 Aug 2019 00:33:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2upc8vf0mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 00:33:57 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7U0XudM009579;
        Fri, 30 Aug 2019 00:33:57 GMT
Received: from localhost (/10.145.178.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 17:33:56 -0700
Date:   Thu, 29 Aug 2019 17:33:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Austin Kim <austindh.kim@gmail.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Use WARN_ON_ONCE rather than BUG for bailout
 mount-operation
Message-ID: <20190830003356.GW5354@magnolia>
References: <20190830003022.GA152970@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830003022.GA152970@LGEARND20B15>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300002
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 09:30:22AM +0900, Austin Kim wrote:
> If the CONFIG_BUG is enabled, BUG is executed and then system is crashed.
> However, the bailout for mount is no longer proceeding.
> 
> For this reason, using WARN_ON_ONCE rather than BUG can prevent this situation.
> 
> Signed-off-by: Austin Kim <austindh.kim@gmail.com>
> ---
>  fs/xfs/xfs_mount.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 322da69..c0d0b72 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -213,8 +213,7 @@ xfs_initialize_perag(
>  			goto out_hash_destroy;
>  
>  		spin_lock(&mp->m_perag_lock);
> -		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
> -			BUG();
> +		if (WARN_ON_ONCE(radix_tree_insert(&mp->m_perag_tree, index, pag))) {

Er... please wrap the line at 80 columns.

--D

>  			spin_unlock(&mp->m_perag_lock);
>  			radix_tree_preload_end();
>  			error = -EEXIST;
> -- 
> 2.6.2
> 
