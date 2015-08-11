Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BCCF629DF6
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 09:19:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 45980AC008
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 07:19:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JpPN8NHg5QttHjU8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Aug 2015 07:19:05 -0700 (PDT)
Date: Tue, 11 Aug 2015 10:19:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 05/10] xfs: introduce table-based init for error behaviours
Message-ID: <20150811141902.GB59636@bfoster.bfoster>
References: <1438772921-28715-1-git-send-email-david@fromorbit.com>
	<1438772921-28715-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1438772921-28715-6-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 05, 2015 at 09:08:36PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Before we start expanding the number of error classes and errors we
> can configure behaviour for, we need a simple and clear way to
> define the default behaviour that we initialised each mount with.
> Introduce a table based method for keeping the initial configuration
> in, and apply that to the existing initialisation code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_sysfs.c | 72 +++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 60 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 3667d33..9d66095 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -303,11 +303,67 @@ struct kobj_type xfs_error_ktype = {
>  	.release = xfs_sysfs_release,
>  };
>  
> +/*
> + * Error initialisation tables. These need to be ordered in the same
> + * order as the enums used to index the array. All class init tables need to
> + * define a "default" behaviour as the first entry, all other entries can be
> + * empty.
> + */
> +struct xfs_error_init {
> +	char		*name;
> +	int		fail_speed;
> +};
> +
> +static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
> +	{ .name = "Default",
> +	  .fail_speed = XFS_ERR_FAIL_NEVER,
> +	},
> +};
> +
> +static int
> +xfs_error_sysfs_init_class(
> +	struct xfs_mount	*mp,
> +	int			class,
> +	const char		*parent_name,
> +	struct xfs_kobj		*parent_kobj,
> +	const struct xfs_error_init init[])
> +{
> +	struct xfs_error_cfg	*cfg;
> +	int			error;
> +	int			i;
> +
> +	ASSERT(class < XFS_ERR_CLASS_MAX);
> +
> +	error = xfs_sysfs_init(parent_kobj, &xfs_error_ktype,
> +				&mp->m_error_kobj, parent_name);

'parent_kobj' is a bit confusing of a name here since you're
initializing it as well. Perhaps 'base_kobj,' 'class_kobj,' or something
along those lines?

Brian

> +	if (error)
> +		return error;
> +
> +	for (i = 0; i < XFS_ERR_ERRNO_MAX; i++) {
> +		cfg = &mp->m_error_cfg[class][i];
> +		error = xfs_sysfs_init(&cfg->kobj, &xfs_error_cfg_ktype,
> +					parent_kobj, init[i].name);
> +		if (error)
> +			goto out_error;
> +
> +		cfg->fail_speed = init[i].fail_speed;
> +	}
> +	return 0;
> +
> +out_error:
> +	/* unwind the entries that succeeded */
> +	for (i--; i >= 0; i--) {
> +		cfg = &mp->m_error_cfg[class][i];
> +		xfs_sysfs_del(&cfg->kobj);
> +	}
> +	xfs_sysfs_del(parent_kobj);
> +	return error;
> +}
> +
>  int
>  xfs_error_sysfs_init(
>  	struct xfs_mount	*mp)
>  {
> -	struct xfs_error_cfg	*cfg;
>  	int			error;
>  
>  	/* .../xfs/<dev>/error/ */
> @@ -317,22 +373,14 @@ xfs_error_sysfs_init(
>  		return error;
>  
>  	/* .../xfs/<dev>/error/metadata/ */
> -	error = xfs_sysfs_init(&mp->m_error_meta_kobj, &xfs_error_ktype,
> -				&mp->m_error_kobj, "metadata");
> +	error = xfs_error_sysfs_init_class(mp, XFS_ERR_METADATA,
> +				"metadata", &mp->m_error_meta_kobj,
> +				xfs_error_meta_init);
>  	if (error)
>  		goto out_error;
>  
> -	cfg = &mp->m_error_cfg[XFS_ERR_METADATA][XFS_ERR_DEFAULT];
> -	error = xfs_sysfs_init(&cfg->kobj, &xfs_error_cfg_ktype,
> -				&mp->m_error_meta_kobj, "Default");
> -	if (error)
> -		goto out_error_meta;
> -	cfg->fail_speed = XFS_ERR_FAIL_NEVER;
> -
>  	return 0;
>  
> -out_error_meta:
> -	xfs_sysfs_del(&mp->m_error_meta_kobj);
>  out_error:
>  	xfs_sysfs_del(&mp->m_error_kobj);
>  	return error;
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
