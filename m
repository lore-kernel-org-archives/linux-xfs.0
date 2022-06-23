Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 212D9C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 05:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiFWFLG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 01:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiFWFKl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 01:10:41 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A866D1BE90
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 21:53:57 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id j39so19269136vsv.11
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 21:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fwn8Odrx17brPOLX5uLA9mLWhZJCedJ0z3jLHzaLLhw=;
        b=JBf5K1zyY3/1rraAEtkkllTfvTJ0InrttmzHs7CPPHpF91Wj3VpbCtC9Z3fWGB9lal
         dHdhCHkgcCPMulw8Ew/vJX47fd1Wz+H2v2xWS4VouIYBjE+a2kF4LV9cjPi+sZjZTd2G
         6guhYTTBiyK5eXYd2gX+w2jPMOog8IH0OKQXNHL0XrxeHXCxr24jmDXyMIPRIvvdnevG
         74TeHN8qTqNmBwyNEy2rqpmnvkyEvMlNq8br9r4mfnRRX/1vXDJsuHjJaspkHQDKF5kY
         GWQOLX72rpPtpsdwZyGVnVGz4QHEzcfNdMnjqj4bS8jKqUadLBR7IqldVWzfPxBrrhU/
         hkug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fwn8Odrx17brPOLX5uLA9mLWhZJCedJ0z3jLHzaLLhw=;
        b=ZXYHrpzJdFcz+/tGVXk5+XIcwBRpXKZD4oz3w+dkIphjPQ+X+vN4jXNZBbMU19nw6d
         m/iPDKcZqzKUDR7opiLSxhj45eUfAOpm8Ft5OB5IgYNzEt8yilNdRnsg1Jy5XEAk6AQT
         T+bH472tyWCUyMwOneSoMvxWhOrKrqeh4i2QlTO5MyeZyq+SjFVabPVny5NFZmZFvhvS
         VfW0j/rkGPsGWj9aQJ8sQGjd6o6ctRljGkrWkDWFhsTk3la/48713F0lXB1laoJeqW2f
         O+ihYFOwEB3iNwgcSzMMyxe7aa2Xjak0rSEmIuyqnUDPCmbOe+XZ9DXLqMlzEeSuCY8s
         dZXQ==
X-Gm-Message-State: AJIora9biRenVEROlqre0ew51U5UTbTlTvy0apWLNuqirwdQY3AnjYU3
        03PJJbNupo6eJV1nTNivwOPr2qK3fzdXvqfkDJw=
X-Google-Smtp-Source: AGRyM1t8/sH37n37ctZYxu6xOV3OQdmheA+oJ1AnRUv5D+RrX/JswLF/xeQ1xlsgNGvhCv8J7CDx1Cez8xS4HrQUS7c=
X-Received: by 2002:a05:6102:5dc:b0:354:63f1:df8d with SMTP id
 v28-20020a05610205dc00b0035463f1df8dmr2922096vsf.72.1655960036668; Wed, 22
 Jun 2022 21:53:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
 <YrNB65ISwFDgLT4O@magnolia> <YrNExw1XTTD1dJET@magnolia> <YrOJu6I5Ui0CGcYr@google.com>
In-Reply-To: <YrOJu6I5Ui0CGcYr@google.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 23 Jun 2022 07:53:45 +0300
Message-ID: <CAOQ4uxh=mzrLxn_xRfApJzFD7kZ8evxnxwyFMzRYDgg5Y3_Oqg@mail.gmail.com>
Subject: Re: [PATCH 5.15 CANDIDATE v2 0/8] xfs stable candidate patches for
 5.15.y (part 1)
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 23, 2022 at 12:38 AM Leah Rumancik <leah.rumancik@gmail.com> wrote:
>
> On Wed, Jun 22, 2022 at 09:35:19AM -0700, Darrick J. Wong wrote:
> > On Wed, Jun 22, 2022 at 09:23:07AM -0700, Darrick J. Wong wrote:
> > > On Thu, Jun 16, 2022 at 11:27:41AM -0700, Leah Rumancik wrote:
> > > > The patch testing has been increased to 100 runs per test on each
> > > > config. A baseline without the patches was established with 100 runs
> > > > to help detect hard failures / tests with a high fail rate. Any
> > > > failures seen in the backports branch but not in the baseline branch
> > > > were then run 1000+ times on both the baseline and backport branches
> > > > and the failure rates compared. The failures seen on the 5.15
> > > > baseline are listed at
> > > > https://gist.github.com/lrumancik/5a9d85d2637f878220224578e173fc23.
> > > > No regressions were seen with these patches.
> > > >
> > > > To make the review process easier, I have been coordinating with Amir
> > > > who has been testing this same set of patches on 5.10. He will be
> > > > sending out the corresponding 5.10 series shortly.
> > > >
> > > > Change log from v1
> > > > (https://lore.kernel.org/all/20220603184701.3117780-1-leah.rumancik@gmail.com/):
> > > > - Increased testing
> > > > - Reduced patch set to overlap with 5.10 patches
> > > >
> > > > Thanks,
> > > > Leah
> > > >
> > > > Brian Foster (1):
> > > >   xfs: punch out data fork delalloc blocks on COW writeback failure
> > > >
> > > > Darrick J. Wong (4):
> > > >   xfs: remove all COW fork extents when remounting readonly
> > > >   xfs: prevent UAF in xfs_log_item_in_current_chkpt
> > > >   xfs: only bother with sync_filesystem during readonly remount
> > >
> > > 5.15 already has the vfs fixes to make sync_fs/sync_filesystem actually
> > > return error codes, right?
> Confirmed "vfs: make sync_filesystem return errors from ->sync_fs" made
> it into 5.15.y (935745abcf4c695a18b9af3fbe295e322547a114).

Confirmed that it made it into 5.10.y and that
2719c7160dcf ("vfs: make freeze_super abort when sync_filesystem returns error")
also made it to both 5.10.y and 5.15.y

>
> > >
> > > >   xfs: use setattr_copy to set vfs inode attributes
> > > >
> > > > Dave Chinner (1):
> > > >   xfs: check sb_meta_uuid for dabuf buffer recovery
> > > >
> > > > Rustam Kovhaev (1):
> > > >   xfs: use kmem_cache_free() for kmem_cache objects
> > > >
> > > > Yang Xu (1):
> > > >   xfs: Fix the free logic of state in xfs_attr_node_hasname
> > >
> > > This one trips me up every time I look at it, but this looks correct.
> > >
> > > If the answer to the above question is yes, then:
> > > Acked-by: Darrick J. Wong <djwong@kernel.org>
> >
> > I should've mentioned that this is acked-by for patches 1-7, since Amir
> > posted a question about patch 8 that seems not to have been answered(?)
> >
> > (Do all the new setgid inheritance tests actually pass with patch 8
> > applied?  The VFS fixes were thorny enough that I'm not as confident
> > that they've all been applied to 5.15.y...)
>
> The setgid tests (ex generic/314, generic/444, generic/673, generic/68[3-7],
> xfs/019) ran without issues. The dax config did have failures on both the
> baseline and backports branch but the other configs all passed cleanly.
> There were some changes to these tests since the last time I updated fstests
> though so I'll go ahead and rerun this set to be sure.

That's not all.
There are also Christian's vfstest tests that also check SGID with
and without idmapped mounts.
This is especially important for 5.15.y which has idmapped mounts
support.

Anyway, as agreed, we are dropping this patch for this round.
So let's talk procedure -
You got Acked-by from Darrick for the entire series minus this one patch,
so according to earlier request, please post the v3 diminished series
of the 5.15 CANDIDATE to xfs list with Darrick's Acked-by on all patches,
to allow developers to see the series in its final form before posting
to stable.

The cover letter should list the Changes since v2 to express the dropped
patch.

I don't know what's the customary time to wait for "last notice before merge"
but I would say you can send your series to stable in a day or two if there
are no last minute comments.

Anyway, the post to stable is also public (don't forget to cc xfs list) and
after patches are queued to stable there is also time for developers
to object. (stable process sends emails to patch authors and reviewers
before merging them).

I suggest for convention, that the post to stable be tagged as v4
with CANDIDATE prefix removed and the changelog looking
something like this:

Changes since v3:
- Post to stable

Changes from v2:
- Drop SGID fix
- Added Acks from Darrick

Changes from v1:
(https://lore.kernel.org/all/20220603184701.3117780-1-leah.rumancik@gmail.com/):
- Increased testing
- Reduced patch set to overlap with 5.10 patches

I will follow the same procedure for 5.10 series as soon as all
of Darrick's concerns will be addressed.

Thanks,
Amir.
