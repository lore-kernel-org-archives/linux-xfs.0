Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 494E6C2D0CD
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 02:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E73D21835
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 02:37:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LAsbikFF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfLRChg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 21:37:36 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33392 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfLRChg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Dec 2019 21:37:36 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBI2OLg9083026;
        Wed, 18 Dec 2019 02:37:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=H7ZwXuNNMQmDz3G1epYU99NTQ9Y+UCYhvi/urpEApPU=;
 b=LAsbikFFZaPfYfhcmSOqPjK4JR3F92xw6WM4ulQvM7ijz4lktgfqe7W4Dy5yKZt6FDGe
 e5CADHQlVWmKVs9hJ6tgZ3MoHZrki73d1ZFpXMXyXFvZ4FSrECB9HKBlDGxF4xcL7NS8
 PcF4wVRC9AzWdrBWlKh4L8LDzOUWNw0RnX2b3Ktwi4vm3N3Sub1/xAOnlmHoUHV/dEsn
 IEYeHjLXI6fhsMun20cTtMko7tJumyKW01szpWHpk8AhLvQHaL3APx59B4HsU5y1kit8
 /1gyFQCTuE1ZPHEOA/dwwPtwfqa8kAELolikUKivpgxHu6DQsRQGmksr2m2WjDAkYCB0 wQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2wvq5ujqmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 02:37:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBI2Npep164134;
        Wed, 18 Dec 2019 02:37:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2wxm5m1fk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 02:37:32 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBI2bVeG028748;
        Wed, 18 Dec 2019 02:37:31 GMT
Received: from localhost (/10.159.137.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Dec 2019 18:37:31 -0800
Date:   Tue, 17 Dec 2019 18:37:26 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: rework insert range into an atomic operation
Message-ID: <20191218023726.GH12765@magnolia>
References: <20191213171258.36934-1-bfoster@redhat.com>
 <20191213171258.36934-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213171258.36934-3-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180018
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 13, 2019 at 12:12:57PM -0500, Brian Foster wrote:
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
> ---
>  fs/xfs/xfs_bmap_util.c | 32 +++++++++++++-------------------
>  1 file changed, 13 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 829ab1a804c9..555c8b49a223 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1134,47 +1134,41 @@ xfs_insert_file_space(
>  	if (error)
>  		return error;
>  
> -	/*
> -	 * The extent shifting code works on extent granularity. So, if stop_fsb
> -	 * is not the starting block of extent, we need to split the extent at
> -	 * stop_fsb.
> -	 */
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
>  			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
>  	if (error)
>  		return error;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
>  
> +	/*
> +	 * The extent shifting code works on extent granularity. So, if stop_fsb
> +	 * is not the starting block of extent, we need to split the extent at
> +	 * stop_fsb.
> +	 */
>  	error = xfs_bmap_split_extent(tp, ip, stop_fsb);
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	error = xfs_trans_commit(tp);
> -	if (error)
> -		return error;
> -
> -	while (!error && !done) {
> -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0,
> -					&tp);

I'm a little concerned about the livelock potential here, if there are a lot of
other threads that have eaten all the transaction reservation and are trying to
get our ILOCK, while at the same time this thread has the ILOCK and is trying
to roll the transaction to move another extent, having already rolled the
transaction more than logcount times.

I think the extent shifting loop starts with the highest offset mapping and
shifts it up and continues in order of decreasing offset until it gets to
 @stop_fsb, correct?

Can we use "alloc trans; ilock; move; commit" for every extent higher than the
one that crosses @stop_fsb, and use "alloc trans; ilock; split; roll;
insert_extents; commit" to deal with that one extent that crosses @stop_fsb?
tr_write pre-reserves enough space to that the roll won't need to get more,
which would eliminate that potential problem, I think.

--D

> +	do {
> +		error = xfs_trans_roll_inode(&tp, ip);
>  		if (error)
> -			break;
> +			goto out_trans_cancel;
>  
> -		xfs_ilock(ip, XFS_ILOCK_EXCL);
> -		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  		error = xfs_bmap_insert_extents(tp, ip, &next_fsb, shift_fsb,
>  				&done, stop_fsb);
>  		if (error)
>  			goto out_trans_cancel;
> +	} while (!done);
>  
> -		error = xfs_trans_commit(tp);
> -	}
> -
> +	error = xfs_trans_commit(tp);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
>  
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
>  }
>  
> -- 
> 2.20.1
> 
