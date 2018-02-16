Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:51370 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753922AbeBPIH7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Feb 2018 03:07:59 -0500
Received: by mail-wm0-f47.google.com with SMTP id r71so1584477wmd.1
        for <linux-xfs@vger.kernel.org>; Fri, 16 Feb 2018 00:07:58 -0800 (PST)
Subject: Re: xfs_buf_lock vs aio
References: <20180207233320.GB20367@dastard>
 <ed83833b-5024-40f2-b335-2dcab7fddf0e@scylladb.com>
 <20180208221153.GF20266@dastard>
 <30274e7a-4029-73b8-0d8b-cdfda450e3bc@scylladb.com>
 <20180209231015.GI20266@dastard>
 <697bf891-e7c4-4d60-e2ce-f1ba6935b38b@scylladb.com>
 <20180213051850.GE6778@dastard>
 <f8b3b7a4-eba4-d5ab-1748-a8382a2a8fd6@scylladb.com>
 <20180214235616.GM7000@dastard>
 <1f90f49b-e11d-3140-f73b-5834e52b5f8a@scylladb.com>
 <20180215213030.GO7000@dastard>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <946349de-471f-f766-47d8-f32959990cc6@scylladb.com>
Date: Fri, 16 Feb 2018 10:07:55 +0200
MIME-Version: 1.0
In-Reply-To: <20180215213030.GO7000@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 02/15/2018 11:30 PM, Dave Chinner wrote:
> On Thu, Feb 15, 2018 at 11:36:54AM +0200, Avi Kivity wrote:
>> On 02/15/2018 01:56 AM, Dave Chinner wrote:
>> A little bird whispered in my ear to try XFS_IOC_OPEN_BY_HANDLE to
>> avoid the the time update lock, so we'll be trying that next, to
>> emulate lazytime.
> Biggest problem with that is it requires root permissions. It's not
> a solution that can be deployed in practice, so I haven't bothered
> suggesting it as something to try.
>
> If you want to try lazytime, an easier test might be to rebuild the
> kernel with this change below to support the lazytime mount option
> and not log the timestamp updates. This is essentially the mechanism
> that I'll use for this, but it will need to grow more stuff to have
> the correct lazytime semantics...
>

We tried open by handle to see if lazytime would provide relief, but it 
looks like it just pushes the lock acquisition to another place:

reactor-8 16033 [009] 1482121.241125:                xfs:xfs_ilock:
dev 9:2 ino 0xc0004bac flags ILOCK_EXCL caller kretprobe_trampoline
             7fffa01ca572 xfs_ilock ([kernel.kallsyms])
             7fff8105f5a0 kretprobe_trampoline ([kernel.kallsyms])
             7fff812bd2ea iomap_apply ([kernel.kallsyms])
             7fff812bdb81 iomap_dio_rw ([kernel.kallsyms])
             7fffa01bbc26 xfs_file_dio_aio_write ([kernel.kallsyms])
             7fffa01bc13f xfs_file_write_iter ([kernel.kallsyms])
             7fff812ab24f aio_write ([kernel.kallsyms])
             7fff812ab90e do_io_submit ([kernel.kallsyms])
             7fff812ac4c0 sys_io_submit ([kernel.kallsyms])
             7fff81005917 do_syscall_64 ([kernel.kallsyms])
             7fff81802115 return_from_SYSCALL_64 ([kernel.kallsyms])
                    f27f9 syscall (/usr/lib64/libc-2.17.so)
                       1c [unknown] ([unknown])
                   142e60 reactor_backend_epoll::~reactor_backend_epoll
(/usr/bin/scylla)

Probably, iomap_apply calls xfs_file_iomap_begin, which calls xfs_ilock().

It consults need_excl_ilock() to see whether it wants to lock or not:

static inline bool need_excl_ilock(struct xfs_inode *ip, unsigned flags)
{
         /*
          * COW writes will allocate delalloc space, so we need to make sure
          * to take the lock exclusively here.
          */
         if (xfs_is_reflink_inode(ip) && (flags & (IOMAP_WRITE | 
IOMAP_ZERO)))
                 return true;
         if ((flags & IOMAP_DIRECT) && (flags & IOMAP_WRITE))
                 return true;
         return false;
}

However, that function can EAGAIN (it does for IOLOCK) so maybe we can 
change xfs_ilock to xfs_ilock_nowait and teach it about not waiting for 
ILOCK too.

