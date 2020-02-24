Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D300C35679
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 06:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D70F20661
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 06:50:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K6GXURzI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgBXGu3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 01:50:29 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:41219 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgBXGu3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 01:50:29 -0500
Received: by mail-il1-f193.google.com with SMTP id f10so6800907ils.8
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 22:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MnoVVJlD7A0Q1uJbVEXWaTmL5r3zfigx/XhxIzAdalk=;
        b=K6GXURzIPSuuvNUfLBIqd0xopLigpKrDW4dlD/+M9109+EY78/CuNoB8dL/FKOHpGs
         PUhFOeH6Epb2pbWa3V4R4FWn1b+iFEet9MXWr7eZqDCdzK8RAc2McbFKjTYOCqbzwJIS
         7geeDXcN+S9HbJteTtByFyr59ggzedqKEmRvsVDNkDGIEWiAzP9mIOVSzN1r/s0u5aHX
         HPCK/CWrDEpnTFcbVRFQC4t2blUFHBo4xyVY7Q3v64WgNAKNTigRMyA2ljFy8oExLm//
         VKerDQsqXAKUocLu33Q/s25n8z71hnjTkT3ybAEZWHPUe9dujbgUYIxktBppato/nlsN
         P15w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MnoVVJlD7A0Q1uJbVEXWaTmL5r3zfigx/XhxIzAdalk=;
        b=WkjTzSbsH0MPWcbBm4Lz9knKUUU/05qyOBKOmESWQck1lCiWbamRB1jdQVWvadAm6I
         UOgydwzPLBZyquU4SFG7cLorknHPs0sQpb6grPd+LxYQNuGQB80H9qEMjuNX4+sF4JXZ
         +gdSDvs6hS+f11JHT7NmZY2AAeI/AJEJ54P+f9lBhYmm85Lf7sJNoMg9ElaaB8gZxylQ
         JUpOWURMCGYzv3Juj0BtMBqe3lSrs/vWN952OQ+b+AgaeZ+vpZbpPXeZ1byAi01q1WZC
         uJ/Y51ygsjxab1nepSPVR2OZ2cboKM+TeM4F2YCGAnV2razvetaA2WuJJnyzRB6QGaYt
         zB+Q==
X-Gm-Message-State: APjAAAVemBDB8Usr9rQWPqKet0CByLJHNihON6aG0A63Stlrmk02cxDd
        ubZTF9hejCgfvTtX5ZtZ/8c77dl1IHvnknbkY/5428lV
X-Google-Smtp-Source: APXvYqxMuG4aFtbptQPydrOL8FUXFr0AtkKPZj2rmU5UmoocJzl+74NvG6Urj+NSKSFYLRIXipHVeqre7ovJDHaKCY4=
X-Received: by 2002:a92:8656:: with SMTP id g83mr59318115ild.9.1582527029102;
 Sun, 23 Feb 2020 22:50:29 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-3-allison.henderson@oracle.com> <CAOQ4uxjnByzxLUsF6GL7-fOeiNwQR46vgt5nSgfUNfB8jdfqMA@mail.gmail.com>
 <0726eb62-c308-3c04-8e3b-ff1f6c76844a@oracle.com>
In-Reply-To: <0726eb62-c308-3c04-8e3b-ff1f6c76844a@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 24 Feb 2020 08:50:18 +0200
Message-ID: <CAOQ4uxiDcaApzkrdL9NVGSgM35K8tc-ny-rta7tYJiQPiL_Dzg@mail.gmail.com>
Subject: Re: [PATCH v7 02/19] xfs: Embed struct xfs_name in xfs_da_args
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 23, 2020 at 6:51 PM Allison Collins
<allison.henderson@oracle.com> wrote:
>
>
>
> On 2/23/20 4:54 AM, Amir Goldstein wrote:
> > On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
> > <allison.henderson@oracle.com> wrote:
> >>
> >> This patch embeds an xfs_name in xfs_da_args, replacing the name, namelen, and flags
> >> members.  This helps to clean up the xfs_da_args structure and make it more uniform
> >> with the new xfs_name parameter being passed around.
> >>
> >> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> >> Reviewed-by: Brian Foster <bfoster@redhat.com>
> >> ---
> >>   fs/xfs/libxfs/xfs_attr.c        |  37 +++++++-------
> >>   fs/xfs/libxfs/xfs_attr_leaf.c   | 104 +++++++++++++++++++++-------------------
> >>   fs/xfs/libxfs/xfs_attr_remote.c |   2 +-
> >>   fs/xfs/libxfs/xfs_da_btree.c    |   6 ++-
> >>   fs/xfs/libxfs/xfs_da_btree.h    |   4 +-
> >>   fs/xfs/libxfs/xfs_dir2.c        |  18 +++----
> >>   fs/xfs/libxfs/xfs_dir2_block.c  |   6 +--
> >>   fs/xfs/libxfs/xfs_dir2_leaf.c   |   6 +--
> >>   fs/xfs/libxfs/xfs_dir2_node.c   |   8 ++--
> >>   fs/xfs/libxfs/xfs_dir2_sf.c     |  30 ++++++------
> >>   fs/xfs/scrub/attr.c             |  12 ++---
> >>   fs/xfs/xfs_trace.h              |  20 ++++----
> >>   12 files changed, 130 insertions(+), 123 deletions(-)
> >>
> >> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> >> index 6717f47..9acdb23 100644
> >> --- a/fs/xfs/libxfs/xfs_attr.c
> >> +++ b/fs/xfs/libxfs/xfs_attr.c
> >> @@ -72,13 +72,12 @@ xfs_attr_args_init(
> >>          args->geo = dp->i_mount->m_attr_geo;
> >>          args->whichfork = XFS_ATTR_FORK;
> >>          args->dp = dp;
> >> -       args->flags = flags;
> >> -       args->name = name->name;
> >> -       args->namelen = name->len;
> >> -       if (args->namelen >= MAXNAMELEN)
> >> +       memcpy(&args->name, name, sizeof(struct xfs_name));
> >
> > Maybe xfs_name_copy and xfs_name_equal are in order?
> You are suggesting to add xfs_name_copy and xfs_name_equal helpers?  I'm
> not sure there's a use case yet for xfs_name_equal, at least not in this
> set.  And I think people indicated that they preferred the memcpy in
> past reviews rather than handling each member of the xfs_name struct.
> Unless I misunderstood the question, I'm not sure there is much left for
> a xfs_name_copy helper to cover that the memcpy does not?
>

It's fine. The choice between xfs_name_copy and memcpy is
mostly personal taste. I did not read through past reviews.

> >
> >>
> >> +       /* Use name now stored in args */
> >> +       name = &args.name;
> >> +
> >
> > It seem that the context of these comments be clear in the future.
> You are asking to add more context to the comment?  How about:
>         /*
>          * Use name now stored in args.  Abandon the local name
>          * parameter as it will not be updated in the subroutines
>          */
>
> Does that help some?

Can't you just not use local name arg anymore?
Instead of re-assigning it and explaining why you do that.
Does that gain anything to code readability or anything else?

Thanks,
Amir.
