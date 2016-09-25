Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:39368 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932525AbcIYVp0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Sep 2016 17:45:26 -0400
Date: Mon, 26 Sep 2016 07:45:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mm: remove unnecessary rcu_lock/unlock around
 radix_tree_tagged lockless function. The function queue_delayed_work is
 already protected with interrupts disabled, hence no need to add
 rcu_lock/unlock.
Message-ID: <20160925214524.GS340@dastard>
References: <20160925192005.GA6517@sudip-Dell-System-Vostro-3450>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160925192005.GA6517@sudip-Dell-System-Vostro-3450>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sudip Midya <midya.sudip@gmail.com>
Cc: xfs@oss.sgi.com, hch@infradead.org, linux-xfs@vger.kernel.org

On Mon, Sep 26, 2016 at 12:50:06AM +0530, Sudip Midya wrote:
> Signed-off-by: Sudip Midya <midya.sudip@gmail.com>
> ---

Patch format still needs work. The subject line should be short, the
patch description should be in the body of the message, not the
subject. Also, this is not a patch for the "mm" subsystem.

Addressing the reason given for the change: the RCU lock is not
actually protecting queue_delayed_work(), so while the code change
may be OK, the reason given for removing it is not. So why is it
safe to remove the rcu_read_lock()?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
