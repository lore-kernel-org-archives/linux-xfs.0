Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59520 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfDWGeW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Apr 2019 02:34:22 -0400
Date: Mon, 22 Apr 2019 23:34:21 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: implement per-inode writeback completion queues
Message-ID: <20190423063421.GA6788@infradead.org>
References: <155529406249.243484.1307333973877627694.stgit@magnolia>
 <155529406877.243484.8074329168835632578.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155529406877.243484.8074329168835632578.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

I'm a little late to the game, sorry..

But:

> +
> +	spin_lock_irqsave(&ip->i_iodone_lock, flags);
> +	list_replace_init(&ip->i_iodone_list, &completion_list);
> +	spin_unlock_irqrestore(&ip->i_iodone_lock, flags);

I really don't like this new per-inode lock, and the irq disabling at
all.  Especially as the pattern perfectly fits the lockless lists (llists).
Can you check if these work here?
