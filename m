Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:26278 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751404AbdIAAag (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 20:30:36 -0400
Date: Fri, 1 Sep 2017 10:30:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fsmap: fix documentation of FMR_OF_LAST
Message-ID: <20170901003029.GX10621@dastard>
References: <20170831204918.GA7404@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170831204918.GA7404@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-api@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Thu, Aug 31, 2017 at 01:49:18PM -0700, Darrick J. Wong wrote:
> The FMR_OF_LAST flag is set on the last fsmap record being returned for
> the dataset requested, contrary to what the header file says.  Fix the
> docs to reflect the behavior of all fsmap implementations.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  include/uapi/linux/fsmap.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/fsmap.h b/include/uapi/linux/fsmap.h
> index 7e8e5f0b..e5213c3 100644
> --- a/include/uapi/linux/fsmap.h
> +++ b/include/uapi/linux/fsmap.h
> @@ -96,7 +96,7 @@ fsmap_advance(
>  #define FMR_OF_EXTENT_MAP	0x4	/* segment = extent map */
>  #define FMR_OF_SHARED		0x8	/* segment = shared with another file */
>  #define FMR_OF_SPECIAL_OWNER	0x10	/* owner is a special value */
> -#define FMR_OF_LAST		0x20	/* segment is the last in the FS */
> +#define FMR_OF_LAST		0x20	/* segment is the last in the dataset */
>  
>  /* Each FS gets to define its own special owner codes. */
>  #define FMR_OWNER(type, code)	(((__u64)type << 32) | \

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
