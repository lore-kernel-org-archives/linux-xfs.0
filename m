Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8EDBA7CB1
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 09:10:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 35D168F804B
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 07:10:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DZMFVAzoJPUeLDxB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 07:10:47 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 8C856C049E1A
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 14:10:47 +0000 (UTC)
Date: Thu, 5 May 2016 10:10:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/7] xfs: introduce table-based init for error behaviors
Message-ID: <20160505141045.GD1231@bfoster.bfoster>
References: <1462376600-8617-1-git-send-email-cmaiolino@redhat.com>
	<1462376600-8617-5-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462376600-8617-5-git-send-email-cmaiolino@redhat.com>
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

On Wed, May 04, 2016 at 05:43:17PM +0200, Carlos Maiolino wrote:
> Before we start expanding the number of error classes and errors we
> can configure behaviour for, we need a simple and clear way to
> define the default behaviour that we initialized each mount with.
> Introduce a table based method for keeping the initial configuration
> in, and apply that to the existing initialization code.
> 
> Changelog:
> 
> V3:
> 	- Replace all .fail_speed fields by .max_retries, once the code will no
> 	  longer use .fail_speed to decide when it should fail
> 	- The "Default" attribute is also in lower-case (default). I don't
> 	  believe it's a good idea to have a mixed-case attribute names in sysfs.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_sysfs.c | 72 +++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 60 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 0a9adcd..2a5b1cf 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -395,11 +395,67 @@ struct kobj_type xfs_error_ktype = {
>  	.release = xfs_sysfs_release,
>  };
>  
> +/*
> + * Error initialization tables. These need to be ordered in the same
> + * order as the enums used to index the array. All class init tables need to
> + * define a "default" behaviour as the first entry, all other entries can be
> + * empty.
> + */
> +struct xfs_error_init {
> +	char		*name;
> +	int		max_retries;
> +};
> +
> +static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
> +	{ .name = "default",
> +	  .max_retries = -1,
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
> +		cfg->max_retries = init[i].max_retries;
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
> @@ -409,22 +465,14 @@ xfs_error_sysfs_init(
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
> -				&mp->m_error_meta_kobj, "default");
> -	if (error)
> -		goto out_error_meta;
> -	cfg->max_retries = -1;
> -
>  	return 0;
>  
> -out_error_meta:
> -	xfs_sysfs_del(&mp->m_error_meta_kobj);
>  out_error:
>  	xfs_sysfs_del(&mp->m_error_kobj);
>  	return error;
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
