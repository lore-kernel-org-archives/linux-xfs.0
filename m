Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4096C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 05:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244021AbiEYFty (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 01:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243629AbiEYFtx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 01:49:53 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB11370350
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 22:49:51 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id r1so990596qvz.8
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 22:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZLCIUhsPIr7zA+4cTqm9nRrIh/YQu8HaslnGXHKmE/I=;
        b=jtEuyyzrsIbzNheWKXzLA2u5vOgtQcz3artvrgQrp79VKtnlfUC4Pfb5lcotokESXD
         cAOIkoYU6J8kB4++zWtUaF0khe085N/toVFdkFJ7jtbntKalp+uOnr11GplDecnrMhh0
         yh2Jno0TaINGku/cN996M5MciaWzOFD/FRsWHQSbjakqhIvhv8eLfbayzFUCKT+yijek
         Zq+oBlrrMzXw4LnNBAF8E1Lng/knkihmplq15UvP2jxRuPnOAXlYUmjoAXJustSMWk9y
         Cd6+HmIpLyHFQWH6MwbU36om6Xx4c05NW3z8X+KUmqzNvH6LmzpdPCyV9TcOYHjVZkgc
         89XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZLCIUhsPIr7zA+4cTqm9nRrIh/YQu8HaslnGXHKmE/I=;
        b=rxvSKdoFKZhF6AS9+xHPCOF+ES1Xc+FDWNpuNfu5s/kKv7dGXHhABcz0PEawKaf4yk
         76Ip4I1DUuSEOK2ZDGfHOotGWORdvjc9C9ORnNzqWPPfRO6JHc/dUxRNr876jaXMJbgL
         fpcjuIZcAM6RRJBywcBNO00UJj+B7VVzMqmTTPuG2MQSreD5DkHW/4IJAft5GCJQP2D9
         PXOUvDMexzqVjG9NFXsJY6bfXSsWuh+yZFo8TcC6maDbfYpJKujay6Ic14SyO2r+/oig
         ecAlelTj1JjBzsMNAVEho4GgwAjsmuwmYyNld0QoSmk008hotecbMgUfW5p1LYwnb213
         7pXg==
X-Gm-Message-State: AOAM5334QVwDSOegTAdpDBla0ISpEQ88xODxleLQY5JPIVy4KEaxOIDy
        lVFvcqj0rqHY/w/pxOem33Yvw+5FOAep9tLrBVg=
X-Google-Smtp-Source: ABdhPJzN6WR3yXgFkfbaOT/7+5RD9TgVRnhSMahSEmiy5vbd9F223EMLJ7mezWv5rPl2iWDO/CnK+CzuuBPYYtD5dDE=
X-Received: by 2002:a05:6214:1cc4:b0:435:35c3:f0f1 with SMTP id
 g4-20020a0562141cc400b0043535c3f0f1mr24559634qvd.0.1653457790785; Tue, 24 May
 2022 22:49:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
 <CAOQ4uxi8eNVCjqeSeVFRgrYC00gjdbuPyV4B2WPN0DmqjrfyFg@mail.gmail.com>
 <878rqs2pg9.fsf@debian-BULLSEYE-live-builder-AMD64> <CAOQ4uxj2Q2mEvrBmBBV7w=NN5SXsLgk=8ph_iAa0jFCV9QP8NA@mail.gmail.com>
In-Reply-To: <CAOQ4uxj2Q2mEvrBmBBV7w=NN5SXsLgk=8ph_iAa0jFCV9QP8NA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 25 May 2022 08:49:39 +0300
Message-ID: <CAOQ4uxgLGp=J=35S_zUB3DHUTYS0uWKHtvLUtyFb2r=W78SHxg@mail.gmail.com>
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

On Mon, May 23, 2022 at 10:06 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, May 23, 2022 at 7:17 PM Chandan Babu R <chandan.babu@oracle.com> wrote:
> >
> > On Mon, May 23, 2022 at 02:15:44 PM +0300, Amir Goldstein wrote:
> > > On Sun, Jan 10, 2021 at 6:10 PM Chandan Babu R <chandanrlinux@gmail.com> wrote:
> > >>
> > >> XFS does not check for possible overflow of per-inode extent counter
> > >> fields when adding extents to either data or attr fork.
> > >>
> > >> For e.g.
> > >> 1. Insert 5 million xattrs (each having a value size of 255 bytes) and
> > >>    then delete 50% of them in an alternating manner.
> > >>
> > >> 2. On a 4k block sized XFS filesystem instance, the above causes 98511
> > >>    extents to be created in the attr fork of the inode.
> > >>
> > >>    xfsaild/loop0  2008 [003]  1475.127209: probe:xfs_inode_to_disk: (ffffffffa43fb6b0) if_nextents=98511 i_ino=131
> > >>
> > >> 3. The incore inode fork extent counter is a signed 32-bit
> > >>    quantity. However, the on-disk extent counter is an unsigned 16-bit
> > >>    quantity and hence cannot hold 98511 extents.
> > >>
> > >> 4. The following incorrect value is stored in the xattr extent counter,
> > >>    # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
> > >>    core.naextents = -32561
> > >>
> > >> This patchset adds a new helper function
> > >> (i.e. xfs_iext_count_may_overflow()) to check for overflow of the
> > >> per-inode data and xattr extent counters and invokes it before
> > >> starting an fs operation (e.g. creating a new directory entry). With
> > >> this patchset applied, XFS detects counter overflows and returns with
> > >> an error rather than causing a silent corruption.
> > >>
> > >> The patchset has been tested by executing xfstests with the following
> > >> mkfs.xfs options,
> > >> 1. -m crc=0 -b size=1k
> > >> 2. -m crc=0 -b size=4k
> > >> 3. -m crc=0 -b size=512
> > >> 4. -m rmapbt=1,reflink=1 -b size=1k
> > >> 5. -m rmapbt=1,reflink=1 -b size=4k
> > >>
> > >> The patches can also be obtained from
> > >> https://github.com/chandanr/linux.git at branch xfs-reserve-extent-count-v14.
> > >>
> > >> I have two patches that define the newly introduced error injection
> > >> tags in xfsprogs
> > >> (https://lore.kernel.org/linux-xfs/20201104114900.172147-1-chandanrlinux@gmail.com/).
> > >>
> > >> I have also written tests
> > >> (https://github.com/chandanr/xfstests/commits/extent-overflow-tests)
> > >> for verifying the checks introduced in the kernel.
> > >>
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
> > > - Chandan has written good regression tests
> > >
> > > I intend to post the rest of the individual selected patches
> > > for review in small batches after they pass the tests, but w.r.t this
> > > patch set -
> > >
> > > Does anyone object to including it in the stable kernel
> > > after it passes the tests?
> > >
> >
> > Hi Amir,
> >
> > The following three commits will have to be skipped from the series,
> >
> > 1. 02092a2f034fdeabab524ae39c2de86ba9ffa15a
> >    xfs: Check for extent overflow when renaming dir entries
> >
> > 2. 0dbc5cb1a91cc8c44b1c75429f5b9351837114fd
> >    xfs: Check for extent overflow when removing dir entries
> >
> > 3. f5d92749191402c50e32ac83dd9da3b910f5680f
> >    xfs: Check for extent overflow when adding dir entries
> >
> > The maximum size of a directory data fork is ~96GiB. This is much smaller than
> > what can be accommodated by the existing data fork extent counter (i.e. 2^31
> > extents).
> >
>
> Thanks for this information!
>
> I understand that the "fixes" are not needed, but the moto of the stable
> tree maintainers is that taking harmless patches is preferred over non
> clean backports and without those patches, the rest of the series does
> not apply cleanly.
>
> So the question is: does it hurt to take those patches to the stable tree?

All right, I've found the revert partial patch in for-next:
83a21c18441f xfs: Directory's data fork extent counter can never overflow

I can backport this patch to stable after it hits mainline (since this is not
an urgent fix I would wait for v.5.19.0) with the obvious omission of the
XFS_MAX_EXTCNT_*_FORK_LARGE constants.

But even then, unless we have a clear revert in mainline, it is better to
have the history in stable as it was in mainline.

Furthermore, stable, even more than mainline, should always prefer safety
over performance optimization, the sending the 3 patches already in mainline
to stable without the partial revert is better than sending no patches at all
and better then delaying the process.

Thanks,
Amir.
