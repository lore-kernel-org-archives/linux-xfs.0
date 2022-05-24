Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5818DC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 16:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239633AbiEXQHs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 12:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239772AbiEXQHh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 12:07:37 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F5B9548D
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 09:05:19 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id v14so15064718qtc.3
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 09:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GpiwcD/9969sKw1R8f6HEAjlIUawGzwrVtr+J1jgBUo=;
        b=fKEVIKP2n0mnANMUsvWLan8J675MVv0QRft8ubfz22nA4R9GUxCSUef6bJNsV3Ae1/
         owYZsWxap9j4pflFC7n/NDA29VTNd5PCZQMZejRAGhqAcpCU0rgJX9wnxd6J96em+fmo
         R6pzHUALG9hnPbbUc9okrrAtjg2lCmu7qeXynNOmnEksUhOkJZsCs5+tMsLIAGuTEsXe
         Kn/WVZB+jG8r2y6q4BupNyRrSH0qAb/6e82R47Svdem85OGR8h4y7qIX5/1KdcAI/Hmc
         J2Xbv7iNmYhcugT0joLw1oUOgg2LNPe+qX1KNQrL5FfM5Q7gmw1nVR8ZKedzSpBrUbny
         ISPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GpiwcD/9969sKw1R8f6HEAjlIUawGzwrVtr+J1jgBUo=;
        b=Qt4M7rP0jb1gw1Sf6e84NJPrLZQwMuCkE/zldiSclbFtr8lOLXm3kLfaE4JoaqM/hd
         unHl9/CPa6hYezlfItYQpF8cnal3vYrYmaGUB0epkQ9X+VnEoHDE8JBayuPsxzYH9fW3
         hDng74GYt2lMYKPapsffSbLbpz2hSWDiUG2m3u+7Fo579USBnIlAX9dWmJLp5RyoCnc8
         1teuvVdshf+Ia2PVh1+136prstpwIIYB32rHOA0jNZILc3FFCqyptaztKum4IWritgMz
         lxUbAJxOrDOZGwsU8mlO9ghg4MqgHFLtwoZ9aKiD6dZvSC0aeETKCquwxSnDfbzlFeJz
         eb9w==
X-Gm-Message-State: AOAM5333gGq1ezLQ48IaII4rwCFeFwiTaeQllWFQFDEqmCJVRtv1WR+Y
        0qGYobNGKdlrCfJYF03EfpLxpFHosU3yyg9lVbg=
X-Google-Smtp-Source: ABdhPJyEB33kGpCY4P9NOOSsa6NhY7yg92deSbGBBmz0UkEmyuOzVM5TonmHGDnMSZAfqQKllUWU7QyWMcaotLidsdE=
X-Received: by 2002:ac8:4e42:0:b0:2f4:fc3c:b0c8 with SMTP id
 e2-20020ac84e42000000b002f4fc3cb0c8mr20920389qtw.684.1653408318811; Tue, 24
 May 2022 09:05:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
 <CAOQ4uxi8eNVCjqeSeVFRgrYC00gjdbuPyV4B2WPN0DmqjrfyFg@mail.gmail.com>
 <20220523224352.GT1098723@dread.disaster.area> <CAOQ4uxgJFVOs-p8kX+4n=TSCK-KbwjgDPaM4t81-x8gHO77FnQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxgJFVOs-p8kX+4n=TSCK-KbwjgDPaM4t81-x8gHO77FnQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 24 May 2022 19:05:07 +0300
Message-ID: <CAOQ4uxhhvsH8zLHxVc=HNViO12cssWFK4y+Pq5Jsz=2ymGaypg@mail.gmail.com>
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

On Tue, May 24, 2022 at 8:36 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, May 24, 2022 at 1:43 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Mon, May 23, 2022 at 02:15:44PM +0300, Amir Goldstein wrote:
> > > On Sun, Jan 10, 2021 at 6:10 PM Chandan Babu R <chandanrlinux@gmail.com> wrote:
> > > >
> > > > XFS does not check for possible overflow of per-inode extent counter
> > > > fields when adding extents to either data or attr fork.
> > > >
> > > > For e.g.
> > > > 1. Insert 5 million xattrs (each having a value size of 255 bytes) and
> > > >    then delete 50% of them in an alternating manner.
> > > >
> > > > 2. On a 4k block sized XFS filesystem instance, the above causes 98511
> > > >    extents to be created in the attr fork of the inode.
> > > >
> > > >    xfsaild/loop0  2008 [003]  1475.127209: probe:xfs_inode_to_disk: (ffffffffa43fb6b0) if_nextents=98511 i_ino=131
> > > >
> > > > 3. The incore inode fork extent counter is a signed 32-bit
> > > >    quantity. However, the on-disk extent counter is an unsigned 16-bit
> > > >    quantity and hence cannot hold 98511 extents.
> > > >
> > > > 4. The following incorrect value is stored in the xattr extent counter,
> > > >    # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
> > > >    core.naextents = -32561
> > > >
> > > > This patchset adds a new helper function
> > > > (i.e. xfs_iext_count_may_overflow()) to check for overflow of the
> > > > per-inode data and xattr extent counters and invokes it before
> > > > starting an fs operation (e.g. creating a new directory entry). With
> > > > this patchset applied, XFS detects counter overflows and returns with
> > > > an error rather than causing a silent corruption.
> > > >
> > > > The patchset has been tested by executing xfstests with the following
> > > > mkfs.xfs options,
> > > > 1. -m crc=0 -b size=1k
> > > > 2. -m crc=0 -b size=4k
> > > > 3. -m crc=0 -b size=512
> > > > 4. -m rmapbt=1,reflink=1 -b size=1k
> > > > 5. -m rmapbt=1,reflink=1 -b size=4k
> > > >
> > > > The patches can also be obtained from
> > > > https://github.com/chandanr/linux.git at branch xfs-reserve-extent-count-v14.
> > > >
> > > > I have two patches that define the newly introduced error injection
> > > > tags in xfsprogs
> > > > (https://lore.kernel.org/linux-xfs/20201104114900.172147-1-chandanrlinux@gmail.com/).
> > > >
> > > > I have also written tests
> > > > (https://github.com/chandanr/xfstests/commits/extent-overflow-tests)
> > > > for verifying the checks introduced in the kernel.
> > > >
> > >
> > > Hi Chandan and XFS folks,
> > >
> > > As you may have heard, I am working on producing a series of
> > > xfs patches for stable v5.10.y.
> > >
> > > My patch selection is documented at [1].
> > > I am in the process of testing the backport patches against the 5.10.y
> > > baseline using Luis' kdevops [2] fstests runner.
> > >
> > > The configurations that we are testing are:
> > > 1. -m rmbat=0,reflink=1 -b size=4k (default)
> > > 2. -m crc=0 -b size=4k
> > > 3. -m crc=0 -b size=512
> > > 4. -m rmapbt=1,reflink=1 -b size=1k
> > > 5. -m rmapbt=1,reflink=1 -b size=4k
> > >
> > > This patch set is the only largish series that I selected, because:
> > > - It applies cleanly to 5.10.y
> > > - I evaluated it as low risk and high value
> >
> > What value does it provide LTS users?
> >
>
> Cloud providers deploy a large number of VMs/containers
> and they may use reflink. So I think this could be an issue.
>
> > This series adds almost no value to normal users - extent count
> > overflows are just something that doesn't happen in production
> > systems at this point in time. The largest data extent count I've
> > ever seen is still an order of magnitude of extents away from
> > overflowing (i.e. 400 million extents seen, 4 billion to overflow),
> > and nobody is using the attribute fork sufficiently hard to overflow
> > 65536 extents (typically a couple of million xattrs per inode).
> >
> > i.e. this series is ground work for upcoming internal filesystem
> > functionality that require much larger attribute forks (parent
> > pointers and fsverity merkle tree storage) to be supported, and
> > allow scope for much larger, massively fragmented VM image files
> > (beyond 16TB on 4kB block size fs for worst case
> > fragmentation/reflink).
>
> I am not sure I follow this argument.
> Users can create large attributes, can they not?
> And users can create massive fragmented/reflinked images, can they not?
> If we have learned anything, is that if users can do something (i.e. on stable),
> users will do that, so it may still be worth protecting this workflow?
>
> I argue that the reason that you did not see those constructs in the wild yet,
> is the time it takes until users format new xfs filesystems with mkfs
> that defaults
> to reflink enabled and then use latest userspace tools that started to do
> copy_file_range() or clone on their filesystem, perhaps even without the
> user's knowledge, such as samba [1].
>
> [1] https://gitlab.com/samba-team/samba/-/merge_requests/2044
>
> >
> > As a standalone patchset, this provides almost no real benefit to
> > users but adds a whole new set of "hard stop" error paths across
> > every operation that does inode data/attr extent allocation. i.e.
> > the scope of affected functionality is very wide, the benefit
> > to users is pretty much zero.
> >
> > Hence I'm left wondering what criteria ranks this as a high value
> > change...
> >
>
> Given your inputs, I am not sure that the fix has high value, but I must
> say I didn't fully understand your argument.
> It sounded like
> "We don't need the fix because we did not see the problem yet",
> but I may have misunderstood you.
>
> I am sure that you are aware of the fact that even though 5.10 is
> almost 2 y/o, it has only been deployed recently by some distros.
>
> For example, Amazon AMI [2] and Google Cloud COS [3] images based
> on the "new" 5.10 kernel were only released about half a year ago.
>
> [2] https://aws.amazon.com/about-aws/whats-new/2021/11/amazon-linux-2-ami-kernel-5-10/
> [3] https://cloud.google.com/container-optimized-os/docs/release-notes/m93#cos-93-16623-39-6
>
> I have not analysed the distro situation w.r.t xfsprogs, but here the
> important factor is which version of xfsprogs was used to format the
> user's filesystem, not which xfsprogs is installed on their system now.
>
> > > - Chandan has written good regression tests
> > >
> > > I intend to post the rest of the individual selected patches
> > > for review in small batches after they pass the tests, but w.r.t this
> > > patch set -
> > >
> > > Does anyone object to including it in the stable kernel
> > > after it passes the tests?
> >
> > I prefer that the process doesn't result in taking random unnecesary
> > functionality into stable kernels. The part of the LTS process that
> > I've most disagreed with is the "backport random unnecessary
> > changes" part of the stable selection criteria. It doesn't matter if
> > it's selected by a bot or a human, the problems that causes are the
> > same.
>
> I am in agreement with you.
>
> If you actually look at my selections [4]
> I think that you will find that they are very far from "random".
> I have tried to make it VERY easy to review my selections, by
> listing the links to lore instead of the commit ids and my selection
> process is also documented in the git log.
>
> TBH, *this* series was the one that I was mostly in doubt about,
> which is one of the reasons I posted it first to the list.
> I was pretty confident about my risk estimation, but not so much
> about the value.
>
> Also, I am considering my post in this mailing list (without CC stable)
> part of the process, and the inputs I got from you and from Chandan
> is exactly what is missing in the regular stable tree process IMO, so
> I appreciate your inputs very much.
>
> >
> > Hence on those grounds, I'd say this isn't a stable backport
> > candidate at all...
> >
>

Allow me to rephrase that using a less hypothetical use case.

Our team is working on an out-of-band dedupe tool, much like
https://markfasheh.github.io/duperemove/duperemove.html
but for larger scale filesystems and testing focus is on xfs.

In certain settings, such as containers, the tool does not control the
running kernel and *if* we require a new kernel, the newest we can
require in this setting is 5.10.y.

How would the tool know that it can safely create millions of dups
that may get fragmented?
One cannot expect from a user space tool to check which kernel
it is running on, even asking which filesystem it is running on would
be an irregular pattern.

The tool just checks for clone/dedupe support in the underlying filesystem.

The way I see it, backporting these changes to LTS kernel is the
only way to move forward, unless you can tell me, and I did not
understand that from your response, why our tool is safe to use
on 5.10.y and why fragmentation cannot lead to hitting maximum
extent limitation in kernel 5.10.y.

So with that information in mind, I have to ask again:

Does anyone *object* to including this series in the stable kernel
after it passes the tests?

Chandan and all,

Do you consider it *harmful* to apply the 3 commits about directory
extents that Chandan listed as "unneeded"?

Please do not regard this as a philosophical question.
Is there an actual known bug/regression from applying those 3 patches
to the 5.10.y kernel?

Because my fstests loop has been running on the recommended xfs
configs for over 30 times now and have not detected any regression
from the baseline LTS kernel so far.

Thanks,
Amir.
