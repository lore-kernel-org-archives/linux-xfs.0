Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C5EF67CA0
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 09:10:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9770530404E
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 07:10:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uOoyHEw7zXl4K51Y (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 07:10:29 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 9469E81135
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 14:10:28 +0000 (UTC)
Date: Thu, 5 May 2016 10:10:26 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/7] xfs: configurable error behavior via sysfs
Message-ID: <20160505141026.GA1231@bfoster.bfoster>
References: <1462376600-8617-1-git-send-email-cmaiolino@redhat.com>
	<1462376600-8617-2-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462376600-8617-2-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, May 04, 2016 at 05:43:14PM +0200, Carlos Maiolino wrote:
> We need to be able to change the way XFS behaviours in error
> conditions depending on the type of underlying storage. This is
> necessary for handling non-traditional block devices with extended
> error cases, such as thin provisioned devices that can return ENOSPC
> as an IO error.
> 
> Introduce the basic sysfs infrastructure needed to define and
> configure error behaviours. This is done to be generic enough to
> extend to configuring behaviour in other error conditions, such as
> ENOMEM, which also has different desired behaviours according to
> machine configuration.
> 
> Changelog:
> 
> V3:
> 	- Rebase patch on top of linux-xfs tree
> 	- Remove XFS_ERR_FAIL enums, once we are not using them
> 	  to control the fail speed, but base it on max_retries value
> 	- Get rid of xfs_error_cfg.fail_speed field. We will use only
> 	  .max_retries to control the failure speed for each error
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_mount.c | 10 +++++++++-
>  fs/xfs/xfs_mount.h | 20 ++++++++++++++++++++
>  fs/xfs/xfs_sysfs.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_sysfs.h |  3 +++
>  4 files changed, 84 insertions(+), 2 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 6ced4f1..b971113 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -17,10 +17,11 @@
>   */
>  
>  #include "xfs.h"
> -#include "xfs_sysfs.h"
> +#include "xfs_shared.h"
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> +#include "xfs_sysfs.h"
>  #include "xfs_log.h"
>  #include "xfs_log_priv.h"
>  #include "xfs_stats.h"
> @@ -362,3 +363,53 @@ struct kobj_type xfs_log_ktype = {
>  	.sysfs_ops = &xfs_sysfs_ops,
>  	.default_attrs = xfs_log_attrs,
>  };
> +
> +/*
> + * Metadata IO error configuration
> + *
> + * The sysfs structure here is:
> + *	...xfs/<dev>/error/<class>/<errno>/<error_attrs>
> + *
> + * where <class> allows use to discriminate between data IO and metadata IO,

Spelling:		   us

Otherwise looks fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> + * and any other future type of IO (e.g. special inode or directory error
> + * handling) we care to support.
> + */
> +static struct attribute *xfs_error_attrs[] = {
> +	NULL,
> +};
> +
> +static inline struct xfs_error_cfg *
> +to_error_cfg(struct kobject *kobject)
> +{
> +	struct xfs_kobj *kobj = to_kobj(kobject);
> +	return container_of(kobj, struct xfs_error_cfg, kobj);
> +}
> +
> +struct kobj_type xfs_error_cfg_ktype = {
> +	.release = xfs_sysfs_release,
> +	.sysfs_ops = &xfs_sysfs_ops,
> +	.default_attrs = xfs_error_attrs,
> +};
> +
> +struct kobj_type xfs_error_ktype = {
> +	.release = xfs_sysfs_release,
> +};
> +
> +int
> +xfs_error_sysfs_init(
> +	struct xfs_mount	*mp)
> +{
> +	int			error;
> +
> +	/* .../xfs/<dev>/error/ */
> +	error = xfs_sysfs_init(&mp->m_error_kobj, &xfs_error_ktype,
> +				&mp->m_kobj, "error");
> +	return error;
> +}
> +
> +void
> +xfs_error_sysfs_del(
> +	struct xfs_mount	*mp)
> +{
> +	xfs_sysfs_del(&mp->m_error_kobj);
> +}
> diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
> index be692e5..d046371 100644
> --- a/fs/xfs/xfs_sysfs.h
> +++ b/fs/xfs/xfs_sysfs.h
> @@ -58,4 +58,7 @@ xfs_sysfs_del(
>  	wait_for_completion(&kobj->complete);
>  }
>  
> +int	xfs_error_sysfs_init(struct xfs_mount *mp);
> +void	xfs_error_sysfs_del(struct xfs_mount *mp);
> +
>  #endif	/* __XFS_SYSFS_H__ */
> -- 
> 2.4.11
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
