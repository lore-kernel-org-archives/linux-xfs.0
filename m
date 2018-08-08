Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38022 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727174AbeHHLH7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Aug 2018 07:07:59 -0400
Date: Wed, 8 Aug 2018 10:49:13 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext4: Close race between direct IO and
 ext4_break_layouts()
Message-ID: <20180808084913.GB15413@quack2.suse.cz>
References: <153367989755.37314.6889218648604435494.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153367989755.37314.6889218648604435494.stgit@djiang5-desk3.ch.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Jiang <dave.jiang@intel.com>
Cc: tytso@mit.edu, darrick.wong@oracle.com, jack@suse.cz, zwisler@kernel.org, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, lczerner@redhat.com, linux-ext4@vger.kernel.org, hch@lst.de

On Tue 07-08-18 15:11:37, Dave Jiang wrote:
> From: Ross Zwisler <zwisler@kernel.org>
> 
> If the refcount of a page is lowered between the time that it is returned
> by dax_busy_page() and when the refcount is again checked in
> ext4_break_layouts() => ___wait_var_event(), the waiting function
> ext4_wait_dax_page() will never be called.  This means that
> ext4_break_layouts() will still have 'retry' set to false, so we'll stop
> looping and never check the refcount of other pages in this inode.
> 
> Instead, always continue looping as long as dax_layout_busy_page() gives us
> a page which it found with an elevated refcount.
> 
> Note that this works around the race exposed by my unit test, but I think
> that there is another race that needs to be addressed, probably with
> additional synchronization added between direct I/O and
> {ext4,xfs}_break_layouts().

I'd just note that the race Ross suspected should be properly handled by
dax_layout_busy_page() so I think this last paragraph from the changelog
can go.

Also Ted, this fixes a problem in the DAX truncate patches you currently
carry in your tree so you can consider just pushing it with them during the
merge window. It's not necessary though - the patches already make the
problematic behavior much less likely, this patch just hopefully completely
closes the race window.

> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 8f6ad7667974..d2663a1e3ec2 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4191,9 +4191,8 @@ int ext4_update_disksize_before_punch(struct inode *inode, loff_t offset,
>  	return 0;
>  }
>  
> -static void ext4_wait_dax_page(struct ext4_inode_info *ei, bool *did_unlock)
> +static void ext4_wait_dax_page(struct ext4_inode_info *ei)
>  {
> -	*did_unlock = true;
>  	up_write(&ei->i_mmap_sem);
>  	schedule();
>  	down_write(&ei->i_mmap_sem);
> @@ -4203,14 +4202,12 @@ int ext4_break_layouts(struct inode *inode)
>  {
>  	struct ext4_inode_info *ei = EXT4_I(inode);
>  	struct page *page;
> -	bool retry;
>  	int error;
>  
>  	if (WARN_ON_ONCE(!rwsem_is_locked(&ei->i_mmap_sem)))
>  		return -EINVAL;
>  
>  	do {
> -		retry = false;
>  		page = dax_layout_busy_page(inode->i_mapping);
>  		if (!page)
>  			return 0;
> @@ -4218,8 +4215,8 @@ int ext4_break_layouts(struct inode *inode)
>  		error = ___wait_var_event(&page->_refcount,
>  				atomic_read(&page->_refcount) == 1,
>  				TASK_INTERRUPTIBLE, 0, 0,
> -				ext4_wait_dax_page(ei, &retry));
> -	} while (error == 0 && retry);
> +				ext4_wait_dax_page(ei));
> +	} while (error == 0);
>  
>  	return error;
>  }
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
