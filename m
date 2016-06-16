Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D9DD17CA2
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 11:12:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B8E9304032
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 09:12:48 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id TnPQilSQ6Twb7D0a (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 09:12:45 -0700 (PDT)
Date: Thu, 16 Jun 2016 18:12:42 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 02/14] fs: introduce iomap infrastructure
Message-ID: <20160616161242.GB2106@quack2.suse.cz>
References: <1464792297-13185-1-git-send-email-hch@lst.de>
	<1464792297-13185-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1464792297-13185-3-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Wed 01-06-16 16:44:45, Christoph Hellwig wrote:
> Add infrastructure for multipage buffered writes.  This is implemented
> using an main iterator that applies an actor function to a range that
> can be written.
> 
> This infrastucture is used to implement a buffered write helper, one
> to zero file ranges and one to implement the ->page_mkwrite VM
> operations.  All of them borrow a fair amount of code from fs/buffers.
> for now by using an internal version of __block_write_begin that
> gets passed an iomap and builds the corresponding buffer head.
> 
> The file system is gets a set of paired ->iomap_begin and ->iomap_end
> calls which allow it to map/reserve a range and get a notification
> once the write code is finished with it.
> 
> Based on earlier code from Dave Chinner.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Bob Peterson <rpeterso@redhat.com>

When reading through the patch I've noticed two minor errors in the
comments:

...
> +static loff_t
> +iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
> +		struct iomap_ops *ops, void *data, iomap_actor_t actor)
> +{
> +	struct iomap iomap = { 0 };
> +	loff_t written = 0, ret;
> +
> +	/*
> +	 * Need to map a range from start position for count bytes. This can
						       ^^^^ length
...

>  struct iomap {
> -	sector_t	blkno;	/* first sector of mapping */
> -	loff_t		offset;	/* file offset of mapping, bytes */
> -	u64		length;	/* length of mapping, bytes */
> -	int		type;	/* type of mapping */
> +	sector_t		blkno;	/* first sector of mapping, fs blocks */

This is actually in 512-byte units, not in fs blocks as the comment
suggests, right?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
