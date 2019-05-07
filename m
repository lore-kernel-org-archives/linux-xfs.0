Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35958 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfEGALe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 May 2019 20:11:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4708jwH130794
        for <linux-xfs@vger.kernel.org>; Tue, 7 May 2019 00:11:33 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2s94bfsre8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 May 2019 00:11:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4709pC2061688
        for <linux-xfs@vger.kernel.org>; Tue, 7 May 2019 00:11:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2sagytmpb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 May 2019 00:11:32 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x470BVXd028075
        for <linux-xfs@vger.kernel.org>; Tue, 7 May 2019 00:11:31 GMT
Subject: Re: [PATCH 2/4] xfs_restore: check return value
References: <155085403848.5141.1866278990901950186.stgit@magnolia>
 <155085405082.5141.12150949924461780415.stgit@magnolia>
From: Allison Collins <allison.henderson@oracle.com>
Message-ID: <038696eb-a0ff-ea34-ebfb-4372ca38873c@oracle.com>
Date: Mon, 6 May 2019 17:11:30 -0700
MIME-Version: 1.0
In-Reply-To: <155085405082.5141.12150949924461780415.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Looks ok.
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

On 2/22/19 9:47 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check the return value of the unlink call when creating a new file.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   restore/dirattr.c |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/restore/dirattr.c b/restore/dirattr.c
> index 0fb2877..4257a1b 100644
> --- a/restore/dirattr.c
> +++ b/restore/dirattr.c
> @@ -67,7 +67,9 @@ create_filled_file(
>   	int		fd;
>   	int		ret;
>   
> -	(void)unlink(pathname);
> +	ret = unlink(pathname);
> +	if (ret && errno != ENOENT)
> +		return ret;
>   
>   	fd = open(pathname, O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR);
>   	if (fd < 0)
> 
