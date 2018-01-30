Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:42397 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751434AbeA3MFv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jan 2018 07:05:51 -0500
Received: by mail-qk0-f175.google.com with SMTP id k201so9742748qke.9
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2018 04:05:51 -0800 (PST)
Message-ID: <1517313948.3658.8.camel@redhat.com>
Subject: Re: [GIT PULL] inode->i_version rework for v4.16
From: Jeff Layton <jlayton@redhat.com>
Date: Tue, 30 Jan 2018 07:05:48 -0500
In-Reply-To: <CA+55aFxXg8JprOwfm0qCm4VkkM8cPM38YMvpkf3gBJq3bSJwPw@mail.gmail.com>
References: <1517228795.5965.24.camel@redhat.com>
         <CA+55aFxXg8JprOwfm0qCm4VkkM8cPM38YMvpkf3gBJq3bSJwPw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: open list <linux-kernel@vger.kernel.org>, "<linux-fsdevel@vger.kernel.org>" <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, xfs <linux-xfs@vger.kernel.org>, "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Mon, 2018-01-29 at 13:50 -0800, Linus Torvalds wrote:
> On Mon, Jan 29, 2018 at 4:26 AM, Jeff Layton <jlayton@redhat.com> wrote:
> > 
> > This pile of patches is a rework of the inode->i_version field. We have
> > traditionally incremented that field on every inode data or metadata
> > change. Typically this increment needs to be logged on disk even when
> > nothing else has changed, which is rather expensive.
> 
> Hmm. I have pulled this, but it is really really broken in one place,
> to the degree that I always went "no, I won't pull this garbage".
> 
> But the breakage is potential, not actual, and can be fixed trivially,
> so I'll let it slide - but I do require it to be fixed. And I require
> people to *think* about it.
> 
> So what's to horribly horribly wrong?
> 
> The inode_cmp_iversion{+raw}() functions are pure and utter crap.
> 
> Why?
> 
> You say that they return 0/negative/positive, but they do so in a
> completely broken manner. They return that ternary value as the
> sequence number difference in a 's64', which means that if you
> actually care about that ternary value, and do the *sane* thing that
> the kernel-doc of the function implies is the right thing, you would
> do
> 
>     int cmp = inode_cmp_iversion(inode, old);
> 
>     if (cmp < 0 ...
> 
> and as a result you get code that looks sane, but that doesn't
> actually *WORK* right.
> 

My intent here was to have this handle wraparound using the same sort of
method that the time_before/time_after macros do. Obviously, I didn't
document that well.

I want to make sure I understand what's actually broken here thoug. Is
it only broken when the two values are more than 2**63 apart, or is
there something else more fundamentally wrong here?

> To make it even worse, it will actually work in practice by accident
> in 99.99999% of all cases, so now you have
> 
>  (a) subtly buggy code
>  (b) that looks fine
>  (c) and that works in testing
> 
> which is just about the worst possible case for any code. The
> interface is simply garbage that encourages bugs.
> 
> And the bug wouldn't be in the user, the bug would be in this code you
> just sent me. The interface is simply wrong.
> 
> So this absolutely needs to be fixed. I see two fixes:
> 
>  - just return a boolean. That's all that any current user actually
> wants, so the ternary value seems pointless.
> 
>  - make it return an 'int', and not just any int, but -1/0/1. That way
> there is no worry about uses, and if somebody *really* cares about the
> ternary value, they can now use a "switch" statement to get it
> (alternatively, make it return an enum, but whatever).
> 
> That "ternary" function that has 18446744069414584320 incorrect return
> values really is unacceptable.
> 

I think I'll just make it return a boolean value like you suggested
first. I'll send a patch to fix it once I've done some basic testing
with it.

Many thanks,
--
Jeff Layton <jlayton@redhat.com>
