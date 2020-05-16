Return-Path: <SRS0=gkwD=66=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D0DC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4165B206D8
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:40:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qA5H9V/B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgEPRkV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 May 2020 13:40:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38710 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgEPRkV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 May 2020 13:40:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GHbsQK030692;
        Sat, 16 May 2020 17:40:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=42c5fknY6DHEKcYiV1xIemcQXdQo/IXkx7TxJ7GtFrU=;
 b=qA5H9V/BVruAxFbQ8OeP63efp1/dyI6wTCs5yCSFt+R1/3EluQ03zMg2j+rJYPWaQ/cB
 4oa77tn1WWXYKeKxCFHzNSlCC1Q0sDU5fqkB2nOuVLmP+BgcNybeQgrcc3bzsVmXxpWq
 ia3PVW7cpZpKtlIVo1fW1QT5fbKo1v7VO0/ZRUHk47Zo20aAdi2Le4fLrdW2NB/ytRl7
 VTmJBNnNk9M0qEnHSgYehbxmcb8X43Dkc/EZDLrU5EeM4IjB0zzjA1upQBPbGS46RXDb
 SIfg3KZT6aj4IzkwskbZZwlUXA5vOodxSA9BvigH14ZfuGZFhUIp8eIkbHCPIX3Ag4na Xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3128tn1b4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 16 May 2020 17:40:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GHcCso002924;
        Sat, 16 May 2020 17:40:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31259rfq60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 May 2020 17:40:15 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04GHeETG024871;
        Sat, 16 May 2020 17:40:14 GMT
Received: from localhost (/10.159.131.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 16 May 2020 10:40:14 -0700
Date:   Sat, 16 May 2020 10:40:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 05/12] xfs: call xfs_dinode_verify from
 xfs_inode_from_disk
Message-ID: <20200516174013.GU6714@magnolia>
References: <20200508063423.482370-1-hch@lst.de>
 <20200508063423.482370-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508063423.482370-6-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 phishscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160158
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 08:34:16AM +0200, Christoph Hellwig wrote:
> Keep the code dealing with the dinode together, and also ensure we verify
> the dinode in the owner change log recovery case as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Seems reasonable to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  .../xfs-self-describing-metadata.txt           | 10 +++++-----
>  fs/xfs/libxfs/xfs_inode_buf.c                  | 18 ++++++++----------
>  2 files changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/filesystems/xfs-self-describing-metadata.txt b/Documentation/filesystems/xfs-self-describing-metadata.txt
> index 8db0121d0980c..e912699d74301 100644
> --- a/Documentation/filesystems/xfs-self-describing-metadata.txt
> +++ b/Documentation/filesystems/xfs-self-describing-metadata.txt
> @@ -337,11 +337,11 @@ buffer.
>  
>  The structure of the verifiers and the identifiers checks is very similar to the
>  buffer code described above. The only difference is where they are called. For
> -example, inode read verification is done in xfs_iread() when the inode is first
> -read out of the buffer and the struct xfs_inode is instantiated. The inode is
> -already extensively verified during writeback in xfs_iflush_int, so the only
> -addition here is to add the LSN and CRC to the inode as it is copied back into
> -the buffer.
> +example, inode read verification is done in xfs_inode_from_disk() when the inode
> +is first read out of the buffer and the struct xfs_inode is instantiated. The
> +inode is already extensively verified during writeback in xfs_iflush_int, so the
> +only addition here is to add the LSN and CRC to the inode as it is copied back
> +into the buffer.
>  
>  XXX: inode unlinked list modification doesn't recalculate the inode CRC! None of
>  the unlinked list modifications check or update CRCs, neither during unlink nor
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 686a026b5f6ed..3aac22e892985 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -188,10 +188,18 @@ xfs_inode_from_disk(
>  	struct xfs_icdinode	*to = &ip->i_d;
>  	struct inode		*inode = VFS_I(ip);
>  	int			error;
> +	xfs_failaddr_t		fa;
>  
>  	ASSERT(ip->i_cowfp == NULL);
>  	ASSERT(ip->i_afp == NULL);
>  
> +	fa = xfs_dinode_verify(ip->i_mount, ip->i_ino, from);
> +	if (fa) {
> +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "dinode", from,
> +				sizeof(*from), fa);
> +		return -EFSCORRUPTED;
> +	}
> +
>  	/*
>  	 * First get the permanent information that is needed to allocate an
>  	 * inode. If the inode is unused, mode is zero and we shouldn't mess
> @@ -627,7 +635,6 @@ xfs_iread(
>  {
>  	xfs_buf_t	*bp;
>  	xfs_dinode_t	*dip;
> -	xfs_failaddr_t	fa;
>  	int		error;
>  
>  	/*
> @@ -652,15 +659,6 @@ xfs_iread(
>  	if (error)
>  		return error;
>  
> -	/* even unallocated inodes are verified */
> -	fa = xfs_dinode_verify(mp, ip->i_ino, dip);
> -	if (fa) {
> -		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "dinode", dip,
> -				sizeof(*dip), fa);
> -		error = -EFSCORRUPTED;
> -		goto out_brelse;
> -	}
> -
>  	error = xfs_inode_from_disk(ip, dip);
>  	if (error)
>  		goto out_brelse;
> -- 
> 2.26.2
> 
