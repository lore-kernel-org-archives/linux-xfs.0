Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:56388 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751882AbcJCBmV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2016 21:42:21 -0400
Date: Mon, 3 Oct 2016 02:42:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC][CFT] splice_read reworked
Message-ID: <20161003014218.GS19539@ZenIV.linux.org.uk>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <20160914031648.GB2356@ZenIV.linux.org.uk>
 <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
 <20160914042559.GC2356@ZenIV.linux.org.uk>
 <20160917082007.GA6489@ZenIV.linux.org.uk>
 <20160917190023.GA8039@ZenIV.linux.org.uk>
 <20160923190032.GA25771@ZenIV.linux.org.uk>
 <2131586457.763354.1475242373422.JavaMail.zimbra@redhat.com>
 <1415238593.811146.1475257337058.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415238593.811146.1475257337058.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: CAI Qian <caiqian@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org

On Fri, Sep 30, 2016 at 01:42:17PM -0400, CAI Qian wrote:

> [ 1599.151286] ------------[ cut here ]------------
> [ 1599.156457] WARNING: CPU: 37 PID: 95143 at lib/iov_iter.c:316 sanity+0x75/0x80

[snip]

> [ 1599.344171]  [<ffffffff813e9b45>] sanity+0x75/0x80
> [ 1599.349518]  [<ffffffff813ec739>] copy_page_to_iter+0xf9/0x1e0
> [ 1599.356027]  [<ffffffff8120691f>] shmem_file_read_iter+0x9f/0x340
> [ 1599.362829]  [<ffffffff812bbeb9>] generic_file_splice_read+0xb9/0x1b0
> [ 1599.370015]  [<ffffffff812bc206>] do_splice_to+0x76/0x90
> [ 1599.375941]  [<ffffffff812bc2db>] splice_direct_to_actor+0xbb/0x220
> [ 1599.382935]  [<ffffffff812bba80>] ? generic_pipe_buf_nosteal+0x10/0x10
> [ 1599.390220]  [<ffffffff812bc4d8>] do_splice_direct+0x98/0xd0
> [ 1599.396537]  [<ffffffff81281dd1>] do_sendfile+0x1d1/0x3b0
> [ 1599.402563]  [<ffffffff81282973>] SyS_sendfile64+0x73/0xd0
> [ 1599.408685]  [<ffffffff81003f8c>] do_syscall_64+0x6c/0x1e0
> [ 1599.414820]  [<ffffffff817d927f>] entry_SYSCALL64_slow_path+0x25/0x25

IOW, sendfile from shmem...  How easily is that reproduced (IOW, did you
get any more of those)?
