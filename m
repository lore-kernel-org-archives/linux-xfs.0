Return-Path: <SRS0=Z/aa=WP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F78C3A5A0
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 23:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6619E22CF7
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 23:10:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H02CKvvP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfHSXKi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Aug 2019 19:10:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42284 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728204AbfHSXKi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Aug 2019 19:10:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7JNA2Hl004022;
        Mon, 19 Aug 2019 23:10:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=VwXXPTi3PJu3WoEKqDUGPJTQ2J6rMB91D0vpSCDwdFM=;
 b=H02CKvvPw74ff4AzAmw4G8u8Lvj+tTzA++uIZsjhwJncfU0MjdDLpXWdpTC9a7ZVmlAa
 lsRTwvx4pRkA/IRPpQ33R9PMxe795MPlz4aB0KD3vmRKgyGjJePqcEJlxke/PfbVuHhB
 Ws6GO8j/dV7Nitni2hZV1S9KZlXUFyhviwgmPF/gniE6TD3T9iU41olCmfyQuhPwyDEs
 Iu43khsZeL96yxp7ML/+jLASRLG1yy+9c+fXoUT5sn8QFmwCzaE1ntRa7utbD8mYm4P1
 fxUPWoKFwqDOsy1gzylMcnZjWVNdR0OQ+UGlkHNnNrnW2Ot4mi2sEnbamVixNJd6F8aF pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ue90tahkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Aug 2019 23:10:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7JN8LBJ190722;
        Mon, 19 Aug 2019 23:10:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ug267wtmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Aug 2019 23:10:35 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7JNAZ7j018438;
        Mon, 19 Aug 2019 23:10:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Aug 2019 16:10:34 -0700
Date:   Mon, 19 Aug 2019 16:10:31 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     ira.weiny@intel.com
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/xfs: Fix return code of xfs_break_leased_layouts()
Message-ID: <20190819231031.GB1037350@magnolia>
References: <20190819213918.29371-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819213918.29371-1-ira.weiny@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908190228
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908190228
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 19, 2019 at 02:39:18PM -0700, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> The parens used in the while loop would result in error being assigned
> the value 1 rather than the intended errno value.
> 
> This is required to return -ETXTBSY from follow on break_layout()
> changes.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Doh.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_pnfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index 0c954cad7449..a339bd5fa260 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -32,7 +32,7 @@ xfs_break_leased_layouts(
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	int			error;
>  
> -	while ((error = break_layout(inode, false) == -EWOULDBLOCK)) {
> +	while ((error = break_layout(inode, false)) == -EWOULDBLOCK) {
>  		xfs_iunlock(ip, *iolock);
>  		*did_unlock = true;
>  		error = break_layout(inode, true);
> -- 
> 2.20.1
> 
