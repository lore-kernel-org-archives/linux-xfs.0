Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 120EFC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 18:46:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376649AbiFVSqo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 14:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiFVSqn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 14:46:43 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6212DD48;
        Wed, 22 Jun 2022 11:46:42 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id k25so10299494vso.6;
        Wed, 22 Jun 2022 11:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DxjtV0ep3tqLwI6SwBIfhjPyHt0fLp1wdFm4NWI+JOo=;
        b=O8DQSUYEabiFw0+mdsXYkeCduMtYnxlsEZ3SfAAd6apinPePSTKegDnUN5AOxpzRzz
         zba0TOi8n1LOj3uT83KaZ2Z9lzocooEx/yiB3fROcuiULxc7QwIPRJBl+YfRoJH9r9eF
         kuo4gqNCdahPb2UH2lTHysKaRlqAKhyABmweofLw2WdCAMbvT9wIlzsLCJFX1OuAFHzG
         RpUqtPXgOTdILMFXMmU67EjEvJvuKcEt/MGZIJD0zeQ/LoRmv83UdvLuK74ei+nLxhEJ
         35ILjjzJyjll9IqIe2rl8bhNZF5tMOaFobAB0yhdvWQGOJR0Yy2Ag0BDRr6omEtiHuzd
         zjTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DxjtV0ep3tqLwI6SwBIfhjPyHt0fLp1wdFm4NWI+JOo=;
        b=Ftc6uK6DM5lJ2Snj2oKvZIVnYH42Pe5Yoz6NLaoB9QdJ78+s2ALcvUMXosRf2K9A0e
         9euqjzXJ2UH2AKxORAdyOrnRVoDMeq77l8ThkP037yqf4s3o1QbNgVBowg2a0wjbnwVH
         wA2Xp4Q4wfnEQRkQjWcM+mknYwGZbFvdYgxrYDNWGttffargKqNe2WpDtsPFDn7tZlll
         6yx34mZ2wyCtqC4afajkUahEDTLlQszYLx7AASKlU1ccLt/Bt/j8RyD2XMHXjGpQAjpB
         HMthVdGpZ2CDqwvPQfCEiyvkhOt1IeybDtvROWZENqrT9WSwgnmyOJa+e1S0x+4fIumD
         b+ww==
X-Gm-Message-State: AJIora8LMjaT7kdVH6Uv0WVhxm2lQXKgS/Jqb28X9mZZwTpljG5/q5l2
        T1bzSBmEX3fEO4t4mrRKgg8Zw9IH3tB1BVNh544=
X-Google-Smtp-Source: AGRyM1ujEDNBquB1gIvuPQ21EbTMBmVtj8SbO+Z02UVlxszjIclEynXo6NELEEZzjANG4NuySDOcTISzM32L0rnpZM4=
X-Received: by 2002:a67:c113:0:b0:354:3ef9:3f79 with SMTP id
 d19-20020a67c113000000b003543ef93f79mr7254327vsj.3.1655923601347; Wed, 22 Jun
 2022 11:46:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220617100641.1653164-1-amir73il@gmail.com> <20220617100641.1653164-4-amir73il@gmail.com>
 <YrNECU28ujN2cabX@magnolia>
In-Reply-To: <YrNECU28ujN2cabX@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 22 Jun 2022 21:46:29 +0300
Message-ID: <CAOQ4uxjaErkbU2=Gmf5GPaiErKU0UVOmfX7gw4Dzhq3-c0aedQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 CANDIDATE 03/11] xfs: Fix the free logic of state in xfs_attr_node_hasname
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Yang Xu <xuyang2018.jy@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 22, 2022 at 7:32 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Fri, Jun 17, 2022 at 01:06:33PM +0300, Amir Goldstein wrote:
> > From: Yang Xu <xuyang2018.jy@fujitsu.com>
> >
> > commit a1de97fe296c52eafc6590a3506f4bbd44ecb19a upstream.
> >
> > When testing xfstests xfs/126 on lastest upstream kernel, it will hang on some machine.
> > Adding a getxattr operation after xattr corrupted, I can reproduce it 100%.
> >
> > The deadlock as below:
> > [983.923403] task:setfattr        state:D stack:    0 pid:17639 ppid: 14687 flags:0x00000080
> > [  983.923405] Call Trace:
> > [  983.923410]  __schedule+0x2c4/0x700
> > [  983.923412]  schedule+0x37/0xa0
> > [  983.923414]  schedule_timeout+0x274/0x300
> > [  983.923416]  __down+0x9b/0xf0
> > [  983.923451]  ? xfs_buf_find.isra.29+0x3c8/0x5f0 [xfs]
> > [  983.923453]  down+0x3b/0x50
> > [  983.923471]  xfs_buf_lock+0x33/0xf0 [xfs]
> > [  983.923490]  xfs_buf_find.isra.29+0x3c8/0x5f0 [xfs]
> > [  983.923508]  xfs_buf_get_map+0x4c/0x320 [xfs]
> > [  983.923525]  xfs_buf_read_map+0x53/0x310 [xfs]
> > [  983.923541]  ? xfs_da_read_buf+0xcf/0x120 [xfs]
> > [  983.923560]  xfs_trans_read_buf_map+0x1cf/0x360 [xfs]
> > [  983.923575]  ? xfs_da_read_buf+0xcf/0x120 [xfs]
> > [  983.923590]  xfs_da_read_buf+0xcf/0x120 [xfs]
> > [  983.923606]  xfs_da3_node_read+0x1f/0x40 [xfs]
> > [  983.923621]  xfs_da3_node_lookup_int+0x69/0x4a0 [xfs]
> > [  983.923624]  ? kmem_cache_alloc+0x12e/0x270
> > [  983.923637]  xfs_attr_node_hasname+0x6e/0xa0 [xfs]
> > [  983.923651]  xfs_has_attr+0x6e/0xd0 [xfs]
> > [  983.923664]  xfs_attr_set+0x273/0x320 [xfs]
> > [  983.923683]  xfs_xattr_set+0x87/0xd0 [xfs]
> > [  983.923686]  __vfs_removexattr+0x4d/0x60
> > [  983.923688]  __vfs_removexattr_locked+0xac/0x130
> > [  983.923689]  vfs_removexattr+0x4e/0xf0
> > [  983.923690]  removexattr+0x4d/0x80
> > [  983.923693]  ? __check_object_size+0xa8/0x16b
> > [  983.923695]  ? strncpy_from_user+0x47/0x1a0
> > [  983.923696]  ? getname_flags+0x6a/0x1e0
> > [  983.923697]  ? _cond_resched+0x15/0x30
> > [  983.923699]  ? __sb_start_write+0x1e/0x70
> > [  983.923700]  ? mnt_want_write+0x28/0x50
> > [  983.923701]  path_removexattr+0x9b/0xb0
> > [  983.923702]  __x64_sys_removexattr+0x17/0x20
> > [  983.923704]  do_syscall_64+0x5b/0x1a0
> > [  983.923705]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> > [  983.923707] RIP: 0033:0x7f080f10ee1b
> >
> > When getxattr calls xfs_attr_node_get function, xfs_da3_node_lookup_int fails with EFSCORRUPTED in
> > xfs_attr_node_hasname because we have use blocktrash to random it in xfs/126. So it
> > free state in internal and xfs_attr_node_get doesn't do xfs_buf_trans release job.
> >
> > Then subsequent removexattr will hang because of it.
> >
> > This bug was introduced by kernel commit 07120f1abdff ("xfs: Add xfs_has_attr and subroutines").
> > It adds xfs_attr_node_hasname helper and said caller will be responsible for freeing the state
> > in this case. But xfs_attr_node_hasname will free state itself instead of caller if
> > xfs_da3_node_lookup_int fails.
> >
> > Fix this bug by moving the step of free state into caller.
> >
> > [amir: this text from original commit is not relevant for 5.10 backport:
> > Also, use "goto error/out" instead of returning error directly in xfs_attr_node_addname_find_attr and
> > xfs_attr_node_removename_setup function because we should free state ourselves.
> > ]
> >
> > Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
> > Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c | 13 +++++--------
> >  1 file changed, 5 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 96ac7e562b87..fcca36bbd997 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -876,21 +876,18 @@ xfs_attr_node_hasname(
> >
> >       state = xfs_da_state_alloc(args);
> >       if (statep != NULL)
> > -             *statep = NULL;
> > +             *statep = state;
> >
> >       /*
> >        * Search to see if name exists, and get back a pointer to it.
> >        */
> >       error = xfs_da3_node_lookup_int(state, &retval);
> > -     if (error) {
> > -             xfs_da_state_free(state);
> > -             return error;
> > -     }
> > +     if (error)
> > +             retval = error;
> >
> > -     if (statep != NULL)
> > -             *statep = state;
> > -     else
> > +     if (!statep)
> >               xfs_da_state_free(state);
> > +
> >       return retval;
> >  }
> >
> > --
>
> Curious -- the conversion of the _node_hasname callers isn't in this
> patch.  Looking at 5.10.124, I see that most of the callers already
> clean up the passed-out statep, but do the callers of xfs_has_attr free
> it too?

Is that a trick question or am I misunderstanding it :)

xfs_has_attr() passes NULL as xfs_attr_node_hasname()
statep argument... they don't get the state back.

Thanks,
Amir.
