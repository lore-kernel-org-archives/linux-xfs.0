Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 733237F3F
	for <xfs@oss.sgi.com>; Sun, 24 Nov 2013 21:34:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 494DF304051
	for <xfs@oss.sgi.com>; Sun, 24 Nov 2013 19:34:50 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id wqi95k3FaGFATLWX for <xfs@oss.sgi.com>;
	Sun, 24 Nov 2013 19:34:49 -0800 (PST)
Message-ID: <5292C557.9020008@sandeen.net>
Date: Sun, 24 Nov 2013 21:34:47 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: return ENOSPC when trying to set more ACLs than
	XFS_ACL_MAX_ENTRIES
References: <52921D12.7040104@oracle.com>
In-Reply-To: <52921D12.7040104@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 11/24/13, 9:36 AM, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> We currently return EINVAL when trying to set more ACL entries than
> XFS_ACL_MAX_ENTRIES(), but it would be a bit more meaningful to return
> ENOSPC in this situation, because the later is used to indicate there
> is no more space to store new ACLs IMHO.

I'm not quite convinced that it's better; the user will get an
error string of "no space left on device" which is misleading too,
and I'd argue that it's no better than "invalid argument."

To me, I think it's not worth changing, but others may disagree.

(I guess looking at ext4, it uses ENOSPC for some similar constraints,
so maybe three is precedent for this)

The setxattr(2) man page says:

> If there is insufficient space remaining to store the extended
> attribute, errno is set to either ENOSPC

but it doesn't say space in _what_ ...

-Eric

> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/xfs/xfs_acl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 370eb3e..4e54a4d 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -397,7 +397,7 @@ xfs_xattr_acl_set(struct dentry *dentry, const char *name,
>  	if (error)
>  		goto out_release;
>  
> -	error = -EINVAL;
> +	error = -ENOSPC;
>  	if (acl->a_count > XFS_ACL_MAX_ENTRIES(XFS_M(inode->i_sb)))
>  		goto out_release;
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
