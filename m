Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74CECC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Dec 2020 01:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17F3422B2D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Dec 2020 01:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbgLVBaX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Dec 2020 20:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLVBaW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Dec 2020 20:30:22 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31937C0613D3
        for <linux-xfs@vger.kernel.org>; Mon, 21 Dec 2020 17:29:42 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id i6so10629334otr.2
        for <linux-xfs@vger.kernel.org>; Mon, 21 Dec 2020 17:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZBKiN+RblSTZ3+cYnKPnyLpl4JiONegMbocvGsyvXSo=;
        b=VEbDQsMOesDN2z5M21MF812gf1rt9nYfKotY6IZMpYubZujWGjtHkfeYzkt5O13F/Y
         4q85DRpzRCn4r/Ea1Rk0aDcEK42gVCtPg4xewGqRW5TpsRiMrquejzjoSRPuNib0eF0/
         huG3YwLrXSaSUfDEUtTGp9Y3tMfpffIa7pU1G77ttkfx02BelKSpVQkxZmblmaOEeguw
         gJh5JbSpAnYmd7d6LgzYMtkmun67TPJYJmH1IWJCXUHnqzbXUvK+O2bN6aawMAsFOMRc
         Ufln87Fx5gtbUhJdtSs9S/L+Ys3q10Yk2gC5/XZRz2yF3O0AY+H8X3DD7CdCiyCBqYNZ
         Bj6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZBKiN+RblSTZ3+cYnKPnyLpl4JiONegMbocvGsyvXSo=;
        b=rQPWe6az4HH1yIY4bKXu43o/UKVPcDvu1mbu0rlo/UhDwJ6KDFEndLYqfgYFTpwm/0
         vaitMwJ/IDmUt8XjBQxnMXiRrSjfuvQrhWbxT8bYmQeNZJWcklOls/eBG7TvCKdqSIlV
         5NMxG/7PgESVTR73PMUoCWHXZzZlxfAhfuiiT94sflCl3lsqI44GI8w3zvR998DKMedl
         N9/0prhXT52r0boB+tXia09k70Y0UL2FZLFG3RTnaJM9B3zGtZCt0op2ELO6ZK7u220w
         o7mSKQl1HxuKchKoAS5p/F89bp4c2eMd0IRt5Y2wUwXC9hd1Ko0HmiaQEOQg2ePs/AkO
         iSYw==
X-Gm-Message-State: AOAM533X+94gQoXAmm7XVrnaM62pbk2h468M+BgS1YKfoPB7AFZpUj1r
        cyKDglsQWnZ7boFRJwhErBKK2b0T/SsthrpfCDNHeKXFbC1ZcQ==
X-Google-Smtp-Source: ABdhPJzuhJbIwQZFZpid0OWT1o4niEqcwKfcTlRQU6coZSqEzfJAzPDg8sI8qmKJVMzX/ahXTd3zafSe6zRNLWnrLJ8=
X-Received: by 2002:a05:6830:22eb:: with SMTP id t11mr14927915otc.114.1608600581451;
 Mon, 21 Dec 2020 17:29:41 -0800 (PST)
MIME-Version: 1.0
References: <CABRboy006NP8JrxuBgEJbfCcGGUY2Kucwfov+HJf2xW34D5Ocg@mail.gmail.com>
 <20201211234233.GK106271@magnolia> <CABRboy35_tyxA3gHN7_=xp0_RVugQjvFOHCRsH4Y4rrivE7HmQ@mail.gmail.com>
 <20201217211117.GF38809@magnolia>
In-Reply-To: <20201217211117.GF38809@magnolia>
From:   wenli xie <wlxie7296@gmail.com>
Date:   Tue, 22 Dec 2020 09:29:30 +0800
Message-ID: <CABRboy38580Wfj4g6w0PbLb4hUSm0tFDgXDGBK5pZ=7xySJKqw@mail.gmail.com>
Subject: Re: [Bug report] overlayfs over xfs whiteout operation may cause deadlock
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thanks Darrick
This patch works fine.  I did some tests for about 3 days, this issue
should be fixed.


During the test, I did 'ps -aux|grep mv'  to get the processes' status.
I can see  some `mv` processes come to 'D' state and then disappear.
So this patch may impact the rename operation's performance of overlay and xfs.
I'd like to have a test, any suggestions?
For overlay, this is fine because the container's rootfs shouldn't
have many rename calls.
What I am most worried about is XFS.




On Fri, Dec 18, 2020 at 5:11 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Tue, Dec 15, 2020 at 08:44:27PM +0800, wenli xie wrote:
> > I tried upstream kernel 5.10 to do the test, and this issue still  can be
> > reproduced.
>
> Thanks for the report, I've condensed this down to the following:
>
> #!/bin/bash
>
> SCRATCH_MNT=/mnt
> LOAD_FACTOR=1
> TIME_FACTOR=1
>
> mkfs.xfs -f /dev/sda
> mount /dev/sda $SCRATCH_MNT
>
> mkdir $SCRATCH_MNT/lowerdir
> mkdir $SCRATCH_MNT/lowerdir1
> mkdir $SCRATCH_MNT/lowerdir/etc
> mkdir $SCRATCH_MNT/workers
> echo salts > $SCRATCH_MNT/lowerdir/etc/access.conf
> touch $SCRATCH_MNT/running
>
> stop_workers() {
>         test -e $SCRATCH_MNT/running || return
>         rm -f $SCRATCH_MNT/running
>
>         while [ "$(ls $SCRATCH_MNT/workers/ | wc -l)" -gt 0 ]; do
>                 wait
>         done
> }
>
> worker() {
>         local tag="$1"
>         local mergedir="$SCRATCH_MNT/merged$tag"
>         local l="lowerdir=$SCRATCH_MNT/lowerdir:$SCRATCH_MNT/lowerdir1"
>         local u="upperdir=$SCRATCH_MNT/upperdir$tag"
>         local w="workdir=$SCRATCH_MNT/workdir$tag"
>         local i="index=off"
>
>         touch $SCRATCH_MNT/workers/$tag
>         while test -e $SCRATCH_MNT/running; do
>                 rm -rf $SCRATCH_MNT/merged$tag
>                 rm -rf $SCRATCH_MNT/upperdir$tag
>                 rm -rf $SCRATCH_MNT/workdir$tag
>                 mkdir $SCRATCH_MNT/merged$tag
>                 mkdir $SCRATCH_MNT/workdir$tag
>                 mkdir $SCRATCH_MNT/upperdir$tag
>
>                 mount -t overlay overlay -o "$l,$u,$w,$i" $mergedir
>                 mv $mergedir/etc/access.conf $mergedir/etc/access.conf.bak
>                 touch $mergedir/etc/access.conf
>                 mv $mergedir/etc/access.conf $mergedir/etc/access.conf.bak
>                 touch $mergedir/etc/access.conf
>                 umount $mergedir
>         done
>         rm -f $SCRATCH_MNT/workers/$tag
> }
>
> for i in $(seq 0 $((4 + LOAD_FACTOR)) ); do
>         worker $i &
> done
>
> sleep $((30 * TIME_FACTOR))
> stop_workers
>
> ...and I think this is enough to diagnose the deadlock.
>
> This is an ABBA deadlock caused by locking the AGI buffers in the wrong
> order.  Specifically, we seem to be calling xfs_dir_rename with a
> non-null @wip and a non-null @target_ip.  In the deadlock scenario, @wip
> is an inode in AG 2, and @target_ip is an inode in AG 0 with nlink==1.
>
> First we call xfs_iunlink_remove to remove @wip from the unlinked list,
> which causes us to lock AGI 2.  Next we replace the directory entry.
> Finally, we need to droplink @target_ip.  Since @target_ip has nlink==1,
> xfs_droplink will need to put it on AGI 0's unlinked list.
>
> Unfortunately, the locking rules say that you can only lock AGIs in
> increasing order.  This means that we cannot lock AGI 0 after locking
> AGI 2 without risking deadlock.
>
> Does the attached patch fix the deadlock for you?
>
> --D
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
> Subject: [PATCH] xfs: fix an ABBA deadlock in xfs_rename
>
> When overlayfs is running on top of xfs and the user unlinks a file in
> the overlay, overlayfs will create a whiteout inode and ask xfs to
> "rename" the whiteout file atop the one being unlinked.  If the file
> being unlinked loses its one nlink, we then have to put the inode on the
> unlinked list.
>
> This requires us to grab the AGI buffer of the whiteout inode to take it
> off the unlinked list (which is where whiteouts are created) and to grab
> the AGI buffer of the file being deleted.  If the whiteout was created
> in a higher numbered AG than the file being deleted, we'll lock the AGIs
> in the wrong order and deadlock.
>
> Therefore, grab all the AGI locks we think we'll need ahead of time, and
> in the correct order.
>
> Reported-by: wenli xie <wlxie7296@gmail.com>
> Fixes: 93597ae8dac0 ("xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_inode.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
>
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index b7352bc4c815..dd419a1bc6ba 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3000,6 +3000,48 @@ xfs_rename_alloc_whiteout(
>         return 0;
>  }
>
> +/*
> + * For the general case of renaming files, lock all the AGI buffers we need to
> + * handle bumping the nlink of the whiteout inode off the unlinked list and to
> + * handle dropping the nlink of the target inode.  We have to do this in
> + * increasing AG order to avoid deadlocks.
> + */
> +static int
> +xfs_rename_lock_agis(
> +       struct xfs_trans        *tp,
> +       struct xfs_inode        *wip,
> +       struct xfs_inode        *target_ip)
> +{
> +       struct xfs_mount        *mp = tp->t_mountp;
> +       struct xfs_buf          *bp;
> +       xfs_agnumber_t          agi_locks[2] = { NULLAGNUMBER, NULLAGNUMBER };
> +       int                     error;
> +
> +       if (wip)
> +               agi_locks[0] = XFS_INO_TO_AGNO(mp, wip->i_ino);
> +
> +       if (target_ip && VFS_I(target_ip)->i_nlink == 1)
> +               agi_locks[1] = XFS_INO_TO_AGNO(mp, target_ip->i_ino);
> +
> +       if (agi_locks[0] != NULLAGNUMBER && agi_locks[1] != NULLAGNUMBER &&
> +           agi_locks[0] > agi_locks[1])
> +               swap(agi_locks[0], agi_locks[1]);
> +
> +       if (agi_locks[0] != NULLAGNUMBER) {
> +               error = xfs_read_agi(mp, tp, agi_locks[0], &bp);
> +               if (error)
> +                       return error;
> +       }
> +
> +       if (agi_locks[1] != NULLAGNUMBER) {
> +               error = xfs_read_agi(mp, tp, agi_locks[1], &bp);
> +               if (error)
> +                       return error;
> +       }
> +
> +       return 0;
> +}
> +
>  /*
>   * xfs_rename
>   */
> @@ -3130,6 +3172,10 @@ xfs_rename(
>                 }
>         }
>
> +       error = xfs_rename_lock_agis(tp, wip, target_ip);
> +       if (error)
> +               return error;
> +
>         /*
>          * Directory entry creation below may acquire the AGF. Remove
>          * the whiteout from the unlinked list first to preserve correct
