Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA31C3567B
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 06:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8690E20714
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 06:58:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rekaQ9gz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgBXG6W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 01:58:22 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:46414 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgBXG6W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 01:58:22 -0500
Received: by mail-il1-f196.google.com with SMTP id t17so6805959ilm.13
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 22:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RmqoW5WkkEt2MNbURyzsV62opv5OaEO0GJdux478kVg=;
        b=rekaQ9gzKhX+v9PK0B0BFMRqQ+qjx+sC1cALf9BhFPnIET6c36bTxCGD9wv0syitPR
         xyEmiAydkv9kswbBk1m79AbtNTJBJ4jMDHGZObIWOAXgXnewsU5yTXGhACYtKvmFLOf1
         T8d/Lv/FTcwl/IMdeAdOIEfA1BLWhtM8D1gYFjO/v2zjBO1NMlWYgKzSikBHaRodP85m
         urQsoTEVjvrR8AaucunWbIlgJamBv4H204Z09ypqNKRc42h0wPd1NTKWWrRYIMwjN1VL
         kQMmiFeTlmx77zozCLdpPpGd8e2wmg6IL7zUnXDnlA/Re2jfp+C/N+GlnQ7IZ1QkiGcU
         eayQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RmqoW5WkkEt2MNbURyzsV62opv5OaEO0GJdux478kVg=;
        b=eH3Nx8p3MDGwL7enFvHp8mKOkcsIKua45WLrcOf6uzcsOxOnrH8J3QZXESA1AUJ/wq
         I0p5dSRtYBpk5EtZvGvyFTFuZDG1lKwYC/IgiAO8s4K2c7QR2yqbp5cAMgY4DPBC+C00
         V9A7P+6+B5KgOYadwm1Mv0y8QcSKBU/IpNmi0nAIBgWlstItspfZP3ggQRl+HpilzRjE
         DoLdiauQbfGrAwu3sisFzUcl6tO2fzJIYRQ15gJR2EPYADkrLYqJKzuhvqms26YhLxHK
         msRP/l1XryJxijo4TwnBwQzqNqsq0ddarm1bgFeslTH2zY6GTFlHS8E8JMlIqtlK9VYP
         TEAQ==
X-Gm-Message-State: APjAAAWBk+P7p3IUV917lkMWYZqPEFU3Nk9WRYnCe9hBXw83L/GI1c+b
        YHBihiuLsKaocWKbaQZ1+JdAmEEfVWqLpNtbuXi7Ug==
X-Google-Smtp-Source: APXvYqyN1ThkXgrcveY3Iz3nzaB/B83e6YQTmu+o3gKP9qtWphXnt5GJAFjbsvMO4BkUzw4oiqIhf/4FGX0qWnoH1iU=
X-Received: by 2002:a92:8656:: with SMTP id g83mr59361484ild.9.1582527500791;
 Sun, 23 Feb 2020 22:58:20 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-4-allison.henderson@oracle.com> <CAOQ4uxiUVy3OfFsqx_KyirE6pD0XvnzNEehn7Vv4cxXw8kTSjQ@mail.gmail.com>
 <2694f05a-3f13-2b13-547d-21b303d4e67f@oracle.com>
In-Reply-To: <2694f05a-3f13-2b13-547d-21b303d4e67f@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 24 Feb 2020 08:58:09 +0200
Message-ID: <CAOQ4uxhPLywxuC+3=1sSbWYdq4mLjOmtaU5FCTj_-t2kYPYpaw@mail.gmail.com>
Subject: Re: [PATCH v7 03/19] xfs: Add xfs_has_attr and subroutines
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 23, 2020 at 7:28 PM Allison Collins
<allison.henderson@oracle.com> wrote:
>
>
>
> On 2/23/20 5:20 AM, Amir Goldstein wrote:
> > On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
> > <allison.henderson@oracle.com> wrote:
> >>
> >> From: Allison Henderson <allison.henderson@oracle.com>
> >>
> >> This patch adds a new functions to check for the existence of an attribute.
> >> Subroutines are also added to handle the cases of leaf blocks, nodes or shortform.
> >> Common code that appears in existing attr add and remove functions have been
> >> factored out to help reduce the appearance of duplicated code.  We will need these
> >> routines later for delayed attributes since delayed operations cannot return error
> >> codes.
> >>
> >> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> >> ---
> >>   fs/xfs/libxfs/xfs_attr.c      | 171 ++++++++++++++++++++++++++++--------------
> >>   fs/xfs/libxfs/xfs_attr.h      |   1 +
> >>   fs/xfs/libxfs/xfs_attr_leaf.c | 111 +++++++++++++++++----------
> >>   fs/xfs/libxfs/xfs_attr_leaf.h |   3 +
> >>   4 files changed, 188 insertions(+), 98 deletions(-)
> >>
> >> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> >> index 9acdb23..2255060 100644
> >> --- a/fs/xfs/libxfs/xfs_attr.c
> >> +++ b/fs/xfs/libxfs/xfs_attr.c
> >> @@ -46,6 +46,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
> >>   STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
> >>   STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
> >>   STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> >> +STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
> >>
> >>   /*
> >>    * Internal routines when attribute list is more than one block.
> >> @@ -53,6 +54,8 @@ STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> >>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> >>   STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> >>   STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> >> +STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> >> +                                struct xfs_da_state **state);
> >>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> >>   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> >>
> >> @@ -310,6 +313,37 @@ xfs_attr_set_args(
> >>   }
> >>
> >>   /*
> >> + * Return EEXIST if attr is found, or ENOATTR if not
> >
> > This is a very silly return value for a function named has_attr in my taste.
> > I realize you inherited this interface from xfs_attr3_leaf_lookup_int(), but
> > IMO this change looks like a very good opportunity to change that internal
> > API:
> >
> > xfs_has_attr?
> >
> > 0: NO
> > 1: YES (or stay with the syscall standard of -ENOATTR)
> > <0: error
> Darrick had mentioned something like that in the last revision, but I
> think people wanted to keep everything a straight hoist at this phase.
> At least as much as possible.  Maybe I can add another patch that does
> this at the end when we're doing clean ups.

In my opinion, this change is hard enough to follow as is.
Making the interface cleaner at this point is not going to make
following the change any harder if anything I thing a clean interface
that makes sense, will make things easier at this point.
But whether you do it now or later, the interface was very bad IMO before
and when attached to a helper named has_attr makes it much worse.

Thanks,
Amir.
