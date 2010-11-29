Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oATKlcvZ215495 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 14:47:38 -0600
Subject: Re: [PATCH] xfsdump: fix xfs_invutil dependency generation
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101129163424.GA22014@sgi.com>
References: <20101129163424.GA22014@sgi.com>
Date: Mon, 29 Nov 2010 14:48:57 -0600
Message-ID: <1291063737.2425.13.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, 2010-11-29 at 10:34 -0600, Bill Kendall wrote:
> Correct the target name for dependency generation in the
> invutil Makefile. This is now consistent with other dump
> makefiles and eliminates "No such file or directory"
> errors during the build.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
>  invutil/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: xfsdump-kernel.org/invutil/Makefile
> ===================================================================
> --- xfsdump-kernel.org.orig/invutil/Makefile
> +++ xfsdump-kernel.org/invutil/Makefile
> @@ -70,7 +70,7 @@ install: default
>  	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
>  install-dev:
>  
> -depend: $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
> +.dep: $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
>  
>  $(COMMINCL) $(COMMON):
>  	@echo "    [LN]     $@"
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
