Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 529A8C3567B
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 07:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19E9320675
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 07:43:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vhZeu5N+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgBXHn1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 02:43:27 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:42179 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgBXHn1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 02:43:27 -0500
Received: by mail-io1-f65.google.com with SMTP id z1so9240016iom.9
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 23:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dvbqy/d6mU8oSxpt6pyvV0c5/z1fgcSmXHOD4zZulFk=;
        b=vhZeu5N+6A5rlvRiDvbOth+R9DyOLYsTXywMSqr8+CJ+gcjdyc19z9RoZrAWl/6RaH
         63NsiX01CVE1K7wEHn8jthtb/X3s8ib7R2mQLpOrs42eYqEQA6o+MadMQEUTUPGRSG2D
         O3mRSZyN+y2i2O6RdOJPHCa7xfLp16+lmA9w4K6OBj/4j6s5lYG2RhJxRTbUkhL5WAke
         7fkC2GkZRv4cQG2NQXLgJdHdtHYs3wJX39hUMrNHGcDGJFFnwrK7iWZLcVYjZTzQv8K8
         fNC+00KN3ug+t/7jaxoCBwb03/56ThVu74aW+GvGxeGnH/Ols+pr+84KXQGD1RDrbLej
         rj1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dvbqy/d6mU8oSxpt6pyvV0c5/z1fgcSmXHOD4zZulFk=;
        b=n8nhXQi6bcAQ1bHquV0YpIwBB90mKFoqrsCsj2GS+giZybfBVy3c+dVlgQKwTCoLiZ
         lFPfiicX1IpolY76AptjyiTT57dYwdtVtB+jNHEKGqfBG+h2XbBCLaD5KtH/1QaoJa3+
         AkM/8+Z9e4hzldnTs0MOHGWNZhM48fdRJlWcyxIhpNh1wQQchMECQxMNuM8wA1oQ2akQ
         Evx7TsE9gmES+CMzRsDP0Afr0NeihhIxXQ+vxnYXEKuquGRNJVVXLD1dOc5oUulX3GGw
         71EOHI5JbNmgo9ST8YNg7oO/roBJauycz9Xg1KWo1a4PVrfapAGVxBUBSNQ4Lb2De1uA
         M9Hg==
X-Gm-Message-State: APjAAAXsG6NPBRhewOxUBLsaefayLuLsVPLIIw9EggNYuao9MyRRiRpl
        RvNClU/4+7saV755pQlq++eKLMXlj19h69CXkVv8pg==
X-Google-Smtp-Source: APXvYqxX4ZyvvR0cgYz1NI4RL726YhYS+23Sgs9H7JLHnRO9YIDV0jsjNIlcM5gTtXGLfXM2Nvtyv3cSVnvlVKMxU18=
X-Received: by 2002:a02:c558:: with SMTP id g24mr49372565jaj.81.1582530206362;
 Sun, 23 Feb 2020 23:43:26 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-3-allison.henderson@oracle.com> <CAOQ4uxjnByzxLUsF6GL7-fOeiNwQR46vgt5nSgfUNfB8jdfqMA@mail.gmail.com>
 <0726eb62-c308-3c04-8e3b-ff1f6c76844a@oracle.com> <CAOQ4uxiDcaApzkrdL9NVGSgM35K8tc-ny-rta7tYJiQPiL_Dzg@mail.gmail.com>
 <1bc9a981-8694-ebce-8243-8d79d7c3ba7f@oracle.com>
In-Reply-To: <1bc9a981-8694-ebce-8243-8d79d7c3ba7f@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 24 Feb 2020 09:43:15 +0200
Message-ID: <CAOQ4uxj+3UeFPDRSnpD1tMfzCXMgsNzFUSONF9K3-_4uePetWg@mail.gmail.com>
Subject: Re: [PATCH v7 02/19] xfs: Embed struct xfs_name in xfs_da_args
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 9:37 AM Allison Collins
<allison.henderson@oracle.com> wrote:
>
>
>
> On 2/23/20 11:50 PM, Amir Goldstein wrote:
> > On Sun, Feb 23, 2020 at 6:51 PM Allison Collins
> > <allison.henderson@oracle.com> wrote:
> >>
> >>
> >>
> >> On 2/23/20 4:54 AM, Amir Goldstein wrote:
> >>> On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
> >>> <allison.henderson@oracle.com> wrote:
> >>>>
> >>>> This patch embeds an xfs_name in xfs_da_args, replacing the name, namelen, and flags
> >>>> members.  This helps to clean up the xfs_da_args structure and make it more uniform
> >>>> with the new xfs_name parameter being passed around.
> >>>>
> >>>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> >>>> Reviewed-by: Brian Foster <bfoster@redhat.com>
> >>>> ---
> >>>>    fs/xfs/libxfs/xfs_attr.c        |  37 +++++++-------
> >>>>    fs/xfs/libxfs/xfs_attr_leaf.c   | 104 +++++++++++++++++++++-------------------
> >>>>    fs/xfs/libxfs/xfs_attr_remote.c |   2 +-
> >>>>    fs/xfs/libxfs/xfs_da_btree.c    |   6 ++-
> >>>>    fs/xfs/libxfs/xfs_da_btree.h    |   4 +-
> >>>>    fs/xfs/libxfs/xfs_dir2.c        |  18 +++----
> >>>>    fs/xfs/libxfs/xfs_dir2_block.c  |   6 +--
> >>>>    fs/xfs/libxfs/xfs_dir2_leaf.c   |   6 +--
> >>>>    fs/xfs/libxfs/xfs_dir2_node.c   |   8 ++--
> >>>>    fs/xfs/libxfs/xfs_dir2_sf.c     |  30 ++++++------
> >>>>    fs/xfs/scrub/attr.c             |  12 ++---
> >>>>    fs/xfs/xfs_trace.h              |  20 ++++----
> >>>>    12 files changed, 130 insertions(+), 123 deletions(-)
> >>>>
> >>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> >>>> index 6717f47..9acdb23 100644
> >>>> --- a/fs/xfs/libxfs/xfs_attr.c
> >>>> +++ b/fs/xfs/libxfs/xfs_attr.c
> >>>> @@ -72,13 +72,12 @@ xfs_attr_args_init(
> >>>>           args->geo = dp->i_mount->m_attr_geo;
> >>>>           args->whichfork = XFS_ATTR_FORK;
> >>>>           args->dp = dp;
> >>>> -       args->flags = flags;
> >>>> -       args->name = name->name;
> >>>> -       args->namelen = name->len;
> >>>> -       if (args->namelen >= MAXNAMELEN)
> >>>> +       memcpy(&args->name, name, sizeof(struct xfs_name));
> >>>
> >>> Maybe xfs_name_copy and xfs_name_equal are in order?
> >> You are suggesting to add xfs_name_copy and xfs_name_equal helpers?  I'm
> >> not sure there's a use case yet for xfs_name_equal, at least not in this
> >> set.  And I think people indicated that they preferred the memcpy in
> >> past reviews rather than handling each member of the xfs_name struct.
> >> Unless I misunderstood the question, I'm not sure there is much left for
> >> a xfs_name_copy helper to cover that the memcpy does not?
> >>
> >
> > It's fine. The choice between xfs_name_copy and memcpy is
> > mostly personal taste. I did not read through past reviews.
> >
> >>>
> >>>>
> >>>> +       /* Use name now stored in args */
> >>>> +       name = &args.name;
> >>>> +
> >>>
> >>> It seem that the context of these comments be clear in the future.
> >> You are asking to add more context to the comment?  How about:
> >>          /*
> >>           * Use name now stored in args.  Abandon the local name
> >>           * parameter as it will not be updated in the subroutines
> >>           */
> >>
> >> Does that help some?
> >
> > Can't you just not use local name arg anymore?
> > Instead of re-assigning it and explaining why you do that.
> > Does that gain anything to code readability or anything else?
> Well, with out the set, you cannot use for example name->type anymore,
> you need to use args->name->type.  In order to use the local name
> variable again, it needs to be updated.  I stumbled across this myself
> when working with it and thought it would be better to fix it right away
> rather than let others run across the same mistake.  It seems like a
> subtle and easy thing to overlook otherwise.
>
> I do think it's a bit of a wart that people may not have thought about
> when we talked about adding this patch.  Though I don't know that it's a
> big enough deal to drop it either.  But I did feel some motivation to at
> least clean it up and make a comment about it.
>

Understood. I have no smart suggestion, so withdrawing my comment.

Thanks,
Amir.
