Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB770C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Mar 2021 21:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFA3064E67
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Mar 2021 21:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhCNVgt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 14 Mar 2021 17:36:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231809AbhCNVge (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 14 Mar 2021 17:36:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5732964E99;
        Sun, 14 Mar 2021 21:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615757794;
        bh=Y0OMIo5dGNwpX/9VF7mIjdTASafYDtcrtnUei8ZURp4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WUMG0aAOzj9c4/wxROEafGLBgeAx/CvoKQgFKLmJEsviS0IhvwZMyV5THg39VO8RE
         ZoXW3yaERDjNgqryvIhLFzvsNViSFTX+VLtNlIxTJAXL+SkqnP0HYL4UGNJz3PLOIl
         PS+Qm1YfiN6c2UY6mUygRhxsSs4rl0uj7h0Nsc2Z6yb6EIcDpmZZQCPAwYLjl0YxIi
         S86XRRJxP13tiw1cmV3ZW3sl3nvzcFt1uHP2bUOk82NQ4L2wr37dYw/hwEosdZeHol
         6zA4F5bvOYjvg8N5qylVNWlIS+dmDvLFl3kv0avcC8a5j0Hf7WyciyuiOgDdJr51Uw
         ONSQclDW7ro2g==
Date:   Sun, 14 Mar 2021 14:36:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guan@eryu.me>
Cc:     guaneryu@gmail.com, wenli xie <wlxie7296@gmail.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCHSET 00/10] fstests: test kernel regressions fixed in 5.12
Message-ID: <20210314213632.GA22097@magnolia>
References: <161526480371.1214319.3263690953532787783.stgit@magnolia>
 <YE5Q8L3is1RscqfJ@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YE5Q8L3is1RscqfJ@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 15, 2021 at 02:07:44AM +0800, Eryu Guan wrote:
> On Mon, Mar 08, 2021 at 08:40:03PM -0800, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Here are new tests for problems that were fixed in upstream Linux
> > between 5.9 and 5.12.
> 
> I've applied all patches except 3/10 and 9/10, thanks for the tests and
> fixes!

Thank /you/ for putting them in!  I'll revise those two and have a new
submission in a few days.

--D

> Eryu
> 
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees, which are linked below.
> > 
> > This is an extraordinary way to destroy everything.  Enjoy!
> > Comments and questions are, as always, welcome.
> > 
> > --D
> > 
> > fstests git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=kernel-regressions
> > ---
> >  .gitignore             |    1 
> >  common/filter          |   24 +++
> >  src/Makefile           |    4 -
> >  src/chprojid_fail.c    |   92 ++++++++++++
> >  src/deduperace.c       |  370 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/1300     |  109 ++++++++++++++
> >  tests/generic/1300.out |    2 
> >  tests/generic/947      |  118 +++++++++++++++
> >  tests/generic/947.out  |   15 ++
> >  tests/generic/948      |   92 ++++++++++++
> >  tests/generic/948.out  |    9 +
> >  tests/generic/949      |   51 +++++++
> >  tests/generic/949.out  |    2 
> >  tests/generic/group    |    4 +
> >  tests/xfs/050          |   30 +---
> >  tests/xfs/122          |    1 
> >  tests/xfs/122.out      |    1 
> >  tests/xfs/299          |   30 +---
> >  tests/xfs/758          |   59 ++++++++
> >  tests/xfs/758.out      |    2 
> >  tests/xfs/759          |  100 +++++++++++++
> >  tests/xfs/759.out      |    2 
> >  tests/xfs/760          |   68 +++++++++
> >  tests/xfs/760.out      |    9 +
> >  tests/xfs/761          |   45 ++++++
> >  tests/xfs/761.out      |    1 
> >  tests/xfs/765          |   71 +++++++++
> >  tests/xfs/765.out      |    4 +
> >  tests/xfs/915          |  162 +++++++++++++++++++++
> >  tests/xfs/915.out      |  151 ++++++++++++++++++++
> >  tests/xfs/group        |    6 +
> >  31 files changed, 1584 insertions(+), 51 deletions(-)
> >  create mode 100644 src/chprojid_fail.c
> >  create mode 100644 src/deduperace.c
> >  create mode 100755 tests/generic/1300
> >  create mode 100644 tests/generic/1300.out
> >  create mode 100755 tests/generic/947
> >  create mode 100644 tests/generic/947.out
> >  create mode 100755 tests/generic/948
> >  create mode 100644 tests/generic/948.out
> >  create mode 100755 tests/generic/949
> >  create mode 100644 tests/generic/949.out
> >  create mode 100755 tests/xfs/758
> >  create mode 100644 tests/xfs/758.out
> >  create mode 100755 tests/xfs/759
> >  create mode 100644 tests/xfs/759.out
> >  create mode 100755 tests/xfs/760
> >  create mode 100644 tests/xfs/760.out
> >  create mode 100755 tests/xfs/761
> >  create mode 100644 tests/xfs/761.out
> >  create mode 100755 tests/xfs/765
> >  create mode 100644 tests/xfs/765.out
> >  create mode 100755 tests/xfs/915
> >  create mode 100644 tests/xfs/915.out
