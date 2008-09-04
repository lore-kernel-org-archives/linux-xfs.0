Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Sep 2008 09:58:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m84Gw81X030781
	for <xfs@oss.sgi.com>; Thu, 4 Sep 2008 09:58:10 -0700
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 92FC7130115B
	for <xfs@oss.sgi.com>; Thu,  4 Sep 2008 09:59:35 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id yAPM2VASVgzSbFEJ for <xfs@oss.sgi.com>; Thu, 04 Sep 2008 09:59:35 -0700 (PDT)
Message-ID: <48C012F3.3000408@redhat.com>
Date: Thu, 04 Sep 2008 11:55:15 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] Implement generic freeze feature
References: <20080818212819t-sato@mail.jp.nec.com>
In-Reply-To: <20080818212819t-sato@mail.jp.nec.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Takashi Sato wrote:

> @@ -141,6 +142,57 @@ static int ioctl_fioasync(unsigned int f
>  }
>  
>  /*
> + * ioctl_freeze - Freeze the filesystem.
> + *
> + * @filp:	target file
> + *
> + * Call freeze_bdev() to freeze the filesystem.
> + */
> +static int ioctl_freeze(struct file *filp)
> +{
> +	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	/* If filesystem doesn't support freeze feature, return. */
> +	if (sb->s_op->write_super_lockfs == NULL)
> +		return -EOPNOTSUPP;
> +
> +	/* If a regular file or a directory isn't specified, return. */
> +	if (sb->s_bdev == NULL)
> +		return -EINVAL;
> +
> +	/* Freeze */
> +	sb = freeze_bdev(sb->s_bdev);
> +	if (IS_ERR(sb))
> +		return PTR_ERR(sb);
> +	return 0;
> +}

Not a problem with your patch exactly, but I was just wondering; you
check here whether the sb returned from freeze_bdev is an ERR_PTR (as
does lock_fs()) - but, freeze_bdev never returns an error, does it?
->write_super_lockfs is a void...

It really seems that at least we should be able to handle IO errors on
the freeze request, and tell the user "No, your filesystem was not
frozen..."?

Maybe I'll whip up a patch to see about propagating freeze errors up
from the filesystems that implement it, unless I'm missing some reason
not to do so...?

Also, should this be checking for a NULL returned from freeze_bdev as
well?  I guess this should never happen if we have a file open on which
we are calling the ioctl ...

-Eric
