Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:33606 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751574AbeA2Vut (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jan 2018 16:50:49 -0500
MIME-Version: 1.0
In-Reply-To: <1517228795.5965.24.camel@redhat.com>
References: <1517228795.5965.24.camel@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 29 Jan 2018 13:50:47 -0800
Message-ID: <CA+55aFxXg8JprOwfm0qCm4VkkM8cPM38YMvpkf3gBJq3bSJwPw@mail.gmail.com>
Subject: Re: [GIT PULL] inode->i_version rework for v4.16
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: open list <linux-kernel@vger.kernel.org>, "<linux-fsdevel@vger.kernel.org>" <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, xfs <linux-xfs@vger.kernel.org>, "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Mon, Jan 29, 2018 at 4:26 AM, Jeff Layton <jlayton@redhat.com> wrote:
>
> This pile of patches is a rework of the inode->i_version field. We have
> traditionally incremented that field on every inode data or metadata
> change. Typically this increment needs to be logged on disk even when
> nothing else has changed, which is rather expensive.

Hmm. I have pulled this, but it is really really broken in one place,
to the degree that I always went "no, I won't pull this garbage".

But the breakage is potential, not actual, and can be fixed trivially,
so I'll let it slide - but I do require it to be fixed. And I require
people to *think* about it.

So what's to horribly horribly wrong?

The inode_cmp_iversion{+raw}() functions are pure and utter crap.

Why?

You say that they return 0/negative/positive, but they do so in a
completely broken manner. They return that ternary value as the
sequence number difference in a 's64', which means that if you
actually care about that ternary value, and do the *sane* thing that
the kernel-doc of the function implies is the right thing, you would
do

    int cmp = inode_cmp_iversion(inode, old);

    if (cmp < 0 ...

and as a result you get code that looks sane, but that doesn't
actually *WORK* right.

To make it even worse, it will actually work in practice by accident
in 99.99999% of all cases, so now you have

 (a) subtly buggy code
 (b) that looks fine
 (c) and that works in testing

which is just about the worst possible case for any code. The
interface is simply garbage that encourages bugs.

And the bug wouldn't be in the user, the bug would be in this code you
just sent me. The interface is simply wrong.

So this absolutely needs to be fixed. I see two fixes:

 - just return a boolean. That's all that any current user actually
wants, so the ternary value seems pointless.

 - make it return an 'int', and not just any int, but -1/0/1. That way
there is no worry about uses, and if somebody *really* cares about the
ternary value, they can now use a "switch" statement to get it
(alternatively, make it return an enum, but whatever).

That "ternary" function that has 18446744069414584320 incorrect return
values really is unacceptable.

                Linus
