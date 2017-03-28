Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33173 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753242AbdC1SBJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Mar 2017 14:01:09 -0400
MIME-Version: 1.0
In-Reply-To: <28001.1490709846@warthog.procyon.org.uk>
References: <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
 <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net> <22058.1490696551@warthog.procyon.org.uk>
 <CAOQ4uxhipk2anBVUh9eKL1A1RqDUMRci5rpYbrjQPo9voab5ZA@mail.gmail.com>
 <23774.1490704285@warthog.procyon.org.uk> <CAOQ4uxgzV7BR5ZHmfWhu2vnGmO9uMqFuzMFrZnKfnH1fooob7w@mail.gmail.com>
 <28001.1490709846@warthog.procyon.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 28 Mar 2017 14:01:07 -0400
Message-ID: <CAOQ4uxjKg5JdUrT3WvfuAa=Qb+LUhBJU98W4U=LDEtgPFVO73Q@mail.gmail.com>
Subject: Re: [PATCH] xfs_io: changes to statx interface
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Mar 28, 2017 at 10:04 AM, David Howells <dhowells@redhat.com> wrote:
> Amir Goldstein <amir73il@gmail.com> wrote:
>
>> > Further, this should work:
>> >
>> >         warthog>xfs_io -c "statx -c" /dev/sda
>> >         /dev/sda: Permission denied
>> >
>>
>> This opens /dev/sda for read/write and feeds the fd to the commands
>> executed.
>> You may want to try
>> xfs_io -r -c "statx -c" /dev/sda
>
> I've added -P to open to supply O_PATH, but I'm having trouble testing the
> dirfd usage - I think probably because file->name is an absolute path:
>
>         xfs_io> open /dev
>         Opened 0
>         xfs_io> open sda
>         sda: No such file or directory
>         xfs_io> open /dev/sda
>         Opened 1
>
> Possibly open should be able to take a base dir and call openat().

Yeh, I told you statx -d does not make much sense for xfs_io.
I don't think you wanna go there...

>
> (I also made it print the file table index after a successful open, though I
> perhaps only want to do this in interactive mode).
>
>> By the time statx() gets to fs specific code it does not matter if you
>> called it with -d/-f or like stat() does it?
>
> No.  But all the calling options still have to be tested, as does stuffing bad
> values into the syscall args - something xfstests seems to be very poor at.
>
>> In my (hopefully unbiased) opinion, there is room for the syscall sanity
>> tests that you posted to LTP and there is room for file system
>> functional tests with xfstests, which xfs_io can be used for.
>
> Yes.  I agree.  Christoph may be of the opinion that LTP is a trainwreck, but
> it can do some things much more easily than can xfstests, primarily because
> its tests are written in C.
>

Adding C tests under src/ dir is a viable option.

> Any suggestions on how to do timestamp comparisons?  I really want to be able
> to do things like asking if mtime > btime or btime < wall clock time.  I guess
> I could add another command for that.

Not in xfs_io, don't go there.

You can look at tests/generic/003 (it hurts the eyes a bit)
Perhaps it would be better to write a small C helper (e.g.
t_compare_statx_times)
and then tests could be easily and flexibly extended.

Amir.
