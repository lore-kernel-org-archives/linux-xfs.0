Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Jul 2008 01:07:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6187n0x005404
	for <xfs@oss.sgi.com>; Tue, 1 Jul 2008 01:07:49 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC2CE2A242E
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2008 01:08:51 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 7hUteJ3rcpSyIIq5 for <xfs@oss.sgi.com>; Tue, 01 Jul 2008 01:08:51 -0700 (PDT)
Date: Tue, 1 Jul 2008 04:08:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] Implement generic freeze feature
Message-ID: <20080701080844.GA16691@infradead.org>
References: <20080630212323t-sato@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630212323t-sato@mail.jp.nec.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, axboe@kernel.dk, mtk.manpages@googlemail.com

>  {
>  	struct super_block *sb;
>  
> +	if (test_and_set_bit(BD_FREEZE_OP, &bdev->bd_state))
> +		return ERR_PTR(-EBUSY);
> +
> +	sb = get_super(bdev);
> +
> +	/* If super_block has been already frozen, return. */
> +	if (sb && sb->s_frozen != SB_UNFROZEN) {
> +		drop_super(sb);
> +		clear_bit(BD_FREEZE_OP, &bdev->bd_state);
> +		return sb;
> +	}
> +
> +	if (sb)
> +		drop_super(sb);
> +
>  	down(&bdev->bd_mount_sem);
>  	sb = get_super(bdev);
>  	if (sb && !(sb->s_flags & MS_RDONLY)) {
> @@ -219,6 +234,8 @@ struct super_block *freeze_bdev(struct b
>  	}
>  
>  	sync_blockdev(bdev);
> +	clear_bit(BD_FREEZE_OP, &bdev->bd_state);
> +

Please only clear BD_FREEZE_OP in thaw_bdev, that way you can also get
rid of the frozen check above, and the double-get_super.  Also
bd_mount_sem could be removed that way by checking for BD_FREEZE_OP
in the unmount path.

>  /*
> + * ioctl_freeze - Freeze the filesystem.
> + *
> + * @filp:	target file
> + *
> + * Call freeze_bdev() to freeze the filesystem.
> + */

This is not a kerneldoc comment.  But I think it can be simply removed
anyway, as it's a quite trivial function with static scope.

> +/*
> + * ioctl_thaw - Thaw the filesystem.
> + *
> + * @filp:	target file
> + *
> + * Call thaw_bdev() to thaw the filesystem.
> + */

Same here.
