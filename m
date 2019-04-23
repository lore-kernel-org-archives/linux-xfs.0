Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36444 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbfDWP3j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Apr 2019 11:29:39 -0400
Date: Tue, 23 Apr 2019 08:29:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/3] xfs: implement per-inode writeback completion queues
Message-ID: <20190423152930.GH4676@magnolia>
References: <155529406249.243484.1307333973877627694.stgit@magnolia>
 <155529406877.243484.8074329168835632578.stgit@magnolia>
 <20190423063421.GA6788@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190423063421.GA6788@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 22, 2019 at 11:34:21PM -0700, Christoph Hellwig wrote:
> I'm a little late to the game, sorry..
> 
> But:
> 
> > +
> > +	spin_lock_irqsave(&ip->i_iodone_lock, flags);
> > +	list_replace_init(&ip->i_iodone_list, &completion_list);
> > +	spin_unlock_irqrestore(&ip->i_iodone_lock, flags);
> 
> I really don't like this new per-inode lock, and the irq disabling at
> all.  Especially as the pattern perfectly fits the lockless lists (llists).
> Can you check if these work here?

They certainly look promising, though the singly-linked list nature
means it can't be a direct replacement for xfs_ioend.io_list because we
still need to be able to sort and merge completions.  However, adding
another pointer to xfs_ioend won't change the objects per slab ratio, so
avoiding the spinlock heartburn might be worth it...

--D
