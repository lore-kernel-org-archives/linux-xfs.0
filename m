Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Jun 2008 14:47:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5OLlZuI003592
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 14:47:36 -0700
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 242A4274CAB
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 14:48:35 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [140.211.169.13]) by cuda.sgi.com with ESMTP id cae5pEvl7KW6gh8w for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 14:48:35 -0700 (PDT)
Date: Tue, 24 Jun 2008 14:48:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] Implement generic freeze feature
Message-Id: <20080624144803.0135a84d.akpm@linux-foundation.org>
In-Reply-To: <20080624155950t-sato@mail.jp.nec.com>
References: <20080624155950t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

On Tue, 24 Jun 2008 15:59:50 +0900
Takashi Sato <t-sato@yk.jp.nec.com> wrote:

> I have modified to set the suitable error number (EOPNOTSUPP)
> in case the filesystem doesn't support the freeze feature.
> This was pointed out by Andreas Dilger.
> 
> The ioctls for the generic freeze feature are below.
> o Freeze the filesystem
>   int ioctl(int fd, int FIFREEZE, arg)
>     fd: The file descriptor of the mountpoint
>     FIFREEZE: request code for the freeze
>     arg: Ignored
>     Return value: 0 if the operation succeeds. Otherwise, -1
> 
> o Unfreeze the filesystem
>   int ioctl(int fd, int FITHAW, arg)
>     fd: The file descriptor of the mountpoint
>     FITHAW: request code for unfreeze
>     arg: Ignored
>     Return value: 0 if the operation succeeds. Otherwise, -1
>
> ...
>
> +/*
> + * get_super_without_lock - Get super_block from block_device without lock.
> + * @bdev:	block device struct
> + *
> + * Scan the superblock list and finds the superblock of the file system
> + * mounted on the block device given. This doesn't lock anyone.
> + * %NULL is returned if no match is found.
> + */

This is not a terribly good comment.

Which lock are we not taking?  I _assume_ that it's referring to
s_umount?  If so, the text should describe that.

It should also go to some lengths explaining why this dangerous-looking
and rather nasty-looking function exists.

Look at it this way: there is no way in which the reviewer of this
patch (ie: me) can work out why this function exists.  Hence there will
be no way in which future readers of this code will be able to work out
why this function exists either.  This is bad.  These things should be
described in code comments and in the changelog (whichever is most
appropriate).

> +struct super_block *get_super_without_lock(struct block_device *bdev)
> +{
> +	struct super_block *sb;
> +
> +	if (!bdev)
> +		return NULL;
> +
> +	spin_lock(&sb_lock);
> +	list_for_each_entry(sb, &super_blocks, s_list) {
> +		if (sb->s_bdev == bdev) {
> +			if (sb->s_root) {
> +				sb->s_count++;
> +				spin_unlock(&sb_lock);
> +				return sb;
> +			}
> +		}
> +	}
> +	spin_unlock(&sb_lock);
> +	return NULL;
> +}
> +EXPORT_SYMBOL(get_super_without_lock);
