Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A1C1C7F3F
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 03:45:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8DD6E8F8033
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 01:45:26 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id JyeX9wA9xSuVWHUz (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 01:45:23 -0700 (PDT)
Date: Wed, 24 Sep 2014 10:45:19 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: Fix mmap data corruption when blocksize <
	pagesize
Message-ID: <20140924084519.GA21987@quack.suse.cz>
References: <1411484603-17756-1-git-send-email-jack@suse.cz>
	<1411484603-17756-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411484603-17756-3-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com, linux-mm@kvack.org, Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org

On Tue 23-09-14 17:03:23, Jan Kara wrote:
> Use block_create_hole() when hole is being created in a file so that
> ->page_mkwrite() will get called for the partial tail page if it is
> mmaped (see the first patch in the series for details).
  Just out of curiosity I did a change similar to this one for ext4 to XFS
and indeed it fixed generic/030 test failures for XFS with blocksize 1k.

								Honza

PS: I forgot to CC xfs list in the original posting. You can find the VFS
    patch e.g. at http://www.spinics.net/lists/linux-mm/msg78976.html

> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/inode.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3aa26e9117c4..fdcb007c2c9e 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4536,8 +4536,12 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  				ext4_orphan_del(NULL, inode);
>  				goto err_out;
>  			}
> -		} else
> +		} else {
> +			loff_t old_size = inode->i_size;
> +
>  			i_size_write(inode, attr->ia_size);
> +			block_create_hole(inode, old_size, inode->i_size);
> +		}
>  
>  		/*
>  		 * Blocks are going to be removed from the inode. Wait
> -- 
> 1.8.1.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
