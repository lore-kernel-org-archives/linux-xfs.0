Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39354 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750978AbdLFEw5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Dec 2017 23:52:57 -0500
Date: Tue, 5 Dec 2017 20:52:54 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v4 72/73] xfs: Convert mru cache to XArray
Message-ID: <20171206045254.GP26021@bombadil.infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206004159.3755-73-willy@infradead.org>
 <20171206012901.GZ4094@dastard>
 <20171206020208.GK26021@bombadil.infradead.org>
 <20171206031456.GE4094@dastard>
 <20171206044549.GO26021@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171206044549.GO26021@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 05, 2017 at 08:45:49PM -0800, Matthew Wilcox wrote:
> The dquot code is just going to have to live with the fact that there's
> additional locking going on that it doesn't need.  I'm open to getting
> rid of the irqsafety, but we can't give up the spinlock protection
> without giving up the RCU/lockdep analysis and the ability to move nodes.
> I don't suppose the dquot code can 

Oops, thought I'd finished writing this paragraph.

I don't suppose the dquot code can be restructured to use the xa_lock to
protect, say, qi_dquots?  I suspect not, since you wouldn't know which
of the three xarray locks to use.
