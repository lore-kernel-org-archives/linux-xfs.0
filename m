Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBCNGW0x127300 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 17:16:33 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B54D7156EE57
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 15:16:31 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	TG8g8FCwRGQIDcOz for <xfs@oss.sgi.com>;
	Mon, 12 Dec 2011 15:16:31 -0800 (PST)
Date: Tue, 13 Dec 2011 10:16:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/12] repair: allocate and free inode records individually
Message-ID: <20111212231629.GV14273@dastard>
References: <20111202174619.179530033@bombadil.infradead.org>
	<20111202174741.284403190@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111202174741.284403190@bombadil.infradead.org>
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

On Fri, Dec 02, 2011 at 12:46:21PM -0500, Christoph Hellwig wrote:
> Instead of allocating inode records in chunks and keeping a freelist of them
> which never gets released to the system memory allocator use plain malloc
> and free for them.  The freelist just means adding a global lock instead
> of relying on malloc and free which could be implemented lockless, and the
> freelist is almost completely worthless as we are done allocating new
> inode records once we start freeing them in major quantities.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

OK, the freelist has been there since at least before the start of
the git tree history, but the locking was added as part of the
threading of repair back in 2007....

It looks to me like the allocation strategy is similar to the way
log tickets used to be allocated - a roll-your-own slab cache to
work around an inefficient memory allocator....

.....
> -	/* initialize node */
> -
> -	ino_rec->ino_startnum = 0;
> -	ino_rec->ino_confirmed = 0;
> -	ino_rec->ino_isa_dir = 0;
> -	ino_rec->ir_free = (xfs_inofree_t) - 1;
> -	ino_rec->ino_un.ex_data = NULL;
> -	ino_rec->nlinkops = &nlinkops[0];
> -	ino_rec->disk_nlinks = calloc(1, nlinkops[0].nlink_size);
> -	if (ino_rec->disk_nlinks == NULL)
> +	irec = malloc(sizeof(*irec));
> +	if (!irec)
> +		do_error(_("inode map malloc failed\n"));
> +
> +	irec->avl_node.avl_nextino = NULL;
> +	irec->avl_node.avl_forw = NULL;
> +	irec->avl_node.avl_back = NULL;
> +
> +	irec->ino_startnum = starting_ino;

OK, so you moved this initialisation into the init function instead
of doing it externally. Seems OK - both callers do post-init of
this, so no reason why not to do it here.

Everything else looks fine. the renaming of mk_ino_tree_nodes()
makes it kind of obvious now what that function is doing, too, so
that is good...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
