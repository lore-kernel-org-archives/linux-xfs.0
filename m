Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85338C43334
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 09:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbiFHJJR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 05:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbiFHJHf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 05:07:35 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0B815350B;
        Wed,  8 Jun 2022 01:25:22 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id d39so18758426vsv.7;
        Wed, 08 Jun 2022 01:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yXkXXsvQd2KkUWNXPHb69SS2KLi9PygRpxgLeegIqwc=;
        b=ox88qVAdhE0t5u2vh85AbyHHEx6bA2iDbZUnW/oXsE/g0iNwZ7+d9HaZGoyvxwCkge
         z2cjWP1wd9n5DLmR87dopdrltiS64RwEvLIeVfApM8ZjxHat/82XTa1KRuxkqK2KmQe0
         O5Z5NLPcjUv3c9d71NiWqSPVK2vu0f44b0ZZXc4bb/TcTTY2fEN26zRHEiyC/u+LF/V1
         aTZdnQPHW0eC7ntLC4wFkHRD0AKsLRzElZ6ruWZAMortf+mdxw5LXUM8shJ7D2SW8SL4
         3olNJdnCU+JR8pfzomOrs3XXEVycUjpRQH53LV1TLPyqJZ5yFpKTNh2t1NUKogQaIsoF
         S3lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yXkXXsvQd2KkUWNXPHb69SS2KLi9PygRpxgLeegIqwc=;
        b=d0ReWIS9r8wE9JxXTVjA0kkbXxnp7kfEoTXw+SHf/0Xp5Dzq5DOJyfnROfW6Hle8qr
         ddXsCk+0AbZMEiBZR824eqe+ojE+uAdimd7FrkvDlJtFvBIdPj2GB34rSG0PdjLYuBd5
         44mg6WZaBmlrQp2M8snIEKbg1W5j8Z+jlQ4DZXJZAu24qV1s8vm5TV5FmZylrHIKk0F9
         zrn77tG6/KZgJ2l8Qw5dgLhMFbVjdcQPwzeGEIgw/u43kGjsnyQXCA8CtMCKafFr7+zg
         YfF5Jv4mtyyJ1o2NvcQ3YF4Xq6/T/0iVLa4CMKj20p2Gz7gKjeAYvt/2nfpvS4KIkPkK
         2n4Q==
X-Gm-Message-State: AOAM533dKs++iMsj3N0Xk4s2Yku4dj0tWETGYt5vqZ493tde1ZqkcOJq
        nUdzloIuJCJVQKqIOojVJKWv+ZXnWwKEaSUr7rE=
X-Google-Smtp-Source: ABdhPJxyUaGimZxcnSD/TOnLgE6RTzPmSx8PAI75J+mNxCiKzWjUNNNXBTFW0njH+zQLYIEI2Ef64FqrCiuTrQEuZQ4=
X-Received: by 2002:a67:486:0:b0:349:e59c:51f4 with SMTP id
 128-20020a670486000000b00349e59c51f4mr16514952vse.3.1654676721635; Wed, 08
 Jun 2022 01:25:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220601104547.260949-1-amir73il@gmail.com> <20220601104547.260949-2-amir73il@gmail.com>
 <20220602005238.GK227878@dread.disaster.area> <CAOQ4uxjcumjxeWypahgYd9wLExLuipd9MTCc_8vfq6SFY7L4dA@mail.gmail.com>
 <20220602103149.gc6b5hzkense5nrs@wittgenstein>
In-Reply-To: <20220602103149.gc6b5hzkense5nrs@wittgenstein>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 8 Jun 2022 11:25:10 +0300
Message-ID: <CAOQ4uxjJBCw7bzK6TAuVd2hs+cs_86z97F06q7k9BE7yVP-Cvw@mail.gmail.com>
Subject: Re: [PATCH 5.10 CANDIDATE 1/8] xfs: fix up non-directory creation in
 SGID directories
To:     Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Yang Xu <xuyang2018.jy@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 2, 2022 at 1:31 PM Christian Brauner <brauner@kernel.org> wrote:
>
> On Thu, Jun 02, 2022 at 07:13:56AM +0300, Amir Goldstein wrote:
> > On Thu, Jun 2, 2022 at 3:52 AM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Wed, Jun 01, 2022 at 01:45:40PM +0300, Amir Goldstein wrote:
> > > > From: Christoph Hellwig <hch@lst.de>
> > > >
> > > > commit 01ea173e103edd5ec41acec65b9261b87e123fc2 upstream.
> > > >
> > > > XFS always inherits the SGID bit if it is set on the parent inode, while
> > > > the generic inode_init_owner does not do this in a few cases where it can
> > > > create a possible security problem, see commit 0fa3ecd87848
> > > > ("Fix up non-directory creation in SGID directories") for details.
> > >
> > > inode_init_owner() introduces a bunch more SGID problems because
> > > it strips the SGID bit from the mode passed to it, but all the code
> > > outside it still sees the SGID bit set. IIRC, that means we do the
> > > wrong thing when ACLs are present. IIRC, there's an LTP test for
> > > this CVE now, and it also has a variant which uses ACLs and that
> > > fails too....
> >
> > Good point.
> > I think Christian's vfstests probably tests more cases than what LTP
> > does at this point.
>
> I think so, yes. There will also be more tests coming into fstests.
>
> >
> > Christian, Yang,
> >
> > It would be nice if you could annotate the relevant fstests with
> > _fixed_by_kernel_commit, which will make it easier to find
> > all relevant commits to backport when tests are failing on LTS
> > kernel.
> >
> > >
> > > I'm kinda wary about mentioning a security fix and then not
> > > backporting the entire set of fixes the CVE requires in the same
> > > patchset.  I have no idea what the status of the VFS level fixes
> > > that are needed to fix this properly - I thought they were done and
> > > reviewed, but they don't appear to be in 5.19 yet.
> > >
> >
> > No, it looks like tihs is still in review.
> >
> > Christoph, Cristian, Yang,
> >
> > What do you think is best to do w.r.t this patch?
> >
> > Wait for all the current known issues to be fixed in upstream and then
> > backport all known fixes?
> >
> > Backport whatever fixes are available in upstream now at the same
> > backport series?
> >
> > Take this now and the rest later?
>
> Imho, backporting this patch is useful. It fixes a basic issue.
> What Dave mentioned is that if ACLs/umask are in play things become
> order dependent I've pointed out on the patch that aims to fix this: If
> no ACLs are supported then umask is stripped in vfs and if they are it's
> stripped in the fs. So if umask strips S_IXGRP in the vfs then no setgid
> bit is inherited. If it's stripped in the fs post inode_init_owner()
> setgid bit is tripped and thus not inherited.. The vfs patch unifies
> this behavior.
>

TBH, I am having a hard time following the expected vs. actual
behavior in all the cases at all points in time.

Christoph,

As the author of this patch, do you have an opinion w.r.t backporting
this patch alongs with vs. independent of followup fixes?
wait for future fixes yet to come?

Thanks,
Amir.
