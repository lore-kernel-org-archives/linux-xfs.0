Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:58173 "EHLO
        mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752472AbcJDN5n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2016 09:57:43 -0400
Date: Tue, 4 Oct 2016 09:57:38 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <371043461.349958.1475589458359.JavaMail.zimbra@redhat.com>
In-Reply-To: <20161003211229.GN27872@dastard>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <20160923190032.GA25771@ZenIV.linux.org.uk> <2131586457.763354.1475242373422.JavaMail.zimbra@redhat.com> <1415238593.811146.1475257337058.JavaMail.zimbra@redhat.com> <20161003014218.GS19539@ZenIV.linux.org.uk> <19064316.41568.1475503587628.JavaMail.zimbra@redhat.com> <59188294.61623.1475508050989.JavaMail.zimbra@redhat.com> <20161003211229.GN27872@dastard>
Subject: Re: [RFC][CFT] splice_read reworked
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org


> This usually happens when an application mixes mmap access and
> direct IO to the same file. The warning fires when the direct IO
> cannot invalidate the cached range after writeback (e.g. writeback
> raced with mmap app faulting and dirtying the page again), and hence
> results in the page cache containing stale data.  This warning fires
> when that happens, indicating to developers who get a bug report
> about data corruption that it's the userspace application that is
> the problem, not the filesystem. i.e the application is doing
> something we explicitly document they should not do:
> 
> $ man 2 open
> ....
>   O_DIRECT
> ....
>        Applications should avoid mixing O_DIRECT and normal I/O to
>        the same file, and especially to overlapping byte regions in
>        the  same  file.   Even  when  the filesystem  correctly
>        handles the coherency issues in this situation, overall I/O
>        throughput is likely to be slower than using either mode
>        alone.  Likewise, applications should avoid mixing mmap(2) of
>        files with direct I/O to the same files.
> 
> Splice should not have this problem if the IO path locking is
> correct, as both direct IO and splice IO use the same inode lock for
> exclusion. i.e. splice write should not be running at the same time
> as a direct IO read or write....
OK, so I assume that trinity is doing something that a proper userspace
application won't be doing which is fine, and there is nothing to worry
about from the kernel's perspective.

I just want to make sure there is no security implication here that a
non-privileged user could corrupt other users' data etc.
   CAI Qian

