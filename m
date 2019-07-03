Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f50.google.com ([209.85.208.50]:42922 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbfGCBZ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jul 2019 21:25:58 -0400
Subject: Re: pagecache locking
References: <20190612162144.GA7619@kmo-pixel>
 <20190612230224.GJ14308@dread.disaster.area>
 <20190613183625.GA28171@kmo-pixel>
 <20190613235524.GK14363@dread.disaster.area>
 <CAHk-=whMHtg62J2KDKnyOTaoLs9GxcNz1hN9QKqpxoO=0bJqdQ@mail.gmail.com>
 <CAHk-=wgz+7O0pdn8Wfxc5EQKNy44FTtf4LAPO1WgCidNjxbWzg@mail.gmail.com>
 <20190617224714.GR14363@dread.disaster.area>
 <CAHk-=wiR3a7+b0cUN45hGp1dvFh=s1i1OkVhoP7CivJxKqsLFQ@mail.gmail.com>
 <CAOQ4uxjqQjrCCt=ixgdUYjBJvKLhw4R9NeMZOB_s2rrWvoDMBw@mail.gmail.com>
 <20190619103838.GB32409@quack2.suse.cz>
 <20190619223756.GC26375@dread.disaster.area>
 <3f394239-f532-23eb-9ff1-465f7d1f3cb4@gmail.com>
 <DM6PR19MB250857CB8A3A1C8279D6F2F3C5FB0@DM6PR19MB2508.namprd19.prod.outlook.com>
From: Boaz Harrosh <openosd@gmail.com>
Message-ID: <9bc50b26-d424-d48a-16db-6fd7e0e88f79@gmail.com>
Date: Wed, 3 Jul 2019 04:25:53 +0300
MIME-Version: 1.0
In-Reply-To: <DM6PR19MB250857CB8A3A1C8279D6F2F3C5FB0@DM6PR19MB2508.namprd19.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Patrick Farrell <pfarrell@whamcloud.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>
Cc: Amir Goldstein <amir73il@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Kent Overstreet <kent.overstreet@gmail.com>, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>

On 03/07/2019 04:07, Patrick Farrell wrote:
> Recursively read locking is generally unsafe, that’s why lockdep
> complains about it.  The common RW lock primitives are queued in
> their implementation, meaning this recursive read lock sequence:
> P1 - read (gets lock)
> P2 - write
> P1 - read
> 
> Results not in a successful read lock, but P1 blocking behind P2,
> which is blocked behind P1.  

> Readers are not allowed to jump past waiting writers.

OK thanks that makes sense. I did not know about that last part. Its a kind
of a lock fairness I did not know we have.

So I guess I'll keep my two locks than. The write_locker is the SLOW
path for me anyway, right?

[if we are already at the subject, Do mutexes have the same lock fairness as
 above? Do the write_lock side of rw_sem have same fairness? Something I never
 figured out]

Thanks
Boaz

> 
> - Patrick
