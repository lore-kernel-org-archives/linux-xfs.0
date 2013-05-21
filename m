Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 261EC29DF8
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 09:03:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EAC778F804C
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 07:03:00 -0700 (PDT)
Message-ID: <519B7DE9.8030604@redhat.com>
Date: Tue, 21 May 2013 10:00:09 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 11/11] xfs: increase number of ACL entries for V5
	superblocks
References: <1369123330-9579-1-git-send-email-david@fromorbit.com>
	<1369123330-9579-12-git-send-email-david@fromorbit.com>
In-Reply-To: <1369123330-9579-12-git-send-email-david@fromorbit.com>
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
Cc: bpm@sgi.com, xfs@oss.sgi.com

On 05/21/2013 04:02 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The limit of 25 ACL entries is arbitrary, but baked into the on-disk
> format.  For version 5 superblocks, increase it to the maximum nuber
> of ACLs that can fit into a single xattr.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_acl.c |   31 ++++++++++++++++++-------------
>  fs/xfs/xfs_acl.h |   30 +++++++++++++++++++++++-------
>  2 files changed, 41 insertions(+), 20 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
> index 39632d9..5310a52 100644
> --- a/fs/xfs/xfs_acl.h
> +++ b/fs/xfs/xfs_acl.h
> @@ -22,19 +22,35 @@ struct inode;
>  struct posix_acl;
>  struct xfs_inode;
>  
> -#define XFS_ACL_MAX_ENTRIES 25
>  #define XFS_ACL_NOT_PRESENT (-1)
>  
>  /* On-disk XFS access control list structure */
> +struct xfs_acl_entry {
> +	__be32	ae_tag;
> +	__be32	ae_id;
> +	__be16	ae_perm;
> +	__be16	ae_pad;		/* fill the implicit hole in the structure */
> +};
> +
>  struct xfs_acl {
> -	__be32		acl_cnt;
> -	struct xfs_acl_entry {
> -		__be32	ae_tag;
> -		__be32	ae_id;
> -		__be16	ae_perm;
> -	} acl_entry[XFS_ACL_MAX_ENTRIES];
> +	__be32			acl_cnt;
> +	struct xfs_acl_entry	acl_entry[0];
>  };
>  
> +/*
> + * The number of ACL entries allowed is defined by the on-disk format.
> + * For v4 superblocks, that is limited to 25 entries. For v5 superblocks, it is
> + * limited only by the maximum size of the xattr that stores the information.
> + */
> +#define XFS_ACL_MAX_ENTRIES(mp)	\
> +	(xfs_sb_version_hascrc(&mp->m_sb) \
> +	   ?  (XATTR_SIZE_MAX - sizeof(__be32) / sizeof(struct xfs_acl_entry)) \
					
It looks like this should be:

	(XATTR_SIZE_MAX - sizeof(__be32)) / sizeof(struct xfs_acl_entry)

(i.e., misplaced parens)

Brian

> +	   : 25)
> +
> +#define XFS_ACL_SIZE(mp) \
> +	(sizeof(struct xfs_acl) + \
> +		sizeof(struct xfs_acl_entry) * XFS_ACL_MAX_ENTRIES((mp)))
> +
>  /* On-disk XFS extended attribute names */
>  #define SGI_ACL_FILE		(unsigned char *)"SGI_ACL_FILE"
>  #define SGI_ACL_DEFAULT		(unsigned char *)"SGI_ACL_DEFAULT"
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
