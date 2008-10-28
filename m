Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 23:16:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S6GJ6n021671
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 23:16:19 -0700
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2538810EE6B4
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 23:16:13 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [140.211.169.13]) by cuda.sgi.com with ESMTP id p5rwG4nU0SFRKb3w for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 23:16:13 -0700 (PDT)
Date: Mon, 27 Oct 2008 23:15:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] Implement generic freeze feature
Message-Id: <20081027231533.96c42a78.akpm@linux-foundation.org>
In-Reply-To: <20081027215855t-sato@mail.jp.nec.com>
References: <20081027215855t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Mon, 27 Oct 2008 21:58:54 +0900 Takashi Sato <t-sato@yk.jp.nec.com> wrote:

> -void thaw_bdev(struct block_device *bdev, struct super_block *sb)
> +int thaw_bdev(struct block_device *bdev, struct super_block *sb)
>  {
> +	int error = 0;
> +
> +	mutex_lock(&bdev->bd_fsfreeze_mutex);
> +	if (!bdev->bd_fsfreeze_count) {
> +		mutex_unlock(&bdev->bd_fsfreeze_mutex);
> +		return -EINVAL;

This would be a programming error, yes?

If so, a WARN_ON is more appropriate than a silent runtime error.

> +	}
