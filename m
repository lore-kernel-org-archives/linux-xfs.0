Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3E1137CBF
	for <xfs@oss.sgi.com>; Wed,  5 Jun 2013 08:26:00 -0500 (CDT)
Message-ID: <51AF3C69.2040903@sgi.com>
Date: Wed, 05 Jun 2013 08:26:01 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/4] xfs: increase number of ACL entries for V5 superblocks
References: <1370398150-12084-1-git-send-email-david@fromorbit.com>
	<1370398150-12084-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1370398150-12084-5-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 06/04/13 21:09, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The limit of 25 ACL entries is arbitrary, but baked into the on-disk
> format.  For version 5 superblocks, increase it to the maximum nuber
> of ACLs that can fit into a single xattr.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> Reviewed-by: Brian Foster<bfoster@redhat.com>
> ---

>   /* On-disk XFS access control list structure */
> +struct xfs_acl_entry {
> +	__be32	ae_tag;
> +	__be32	ae_id;
> +	__be16	ae_perm;
> +	__be16	ae_pad;		/* fill the implicit hole in the structure */
> +};
> +
>   struct xfs_acl {
> -	__be32		acl_cnt;
> -	struct xfs_acl_entry {
> -		__be32	ae_tag;
> -		__be32	ae_id;
> -		__be16	ae_perm;
> -	} acl_entry[XFS_ACL_MAX_ENTRIES];
> +	__be32			acl_cnt;
> +	struct xfs_acl_entry	acl_entry[0];
>   };
>
> +/*
> + * The number of ACL entries allowed is defined by the on-disk format.
> + * For v4 superblocks, that is limited to 25 entries. For v5 superblocks, it is
> + * limited only by the maximum size of the xattr that stores the information.
> + */
> +#define XFS_ACL_MAX_ENTRIES(mp)	\
> +	(xfs_sb_version_hascrc(&mp->m_sb) \
> +		?  (XATTR_SIZE_MAX - sizeof(struct xfs_acl)) / \
> +						sizeof(struct xfs_acl_entry) \
> +		: 25)
> +
> +#define XFS_ACL_MAX_SIZE(mp) \
> +	(sizeof(struct xfs_acl) + \
> +		sizeof(struct xfs_acl_entry) * XFS_ACL_MAX_ENTRIES((mp)))
> +
>   /* On-disk XFS extended attribute names */
>   #define SGI_ACL_FILE		(unsigned char *)"SGI_ACL_FILE"
>   #define SGI_ACL_DEFAULT		(unsigned char *)"SGI_ACL_DEFAULT"

I thought you would leave the XFS_ACL_MAX_ENTRIES(mp) as:


#define XFS_ACL_MAX_ENTRIES(mp)	\
	(xfs_sb_version_hascrc(&mp->m_sb) \
	   ?  (XATTR_SIZE_MAX - sizeof(__be32)) / sizeof(struct xfs_acl_entry) \
	   : 25)

and change the XFS_ACL_SIZE to:

#define XFS_ACL_SIZE(mp) \
	((offsetof(struct xfs_acl_entry, acl_entry) + \
		sizeof(struct xfs_acl_entry) *

since acl_entry[] is a place holder for the entry array.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
