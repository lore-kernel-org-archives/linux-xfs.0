Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 079DEC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 23 May 2022 19:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiEWT1U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 15:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbiEWT06 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 15:26:58 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4509318AAAE
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 12:07:00 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id bs17so13561212qkb.0
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 12:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IcoavjubnHPcUyWqxcLcwNmAcO4yKD0lQ2Uqome84Cw=;
        b=EjywDwPnEZMq5wzaqlaiJjA1PTGm6ZCkqeQ2frv8HJZB887auYEGm0wS4iJ3uuDd9w
         2YdjdIqtygcLNOOk0D3DYod0YBqJ/lRa57X0eAKExf5xb9zfnkP7tpoYCjCiPK1OQGgA
         MORCTEeIC14+vbRN0yz1yq7sWto96lhepdM8KBtuBA9lY6f/XuJTKOIxdnVjdB1mdbjr
         9Lq47+qX7cqgWkO0BCu3pL8mET7cJJ/nlxALmNvU6+l0fvkrnXkQutf/akN9vNWJ6xF3
         0eSuqU+R0Qsuy5eNmxDyjgzWBJhp6zsiv0ruZUjYQZeuX0z7lMGhjMhFMYI30N84fqss
         bZrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IcoavjubnHPcUyWqxcLcwNmAcO4yKD0lQ2Uqome84Cw=;
        b=mbuVAiAO/HP/4jgubaQn6ikWOp96kBFSgT3cHhKJ7OURhqaArB5DXvyCHzcGhK1Q3c
         tNIQo7p4DeH5hWIKSSXL1zyi02P9O1Ec2dIvzSsPwRWy5RFs9cEgoMOg7yW9ObkaEhXi
         GlFujjoF3G7oGrM4SFxRlJPSvDT63N+bswTdgX+8JPdYu0SnFMncdfuohlBsxMRcvnbn
         vEfbFLAfgfhQ+Fz8YXgt5xnVLJ0zCEfJCYCTVSxzeICFo6HAkBSGTmaFK4dUbDM7IEbf
         MHbAj+cUT7tQ8BB6qe/J9K1HW/OfthavkP63XaJzpOTQTvGU+xnnctFBdQSTeRw60Ynv
         p3yQ==
X-Gm-Message-State: AOAM53027hTO/XamBiGiUPifcurGA1ewszt2Wb6wgzPd+x04pg23qS1u
        /65BYnkZenBf1HLR/Xkj+xVDAM8ph/2ywr+J218=
X-Google-Smtp-Source: ABdhPJw+us6Ei8yuEGNEER2FiDxw99oUIQfmX5yKvEKtARIulj+Z9ToD/oQs8RLTp48YhdKkePx7eE35r4AlrBaaC2U=
X-Received: by 2002:a37:8802:0:b0:6a3:4aa4:7cb4 with SMTP id
 k2-20020a378802000000b006a34aa47cb4mr11029532qkd.722.1653332819524; Mon, 23
 May 2022 12:06:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
 <CAOQ4uxi8eNVCjqeSeVFRgrYC00gjdbuPyV4B2WPN0DmqjrfyFg@mail.gmail.com> <878rqs2pg9.fsf@debian-BULLSEYE-live-builder-AMD64>
In-Reply-To: <878rqs2pg9.fsf@debian-BULLSEYE-live-builder-AMD64>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 23 May 2022 22:06:47 +0300
Message-ID: <CAOQ4uxj2Q2mEvrBmBBV7w=NN5SXsLgk=8ph_iAa0jFCV9QP8NA@mail.gmail.com>
Subject: Re: [PATCH V14 00/16] Bail out if transaction can cause extent count
 to overflow
To:     Chandan Babu R <chandan.babu@oracle.com>
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

On Mon, May 23, 2022 at 7:17 PM Chandan Babu R <chandan.babu@oracle.com> wrote:
>
> On Mon, May 23, 2022 at 02:15:44 PM +0300, Amir Goldstein wrote:
> > On Sun, Jan 10, 2021 at 6:10 PM Chandan Babu R <chandanrlinux@gmail.com> wrote:
> >>
> >> XFS does not check for possible overflow of per-inode extent counter
> >> fields when adding extents to either data or attr fork.
> >>
> >> For e.g.
> >> 1. Insert 5 million xattrs (each having a value size of 255 bytes) and
> >>    then delete 50% of them in an alternating manner.
> >>
> >> 2. On a 4k block sized XFS filesystem instance, the above causes 98511
> >>    extents to be created in the attr fork of the inode.
> >>
> >>    xfsaild/loop0  2008 [003]  1475.127209: probe:xfs_inode_to_disk: (ffffffffa43fb6b0) if_nextents=98511 i_ino=131
> >>
> >> 3. The incore inode fork extent counter is a signed 32-bit
> >>    quantity. However, the on-disk extent counter is an unsigned 16-bit
> >>    quantity and hence cannot hold 98511 extents.
> >>
> >> 4. The following incorrect value is stored in the xattr extent counter,
> >>    # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
> >>    core.naextents = -32561
> >>
> >> This patchset adds a new helper function
> >> (i.e. xfs_iext_count_may_overflow()) to check for overflow of the
> >> per-inode data and xattr extent counters and invokes it before
> >> starting an fs operation (e.g. creating a new directory entry). With
> >> this patchset applied, XFS detects counter overflows and returns with
> >> an error rather than causing a silent corruption.
> >>
> >> The patchset has been tested by executing xfstests with the following
> >> mkfs.xfs options,
> >> 1. -m crc=0 -b size=1k
> >> 2. -m crc=0 -b size=4k
> >> 3. -m crc=0 -b size=512
> >> 4. -m rmapbt=1,reflink=1 -b size=1k
> >> 5. -m rmapbt=1,reflink=1 -b size=4k
> >>
> >> The patches can also be obtained from
> >> https://github.com/chandanr/linux.git at branch xfs-reserve-extent-count-v14.
> >>
> >> I have two patches that define the newly introduced error injection
> >> tags in xfsprogs
> >> (https://lore.kernel.org/linux-xfs/20201104114900.172147-1-chandanrlinux@gmail.com/).
> >>
> >> I have also written tests
> >> (https://github.com/chandanr/xfstests/commits/extent-overflow-tests)
> >> for verifying the checks introduced in the kernel.
> >>
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
> > - Chandan has written good regression tests
> >
> > I intend to post the rest of the individual selected patches
> > for review in small batches after they pass the tests, but w.r.t this
> > patch set -
> >
> > Does anyone object to including it in the stable kernel
> > after it passes the tests?
> >
>
> Hi Amir,
>
> The following three commits will have to be skipped from the series,
>
> 1. 02092a2f034fdeabab524ae39c2de86ba9ffa15a
>    xfs: Check for extent overflow when renaming dir entries
>
> 2. 0dbc5cb1a91cc8c44b1c75429f5b9351837114fd
>    xfs: Check for extent overflow when removing dir entries
>
> 3. f5d92749191402c50e32ac83dd9da3b910f5680f
>    xfs: Check for extent overflow when adding dir entries
>
> The maximum size of a directory data fork is ~96GiB. This is much smaller than
> what can be accommodated by the existing data fork extent counter (i.e. 2^31
> extents).
>

Thanks for this information!

I understand that the "fixes" are not needed, but the moto of the stable
tree maintainers is that taking harmless patches is preferred over non
clean backports and without those patches, the rest of the series does
not apply cleanly.

So the question is: does it hurt to take those patches to the stable tree?

> Also the corresponding test (i.e. xfs/533) has been removed from
> fstests. Please refer to
> https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/commit/?id=9ae10c882550c48868e7c0baff889bb1a7c7c8e9
>

Well the test does not fail so it doesn't hurt either. Right?
In my test env, we will occasionally pull latest fstests and then
the unneeded test will be removed.

Does that sound right?

Thanks,
Amir.
