Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C93ADC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jun 2022 04:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiFBEOL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jun 2022 00:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiFBEOJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jun 2022 00:14:09 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C899232A57;
        Wed,  1 Jun 2022 21:14:08 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id v5so2850186qvs.10;
        Wed, 01 Jun 2022 21:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CDMaq12gvfHNtCAAIYlXWvyoSMGyp4EOiIiFiNQwkJ4=;
        b=KfLc8dEFRs4FyA+24zbDQsYIaVyL4qWtfms64oJOHMLR8kJ6rTgyy4j3qjezpHRvTs
         kFCOBXyNPXhPgQWTz+CCVrwxjxUx38RLU0i/+EWT/BTDXxP3gr1J1vHS+s7WKfVdGc/B
         bMz+X5oyUxAojTr/0I2E2mOMcxMAMrJiepWExqUJVS/z19OLUFvlSe85GCrx5kSyo/lc
         SMQ+yTGzwRcmcJxXpOlAz5bi70l9fFHq4T52QfACX6LZXbIDE6G/RzpqGjkuXBS888YT
         NbpgUDQLtrJvSzoUXkGQCC4jyhJh0j3Xzq6yge7foMSc+nm9PUrzWWkW7K0zjzU0lyAF
         w33w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CDMaq12gvfHNtCAAIYlXWvyoSMGyp4EOiIiFiNQwkJ4=;
        b=kDr1KiY078LOtWYkQupj08Hf385veLVKC7rUr8bKGIgvI+TN+KEPKiIjWDI9Z6bgAF
         bm0fazCteIMvHJvL3qgVd7QHgwy8fHnEatnlavJxzevHOrro7JzOpQQEbIdrvcVLZHP7
         pfpZrYKftsZCUYrtxi9WwP4LqUBj8BbGLIFINz40ONWaCSWnZP7h9hSmu+6lIbSlsgFl
         MohXMBW0dm+b4L8dqkZeT6c/Ye9CiU5WslxdDmg4FJ2yYpI8F5JWCm86JXYqmL9IOAen
         KIa20qXtauwcP9ANPdzXezlQ4h+ynyuvwifkrweaNep65Mge0Mw7lj6b7AOAYk4mkGkT
         17dA==
X-Gm-Message-State: AOAM5337y8xLA64Cfrokm048Bl7YVKFC3i31NspYiKsNk9sncFB+kGSU
        XqM7x3SAV/6ScOqnBh8gl7LlWucOXEVtrx9U6knvMp+f+Gc=
X-Google-Smtp-Source: ABdhPJz4yBMEsezosWxKF/iCFR5mDemaYrsUxVjhUX1pZaxsBxoYJ2qwjU67r2caCdLuFOC+7cU8R27Xlc/kqLi7oSQ=
X-Received: by 2002:a05:6214:2468:b0:466:1bce:6c74 with SMTP id
 im8-20020a056214246800b004661bce6c74mr3672134qvb.77.1654143247763; Wed, 01
 Jun 2022 21:14:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220601104547.260949-1-amir73il@gmail.com> <20220601104547.260949-2-amir73il@gmail.com>
 <20220602005238.GK227878@dread.disaster.area>
In-Reply-To: <20220602005238.GK227878@dread.disaster.area>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 2 Jun 2022 07:13:56 +0300
Message-ID: <CAOQ4uxjcumjxeWypahgYd9wLExLuipd9MTCc_8vfq6SFY7L4dA@mail.gmail.com>
Subject: Re: [PATCH 5.10 CANDIDATE 1/8] xfs: fix up non-directory creation in
 SGID directories
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J . Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
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

On Thu, Jun 2, 2022 at 3:52 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Wed, Jun 01, 2022 at 01:45:40PM +0300, Amir Goldstein wrote:
> > From: Christoph Hellwig <hch@lst.de>
> >
> > commit 01ea173e103edd5ec41acec65b9261b87e123fc2 upstream.
> >
> > XFS always inherits the SGID bit if it is set on the parent inode, while
> > the generic inode_init_owner does not do this in a few cases where it can
> > create a possible security problem, see commit 0fa3ecd87848
> > ("Fix up non-directory creation in SGID directories") for details.
>
> inode_init_owner() introduces a bunch more SGID problems because
> it strips the SGID bit from the mode passed to it, but all the code
> outside it still sees the SGID bit set. IIRC, that means we do the
> wrong thing when ACLs are present. IIRC, there's an LTP test for
> this CVE now, and it also has a variant which uses ACLs and that
> fails too....

Good point.
I think Christian's vfstests probably tests more cases than what LTP
does at this point.

Christian, Yang,

It would be nice if you could annotate the relevant fstests with
_fixed_by_kernel_commit, which will make it easier to find
all relevant commits to backport when tests are failing on LTS
kernel.

>
> I'm kinda wary about mentioning a security fix and then not
> backporting the entire set of fixes the CVE requires in the same
> patchset.  I have no idea what the status of the VFS level fixes
> that are needed to fix this properly - I thought they were done and
> reviewed, but they don't appear to be in 5.19 yet.
>

No, it looks like tihs is still in review.

Christoph, Cristian, Yang,

What do you think is best to do w.r.t this patch?

Wait for all the current known issues to be fixed in upstream and then
backport all known fixes?

Backport whatever fixes are available in upstream now at the same
backport series?

Take this now and the rest later?

To be on the safe side, until there is consensus about the best way
to fix LTS, I will omit this fix from my weekly post to stable.

Thanks,
Amir.
