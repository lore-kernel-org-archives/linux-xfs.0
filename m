Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 48E717F66
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 00:20:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2AFA830404E
	for <xfs@oss.sgi.com>; Wed, 22 Jul 2015 22:20:06 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id IL3fqKAvKla8x1HE for <xfs@oss.sgi.com>;
	Wed, 22 Jul 2015 22:20:04 -0700 (PDT)
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] xfs: set XFS_DA_OP_OKNOENT in xfs_attr_get
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <55B07496.9060207@redhat.com>
Date: Thu, 23 Jul 2015 00:20:03 -0500
Message-Id: <64D3B2DB-5FBB-41A9-8544-1635D474240E@sandeen.net>
References: <55B07496.9060207@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Jul 22, 2015, at 11:59 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> 
> It's entirely possible for userspace to ask for an xattr which
> does not exist.
> 
> Normally, there is no problem whatsoever when we ask for such
> a thing, but when we look at an obfuscated metadump image
> on a debug kernel with selinux, we trip over this ASSERT in
> xfs_da3_path_shift():
> 
>        *result = -ENOENT;      /* we're out of our tree */
>        ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
> 
> It (more or less) only shows up in the above scenario, because
> xfs_metadump obfuscates attr names, but chooses names which
> keep the same hash value - and xfs_da3_node_lookup_int does:
> 
>        if (((retval == -ENOENT) || (retval == -ENOATTR)) &&
>            (blk->hashval == args->hashval)) {
>                error = xfs_da3_path_shift(state, &state->path, 1, 1,
>                                                 &retval);


Oh, and add: thanks to dchinner for spotting the above conditional that got us there ;)

-Eric

> IOWS, we only get down to the xfs_da3_path_shift() ASSERT
> if we are looking for an xattr which doesn't exist, but we
> find xattrs on disk which have the same hash, and so might be
> a hash collision, so we try the path shift.  When *that*
> fails to find what we're looking for, we hit the assert about
> XFS_DA_OP_OKNOENT.
> 
> Simply setting XFS_DA_OP_OKNOENT in xfs_attr_get solves this
> rather corner-case problem with no ill side effects.  It's
> fine for an attr name lookup to fail.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 3349c9a..ff06557 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -139,6 +139,8 @@ xfs_attr_get(
> 
>    args.value = value;
>    args.valuelen = *valuelenp;
> +    /* Entirely possible to look up a name which doesn't exist */
> +    args.op_flags = XFS_DA_OP_OKNOENT;
> 
>    lock_mode = xfs_ilock_attr_map_shared(ip);
>    if (!xfs_inode_hasattr(ip))
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
