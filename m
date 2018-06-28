Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:55403 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752529AbeF1ChN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jun 2018 22:37:13 -0400
MIME-Version: 1.0
References: <60052659-7b37-cb69-bf9f-1683caa46219@redhat.com>
 <CA+55aFzeA7N3evSF2jKHu8JoTQuKDLCMKx7RiPhmym97-8HY7A@mail.gmail.com> <1e2ad827-6ff4-4b1e-c4d9-79ca4e432a6c@sandeen.net>
In-Reply-To: <1e2ad827-6ff4-4b1e-c4d9-79ca4e432a6c@sandeen.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 Jun 2018 19:37:01 -0700
Message-ID: <CA+55aFxs7Cc30fCiENw0R+XDJhUJ-w=z=NLLzYfT5gF2Qh-60Q@mail.gmail.com>
Subject: Re: [PATCH] mm: reject MAP_SHARED_VALIDATE without new flags
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-ext4@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, zhibli@redhat.com

On Wed, Jun 27, 2018 at 7:17 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> What broke is that mmap(MAP_SHARED|MAP_PRIVATE) now succeeds without error,
> whereas before it rightly returned -EINVAL.

You're still confusing *behavior* with breakage.

Yes. New *behavior* is that MAP_SHARED|MAP_PRIVATE is now a valid
thing. It means "MAP_SHARED_VALIDATE".

Behavior changed.  That's normal. Every single time we add a system
call, behavior changes: a system call that used to return -ENOSYS now
returns something else.

That's not breakage, that's just intentional new behavior.

> What behavior should a user expect from a successful mmap(MAP_SHARED|MAP_PRIVATE)?

MAP_SHARED|MAP_PRIVATE makes no sense and nobody uses it (because it
has always returned an error and never done anything interesting).

Nobody uses it, and it used to return an error is *exactly* why it was
defined to be MAP_SHARED_VALIDATE.

So you should expect MAP_SHARED_VALIDATE behavior - which is
MAP_SHARED together with "validate that all the flags are things that
we support".

Actual BREAKAGE is if some application or user workflow no longer
works. Did LibreOffice stop working? That is breakage.

And by application, I mean exactly that: a real program.  Not some
manual-page, and not some test-program that people don't actually rely
on, and that just reports on some particular behavior.

Because I can write a test program that verifies that system call #335
doesn't exist:

    #define _GNU_SOURCE
    #include <unistd.h>
    #include <sys/syscall.h>
    #include <errno.h>
    #include <assert.h>

    int main(int argc, char **argv)
    {
        assert(syscall(335, 0) == -1 && errno == ENOSYS);
        return 0;
    }

and the next system call we add will break that test program on x86-64.

And that's still not a "regression" - it's just a change in behavior.

But if firefox no longer runs, because it depended on that system call
not existing (or it depended on that MAP_SHARED_VALIDATE returning
EINVAL) then it's a regression.

See the difference?

One case is "we added new behavior".

The other case is "we have a regression".

                Linus
