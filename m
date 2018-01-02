Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35800 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751097AbeABQui (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Jan 2018 11:50:38 -0500
Date: Tue, 2 Jan 2018 17:50:34 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 16/19] fs: only set S_VERSION when updating times if
 necessary
Message-ID: <20180102165034.GA4911@quack2.suse.cz>
References: <20171222120556.7435-1-jlayton@kernel.org>
 <20171222120556.7435-17-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171222120556.7435-17-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com

On Fri 22-12-17 07:05:53, Jeff Layton wrote:
> From: Jeff Layton <jlayton@redhat.com>
> 
> We only really need to update i_version if someone has queried for it
> since we last incremented it. By doing that, we can avoid having to
> update the inode if the times haven't changed.
> 
> If the times have changed, then we go ahead and forcibly increment the
> counter, under the assumption that we'll be going to the storage
> anyway, and the increment itself is relatively cheap.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/inode.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 19e72f500f71..2fa920188759 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1635,17 +1635,21 @@ static int relatime_need_update(const struct path *path, struct inode *inode,
>  int generic_update_time(struct inode *inode, struct timespec *time, int flags)
>  {
>  	int iflags = I_DIRTY_TIME;
> +	bool dirty = false;
>  
>  	if (flags & S_ATIME)
>  		inode->i_atime = *time;
>  	if (flags & S_VERSION)
> -		inode_inc_iversion(inode);
> +		dirty |= inode_maybe_inc_iversion(inode, dirty);
>  	if (flags & S_CTIME)
>  		inode->i_ctime = *time;
>  	if (flags & S_MTIME)
>  		inode->i_mtime = *time;
> +	if ((flags & (S_ATIME | S_CTIME | S_MTIME)) &&
> +	    !(inode->i_sb->s_flags & SB_LAZYTIME))
> +		dirty = true;

When you pass 'dirty' to inode_maybe_inc_iversion(), it is always false.
Maybe this condition should be at the beginning of the function? Once you
fix that the patch looks good so you can add:

Reviewed-by: Jan Kara <jack@suse.cz>


								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
