Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD371C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jul 2022 21:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiGTV0s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jul 2022 17:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiGTV0r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jul 2022 17:26:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD515A891
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 14:26:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03790B82213
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 21:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905CCC3411E;
        Wed, 20 Jul 2022 21:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658352403;
        bh=GF/YRWN7NyQ5ULJL8IJjxNSZCrMwpGAKJKRO0LoGATs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aIBZA77yG1Xkl+n/CCtMZNsXUowPbmnOmdpwVGteofRjmzF0RGwHBlBIKvxW8pi4R
         xZpp2Lfe7GDidHb4cHnhEmeAM1dy1VZ6oM1W42ffXgMCVwsnzmhXveVdxTPxR7jCC7
         y5edKgufro7n/GmjJRRhTJLyUr0ckPuVkUx7AMvl2voCGVwpUZ0fjx9o+YAYHS09yN
         3EFNCnWox2NKX32VcymlnRIPeWOJ7MecjtZNmHg9Al1gI4ZneJuUBLx9XNfqysVcRf
         yoPiZw8VcV4tFrHs6Ln5Flg8F6LTXVe2l0e8Y7routiEmTz4YdvRh6Sl1xNen6k3Qa
         loDdcl94YZ9Sg==
Date:   Wed, 20 Jul 2022 14:26:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 5.15 CANDIDATE 0/9] xfs stable candidate patches for
 5.15.y (part 3)
Message-ID: <YthzE8UDK8yY4OUA@magnolia>
References: <20220718202959.1611129-1-leah.rumancik@gmail.com>
 <YtXXhQuOioUeSltH@magnolia>
 <CAOQ4uxh13NPtWP98E-R7Sxfy=dkgCHxk7tysEykJ2rg3yhJ__A@mail.gmail.com>
 <YtbDSQjWaVvweLRC@magnolia>
 <YthFT0bJlbEdhPTY@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YthFT0bJlbEdhPTY@google.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 20, 2022 at 11:11:27AM -0700, Leah Rumancik wrote:
> On Tue, Jul 19, 2022 at 07:44:25AM -0700, Darrick J. Wong wrote:
> > On Tue, Jul 19, 2022 at 10:44:29AM +0200, Amir Goldstein wrote:
> > > On Tue, Jul 19, 2022 at 12:05 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > > >
> > > > On Mon, Jul 18, 2022 at 01:29:50PM -0700, Leah Rumancik wrote:
> > > > > Hi again,
> > > > >
> > > > > This set contains fixes from 5.16 to 5.17. The normal testing was run
> > > > > for this set with no regressions found.
> > > > >
> > > > > I included some fixes for online scrub. I am not sure if this
> > > > > is in use for 5.15 though so please let me know if these should be
> > > > > dropped.
> > > > >
> > > > > Some refactoring patches were included in this set as dependencies:
> > > > >
> > > > > bf2307b19513 xfs: fold perag loop iteration logic into helper function
> > > > >     dependency for f1788b5e5ee25bedf00bb4d25f82b93820d61189
> > > > > f1788b5e5ee2 xfs: rename the next_agno perag iteration variable
> > > > >     dependency for 8ed004eb9d07a5d6114db3e97a166707c186262d
> > > > >
> > > > > Thanks,
> > > > > Leah
> > > > >
> > > > >
> > > > > Brian Foster (4):
> > > > >   xfs: fold perag loop iteration logic into helper function
> > > > >   xfs: rename the next_agno perag iteration variable
> > > > >   xfs: terminate perag iteration reliably on agcount
> > > > >   xfs: fix perag reference leak on iteration race with growfs
> > > > >
> > > > > Dan Carpenter (1):
> > > > >   xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()
> > > > >
> > > > > Darrick J. Wong (4):
> > > > >   xfs: fix maxlevels comparisons in the btree staging code
> > > >
> > > > Up to this point,
> > > > Acked-by: Darrick J. Wong <djwong@kernel.org>
> > > >
> > > > >   xfs: fix incorrect decoding in xchk_btree_cur_fsbno
> > > > >   xfs: fix quotaoff mutex usage now that we don't support disabling it
> > > > >   xfs: fix a bug in the online fsck directory leaf1 bestcount check
> > > >
> > > > No objections to these last three, since they're legitimate fixes for
> > > > bugs in 5.15, but I would advise y'all not to worry too much about fixes
> > > > for EXPERIMENTAL features.
> > 
> > Also, to clarify -- if you /do/ want to pick up the scrub fixes, then
> > yes, the Acked-by above does apply to the entire set.  I don't know if
> > you have people running (experimental) scrub, but I don't know that you
> > **don't**. :)
> 
> These fixes aren't a priority over here so I'll postpone scrub fixes in
> the future since it doesn't seem like people care. For this set, is
> there coverage in xfstests for them? If so, I'll go ahead and keep them,
> but if not, I'll just drop them.

Nothing other than the general fuzzing tests.  You might as well ignore
them.

--D

> - Leah
> 
> > 
> > > FWIW, from the set above, I only picked Dan Carpenter's fix for 5.10.
> > > I'll include it in one of the following updates.
> > 
> > <nod>
> > 
> > --D
> > 
> > > Thanks,
> > > Amir.
