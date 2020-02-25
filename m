Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54875C35DF2
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 06:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EE8021556
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 06:44:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ps2d2Q07"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbgBYGoF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 01:44:05 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:39895 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729025AbgBYGoF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 01:44:05 -0500
Received: by mail-io1-f66.google.com with SMTP id c16so13017602ioh.6
        for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2020 22:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KVD3rJAbi8Rc8eYIsCwIQM/t84HexF4l3sGHMIyf7aw=;
        b=ps2d2Q07rhk+3PRcIHx1MOrqDrgleEjdQSFUqUL7lkqoa9iXsWuE9g3+UFaMHRPyTB
         oK2taw33IWjtXQE95LQKEvGmo19KlTtVlBx8kU8g6rDiBDQ0mYH8InW4lLnmgVkfV7zf
         iYGrqSNGqrFTLJheUDtqzBFVSFXmgwoajx4kK1jPLjljnLz9Znke+hZemNrMhvlyQ8zO
         0/NVDAn3KJ/zQRUD0gc7AIlmrmEE8QYpnssK+jiQTSS2c5x8SYVp55MJ2DxXbEbpPs/0
         uC3jk1uEq/COJ4RHBbkj/gCz0N+zWSgjIkz2LcA8zH2leumrCKVMktTIUrdcsGkNT6bO
         qdqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KVD3rJAbi8Rc8eYIsCwIQM/t84HexF4l3sGHMIyf7aw=;
        b=Y/2O5DKUjykArrRfW+DFjXW/04Z23I5tT1qgTBGDfppwOwTS4xEdzljrbYUAYbt9xh
         gb4YIoi57Icv6cx3TIBMy9w/AJfZyKmM0Dc1uUJVaJTsHEXrwsqkD1e9UrKwJhpalwbI
         1krT7q7B/s+3hIPGNQDhifhABIfK2LGp7dJqkscfYr73EWfp9a0WGThuzoKGrWnnxvW/
         6RMyC2hipQw9yI/ImTBxAfEzMb+5iqiBh+ODxWiZ7qToC27ZKgs27GnXbHTQtrVNJBoI
         UJ9gedeNak6PsxuWrm8gexUr0ivBx6tjttBURgcsQRQnYDfMzoiqkIxiZgFuuZQpnPjt
         bz6g==
X-Gm-Message-State: APjAAAWOvy8rbsewUsx8XDChZVslFLEbjGU/T/MLQ5qWv/dx+PBDcdzq
        njAzXeEcr5okjq26Lq+/PnmraDaNRSRzjOXWFh9Hpw==
X-Google-Smtp-Source: APXvYqzzPFylDaCe564zpPBc23r7BWBli+gJqXGhhRG3hfflm+KwhBlCvhyPjSc6+aVJXuqHlahsYDggIFI1Vj56pHc=
X-Received: by 2002:a5e:a616:: with SMTP id q22mr53367972ioi.250.1582613044557;
 Mon, 24 Feb 2020 22:44:04 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-4-allison.henderson@oracle.com> <CAOQ4uxiUVy3OfFsqx_KyirE6pD0XvnzNEehn7Vv4cxXw8kTSjQ@mail.gmail.com>
 <20200225062612.GE10776@dread.disaster.area>
In-Reply-To: <20200225062612.GE10776@dread.disaster.area>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 25 Feb 2020 08:43:53 +0200
Message-ID: <CAOQ4uxh2K3Tee+KWtv+bU7xHHjRjrjw0BxmL5RuWc2uv2FVpHw@mail.gmail.com>
Subject: Re: [PATCH v7 03/19] xfs: Add xfs_has_attr and subroutines
To:     Dave Chinner <david@fromorbit.com>
Cc:     Allison Collins <allison.henderson@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 8:26 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Sun, Feb 23, 2020 at 02:20:32PM +0200, Amir Goldstein wrote:
> > On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
> > <allison.henderson@oracle.com> wrote:
> > >
> > > From: Allison Henderson <allison.henderson@oracle.com>
> > >
> > > This patch adds a new functions to check for the existence of an attribute.
> > > Subroutines are also added to handle the cases of leaf blocks, nodes or shortform.
> > > Common code that appears in existing attr add and remove functions have been
> > > factored out to help reduce the appearance of duplicated code.  We will need these
> > > routines later for delayed attributes since delayed operations cannot return error
> > > codes.
> > >
> > > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_attr.c      | 171 ++++++++++++++++++++++++++++--------------
> > >  fs/xfs/libxfs/xfs_attr.h      |   1 +
> > >  fs/xfs/libxfs/xfs_attr_leaf.c | 111 +++++++++++++++++----------
> > >  fs/xfs/libxfs/xfs_attr_leaf.h |   3 +
> > >  4 files changed, 188 insertions(+), 98 deletions(-)
> > >
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index 9acdb23..2255060 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > @@ -46,6 +46,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
> > >  STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
> > >  STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
> > >  STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> > > +STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
> > >
> > >  /*
> > >   * Internal routines when attribute list is more than one block.
> > > @@ -53,6 +54,8 @@ STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> > >  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> > >  STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> > >  STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> > > +STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> > > +                                struct xfs_da_state **state);
> > >  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> > >  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> > >
> > > @@ -310,6 +313,37 @@ xfs_attr_set_args(
> > >  }
> > >
> > >  /*
> > > + * Return EEXIST if attr is found, or ENOATTR if not
> >
> > This is a very silly return value for a function named has_attr in my taste.
> > I realize you inherited this interface from xfs_attr3_leaf_lookup_int(), but
> > IMO this change looks like a very good opportunity to change that internal
> > API:
>
> tl;dr Cleaning up this API is work for another patchset.
>
> >
> > xfs_has_attr?
> >
> > 0: NO
> > 1: YES (or stay with the syscall standard of -ENOATTR)
> > <0: error
>
> While I agree with your sentiment, Amir, the API you suggest is an
> anti-pattern. We've been removing ternary return value APIs like
> this from XFS and replacing them with an explicit error return value
> and an operational return parameter like so:
>
>         error = xfs_has_attr(&exists)
>         if (error)
>                 return error;
>

That would be neat and tidy.

One of the outcomes of new reviewers is comments on code unrelated
to the changes... I have no problem of keeping API as is for Allison's
change, but I did want to point out that the API became worse to read
due to the helper name change from _lookup_attr to _has_attr, which
really asks for a yes or no answer.

Thanks,
Amir.
