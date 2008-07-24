Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 22:44:26 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6O5iM6N003292
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 22:44:24 -0700
Date: Thu, 24 Jul 2008 01:45:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Prevent log tail pushing from blocking on buffer locks
Message-ID: <20080724054531.GA17215@infradead.org>
References: <48857EFB.3030301@sgi.com> <20080723112154.GA17338@infradead.org> <48881788.7010709@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48881788.7010709@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jul 24, 2008 at 03:47:52PM +1000, Lachlan McIlroy wrote:
>> The stuck propagation looks good, but I don't think this should be
>> blindly done for all errors.  The only error where it makes sense is
>> the EAGAIN from xfs_iflush.  All other returns inside the item_push
>> handlers basically indicate filesystem corruption.
>
> Good point.  Regardless of the error it's still an item that could not
> be pushed and is effectively 'stuck'.  What do you recommend I do for
> other errors?  Shutdown the filesystem?

Good questions.  When I did a quick audit many error do in fact come
from tests for shutdown filesystems, so they shouldn't ever happens.
So maybe add an assert that we're never getting here for shut down
filesystems and otherwise shut it down.

But all this is getting a little complicated and riksy, so I'd say push
your original patch in first and make the error handling a second one.
