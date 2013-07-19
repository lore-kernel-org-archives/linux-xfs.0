Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CFE807F58
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 00:19:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B24AE30404E
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 22:19:38 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	9ZHHFuYWx7COQrgf for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 22:19:37 -0700 (PDT)
Date: Fri, 19 Jul 2013 15:19:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 1/7] xfs: create wrappers for converting kuid_t
	to/from uid_t
Message-ID: <20130719051933.GS11674@dastard>
References: <20130717114714.256c828d@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130717114714.256c828d@oracle.com>
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

On Wed, Jul 17, 2013 at 11:47:14AM -0400, Dwight Engen wrote:
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> ---
>  fs/xfs/xfs_linux.h | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 800f896..761e4c0 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -159,6 +159,32 @@
>  #define MAX(a,b)	(max(a,b))
>  #define howmany(x, y)	(((x)+((y)-1))/(y))
>  
> +/* Kernel uid/gid conversion. These are used to convert to/from the on disk
> + * uid_t/gid_t types to the kuid_t/kgid_t types that the kernel uses internally.
> + * The conversion here is type only, the value will remain the same since we
> + * are converting to the init_user_ns. The uid is later mapped to a particular
> + * user namespace value when crossing the kernel/user boundary.
> + */
> +static inline __uint32_t xfs_kuid_to_uid(kuid_t uid)
> +{
> +	return from_kuid(&init_user_ns, uid);
> +}
> +
> +static inline kuid_t xfs_uid_to_kuid(__uint32_t uid)
> +{
> +	return make_kuid(&init_user_ns, uid);
> +}
> +
> +static inline __uint32_t xfs_kgid_to_gid(kgid_t gid)
> +{
> +	return from_kgid(&init_user_ns, gid);
> +}
> +
> +static inline kgid_t xfs_gid_to_kgid(__uint32_t gid)
> +{
> +	return make_kgid(&init_user_ns, gid);
> +}

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
