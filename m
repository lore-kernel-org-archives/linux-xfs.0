Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33736 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388090AbeGXFWV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jul 2018 01:22:21 -0400
Date: Mon, 23 Jul 2018 21:17:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfsprogs: remove generated scrub files under clean target
Message-ID: <20180724041738.GR4813@magnolia>
References: <eed34d4b-7ec9-aedb-fbb3-1c887d375001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eed34d4b-7ec9-aedb-fbb3-1c887d375001@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jul 23, 2018 at 09:06:33PM -0700, Eric Sandeen wrote:
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/scrub/Makefile b/scrub/Makefile
> index d9ab148..acebecc 100644
> --- a/scrub/Makefile
> +++ b/scrub/Makefile
> @@ -97,6 +97,8 @@ ifeq ($(HAVE_HDIO_GETGEO),yes)
>  LCFLAGS += -DHAVE_HDIO_GETGEO
>  endif
>  
> +LDIRT = $(XFS_SCRUB_ALL_PROG) *.service *.cron
> +
>  default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(OPTIONAL_TARGETS)
>  
>  xfs_scrub_all: xfs_scrub_all.in
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
