Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63AFAC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 15:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244932AbiEZPwF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 11:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239905AbiEZPwE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 11:52:04 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48E2DE335
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 08:52:03 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id s31so2071015qtc.3
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 08:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=H9gsY8PQkmpsqphZH6WSs2NqeTKu15EXsMTvW5us2I0=;
        b=D6tH1wi8LSblLWUDHerq8ix+sls4OjXN3RTfgpcPxDjgoYDINB98B9ssfZ8nWnlFss
         +Erl1giBS49sBi7h8pYVf84Qq4reD0fAShu/QOfyNgZ0mSP6VYT3xtc20sNeK52SyVQx
         OF+mvoHiFL2CR+urhwZeigg0Chu24nSrQ+9TgDOj9XLub6bemHCGfDKPwn5Fz/6jrCwb
         38fg8ybTi0crbNl9Fa2zxYs0jF9mS4ySCI+BVKY83/5K2meA97bFnnKKo+bfbrWe0djx
         l29OBrjPE4wj3cdRPvyOyn/Tfb0WJKzgZ4IVj7fB3+g/FNGjiMr/SazGoFFibD0j8zYk
         KwyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=H9gsY8PQkmpsqphZH6WSs2NqeTKu15EXsMTvW5us2I0=;
        b=NYxYZuytEYzUVXfHhL2kQOFmsdgIHNeNFTL+v3Uc/+9TYKxadRYR5dd75empNQOoTE
         QELxnObps1Ft8qYHMrxfb7DJkVK78BOTOSY8Yx98xeTeIYyx4lKIbqdhF5dScVh0/Dqf
         NJG7XHklWMhNpqzIZzqtvKnhOdE68hPV/iKAIOnAhvg6fEOBe9vdmjldpjfa3jMaZ5T9
         VhF/SSBfnYGt/xVImP95S8oShVvpfugZErsdsM53YqrTO7y/0K1qi+BhBLkjxeoOUoeK
         lJV1FxRBqfWxFh3zMZI0FE3WTW3VAgiV7s9IAKVEp/V5LrFHTELgxBB0zWUzfWZ6zZ3k
         T6SQ==
X-Gm-Message-State: AOAM530wXvYio9R2b+98xJPhOzyQY/9hr0MZFxWKXC262Hk3/YpVwdWe
        xjfBv+ouNQzT8HOTbnZ+Z5R2vJ0CT1FgVYAmY80Fa9LQBDs=
X-Google-Smtp-Source: ABdhPJwoB0TggfTgzZck4K6Gk4mb7ncAJ+HyEeKuBSr1eEukEYSk5plIq9OmjYl+VuWx2kb+C2chYM6WLgB4gxfWhF0=
X-Received: by 2002:ac8:7fc2:0:b0:2f3:d47d:487c with SMTP id
 b2-20020ac87fc2000000b002f3d47d487cmr29271381qtk.157.1653580322855; Thu, 26
 May 2022 08:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <Yo6ePjvpC7nhgek+@magnolia> <Yo+WQl3OFsPMUAbl@google.com>
In-Reply-To: <Yo+WQl3OFsPMUAbl@google.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 26 May 2022 18:51:51 +0300
Message-ID: <CAOQ4uxhiAeO=EBVfphyJ7Y71kqYQJk721Df3W0Ek8nnYZw7LZg@mail.gmail.com>
Subject: Re: XFS LTS backport cabal
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Shirley Ma <shirley.ma@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Konrad Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 26, 2022 at 6:01 PM Leah Rumancik <leah.rumancik@gmail.com> wro=
te:
>
> On Wed, May 25, 2022 at 02:23:10PM -0700, Darrick J. Wong wrote:
> > Hi everyone,
> >
> > 3. fstesting -- new patches proposed for stable branches shouldn't
> > introduce new regressions, and ideally there would also be a regression
> > test that would now pass.  As Dave and I have stated in the past,
> > fstests is a big umbrella of a test suite, which implies that A/B
> > testing is the way to go.  I think at least Zorro and I would like to
> > improve the tagging in fstests to make it more obvious which tests
> > contain enough randomness that they cannot be expected to behave 100%
> > reliably.
> It would be nice to find an agreement on testing requirements. I have
> attached some ideas on configs/number of tests/etc as well as the status
> of my work on 5.15 below.
>
>
> > a> I've been following the recent fstests threads, and it seems to me
> > that there are really two classes of users -- sustaining people who wan=
t
> > fstests to run reliably so they can tell if their backports have broken
> > anything; and developers, who want the randomness to try to poke into
> > dusty corners of the filesystem.  Can we make it easier to associate
> > random bits of data (reliability rates, etc.) with a given fstests
> > configuration?  And create a test group^Wtag for the tests that rely on
> > RNGs to shake things up?
> This would be great!
>
> >
> >
> > Thoughts? Flames?
> >
> > --D
> This thread had good timing :) I have been working on setting up
> some automated testing. Currently, 5.15.y is our priority so I have
> started working on this branch.
>
> Patches are being selected by simply searching for the =E2=80=9CFixes=E2=
=80=9D
> tag and applying if the commit-to-be-fixed is in the stable branch,
> but AUTOSEL would be nice, so I=E2=80=99ll start playing around with that=
.
> Amir, it would be nice to sync up the patch selection process. I can
> help share the load, especially for 5.15.
>

I would like that :)

> Selecting just the tagged =E2=80=9CFixes=E2=80=9D for 5.15.y for patches =
through
> 5.17.2, 15 patches were found and applied - if there are no
> complaints about the testing setup, I can go ahead and send out this
> batch:
>
> c30a0cbd07ec xfs: use kmem_cache_free() for kmem_cache objects
> 5ca5916b6bc9 xfs: punch out data fork delalloc blocks on COW writeback fa=
ilure
> a1de97fe296c xfs: Fix the free logic of state in xfs_attr_node_hasname
> 1090427bf18f xfs: remove xfs_inew_wait
> 089558bc7ba7 xfs: remove all COW fork extents when remounting readonly
> 7993f1a431bc xfs: only run COW extent recovery when there are no live ext=
ents
> 09654ed8a18c xfs: check sb_meta_uuid for dabuf buffer recovery
> f8d92a66e810 xfs: prevent UAF in xfs_log_item_in_current_chkpt
> b97cca3ba909 xfs: only bother with sync_filesystem during readonly remoun=
t
> eba0549bc7d1 xfs: don't generate selinux audit messages for capability te=
sting
> e014f37db1a2 xfs: use setattr_copy to set vfs inode attributes
> 70447e0ad978 xfs: async CIL flushes need pending pushes to be made stable
> c8c568259772 xfs: don't include bnobt blocks when reserving free block po=
ol
> cd6f79d1fb32 xfs: run callbacks before waking waiters in xlog_state_shutd=
own_callbacks
> 919edbadebe1 xfs: drop async cache flushes from CIL commits.
>

Here are my selection for v5.15..v5.17:

* 1cd231d9fdb1 - (tag: xfs-5.10.y-7) xfs: use setattr_copy to set vfs
inode attributes
* af09d052db41 - xfs: fallocate() should call file_modified()
* 0daebb90e096 - xfs: reject crazy array sizes being fed to XFS_IOC_GETBMAP=
*
* 35d876873c28 - xfs: prevent UAF in xfs_log_item_in_current_chkpt
* 796e9e00071d - xfs: xfs_log_force_lsn isn't passed a LSN
* fa33747dd25b - xfs: refactor xfs_file_fsync
* 374a05b9a2de - xfs: check sb_meta_uuid for dabuf buffer recovery
* 0b66f78d6af1 - (tag: xfs-5.10.y-6) xfs: remove all COW fork extents
when remounting readonly
* 44caa4c7aaf4 - xfs: remove incorrect ASSERT in xfs_rename
* 4133fc82c95d - xfs: punch out data fork delalloc blocks on COW
writeback failure

The branch of the moment is at:
https://github.com/amir73il/linux/commits/xfs-5.10.y
But I keep force pushing the branch and tags when dropping patches
from the queue.

Note that only half of those commits have Fixes: tag.
As I explained, I got to them by removing all the non-fixes and non-relevan=
t
commits and then tried to evaluate the remaining commits individually.
This was only made scalable because I was working at the patch series
level and not at commit level, although at many times, a single fix patch
was selected from within a non-fix series.

Note that many of the fixes that you selected are impact waves of
big performance improvements that got merged after 5.10, so
were not relevant for my 5.10.y selection.

Thanks,
Amir.
