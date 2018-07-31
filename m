Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53806 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbeGaFYK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 01:24:10 -0400
Date: Mon, 30 Jul 2018 20:45:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] misc: remove COPYING from doc/ Makefile
Message-ID: <20180731034556.GT30972@magnolia>
References: <e4d64c9b-5a1a-54b5-8b69-463738c95307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4d64c9b-5a1a-54b5-8b69-463738c95307@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jul 30, 2018 at 10:41:54PM -0500, Eric Sandeen wrote:
> COPYING is gone now, so make doc-install breaks.
> 
> Fixes: 959ef98 ("xfsprogs: convert to SPDX license tags")
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/doc/Makefile b/doc/Makefile
> index 8b870dc..83dfa38 100644
> --- a/doc/Makefile
> +++ b/doc/Makefile
> @@ -5,7 +5,7 @@
>  TOPDIR = ..
>  include $(TOPDIR)/include/builddefs
>  
> -LSRCFILES = INSTALL CHANGES COPYING CREDITS sparse.txt
> +LSRCFILES = INSTALL CHANGES CREDITS sparse.txt
>  LDIRT = *.gz
>  
>  default: CHANGES.gz
> @@ -21,8 +21,6 @@ install: default
>  	$(INSTALL) -m 644 CHANGES.gz CREDITS $(PKG_DOC_DIR)
>  ifeq ($(PKG_DISTRIBUTION), debian)
>  	$(INSTALL) -S CHANGES.gz $(PKG_DOC_DIR)/changelog.gz
> -else
> -	$(INSTALL) -m 644 COPYING $(PKG_DOC_DIR)
>  endif
>  
>  install-dev:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
