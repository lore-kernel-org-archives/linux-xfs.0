Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:35533 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751464AbdHHHvL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Aug 2017 03:51:11 -0400
Received: by mail-ua0-f174.google.com with SMTP id d29so11374885uai.2
        for <linux-xfs@vger.kernel.org>; Tue, 08 Aug 2017 00:51:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170807181034.GM24087@magnolia>
References: <8948A7010F7A4A758A580103D54CE381@alyakaslap> <20170807151651.GA43920@bfoster.bfoster>
 <20170807163744.GL24087@magnolia> <20170807172605.GA49072@bfoster.bfoster> <20170807181034.GM24087@magnolia>
From: Alex Lyakas <alex@zadarastorage.com>
Date: Tue, 8 Aug 2017 10:51:10 +0300
Message-ID: <CAOcd+r0GEy4CAffRzgr+ydfkM5BEiNxidzWi8693t83CM2oKQQ@mail.gmail.com>
Subject: Re: [RFC - PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of the first attribute
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Shyam Kaushik <shyam@zadarastorage.com>, Yair Hershko <yair@zadarastorage.com>

Hi Darrick,

[...]

> I'm confused and going to step through through this code one piece at a time.
>
>         /*
>          * It won't fit in the shortform, transform to a leaf block.
>          * GROT: another possible req'mt for a double-split btree op.
>          */
>         xfs_defer_init(args.dfops, args.firstblock);
>         error = xfs_attr_shortform_to_leaf(&args, &leaf_bp);
>
>         /* hold the leaf buffer locked, when "args.trans" transaction commits */
>         if (leaf_bp)
>                 xfs_trans_bhold(args.trans, leaf_bp);
>
> If we hit an error in xfs_attr_shortform_to_leaf leaf_bp will have been
> bjoined to args.trans by xfs_attr_shortform_to_leaf ->
> xfs_attr3_leaf_create -> xfs_da_get_buf -> xfs_trans_get_buf_map, so
> when we goto out in the error handling clause below, we'll trans_cancel,
> which releases leaf_bp, right?  And we can't just xfs_buf_relse because
> that would unlock a buffer that's still owned by args.trans (like Brian
> said)...
If xfs_attr_shortform_to_leaf() hits an error, it will not set the
caller's leaf_bp pointer. So this pointer will remain NULL, and
therefore all the error handing logic at the caller will not touch
this xfs_buf. I believe this addresses your concern.

Thanks,
Alex.
