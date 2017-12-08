Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42498 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751944AbdLHSOt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Dec 2017 13:14:49 -0500
Date: Fri, 8 Dec 2017 10:14:38 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: Lockdep is less useful than it was
Message-ID: <20171208181438.GA6406@bombadil.infradead.org>
References: <20171206004159.3755-73-willy@infradead.org>
 <20171206012901.GZ4094@dastard>
 <20171206020208.GK26021@bombadil.infradead.org>
 <20171206031456.GE4094@dastard>
 <20171206044549.GO26021@bombadil.infradead.org>
 <20171206084404.GF4094@dastard>
 <20171206140648.GB32044@bombadil.infradead.org>
 <20171207160634.il3vt5d6a4v5qesi@thunk.org>
 <20171207223803.GC26792@bombadil.infradead.org>
 <20171208152717.fx5w66wvyrfx6vrz@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171208152717.fx5w66wvyrfx6vrz@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@kernel.org, byungchul.park@lge.com

On Fri, Dec 08, 2017 at 10:27:17AM -0500, Theodore Ts'o wrote:
> So if you are adding complexity to the kernel with the argument,
> "lockdep will save us", I'm with Dave --- it's just not a believable
> argument.

I think that's a gross misrepresentation of what I'm doing.

At the moment, the radix tree actively disables the RCU checking that
enabling lockdep would give us.  It has to, because it has no idea what
lock protects any individual access to the radix tree.  The XArray can
use the RCU checking because it knows that every reference is protected
by either the spinlock or the RCU lock.

Dave was saying that he has a tree which has to be protected by a mutex
because of where it is in the locking hierarchy, and I was vigorously
declining his proposal of allowing him to skip taking the spinlock.

And yes, we have bugs today that I assume we only stumble across every
few billion years (or only on alpha, or only if our compiler gets more
aggressive) because we have missing rcu_dereference annotations.
