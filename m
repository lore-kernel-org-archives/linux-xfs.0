Return-Path: <SRS0=kies=2K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09794C43603
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Dec 2019 16:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4994206D3
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Dec 2019 16:30:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AxT8sxi3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfLTQaY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Dec 2019 11:30:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48768 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfLTQaY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Dec 2019 11:30:24 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBKGTEW4049185;
        Fri, 20 Dec 2019 16:30:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=8W2cnKxQ5bWF4ipRvYriBMOXbRYSX9ZJzo29FO6rc+4=;
 b=AxT8sxi3eMc7BE2ezG0z0NVEHbKsgFPgRjOakkQ86FveHFWOSu7ZRZZLb8YMw2AKQewL
 4s809lai90ZraXSCzMli4BVafIvsXOh3G0A0ElrMpPziB8PdHOJeQQ7aWvfp1YTafkEf
 QkJBGYSRF6xenw1IGo25wUO5wta423VgpdqnPijDZybSBkjnmQwRMgu7E0/raerMdYZo
 omGDMEWMUk9+w6XNfENK6rKqugzZNLTwYNF5hbkKyJOO83tsdXAaidaR7S1q8xihllSq
 QlC7sFlCcfRSjaeZFIhXAexxhWvlkwfPA9ra5qClQt9wGb0qfXMUKiPj25vMIiXnsWgn 2g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x01knsq75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Dec 2019 16:30:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBKGT8wU158468;
        Fri, 20 Dec 2019 16:30:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2x0bgnt4tp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Dec 2019 16:30:09 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBKGU5cC007636;
        Fri, 20 Dec 2019 16:30:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 20 Dec 2019 08:30:04 -0800
Date:   Fri, 20 Dec 2019 08:30:03 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chen Wandun <chenwandun@huawei.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, dchinner@redhat.com,
        preichl@redhat.com, sandeen@sandeen.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] xfs: Make the symbol 'xfs_rtalloc_log_count' static
Message-ID: <20191220163003.GP7489@magnolia>
References: <20191220095157.42619-1-chenwandun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220095157.42619-1-chenwandun@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9477 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912200127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9477 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912200127
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 20, 2019 at 05:51:57PM +0800, Chen Wandun wrote:
> Fix the following sparse warning:
> 
> fs/xfs/libxfs/xfs_trans_resv.c:206:1: warning: symbol 'xfs_rtalloc_log_count' was not declared. Should it be static?
> 
> Fixes: b1de6fc7520f ("xfs: fix log reservation overflows when allocating large rt extents")
> Signed-off-by: Chen Wandun <chenwandun@huawei.com>

Urk, oops, good catch!

Especially since the for-next announcement message got totally eaten by
$employer MTA or something. :/

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_trans_resv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 824073a839ac..7a9c04920505 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -202,7 +202,7 @@ xfs_calc_inode_chunk_res(
>   * blocks as needed to mark inuse MAXEXTLEN blocks' worth of realtime extents,
>   * as well as the realtime summary block.
>   */
> -unsigned int
> +static unsigned int
>  xfs_rtalloc_log_count(
>  	struct xfs_mount	*mp,
>  	unsigned int		num_ops)
> -- 
> 2.17.1
> 
