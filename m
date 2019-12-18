Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B5CFC2D0CD
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 02:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 523EC21835
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 02:40:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UcEewv84"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfLRCkF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 21:40:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34248 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfLRCkF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Dec 2019 21:40:05 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBI2OGdw064356;
        Wed, 18 Dec 2019 02:40:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=5RBQ5OIDrgiiwqpRN5aZr0qeCTxvgYiO63mntJqnh+I=;
 b=UcEewv84UlwlEUnTeZc6nTvhH6VoYAhBVp4tExwKA6c9yl+DJqUgUvwB/FiA5HNZv3Rv
 KbRCPSZMAy7ccyEQoyD0BDeBmgCbXcpn2ztFs6zP3fLWpJJe99nc3EhlVRGbp5XZ7e6c
 7xHaEPyuV6QecicHGludIpWhcI9kNE3ReCmekwr5megW+ynWuhcX4zaH9k+Z+TJ5QLNJ
 gxUKrLFi4S+0OchYhPxP0CJwysO1QgTSPY7c6jVb4K/3Lh2JBKP5UFuYUBTErGv7xpnn
 UMGlq1SMHQBQx0nMum2dQN8qTqJy+rRiUBo/RqmVmylhJ2DYQAyUHcbqy1GvY+XFCBX4 3w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wvqpqan5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 02:40:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBI2Noxa164009;
        Wed, 18 Dec 2019 02:40:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2wxm5m1j67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 02:40:00 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBI2dxRB001907;
        Wed, 18 Dec 2019 02:39:59 GMT
Received: from localhost (/10.159.137.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Dec 2019 18:39:59 -0800
Date:   Tue, 17 Dec 2019 18:39:58 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: rework collapse range into an atomic operation
Message-ID: <20191218023958.GI12765@magnolia>
References: <20191213171258.36934-1-bfoster@redhat.com>
 <20191213171258.36934-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213171258.36934-4-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180018
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 13, 2019 at 12:12:58PM -0500, Brian Foster wrote:
> The collapse range operation uses a unique transaction and ilock
> cycle for the hole punch and each extent shift iteration of the
> overall operation. While the hole punch is safe as a separate
> operation due to the iolock, cycling the ilock after each extent
> shift is risky similar to insert range.

It is?  I thought collapse range was safe because we started by punching
out the doomed range and shifting downwards, which eliminates the
problems that come with two adjacent mappings that could be combined?

<confused?>

--D

> To avoid this problem, make collapse range atomic with respect to
> ilock. Hold the ilock across the entire operation, replace the
> individual transactions with a single rolling transaction sequence
> and finish dfops on each iteration to perform pending frees and roll
> the transaction. Remove the unnecessary quota reservation as
> collapse range can only ever merge extents (and thus remove extent
> records and potentially free bmap blocks). The dfops call
> automatically relogs the inode to keep it moving in the log. This
> guarantees that nothing else can change the extent mapping of an
> inode while a collapse range operation is in progress.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 555c8b49a223..1c34a34997ca 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1050,7 +1050,6 @@ xfs_collapse_file_space(
>  	int			error;
>  	xfs_fileoff_t		next_fsb = XFS_B_TO_FSB(mp, offset + len);
>  	xfs_fileoff_t		shift_fsb = XFS_B_TO_FSB(mp, len);
> -	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
>  	bool			done = false;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> @@ -1066,32 +1065,34 @@ xfs_collapse_file_space(
>  	if (error)
>  		return error;
>  
> -	while (!error && !done) {
> -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0,
> -					&tp);
> -		if (error)
> -			break;
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0, &tp);
> +	if (error)
> +		return error;
>  
> -		xfs_ilock(ip, XFS_ILOCK_EXCL);
> -		error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
> -				ip->i_gdquot, ip->i_pdquot, resblks, 0,
> -				XFS_QMOPT_RES_REGBLKS);
> -		if (error)
> -			goto out_trans_cancel;
> -		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
>  
> +	while (!done) {
>  		error = xfs_bmap_collapse_extents(tp, ip, &next_fsb, shift_fsb,
>  				&done);
>  		if (error)
>  			goto out_trans_cancel;
> +		if (done)
> +			break;
>  
> -		error = xfs_trans_commit(tp);
> +		/* finish any deferred frees and roll the transaction */
> +		error = xfs_defer_finish(&tp);
> +		if (error)
> +			goto out_trans_cancel;
>  	}
>  
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
