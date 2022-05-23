Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B65C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 23 May 2022 22:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiEWWn6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 18:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiEWWn5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 18:43:57 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B3286ABF48
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 15:43:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id AA191536817;
        Tue, 24 May 2022 08:43:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ntGmG-00FbKf-Dv; Tue, 24 May 2022 08:43:52 +1000
Date:   Tue, 24 May 2022 08:43:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Allison Henderson <allison.henderson@oracle.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH V14 00/16] Bail out if transaction can cause extent count
 to overflow
Message-ID: <20220523224352.GT1098723@dread.disaster.area>
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
 <CAOQ4uxi8eNVCjqeSeVFRgrYC00gjdbuPyV4B2WPN0DmqjrfyFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi8eNVCjqeSeVFRgrYC00gjdbuPyV4B2WPN0DmqjrfyFg@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=628c0e2c
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=pGLkceISAAAA:8 a=NEAV23lmAAAA:8
        a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8 a=7EEJWBEWIgfxi64L_SkA:9
        a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 23, 2022 at 02:15:44PM +0300, Amir Goldstein wrote:
> On Sun, Jan 10, 2021 at 6:10 PM Chandan Babu R <chandanrlinux@gmail.com> wrote:
> >
> > XFS does not check for possible overflow of per-inode extent counter
> > fields when adding extents to either data or attr fork.
> >
> > For e.g.
> > 1. Insert 5 million xattrs (each having a value size of 255 bytes) and
> >    then delete 50% of them in an alternating manner.
> >
> > 2. On a 4k block sized XFS filesystem instance, the above causes 98511
> >    extents to be created in the attr fork of the inode.
> >
> >    xfsaild/loop0  2008 [003]  1475.127209: probe:xfs_inode_to_disk: (ffffffffa43fb6b0) if_nextents=98511 i_ino=131
> >
> > 3. The incore inode fork extent counter is a signed 32-bit
> >    quantity. However, the on-disk extent counter is an unsigned 16-bit
> >    quantity and hence cannot hold 98511 extents.
> >
> > 4. The following incorrect value is stored in the xattr extent counter,
> >    # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
> >    core.naextents = -32561
> >
> > This patchset adds a new helper function
> > (i.e. xfs_iext_count_may_overflow()) to check for overflow of the
> > per-inode data and xattr extent counters and invokes it before
> > starting an fs operation (e.g. creating a new directory entry). With
> > this patchset applied, XFS detects counter overflows and returns with
> > an error rather than causing a silent corruption.
> >
> > The patchset has been tested by executing xfstests with the following
> > mkfs.xfs options,
> > 1. -m crc=0 -b size=1k
> > 2. -m crc=0 -b size=4k
> > 3. -m crc=0 -b size=512
> > 4. -m rmapbt=1,reflink=1 -b size=1k
> > 5. -m rmapbt=1,reflink=1 -b size=4k
> >
> > The patches can also be obtained from
> > https://github.com/chandanr/linux.git at branch xfs-reserve-extent-count-v14.
> >
> > I have two patches that define the newly introduced error injection
> > tags in xfsprogs
> > (https://lore.kernel.org/linux-xfs/20201104114900.172147-1-chandanrlinux@gmail.com/).
> >
> > I have also written tests
> > (https://github.com/chandanr/xfstests/commits/extent-overflow-tests)
> > for verifying the checks introduced in the kernel.
> >
> 
> Hi Chandan and XFS folks,
> 
> As you may have heard, I am working on producing a series of
> xfs patches for stable v5.10.y.
> 
> My patch selection is documented at [1].
> I am in the process of testing the backport patches against the 5.10.y
> baseline using Luis' kdevops [2] fstests runner.
> 
> The configurations that we are testing are:
> 1. -m rmbat=0,reflink=1 -b size=4k (default)
> 2. -m crc=0 -b size=4k
> 3. -m crc=0 -b size=512
> 4. -m rmapbt=1,reflink=1 -b size=1k
> 5. -m rmapbt=1,reflink=1 -b size=4k
> 
> This patch set is the only largish series that I selected, because:
> - It applies cleanly to 5.10.y
> - I evaluated it as low risk and high value

What value does it provide LTS users?

This series adds almost no value to normal users - extent count
overflows are just something that doesn't happen in production
systems at this point in time. The largest data extent count I've
ever seen is still an order of magnitude of extents away from
overflowing (i.e. 400 million extents seen, 4 billion to overflow),
and nobody is using the attribute fork sufficiently hard to overflow
65536 extents (typically a couple of million xattrs per inode).

i.e. this series is ground work for upcoming internal filesystem
functionality that require much larger attribute forks (parent
pointers and fsverity merkle tree storage) to be supported, and
allow scope for much larger, massively fragmented VM image files
(beyond 16TB on 4kB block size fs for worst case
fragmentation/reflink). 

As a standalone patchset, this provides almost no real benefit to
users but adds a whole new set of "hard stop" error paths across
every operation that does inode data/attr extent allocation. i.e.
the scope of affected functionality is very wide, the benefit
to users is pretty much zero.

Hence I'm left wondering what criteria ranks this as a high value
change...

> - Chandan has written good regression tests
>
> I intend to post the rest of the individual selected patches
> for review in small batches after they pass the tests, but w.r.t this
> patch set -
> 
> Does anyone object to including it in the stable kernel
> after it passes the tests?

I prefer that the process doesn't result in taking random unnecesary
functionality into stable kernels. The part of the LTS process that
I've most disagreed with is the "backport random unnecessary
changes" part of the stable selection criteria. It doesn't matter if
it's selected by a bot or a human, the problems that causes are the
same.

Hence on those grounds, I'd say this isn't a stable backport
candidate at all...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
