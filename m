Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0PEMuD2131928 for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 08:22:57 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 658851BAB776
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 06:22:13 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Gara7aoU4jQVzgwU for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 06:22:13 -0800 (PST)
Message-ID: <497C7594.8080804@sandeen.net>
Date: Sun, 25 Jan 2009 08:22:12 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix 122 for removed btree types
References: <20090122220446.GA8723@infradead.org>
In-Reply-To: <20090122220446.GA8723@infradead.org>
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

Christoph Hellwig wrote:
> With the the btree refactoring various btree trypes have been removed,
> so remove them from the golden output for 122.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfstests-dev/122.out
> ===================================================================
> --- xfstests-dev.orig/122.out	2009-01-04 19:22:15.000000000 +0000
> +++ xfstests-dev/122.out	2009-01-04 19:22:31.000000000 +0000
> @@ -65,10 +65,6 @@
>  sizeof( xfs_bmbt_rec_64_t ) = 16
>  sizeof( xfs_bmdr_block_t ) = 4
>  sizeof( xfs_btnum_t ) = 4
> -sizeof( xfs_btree_block_t ) = 24
> -sizeof( xfs_btree_hdr_t ) = 8
> -sizeof( xfs_btree_lblock_t ) = 24
> -sizeof( xfs_btree_sblock_t ) = 16
>  sizeof( xfs_buf_log_format_t ) = 24
>  sizeof( xfs_da_blkinfo_t ) = 12
>  sizeof( xfs_da_intnode_t ) = 24
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
