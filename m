Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 882147F5F
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 11:06:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 74548304059
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 09:06:27 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id dUVBoa5RWqQyQrZ2 for <xfs@oss.sgi.com>;
	Wed, 02 Sep 2015 09:06:26 -0700 (PDT)
Subject: Re: [PATCH] xfs_repair: update btree ptr when attr node level moves
	to next buffer
References: <1441200906-37170-1-git-send-email-bfoster@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <55E71E80.3070508@sandeen.net>
Date: Wed, 2 Sep 2015 11:06:24 -0500
MIME-Version: 1.0
In-Reply-To: <1441200906-37170-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com
Cc: Eryu Guan <eguan@redhat.com>

On 9/2/15 8:35 AM, Brian Foster wrote:
> xfs_repair walks the attribute fork btree for files with a significant
> number of extended attributes. It creates a cursor, walks the leaf
> blocks, and verifies the path from each leaf block back to the root of
> the tree. Eryu reports that the following test causes xfs_repair to
> report corruption on 512b filesystems:
> 
> 	num_xattrs=577
> 	for ((i = 1; i <= $num_xattrs; i++)); do
> 		name="user.attr_$(printf "%04d" $i)"
> 		setfattr -n $name -v "val_$(printf "%04d" $i)" <file>
> 	done
> 
> xfs_repair complains that the block number of the leaf (level 0) does
> not match the block number of the level 1 node block entry. This occurs
> as soon as the left-most level 1 node block is completely processed and
> the cursor is walked to the next level 1 block in the array. The problem
> is that while verify_da_path() updates level 1 of the cursor to the next
> level 1 buffer, it fails to correctly update the btree pointer to the
> entry list of the new buffer. As a result, the child leaf block of the
> next node block is incorrectly validated against the entry list of the
> previous node block.
> 
> Update verify_da_path() to correctly update the btree pointer to the
> entry list of the new node block when the cursor is walked forward at
> higher (non-leaf) levels.
> 
> Reported-by: Eryu Guan <eguan@redhat.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  repair/attr_repair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 83a07a8..b76618a 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -562,7 +562,7 @@ verify_da_path(xfs_mount_t	*mp,
>  		}
>  
>  		newnode = (xfs_da_intnode_t *)XFS_BUF_PTR(bp);
> -		btree = M_DIROPS(mp)->node_tree_p(node);
> +		btree = M_DIROPS(mp)->node_tree_p(newnode);
>  		M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, newnode);
>  
>  		/*
> 

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Incidentally, the same (correct) logic exists in verify_dir2_path()

Looks like it was just a thinko or cut/paste error here, originally.

(Incidentally^2, I wonder if we should combine those functions, they
are remarkably similar yet slightly divergent)

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
