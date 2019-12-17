Return-Path: <SRS0=4VMi=2H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56EDFC43603
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 17:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29B0C21835
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 17:05:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oQHwoncW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfLQRFA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 12:05:00 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55356 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbfLQRFA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Dec 2019 12:05:00 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBHH48q1006747;
        Tue, 17 Dec 2019 17:04:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=goWp/rdKeUMQUIeo5TdWC6vSWHDLxKI1DeyzXkdhhYc=;
 b=oQHwoncW0DHo/snc8jNjRc03drHQ3fHOorIzQCrvMNskIr0zsuoxSGz0H3x1E2KpMwNl
 4fyrsYcI0YQMzHWOs8RQlE+yFTpQYiy28Nf69DNFpwWjfqWm+PUljQIx/e0J7uUVbyvi
 6e3waDAgSBISRQE9PRNK7EdYeW4lFYms7n270QeYcIIrkGT3zrUPwon0iJhKPy1MaKaL
 Kn9+ZqXb2Xfl+VsakoHS7MQwYD6b9E0JR90LYW9vGC5cHx4OGeWbutxfD5YynKWgNU3N
 t/SRCUfD8+5v4zOXgJSRaTGk4Hn+ChrzDPLmscOH/NtqaQC0E1GkiaOEc1C02nKgVnt9 LQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wvrcr7xg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 17:04:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBHH4Le2027537;
        Tue, 17 Dec 2019 17:04:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2wxm5nhgqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 17:04:56 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBHH4tkl016580;
        Tue, 17 Dec 2019 17:04:55 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Dec 2019 09:04:55 -0800
Subject: Re: [PATCH 2/3] xfs: rework insert range into an atomic operation
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20191213171258.36934-1-bfoster@redhat.com>
 <20191213171258.36934-3-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <10b19c32-e96e-fb29-611b-e615bafbf04f@oracle.com>
Date:   Tue, 17 Dec 2019 10:04:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191213171258.36934-3-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912170135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912170135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/13/19 10:12 AM, Brian Foster wrote:
> The insert range operation uses a unique transaction and ilock cycle
> for the extent split and each extent shift iteration of the overall
> operation. While this works, it is risks racing with other
> operations in subtle ways such as COW writeback modifying an extent
> tree in the middle of a shift operation.
> 
> To avoid this problem, make insert range atomic with respect to
> ilock. Hold the ilock across the entire operation, replace the
> individual transactions with a single rolling transaction sequence
> and relog the inode to keep it moving in the log. This guarantees
> that nothing else can change the extent mapping of an inode while
> an insert range operation is in progress.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Ok, this looks good to me.  Thanks!

Reviewed by: Allison Collins <allison.henderson@oracle.com>
> ---
>   fs/xfs/xfs_bmap_util.c | 32 +++++++++++++-------------------
>   1 file changed, 13 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 829ab1a804c9..555c8b49a223 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1134,47 +1134,41 @@ xfs_insert_file_space(
>   	if (error)
>   		return error;
>   
> -	/*
> -	 * The extent shifting code works on extent granularity. So, if stop_fsb
> -	 * is not the starting block of extent, we need to split the extent at
> -	 * stop_fsb.
> -	 */
>   	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
>   			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
>   	if (error)
>   		return error;
>   
>   	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
>   
> +	/*
> +	 * The extent shifting code works on extent granularity. So, if stop_fsb
> +	 * is not the starting block of extent, we need to split the extent at
> +	 * stop_fsb.
> +	 */
>   	error = xfs_bmap_split_extent(tp, ip, stop_fsb);
>   	if (error)
>   		goto out_trans_cancel;
>   
> -	error = xfs_trans_commit(tp);
> -	if (error)
> -		return error;
> -
> -	while (!error && !done) {
> -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0,
> -					&tp);
> +	do {
> +		error = xfs_trans_roll_inode(&tp, ip);
>   		if (error)
> -			break;
> +			goto out_trans_cancel;
>   
> -		xfs_ilock(ip, XFS_ILOCK_EXCL);
> -		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>   		error = xfs_bmap_insert_extents(tp, ip, &next_fsb, shift_fsb,
>   				&done, stop_fsb);
>   		if (error)
>   			goto out_trans_cancel;
> +	} while (!done);
>   
> -		error = xfs_trans_commit(tp);
> -	}
> -
> +	error = xfs_trans_commit(tp);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>   	return error;
>   
>   out_trans_cancel:
>   	xfs_trans_cancel(tp);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>   	return error;
>   }
>   
> 
