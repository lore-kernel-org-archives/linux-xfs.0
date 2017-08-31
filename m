Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56249 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750816AbdHaIY5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Aug 2017 04:24:57 -0400
Date: Thu, 31 Aug 2017 10:24:27 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 4/4] ext4: perform dax_device lookup at mount
Message-ID: <20170831082427.GE7897@quack2.suse.cz>
References: <150412222686.10177.8031279869867070772.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150412224853.10177.6213990706281408829.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150412224853.10177.6213990706281408829.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>

On Wed 30-08-17 12:44:08, Dan Williams wrote:
> The ->iomap_begin() operation is a hot path, so cache the
> fs_dax_get_by_host() result at mount time to avoid the incurring the
> hash lookup overhead on a per-i/o basis.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Jan Kara <jack@suse.cz>
> Reported-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

With the same nit as for ext2:

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index d61a70e2193a..0b3d94e25efb 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -864,6 +864,7 @@ static inline void ext4_quota_off_umount(struct super_block *sb)
>  static void ext4_put_super(struct super_block *sb)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +	struct dax_device *dax_dev = sbi->s_daxdev;
>  	struct ext4_super_block *es = sbi->s_es;
>  	int aborted = 0;
>  	int i, err;
> @@ -952,6 +953,7 @@ static void ext4_put_super(struct super_block *sb)
>  		crypto_free_shash(sbi->s_chksum_driver);
>  	kfree(sbi->s_blockgroup_lock);
>  	kfree(sbi);
> +	fs_put_dax(dax_dev);

Just remove dax_dev local variable...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
