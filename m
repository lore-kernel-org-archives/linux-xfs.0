Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:46634 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751530AbeFDEwe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 00:52:34 -0400
Received: by mail-yb0-f194.google.com with SMTP id p22-v6so10632842yba.13
        for <linux-xfs@vger.kernel.org>; Sun, 03 Jun 2018 21:52:34 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: Re: NULL pointer dereference in xfs_bmap_extents_to_btree() when
 mounting and operating a crafted image
From: Wen Xu <xuwen.sjtu@gmail.com>
In-Reply-To: <20180604042227.GO10363@dastard>
Date: Mon, 4 Jun 2018 00:52:33 -0400
Content-Transfer-Encoding: quoted-printable
Message-Id: <20906E91-1B6B-4F3E-AA97-8AAA86BE715B@gmail.com>
References: <CANrHXgzLvaud2HEv3jAFGTfn5S80d7Rwj-ztJNWPT8eyFTohMg@mail.gmail.com>
 <20180603223435.GU10363@dastard> <20180603230341.GV10363@dastard>
 <20180603233114.GW10363@dastard>
 <CANrHXgwP5nOaG6nZwUs-bM_oJDNdUnXj=33xrrLJ-OvyCaz_EA@mail.gmail.com>
 <20180604042227.GO10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org



> On Jun 4, 2018, at 12:22 AM, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Sun, Jun 03, 2018 at 10:07:52PM -0400, Wen Xu wrote:
>> Hi Dave,
>>=20
>> Very strange.
>>=20
>> I checkout v4.17-rc7 of
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
>> and merge with for-next of
>> https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/ to make the
>> kernel build.
>=20
> The last commit from the for-next tree I have is:
>=20
> d25522f10cfa xfs: repair superblocks
>=20
> Does that match what you merged?

Ah it seems not=E2=80=A6 Considering the commit log =
(https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/log/?h=3Dfor-next),
The last commit here is fs: use ->is_partially_uptodate in =
page_cache_seek_hole_data

>=20
>> d1dabff17081af94c9604c5fdddd0de7  20.img
>> mounting 20.img and running poc.c on mounted folder still gives me
>> nullptr access.
>>=20
>> [ 1381.524410] XFS (loop0): Mounting V4 Filesystem
>> [ 1381.524484] XFS (loop0): Log size 864 blocks too small, minimum
>> size is 942 blocks
>> [ 1381.524487] XFS (loop0): Log size out of supported range.
>> [ 1381.525728] XFS (loop0): Continuing onwards, but if log hangs are
>> experienced then please report this message in the bug report.
>> [ 1381.533754] XFS (loop0): Ending clean mount
>> [ 1388.369552] XFS (loop0): xfs_buf_find: daddr 0x7fb28 out of range, =
EOFS 0x8000
>=20
> So, somehow, it's getting a block beyond EOF being allocated out of
> the free space tree. So what we have here is an uncaught corrupt
> freespace record....
>=20
> <sigh>
>=20
> $ sudo xfs_repair -n -f xfs.img
> Phase 1 - find and verify superblock...
> bad primary superblock - inconsistent filesystem geometry in
> realtime filesystem component !!!
>=20
> attempting to find secondary superblock...
> ...Sorry, could not find valid secondary superblock
> Exiting now.
> $
>=20
> Please use a filesystem with at least 2 AGs as the basis of your
> fuzzing in future.
>=20
> But, yeah, xfs_db tells me the by-size freespace btree is full of
> crap, but the by-cnt tree is completely empty (i.e. corrupt) so
> allocation should definitely be failing long before if gets anywhere
> near returning an allocated block.
>=20
> Ok, I just worked out why I haven't been able to reproduce the
> issue: you have no error checking in your test code, so I get no
> indication that it fails to run correctly when run as a user.
>=20
> Alright, lets start this whole thing again.
>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com

I see. Yeah, my test code is a bit scratchy=E2=80=A6I will make a new =
seed image w/ at least 2ag for my fuzzing later.

Thanks,
Wen

