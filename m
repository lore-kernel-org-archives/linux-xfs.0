Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 334287CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 12:54:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 05A558F8040
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 10:54:27 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9quhLL7DiZjHJZ6C (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 15 Feb 2016 10:54:27 -0800 (PST)
Date: Mon, 15 Feb 2016 13:54:25 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: sanitize remount options
Message-ID: <20160215185424.GB33291@bfoster.bfoster>
References: <56BBC982.50804@redhat.com>
 <56BBCA55.3000506@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56BBCA55.3000506@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, Feb 10, 2016 at 05:40:05PM -0600, Eric Sandeen wrote:
> Perform basic sanitization of remount options by
> passing the option string and a dummy mount structure
> through xfs_parseargs and returning the result.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 934233a..d1cd4fa 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1168,6 +1168,27 @@ xfs_quiesce_attr(
>  }
>  
>  STATIC int
> +xfs_test_remount_options(
> +	struct super_block	*sb,
> +	struct xfs_mount	*mp,
> +	char			*options)
> +{
> +	int			error = 0;
> +	struct xfs_mount	*tmp;
> +
> +	tmp = kmem_zalloc(sizeof(*tmp), KM_MAYFAIL);
> +	if (!tmp)
> +		return -ENOMEM;
> +
> +	tmp->m_super = sb;
> +	error = xfs_parseargs(tmp, options);
> +	xfs_free_fsname(tmp);
> +	kfree(tmp);
> +
> +	return error;
> +}

This seems fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

... though I get a little bit nervous about xfs_parseargs() changing
some other data structure down the road. I wonder if we should constify
the sb pointer in xfs_parseargs() with a quick comment as to why..?

Brian

> +
> +STATIC int
>  xfs_fs_remount(
>  	struct super_block	*sb,
>  	int			*flags,
> @@ -1179,6 +1200,11 @@ xfs_fs_remount(
>  	char			*p;
>  	int			error;
>  
> +	/* First, check for complete junk; i.e. invalid options */
> +	error = xfs_test_remount_options(sb, mp, options);
> +	if (error)
> +		return error;
> +
>  	sync_filesystem(sb);
>  	while ((p = strsep(&options, ",")) != NULL) {
>  		int token;
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
