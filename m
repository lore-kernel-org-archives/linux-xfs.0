Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51035 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752226AbdC1OEx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Mar 2017 10:04:53 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOQ4uxgzV7BR5ZHmfWhu2vnGmO9uMqFuzMFrZnKfnH1fooob7w@mail.gmail.com>
References: <CAOQ4uxgzV7BR5ZHmfWhu2vnGmO9uMqFuzMFrZnKfnH1fooob7w@mail.gmail.com> <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net> <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net> <22058.1490696551@warthog.procyon.org.uk> <CAOQ4uxhipk2anBVUh9eKL1A1RqDUMRci5rpYbrjQPo9voab5ZA@mail.gmail.com> <23774.1490704285@warthog.procyon.org.uk>
Subject: Re: [PATCH] xfs_io: changes to statx interface
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28000.1490709846.1@warthog.procyon.org.uk>
Date: Tue, 28 Mar 2017 15:04:06 +0100
Message-ID: <28001.1490709846@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: dhowells@redhat.com, Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

Amir Goldstein <amir73il@gmail.com> wrote:

> > Further, this should work:
> >
> >         warthog>xfs_io -c "statx -c" /dev/sda
> >         /dev/sda: Permission denied
> >
> 
> This opens /dev/sda for read/write and feeds the fd to the commands
> executed.
> You may want to try
> xfs_io -r -c "statx -c" /dev/sda

I've added -P to open to supply O_PATH, but I'm having trouble testing the
dirfd usage - I think probably because file->name is an absolute path:

	xfs_io> open /dev
	Opened 0
	xfs_io> open sda
	sda: No such file or directory
	xfs_io> open /dev/sda
	Opened 1

Possibly open should be able to take a base dir and call openat().

(I also made it print the file table index after a successful open, though I
perhaps only want to do this in interactive mode).

> By the time statx() gets to fs specific code it does not matter if you
> called it with -d/-f or like stat() does it?

No.  But all the calling options still have to be tested, as does stuffing bad
values into the syscall args - something xfstests seems to be very poor at.

> In my (hopefully unbiased) opinion, there is room for the syscall sanity
> tests that you posted to LTP and there is room for file system
> functional tests with xfstests, which xfs_io can be used for.

Yes.  I agree.  Christoph may be of the opinion that LTP is a trainwreck, but
it can do some things much more easily than can xfstests, primarily because
its tests are written in C.

Any suggestions on how to do timestamp comparisons?  I really want to be able
to do things like asking if mtime > btime or btime < wall clock time.  I guess
I could add another command for that.
