Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f43.google.com ([209.85.167.43]:35623 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfFOEB0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 Jun 2019 00:01:26 -0400
Received: by mail-lf1-f43.google.com with SMTP id a25so3021553lfg.2
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2019 21:01:25 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id 25sm890527ljo.38.2019.06.14.21.01.23
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 21:01:24 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id k18so4250297ljc.11
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2019 21:01:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
 <20190611011737.GA28701@kmo-pixel> <20190611043336.GB14363@dread.disaster.area>
 <20190612162144.GA7619@kmo-pixel> <20190612230224.GJ14308@dread.disaster.area>
 <20190613183625.GA28171@kmo-pixel> <20190613235524.GK14363@dread.disaster.area>
 <CAHk-=whMHtg62J2KDKnyOTaoLs9GxcNz1hN9QKqpxoO=0bJqdQ@mail.gmail.com>
In-Reply-To: <CAHk-=whMHtg62J2KDKnyOTaoLs9GxcNz1hN9QKqpxoO=0bJqdQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Jun 2019 18:01:07 -1000
Message-ID: <CAHk-=wgz+7O0pdn8Wfxc5EQKNy44FTtf4LAPO1WgCidNjxbWzg@mail.gmail.com>
Subject: Re: pagecache locking (was: bcachefs status update) merged)
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>

On Thu, Jun 13, 2019 at 5:08 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I do not believe that posix itself actually requires that at all,
> although extended standards may.

So I tried to see if I could find what this perhaps alludes to.

And I suspect it's not in the read/write thing, but the pthreads side
talks about atomicity.

Interesting, but I doubt if that's actually really intentional, since
the non-thread read/write behavior specifically seems to avoid the
whole concurrency issue.

The pthreads atomicity thing seems to be about not splitting up IO and
doing it in chunks when you have m:n threading models, but can be
(mis-)construed to have threads given higher atomicity guarantees than
processes.

               Linus
