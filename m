Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60984 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756610AbdEOL6n (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 May 2017 07:58:43 -0400
Date: Mon, 15 May 2017 13:58:38 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 22/27] jbd2: don't reset error in
 journal_finish_inode_data_buffers
Message-ID: <20170515115838.GE16182@quack2.suse.cz>
References: <20170509154930.29524-1-jlayton@redhat.com>
 <20170509154930.29524-23-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170509154930.29524-23-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk, josef@toxicpanda.com, hubcap@omnibond.com, rpeterso@redhat.com, bo.li.liu@oracle.com

On Tue 09-05-17 11:49:25, Jeff Layton wrote:
> Now that we don't clear writeback errors after fetching them, there is
> no need to reset them. This is also potentially racy.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/commit.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index b6b194ec1b4f..4c6262652028 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -264,17 +264,8 @@ static int journal_finish_inode_data_buffers(journal_t *journal,
>  		jinode->i_flags |= JI_COMMIT_RUNNING;
>  		spin_unlock(&journal->j_list_lock);
>  		err = filemap_fdatawait(jinode->i_vfs_inode->i_mapping);
> -		if (err) {
> -			/*
> -			 * Because AS_EIO is cleared by
> -			 * filemap_fdatawait_range(), set it again so
> -			 * that user process can get -EIO from fsync().
> -			 */
> -			mapping_set_error(jinode->i_vfs_inode->i_mapping, -EIO);
> -
> -			if (!ret)
> -				ret = err;
> -		}
> +		if (err && !ret)
> +			ret = err;
>  		spin_lock(&journal->j_list_lock);
>  		jinode->i_flags &= ~JI_COMMIT_RUNNING;
>  		smp_mb();
> -- 
> 2.9.3
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
