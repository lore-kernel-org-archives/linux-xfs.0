Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53044 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725881AbfDHLDZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Apr 2019 07:03:25 -0400
Date: Mon, 8 Apr 2019 13:03:22 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [POC][PATCH] xfs: reduce ilock contention on buffered randrw
 workload
Message-ID: <20190408110322.GA18662@quack2.suse.cz>
References: <20190404165737.30889-1-amir73il@gmail.com>
 <20190404211730.GD26298@dastard>
 <CAOQ4uxjQNmxqmtA_VbYW0Su9rKRk2zobJmahcyeaEVOFKVQ5dw@mail.gmail.com>
 <20190407232728.GF26298@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190407232728.GF26298@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon 08-04-19 09:27:28, Dave Chinner wrote:
> The result of this is that, AFAICT, ext4 does not protect against
> read() vs hole punch races - it's hole punching code it does:
> 
> Hole Punch:				read():
> 
> inode_lock()
> inode_dio_wait(inode);
> down_write(i_mmap_sem)
> truncate_pagecache_range()
> 					ext4_file_iter_read()
> 					  ext4_map_blocks()
> 					    down_read(i_data_sem)
> 					     <gets mapping>
> 					<populates page cache over hole>
> 					<reads stale data into cache>
> 					.....
> down_write(i_data_sem)
>   remove extents
> 
> IOWs, ext4 is safe against truncate because of the
> change-inode-size-before-invalidation hacks, but the lack of
> serialise buffered reads means that hole punch and other similar
> fallocate based extent manipulations can race against reads....

Hum, you are right. Ext4 is buggy in this regard. I've fixed the race for
page fault in ea3d7209ca01 "ext4: fix races between page faults and hole
punching" but didn't realize the problem is there for buffered reads as
well. I'll think how we can fix this. Thanks for noticing this!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
