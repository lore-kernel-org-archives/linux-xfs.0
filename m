Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:36273 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbfB0FTv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Feb 2019 00:19:51 -0500
MIME-Version: 1.0
References: <20190226181407.44612-1-bfoster@redhat.com> <CAOQ4uxg12SAKrSpX8_cdx4Cs56FVjdXiH5U1e8Y3yyCegNYDSw@mail.gmail.com>
 <20190226232212.GD16436@dastard> <CAOQ4uxgueAtF5o+Zjd+N0_h7784veL2FNd7-aB+33HWEN07gHg@mail.gmail.com>
 <ed870e00-1931-d7b1-a3ed-8a184889f6fc@gmx.com> <CAOQ4uxhNdzbSiPREmMtv5_81=7bxCRbTaa_KUN00g7De_j6a4Q@mail.gmail.com>
 <1f5c2280-f4db-2c13-bf2b-f4dc4111613a@suse.de>
In-Reply-To: <1f5c2280-f4db-2c13-bf2b-f4dc4111613a@suse.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 27 Feb 2019 07:19:39 +0200
Message-ID: <CAOQ4uxihcTPhJnNKc3siZs3a9iwRnqG1fiXa64_Rgo5rd-hM=Q@mail.gmail.com>
Subject: Re: [PATCH] generic: skip dm-log-writes tests on XFS v5 superblock filesystems
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Qu Wenruo <wqu@suse.de>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, Josef Bacik <josef@toxicpanda.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Feb 27, 2019 at 7:01 AM Qu Wenruo <wqu@suse.de> wrote:
>
>
>
> On 2019/2/27 =E4=B8=8B=E5=8D=8812:49, Amir Goldstein wrote:
> [snip]
> >>> Indeed.
> >>
> >> May I ask a stupid question?
> >>
> >> How does it matter whether the device is clean or not?
> >> Shouldn't the journal/metadata or whatever be self-contained?
> >>
> >
> > Yes and no.
> >
> > The most simple example (not limited to xfs and not sure it is like tha=
t in xfs)
> > is how you find the last valid journal commit entry. It should have cor=
rect CRC
> > and the largest LSN. But it you replay IO on top of existing journal wi=
thout
> > wiping it first, then journal recovery will continue past the point to =
meant to
> > replay or worse.
>
> The journal doesn't have some superblock like system to tell where to
> stop replaying?
>

Yes, it does. My statement was inaccurate.
The point is how can filesystem trust that journal superblock is not corrup=
ted?
If filesystem observes data from the future in the journal that is not
expected to
be there, or any checksumed metadata on the device, it may fail sanity chec=
ks
that superblock or other metadata are not corrupted.

Suppose filesystem has a bug that overwrites new metadata from time N
with old stale metadata buffer from time N-1. That would look not much diff=
erent
than log-writes replay to time N-1 over non clean device from time N.

> If not, then indeed we need to discard the journal before writing new one=
.
>
...

> >> Am I missing something? Or do I get too poisoned by btrfs CoW?
> >>
> >
> > I'd be very surprised if btrfs cannot be flipped by seeing stale data "=
from
> > the future" in the block device. Seems to me like the entire concept of
> > CoW and metadata checksums is completely subverted by the existence
> > of correct checksums on "stale metadata from the future".
>
> It seems that metadata CoW makes it impossible to see future data.
>
> All btree trees get updated CoW, so no metadata will be overwritten
> during one transaction.
> Only super block is overwritten and normally superblock is updated
> atomically.
>
> So either old superblock is still here, all we can see is old tree pointe=
rs.
> Or new superblock is here, all we can see is new tree pointers.
> And new metadata will never be written into old metadata, there is no
> way to see future metadata.
>

Those assumptions could fail if you have unreliable hardware that
reorders IO across FUA, just drops IO on the floor or a bug in the filesyst=
em
or block layer.

Existence of metadata from the future could look like any of
the above has happened.

Thanks,
Amir.
