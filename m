Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:35090 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932176AbdC1NeP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Mar 2017 09:34:15 -0400
MIME-Version: 1.0
In-Reply-To: <23774.1490704285@warthog.procyon.org.uk>
References: <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
 <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net> <22058.1490696551@warthog.procyon.org.uk>
 <CAOQ4uxhipk2anBVUh9eKL1A1RqDUMRci5rpYbrjQPo9voab5ZA@mail.gmail.com> <23774.1490704285@warthog.procyon.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 28 Mar 2017 09:34:08 -0400
Message-ID: <CAOQ4uxgzV7BR5ZHmfWhu2vnGmO9uMqFuzMFrZnKfnH1fooob7w@mail.gmail.com>
Subject: Re: [PATCH] xfs_io: changes to statx interface
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Mar 28, 2017 at 8:31 AM, David Howells <dhowells@redhat.com> wrote:
> Amir Goldstein <amir73il@gmail.com> wrote:
>
>> xfs_io -c "statx -c /dev/null"
>>
>> is what you want
>
> That doesn't produce any output.  Did you mean:
>
>         xfs_io -c "statx -c" /dev/null

Yes.

>
> Further, this should work:
>
>         warthog>xfs_io -c "statx -c" /dev/sda
>         /dev/sda: Permission denied
>

This opens /dev/sda for read/write and feeds the fd to the commands
executed.
You may want to try
xfs_io -r -c "statx -c" /dev/sda

> but doesn't.
>
>> See the output of 'file' command or the global var filetable.
>
> So I would have to make "-d dirfd" take an entry in the global var filetable
> rather than an actual fd number?
>

I guess if you want to test statx without -f/-d then you'd
need to provide filename as one of the args to the statx command
(and not as args to xfs_io command line).

-f is the natural operation you can get from xfs_io
and you can use -d on current fd as well.

The only command I see that uses the non current fd is
sendfile -f N
Mostly commands operate on the "current" fd and current fd
is iterated from filetable.
if you use -d N from command line, you must use -C instead of
-c so statx is not performed on all fds in filetable, e.g:

xfs_io -r -C "statx -c -d 0" /a/ /a/foo

But you see that this makes little sense if "foo" is not an argument
of statx.

In my (hopefully unbiased) opinion, there is room for the syscall sanity
tests that you posted to LTP and there is room for file system
functional tests with xfstests, which xfs_io can be used for.

The main advantage you get from writing xfstests is that many of us run
them on a diversity of file systems, so it is good for catching wrong
implementation of statx by specific file systems.

By the time statx() gets to fs specific code it does not matter if you called it
with -d/-f or like stat() does it?

Amir.
