Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC07C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 05:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbiEXFhI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 01:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234538AbiEXFhH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 01:37:07 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C7265D28
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 22:37:03 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id dm17so13603811qvb.2
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 22:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x6ggWEf0rlFyHgVKU4jkWfukCMcLtw8G7VkoNnmun0g=;
        b=iDDeKyEWb7DoIZjbR7gbKTGpX3Z+uBtrzuGJpxv0OuaoyB9/HSEM5CwQHygM6wNJb4
         1x+P2HNPwa8/ebp+JYAtD1uiMl6srYWC5TfOV7K44KTK35Pzu3DA12RYUd6/OprUDjb4
         NGdXWw/brXbVIH4hvo8UMaArAF9pNjbF2y1Ne/itfuIu/+94o1eXizFNeO3CWAysYfHo
         Pfvh5ajdWHYwQxdjMGVEoaW0LUOPiYGjoxgMuUTkIC2Ie347/ojdAAKpJcTyYVXXgEon
         5mjDa5BTs29oMhdi5Dxs9QdjqRtqIvzGE9i9VxSXluaoO+/jF3ypXLiM+68f3aooPBIt
         Sa+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x6ggWEf0rlFyHgVKU4jkWfukCMcLtw8G7VkoNnmun0g=;
        b=QZ79CTa9ze7jcNB4wUvu79P4vUp6PugJCGg3f200edchXkUr24qspxXyGBCG69IEny
         kzVNUJtx9VBxDmtqrqWnbLWmHNEVU5CMb6ETBaqHjeUxNlO+58BIk7J2Sp1Rx+yLoZft
         vGs+Ft2lDFTzg0whl0R8Nntibk7besWfSRe3Dlq197l7YLYHH8sPBMaO3wZ5mVyE7Q85
         Ko+2F7tdTkzAxYDUhXtefFEs0tCxGHGudNtRH7uwG4rVV1LsXzs754IB57zALq18WTwH
         zrSJ2mUsgfkKUX3Qhx0V9CguzQ9aLnikpHvZxpA0bA9MBEM4/0nIT1PLC/YsVp6Xw9Cg
         KFFw==
X-Gm-Message-State: AOAM532IquQXCnzuqDbxmopA8OZ8dV4muetLwBtHCUXzWpPAtrmbeLES
        0OhruhAQCsyR7LqEKQ0EH6srzwba33GkkFQsYHw=
X-Google-Smtp-Source: ABdhPJyq+rii0W3UHSvvCasLdPJvM9weJoMHgSy0krgsrlIWSeiqqut1cd4BwJiHvv5aI6ck8vLAJ8zKtp/JhbGVbx4=
X-Received: by 2002:a05:6214:1cc4:b0:435:35c3:f0f1 with SMTP id
 g4-20020a0562141cc400b0043535c3f0f1mr19969942qvd.0.1653370622610; Mon, 23 May
 2022 22:37:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
 <CAOQ4uxi8eNVCjqeSeVFRgrYC00gjdbuPyV4B2WPN0DmqjrfyFg@mail.gmail.com> <20220523224352.GT1098723@dread.disaster.area>
In-Reply-To: <20220523224352.GT1098723@dread.disaster.area>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 24 May 2022 08:36:50 +0300
Message-ID: <CAOQ4uxgJFVOs-p8kX+4n=TSCK-KbwjgDPaM4t81-x8gHO77FnQ@mail.gmail.com>
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

On Tue, May 24, 2022 at 1:43 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, May 23, 2022 at 02:15:44PM +0300, Amir Goldstein wrote:
> > On Sun, Jan 10, 2021 at 6:10 PM Chandan Babu R <chandanrlinux@gmail.com> wrote:
> > >
> > > XFS does not check for possible overflow of per-inode extent counter
> > > fields when adding extents to either data or attr fork.
> > >
> > > For e.g.
> > > 1. Insert 5 million xattrs (each having a value size of 255 bytes) and
> > >    then delete 50% of them in an alternating manner.
> > >
> > > 2. On a 4k block sized XFS filesystem instance, the above causes 98511
> > >    extents to be created in the attr fork of the inode.
> > >
> > >    xfsaild/loop0  2008 [003]  1475.127209: probe:xfs_inode_to_disk: (ffffffffa43fb6b0) if_nextents=98511 i_ino=131
> > >
> > > 3. The incore inode fork extent counter is a signed 32-bit
> > >    quantity. However, the on-disk extent counter is an unsigned 16-bit
> > >    quantity and hence cannot hold 98511 extents.
> > >
> > > 4. The following incorrect value is stored in the xattr extent counter,
> > >    # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
> > >    core.naextents = -32561
> > >
> > > This patchset adds a new helper function
> > > (i.e. xfs_iext_count_may_overflow()) to check for overflow of the
> > > per-inode data and xattr extent counters and invokes it before
> > > starting an fs operation (e.g. creating a new directory entry). With
> > > this patchset applied, XFS detects counter overflows and returns with
> > > an error rather than causing a silent corruption.
> > >
> > > The patchset has been tested by executing xfstests with the following
> > > mkfs.xfs options,
> > > 1. -m crc=0 -b size=1k
> > > 2. -m crc=0 -b size=4k
> > > 3. -m crc=0 -b size=512
> > > 4. -m rmapbt=1,reflink=1 -b size=1k
> > > 5. -m rmapbt=1,reflink=1 -b size=4k
> > >
> > > The patches can also be obtained from
> > > https://github.com/chandanr/linux.git at branch xfs-reserve-extent-count-v14.
> > >
> > > I have two patches that define the newly introduced error injection
> > > tags in xfsprogs
> > > (https://lore.kernel.org/linux-xfs/20201104114900.172147-1-chandanrlinux@gmail.com/).
> > >
> > > I have also written tests
> > > (https://github.com/chandanr/xfstests/commits/extent-overflow-tests)
> > > for verifying the checks introduced in the kernel.
> > >
> >
> > Hi Chandan and XFS folks,
> >
> > As you may have heard, I am working on producing a series of
> > xfs patches for stable v5.10.y.
> >
> > My patch selection is documented at [1].
> > I am in the process of testing the backport patches against the 5.10.y
> > baseline using Luis' kdevops [2] fstests runner.
> >
> > The configurations that we are testing are:
> > 1. -m rmbat=0,reflink=1 -b size=4k (default)
> > 2. -m crc=0 -b size=4k
> > 3. -m crc=0 -b size=512
> > 4. -m rmapbt=1,reflink=1 -b size=1k
> > 5. -m rmapbt=1,reflink=1 -b size=4k
> >
> > This patch set is the only largish series that I selected, because:
> > - It applies cleanly to 5.10.y
> > - I evaluated it as low risk and high value
>
> What value does it provide LTS users?
>

Cloud providers deploy a large number of VMs/containers
and they may use reflink. So I think this could be an issue.

> This series adds almost no value to normal users - extent count
> overflows are just something that doesn't happen in production
> systems at this point in time. The largest data extent count I've
> ever seen is still an order of magnitude of extents away from
> overflowing (i.e. 400 million extents seen, 4 billion to overflow),
> and nobody is using the attribute fork sufficiently hard to overflow
> 65536 extents (typically a couple of million xattrs per inode).
>
> i.e. this series is ground work for upcoming internal filesystem
> functionality that require much larger attribute forks (parent
> pointers and fsverity merkle tree storage) to be supported, and
> allow scope for much larger, massively fragmented VM image files
> (beyond 16TB on 4kB block size fs for worst case
> fragmentation/reflink).

I am not sure I follow this argument.
Users can create large attributes, can they not?
And users can create massive fragmented/reflinked images, can they not?
If we have learned anything, is that if users can do something (i.e. on stable),
users will do that, so it may still be worth protecting this workflow?

I argue that the reason that you did not see those constructs in the wild yet,
is the time it takes until users format new xfs filesystems with mkfs
that defaults
to reflink enabled and then use latest userspace tools that started to do
copy_file_range() or clone on their filesystem, perhaps even without the
user's knowledge, such as samba [1].

[1] https://gitlab.com/samba-team/samba/-/merge_requests/2044

>
> As a standalone patchset, this provides almost no real benefit to
> users but adds a whole new set of "hard stop" error paths across
> every operation that does inode data/attr extent allocation. i.e.
> the scope of affected functionality is very wide, the benefit
> to users is pretty much zero.
>
> Hence I'm left wondering what criteria ranks this as a high value
> change...
>

Given your inputs, I am not sure that the fix has high value, but I must
say I didn't fully understand your argument.
It sounded like
"We don't need the fix because we did not see the problem yet",
but I may have misunderstood you.

I am sure that you are aware of the fact that even though 5.10 is
almost 2 y/o, it has only been deployed recently by some distros.

For example, Amazon AMI [2] and Google Cloud COS [3] images based
on the "new" 5.10 kernel were only released about half a year ago.

[2] https://aws.amazon.com/about-aws/whats-new/2021/11/amazon-linux-2-ami-kernel-5-10/
[3] https://cloud.google.com/container-optimized-os/docs/release-notes/m93#cos-93-16623-39-6

I have not analysed the distro situation w.r.t xfsprogs, but here the
important factor is which version of xfsprogs was used to format the
user's filesystem, not which xfsprogs is installed on their system now.

> > - Chandan has written good regression tests
> >
> > I intend to post the rest of the individual selected patches
> > for review in small batches after they pass the tests, but w.r.t this
> > patch set -
> >
> > Does anyone object to including it in the stable kernel
> > after it passes the tests?
>
> I prefer that the process doesn't result in taking random unnecesary
> functionality into stable kernels. The part of the LTS process that
> I've most disagreed with is the "backport random unnecessary
> changes" part of the stable selection criteria. It doesn't matter if
> it's selected by a bot or a human, the problems that causes are the
> same.

I am in agreement with you.

If you actually look at my selections [4]
I think that you will find that they are very far from "random".
I have tried to make it VERY easy to review my selections, by
listing the links to lore instead of the commit ids and my selection
process is also documented in the git log.

TBH, *this* series was the one that I was mostly in doubt about,
which is one of the reasons I posted it first to the list.
I was pretty confident about my risk estimation, but not so much
about the value.

Also, I am considering my post in this mailing list (without CC stable)
part of the process, and the inputs I got from you and from Chandan
is exactly what is missing in the regular stable tree process IMO, so
I appreciate your inputs very much.

>
> Hence on those grounds, I'd say this isn't a stable backport
> candidate at all...
>

If my arguments did not convince you, out goes this series!

I shall be posting more patches for consideration in the coming
weeks. I would appreciate your inputs on those as well.

You guys are welcome to review my selection [4] already.

Thanks!
Amir.

[4] https://github.com/amir73il/b4/blob/xfs-5.10.y/xfs-5.10..5.17-fixes.rst
