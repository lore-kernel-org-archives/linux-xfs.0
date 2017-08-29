Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28183 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753044AbdH2QLZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 12:11:25 -0400
Date: Tue, 29 Aug 2017 09:11:15 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/4] iomap: Switch from blkno to disk offset
Message-ID: <20170829161115.GS4757@magnolia>
References: <20170829142942.21594-1-agruenba@redhat.com>
 <20170829142942.21594-2-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829142942.21594-2-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>

On Tue, Aug 29, 2017 at 04:29:39PM +0200, Andreas Gruenbacher wrote:
> Replace iomap->blkno, the sector number, with iomap->addr, the disk
> offset in bytes.  For invalid disk offsets, use the special value
> IOMAP_NULL_ADDR instead of IOMAP_NULL_BLOCK.  This allows to use iomap
> for mappings which are not block aligned, such as inline data on ext4
> and stuffed inodes on gfs2.
> 
> Tested on xfs and ext4 with xfstests; seems to be working correctly.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/buffer.c           |  4 ++--
>  fs/dax.c              |  2 +-
>  fs/ext2/inode.c       |  4 ++--
>  fs/ext4/inode.c       |  4 ++--
>  fs/iomap.c            | 11 +++++------
>  fs/nfsd/blocklayout.c |  4 ++--
>  fs/xfs/xfs_iomap.c    |  6 +++---
>  include/linux/iomap.h | 10 +++++-----
>  8 files changed, 22 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 5715dac7821f..b9d20076bb8f 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1979,8 +1979,8 @@ iomap_to_bh(struct inode *inode, sector_t block, struct buffer_head *bh,
>  	case IOMAP_MAPPED:
>  		if (offset >= i_size_read(inode))
>  			set_buffer_new(bh);
> -		bh->b_blocknr = (iomap->blkno >> (inode->i_blkbits - 9)) +
> -				((offset - iomap->offset) >> inode->i_blkbits);
> +		bh->b_blocknr = (iomap->addr + offset - iomap->offset) >>
> +				inode->i_blkbits;
>  		set_buffer_mapped(bh);
>  		break;
>  	}
> diff --git a/fs/dax.c b/fs/dax.c
> index 865d42c63e23..539aaa0b9c45 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -987,7 +987,7 @@ EXPORT_SYMBOL_GPL(__dax_zero_page_range);
>  
>  static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
>  {
> -	return iomap->blkno + (((pos & PAGE_MASK) - iomap->offset) >> 9);
> +	return (iomap->addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
>  }
>  
>  static loff_t
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 30163d007b2f..e7d8925d0140 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -824,11 +824,11 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  
>  	if (ret == 0) {
>  		iomap->type = IOMAP_HOLE;
> -		iomap->blkno = IOMAP_NULL_BLOCK;
> +		iomap->addr = IOMAP_NULL_ADDR;
>  		iomap->length = 1 << blkbits;
>  	} else {
>  		iomap->type = IOMAP_MAPPED;
> -		iomap->blkno = (sector_t)bno << (blkbits - 9);
> +		iomap->addr = (u64)bno << blkbits;
>  		iomap->length = (u64)ret << blkbits;
>  		iomap->flags |= IOMAP_F_MERGED;
>  	}
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c774bdc22759..429f0afde9f2 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3483,7 +3483,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  
>  	if (ret == 0) {
>  		iomap->type = IOMAP_HOLE;
> -		iomap->blkno = IOMAP_NULL_BLOCK;
> +		iomap->addr = IOMAP_NULL_ADDR;
>  		iomap->length = (u64)map.m_len << blkbits;
>  	} else {
>  		if (map.m_flags & EXT4_MAP_MAPPED) {
> @@ -3494,7 +3494,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  			WARN_ON_ONCE(1);
>  			return -EIO;
>  		}
> -		iomap->blkno = (sector_t)map.m_pblk << (blkbits - 9);
> +		iomap->addr = (u64)map.m_pblk << blkbits;
>  		iomap->length = (u64)map.m_len << blkbits;
>  	}
>  
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 59cc98ad7577..7bc1797c2292 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -350,8 +350,8 @@ static int iomap_zero(struct inode *inode, loff_t pos, unsigned offset,
>  static int iomap_dax_zero(loff_t pos, unsigned offset, unsigned bytes,
>  		struct iomap *iomap)
>  {
> -	sector_t sector = iomap->blkno +
> -		(((pos & ~(PAGE_SIZE - 1)) - iomap->offset) >> 9);
> +	sector_t sector = (iomap->addr +
> +			   (pos & PAGE_MASK) - iomap->offset) >> 9;
>  
>  	return __dax_zero_page_range(iomap->bdev, iomap->dax_dev, sector,
>  			offset, bytes);
> @@ -512,9 +512,8 @@ static int iomap_to_fiemap(struct fiemap_extent_info *fi,
>  		flags |= FIEMAP_EXTENT_SHARED;
>  
>  	return fiemap_fill_next_extent(fi, iomap->offset,
> -			iomap->blkno != IOMAP_NULL_BLOCK ? iomap->blkno << 9: 0,
> +			iomap->addr != IOMAP_NULL_ADDR ? iomap->addr : 0,
>  			iomap->length, flags);
> -
>  }
>  
>  static loff_t
> @@ -807,7 +806,7 @@ iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
>  	bio = bio_alloc(GFP_KERNEL, 1);
>  	bio->bi_bdev = iomap->bdev;
>  	bio->bi_iter.bi_sector =
> -		iomap->blkno + ((pos - iomap->offset) >> 9);
> +		(iomap->addr + pos - iomap->offset) >> 9;
>  	bio->bi_private = dio;
>  	bio->bi_end_io = iomap_dio_bio_end_io;
>  
> @@ -886,7 +885,7 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
>  		bio = bio_alloc(GFP_KERNEL, nr_pages);
>  		bio->bi_bdev = iomap->bdev;
>  		bio->bi_iter.bi_sector =
> -			iomap->blkno + ((pos - iomap->offset) >> 9);
> +			(iomap->addr + pos - iomap->offset) >> 9;
>  		bio->bi_write_hint = dio->iocb->ki_hint;
>  		bio->bi_private = dio;
>  		bio->bi_end_io = iomap_dio_bio_end_io;
> diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
> index c862c2489df0..2d1d37b27dc7 100644
> --- a/fs/nfsd/blocklayout.c
> +++ b/fs/nfsd/blocklayout.c
> @@ -65,7 +65,7 @@ nfsd4_block_proc_layoutget(struct inode *inode, const struct svc_fh *fhp,
>  			bex->es = PNFS_BLOCK_READ_DATA;
>  		else
>  			bex->es = PNFS_BLOCK_READWRITE_DATA;
> -		bex->soff = (iomap.blkno << 9);
> +		bex->soff = iomap.addr;
>  		break;
>  	case IOMAP_UNWRITTEN:
>  		if (seg->iomode & IOMODE_RW) {
> @@ -78,7 +78,7 @@ nfsd4_block_proc_layoutget(struct inode *inode, const struct svc_fh *fhp,
>  			}
>  
>  			bex->es = PNFS_BLOCK_INVALID_DATA;
> -			bex->soff = (iomap.blkno << 9);
> +			bex->soff = iomap.addr;
>  			break;
>  		}
>  		/*FALLTHRU*/
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 813394c62849..1bcc5d0373a5 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -54,13 +54,13 @@ xfs_bmbt_to_iomap(
>  	struct xfs_mount	*mp = ip->i_mount;
>  
>  	if (imap->br_startblock == HOLESTARTBLOCK) {
> -		iomap->blkno = IOMAP_NULL_BLOCK;
> +		iomap->addr = IOMAP_NULL_ADDR;
>  		iomap->type = IOMAP_HOLE;
>  	} else if (imap->br_startblock == DELAYSTARTBLOCK) {
> -		iomap->blkno = IOMAP_NULL_BLOCK;
> +		iomap->addr = IOMAP_NULL_ADDR;
>  		iomap->type = IOMAP_DELALLOC;
>  	} else {
> -		iomap->blkno = xfs_fsb_to_db(ip, imap->br_startblock);
> +		iomap->addr = (u64)xfs_fsb_to_db(ip, imap->br_startblock) << 9;

iomap->addr = BBTOB(xfs_fsb_to_db(...));

Same machine-level transformation, but please help us maintain
consistent unit conversion code; the 'BBTOB' name makes the units
analysis of a given piece of code more straightforward.

With that fixed,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

for the iomap and XFS parts.

--D

>  		if (imap->br_state == XFS_EXT_UNWRITTEN)
>  			iomap->type = IOMAP_UNWRITTEN;
>  		else
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index f64dc6ce5161..7b8a615fa021 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -15,8 +15,8 @@ struct vm_fault;
>   */
>  #define IOMAP_HOLE	0x01	/* no blocks allocated, need allocation */
>  #define IOMAP_DELALLOC	0x02	/* delayed allocation blocks */
> -#define IOMAP_MAPPED	0x03	/* blocks allocated @blkno */
> -#define IOMAP_UNWRITTEN	0x04	/* blocks allocated @blkno in unwritten state */
> +#define IOMAP_MAPPED	0x03	/* blocks allocated at @addr */
> +#define IOMAP_UNWRITTEN	0x04	/* blocks allocated at @addr in unwritten state */
>  
>  /*
>   * Flags for all iomap mappings:
> @@ -30,12 +30,12 @@ struct vm_fault;
>  #define IOMAP_F_SHARED	0x20	/* block shared with another file */
>  
>  /*
> - * Magic value for blkno:
> + * Magic value for addr:
>   */
> -#define IOMAP_NULL_BLOCK -1LL	/* blkno is not valid */
> +#define IOMAP_NULL_ADDR -1ULL	/* addr is not valid */
>  
>  struct iomap {
> -	sector_t		blkno;	/* 1st sector of mapping, 512b units */
> +	u64			addr; /* disk offset of mapping, bytes */
>  	loff_t			offset;	/* file offset of mapping, bytes */
>  	u64			length;	/* length of mapping, bytes */
>  	u16			type;	/* type of mapping */
> -- 
> 2.13.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
