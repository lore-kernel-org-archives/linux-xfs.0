Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 May 2008 12:31:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4PJVMHR030022
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 12:31:25 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C9B7D1B0283
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 12:32:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id AgkRqaNk3DBt7s8b for <xfs@oss.sgi.com>; Sun, 25 May 2008 12:32:13 -0700 (PDT)
Date: Sun, 25 May 2008 15:32:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
Message-ID: <20080525193211.GA24328@infradead.org>
References: <20080522175020t-sato@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522175020t-sato@mail.jp.nec.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

> +	if (test_and_set_bit(BD_FREEZE_OP, &bdev->bd_state))
> +		return ERR_PTR(-EBUSY);
> +
> +	sb = get_super_without_lock(bdev);
> +
> +	/* If super_block has been already frozen, return. */
> +	if (sb && sb->s_frozen != SB_UNFROZEN) {
> +		put_super(sb);
> +		clear_bit(BD_FREEZE_OP, &bdev->bd_state);
> +		return sb;
> +	}

The BD_FREEZE_OP flag in the block_device already prevents multiple
freezes for a singe block device, so there is no need for this
additional check and the get_super_without_lock helper.

>  	down(&bdev->bd_mount_sem);

And with that flag bd_mount_sem is also obsolete for preventing the
multiple freeze operations.  We still need investigate what
synchronization we need vs unmount which also takes bd_mount_sem without
every having document what it exactly protects.
