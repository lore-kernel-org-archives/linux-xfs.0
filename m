Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45250 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750964AbeEYECg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 May 2018 00:02:36 -0400
Date: Thu, 24 May 2018 21:02:18 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 4/4] debian/rules: use the new sysconfdir
 configuration setting
Message-ID: <20180525040218.GS14384@magnolia>
References: <20180525031943.29440-1-mcgrof@kernel.org>
 <20180525031943.29440-5-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180525031943.29440-5-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Thu, May 24, 2018 at 08:19:43PM -0700, Luis R. Rodriguez wrote:
> Configuration file support requires setting --sysconfdir=/etc/ if your
> distribution expects mkfs.xfs.d directory to be in /etc.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>

Looks good, thanks for putting this series together!
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  debian/rules | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/debian/rules b/debian/rules
> index cb4fa22c1584..599d7998052e 100755
> --- a/debian/rules
> +++ b/debian/rules
> @@ -20,9 +20,9 @@ stdenv = @GZIP=-q; export GZIP;
>  
>  options = export DEBUG=-DNDEBUG DISTRIBUTION=debian \
>  	  INSTALL_USER=root INSTALL_GROUP=root \
> -	  LOCAL_CONFIGURE_OPTIONS="--enable-readline=yes --enable-blkid=yes --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
> +	  LOCAL_CONFIGURE_OPTIONS="--enable-readline=yes --enable-blkid=yes --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto --sysconfdir=/etc/" ;
>  diopts  = $(options) \
> -	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
> +	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto --sysconfdir=/etc/" ;
>  checkdir = test -f debian/rules
>  
>  build: build-arch build-indep
> -- 
> 2.16.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
