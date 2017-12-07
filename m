Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40078 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752073AbdLGAvZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Dec 2017 19:51:25 -0500
Subject: Re: [PATCH] libxfs: libxfs_nproc should never return negative numbers
References: <20171206234917.GM4910@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <a6c8f1a1-2706-1805-aae4-7608258c6a61@redhat.com>
Date: Wed, 6 Dec 2017 18:51:23 -0600
MIME-Version: 1.0
In-Reply-To: <20171206234917.GM4910@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 12/6/17 5:49 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Prevent libxfs_nproc from returning a negative/zero CPU count if
> platform_nproc happens to error out.
> 
> Fixes-coverity-id: 1425909
> Fixes-coverity-id: 1425910
> Fixes-coverity-id: 1425913

3 birds, one stone, probably worth it :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libxfs/init.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index a007b3b..302f088 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -910,7 +910,12 @@ libxfs_report(FILE *fp)
>  int
>  libxfs_nproc(void)
>  {
> -	return platform_nproc();
> +	int	nr;
> +
> +	nr = platform_nproc();
> +	if (nr < 1)
> +		nr = 1;
> +	return nr;
>  }
>  
>  unsigned long
> 

