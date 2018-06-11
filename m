Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38106 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933183AbeFKR2Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jun 2018 13:28:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5BHQ2sr071567
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 17:28:24 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2jg7hwxdae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 17:28:23 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5BHSN3b015508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 17:28:23 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5BHSNjq027841
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 17:28:23 GMT
Date: Mon, 11 Jun 2018 10:28:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 19/27] xfsprogs: Add delayed attributes error tag
Message-ID: <20180611172822.GB22045@magnolia>
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
 <1528607272-11122-20-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1528607272-11122-20-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

> Subject: [PATCH v2 19/27] xfsprogs: Add delayed attributes error tag

Please identify the tool name in the subject when possible, e.g.

[PATCH v2 19/27] xfs_io: Add delayed attributes error tag

Otherwise looks ok, though in the end I suspect the xfs_errortag.h chunk
will be ported in from the kernel patch and this will be a separate
patch with just the xfs_io part.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


On Sat, Jun 09, 2018 at 10:07:44PM -0700, Allison Henderson wrote:
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  io/inject.c           | 1 +
>  libxfs/xfs_errortag.h | 5 ++++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/io/inject.c b/io/inject.c
> index fc3cf25..2d6cc9c 100644
> --- a/io/inject.c
> +++ b/io/inject.c
> @@ -63,6 +63,7 @@ error_tag(char *name)
>  		{ XFS_ERRTAG_LOG_BAD_CRC,		"log_bad_crc" },
>  		{ XFS_ERRTAG_LOG_ITEM_PIN,		"log_item_pin" },
>  		{ XFS_ERRTAG_BUF_LRU_REF,		"buf_lru_ref" },
> +		{ XFS_ERRTAG_DELAYED_ATTR,		"delayed_attr" },
>  		{ XFS_ERRTAG_MAX,			NULL }
>  	};
>  	int	count;
> diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
> index bc1789d..f606ab6 100644
> --- a/libxfs/xfs_errortag.h
> +++ b/libxfs/xfs_errortag.h
> @@ -65,7 +65,8 @@
>  #define XFS_ERRTAG_LOG_BAD_CRC				29
>  #define XFS_ERRTAG_LOG_ITEM_PIN				30
>  #define XFS_ERRTAG_BUF_LRU_REF				31
> -#define XFS_ERRTAG_MAX					32
> +#define XFS_ERRTAG_DELAYED_ATTR			32
> +#define XFS_ERRTAG_MAX					33
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -102,5 +103,7 @@
>  #define XFS_RANDOM_LOG_BAD_CRC				1
>  #define XFS_RANDOM_LOG_ITEM_PIN				1
>  #define XFS_RANDOM_BUF_LRU_REF				2
> +#define XFS_RANDOM_DELAYED_ATTR			1
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> +
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
