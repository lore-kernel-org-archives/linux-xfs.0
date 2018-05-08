Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56492 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932677AbeEHRVN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 13:21:13 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w48HL4Jf190882
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 17:21:12 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2hs24shtsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 17:21:12 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w48HLCfV021078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 17:21:12 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w48HLBOA001829
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 17:21:11 GMT
Date: Tue, 8 May 2018 10:21:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 17/21] xfsprogs: Add delayed attributes error tag
Message-ID: <20180508172107.GQ11261@magnolia>
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
 <1525754479-12177-18-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525754479-12177-18-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, May 07, 2018 at 09:41:15PM -0700, Allison Henderson wrote:
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Needs a commit message.  Eric might also want the xfs_io bit as a
separate patch to keep this one as close to the kernel patch as
possible.

(Though really, it's a single line, maybe not...)

--D

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
