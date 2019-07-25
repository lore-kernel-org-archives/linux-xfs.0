Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57604 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfGYGwd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 02:52:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6P6mvGG052989
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 06:52:31 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2tx61c1tq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 06:52:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6P6mFuT112743
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 06:52:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2tx60yq1s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 06:52:31 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6P6qUPP014402
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 06:52:30 GMT
Date: Thu, 25 Jul 2019 09:52:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] xfs: fix stack contents leakage in the v1
 bulkstat/inumbers ioctls
Message-ID: <20190725065216.GI3089@kadam>
References: <20190724153545.GC1561054@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724153545.GC1561054@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 24, 2019 at 08:35:45AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Explicitly initialize the onstack structures to zero so we don't leak
> kernel memory into userspace when converting the in-core structure to
> the v1 ioctl structure.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index f193f7b288ca..44e1a290f053 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -719,7 +719,7 @@ xfs_fsbulkstat_one_fmt(
>  	struct xfs_ibulk		*breq,
>  	const struct xfs_bulkstat	*bstat)
>  {
> -	struct xfs_bstat		bs1;
> +	struct xfs_bstat		bs1 = { 0 };

This sort of initialization is potentially problematic because some
versions of GCC will change it as a series of assignments (which doesn't
clear the struct hole).  It's not clear to me the rules where GCC does
this and also I wish there were an option to disable that feature.

[ I am still out of office until the end of the month ]

regards,
dan carpenter
