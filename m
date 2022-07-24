Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E6D7C43334
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jul 2022 12:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiGXMOS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Jul 2022 08:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGXMOS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jul 2022 08:14:18 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE7865AF
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jul 2022 05:14:17 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id k25-20020a056830169900b0061c6f68f451so6684394otr.9
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jul 2022 05:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1NufmrS5kIAYqYZGXtNTdeY1J+c6UeCWVjfbEiwljyc=;
        b=X1k8mbjnOssw/GbJ+nyekvTiBtbKHlmSRWogiFXYhNZzv9vb7oUD5mc0mvP9C+hGwz
         Q3cMcV2+mopUaZVlA9ybn1Qr93ZGKztlJjj4rgVupdrH/owA/XAMy4OSy1uBT2rAV3zX
         U2UKp1N0CiiloWF0WA4GuDdITjKuEO50KB62iJgkPPviGn0fy9N7arKvqOEYEOlOQYkd
         Jcm/ck6UNi+BdNzCZpZ6nFuouGcRwlAXyOAwCrXiZR97UZ+HUtdsnE95wZj/JAMlbizC
         lYZAFqGPO+aU1QwJf034Q/hmJQsxQd85juUdf6+naKAu8s8lPkz30CHBTNsOI7lMefa8
         zMRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1NufmrS5kIAYqYZGXtNTdeY1J+c6UeCWVjfbEiwljyc=;
        b=d3c4cyA1O5JfWv6q17979Vj2HFLix3I96wIhJlQHUb28L8odJX9XZkAj/ZqHYSmb3b
         +5BpI0aivZhJzGA7kDkpEg17cJOBsGhMKmbs0B9t3EeGrAShLJV9bp36rZzeoOU9MaQR
         VSqOzrafQ2jqAxuyAK7o7kUayeJjRarmPYQMvEJWad9kPOlqgULuditUUNicO2rRhoNN
         tl3d7Ogu7Z6JkapjwkUpc9cJwPiWkslK+Rt0ZyYV0W76IgPMucHl2Iqvmb+TLBRO7kPr
         gVRFIYbmFGrVXrtygj/uelJudRKHM2ePrwQbKjBGj614LyZGfBSjW90/Ek1kUj5rrb1g
         xdNA==
X-Gm-Message-State: AJIora/iR39KCnJQORnNO0blGL4d72r0E07wgPL2s9WzumhJG0diKtk4
        nbm99XRNIuyo1oB778ozc/Io59cg3VH16Wo2/sEpl2GGJPCFEW8N
X-Google-Smtp-Source: AGRyM1uf818MIt3GMNLRBOsvxfP0XUfU9OdpMFPswyR1o0J8GpO6r6GXir5nxYlWOKnrW5LtD0s7uSE6HRscPmqK698=
X-Received: by 2002:a9d:686:0:b0:61c:8be0:a26a with SMTP id
 6-20020a9d0686000000b0061c8be0a26amr3104780otx.127.1658664856420; Sun, 24 Jul
 2022 05:14:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200510072404.986627-1-hch@lst.de> <20200510072404.986627-4-hch@lst.de>
 <20200516180736.GE6714@magnolia>
In-Reply-To: <20200516180736.GE6714@magnolia>
From:   Alex Lyakas <alex.lyakas@zadara.com>
Date:   Sun, 24 Jul 2022 15:14:04 +0300
Message-ID: <CAOcd+r2cPb3BYKpiSObX5o5hRGvZ=qqWa8jRjh_=z+dY7CLq5Q@mail.gmail.com>
Subject: Re: [PATCH 3/6] xfs: remove xfs_ifree_local_data
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Christoph,

On Sat, May 16, 2020 at 9:07 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Sun, May 10, 2020 at 09:24:01AM +0200, Christoph Hellwig wrote:
> > xfs_ifree only need to free inline data in the data fork, as we've
> > already taken care of the attr fork before (and in fact freed the
> > fork structure).  Just open code the freeing of the inline data.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Looks ok,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>
> --D
>
> > ---
> >  fs/xfs/xfs_inode.c | 30 ++++++++++--------------------
> >  1 file changed, 10 insertions(+), 20 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 549ff468b7b60..7d3144dc99b72 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -2711,24 +2711,6 @@ xfs_ifree_cluster(
> >       return 0;
> >  }
> >
> > -/*
> > - * Free any local-format buffers sitting around before we reset to
> > - * extents format.
> > - */
> > -static inline void
> > -xfs_ifree_local_data(
> > -     struct xfs_inode        *ip,
> > -     int                     whichfork)
> > -{
> > -     struct xfs_ifork        *ifp;
> > -
> > -     if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
> > -             return;
> > -
> > -     ifp = XFS_IFORK_PTR(ip, whichfork);
> > -     xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
> > -}
> > -
> >  /*
> >   * This is called to return an inode to the inode free list.
> >   * The inode should already be truncated to 0 length and have
> > @@ -2765,8 +2747,16 @@ xfs_ifree(
> >       if (error)
> >               return error;
> >
> > -     xfs_ifree_local_data(ip, XFS_DATA_FORK);
> > -     xfs_ifree_local_data(ip, XFS_ATTR_FORK);
> > +     /*
> > +      * Free any local-format data sitting around before we reset the
> > +      * data fork to extents format.  Note that the attr fork data has
> > +      * already been freed by xfs_attr_inactive.
> > +      */
> > +     if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
> > +             kmem_free(ip->i_df.if_u1.if_data);
> > +             ip->i_df.if_u1.if_data = NULL;
> > +             ip->i_df.if_bytes = 0;
> > +     }
> >
> >       VFS_I(ip)->i_mode = 0;          /* mark incore inode as free */
> >       ip->i_d.di_flags = 0;
> > --
> > 2.26.2
> >


I stumbled upon this patch, by analyzing a kernel panic we had [1].
Looking at the call trace, the panic happened in
xfs_ifree_local_data() being called with XFS_ATTR_FORK.
It looks like
ifp = XFS_IFORK_PTR(ip, whichfork);
returned NULL.

Based on your patch, do I understand correctly that it fixes the panic?

What happened seems to be that inode had an attribute fork and
xfs_attr_fork_remove() was called on it. This function set:
ip->i_afp = NULL
ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS.

As a result, xfs_ifree_local_data() [2] checked XFS_IFORK_FORMAT() and
got XFS_DINODE_FMT_EXTENTS. So it performed:
    ifp = XFS_IFORK_PTR(ip, whichfork);
    xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
which caused NULL pointer exception.

Is this analysis correct, that any time we have an inode with an
attribute fork, we will crash deleting it?

Thanks,
Alex.



[1]
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: xfs_ifree+0x12c/0x150 [xfs]
PGD 800000066eea0067 P4D 800000066eea0067 PUD 3066ce067 PMD 0
Oops: 0000 [#1] PREEMPT SMP PTI
Modules linked in: binfmt_misc xt_nat xfs(OE) sd_mod sg bonding xt_CHECKSUM i
 libiscsi_tcp(OE) sunrpc libiscsi(OE) scsi_transport_iscsi(OE) i6300esb ip_ta
CPU: 3 PID: 19176 Comm: swift-object-re Tainted: G        W  OE   4.14.99-zad
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 0
task: ffffa009b0d45640 task.stack: ffffb0a85dddc000
RIP: 0010:xfs_ifree+0x12c/0x150 [xfs]
RSP: 0018:ffffb0a85dddfdb8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffa00999610f00 RCX: 000000168215a803
RDX: 0000000000000000 RSI: ffffd0a83f9b3ed0 RDI: ffffa00999610f00
RBP: ffffa00edbe1af30 R08: 00003091b4833ed0 R09: ffffffffc0a39de4
R10: 0000000000000000 R11: 0000000000000040 R12: ffffb0a85dddfe10
R13: ffffb0a85dddfe08 R14: ffffa00d7f147780 R15: 0000000000000000
FS:  00007f012ffff700(0000) GS:ffffa0168b180000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000749f26006 CR4: 00000000003606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 xfs_inactive_ifree+0xbb/0x220 [xfs]
 xfs_inactive+0x74/0x100 [xfs]
 xfs_fs_destroy_inode+0xb4/0x240 [xfs]
 do_unlinkat+0x1b3/0x310
 do_syscall_64+0x6e/0x120
 entry_SYSCALL_64_after_hwframe+0x3d/0xa2


[2]
static inline void
xfs_ifree_local_data(
    struct xfs_inode    *ip,
    int            whichfork)
{
    struct xfs_ifork    *ifp;

    if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
        return;

    ifp = XFS_IFORK_PTR(ip, whichfork);
    xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
}
