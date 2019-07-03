Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42523 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbfGCAbe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jul 2019 20:31:34 -0400
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
From: Boaz Harrosh <openosd@gmail.com>
Message-ID: <3f394239-f532-23eb-9ff1-465f7d1f3cb4@gmail.com>
Date: Wed, 3 Jul 2019 03:04:45 +0300
MIME-Version: 1.0
In-Reply-To: <20190619223756.GC26375@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>
Cc: Amir Goldstein <amir73il@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Kent Overstreet <kent.overstreet@gmail.com>, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>

On 20/06/2019 01:37, Dave Chinner wrote:
<>
> 
> I'd prefer it doesn't get lifted to the VFS because I'm planning on
> getting rid of it in XFS with range locks. i.e. the XFS_MMAPLOCK is
> likely to go away in the near term because a range lock can be
> taken on either side of the mmap_sem in the page fault path.
> 
<>
Sir Dave

Sorry if this was answered before. I am please very curious. In the zufs
project I have an equivalent rw_MMAPLOCK that I _read_lock on page_faults.
(Read & writes all take read-locks ...)
The only reason I have it is because of lockdep actually.

Specifically for those xfstests that mmap a buffer then direct_IO in/out
of that buffer from/to another file in the same FS or the same file.
(For lockdep its the same case).
I would be perfectly happy to recursively _read_lock both from the top
of the page_fault at the DIO path, and under in the page_fault. I'm
_read_locking after all. But lockdep is hard to convince. So I stole the
xfs idea of having an rw_MMAPLOCK. And grab yet another _write_lock at
truncate/punch/clone time when all mapping traversal needs to stop for
the destructive change to take place. (Allocations are done another way
and are race safe with traversal)

How do you intend to address this problem with range-locks? ie recursively
taking the same "lock"? because if not for the recursive-ity and lockdep I would
not need the extra lock-object per inode.

Thanks
Boaz
