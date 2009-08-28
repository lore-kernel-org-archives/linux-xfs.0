Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7SH2Q2B166228 for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 12:02:36 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CD8828F80F4
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 10:03:20 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfs: simplify xfs_trans_iget
Date: Fri, 28 Aug 2009 12:02:06 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ABE9@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090826204701.GA31870@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

I have a couple of comments below--things I haven't convinced
myself of yet--but overall this looks good, and is an improvement.

					-Alex

Christoph Hellwig wrote:
> xfs_trans_iget is a wrapper for xfs_iget that adds the inode to the
> transaction after it is read.  Except when the inode already is in the
> inode cache, in which case it returns the existing locked inode with
> increment lock recursion counts.
> 
> Now, no one in the tree every decrements these lock recursion counts,
> so any user of this gets a potential double unlock when both the
> original owner of the inode and the xfs_trans_iget caller unlock it. 
> When looking 
> back in a git bisect in the historic XFS tree there was only one place
> that decremented these counts, xfs_trans_iput.  Introduced in commit
> ca25df7a840f426eb566d52667b6950b92bb84b5 by Adam Sweeney in 1993,
> and removed in commit 19f899a3ab155ff6a49c0c79b06f2f61059afaf3 by
> Steve Lord in 2003.  And as long as it didn't slip through git bisects
> cracks never actually used in that time frame.
> 
> A quick audit of the callers of xfs_trans_iget shows that no caller
> really relies on this behaviour fortunately - xfs_ialloc allows this
> inode from disk so it must not be there before, and all the RT
> allocator routines only every add each RT bitmap inode once.
> 
> In addition to removing lots of code and reducing the size of the
> inode item this patch also avoids the double inode cache lookup in each
> create/mkdir/mknod transaction.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/fs/xfs/xfs_iget.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_iget.c	2009-08-26 14:14:32.113357904
> -0300 +++ linux-2.6/fs/xfs/xfs_iget.c	2009-08-26 14:15:40.613392686
> -0300 @@ -456,32 +456,6 @@ out_error_or_again:
>  	return error;
>  }
> 
> -
> -/*
> - * Look for the inode corresponding to the given ino in the hash
> table. 
> - * If it is there and its i_transp pointer matches tp, return it.
> - * Otherwise, return NULL.
> - */
> -xfs_inode_t *
> -xfs_inode_incore(xfs_mount_t	*mp,
> -		 xfs_ino_t	ino,
> -		 xfs_trans_t	*tp)
> -{
> -	xfs_inode_t	*ip;
> -	xfs_perag_t	*pag;
> -
> -	pag = xfs_get_perag(mp, ino);
> -	read_lock(&pag->pag_ici_lock);
> -	ip = radix_tree_lookup(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp,
> ino)); 
> -	read_unlock(&pag->pag_ici_lock);
> -	xfs_put_perag(mp, pag);
> -
> -	/* the returned inode must match the transaction */
> -	if (ip && (ip->i_transp != tp))
> -		return NULL;


This function was only ever called as a helper by xfs_trans_iget().
And it does the same things as xfs_iget() does, but in a more
restricted  context.  One difference I see is that this verifies
the transaction pointers match--and if they do not, it returns NULL.

In xfs_iget(), meanwhile, there is no such check.  I'm not familiar
enough with the transaction code to know what circumstances that
might lead a hashed inode without a matching transaction pointer,
but thought I'd point it out anyway in hopes you maybe did...


> -	return ip;
> -}
> -
>  /*
>   * Decrement reference count of an inode structure and unlock it.
>   *

. . .

> Index: linux-2.6/fs/xfs/xfs_trans_inode.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_trans_inode.c	2009-08-26 14:15:45.689894519 -0300
> +++ linux-2.6/fs/xfs/xfs_trans_inode.c	2009-08-26 14:17:14.434495492 -0300

. . .

> @@ -163,8 +89,6 @@ xfs_trans_ijoin(
>  		xfs_inode_item_init(ip, ip->i_mount);
>  	iip = ip->i_itemp;
>  	ASSERT(iip->ili_flags == 0);
> -	ASSERT(iip->ili_ilock_recur == 0);
> -	ASSERT(iip->ili_iolock_recur == 0);

These are the only other references, and (assuming we've done
a lot of testing with ASSERT() enabled) it is evident that
these are always zero at this point.  In any case, what this
means is that xfs_trans_ijoin() must never be called after
xfs_trans_iget() has been called on a hashed inode.  Again,
I'm not familiar enough with how we manage transactions to
to verify by inspection this is the case, but I presume it is.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
