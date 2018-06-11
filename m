Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33432 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933385AbeFKSGt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jun 2018 14:06:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5BI5oxw144085
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 18:06:48 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2jgecxdtq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 18:06:48 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5BI6m3O017132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 18:06:48 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5BI6moj010053
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 18:06:48 GMT
Date: Mon, 11 Jun 2018 11:06:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 24/27] xfsprogs: Add parent pointers to recreated
 inodes
Message-ID: <20180611180647.GF22045@magnolia>
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
 <1528607272-11122-25-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1528607272-11122-25-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Jun 09, 2018 at 10:07:49PM -0700, Allison Henderson wrote:
> Inodes that are not recovered from the orphanage will
> be recreated, so we will need to re-add the parent pointers
> here too.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  libxfs/libxfs_api_defs.h |  1 +
>  repair/phase6.c          | 40 +++++++++++++++++++++++++++-------------
>  2 files changed, 28 insertions(+), 13 deletions(-)
> 
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 78daca0..4b47479 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -152,5 +152,6 @@
>  #define xfs_rmap_compare		libxfs_rmap_compare
>  #define xfs_dir_get_ops			libxfs_dir_get_ops
>  #define xfs_default_ifork_ops		libxfs_default_ifork_ops
> +#define xfs_parent_add    		libxfs_parent_add
>  
>  #endif /* __LIBXFS_API_DEFS_H__ */
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 4fedb35..96ffade 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -29,6 +29,7 @@
>  #include "dinode.h"
>  #include "progress.h"
>  #include "versions.h"
> +#include "xfs_parent.h"
>  
>  static struct cred		zerocr;
>  static struct fsxattr 		zerofsx;
> @@ -962,19 +963,20 @@ mk_root_dir(xfs_mount_t *mp)
>  static xfs_ino_t
>  mk_orphanage(xfs_mount_t *mp)
>  {
> -	xfs_ino_t	ino;
> -	xfs_trans_t	*tp;
> -	xfs_inode_t	*ip;
> -	xfs_inode_t	*pip;
> -	xfs_fsblock_t	first;
> -	ino_tree_node_t	*irec;
> -	int		ino_offset = 0;
> -	int		i;
> -	int		error;
> +	xfs_ino_t		ino;
> +	struct xfs_trans	*tp;
> +	struct xfs_inode	*ip;
> +	struct xfs_inode	*pip;
> +	xfs_fsblock_t		first;
> +	struct ino_tree_node	*irec;
> +	int			ino_offset = 0;
> +	int			i;
> +	int			error;
>  	struct xfs_defer_ops	dfops;
> -	const int	mode = 0755;
> -	int		nres;
> -	struct xfs_name	xname;
> +	const int		mode = 0755;
> +	int			nres;
> +	struct xfs_name		xname;
> +	xfs_dir2_dataptr_t      offset;
>  
>  	/*
>  	 * check for an existing lost+found first, if it exists, return
> @@ -1061,7 +1063,7 @@ mk_orphanage(xfs_mount_t *mp)
>  	 * create the actual entry
>  	 */
>  	error = -libxfs_dir_createname(tp, pip, &xname, ip->i_ino, &first,
> -					&dfops, nres, NULL);
> +					&dfops, nres, &offset);
>  	if (error)
>  		do_error(
>  		_("can't make %s, createname error %d\n"),
> @@ -1083,6 +1085,18 @@ mk_orphanage(xfs_mount_t *mp)
>  	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
>  	libxfs_defer_ijoin(&dfops, ip);
> +
> +        if (xfs_sb_version_hasparent(&mp->m_sb)) {
> +                error = -libxfs_parent_add(pip, ip, &xname, offset,

Tabs, not spaces for the indenting.

> +				       &first, &dfops);
> +                if (error)
> +                        do_error(_("Error creating parent pointer: %d\n"),
> +				 error);
> +		libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
> +		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +		libxfs_defer_ijoin(&dfops, pip);

/me wonders if it's really necessary to _defer_ijoin either of the
inodes to the transaction since we commit and IRELE both of them
immediately afterwards...

--D

> +        }
> +
>  	error = -libxfs_defer_finish(&tp, &dfops);
>  	if (error) {
>  		do_error(_("%s directory creation failed -- bmapf error %d\n"),
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
