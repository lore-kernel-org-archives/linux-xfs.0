Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43264 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750916AbeBVXvF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 18:51:05 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1MNlpxH066330
        for <linux-xfs@vger.kernel.org>; Thu, 22 Feb 2018 23:51:04 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2ga7cjr3v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Feb 2018 23:51:04 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1MNp2ro018127
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Feb 2018 23:51:03 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1MNp2LG019982
        for <linux-xfs@vger.kernel.org>; Thu, 22 Feb 2018 23:51:02 GMT
Date: Thu, 22 Feb 2018 15:51:01 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: don't iunlock the quota ip when quota block
 allocation fails
Message-ID: <20180222235101.GK9827@magnolia>
References: <20180222230435.GJ9827@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180222230435.GJ9827@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

On Thu, Feb 22, 2018 at 03:04:35PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_qm_dqalloc, we join the locked quota inode to the transaction we
> use to allocate blocks.  If the allocation or mapping fails, we're not
> allowed to unlock the inode because the transaction code is in charge of
> unlocking it for us.  Therefore, remove the iunlock call to avoid
> blowing asserts about unbalanced locking + mount hang.
> 
> Found by corrupting the AGF and allocating space in the filesystem
> (quotacheck) immediately after mount.  The upcoming agfl wrapping fixup
> test will trigger this scenario.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Realized I had a whole pile of other fixes to send out, so ignore this
for now.

--D

> ---
>  fs/xfs/xfs_dquot.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 43572f8..2410acc 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -394,8 +394,6 @@ xfs_qm_dqalloc(
>  error1:
>  	xfs_defer_cancel(&dfops);
>  error0:
> -	xfs_iunlock(quotip, XFS_ILOCK_EXCL);
> -
>  	return error;
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
