Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34960 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbcIVJCK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2016 05:02:10 -0400
MIME-Version: 1.0
In-Reply-To: <1473856994-27463-5-git-send-email-amir73il@gmail.com>
References: <1473856994-27463-1-git-send-email-amir73il@gmail.com> <1473856994-27463-5-git-send-email-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 22 Sep 2016 11:49:38 +0300
Message-ID: <CAOQ4uxjhO0M4K4oNA0dGsN6-DHtJ7zFQVLe=T2qpuWb+eubaig@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] ovl: use vfs_copy_file_range() to copy up file data
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Sep 14, 2016 at 3:43 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Use vfs_copy_file_range() helper instead of calling do_splice_direct()
> when copying up file data.
> When copying up within the same fs, which supports copy_file_range(),
> fs implementation can be more efficient then do_splice_direct().
> vfs_copy_file_range() helper falls back to do_splice_direct() if
> it cannot use the file system's copy_file_range() implementation.
>
> A previous change added a vfs_clone_file_range() call before
> the data copy loop, so this change is only effective for filesystems
> that support copy_file_range() and *do not* support clone_file_range().
> At the moment, there are no such filesystems in the kernel that
> can be used as overlayfs upper, so I tested this change by disabling
> the vfs_clone_file_range() call.
>
> Tested correct behavior when lower and upper are on:
> 1. same ext4 (copy)
> 2. same xfs + reflink patches + mkfs.xfs (copy)
> 3. same xfs + reflink patches + mkfs.xfs -m reflink=1 (reflink)
> 4. different xfs + reflink patches + mkfs.xfs -m reflink=1 (copy)
>
> For comparison, on my laptop, xfstest overlay/001 (copy up of large
> sparse files) takes less than 1 second in the xfs reflink setup vs.
> 25 seconds on the rest of the setups.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/copy_up.c | 10 +++++-----
>  fs/read_write.c        |  1 +
>  2 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index ba039f8..a6d6bac 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -146,7 +146,6 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>         /* Can't clone, so now we try to copy the data */
>         error = 0;
>
> -       /* FIXME: copy up sparse files efficiently */
>         while (len) {
>                 size_t this_len = OVL_COPY_UP_CHUNK_SIZE;
>                 long bytes;
> @@ -159,15 +158,16 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>                         break;
>                 }
>
> -               bytes = do_splice_direct(old_file, &old_pos,
> -                                        new_file, &new_pos,
> -                                        this_len, SPLICE_F_MOVE);
> +               bytes = vfs_copy_file_range(old_file, old_pos,
> +                                           new_file, new_pos,
> +                                           this_len, 0);
>                 if (bytes <= 0) {
>                         error = bytes;
>                         break;
>                 }
> -               WARN_ON(old_pos != new_pos);
>
> +               old_pos += bytes;
> +               new_pos += bytes;
>                 len -= bytes;
>         }
>  out:
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 6975fe8..dfc083a 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1515,6 +1515,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>             file_out->f_op->copy_file_range)
>                 ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out,
>                                                       pos_out, len, flags);
> +       /* FIXME: copy sparse file range efficiently */
>         if (ret == -EOPNOTSUPP)
>                 ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
>                                 len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
> --
> 2.7.4
>

Guys, I just hit a lockdep warning on nesting an mnt_want_write() with
this patch
because overlay already holds the write lock when getting to ovl_copy_up_data()
I don't know how I missed it before.

Is it really a problem to nest this lock?
Should I factor our another set of _locked helpers from the
vfs_{copy,clone}_file_range helpers?

===========

[  675.814754] =============================================
[  675.814755] [ INFO: possible recursive locking detected ]
[  675.814757] 4.8.0-rc5+ #5 Tainted: G        W  O
[  675.814758] ---------------------------------------------
[  675.814759] xfs_io/15241 is trying to acquire lock:
[  675.814760]  (sb_writers#7){.+.+.+}, at: [<ffffffffa2277144>]
__sb_start_write+0xb4/0xf0
[  675.814767]
               but task is already holding lock:
[  675.814768]  (sb_writers#7){.+.+.+}, at: [<ffffffffa2277144>]
__sb_start_write+0xb4/0xf0
[  675.814772]
               other info that might help us debug this:
[  675.814773]  Possible unsafe locking scenario:

[  675.814774]        CPU0
[  675.814775]        ----
[  675.814775]   lock(sb_writers#7);
[  675.814777]   lock(sb_writers#7);
[  675.814779]
                *** DEADLOCK ***

[  675.814780]  May be due to missing lock nesting notation

[  675.814782] 4 locks held by xfs_io/15241:
[  675.814783]  #0:  (sb_writers#7){.+.+.+}, at: [<ffffffffa2277144>]
__sb_start_write+0xb4/0xf0
[  675.814787]  #1:  (&type->s_vfs_rename_key){+.+.+.}, at:
[<ffffffffa227f992>] lock_rename+0x32/0x100
[  675.814791]  #2:  (&type->i_mutex_dir_key#2/1){+.+.+.}, at:
[<ffffffffa227fa40>] lock_rename+0xe0/0x100
[  675.814796]  #3:  (&type->i_mutex_dir_key#2/5){+.+.+.}, at:
[<ffffffffa227fa55>] lock_rename+0xf5/0x100
[  675.814800]
               stack backtrace:
[  675.814802] CPU: 2 PID: 15241 Comm: xfs_io Tainted: G        W  O
 4.8.0-rc5+ #5
[  675.814804] Hardware name: Dell Inc. Latitude E7450/0D8H72, BIOS
A13 05/17/2016
[  675.814805]  0000000000000086 00000000029bfc05 ffff9cd454ab78b0
ffffffffa2474d83
[  675.814808]  ffffffffa3a7b6f0 ffff9cd4685f0000 ffff9cd454ab7980
ffffffffa20ed54d
[  675.814810]  0000000000000296 0000000400000246 ffff9cd400000000
ffffffffa3392101
[  675.814813] Call Trace:
[  675.814816]  [<ffffffffa2474d83>] dump_stack+0x85/0xc2
[  675.814820]  [<ffffffffa20ed54d>] __lock_acquire+0x148d/0x14f0
[  675.814822]  [<ffffffffa22ec170>] ? dquot_file_open+0x40/0x50
[  675.814825]  [<ffffffffa20eda70>] lock_acquire+0x100/0x1f0
[  675.814826]  [<ffffffffa2277144>] ? __sb_start_write+0xb4/0xf0
[  675.814829]  [<ffffffffa20e6b1f>] percpu_down_read+0x4f/0xa0
[  675.814830]  [<ffffffffa2277144>] ? __sb_start_write+0xb4/0xf0
[  675.814832]  [<ffffffffa2277144>] __sb_start_write+0xb4/0xf0
[  675.814834]  [<ffffffffa23cdd2d>] ? security_file_permission+0x3d/0xc0
[  675.814837]  [<ffffffffa229ba88>] mnt_want_write_file+0x28/0x60
[  675.814839]  [<ffffffffa2274dd2>] vfs_copy_file_range+0xc2/0x270
[  675.814844]  [<ffffffffc0c797f6>] ovl_copy_up_one+0x4d6/0x710 [overlay]
[  675.814847]  [<ffffffffc0c79b16>] ovl_copy_up+0xe6/0x118 [overlay]
[  675.814850]  [<ffffffffc0c75d6d>] ovl_open_maybe_copy_up+0x8d/0xd0 [overlay]
[  675.814852]  [<ffffffffc0c73303>] ovl_d_real+0xd3/0x130 [overlay]
[  675.814854]  [<ffffffffa227209f>] vfs_open+0x6f/0x80
[  675.814856]  [<ffffffffa2284698>] path_openat+0x2a8/0xb80
[  675.814858]  [<ffffffffa22864e1>] do_filp_open+0x91/0x100
[  675.814861]  [<ffffffffa292abe7>] ? _raw_spin_unlock+0x27/0x40
[  675.814862]  [<ffffffffa2297f39>] ? __alloc_fd+0xf9/0x210
[  675.814864]  [<ffffffffa2272494>] do_sys_open+0x124/0x210
[  675.814867]  [<ffffffffa227259e>] SyS_open+0x1e/0x20
[  675.814868]  [<ffffffffa292b540>] entry_SYSCALL_64_fastpath+0x23/0xc1
