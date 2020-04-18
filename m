Return-Path: <SRS0=FK3z=6C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9195FC2BB1D
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Apr 2020 00:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 670F320857
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Apr 2020 00:27:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZituiU4v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgDRA17 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Apr 2020 20:27:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52934 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgDRA16 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Apr 2020 20:27:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03I0Nvj6070987;
        Sat, 18 Apr 2020 00:27:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GG6qiduq9Ds2XKXo03KvE9Ga7tX1FxPYVYsowp9zXfw=;
 b=ZituiU4vUdi+BQlgmBg3yJgRJjZrVs21U7o1wIIFkalaBOAVZ30Fkmv1EmQki0r71HJ6
 WSAz2n1xBz6caImkBNZfuwxKPUwxYoJFnM0yMFdOXWVTQGg1cYCVdOte3TEk+mLUIUc3
 evCycgxp5tewe+fTJKSeXH7eBNLi3MXzBjzM47EanmKVi9SatWW8TeCY2WzeXod/aVVn
 be6kKqGx/lv48kCbp1VsiB4u/XNoMyJl1wvsI27ly6Y32mSJJQlty5vurLgjp1J/NhRC
 ehVe3Gu7i84hnJ5wKCq1msSXAwfLI1d/NN6pKRl4ddgsGxkQgIwxxDv+1UBbvYHwgVxR 8Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30e0aafab8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Apr 2020 00:27:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03I0MSlG067309;
        Sat, 18 Apr 2020 00:27:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30dn9mj3p1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Apr 2020 00:27:54 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03I0Rsei025433;
        Sat, 18 Apr 2020 00:27:54 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 17:27:54 -0700
Subject: Re: [PATCH 04/12] xfs: remove unnecessary shutdown check from
 xfs_iflush()
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-5-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <fd009e28-0ac0-a75a-8a64-c1303e9f660f@oracle.com>
Date:   Fri, 17 Apr 2020 17:27:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200417150859.14734-5-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004180000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004180000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/17/20 8:08 AM, Brian Foster wrote:
> The shutdown check in xfs_iflush() duplicates checks down in the
> buffer code. If the fs is shut down, xfs_trans_read_buf_map() always
> returns an error and falls into the same error path. Remove the
> unnecessary check along with the warning in xfs_imap_to_bp()
> that generates excessive noise in the log if the fs is shut down.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
Ok, I see the duplicate handler you are referring to.
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_inode_buf.c |  7 +------
>   fs/xfs/xfs_inode.c            | 13 -------------
>   2 files changed, 1 insertion(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 39c5a6e24915..b102e611bf54 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -172,12 +172,7 @@ xfs_imap_to_bp(
>   				   (int)imap->im_len, buf_flags, &bp,
>   				   &xfs_inode_buf_ops);
>   	if (error) {
> -		if (error == -EAGAIN) {
> -			ASSERT(buf_flags & XBF_TRYLOCK);
> -			return error;
> -		}
> -		xfs_warn(mp, "%s: xfs_trans_read_buf() returned error %d.",
> -			__func__, error);
> +		ASSERT(error != -EAGAIN || (buf_flags & XBF_TRYLOCK));
>   		return error;
>   	}
>   
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 4c9971ec6fa6..98ee1b10d1b0 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3657,19 +3657,6 @@ xfs_iflush(
>   		return 0;
>   	}
>   
> -	/*
> -	 * This may have been unpinned because the filesystem is shutting
> -	 * down forcibly. If that's the case we must not write this inode
> -	 * to disk, because the log record didn't make it to disk.
> -	 *
> -	 * We also have to remove the log item from the AIL in this case,
> -	 * as we wait for an empty AIL as part of the unmount process.
> -	 */
> -	if (XFS_FORCED_SHUTDOWN(mp)) {
> -		error = -EIO;
> -		goto abort;
> -	}
> -
>   	/*
>   	 * Get the buffer containing the on-disk inode. We are doing a try-lock
>   	 * operation here, so we may get an EAGAIN error. In that case, return
> 
