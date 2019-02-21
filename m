Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40738 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbfBUInG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Feb 2019 03:43:06 -0500
Subject: Re: [PATCH V15 14/18] block: enable multipage bvecs
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <6c9ae4de-c56f-a2b3-2542-da7d8b95601d@samsung.com>
Date: Thu, 21 Feb 2019 09:42:59 +0100
MIME-Version: 1.0
In-Reply-To: <20190215111324.30129-15-ming.lei@redhat.com>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
References: <20190215111324.30129-1-ming.lei@redhat.com>
        <20190215111324.30129-15-ming.lei@redhat.com>
        <CGME20190221084301eucas1p11e8841a62b4b1da3cccca661b6f4c29d@eucas1p1.samsung.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com, Ulf Hansson <ulf.hansson@linaro.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, 'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Dear All,

On 2019-02-15 12:13, Ming Lei wrote:
> This patch pulls the trigger for multi-page bvecs.
>
> Reviewed-by: Omar Sandoval <osandov@fb.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Since Linux next-20190218 I've observed problems with block layer on one
of my test devices (Odroid U3 with EXT4 rootfs on SD card). Bisecting
this issue led me to this change. This is also the first linux-next
release with this change merged. The issue is fully reproducible and can
be observed in the following kernel log:

sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
s3c-sdhci 12530000.sdhci: clock source 2: mmc_busclk.2 (100000000 Hz)
s3c-sdhci 12530000.sdhci: Got CD GPIO
mmc0: SDHCI controller on samsung-hsmmc [12530000.sdhci] using ADMA
mmc0: new high speed SDHC card at address aaaa
mmcblk0: mmc0:aaaa SL16G 14.8 GiB

...

EXT4-fs (mmcblk0p2): INFO: recovery required on readonly filesystem
EXT4-fs (mmcblk0p2): write access will be enabled during recovery
EXT4-fs (mmcblk0p2): recovery complete
EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 179:2.
devtmpfs: mounted
Freeing unused kernel memory: 1024K
hub 1-3:1.0: USB hub found
Run /sbin/init as init process
hub 1-3:1.0: 3 ports detected
*** stack smashing detected ***: <unknown> terminated
Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000004
CPU: 1 PID: 1 Comm: init Not tainted 5.0.0-rc6-next-20190218 #1546
Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[<c01118d0>] (unwind_backtrace) from [<c010d794>] (show_stack+0x10/0x14)
[<c010d794>] (show_stack) from [<c09ff8a4>] (dump_stack+0x90/0xc8)
[<c09ff8a4>] (dump_stack) from [<c0125944>] (panic+0xfc/0x304)
[<c0125944>] (panic) from [<c012bc98>] (do_exit+0xabc/0xc6c)
[<c012bc98>] (do_exit) from [<c012c100>] (do_group_exit+0x3c/0xbc)
[<c012c100>] (do_group_exit) from [<c0138908>] (get_signal+0x130/0xbf4)
[<c0138908>] (get_signal) from [<c010c7a0>] (do_work_pending+0x130/0x618)
[<c010c7a0>] (do_work_pending) from [<c0101034>]
(slow_work_pending+0xc/0x20)
Exception stack(0xe88c3fb0 to 0xe88c3ff8)
3fa0:                                     00000000 bea7787c 00000005
b6e8d0b8
3fc0: bea77a18 b6f92010 b6e8d0b8 00000001 b6e8d0c8 00000001 b6e8c000
bea77b60
3fe0: 00000020 bea77998 ffffffff b6d52368 60000050 ffffffff
CPU3: stopping

I would like to help debugging and fixing this issue, but I don't really
have idea where to start. Here are some more detailed information about
my test system:

1. Board: ARM 32bit Samsung Exynos4412-based Odroid U3 (device tree
source: arch/arm/boot/dts/exynos4412-odroidu3.dts)

2. Block device: MMC/SDHCI/SDHCI-S3C with SD card
(drivers/mmc/host/sdhci-s3c.c driver, sdhci_2 device node in the device
tree)

3. Rootfs: Ext4

4. Kernel config: arch/arm/configs/exynos_defconfig

I can gather more logs if needed, just let me which kernel option to
enable. Reverting this commit on top of next-20190218 as well as current
linux-next (tested with next-20190221) fixes this issue and makes the
system bootable again.

> ---
>  block/bio.c         | 22 +++++++++++++++-------
>  fs/iomap.c          |  4 ++--
>  fs/xfs/xfs_aops.c   |  4 ++--
>  include/linux/bio.h |  2 +-
>  4 files changed, 20 insertions(+), 12 deletions(-)
>
> diff --git a/block/bio.c b/block/bio.c
> index 968b12fea564..83a2dfa417ca 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -753,6 +753,8 @@ EXPORT_SYMBOL(bio_add_pc_page);
>   * @page: page to add
>   * @len: length of the data to add
>   * @off: offset of the data in @page
> + * @same_page: if %true only merge if the new data is in the same physical
> + *		page as the last segment of the bio.
>   *
>   * Try to add the data at @page + @off to the last bvec of @bio.  This is a
>   * a useful optimisation for file systems with a block size smaller than the
> @@ -761,19 +763,25 @@ EXPORT_SYMBOL(bio_add_pc_page);
>   * Return %true on success or %false on failure.
>   */
>  bool __bio_try_merge_page(struct bio *bio, struct page *page,
> -		unsigned int len, unsigned int off)
> +		unsigned int len, unsigned int off, bool same_page)
>  {
>  	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
>  		return false;
>  
>  	if (bio->bi_vcnt > 0) {
>  		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
> +		phys_addr_t vec_end_addr = page_to_phys(bv->bv_page) +
> +			bv->bv_offset + bv->bv_len - 1;
> +		phys_addr_t page_addr = page_to_phys(page);
>  
> -		if (page == bv->bv_page && off == bv->bv_offset + bv->bv_len) {
> -			bv->bv_len += len;
> -			bio->bi_iter.bi_size += len;
> -			return true;
> -		}
> +		if (vec_end_addr + 1 != page_addr + off)
> +			return false;
> +		if (same_page && (vec_end_addr & PAGE_MASK) != page_addr)
> +			return false;
> +
> +		bv->bv_len += len;
> +		bio->bi_iter.bi_size += len;
> +		return true;
>  	}
>  	return false;
>  }
> @@ -819,7 +827,7 @@ EXPORT_SYMBOL_GPL(__bio_add_page);
>  int bio_add_page(struct bio *bio, struct page *page,
>  		 unsigned int len, unsigned int offset)
>  {
> -	if (!__bio_try_merge_page(bio, page, len, offset)) {
> +	if (!__bio_try_merge_page(bio, page, len, offset, false)) {
>  		if (bio_full(bio))
>  			return 0;
>  		__bio_add_page(bio, page, len, offset);
> diff --git a/fs/iomap.c b/fs/iomap.c
> index af736acd9006..0c350e658b7f 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -318,7 +318,7 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  	 */
>  	sector = iomap_sector(iomap, pos);
>  	if (ctx->bio && bio_end_sector(ctx->bio) == sector) {
> -		if (__bio_try_merge_page(ctx->bio, page, plen, poff))
> +		if (__bio_try_merge_page(ctx->bio, page, plen, poff, true))
>  			goto done;
>  		is_contig = true;
>  	}
> @@ -349,7 +349,7 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  		ctx->bio->bi_end_io = iomap_read_end_io;
>  	}
>  
> -	__bio_add_page(ctx->bio, page, plen, poff);
> +	bio_add_page(ctx->bio, page, plen, poff);
>  done:
>  	/*
>  	 * Move the caller beyond our range so that it keeps making progress.
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 1f1829e506e8..b9fd44168f61 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -616,12 +616,12 @@ xfs_add_to_ioend(
>  				bdev, sector);
>  	}
>  
> -	if (!__bio_try_merge_page(wpc->ioend->io_bio, page, len, poff)) {
> +	if (!__bio_try_merge_page(wpc->ioend->io_bio, page, len, poff, true)) {
>  		if (iop)
>  			atomic_inc(&iop->write_count);
>  		if (bio_full(wpc->ioend->io_bio))
>  			xfs_chain_bio(wpc->ioend, wbc, bdev, sector);
> -		__bio_add_page(wpc->ioend->io_bio, page, len, poff);
> +		bio_add_page(wpc->ioend->io_bio, page, len, poff);
>  	}
>  
>  	wpc->ioend->io_size += len;
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 089370eb84d9..9f77adcfde82 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -441,7 +441,7 @@ extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
>  extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
>  			   unsigned int, unsigned int);
>  bool __bio_try_merge_page(struct bio *bio, struct page *page,
> -		unsigned int len, unsigned int off);
> +		unsigned int len, unsigned int off, bool same_page);
>  void __bio_add_page(struct bio *bio, struct page *page,
>  		unsigned int len, unsigned int off);
>  int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter);

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
