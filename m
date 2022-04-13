Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E92C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Apr 2022 07:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbiDMIBT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Apr 2022 04:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbiDMIBS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Apr 2022 04:01:18 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CAD4D9C8;
        Wed, 13 Apr 2022 00:58:54 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id c1so777171qkf.13;
        Wed, 13 Apr 2022 00:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=FguQ3xPb2OWJLCCCeDkDPo74kniWktE5swxADSohLoI=;
        b=JMv33Ei5cPVMh4fpzLwZWW2NDiLYJlkgSft5+WWzRKJ0H8b2/FGP8Whu8NKOMK8TVy
         MSmU9AM4arviVOfM0QBQHNM1fLGaZh1O4QeXEmFLu8F+S8GI79wP6HvTW++wB8GsDcCE
         J3hQpyWeFCDmfM8Kt7aaooFb8YBvWsKit+foTbN9lxI0ZzgZWrfBV1NR21wvtEziJQO/
         zyBOgegfdzf7ZeVG1l1Sj5Aw0JMdg9qejs/6MMxBuiwPG2HfQoHpaVuot+AKMGgZmuzp
         a0QOdXiXPhUKf+HdbwkoXLLrtKq5lkWWdjXVPKG5MMnwJUKCAtVKaKvZU1l8lUJ40wMV
         +C1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=FguQ3xPb2OWJLCCCeDkDPo74kniWktE5swxADSohLoI=;
        b=8EMg7UdpGRMDFxEmNcl+Ur/zWJoDyYoUtHC0nXwwGd3Lx/MawDTgs9CbbCUhU92QVV
         V1WE1+dHBCwRJD0c3+WN7lOSW5IiXlkho3K9THqe6t3XEtZqz3aRTTblAk3dx1OwUoWa
         pErg50ZUh0Wt8u9W4hl7s9EdaMukSqyUuDMo7F9LcKW7iRB91juYOGsoItzr1fyXsrDv
         WitLrHVb4NtWJkPWrIP2FbTI9ssE9Q1YvT97Tix0iBKuvaY+QDxzQe2pa8yZxHkF8/lE
         WPTqEpfbhMsyqV/oGAGF4jsfcrjN/sXWI4wX59wmibKbdfsrNcMzDnleNdnvRaJ/Lwcd
         ykzw==
X-Gm-Message-State: AOAM530hOCMZztggcXUP7oMbF+sfHIq52kSEIz7/jCdKboq2THt4yadn
        Dsa2XfQVZbv/vjY4CEkrM8uKoFdWfU3ymJ4eTjA=
X-Google-Smtp-Source: ABdhPJwfVyL0+uJRB9o1Fj57HQBh8mTYYUtYEcwZ1K2oi2f/W+KYVrlfS+qu8lPX6G7y3U/bJhDLSA5ILQ/KH1yg1pw=
X-Received: by 2002:a37:48c:0:b0:69c:1250:aeb3 with SMTP id
 134-20020a37048c000000b0069c1250aeb3mr5864527qke.643.1649836733212; Wed, 13
 Apr 2022 00:58:53 -0700 (PDT)
MIME-Version: 1.0
References: <164971767143.169983.12905331894414458027.stgit@magnolia>
 <164971768254.169983.13280225265874038241.stgit@magnolia> <20220412115205.d6jjudlkxs72vezd@zlang-mailbox>
In-Reply-To: <20220412115205.d6jjudlkxs72vezd@zlang-mailbox>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 13 Apr 2022 10:58:41 +0300
Message-ID: <CAOQ4uxiDW6=qgWtH8uHkOmAyZBR7vfgwgt-DA_Rn0QVihQZQLw@mail.gmail.com>
Subject: Re: [PATCH 2/4] generic: ensure we drop suid after fallocate
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 13, 2022 at 1:18 AM Zorro Lang <zlang@redhat.com> wrote:
>
> On Mon, Apr 11, 2022 at 03:54:42PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > fallocate changes file contents, so make sure that we drop privileges
> > and file capabilities after each fallocate operation.
> >
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/generic/834     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/834.out |   33 +++++++++++++
> >  tests/generic/835     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/835.out |   33 +++++++++++++
> >  tests/generic/836     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/836.out |   33 +++++++++++++
> >  tests/generic/837     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/837.out |   33 +++++++++++++
> >  tests/generic/838     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/838.out |   33 +++++++++++++
> >  tests/generic/839     |   77 ++++++++++++++++++++++++++++++
> >  tests/generic/839.out |   13 +++++
> >  12 files changed, 890 insertions(+)
> >  create mode 100755 tests/generic/834
> >  create mode 100644 tests/generic/834.out
> >  create mode 100755 tests/generic/835
> >  create mode 100644 tests/generic/835.out
> >  create mode 100755 tests/generic/836
> >  create mode 100644 tests/generic/836.out
> >  create mode 100755 tests/generic/837
> >  create mode 100644 tests/generic/837.out
> >  create mode 100755 tests/generic/838
> >  create mode 100644 tests/generic/838.out
> >  create mode 100755 tests/generic/839
> >  create mode 100755 tests/generic/839.out
> >
> >
> > diff --git a/tests/generic/834 b/tests/generic/834
> > new file mode 100755
> > index 00000000..9302137b
> > --- /dev/null
> > +++ b/tests/generic/834
> > @@ -0,0 +1,127 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 834
> > +#
> > +# Functional test for dropping suid and sgid bits as part of a fallocate.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto clone quick
> > +
> > +# Override the default cleanup function.
> > +_cleanup()
> > +{
> > +     cd /
> > +     rm -r -f $tmp.* $junk_dir
> > +}
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/reflink
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs xfs btrfs ext4
>
> So we have more cases will break downstream XFS testing :)

Funny you should mention that.
I was going to propose an RFC for something like:

_fixed_by_kernel_commit fbe7e5200365 "xfs: fallocate() should call
file_modified()"

The first thing that could be done with this standard annotation is print a
hint on failure, like LTP does:

HINT: You _MAY_ be missing kernel fixes:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fbe7e5200365

The second thing to be done is that downstream testers could use a script
to auto-generate an expunge list for their test kernel, if they don't care about
testing known issues, only regressions.

I hope that with the new maintainship you will also take the opportunity
to make fstests more friendly to downstream kernel testers.

> All cases looks good, but according to the custom, all generic cases use
> "_supported_fs generic", if you have 1+ specified filesystems, maybe
> "tests/shared/*" is better?
>

I think we should stay away from tests/shared for as much as possible and
use it only for very specific fs behaviors.

What in the behavior of fallocate() and setgid makes it so special that it needs
to be restricted to "xfs btrfs ext4" and not treated as a bug for other fs?
I suspect that it might be difficult or impossible to change that behavior in
network filesystems?

When facing a similar dilemma in the past we ended up with a whitelist
_fstyp_has_non_default_seek_data_hole(), but not sure we need to resort to that.

Thanks,
Amir.
