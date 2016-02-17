Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6BC607CA8
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 15:33:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4C1DE8F8033
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 13:33:09 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id cUARPXHKGAEpn5K8 (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2016 13:33:06 -0800 (PST)
Date: Wed, 17 Feb 2016 22:33:25 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 2/6] ext2, ext4: only set S_DAX for regular inodes
Message-ID: <20160217213325.GH14140@quack.suse.cz>
References: <1455680059-20126-1-git-send-email-ross.zwisler@linux.intel.com>
	<1455680059-20126-3-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455680059-20126-3-git-send-email-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@poochiereds.net>, Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

On Tue 16-02-16 20:34:15, Ross Zwisler wrote:
> When S_DAX is set on an inode we assume that if there are pages attached
> to the mapping (mapping->nrpages != 0), those pages are clean zero pages
> that were used to service reads from holes.  Any dirty data associated with
> the inode should be in the form of DAX exceptional entries
> (mapping->nrexceptional) that is written back via
> dax_writeback_mapping_range().
> 
> With the current code, though, this isn't always true.  For example, ext2
> and ext4 directory inodes can have S_DAX set, but have their dirty data
> stored as dirty page cache entries.  For these types of inodes, having
> S_DAX set doesn't really make sense since their I/O doesn't actually happen
> through the DAX code path.
> 
> Instead, only allow S_DAX to be set for regular inodes for ext2 and ext4.
> This allows us to have strict DAX vs non-DAX paths in the writeback code.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext2/inode.c | 2 +-
>  fs/ext4/inode.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 338eefd..27e2cdd 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1296,7 +1296,7 @@ void ext2_set_inode_flags(struct inode *inode)
>  		inode->i_flags |= S_NOATIME;
>  	if (flags & EXT2_DIRSYNC_FL)
>  		inode->i_flags |= S_DIRSYNC;
> -	if (test_opt(inode->i_sb, DAX))
> +	if (test_opt(inode->i_sb, DAX) && S_ISREG(inode->i_mode))
>  		inode->i_flags |= S_DAX;
>  }
>  
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 83bc8bf..7088aa5 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4127,7 +4127,7 @@ void ext4_set_inode_flags(struct inode *inode)
>  		new_fl |= S_NOATIME;
>  	if (flags & EXT4_DIRSYNC_FL)
>  		new_fl |= S_DIRSYNC;
> -	if (test_opt(inode->i_sb, DAX))
> +	if (test_opt(inode->i_sb, DAX) && S_ISREG(inode->i_mode))
>  		new_fl |= S_DAX;
>  	inode_set_flags(inode, new_fl,
>  			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_DAX);
> -- 
> 2.5.0
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
