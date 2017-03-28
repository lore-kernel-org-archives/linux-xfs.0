Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36464 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754271AbdC1Jkf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Mar 2017 05:40:35 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOQ4uxgBkNRzJkE7qVjv_Ej0LBRHzG_7=1qd4uW62SH1kO1DMQ@mail.gmail.com>
References: <CAOQ4uxgBkNRzJkE7qVjv_Ej0LBRHzG_7=1qd4uW62SH1kO1DMQ@mail.gmail.com> <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net> <5245.1490608817@warthog.procyon.org.uk>
Subject: Re: [PATCH 0/2 V2] xfs_io: hook up statx
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7546.1490693979.1@warthog.procyon.org.uk>
Date: Tue, 28 Mar 2017 10:39:39 +0100
Message-ID: <7547.1490693979@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: dhowells@redhat.com, Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

Amir Goldstein <amir73il@gmail.com> wrote:

> xfstests is all 99% bash scripts and most of the uses of stat(2) are
> by executing
> stat(1), so all you have to do in order to exercise a statx() with existing
> tests is install a stat executable in your path that uses statx()
> instead of stat().

Actually, it would be easier to write the test in C as:

 (1) How do you feed statx bad arguments from shell scripts (e.g. a kernel
     address for the buffer pointer or the name pointer) to make sure it gives
     appropriate errors?

 (2) I want to do a comparison of the struct statx to a struct stat almost
     every time statx is called.

 (3) There's going to be a bunch of timestamp comparisons.

I grant that (2) and (3) can be done in shell scripts - I've not tried bash's
associative arrays, but they ought to make it easier.  (1), however, is
something that requires C support and is something that I have in the LTP
tests as I copied that stuff from the stat/fstat/lstat tests there.

> It sounds like you are new to xfstests?

I've not tried to modify it before.

> xfstests is not extensively documented, but it quite simple, so it
> usually "just works".

I noticed the paucity of documentation.  doc/ contains nothing more than an
old CHANGES file.  "Quite simple" does not translate to "easy to use",
especially when you have to make changes outside the package to get it to work
- and nowhere in the docs that there are is this mentioned.

David
