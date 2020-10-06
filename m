Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3132CC4363D
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C52FD208B6
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:16:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="s9vZAMol"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgJFEQd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 00:16:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49252 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgJFEQd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 00:16:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964Eihk049132;
        Tue, 6 Oct 2020 04:16:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LLbnbTpjdmUgTq2SmwBRG4md4RcLoaiSNVNFO4dT8eA=;
 b=s9vZAMolQlfR23PasIqmyIqu2l0pIPhRmZ1IIFR5gCzm2ZpPzLeZ/+2Wyq3ldonko8Pq
 N+ASR7lO31T/CQQkqUnUSsOvVgQdNTohszQ/CnVjLZFAunEqUT1cTkgqIgroVH5tvo1H
 nCxGcSB51ECKJrnzbQLKJ2Go03hOZ2E0qz4lkZRbMSmQbx5Kf8IL3Kc9k4SSdXs9RZ1e
 mSQeOBNxbMUtrkYYNP5FCu3uXB5cPtcqh+5epAcxgnziEAWl6qZtjwYuGnXWLA6VyOm9
 k/qOrPUfeD8an4zGXAStXv3JQcXONJ+pcbvvJsFG4FPBjtgMZODnxgwe6OCi6DVzfGxh Wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33xhxmspk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 04:16:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964A652041291;
        Tue, 6 Oct 2020 04:16:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33y37wag20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 04:16:29 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0964GStP010418;
        Tue, 6 Oct 2020 04:16:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 21:16:28 -0700
Date:   Mon, 5 Oct 2020 21:16:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 2/4] xfs: clean up whitespace in xfs_isilocked() calls
Message-ID: <20201006041627.GJ49547@magnolia>
References: <20201005213852.233004-1-preichl@redhat.com>
 <20201005213852.233004-3-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005213852.233004-3-preichl@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=1 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 05, 2020 at 11:38:50PM +0200, Pavel Reichl wrote:
> Make whitespace follow the same pattern in all xfs_isilocked() calls.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 2 +-
>  fs/xfs/xfs_file.c        | 3 ++-
>  fs/xfs/xfs_inode.c       | 4 ++--
>  fs/xfs/xfs_qm.c          | 2 +-
>  4 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 1b0a01b06a05..ced3b996cd8a 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3883,7 +3883,7 @@ xfs_bmapi_read(
>  
>  	ASSERT(*nmap >= 1);
>  	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_ENTIRE)));
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
>  
>  	if (WARN_ON_ONCE(!ifp))
>  		return -EFSCORRUPTED;
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index a29f78a663ca..c8b1d4e4199a 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -763,7 +763,8 @@ xfs_break_layouts(
>  	bool			retry;
>  	int			error;
>  
> -	ASSERT(xfs_isilocked(XFS_I(inode), XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
> +	ASSERT(xfs_isilocked(XFS_I(inode),
> +			XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
>  
>  	do {
>  		retry = false;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 1f39bce96656..49d296877494 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2779,7 +2779,7 @@ static void
>  xfs_iunpin(
>  	struct xfs_inode	*ip)
>  {
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
>  
>  	trace_xfs_inode_unpin_nowait(ip, _RET_IP_);
>  
> @@ -3472,7 +3472,7 @@ xfs_iflush(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	int			error;
>  
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
>  	ASSERT(xfs_isiflocked(ip));
>  	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
>  	       ip->i_df.if_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index be67570badf8..57bfa5266c47 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1803,7 +1803,7 @@ xfs_qm_vop_chown_reserve(
>  	int			error;
>  
>  
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
>  	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
>  
>  	delblks = ip->i_delayed_blks;
> -- 
> 2.26.2
> 
