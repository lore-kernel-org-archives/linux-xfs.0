Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A3FBE7CA0
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 04:16:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7546B304048
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 02:16:04 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id WLH4HXBQlzR7WQJO (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Mar 2016 02:16:02 -0700 (PDT)
Date: Mon, 21 Mar 2016 10:16:28 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [GIT PULL] xfs: updates for 4.6-rc1
Message-ID: <20160321091628.GE30819@quack.suse.cz>
References: <20160321020505.GJ11812@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160321020505.GJ11812@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, jack@suse.cz, akpm@linux-foundation.org, torvalds@linux-foundation.org

On Mon 21-03-16 13:05:05, Dave Chinner wrote:
The resolution of conflict in fs/ext4/inode.c is fine except for one minor
issue:

> diff --cc fs/ext4/inode.c
> index b2e9576,2b98171..e5ba3b0
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@@ -3289,10 -3161,10 +3289,10 @@@ out
>   }
>   #endif
>   
> - static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
> + static int ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
>   			    ssize_t size, void *private)
>   {
>  -        ext4_io_end_t *io_end = iocb->private;
>  +        ext4_io_end_t *io_end = private;
>   
>   	/* if not async direct IO just return */
>   	if (!io_end)
> @@@ -3300,8 -3172,18 +3300,17 @@@
>   
>   	ext_debug("ext4_end_io_dio(): io_end 0x%p "
>   		  "for inode %lu, iocb 0x%p, offset %llu, size %zd\n",
>  - 		  iocb->private, io_end->inode->i_ino, iocb, offset,
>  -		  size);
>  +		  io_end, io_end->inode->i_ino, iocb, offset, size);
>   
> + 	iocb->private = NULL;

The line above should not exist in the result. It does no harm but is
unnecessary.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
