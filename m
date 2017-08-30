Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37581 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751358AbdH3O7Y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 10:59:24 -0400
Date: Wed, 30 Aug 2017 16:59:21 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA
Message-ID: <20170830145921.GB5920@quack2.suse.cz>
References: <20170829142942.21594-1-agruenba@redhat.com>
 <20170829142942.21594-5-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <20170829142942.21594-5-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 29-08-17 16:29:42, Andreas Gruenbacher wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Switch to the iomap_seek_hole and iomap_seek_data helpers for
> implementing lseek SEEK_HOLE / SEEK_DATA, and remove all the code that
> isn't needed any more.
> 
> Note that with this patch, ext4 will now always depend on the iomap code
> instead of only when CONFIG_DAX is enabled, and it requires adding a
> call into the extent status tree for iomap_begin as well to properly
> deal with delalloc extents.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> [Minor fixes and cleanups by Andreas]
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

...

> @@ -3425,6 +3425,29 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  
>  	if (!(flags & IOMAP_WRITE)) {
>  		ret = ext4_map_blocks(NULL, inode, &map, 0);
> +		if (ret < 0)
> +			return ret;

One general question about IOMAP_REPORT: When there is unwritten extent, we
use page_cache_seek_hole_data() to determine what is actually a hole and
what is data. We could use exactly the same function to determine what is a
hole and what is data in an IOMAP_HOLE extent, couldn't we? Now I
understand that a filesystem is supposed to return IOMAP_DELALLOC extent if
there is delayed allocation data covering queried offset so probably it's
not a great idea to use that however it still seems a bit like an
unnecessary duplication...

> +		if (!ret) {

Please go to this branch only for IOMAP_REPORT case to avoid unnecessary
overhead for DAX mappings...

> +			struct extent_status es = {};
> +
> +			ext4_es_find_delayed_extent_range(inode, map.m_lblk,
> +					map.m_lblk + map.m_len - 1, &es);
> +			/* Is delalloc data before next block in extent tree? */
> +			if (es.es_len && es.es_lblk < map.m_lblk + map.m_len) {

And this is still wrong - I have actually verified that with attached patch
that disables caching of extents (so it is equivalent to *very* aggresive
slab reclaim happening). With that patch applied you'll get:

kvm0:~ # rm /mnt/file; xfs_io -f -c "pwrite 4096 4096" -c "seek -a 0"
/mnt/file
wrote 4096/4096 bytes at offset 4096
4 KiB, 1 ops; 0.0000 sec (16.693 MiB/sec and 4273.5043 ops/sec)
Whence	Result
DATA	0
HOLE	8192

Which is obviously wrong - hole should be 0, data should be 4096.

And the reason why this is wrong is that when we are asked to map things at
first_block and there is a hole at that offset, we need to just truncate
the hole extent returned by ext4_map_blocks() by possibly following
delalloc allocation. But we still need to return that there *is a hole* at
first_block. But your patch seems to try to return the delalloc extent
instead which is wrong.

> +				ext4_lblk_t offs = 0;
> +
> +				if (es.es_lblk < map.m_lblk)
> +					offs = map.m_lblk - es.es_lblk;
> +				map.m_lblk = es.es_lblk + offs;
> +				map.m_pblk = ext4_es_pblock(&es) + offs;
> +				map.m_len = es.es_len - offs;
> +				if (ext4_es_is_unwritten(&es))
> +					map.m_flags |= EXT4_MAP_UNWRITTEN;
> +				if (ext4_es_is_delayed(&es))
> +					delalloc = true;
> +				ret = 1;
> +			}
> +		}
>  	} else {
>  		int dio_credits;
>  		handle_t *handle;

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--r5Pyd7+fXNt84Ff3
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="extent_status_disable.diff"

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index e7f12a204cbc..32b55cdf9b82 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -698,7 +698,7 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 	es_debug("add [%u/%u) %llu %x to extent status tree of inode %lu\n",
 		 lblk, len, pblk, status, inode->i_ino);
 
-	if (!len)
+	if (!len || !(status & EXTENT_STATUS_DELAYED))
 		return 0;
 
 	BUG_ON(end < lblk);

--r5Pyd7+fXNt84Ff3--
