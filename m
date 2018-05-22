Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:40994 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751719AbeEVDtL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 May 2018 23:49:11 -0400
Date: Mon, 21 May 2018 23:49:06 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH] [RFC] bcachefs: SIX locks (shared/intent/exclusive)
Message-ID: <20180522034906.GA4535@kmo-pixel>
References: <20180522021951.1453-1-kent.overstreet@gmail.com>
 <20180522030416.GB18682@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180522030416.GB18682@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, peterz@infradead.org

On Mon, May 21, 2018 at 08:04:16PM -0700, Matthew Wilcox wrote:
> On Mon, May 21, 2018 at 10:19:51PM -0400, Kent Overstreet wrote:
> > New lock for bcachefs, like read/write locks but with a third state,
> > intent.
> > 
> > Intent locks conflict with each other, but not with read locks; taking a
> > write lock requires first holding an intent lock.
> 
> Can you put something in the description that these are sleeping locks
> (like mutexes), not spinning locks (like spinlocks)?  (Yeah, I know
> there's the opportunistic spin, but conceptually, they're sleeping locks).

Yup, I'll add that

> 
> Some other things I'd like documented:
> 
>  - Any number of readers can hold the lock
>  - Once one thread acquires the lock for intent, further intent acquisitions
>    will block.  May new readers acquire the lock?

I think I should have that covered already - "Intent does not block read, but
does block other intent locks"

>  - You cannot acquire the lock for write directly, you must acquire it for
>    intent first, then upgrade to write.
>  - Can you downgrade to read from intent, or downgrade from write back to
>    intent?

You hold both write and intent, like so:

six_lock_intent(&foo->lock);
six_lock_write(&foo->lock);
six_unlock_write(&foo->lock);
six_unlock_intent(&foo->lock);


>  - Once you are trying to upgrade from intent to write, are new read
>    acquisitions blocked? (can readers starve writers?)

Readers can starve writers in the current implementation, but that's something
that should probably be fixed...

>  - When you drop the lock as a writer, do we prefer reader acquisitions
>    over intent acquisitions?  That is, if we have a queue of RRIRIRIR,
>    and we drop the lock, does the queue look like II or IRIR?

Separate queues per lock type, so dropping a write lock will wake up everyone
trying to take a read lock, and dropping an intent lock wakes up everyone trying
to take an intent lock.

---

Here's the new documentation I just wrote:

/*
 * Shared/intent/exclusive locks: sleepable read/write locks, much like rw
 * semaphores, except with a third intermediate state, intent. Basic operations
 * are:
 *
 * six_lock_read(&foo->lock);
 * six_unlock_read(&foo->lock);
 *
 * six_lock_intent(&foo->lock);
 * six_unlock_intent(&foo->lock);
 *
 * six_lock_write(&foo->lock);
 * six_unlock_write(&foo->lock);
 *
 * Intent locks block other intent locks, but do not block read locks, and you
 * must have an intent lock held before taking a write lock, like so:
 *
 * six_lock_intent(&foo->lock);
 * six_lock_write(&foo->lock);
 * six_unlock_write(&foo->lock);
 * six_unlock_intent(&foo->lock);
 *
 * Other operations:
 *
 *   six_trylock_read()
 *   six_trylock_intent()
 *   six_trylock_write()
 *
 *   six_lock_downgrade():	convert from intent to read
 *   six_lock_tryupgrade():	attempt to convert from read to intent
 *
 * Locks also embed a sequence number, which is incremented when the lock is
 * locked or unlocked for write. The current sequence number can be grabbed
 * while a lock is held from lock->state.seq; then, if you drop the lock you can
 * use six_relock_(read|intent_write)(lock, seq) to attempt to retake the lock
 * iff it hasn't been locked for write in the meantime.
 *
 * There are also operations that take the lock type as a parameter, where the
 * type is one of SIX_LOCK_read, SIX_LOCK_intent, or SIX_LOCK_write:
 *
 *   six_lock_type(lock, type)
 *   six_unlock_type(lock, type)
 *   six_relock(lock, type, seq)
 *   six_trylock_type(lock, type)
 *   six_trylock_convert(lock, from, to)
 *
 * A lock may be held multiple types by the same thread (for read or intent,
 * not write) - up to SIX_LOCK_MAX_RECURSE. However, the six locks code does
 * _not_ implement the actual recursive checks itself though - rather, if your
 * code (e.g. btree iterator code) knows that the current thread already has a
 * lock held, and for the correct type, six_lock_increment() may be used to
 * bump up the counter for that type - the only effect is that one more call to
 * unlock will be required before the lock is unlocked.
 *
 */
