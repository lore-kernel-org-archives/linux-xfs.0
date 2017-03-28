Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:35911 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753112AbdC1SLi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Mar 2017 14:11:38 -0400
MIME-Version: 1.0
In-Reply-To: <7095.1490723812@warthog.procyon.org.uk>
References: <29458.1490711932@warthog.procyon.org.uk> <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net>
 <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net> <29491.1490712064@warthog.procyon.org.uk>
 <4DB15765-D097-43B5-9F1B-43DE76D3BC90@sandeen.net> <CAOQ4uxj_S2UtW0A5vSsmD_1vjgPsdopckj4Jtc5w5KuM2aTppA@mail.gmail.com>
 <7095.1490723812@warthog.procyon.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 28 Mar 2017 14:11:22 -0400
Message-ID: <CAOQ4uxg2Y7V_GhqEbTvnOfVn0ihzs=gWGJ-fBMvjA5ezwx2cYg@mail.gmail.com>
Subject: Re: [PATCH] xfs_io: changes to statx interface [ver #2]
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

On Tue, Mar 28, 2017 at 1:56 PM, David Howells <dhowells@redhat.com> wrote:
> Amir Goldstein <amir73il@gmail.com> wrote:
>
>> That's actually the shortest path for you and there are quite a few
>> tests in xfstests that took
>> this path. It should be easy for you to copy & paste one of them.
>
> Don't forget that syscall testing for this has to be added to LTP anyway...
>

Sure, LTP is good for that and many testers run LTP, but I have no idea how
wide is the file system diversity of their setups.
statx may have bugs in syscall/vfs and it may have bugs in specific
fs, so having
some C tests in LTP and some C tests in xfstest can't hurt.

It's not difficult to harness a C test to xfstest.
See recent example of C only (mostly) test in
 2161614 generic: concurrent non-overlapping direct I/O on the same extents
