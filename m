Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D97C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 07:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiEYHsZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 03:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiEYHsY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 03:48:24 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8D377F13
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 00:48:21 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id y15so12130438qtx.4
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 00:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CykcZknmRdWBqOHZQwVhQSsfj/9vYecFACUhRxpqtfk=;
        b=mhEK7FvVTr9ha1N4Zlu+t826CcLctFFDxfEfXwc8sbkiHUdoHh4dsXTpZmSAlQ8OfP
         GnYfYaOLQFtr3reLmk2DPvmQFbnbCeh8hcsGqHbp2b4PzIvBwDYZgtLGfO+pDmFEaUoi
         kmP+tVJ4RzfBBcH1Cwgh3UiDmYBe6Ys7vXsdvP1i4HAH30Br8zVF8DjdBoiaD7g0dDU7
         31Blxz0xXU6UsIBeWPUcydpSmH1CnojpAh11uWi6R9GMmW9QYqRE0WsRHzwvL0tfExdr
         I5rQbob+JbsQ5IsGZfNS2NNJIV8aSSBGsod1o9wBZoKu3JrVdsi19nz9zmmSNcU2VM6u
         PzBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CykcZknmRdWBqOHZQwVhQSsfj/9vYecFACUhRxpqtfk=;
        b=U1CUhyWcUqtEdFPLkNN4aYDu2UhKBhuotxE2RByqKCjlgpScyJd6luP/pRiv6NLMxf
         FJM/2k3G3cgJr76zBcpnvjCAt74dHMK8RDkwoMK7tyRa2y0UVj0veWiJ+sUPBbE0SYZ2
         8zyRUPbT95CSgwkFvprPdrU1D2GjCik7z8aCTuAfLmH1c3PE8GkQFeTaMeKxm5rAGCGg
         9etK31jameHULsqIuWUB1HlKtrT2+EuQmVFzuLGYsR3uQEE2xK7VFS4gQ1SgQ01SRa5z
         r8S/m8aDa/Y7U+xaV9OfhFJ/K2DKOxtcsAzYmB5KdmyCGSXZwL/86TRCnjhwn+7cctaJ
         0xAA==
X-Gm-Message-State: AOAM532NZe1sH66YvBWrRwqCvuRxQeTSu7pgs1RPH5PzIeu3qhQeihV/
        ZMYl9f0V/ZiZxZ2PmKRD2hxgb3+qSmzptj0M6Ps=
X-Google-Smtp-Source: ABdhPJzlBP0FnO83wu6zSmwoXK2UAPtx3AQdv6Jvo9FsE1EU5CJph415h4t1P1OB4u7EZUWHeoazE0eK6YXZDi3gULU=
X-Received: by 2002:a05:622a:1a9c:b0:2f3:d873:4acc with SMTP id
 s28-20020a05622a1a9c00b002f3d8734accmr23599803qtc.424.1653464900850; Wed, 25
 May 2022 00:48:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
 <CAOQ4uxi8eNVCjqeSeVFRgrYC00gjdbuPyV4B2WPN0DmqjrfyFg@mail.gmail.com>
 <20220523224352.GT1098723@dread.disaster.area> <CAOQ4uxgJFVOs-p8kX+4n=TSCK-KbwjgDPaM4t81-x8gHO77FnQ@mail.gmail.com>
 <20220525073339.GF1098723@dread.disaster.area>
In-Reply-To: <20220525073339.GF1098723@dread.disaster.area>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 25 May 2022 10:48:09 +0300
Message-ID: <CAOQ4uxi=jZt_FnNktw8u5L90WUcEAtX4jymM126hLTVbw74f=g@mail.gmail.com>
Subject: Re: [PATCH V14 00/16] Bail out if transaction can cause extent count
 to overflow
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Allison Henderson <allison.henderson@oracle.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 25, 2022 at 10:33 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, May 24, 2022 at 08:36:50AM +0300, Amir Goldstein wrote:
> > On Tue, May 24, 2022 at 1:43 AM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Mon, May 23, 2022 at 02:15:44PM +0300, Amir Goldstein wrote:
> > > > On Sun, Jan 10, 2021 at 6:10 PM Chandan Babu R <chandanrlinux@gmail.com> wrote:
> > > > >
> > > > > XFS does not check for possible overflow of per-inode extent counter
> > > > > fields when adding extents to either data or attr fork.
> > > > >
> > > > > For e.g.
> > > > > 1. Insert 5 million xattrs (each having a value size of 255 bytes) and
> > > > >    then delete 50% of them in an alternating manner.
> > > > >
> > > > > 2. On a 4k block sized XFS filesystem instance, the above causes 98511
> > > > >    extents to be created in the attr fork of the inode.
> > > > >
> > > > >    xfsaild/loop0  2008 [003]  1475.127209: probe:xfs_inode_to_disk: (ffffffffa43fb6b0) if_nextents=98511 i_ino=131
> > > > >
> > > > > 3. The incore inode fork extent counter is a signed 32-bit
> > > > >    quantity. However, the on-disk extent counter is an unsigned 16-bit
> > > > >    quantity and hence cannot hold 98511 extents.
> > > > >
> > > > > 4. The following incorrect value is stored in the xattr extent counter,
> > > > >    # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
> > > > >    core.naextents = -32561
> > > > >
> > > > > This patchset adds a new helper function
> > > > > (i.e. xfs_iext_count_may_overflow()) to check for overflow of the
> > > > > per-inode data and xattr extent counters and invokes it before
> > > > > starting an fs operation (e.g. creating a new directory entry). With
> > > > > this patchset applied, XFS detects counter overflows and returns with
> > > > > an error rather than causing a silent corruption.
> > > > >
> > > > > The patchset has been tested by executing xfstests with the following
> > > > > mkfs.xfs options,
> > > > > 1. -m crc=0 -b size=1k
> > > > > 2. -m crc=0 -b size=4k
> > > > > 3. -m crc=0 -b size=512
> > > > > 4. -m rmapbt=1,reflink=1 -b size=1k
> > > > > 5. -m rmapbt=1,reflink=1 -b size=4k
> > > > >
> > > > > The patches can also be obtained from
> > > > > https://github.com/chandanr/linux.git at branch xfs-reserve-extent-count-v14.
> > > > >
> > > > > I have two patches that define the newly introduced error injection
> > > > > tags in xfsprogs
> > > > > (https://lore.kernel.org/linux-xfs/20201104114900.172147-1-chandanrlinux@gmail.com/).
> > > > >
> > > > > I have also written tests
> > > > > (https://github.com/chandanr/xfstests/commits/extent-overflow-tests)
> > > > > for verifying the checks introduced in the kernel.
> > > > >
> > > >
> > > > Hi Chandan and XFS folks,
> > > >
> > > > As you may have heard, I am working on producing a series of
> > > > xfs patches for stable v5.10.y.
> > > >
> > > > My patch selection is documented at [1].
> > > > I am in the process of testing the backport patches against the 5.10.y
> > > > baseline using Luis' kdevops [2] fstests runner.
> > > >
> > > > The configurations that we are testing are:
> > > > 1. -m rmbat=0,reflink=1 -b size=4k (default)
> > > > 2. -m crc=0 -b size=4k
> > > > 3. -m crc=0 -b size=512
> > > > 4. -m rmapbt=1,reflink=1 -b size=1k
> > > > 5. -m rmapbt=1,reflink=1 -b size=4k
> > > >
> > > > This patch set is the only largish series that I selected, because:
> > > > - It applies cleanly to 5.10.y
> > > > - I evaluated it as low risk and high value
> > >
> > > What value does it provide LTS users?
> > >
> >
> > Cloud providers deploy a large number of VMs/containers
> > and they may use reflink. So I think this could be an issue.
>
> Cloud providers are not deploying multi-TB VM images on XFS without
> also using some mechanism for avoiding worst-case fragmentation.
> They know all about the problems that manifest when extent
> counts get into the tens of millions, let alone billions....
>
> e.g. first access to a file pulls the entire extent list into
> memory, so for a file with 4 billion extents this will take hours to
> pull into memory (single threaded, synchronous read IO of millions
> of filesystem blocks) and consume and consume >100GB of RAM for the
> in-memory extent list. Having VM startup get delayed by hours and
> put a massive load on the cloud storage infrastructure for that
> entire length of time isn't desirable behaviour...
>
> For multi-TB VM image deployment - especially with reflink on the
> image file - extent size hints are needed to mitigate worst case
> fragmentation.  Reflink copies can run at up to about 100,000
> extents/s, so if you reflink a file with 4 billion extents in it,
> not only do you need another 100GB RAM, you also need to wait
> several hours for the reflink to run. And while that reflink is
> running, nothing else has access the data in that VM image: your VM
> is *down* for *hours* while you snapshot it.
>
> Typical mitigation is extent size hints in the MB ranges to reduce
> worst case fragmentation by two orders of magnitude (i.e. limit to
> tens of millions of extents, not billions) which brings snapshot
> times down to a minute or two.
>
> IOWs, it's obviously not practical to scale VM images out to
> billions of extents, even though we support extent counts in the
> billions.
>
> > > This series adds almost no value to normal users - extent count
> > > overflows are just something that doesn't happen in production
> > > systems at this point in time. The largest data extent count I've
> > > ever seen is still an order of magnitude of extents away from
> > > overflowing (i.e. 400 million extents seen, 4 billion to overflow),
> > > and nobody is using the attribute fork sufficiently hard to overflow
> > > 65536 extents (typically a couple of million xattrs per inode).
> > >
> > > i.e. this series is ground work for upcoming internal filesystem
> > > functionality that require much larger attribute forks (parent
> > > pointers and fsverity merkle tree storage) to be supported, and
> > > allow scope for much larger, massively fragmented VM image files
> > > (beyond 16TB on 4kB block size fs for worst case
> > > fragmentation/reflink).
> >
> > I am not sure I follow this argument.
> > Users can create large attributes, can they not?
>
> Sure. But *nobody does*, and there are good reasons we don't see
> people doing this.
>
> The reality is that apps don't use xattrs heavily because
> filesystems are traditionally very bad at storing even moderate
> numbers of xattrs. XFS is the exception to the rule. Hence nobody is
> trying to use a few million xattrs per inode right now, and it's
> unlikely anyone will unless they specifically target XFS.  In which
> case, they are going to want the large extent count stuff that just
> got merged into the for-next tree, and this whole discussion is
> moot....

With all the barriers to large extents count that you mentioned
I wonder how large extent counters feature mitigates those,
but that is irrelevant to the question at hand.

>
> > And users can create massive fragmented/reflinked images, can they not?
>
> Yes, and they will hit scalability problems long before they get
> anywhere near 4 billion extents.
>
> > If we have learned anything, is that if users can do something (i.e. on stable),
> > users will do that, so it may still be worth protecting this workflow?
>
> If I have learned anything, it's that huge extent counts are highly
> impractical for most workloads for one reason or another. We are a
> long way for enabling practical use of extent counts in the
> billions. Demand paging the extent list is the bare minimum we need,
> but then there's sheer scale of modifications reflink and unlink
> need to make (billions of transactions to share/free billions of
> individual extents) and there's no magic solution to that.
>
> > I argue that the reason that you did not see those constructs in the wild yet,
> > is the time it takes until users format new xfs filesystems with mkfs
>
> It really has nothing to do with filesystem formats and everything
> to do with the *cost* of creating, accessing, indexing and managing
> billions of extents.
>
> Have you ever tried to create a file with 4 billion extents in it?
> Even using fallocate to do it as fast as possible (no data IO!), I
> ran out of RAM on my 128GB test machine after 6 days of doing
> nothing but running fallocate() on a single inode. The kernel died a
> horrible OOM killer death at around 2.5 billion extents because the
> extent list cannot be reclaimed from memory while the inode is in
> use and the kernel ran out of all other memory it could reclaim as
> the extent list grew.
>
> The only way to fix that is to make the extent lists reclaimable
> (i.e. demand paging of the in-memory extent list) and that's a big
> chunk of work that isn't on anyone's radar right now.
>
> > Given your inputs, I am not sure that the fix has high value, but I must
> > say I didn't fully understand your argument.
> > It sounded like
> > "We don't need the fix because we did not see the problem yet",
> > but I may have misunderstood you.
>
> I hope you now realise that there are much bigger practical
> scalability limitations with extent lists and reflink that will
> manifest in production systems long before we get anywhere near
> billions of extents per inode.
>

I do!
And I *really* appreciate the time that you took to explain it to me
(and to everyone).

I'm dropping this series from my xfs-5.10.y queue.

Thanks,
Amir.
