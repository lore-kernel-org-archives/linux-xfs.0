Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F89C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 15:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18EA66144D
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 15:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241393AbhDUP7T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 11:59:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241348AbhDUP7S (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Apr 2021 11:59:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E2C86144B;
        Wed, 21 Apr 2021 15:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619020724;
        bh=B09k3QZ6+TR+PNrHt6xfdnlGVA6+HKT9x+sdljCrvSY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W5Qw+6jam2abQsTcujncoGDO/vF/Y4e+I0ouqs7w5XxR2EbAHY0C37lv6cIOLr2s2
         xf2t4/1S5giWd0Pb1c54oQcFS1gu74U5b31bp6XXVZmTgTFCSP0hlTEbA5SvAppm8L
         Y88AK04FNKip5D6PqtERCuW55bMluP8cTFWrGnmITrvBqj1SECBTaKcUxS/Iadn+rI
         /3WJkPxkeP7l+TaKtO2LuPlcCjwUR0WqayyV13dLT9iTZN3Eu49bLdUYZvCHmybvID
         L50rBu7LMOHpgQAMJZV+TDMGfOHLgjIq869M1OUH+oU4eJlNYoVUeoNV0FlE1DxaAM
         NqPjGZ1RsGn7A==
Date:   Wed, 21 Apr 2021 08:58:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH 1/1] xfs: test that the needsrepair feature works as
 advertised
Message-ID: <20210421155843.GC3122235@magnolia>
References: <161896455503.776294.3492113564046201298.stgit@magnolia>
 <161896456107.776294.13840945585349427098.stgit@magnolia>
 <CAOQ4uxhvt0j7r6ZSTiwX8T7uPw5eVH+uMegt+ActLeopmpJy7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhvt0j7r6ZSTiwX8T7uPw5eVH+uMegt+ActLeopmpJy7Q@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 21, 2021 at 09:01:05AM +0300, Amir Goldstein wrote:
> On Wed, Apr 21, 2021 at 3:23 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Make sure that the needsrepair feature flag can be cleared only by
> > repair and that mounts are prohibited when the feature is set.
> >
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/xfs        |   28 ++++++++++++++++++
> >  tests/xfs/768     |   80 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/768.out |    4 +++
> >  tests/xfs/770     |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/770.out |    2 +
> >  tests/xfs/group   |    2 +
> >  6 files changed, 199 insertions(+)
> >  create mode 100755 tests/xfs/768
> >  create mode 100644 tests/xfs/768.out
> >  create mode 100755 tests/xfs/770
> >  create mode 100644 tests/xfs/770.out
> >
> >
> > diff --git a/common/xfs b/common/xfs
> > index 887bd001..c2384146 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -312,6 +312,13 @@ _scratch_xfs_check()
> >         _xfs_check $SCRATCH_OPTIONS $* $SCRATCH_DEV
> >  }
> >
> > +_require_libxfs_debug_flag() {
> > +       local hook="$1"
> > +
> > +       grep -q LIBXFS_DEBUG_WRITE_CRASH "$(type -P xfs_repair)" || \
> > +               _notrun "libxfs debug hook $hook not detected?"
> 
> You ignored the $hook arg.
> And this is a bit of a strange test.

Doh.  Will fix; thanks for noticing that. :)

> In _require_unionmount_testsuite() I also pass env vars to the test utility
> and I made it so the usage message will print the non empty env vars
> passed to the programm.
> 
> I can understand if nothing like that was done for xfs_repair and you want
> this test to work with an already released version of xfs_repair, but if that
> test is against a pre-released version of xfs_repair, I suggest to make it
> more friendly for _require check.

That would have been a good idea, but we already shipped this in 5.11.
:/

--D

> Thanks,
> Amir.
