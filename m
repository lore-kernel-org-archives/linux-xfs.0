Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6B97B7CB1
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 12:34:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F3AE3AC001
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 10:34:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Jm07AzBbtalhVc0p (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 17 Jun 2016 10:34:29 -0700 (PDT)
Date: Fri, 17 Jun 2016 13:34:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 003/119] xfs: check offsets of variable length structures
Message-ID: <20160617173426.GA46309@bfoster.bfoster>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612629195.12839.14090954204243398929.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612629195.12839.14090954204243398929.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Thu, Jun 16, 2016 at 06:18:12PM -0700, Darrick J. Wong wrote:
> Some of the directory/attr structures contain variable-length objects,
> so the enclosing structure doesn't have a meaningful fixed size at
> compile time.  We can check the offsets of the members before the
> variable-length member, so do those.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

I'm missing why this is necessary. Is the intent still to catch
alignment and/or padding issues? If so, isn't the size check sufficient,
regardless of trailing variable size fields?

Perhaps the goal here is to reduce the scope of checking from where it
isn't needed..? For example, xfs_dir2_data_unused_t looks like it has a
field where the offset in the structure is irrelevant, so that's a
possible false positive if that changes down the road. On the flip side,
that doesn't appear to be the case for other structures such as
xfs_attr_leaf_name_[local|remote]_t.

Brian

>  fs/xfs/xfs_ondisk.h |   25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 184c44e..0272301 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -22,6 +22,11 @@
>  	BUILD_BUG_ON_MSG(sizeof(structname) != (size), "XFS: sizeof(" \
>  		#structname ") is wrong, expected " #size)
>  
> +#define XFS_CHECK_OFFSET(structname, member, off) \
> +	BUILD_BUG_ON_MSG(offsetof(structname, member) != (off), \
> +		"XFS: offsetof(" #structname ", " #member ") is wrong, " \
> +		"expected " #off)
> +
>  static inline void __init
>  xfs_check_ondisk_structs(void)
>  {
> @@ -75,15 +80,28 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_remote_t,	12);
>  	 */
>  
> +	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, valuelen,	0);
> +	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, namelen,	2);
> +	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, nameval,	3);
> +	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, valueblk,	0);
> +	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, valuelen,	4);
> +	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, namelen,	8);
> +	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, name,	9);
>  	XFS_CHECK_STRUCT_SIZE(xfs_attr_leafblock_t,		40);
> -	XFS_CHECK_STRUCT_SIZE(xfs_attr_shortform_t,		8);
> +	XFS_CHECK_OFFSET(xfs_attr_shortform_t, hdr.totsize,	0);
> +	XFS_CHECK_OFFSET(xfs_attr_shortform_t, hdr.count,	2);
> +	XFS_CHECK_OFFSET(xfs_attr_shortform_t, list[0].namelen,	4);
> +	XFS_CHECK_OFFSET(xfs_attr_shortform_t, list[0].valuelen, 5);
> +	XFS_CHECK_OFFSET(xfs_attr_shortform_t, list[0].flags,	6);
> +	XFS_CHECK_OFFSET(xfs_attr_shortform_t, list[0].nameval,	7);
>  	XFS_CHECK_STRUCT_SIZE(xfs_da_blkinfo_t,			12);
>  	XFS_CHECK_STRUCT_SIZE(xfs_da_intnode_t,			16);
>  	XFS_CHECK_STRUCT_SIZE(xfs_da_node_entry_t,		8);
>  	XFS_CHECK_STRUCT_SIZE(xfs_da_node_hdr_t,		16);
>  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_data_free_t,		4);
>  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_data_hdr_t,		16);
> -	XFS_CHECK_STRUCT_SIZE(xfs_dir2_data_unused_t,		6);
> +	XFS_CHECK_OFFSET(xfs_dir2_data_unused_t, freetag,	0);
> +	XFS_CHECK_OFFSET(xfs_dir2_data_unused_t, length,	2);
>  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_free_hdr_t,		16);
>  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_free_t,			16);
>  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_ino4_t,			4);
> @@ -94,6 +112,9 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_t,			16);
>  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_tail_t,		4);
>  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_entry_t,		3);
> +	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, namelen,		0);
> +	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, offset,		1);
> +	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, name,		3);
>  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_hdr_t,		10);
>  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_off_t,		2);
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
