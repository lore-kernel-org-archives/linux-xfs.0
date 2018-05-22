Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36094 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751505AbeEVDES (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 May 2018 23:04:18 -0400
Date: Mon, 21 May 2018 20:04:16 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] [RFC] bcachefs: SIX locks (shared/intent/exclusive)
Message-ID: <20180522030416.GB18682@bombadil.infradead.org>
References: <20180522021951.1453-1-kent.overstreet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180522021951.1453-1-kent.overstreet@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, peterz@infradead.org

On Mon, May 21, 2018 at 10:19:51PM -0400, Kent Overstreet wrote:
> New lock for bcachefs, like read/write locks but with a third state,
> intent.
> 
> Intent locks conflict with each other, but not with read locks; taking a
> write lock requires first holding an intent lock.

Can you put something in the description that these are sleeping locks
(like mutexes), not spinning locks (like spinlocks)?  (Yeah, I know
there's the opportunistic spin, but conceptually, they're sleeping locks).

Some other things I'd like documented:

 - Any number of readers can hold the lock
 - Once one thread acquires the lock for intent, further intent acquisitions
   will block.  May new readers acquire the lock?
 - You cannot acquire the lock for write directly, you must acquire it for
   intent first, then upgrade to write.
 - Can you downgrade to read from intent, or downgrade from write back to
   intent?
 - Once you are trying to upgrade from intent to write, are new read
   acquisitions blocked? (can readers starve writers?)
 - When you drop the lock as a writer, do we prefer reader acquisitions
   over intent acquisitions?  That is, if we have a queue of RRIRIRIR,
   and we drop the lock, does the queue look like II or IRIR?

