Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:36915 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfFREWK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 00:22:10 -0400
MIME-Version: 1.0
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
 <20190611011737.GA28701@kmo-pixel> <20190611043336.GB14363@dread.disaster.area>
 <20190612162144.GA7619@kmo-pixel> <20190612230224.GJ14308@dread.disaster.area>
 <20190613183625.GA28171@kmo-pixel> <20190613235524.GK14363@dread.disaster.area>
 <CAHk-=whMHtg62J2KDKnyOTaoLs9GxcNz1hN9QKqpxoO=0bJqdQ@mail.gmail.com>
 <CAHk-=wgz+7O0pdn8Wfxc5EQKNy44FTtf4LAPO1WgCidNjxbWzg@mail.gmail.com>
 <20190617224714.GR14363@dread.disaster.area> <CAHk-=wiR3a7+b0cUN45hGp1dvFh=s1i1OkVhoP7CivJxKqsLFQ@mail.gmail.com>
In-Reply-To: <CAHk-=wiR3a7+b0cUN45hGp1dvFh=s1i1OkVhoP7CivJxKqsLFQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 18 Jun 2019 07:21:56 +0300
Message-ID: <CAOQ4uxjqQjrCCt=ixgdUYjBJvKLhw4R9NeMZOB_s2rrWvoDMBw@mail.gmail.com>
Subject: Re: pagecache locking (was: bcachefs status update) merged)
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Kent Overstreet <kent.overstreet@gmail.com>, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>

> > Right, but regardless of the spec we have to consider that the
> > behaviour of XFS comes from it's Irix heritage (actually from EFS,
> > the predecessor of XFS from the late 1980s)
>
> Sure. And as I mentioned, I think it's technically the nicer guarantee.
>
> That said, it's a pretty *expensive* guarantee. It's one that you
> yourself are not willing to give for O_DIRECT IO.
>
> And it's not a guarantee that Linux has ever had. In fact, it's not
> even something I've ever seen anybody ever depend on.
>
> I agree that it's possible that some app out there might depend on
> that kind of guarantee, but I also suspect it's much much more likely
> that it's the other way around: XFS is being unnecessarily strict,
> because everybody is testing against filesystems that don't actually
> give the total atomicity guarantees.
>
> Nobody develops for other unixes any more (and nobody really ever did
> it by reading standards papers - even if they had been very explicit).
>
> And honestly, the only people who really do threaded accesses to the same file
>
>  (a) don't want that guarantee in the first place
>
>  (b) are likely to use direct-io that apparently doesn't give that
> atomicity guarantee even on xfs
>
> so I do think it's moot.
>
> End result: if we had a really cheap range lock, I think it would be a
> good idea to use it (for the whole QoI implementation), but for
> practical reasons it's likely better to just stick to the current lack
> of serialization because it performs better and nobody really seems to
> want anything else anyway.
>

This is the point in the conversation where somebody usually steps in
and says "let the user/distro decide". Distro maintainers are in a much
better position to take the risk of breaking hypothetical applications.

I should point out that even if "strict atomic rw" behavior is desired, then
page cache warmup [1] significantly improves performance.
Having mentioned that, the discussion can now return to what is the
preferred way to solve the punch hole vs. page cache add race.

XFS may end up with special tailored range locks, which beings some
other benefits to XFS, but all filesystems need the solution for the punch
hole vs. page cache add race.
Jan recently took a stab at it for ext4 [2], but that didn't work out.
So I wonder what everyone thinks about Kent's page add lock as the
solution to the problem.
Allegedly, all filesystems (XFS included) are potentially exposed to
stale data exposure/data corruption.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/20190404165737.30889-1-amir73il@gmail.com/
[2] https://lore.kernel.org/linux-fsdevel/20190603132155.20600-3-jack@suse.cz/
