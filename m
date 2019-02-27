Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:43628 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727187AbfB0F7B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Feb 2019 00:59:01 -0500
MIME-Version: 1.0
References: <20190226181407.44612-1-bfoster@redhat.com> <CAOQ4uxg12SAKrSpX8_cdx4Cs56FVjdXiH5U1e8Y3yyCegNYDSw@mail.gmail.com>
 <20190226232212.GD16436@dastard> <CAOQ4uxgueAtF5o+Zjd+N0_h7784veL2FNd7-aB+33HWEN07gHg@mail.gmail.com>
 <ed870e00-1931-d7b1-a3ed-8a184889f6fc@gmx.com> <CAOQ4uxhNdzbSiPREmMtv5_81=7bxCRbTaa_KUN00g7De_j6a4Q@mail.gmail.com>
 <1f5c2280-f4db-2c13-bf2b-f4dc4111613a@suse.de> <CAOQ4uxihcTPhJnNKc3siZs3a9iwRnqG1fiXa64_Rgo5rd-hM=Q@mail.gmail.com>
 <7aa13461-0f5f-af48-b3d1-48d03108da09@suse.de>
In-Reply-To: <7aa13461-0f5f-af48-b3d1-48d03108da09@suse.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 27 Feb 2019 07:58:48 +0200
Message-ID: <CAOQ4uxjRRtS+sAB8mywdFepWGGZD67JKES3NMoLvbeEQsGJUSg@mail.gmail.com>
Subject: Re: [PATCH] generic: skip dm-log-writes tests on XFS v5 superblock filesystems
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Qu Wenruo <wqu@suse.de>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, Josef Bacik <josef@toxicpanda.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

> >> It seems that metadata CoW makes it impossible to see future data.
> >>
> >> All btree trees get updated CoW, so no metadata will be overwritten
> >> during one transaction.
> >> Only super block is overwritten and normally superblock is updated
> >> atomically.
> >>
> >> So either old superblock is still here, all we can see is old tree pointers.
> >> Or new superblock is here, all we can see is new tree pointers.
> >> And new metadata will never be written into old metadata, there is no
> >> way to see future metadata.
> >>
> >
> > Those assumptions could fail if you have unreliable hardware that
> > reorders IO across FUA, just drops IO on the floor or a bug in the filesystem
> > or block layer.
>
> Well, if hardware has problem, we can't really do anything to help.
>
> Maybe that's reason why there are more corruption report for btrfs as
> there are more problematic hardware than we thought?
>

I think we are not understanding each other.

dm-log-writes and xfstests are not expected to test unreliable hardware.
filesystems are not expected to work properly on unreliable hardware,
but they do have sanity checks to try and detect metadata corruptions that
could be a result of unreliable hardware/storage stack and put up a big
red sign.

If we don't wipe block device before log-writes replay, filesystem trips
over those sanity checks, because replay to time N-1 without wipe of
writes from time N looks awfully similar to flaky hardware/storage stack.

> >
> > Existence of metadata from the future could look like any of
> > the above has happened.
>
> Btrfs has an extra layer to prevent such problem from happening, each
> metadata pointer has its expected generation.
>
> If one metadata has a mismatch generation with its parent, then kernel
> will know something went wrong.
>
> And in fact, that's the most common failure mode for btrfs (although
> most of them is seeing too old metadata), and we're looking into the
> problem (but not much progress yet).
>

Yes, and that is exactly the reason why dm-log-writes has the potential
to generate false positive sanity check failures. Granted, I do not know
the inner works of btrfs CoW to point out a specific problematic use case.

Anyway, we do need to wipe block device before log replay regardless
if btrfs needs it or not.

Thanks,
Amir.
