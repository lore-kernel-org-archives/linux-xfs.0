Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74926C47254
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59BBB20870
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:37:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QUVYr+7/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgD3Shf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 14:37:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37106 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgD3She (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 14:37:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UIO94p030712;
        Thu, 30 Apr 2020 18:37:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=VpaX1C/j6dAG/dZvQY9no2CfZVE5ItMPcAsZ8EN4Hwk=;
 b=QUVYr+7/IK7rtl+7gMuhTBu7eDqcx9h+ai2bGBg6dx2stVyDYtq65ttr/Rhc9jNkxlrx
 eNEdK11NAXWJLY+C4OMvT09JH26wE3yWKnbi5ioWxRIP7Q7815t6L93X/LsCNfuydNaH
 Z/MkRl6FzmUo3w2/272HW1arv1NQP0gaAjB5oqNQ6svgsqsii9ALCs5gwlOxP51HNbcI
 UW+s1kFJWwo2Emm3S4PP7pdA1i4THNXWBlLWeSMsJ3iMVR6lGDpr7bGG+fv/p7XbKKZX
 K5I7U1DOG8PRKcADnRwO5P7n6v+E2RcaZyxyOxZsLvIsaLgntk9NG5llfdnN+b8ZYTPy FQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30p2p0jn8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:37:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UIaJo0078187;
        Thu, 30 Apr 2020 18:37:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30qtg1m4q7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:37:31 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UIbUZS021381;
        Thu, 30 Apr 2020 18:37:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 11:37:30 -0700
Date:   Thu, 30 Apr 2020 11:37:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 04/17] xfs: remove unnecessary shutdown check from
 xfs_iflush()
Message-ID: <20200430183729.GE6742@magnolia>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-5-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:40PM -0400, Brian Foster wrote:
> The shutdown check in xfs_iflush() duplicates checks down in the
> buffer code. If the fs is shut down, xfs_trans_read_buf_map() always
> returns an error and falls into the same error path. Remove the
> unnecessary check along with the warning in xfs_imap_to_bp()
> that generates excessive noise in the log if the fs is shut down.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks decent,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c |  7 +------
>  fs/xfs/xfs_inode.c            | 13 -------------
>  2 files changed, 1 insertion(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 39c5a6e24915..b102e611bf54 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -172,12 +172,7 @@ xfs_imap_to_bp(
>  				   (int)imap->im_len, buf_flags, &bp,
>  				   &xfs_inode_buf_ops);
>  	if (error) {
> -		if (error == -EAGAIN) {
> -			ASSERT(buf_flags & XBF_TRYLOCK);
> -			return error;
> -		}
> -		xfs_warn(mp, "%s: xfs_trans_read_buf() returned error %d.",
> -			__func__, error);
> +		ASSERT(error != -EAGAIN || (buf_flags & XBF_TRYLOCK));
>  		return error;
>  	}
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 84f2ee9957dc..6fb3e26afa8b 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3657,19 +3657,6 @@ xfs_iflush(
>  		return 0;
>  	}
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
>  	/*
>  	 * Get the buffer containing the on-disk inode. We are doing a try-lock
>  	 * operation here, so we may get an EAGAIN error. In that case, return
> -- 
> 2.21.1
> 
