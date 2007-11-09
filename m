Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Nov 2007 17:08:59 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA918kYk022102
	for <xfs@oss.sgi.com>; Thu, 8 Nov 2007 17:08:52 -0800
Message-ID: <4733B34F.70407@sgi.com>
Date: Fri, 09 Nov 2007 12:09:35 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [patch] Fix broken inode clustering
References: <20071108003848.GA66820511@sgi.com>
In-Reply-To: <20071108003848.GA66820511@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Looks good Dave.

David Chinner wrote:
> The radix tree based inode caches did away with the inode cluster hashes,
> replacing them with a bunch of masking and gang lookups on the radix tree.
> 
> This masking got broken when moving the code to per-ag radix trees and
> indexing by agino # rather than straight inode number. The result is
> clustered inode writeback does not cluster and things can go extremely
> slowly when there are lots of inodes to write.
> 
> The following patch fixes this up by comparing agino # of the inode
> found to the index of the cluster we are looking for.
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> Tested-by: Torsten Kaiser <just.for.lkml@googlemail.com>
> 
> ---
>  fs/xfs/xfs_iget.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: 2.6.x-xfs-new/fs/xfs/xfs_iget.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_iget.c	2007-11-02 13:44:46.000000000 +1100
> +++ 2.6.x-xfs-new/fs/xfs/xfs_iget.c	2007-11-07 13:08:42.534440675 +1100
> @@ -248,7 +248,7 @@ finish_inode:
>  	icl = NULL;
>  	if (radix_tree_gang_lookup(&pag->pag_ici_root, (void**)&iq,
>  							first_index, 1)) {
> -		if ((iq->i_ino & mask) == first_index)
> +		if ((XFS_INO_TO_AGINO(mp, iq->i_ino) & mask) == first_index)
>  			icl = iq->i_cluster;
>  	}
>  
> 
> 
> 
