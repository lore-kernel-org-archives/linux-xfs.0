Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Sep 2008 10:09:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m88H9JLV003855
	for <xfs@oss.sgi.com>; Mon, 8 Sep 2008 10:09:20 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7328104FA1B
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2008 10:10:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id dWqZSe7QjmavTFPM for <xfs@oss.sgi.com>; Mon, 08 Sep 2008 10:10:47 -0700 (PDT)
Date: Mon, 8 Sep 2008 13:10:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] Implement generic freeze feature
Message-ID: <20080908171020.GA22521@infradead.org>
References: <20080908205245t-sato@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080908205245t-sato@mail.jp.nec.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Mon, Sep 08, 2008 at 08:52:45PM +0900, Takashi Sato wrote:
> diff -uprN -X linux-2.6.27-rc5.org/Documentation/dontdiff linux-2.6.27-rc5.org/fs/block_dev.c linux-2.6.27-rc5-freeze/fs
> /block_dev.c
> --- linux-2.6.27-rc5.org/fs/block_dev.c	2008-08-29 07:52:02.000000000 +0900
> +++ linux-2.6.27-rc5-freeze/fs/block_dev.c	2008-09-05 20:00:29.000000000 +0900
> @@ -285,6 +285,8 @@ static void init_once(void *foo)
>  	INIT_LIST_HEAD(&bdev->bd_holder_list);
>  #endif
>  	inode_init_once(&ei->vfs_inode);
> +	/* Initialize mutex for freeze. */
> +	mutex_init(&bdev->bd_fsfreeze_mutex);

Why not just freeze_mutex?


>  struct super_block *freeze_bdev(struct block_device *bdev)
>  {
>  	struct super_block *sb;
>  
> +	mutex_lock(&bdev->bd_fsfreeze_mutex);
> +	if (bdev->bd_fsfreeze_count > 0) {
> +		bdev->bd_fsfreeze_count++;
> +		sb = get_super(bdev);
> +		mutex_unlock(&bdev->bd_fsfreeze_mutex);
> +		return sb;
> +	}
> +	bdev->bd_fsfreeze_count++;
> +
>  	down(&bdev->bd_mount_sem);

Note that we still have duplication with the bd_mount_sem.  I think
you should look into getting rid of it and instead do a check of
the freeze_count under proper freeze_mutex protection.

> +int thaw_bdev(struct block_device *bdev, struct super_block *sb)
>  {
> +	mutex_lock(&bdev->bd_fsfreeze_mutex);
> +	if (!bdev->bd_fsfreeze_count) {
> +		mutex_unlock(&bdev->bd_fsfreeze_mutex);
> +		return 0;
> +	}
> +
> +	bdev->bd_fsfreeze_count--;
> +	if (bdev->bd_fsfreeze_count > 0) {
> +		if (sb)
> +			drop_super(sb);
> +		mutex_unlock(&bdev->bd_fsfreeze_mutex);
> +		return 0;
> +	}
> +
>  	if (sb) {
>  		BUG_ON(sb->s_bdev != bdev);
>  
> @@ -244,6 +274,8 @@ void thaw_bdev(struct block_device *bdev
>  	}
>  
>  	up(&bdev->bd_mount_sem);
> +	mutex_unlock(&bdev->bd_fsfreeze_mutex);
> +	return 0;

Why do you add a return value here if we always return 0 anyway?
