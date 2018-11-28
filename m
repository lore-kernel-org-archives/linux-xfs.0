Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:32862 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728217AbeK2DPD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 22:15:03 -0500
Date: Wed, 28 Nov 2018 08:12:48 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfsprogs: don't install xfs_scrub man pages if config'd
 off
Message-ID: <20181128161248.GH8125@magnolia>
References: <0ba2607c-9954-94fc-fcf0-c6fe8579a2c8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ba2607c-9954-94fc-fcf0-c6fe8579a2c8@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Nov 27, 2018 at 01:41:31PM -0600, Eric Sandeen wrote:
> Don't install man pages for xfs_scrub if it's turned off
> in the config.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/man/man8/Makefile b/man/man8/Makefile
> index 36620da..e6a5572 100644
> --- a/man/man8/Makefile
> +++ b/man/man8/Makefile
> @@ -7,7 +7,11 @@ include $(TOPDIR)/include/builddefs
>  
>  MAN_SECTION	= 8
>  
> -MAN_PAGES	= $(shell echo *.$(MAN_SECTION))
> +ifneq ("$(ENABLE_SCRUB)","yes")
> +  MAN_PAGES = $(filter-out xfs_scrub%,$(shell echo *.$(MAN_SECTION)))
> +else
> +  MAN_PAGES = $(shell echo *.$(MAN_SECTION))
> +endif
>  MAN_DEST	= $(PKG_MAN_DIR)/man$(MAN_SECTION)
>  LSRCFILES	= $(MAN_PAGES)
>  
> 
