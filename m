Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33188 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfBZLQE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Feb 2019 06:16:04 -0500
Received: by mail-wr1-f66.google.com with SMTP id i12so13511777wrw.0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Feb 2019 03:16:02 -0800 (PST)
Date: Tue, 26 Feb 2019 12:15:58 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Umount D status issue after unplugging the disk
Message-ID: <20190226111558.b3ygxv75l7e6um4z@pegasus.maiolino.io>
References: <CALe3CaAcu02u4GcFefDs5PGHuGNuCz2zR4oxsAwcbBZjwah-_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALe3CaAcu02u4GcFefDs5PGHuGNuCz2zR4oxsAwcbBZjwah-_A@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Su Hua <suhua.tanke@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 21, 2019 at 10:54:53AM +0800, Su Hua wrote:
>    Hi Carlos
>    I am using the kernel version 4.4.163. There is a problem that umount
>    is in the D state after the disk is unplugged. This problem was solved
>    after version 4.7. Now that we have not upgraded the kernel version, I
>    want to try backport on this 4.4.163 first. I added these two patches
>    separately. But there are still problems, can you still recall where i
>    need to change?

Hello Su. My apologies for the late response.

>    patch：
>    [1]e6b3bb78962e6 ("xfs: add "fail at unmount" error handling
>    configuration")

This alone can't do much without the fixes in buffer writeback code.

>    [2]9356413  Release buffer locks in case of IO error

This patch specifically was a 'hack' to prove a point where the problem was, but
it never was the proper fix.

I believe the patches you are looking for are (from Linus's tree):

373b0589dc8d
842f6e9f7862
d3a304b62921
0b80ae6ed131

Cheers

>    This is the information I used to communicate with Brian.
>    [3]https://www.spinics.net/lists/linux-xfs/msg24740.html
>    problem：
>    ...
>    Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp:
>    xfs_trans_read_buf() returned error -5.
>    Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp:
>    xfs_trans_read_buf() returned error -5.
>    Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp:
>    xfs_trans_read_buf() returned error -5.
>    Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp:
>    xfs_trans_read_buf() returned error -5.
>    Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp:
>    xfs_trans_read_buf() returned error -5.
>    Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp:
>    xfs_trans_read_buf() returned error -5.
>    Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp:
>    xfs_trans_read_buf() returned error -5.
>    Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp:
>    xfs_trans_read_buf() returned error -5.
>    Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp:
>    xfs_trans_read_buf() returned error -5.
>    Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp:
>    xfs_trans_read_buf() returned error -5.
>    Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp:
>    xfs_trans_read_buf() returned error -5.
>    Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp:
>    xfs_trans_read_buf() returned error -5.
>    Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp:
>    xfs_trans_read_buf() returned error -5.
>    Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp:
>    xfs_trans_read_buf() returned error -5.
>    Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp:
>    xfs_trans_read_buf() returned error -5.
>    Feb 20 18:07:56 node-1 kernel: XFS (sdc): xfs_imap_to_bp:
>    xfs_trans_read_buf() returned error -5.
>    ...
>    This is where I modified according to the second patch.
>    440     /*
>    441      * Someone else is already flushing the inode.  Nothing we can
>    do
>    442      * here but wait for the flush to finish and remove the item
>    from
>    443      * the AIL.
>    444      */
>    445     if (!xfs_iflock_nowait(ip)) {
>    446
>    447             if (lip->li_mountp->m_flags & XFS_MOUNT_UNMOUNTING) {
>    448                     int error;
>    449                     struct xfs_dinode *dip;
>    450
>    451                     error = xfs_imap_to_bp(ip->i_mount, NULL,
>    &ip->i_imap, &dip,
>    452                                     &bp, XBF_TRYLOCK, 0);
>    453                     if (error) {
>    454                             rval = XFS_ITEM_FLUSHING;
>    455                             goto out_unlock;
>    456                     }
>    457
>    458                     if (!(bp->b_flags & XBF_WRITE_FAIL)) {
>    459                             rval = XFS_ITEM_FLUSHING;
>    460                             xfs_buf_relse(bp);
>    461                             goto out_unlock;
>    462                     }
>    463
>    464                     if (!xfs_buf_delwri_queue(bp, buffer_list))
>    465                             rval = XFS_ITEM_FLUSHING;
>    466
>    467                     xfs_buf_relse(bp);
>    468             } else
>    469                     rval = XFS_ITEM_FLUSHING;
>    470         goto out_unlock;
>    471     }
>    regards
>    su
> 
> References
> 
>    1. http://kernel.suse.com/cgit/kernel/commit/?h=stable&id=e6b3bb78962e65c4ad125598755cfbf2a8779e86
>    2. https://patchwork.kernel.org/patch/9356413/
>    3. https://www.spinics.net/lists/linux-xfs/msg24740.html

-- 
Carlos
