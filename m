Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37478 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbeHLKcb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Aug 2018 06:32:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7C7stFV036347
        for <linux-xfs@vger.kernel.org>; Sun, 12 Aug 2018 07:55:23 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2ksq7t1e03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 12 Aug 2018 07:55:23 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w7C7tM9L022858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 12 Aug 2018 07:55:23 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w7C7tMH7018647
        for <linux-xfs@vger.kernel.org>; Sun, 12 Aug 2018 07:55:22 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 5/6] iomap: fix WARN_ON_ONCE on uninitialized variable
References: <153400169747.27471.4044680761841034489.stgit@magnolia>
 <153400172814.27471.988480858889151684.stgit@magnolia>
Message-ID: <84c7794d-ad2f-bb05-de12-0838ec0973a6@oracle.com>
Date: Sun, 12 Aug 2018 00:55:21 -0700
MIME-Version: 1.0
In-Reply-To: <153400172814.27471.988480858889151684.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 08/11/2018 08:35 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit 9dc55f1389f9569 ("iomap: add support for sub-pagesize buffered
> I/O without buffer heads") we moved the initialization of poff (it's
> computed from pos) into a separate helper function.  Inline data only
> ever deals with pos == 0, hence the WARN_ON_ONCE, but now we're testing
> an uninitialized variable.
> 
> Therefore, change the test to check the parameter directly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/iomap.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 8bd54c08deee..8a18163dc432 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -290,7 +290,7 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>   	sector_t sector;
>   
>   	if (iomap->type == IOMAP_INLINE) {
> -		WARN_ON_ONCE(poff);
> +		WARN_ON_ONCE(pos);
>   		iomap_read_inline_data(inode, page, iomap);
>   		return PAGE_SIZE;
>   	}
> 
Ok, looks good.
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
