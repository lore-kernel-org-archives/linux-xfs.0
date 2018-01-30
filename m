Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:43670 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753379AbeA3Qg6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jan 2018 11:36:58 -0500
MIME-Version: 1.0
In-Reply-To: <1517313948.3658.8.camel@redhat.com>
References: <1517228795.5965.24.camel@redhat.com> <CA+55aFxXg8JprOwfm0qCm4VkkM8cPM38YMvpkf3gBJq3bSJwPw@mail.gmail.com>
 <1517313948.3658.8.camel@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 30 Jan 2018 08:36:56 -0800
Message-ID: <CA+55aFwD-=YNXQTOSNZE9SQwsin=ay56GOt4gekYe1U0qPeksQ@mail.gmail.com>
Subject: Re: [GIT PULL] inode->i_version rework for v4.16
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: open list <linux-kernel@vger.kernel.org>, "<linux-fsdevel@vger.kernel.org>" <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, xfs <linux-xfs@vger.kernel.org>, "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Tue, Jan 30, 2018 at 4:05 AM, Jeff Layton <jlayton@redhat.com> wrote:
>
> My intent here was to have this handle wraparound using the same sort of
> method that the time_before/time_after macros do. Obviously, I didn't
> document that well.

Oh, the intent was clear. The implementation was wrong.

Note that "time_before()" returns a _boolean_.

So yes, the time comparison functions do a 64-bit subtraction, exactly
like yours do. BUT THEY DO NOT RETURN THAT DIFFERENCE. They test the
sign in 64 bits and return that boolean single-bit value.

> I want to make sure I understand what's actually broken here thoug. Is
> it only broken when the two values are more than 2**63 apart, or is
> there something else more fundamentally wrong here?

There's something fundamentally wrong. The _intent_ is to allow
numbers up to 2**63 apart, but if somebody does that

     int cmp = inode_cmp_iversion(inode, old);

     if (cmp < 0 ...

then it actually only ever tests numbers 2**31 apart, because the high
32 bits will have been thrown away when the 64-bit difference is cast
to "int".

And what used to be a sign bit (in 64 bits) no longer exists, and the
above tests the *new* sign bit that is bit #31, not #63.

So you are a factor of four billion off.

And while 2**63 is a big number and perfectly ok for a filesystem
event difference, a difference of 2**31 is a "this can actually
happen".

Yes, even 2**31 is still a big difference, and it will take a very
unusual situation, and quite a long time to trigger: something that
does a thousand filesystem ops per second will not see the problem for
24 days. So you'll never see it in a test. But 24 days happens in real
life..

That's why you need to do the comparison against zero inside the
actual helper functions like the time comparisons do. Because if you
return the 64-bit difference, it will be trivially lost, and the code
will _look_ right, but not work right.

The fact that you didn't even seem to see the problem in my example
calling sequence just proves that point.

                   Linus
