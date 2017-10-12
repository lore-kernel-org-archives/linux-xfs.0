Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41512 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753191AbdJLWCz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2017 18:02:55 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9CM2sg2011956
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 22:02:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9CM2qi9009876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 22:02:53 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9CM2peW015039
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 22:02:52 GMT
Date: Thu, 12 Oct 2017 15:02:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_io: report io error for pwrite -W and -w
Message-ID: <20171012220245.GM7122@magnolia>
References: <20171012204949.8225-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171012204949.8225-1-bo.li.liu@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2017 at 02:49:49PM -0600, Liu Bo wrote:
> When IO error occurs, xfs_io -c "pwrite -W/w" doesn't report errors
> while xfs_io -c "pwrite" -c "fsync" does.
> 
> This changes "pwrite -W/w" to report errors when it should.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  io/pwrite.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/io/pwrite.c b/io/pwrite.c
> index 1c5dfca..71bcccc 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -379,11 +379,18 @@ pwrite_f(
>  	}
>  	if (c < 0)
>  		goto done;
> -	if (Wflag)
> -		fsync(file->fd);
> -	if (wflag)
> -		fdatasync(file->fd);
> +	if (Wflag) {
> +		if (fsync(file->fd) < 0) {
> +			perror("fsync");
> +			goto done;
> +		}
> +	}
> +	if (wflag) {
> +		if (fdatasync(file->fd) < 0) {
> +			perror("fdatasync");

Ok.

> +			goto done;

So this is a new behavior -- previously we'd print the timing info even
if the f{data,}sync call fails.  I don't know that the timing matters if
we fail to guarantee the data is on stable storage, but does anyone else
have opinions?

--D

> +		}
> +	}
>  	if (qflag)
>  		goto done;
>  	gettimeofday(&t2, NULL);
> -- 
> 2.9.4
> 
> @@ -390,0 +397,0 @@
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
