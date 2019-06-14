Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45879 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfFNDIh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 23:08:37 -0400
Received: by mail-lj1-f193.google.com with SMTP id m23so766738lje.12
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2019 20:08:35 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id g15sm313603ljk.83.2019.06.13.20.08.33
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:08:33 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id 131so809673ljf.4
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2019 20:08:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
 <20190611011737.GA28701@kmo-pixel> <20190611043336.GB14363@dread.disaster.area>
 <20190612162144.GA7619@kmo-pixel> <20190612230224.GJ14308@dread.disaster.area>
 <20190613183625.GA28171@kmo-pixel> <20190613235524.GK14363@dread.disaster.area>
In-Reply-To: <20190613235524.GK14363@dread.disaster.area>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Jun 2019 17:08:16 -1000
Message-ID: <CAHk-=whMHtg62J2KDKnyOTaoLs9GxcNz1hN9QKqpxoO=0bJqdQ@mail.gmail.com>
Subject: Re: pagecache locking (was: bcachefs status update) merged)
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>

On Thu, Jun 13, 2019 at 1:56 PM Dave Chinner <david@fromorbit.com> wrote:
>
> - buffered read and buffered write can run concurrently if they
> don't overlap, but right now they are serialised because that's the
> only way to provide POSIX atomic write vs read semantics (only XFS
> provides userspace with that guarantee).

I do not believe that posix itself actually requires that at all,
although extended standards may.

That said, from a quality of implementation standpoint, it's obviously
a good thing to do, so it might be worth looking at if something
reasonable can be done. The XFS atomicity guarantees are better than
what other filesystems give, but they might also not be exactly
required.

But POSIX actually ends up being pretty lax, and says

  "Writes can be serialized with respect to other reads and writes. If
a read() of file data can be proven (by any means) to occur after a
write() of the data, it must reflect that write(), even if the calls
are made by different processes. A similar requirement applies to
multiple write operations to the same file position. This is needed to
guarantee the propagation of data from write() calls to subsequent
read() calls. This requirement is particularly significant for
networked file systems, where some caching schemes violate these
semantics."

Note the "can" in "can be serialized", not "must". Also note that
whole language about how the read file data must match the written
data only if the read can be proven to have occurred after a write of
that data.  Concurrency is very much left in the air, only provably
serial operations matter.

(There is also language that talks about "after the write has
successfully returned" etc - again, it's about reads that occur
_after_ the write, not concurrently with the write).

The only atomicity guarantees are about the usual pipe writes and
PIPE_BUF. Those are very explicit.

Of course, there are lots of standards outside of just the POSIX
read/write thing, so you may be thinking of some other stricter
standard. POSIX itself has always been pretty permissive.

And as mentioned, I do agree from a QoI standpoint that atomicity is
nice, and that the XFS behavior is better. However, it does seem that
nobody really cares, because I'm not sure we've ever done it in
general (although we do have that i_rwsem, but I think it's mainly
used to give the proper lseek behavior). And so the XFS behavior may
not necessarily be *worth* it, although I presume you have some test
for this as part of xfstests.

                Linus
