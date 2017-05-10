Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:34041 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752602AbdEJO4U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2017 10:56:20 -0400
Received: by mail-qt0-f169.google.com with SMTP id j29so31680723qtj.1
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2017 07:56:19 -0700 (PDT)
Message-ID: <1494428176.2688.25.camel@redhat.com>
Subject: Re: [PATCH v4 13/27] lib: add errseq_t type and infrastructure for
 handling it
From: Jeff Layton <jlayton@redhat.com>
Date: Wed, 10 May 2017 10:56:16 -0400
In-Reply-To: <20170510141821.GB1590@bombadil.infradead.org>
References: <20170509154930.29524-1-jlayton@redhat.com>
         <20170509154930.29524-14-jlayton@redhat.com>
         <20170510141821.GB1590@bombadil.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk, josef@toxicpanda.com, hubcap@omnibond.com, rpeterso@redhat.com, bo.li.liu@oracle.com

On Wed, 2017-05-10 at 07:18 -0700, Matthew Wilcox wrote:
> On Tue, May 09, 2017 at 11:49:16AM -0400, Jeff Layton wrote:
> > +++ b/lib/errseq.c
> > @@ -0,0 +1,199 @@
> > +#include <linux/err.h>
> > +#include <linux/bug.h>
> > +#include <linux/atomic.h>
> > +#include <linux/errseq.h>
> > +
> > +/*
> > + * An errseq_t is a way of recording errors in one place, and allowing any
> > + * number of "subscribers" to tell whether it has changed since an arbitrary
> > + * time of their choosing.
> 
> You use the word "time" in several places in the documentation, but I think
> it's clearer to say "sampling point" or "sample", since you're not using jiffies
> or nanoseconds.  For example, I'd phrase this paragraph this way:
> 
>  * An errseq_t is a way of recording errors in one place, and allowing any
>  * number of "subscribers" to tell whether it has changed since they last
>  * sampled it.
> 
> > + * The general idea is for consumers to sample an errseq_t value at a
> > + * particular point in time. Later, that value can be used to tell whether any
> > + * new errors have occurred since that time.
> 
>  * The general idea is for consumers to sample an errseq_t value.  That
>  * value can be used to tell whether any new errors have occurred since
>  * the last time it was sampled.
> 
> > +/* The "ones" bit for the counter */
> 
> Maybe "The lowest bit of the counter"?
> 
> > +/**
> > + * errseq_check - has an error occurred since a particular point in time?
> 
> "has an error occurred since the last time it was sampled"
> 
> > +/**
> > + * errseq_check_and_advance - check an errseq_t and advance it to the current value
> > + * @eseq: pointer to value being checked reported
> 
> "value being checked reported"?
> 

Thanks. I'm cleaning up the comments like you suggest.

> > +int errseq_check_and_advance(errseq_t *eseq, errseq_t *since)
> > +{
> > +	int err = 0;
> > +	errseq_t old, new;
> > +
> > +	/*
> > +	 * Most callers will want to use the inline wrapper to check this,
> > +	 * so that the common case of no error is handled without needing
> > +	 * to lock.
> > +	 */
> > +	old = READ_ONCE(*eseq);
> > +	if (old != *since) {
> > +		/*
> > +		 * Set the flag and try to swap it into place if it has
> > +		 * changed.
> > +		 *
> > +		 * We don't care about the outcome of the swap here. If the
> > +		 * swap doesn't occur, then it has either been updated by a
> > +		 * writer who is bumping the seq count anyway, or another
> > +		 * reader who is just setting the "seen" flag. Either outcome
> > +		 * is OK, and we can advance "since" and return an error based
> > +		 * on what we have.
> > +		 */
> > +		new = old | ERRSEQ_SEEN;
> > +		if (new != old)
> > +			cmpxchg(eseq, old, new);
> > +		*since = new;
> > +		err = -(new & MAX_ERRNO);
> > +	}
> 
> I probably need to read through the patchset some more to understand this.
> Naively, surely "since" should be updated to the current value of 'eseq'
> if we failed the cmpxchg()?

I don't think so. If we want to do that, then we'll need to redrive the
cmpxchg to set the SEEN flag if it's now clear. Storing the value in
"since" is effectively sampling it, so you do have to mark it seen.

The good news is that I think that "new" is just as valid a value to
store here as *eseq would be. It ends up representing an errseq_t value
that never actually got stored in eseq, but that's OK with the way this
works.

-- 
Jeff Layton <jlayton@redhat.com>
