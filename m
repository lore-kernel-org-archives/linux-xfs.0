Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:52455 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751378AbdJMU6z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Oct 2017 16:58:55 -0400
Date: Fri, 13 Oct 2017 14:58:54 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 16/19] ext4: Support for synchronous DAX faults
Message-ID: <20171013205854.GE29081@linux.intel.com>
References: <20171011200603.27442-1-jack@suse.cz>
 <20171011200603.27442-17-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171011200603.27442-17-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Oct 11, 2017 at 10:06:00PM +0200, Jan Kara wrote:
> We return IOMAP_F_NEEDDSYNC flag from ext4_iomap_begin() for a
> synchronous write fault when inode has some uncommitted metadata
> changes. In the fault handler ext4_dax_fault() we then detect this case,
> call vfs_fsync_range() to make sure all metadata is committed, and call
> dax_insert_pfn_mkwrite() to insert page table entry. Note that this will
> also dirty corresponding radix tree entry which is what we want -
> fsync(2) will still provide data integrity guarantees for applications
> not using userspace flushing. And applications using userspace flushing
> can avoid calling fsync(2) and thus avoid the performance overhead.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/file.c       |  6 +++++-
>  fs/ext4/inode.c      | 15 +++++++++++++++
>  fs/jbd2/journal.c    | 17 +++++++++++++++++
>  include/linux/jbd2.h |  1 +
>  4 files changed, 38 insertions(+), 1 deletion(-)

<>

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 31db875bc7a1..13a198924a0f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3394,6 +3394,19 @@ static int ext4_releasepage(struct page *page, gfp_t wait)
>  }
>  
>  #ifdef CONFIG_FS_DAX
> +static bool ext4_inode_datasync_dirty(struct inode *inode)
> +{
> +	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
> +
> +	if (journal)
> +		return !jbd2_transaction_committed(journal,
> +					EXT4_I(inode)->i_datasync_tid);
> +	/* Any metadata buffers to write? */
> +	if (!list_empty(&inode->i_mapping->private_list))
> +		return true;
> +	return inode->i_state & I_DIRTY_DATASYNC;
> +}

I just had 2 quick questions on this:

1) Does ext4 actually use inode->i_mapping->private_list to keep track of
dirty metadata buffers?  The comment above ext4_write_end() leads me to
believe that this list is unused?

 * ext4 never places buffers on inode->i_mapping->private_list.  metadata
 * buffers are managed internally.

Or does the above comment only apply to ext4 with a journal?

2) Where is I_DIRTY_DATASYNC set in inode->i_state?  I poked around a bit and
couldn't see it.

The rest of the patch looks good to me, and you can add:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
