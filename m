Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Feb 2007 05:05:40 -0800 (PST)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l17D5Sm9002340
	for <xfs@oss.sgi.com>; Wed, 7 Feb 2007 05:05:32 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l17Csbb2007791
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 7 Feb 2007 13:54:38 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l17Csb8m007789
	for xfs@oss.sgi.com; Wed, 7 Feb 2007 13:54:37 +0100
Date: Wed, 7 Feb 2007 13:54:37 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fix sparse warning in xfs_da_btree.c
Message-ID: <20070207125437.GA7740@lst.de>
References: <20061129154441.GA6400@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061129154441.GA6400@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wed, Nov 29, 2006 at 04:44:41PM +0100, Christoph Hellwig wrote:
> The first use in xfs_da_node_lookup_int would have to be __be32.
> But we can just remove this temporary variable use completely and
> make sparse happy.  The variable is used later in the function for
> a native endian variable so we'll have to keep it.

ping?

> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
> index a68bc1f..cccf69e 100644
> --- a/fs/xfs/xfs_da_btree.c
> +++ b/fs/xfs/xfs_da_btree.c
> @@ -1090,8 +1090,7 @@ xfs_da_node_lookup_int(xfs_da_state_t *s
>  		if (blk->magic == XFS_DA_NODE_MAGIC) {
>  			node = blk->bp->data;
>  			max = be16_to_cpu(node->hdr.count);
> -			btreehashval = node->btree[max-1].hashval;
> -			blk->hashval = be32_to_cpu(btreehashval);
> +			blk->hashval = be32_to_cpu(node->btree[max-1].hashval);
>  
>  			/*
>  			 * Binary search.  (note: small blocks will skip loop)
---end quoted text---
