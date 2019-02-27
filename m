Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46910 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729128AbfB0Dmf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Feb 2019 22:42:35 -0500
Received: by mail-ot1-f68.google.com with SMTP id c18so13123198otl.13
        for <linux-xfs@vger.kernel.org>; Tue, 26 Feb 2019 19:42:34 -0800 (PST)
MIME-Version: 1.0
References: <CALe3CaAcu02u4GcFefDs5PGHuGNuCz2zR4oxsAwcbBZjwah-_A@mail.gmail.com>
In-Reply-To: <CALe3CaAcu02u4GcFefDs5PGHuGNuCz2zR4oxsAwcbBZjwah-_A@mail.gmail.com>
From: Su Hua <suhua.tanke@gmail.com>
Date: Wed, 27 Feb 2019 11:41:54 +0800
Message-ID: <CALe3CaA7r5G4Gs58u--uxOExqaHWZS03NB8+GUyzP+ZZqQKwJA@mail.gmail.com>
Subject: Re: Umount D status issue after unplugging the disk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: cmaiolino@redhat.com
Cc: linux-xfs@vger.kernel.org, Su Hua <suhua.tanke@gmail.com>

Thank you for your tips, I will try it down.

regards


Su Hua <suhua.tanke@gmail.com> =E4=BA=8E2019=E5=B9=B42=E6=9C=8821=E6=97=A5=
=E5=91=A8=E5=9B=9B =E4=B8=8A=E5=8D=8810:54=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi Carlos
> I am using the kernel version 4.4.163. There is a problem that umount is =
in the D state after the disk is unplugged. This problem was solved after v=
ersion 4.7. Now that we have not upgraded the kernel version, I want to try=
 backport on this 4.4.163 first. I added these two patches separately. But =
there are still problems, can you still recall where i need to change?
> patch=EF=BC=9A
> e6b3bb78962e6 ("xfs: add "fail at unmount" error handling configuration")
> 9356413  Release buffer locks in case of IO error
>
> This is the information I used to communicate with Brian.
> https://www.spinics.net/lists/linux-xfs/msg24740.html
>
> problem=EF=BC=9A
> ...
> Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp: xfs_trans_read_=
buf() returned error -5.
> Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp: xfs_trans_read_=
buf() returned error -5.
> Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp: xfs_trans_read_=
buf() returned error -5.
> Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp: xfs_trans_read_=
buf() returned error -5.
> Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp: xfs_trans_read_=
buf() returned error -5.
> Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp: xfs_trans_read_=
buf() returned error -5.
> Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp: xfs_trans_read_=
buf() returned error -5.
> Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp: xfs_trans_read_=
buf() returned error -5.
> Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp: xfs_trans_read_=
buf() returned error -5.
> Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp: xfs_trans_read_=
buf() returned error -5.
> Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp: xfs_trans_read_=
buf() returned error -5.
> Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp: xfs_trans_read_=
buf() returned error -5.
> Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp: xfs_trans_read_=
buf() returned error -5.
> Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp: xfs_trans_read_=
buf() returned error -5.
> Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp: xfs_trans_read_=
buf() returned error -5.
> Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp: xfs_trans_read_=
buf() returned error -5.
> ...
>
> This is where I modified according to the second patch.
> 440     /*
> 441      * Someone else is already flushing the inode.  Nothing we can do
> 442      * here but wait for the flush to finish and remove the item from
> 443      * the AIL.
> 444      */
> 445     if (!xfs_iflock_nowait(ip)) {
> 446
> 447             if (lip->li_mountp->m_flags & XFS_MOUNT_UNMOUNTING) {
> 448                     int error;
> 449                     struct xfs_dinode *dip;
> 450
> 451                     error =3D xfs_imap_to_bp(ip->i_mount, NULL, &ip->=
i_imap, &dip,
> 452                                     &bp, XBF_TRYLOCK, 0);
> 453                     if (error) {
> 454                             rval =3D XFS_ITEM_FLUSHING;
> 455                             goto out_unlock;
> 456                     }
> 457
> 458                     if (!(bp->b_flags & XBF_WRITE_FAIL)) {
> 459                             rval =3D XFS_ITEM_FLUSHING;
> 460                             xfs_buf_relse(bp);
> 461                             goto out_unlock;
> 462                     }
> 463
> 464                     if (!xfs_buf_delwri_queue(bp, buffer_list))
> 465                             rval =3D XFS_ITEM_FLUSHING;
> 466
> 467                     xfs_buf_relse(bp);
> 468             } else
> 469                     rval =3D XFS_ITEM_FLUSHING;
> 470         goto out_unlock;
> 471     }
>
> regards
> su
>
>
