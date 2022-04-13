Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B098AC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Apr 2022 15:44:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbiDMPqf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Apr 2022 11:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbiDMPqe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Apr 2022 11:46:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C95AB4A93F
        for <linux-xfs@vger.kernel.org>; Wed, 13 Apr 2022 08:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649864651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oxZdvs0VmpSsHUDqQuZgTQd2vsFm6VB9blHUa5yc41E=;
        b=Hih9y838PskeGVpJuax5y8okSQ28A7Vn83PFLANoAQ1yA3qcd5THjn7YRTyORFxDWzwBKx
        IFoVIwohtf31oFEN41cNGKIQnI5XqRd7bRrFyIVTDbkUKj4vTHD2XbAxV5eYk3HHLtRTcD
        Yec/kjdkN2W+YQRvmVF1OXzb/hePbXQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339-ZrjXRmYRP-OkFwA6t0UQsw-1; Wed, 13 Apr 2022 11:44:10 -0400
X-MC-Unique: ZrjXRmYRP-OkFwA6t0UQsw-1
Received: by mail-qt1-f199.google.com with SMTP id bb11-20020a05622a1b0b00b002f1d65bfc07so277206qtb.19
        for <linux-xfs@vger.kernel.org>; Wed, 13 Apr 2022 08:44:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=oxZdvs0VmpSsHUDqQuZgTQd2vsFm6VB9blHUa5yc41E=;
        b=7T4GObqm415MwqB9HLZlS9WN83KXT4C7njUsT8UwtL9EX1FXUFYqRczUd7wmwqih9L
         vsayqL0aUGPH/3le3xHUeKE6iftwPt0CP/pyr71/+Jzn6H7FN4Ue0WWEl06sjV8jsqOn
         6xarRZk5m3mZz1suheMVPmWh+dpQyIo2ijZtFqSrGjxIjUlPPJSUrqD3fy89wCFdRH1J
         rCjG6GmmR4V6lTpG1LmM0H1Lj6EcUMbdfA0ECFSpV3++5QVho42DrGjKkDCAuvBuBB1l
         HRaLM/BMrzRk4o0GiHl5Qocwz8PhWTmwgChmWTZDxVNW4RFxGDVDiEl2pYOX+WhOuxdm
         R/Ng==
X-Gm-Message-State: AOAM532GVSBt7BXgnqYrz17kf7b64I41Bv/e97N9jdi3UI0wgsL7W9Cx
        SBsTvkbnkJA86k06OqrCfsV3iV2nNBV53ywHnGlcTrfsA6TDm8RBCh9ueK2MChtvn53cyosE1yg
        5iDRPtnGJu0hRZNIBfRLd
X-Received: by 2002:ad4:5634:0:b0:444:4843:1b6f with SMTP id cb20-20020ad45634000000b0044448431b6fmr12989933qvb.6.1649864649258;
        Wed, 13 Apr 2022 08:44:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4v6llDaXqMU0ZBKQmS618JbJtkhiTaWVq0axFMoH2yOJssiSEovSA/c93WE4+JdeyfKKb6A==
X-Received: by 2002:ad4:5634:0:b0:444:4843:1b6f with SMTP id cb20-20020ad45634000000b0044448431b6fmr12989909qvb.6.1649864648963;
        Wed, 13 Apr 2022 08:44:08 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b3-20020a05620a270300b0069c5f9304e6sm557692qkp.48.2022.04.13.08.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 08:44:07 -0700 (PDT)
Date:   Wed, 13 Apr 2022 23:44:01 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH 2/4] generic: ensure we drop suid after fallocate
Message-ID: <20220413154401.vun2usvgwlfers2r@zlang-mailbox>
Mail-Followup-To: Amir Goldstein <amir73il@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
References: <164971767143.169983.12905331894414458027.stgit@magnolia>
 <164971768254.169983.13280225265874038241.stgit@magnolia>
 <20220412115205.d6jjudlkxs72vezd@zlang-mailbox>
 <CAOQ4uxiDW6=qgWtH8uHkOmAyZBR7vfgwgt-DA_Rn0QVihQZQLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiDW6=qgWtH8uHkOmAyZBR7vfgwgt-DA_Rn0QVihQZQLw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 13, 2022 at 10:58:41AM +0300, Amir Goldstein wrote:
> On Wed, Apr 13, 2022 at 1:18 AM Zorro Lang <zlang@redhat.com> wrote:
> >
> > On Mon, Apr 11, 2022 at 03:54:42PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > >
> > > fallocate changes file contents, so make sure that we drop privileges
> > > and file capabilities after each fallocate operation.
> > >
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  tests/generic/834     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/834.out |   33 +++++++++++++
> > >  tests/generic/835     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/835.out |   33 +++++++++++++
> > >  tests/generic/836     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/836.out |   33 +++++++++++++
> > >  tests/generic/837     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/837.out |   33 +++++++++++++
> > >  tests/generic/838     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/838.out |   33 +++++++++++++
> > >  tests/generic/839     |   77 ++++++++++++++++++++++++++++++
> > >  tests/generic/839.out |   13 +++++
> > >  12 files changed, 890 insertions(+)
> > >  create mode 100755 tests/generic/834
> > >  create mode 100644 tests/generic/834.out
> > >  create mode 100755 tests/generic/835
> > >  create mode 100644 tests/generic/835.out
> > >  create mode 100755 tests/generic/836
> > >  create mode 100644 tests/generic/836.out
> > >  create mode 100755 tests/generic/837
> > >  create mode 100644 tests/generic/837.out
> > >  create mode 100755 tests/generic/838
> > >  create mode 100644 tests/generic/838.out
> > >  create mode 100755 tests/generic/839
> > >  create mode 100755 tests/generic/839.out
> > >
> > >
> > > diff --git a/tests/generic/834 b/tests/generic/834
> > > new file mode 100755
> > > index 00000000..9302137b
> > > --- /dev/null
> > > +++ b/tests/generic/834
> > > @@ -0,0 +1,127 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 834
> > > +#
> > > +# Functional test for dropping suid and sgid bits as part of a fallocate.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto clone quick
> > > +
> > > +# Override the default cleanup function.
> > > +_cleanup()
> > > +{
> > > +     cd /
> > > +     rm -r -f $tmp.* $junk_dir
> > > +}
> > > +
> > > +# Import common functions.
> > > +. ./common/filter
> > > +. ./common/reflink
> > > +
> > > +# real QA test starts here
> > > +
> > > +# Modify as appropriate.
> > > +_supported_fs xfs btrfs ext4
> >
> > So we have more cases will break downstream XFS testing :)
> 
> Funny you should mention that.
> I was going to propose an RFC for something like:
> 
> _fixed_by_kernel_commit fbe7e5200365 "xfs: fallocate() should call
> file_modified()"
> 
> The first thing that could be done with this standard annotation is print a
> hint on failure, like LTP does:
> 
> HINT: You _MAY_ be missing kernel fixes:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fbe7e5200365

I think it's not difficult to implement this behavior in xfstests. Generally if
a case covers a known bug, we record the patch commit in case description.

As my habit, if a test case fails, I'd like to read the case source code
directly, to get more details about the failure, and check if there's a known
issue(commit id) covered by that. If there is, check if the kernel I'm testing
contains this commit.

From my experience, if a case fails as it's expect, that's easy to find out,
if the comments is good. Print a hint will help, but won't help much I think,
due to the hint is just a guess, we still need to read source code or do more
testing to make sure that, when we hit a failure first time. But most of time
we always hit unexpected failures, that takes longer time to check.

> 
> The second thing to be done is that downstream testers could use a script
> to auto-generate an expunge list for their test kernel, if they don't care about
> testing known issues, only regressions.

In my testing on RHEL (downstream), I record and update known issues, include known
failures and panic/hang issues (need to skip) for each RHEL release. Before running
xfstests, I try to get a skip list for a specified RHEL/kernel version. Then compare
with its known failures after testing done, to decide if a failure is known/unknown.
Also I created version tags for my redhat internal xfstests repo, for some downstream
of downstream kernel testing (likes Z-stream testing) can use fixed xfstests version.

Some known issue format I record as below[1], a bash script will help to parse it and
compare with testing results. It's only for our internal use, due to I think it's too
crude to be shared :-P

[1]
$ cat known_results/$distro/xfs/145.json 
[
    {
        "DESCRIPTION": "bz19483*** XFS: Assertion failed: dqp->q_res_bcount >= be64_to_cpu(dqp->q_core.d_bcount)",
        "FS": ["xfs"],
        "DMESG": "Assertion failed: dqp->q_res_bcount >= be64_to_cpu\\(dqp->q_core.d_bcount\\)",
        "FIXED": true
    }
]
$ cat known_results/$distro/generic/417.json 
[
    {
        "DESCRIPTION": "bz16255*** (<1%): XFS corruption attribute entry #0 in attr block 0, inode 674 is INCOMPLETE",
        "FS": ["xfs"],
        "ARCH": ["ppc64le"],
        "OUTBAD": "_check_xfs_filesystem.*inconsistent",
        "FULL": "attribute entry.*in attr block.*, inode.*is INCOMPLETE"
    }
]

> 
> I hope that with the new maintainship you will also take the opportunity
> to make fstests more friendly to downstream kernel testers.
> 
> > All cases looks good, but according to the custom, all generic cases use
> > "_supported_fs generic", if you have 1+ specified filesystems, maybe
> > "tests/shared/*" is better?
> >
> 
> I think we should stay away from tests/shared for as much as possible and
> use it only for very specific fs behaviors.

I prefer generic testing too :)

> 
> What in the behavior of fallocate() and setgid makes it so special that it needs
> to be restricted to "xfs btrfs ext4" and not treated as a bug for other fs?
> I suspect that it might be difficult or impossible to change that behavior in
> network filesystems?

I'm not sure what other filesystems think about this behavior. If this's a standard
or most common behavior, I hope it can be a generic test (then let other fs maintainers
worry about their new testing failure:-P). Likes generic/673 was written for XFS,
then btrfs found failure, then btrfs said XFS should follow VFS as btrfs does :)

> 
> When facing a similar dilemma in the past we ended up with a whitelist
> _fstyp_has_non_default_seek_data_hole(), but not sure we need to resort to that.
> 
> Thanks,
> Amir.
> 

