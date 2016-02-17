Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 927A57CAA
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 15:34:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 73DB6304039
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 13:34:35 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id 7fafiaboFkKlhaL2 (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2016 13:34:29 -0800 (PST)
Date: Wed, 17 Feb 2016 22:34:50 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 3/6] ext4: Online defrag not supported with DAX
Message-ID: <20160217213450.GI14140@quack.suse.cz>
References: <1455680059-20126-1-git-send-email-ross.zwisler@linux.intel.com>
	<1455680059-20126-4-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455680059-20126-4-git-send-email-ross.zwisler@linux.intel.com>
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

On Tue 16-02-16 20:34:16, Ross Zwisler wrote:
> Online defrag operations for ext4 are hard coded to use the page cache.
> See ext4_ioctl() -> ext4_move_extents() -> move_extent_per_page()
> 
> When combined with DAX I/O, which circumvents the page cache, this can
> result in data corruption.  This was observed with xfstests ext4/307 and
> ext4/308.
> 
> Fix this by only allowing online defrag for non-DAX files.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

We need to handle this eventually but for now we are fine. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ioctl.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 0f6c369..e32c86f 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -583,6 +583,11 @@ group_extend_out:
>  				 "Online defrag not supported with bigalloc");
>  			err = -EOPNOTSUPP;
>  			goto mext_out;
> +		} else if (IS_DAX(inode)) {
> +			ext4_msg(sb, KERN_ERR,
> +				 "Online defrag not supported with DAX");
> +			err = -EOPNOTSUPP;
> +			goto mext_out;
>  		}
>  
>  		err = mnt_want_write_file(filp);
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
