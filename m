Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 03:36:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3SAacn6002834
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 03:36:40 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 494A615F4A6C
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 03:37:21 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id l71AkZvjKrTXZEPQ for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 03:37:21 -0700 (PDT)
Date: Mon, 28 Apr 2008 06:37:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
Message-ID: <20080428103719.GA16030@infradead.org>
References: <20080428193123t-sato@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428193123t-sato@mail.jp.nec.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Mon, Apr 28, 2008 at 07:31:23PM +0900, Takashi Sato wrote:
> +	/* Initialize semaphore for freeze. */
> +	sema_init(&bdev->bd_freeze_sem, 1);

The freezing process is already protected by bd_mount_sem, so I don't
think there's need for another one.

> --- linux-2.6.25.org/fs/buffer.c	2008-04-17 11:49:44.000000000 +0900
> +++ linux-2.6.25-freeze/fs/buffer.c	2008-04-24 20:43:28.000000000 +0900
> @@ -201,6 +201,19 @@ struct super_block *freeze_bdev(struct b
>  {
>  	struct super_block *sb;
>  
> +	down(&bdev->bd_freeze_sem);
> +	sb = get_super_without_lock(bdev);
> +
> +	/* If super_block has been already frozen, return. */
> +	if (sb && sb->s_frozen != SB_UNFROZEN) {
> +		put_super(sb);
> +		up(&bdev->bd_freeze_sem);
> +		return sb;
> +	}
> +
> +	if (sb)
> +		put_super(sb);
> +
>  	down(&bdev->bd_mount_sem);
>  	sb = get_super(bdev);

I think the protection against double freezes would be better done by
using a trylock on bd_mount_sem.  In fact after that it could be changed
from a semaphore to a simple test_and_set_bit.
>  			error = -ENOTTY;
>  		break;
> +
> +	case FIFREEZE: {

This would be better to split intot a small helper ala ioctl_fibmap()

> +	case FITHAW: {

Same here.
