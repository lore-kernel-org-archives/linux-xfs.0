Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55504 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbfCOWC0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Mar 2019 18:02:26 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 05/36] debian: don't bypass top level Makefile when
 building subdirs
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259745436.31886.466306969009991047.stgit@magnolia>
Message-ID: <60dcbbb7-9e49-d65f-42aa-726a86c8be80@oracle.com>
Date: Fri, 15 Mar 2019 15:02:21 -0700
MIME-Version: 1.0
In-Reply-To: <155259745436.31886.466306969009991047.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org

Looks ok.  Thanks!

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

On 3/14/19 2:04 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The top level Makefile does some processing to set build environment
> variables (Q and CHECK_CMD).  debian/rules uses -C to build subdirs
> directly, which bypases this feature of the top-level makefile, which
> causes more build spew than necessary (because Q never gets set to quiet
> the build).
> 
> Since the top level makefile can be used to build the subdirs
> debian/rules cares about, drop the -C and build subdirs via the top
> level Makefile to quiet the build.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   debian/rules |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/debian/rules b/debian/rules
> index 80dff4bb..7c2a8b3c 100755
> --- a/debian/rules
> +++ b/debian/rules
> @@ -51,7 +51,7 @@ dibuild:
>   			$(MAKE) -C $$dir NODEP=1 install-headers; \
>   		done; \
>   		for dir in include libxfs libxcmd libfrog mkfs; do \
> -			$(MAKE) -C $$dir; \
> +			$(MAKE) $$dir; \
>   		done; \
>   		mv mkfs/mkfs.xfs mkfs/mkfs.xfs-$(bootpkg); \
>   		$(MAKE) distclean; \
> 
