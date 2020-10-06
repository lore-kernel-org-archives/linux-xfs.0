Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65EF2C4363D
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 277C1208C3
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:18:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J1RcSL0S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgJFESv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 00:18:51 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45034 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgJFESv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 00:18:51 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964ES3I087740;
        Tue, 6 Oct 2020 04:18:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=PuWc9UqEcM63wiMLKyIOLbY5hV/jQD9Sak5ucyvb+E8=;
 b=J1RcSL0SVjOB4orqitc/8nhMNogHoUdb7OmjDBfLcKzEcE4TQGuXrUepOTUlGj2i9YyL
 b5r13kOsiwxmeKiJ3aWPXnhSFszvb5JdwZ+9GeG2nasbwDYNWzPvST5HfR8/JJk1DeiK
 Prr2Dt/aD1hryt1cYg60tY688z5c6tBzihhqLX4r2AdpVNmtk3X0o/b02yasNKbYVOY3
 svs2n/EkS8Rjm/eeYF74MzVUaJZ24pkAw8uhDJ8sEEuwBlMgoOu1iPmuzTn+Lfa/PTNq
 /f1XjOnSKTSg2ek9/6Kc9GH2A2Tsm9lTfmoKvJlOgodjhXM7SkLi94Qmv2pAN+cDG4L7 CA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33xetasxbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 04:18:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964BDx7072168;
        Tue, 6 Oct 2020 04:16:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33y2vmere8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 04:16:48 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0964GmiU000410;
        Tue, 6 Oct 2020 04:16:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 21:16:48 -0700
Date:   Mon, 5 Oct 2020 21:16:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 3/4] xfs: xfs_isilocked() can only check a single lock
 type
Message-ID: <20201006041647.GK49547@magnolia>
References: <20201005213852.233004-1-preichl@redhat.com>
 <20201005213852.233004-4-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005213852.233004-4-preichl@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=1 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010060023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 05, 2020 at 11:38:51PM +0200, Pavel Reichl wrote:
> In its current form, xfs_isilocked() is only able to test one lock type
> at a time - ilock, iolock, or mmap lock, but combinations are not
> properly handled. The intent here is to check that both XFS_IOLOCK_EXCL
> and XFS_ILOCK_EXCL are held, so test them each separately.
> 
> The commit ecfea3f0c8c6 ("xfs: split xfs_bmap_shift_extents") ORed the
> flags together which was an error, so this patch reverts that part of
> the change and check the locks independently.
> 
> Fixes: ecfea3f0c8c6 ("xfs: split xfs_bmap_shift_extents")
> 
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Pavel Reichl <preichl@redhat.com>

Looks good,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index ced3b996cd8a..ff5cc8a5d476 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5787,7 +5787,8 @@ xfs_bmap_collapse_extents(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> -	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
> +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  
>  	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
>  		error = xfs_iread_extents(tp, ip, whichfork);
> @@ -5904,7 +5905,8 @@ xfs_bmap_insert_extents(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> -	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
> +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  
>  	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
>  		error = xfs_iread_extents(tp, ip, whichfork);
> -- 
> 2.26.2
> 
