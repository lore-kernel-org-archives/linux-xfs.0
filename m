Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33770 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933303AbeCSVhn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Mar 2018 17:37:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAM_iQpU9A+KpSdXceUuz-cUX+f91bttKwJCOE91LnTZmKofk_Q@mail.gmail.com>
References: <CAM_iQpU9A+KpSdXceUuz-cUX+f91bttKwJCOE91LnTZmKofk_Q@mail.gmail.com>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Mon, 19 Mar 2018 14:37:22 -0700
Message-ID: <CAM_iQpVBmhiN05ZpxEZ2cNLSJpczc7z=Sz7a1tnUGeQimtDTYA@mail.gmail.com>
Subject: Re: xfs: list corruption in xfs_setup_inode()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <dchinner@redhat.com>, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>

On Mon, Oct 30, 2017 at 2:55 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> Hello,
>
> We triggered a list corruption (double add) warning below on our 4.9
> kernel (the 4.9 kernel we use is based on -stable release, with only a
> few unrelated networking backports):

We still keep getting this warning on 4.9 kernel. Looking into this again,
it seems xfs_setup_inode() could be called twice if an XFS inode is gotten
from disk? Once in xfs_iget() => xfs_setup_existing_inode(), and once
in xfs_ialloc().

Does the following patch (compile-only) make any sense? Again, I don't
want to pretend to understand XFS...


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 604ee384a00a..6761b1f8fa2f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -775,6 +775,7 @@ xfs_ialloc(
        int             error;
        struct timespec tv;
        struct inode    *inode;
+       bool            had_imode;

        /*
         * Call the space management code to pick
@@ -801,6 +802,7 @@ xfs_ialloc(
                return error;
        ASSERT(ip != NULL);
        inode = VFS_I(ip);
+       had_imode = !!inode->i_mode;

        /*
         * We always convert v1 inodes to v2 now - we only support filesystems
@@ -946,7 +948,8 @@ xfs_ialloc(
        xfs_trans_log_inode(tp, ip, flags);

        /* now that we have an i_mode we can setup the inode structure */
-       xfs_setup_inode(ip);
+       if (!had_imode)
+               xfs_setup_inode(ip);

        *ipp = ip;
        return 0;
