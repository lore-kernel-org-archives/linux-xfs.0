Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50454 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729116AbfDDVHx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Apr 2019 17:07:53 -0400
Subject: Re: [PATCH 37/36] xfs_scrub: include unicrash.h in unicrash.c
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <20190320193417.GA1183@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <19c738d2-515a-2d05-a3f0-458461cd72db@sandeen.net>
Date: Thu, 4 Apr 2019 16:07:52 -0500
MIME-Version: 1.0
In-Reply-To: <20190320193417.GA1183@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 3/20/19 2:34 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix broken function prototype checking in unicrash.c by actually
> including its header.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/unicrash.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/scrub/unicrash.c b/scrub/unicrash.c
> index 121eedbc..824b10f0 100644
> --- a/scrub/unicrash.c
> +++ b/scrub/unicrash.c
> @@ -16,6 +16,7 @@
>  #include "path.h"
>  #include "xfs_scrub.h"
>  #include "common.h"
> +#include "unicrash.h"
>  
>  /*
>   * Detect Unicode confusable names in directories and attributes.
> 
