Return-Path: <SRS0=0zz6=4T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D2AC3F2D1
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 18:12:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4005524676
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 18:12:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bwp5Wa94"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgCBSMB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 13:12:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54818 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgCBSMB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Mar 2020 13:12:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 022HrlNM163545
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 18:12:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=iYqefQgcioL6nUJzvnkC2v/4vYC5+CiQS6i8YUHwHsM=;
 b=bwp5Wa94eSdK0xGxPoJyIw59Qh7F4T8bsQd//+aSxjp9oejguHkSwIbTNJTgAiUseLP4
 o2d8dFU1Tp3MCP5bg+/gYvH4q+S22CekBgwYhEL4OyWd++aDOr071EKSLTQyhuwAxCUb
 AOjX+Dct9QsPL3mnh84K5GVk45X3iHXW2ts2TuNoGTxwHW1oVupFUXWbx2oluEJEpU+D
 9fYguRL27GWAxYk3yCHYNTmeixWqzm/PZA57zvHVJ4GzbD+xBTH/QMiRlTlt9KdT0i2K
 tMuPKqHGNh4b35cEw47vl+g/sZTtaXqi0KMYsSC3/zfUphliOBOwjm8TmRwsMslWqnxf uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2yffcu9gvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 02 Mar 2020 18:12:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 022Hqd8d064054
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 18:11:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2yg1rg435b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 02 Mar 2020 18:11:59 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 022IBwGx004136
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 18:11:58 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Mar 2020 10:11:50 -0800
Subject: Re: [PATCH 1/4] xfs: fix buffer state when we reject a corrupt dir
 free block
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <158294091582.1729975.287494493433729349.stgit@magnolia>
 <158294092192.1729975.12710230360219661807.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <e77cf699-8890-5a13-3f34-c8506dc29e98@oracle.com>
Date:   Mon, 2 Mar 2020 11:11:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <158294092192.1729975.12710230360219661807.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9548 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=984
 suspectscore=2 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9548 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 adultscore=0 suspectscore=2 spamscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003020118
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/28/20 6:48 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix two problems in the dir3 free block read routine when we want to
> reject a corrupt free block.  First, buffers should never have DONE set
> at the same time that b_error is EFSCORRUPTED.  Second, don't leak a
> pointer back to the caller.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Looks good:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_dir2_node.c |    2 ++
>   1 file changed, 2 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index a0cc5e240306..f622ede7119e 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -227,7 +227,9 @@ __xfs_dir3_free_read(
>   	fa = xfs_dir3_free_header_check(dp, fbno, *bpp);
>   	if (fa) {
>   		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
> +		(*bpp)->b_flags &= ~XBF_DONE;
>   		xfs_trans_brelse(tp, *bpp);
> +		*bpp = NULL;
>   		return -EFSCORRUPTED;
>   	}
>   
> 
