Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8315929DFB
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 20:48:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1DA7FAC006
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 18:48:15 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	3JBam1XocYlDJUZc for <xfs@oss.sgi.com>;
	Thu, 01 Aug 2013 18:48:13 -0700 (PDT)
Date: Fri, 2 Aug 2013 11:48:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v8 7/7] enable building user namespace with xfs
Message-ID: <20130802014812.GX7118@dastard>
References: <20130801113025.5d579a28@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130801113025.5d579a28@oracle.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 01, 2013 at 11:30:25AM -0400, Dwight Engen wrote:
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> ---
>  init/Kconfig | 13 -------------
>  1 file changed, 13 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 247084b..a7bcd87 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1106,7 +1106,6 @@ config IPC_NS
>  
>  config USER_NS
>  	bool "User namespace"
> -	depends on UIDGID_CONVERTED
>  	select UIDGID_STRICT_TYPE_CHECKS
>  
>  	default n
> @@ -1140,20 +1139,8 @@ config NET_NS
>  
>  endif # NAMESPACES
>  
> -config UIDGID_CONVERTED
> -	# True if all of the selected software conmponents are known
> -	# to have uid_t and gid_t converted to kuid_t and kgid_t
> -	# where appropriate and are otherwise safe to use with
> -	# the user namespace.
> -	bool
> -	default y
> -
> -	# Filesystems
> -	depends on XFS_FS = n
> -
>  config UIDGID_STRICT_TYPE_CHECKS
>  	bool "Require conversions between uid/gids and their internal representation"
> -	depends on UIDGID_CONVERTED
>  	default n
>  	help
>  	 While the nececessary conversions are being added to all subsystems this option allows

Looks good, I think we can run with this now...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Good work, Dwight :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
