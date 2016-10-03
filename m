Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:32886 "EHLO
        mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750822AbcJCOGg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Oct 2016 10:06:36 -0400
Date: Mon, 3 Oct 2016 10:06:27 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <19064316.41568.1475503587628.JavaMail.zimbra@redhat.com>
In-Reply-To: <20161003014218.GS19539@ZenIV.linux.org.uk>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <20160914042559.GC2356@ZenIV.linux.org.uk> <20160917082007.GA6489@ZenIV.linux.org.uk> <20160917190023.GA8039@ZenIV.linux.org.uk> <20160923190032.GA25771@ZenIV.linux.org.uk> <2131586457.763354.1475242373422.JavaMail.zimbra@redhat.com> <1415238593.811146.1475257337058.JavaMail.zimbra@redhat.com> <20161003014218.GS19539@ZenIV.linux.org.uk>
Subject: Re: [RFC][CFT] splice_read reworked
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org



----- Original Message -----
> From: "Al Viro" <viro@ZenIV.linux.org.uk>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Dave Chinner" <david@fromorbit.com>, "linux-xfs"
> <linux-xfs@vger.kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "Nick Piggin" <npiggin@gmail.com>,
> linux-fsdevel@vger.kernel.org
> Sent: Sunday, October 2, 2016 9:42:18 PM
> Subject: Re: [RFC][CFT] splice_read reworked
> 
> On Fri, Sep 30, 2016 at 01:42:17PM -0400, CAI Qian wrote:
> 
> > [ 1599.151286] ------------[ cut here ]------------
> > [ 1599.156457] WARNING: CPU: 37 PID: 95143 at lib/iov_iter.c:316
> > sanity+0x75/0x80
> 
> [snip]
> 
> > [ 1599.344171]  [<ffffffff813e9b45>] sanity+0x75/0x80
> > [ 1599.349518]  [<ffffffff813ec739>] copy_page_to_iter+0xf9/0x1e0
> > [ 1599.356027]  [<ffffffff8120691f>] shmem_file_read_iter+0x9f/0x340
> > [ 1599.362829]  [<ffffffff812bbeb9>] generic_file_splice_read+0xb9/0x1b0
> > [ 1599.370015]  [<ffffffff812bc206>] do_splice_to+0x76/0x90
> > [ 1599.375941]  [<ffffffff812bc2db>] splice_direct_to_actor+0xbb/0x220
> > [ 1599.382935]  [<ffffffff812bba80>] ? generic_pipe_buf_nosteal+0x10/0x10
> > [ 1599.390220]  [<ffffffff812bc4d8>] do_splice_direct+0x98/0xd0
> > [ 1599.396537]  [<ffffffff81281dd1>] do_sendfile+0x1d1/0x3b0
> > [ 1599.402563]  [<ffffffff81282973>] SyS_sendfile64+0x73/0xd0
> > [ 1599.408685]  [<ffffffff81003f8c>] do_syscall_64+0x6c/0x1e0
> > [ 1599.414820]  [<ffffffff817d927f>] entry_SYSCALL64_slow_path+0x25/0x25
> 
> IOW, sendfile from shmem...  How easily is that reproduced (IOW, did you
> get any more of those)?
> 
It is pretty reproducible so far by just running the trinity from a docker
container backed by overlayfs/xfs.

# su - test
$ trinity

   CAI Qian
