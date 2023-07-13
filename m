Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0359CEB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 05:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbjGMFMc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 01:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbjGMFMb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2023 01:12:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA732114
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 22:12:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C32D61A00
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 05:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68E0C433C8;
        Thu, 13 Jul 2023 05:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689225148;
        bh=MAmwFVz5TmIP4UQ9sgJdqMOixzDnlU8fwUKKhiZzn6A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TCjEGiotMfI5ztjAsv1yZVhUvrlY9Uwza2xWtLjoUM+lfdDQI0OYCla2zamtwPPfW
         3JlikA5CwxYdkhEF2QxurP+mulUxdazUVfP9bOzYbxkxOUZ9Ybqjhs8Z1/+jcW9Ypq
         CaS0U3iHsbGiWELpdJozqOnxFJ8XCWYn7PnD5o2ktU7wqJQ5oJP5E3+dCp9cZHqhgT
         U9NOtgpXgMVAS8lScxGoKID+7pZ+d/DQDG8ya8fto1dBZmfQM3jrt+4di7vksFUezM
         mAiJlSMlgFqElXvLm0O5p29VX+/x7yZEuu0/RmnrWmP7w0DLPOPH8WeV/SR4Sx11sr
         47fuWM2AE6k+w==
Date:   Wed, 12 Jul 2023 22:12:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCHSET v25.0 0/7] xfs_scrub: fixes to the repair code
Message-ID: <20230713051228.GO108251@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
 <168506071314.3742205.8114181660121831202.stgit@frogsfrogsfrogs>
 <4af2621e-bd59-f1be-8e07-7800a68c59fa@fujitsu.com>
 <20230608145601.GW1325469@frogsfrogsfrogs>
 <e7c43625-73a5-9de5-f3a0-b8e1d67a46f8@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7c43625-73a5-9de5-f3a0-b8e1d67a46f8@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 09, 2023 at 11:22:30AM +0800, Shiyang Ruan wrote:
> 
> 
> 在 2023/6/8 22:56, Darrick J. Wong 写道:
> > On Thu, Jun 08, 2023 at 09:22:02PM +0800, Shiyang Ruan wrote:
> > > Hi Darrick,
> > > 
> > > I'm running test on this patchset (patched kernel and xfsprogs, latest
> > > xfstests:v2023.05.28).  Now I found xfs/730 failed with message "online
> > > scrub didn't fail".  The detail is:
> > > 
> > > FSTYP         -- xfs (debug)
> > > PLATFORM      -- Linux/x86_64 f36 6.4.0-rc3-pmem+ #309 SMP PREEMPT_DYNAMIC
> > > Wed Jun  7 15:44:15 CST 2023
> > > MKFS_OPTIONS  -- -f /dev/pmem1
> > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/pmem1
> > > /mnt/scratch
> > > 
> > > xfs/730       - output mismatch (see
> > > /root/xts/results//default/xfs/730.out.bad)
> > > mv: failed to preserve ownership for
> > > '/root/xts/results//default/xfs/730.out.bad': Operation not permitted
> > >      --- tests/xfs/730.out	2023-03-16 09:42:15.256141472 +0800
> > >      +++ /root/xts/results//default/xfs/730.out.bad	2023-06-08
> > 
> > Whoah, someone besides me actually runs the repair fuzzers??
> > 
> > Yay!
> > 
> > > 20:43:27.436083265 +0800
> > >      @@ -1,4 +1,14 @@
> > >       QA output created by 730
> > >       Format and populate
> > >       Fuzz fscounters
> > >      +icount = zeroes: online scrub didn't fail.
> > >      +icount = ones: online scrub didn't fail.
> > >      +icount = firstbit: online scrub didn't fail.
> > >      +icount = middlebit: online scrub didn't fail.
> > >      ...
> > >      (Run 'diff -u /root/xts/tests/xfs/730.out
> > > /root/xts/results//default/xfs/730.out.bad'  to see the entire diff)
> > > 
> > > 
> > > This test case is to fuzz metadata and make sure xfs_scrub can repair the
> > > fs. After a little investigation, I think the fuzz actually done to the
> > > metadata area but the xfs_scrub seems didn't notice that.  I haven't found
> > > the root cause of the problem yet.  Do you have the same message which
> > > causes fail on this case?
> > 
> > Yeah, we recently disabled some code in fscounters.c to fix some other
> > correctness problems in the inodegc code.
> 
> Do you mean this failure is what you expected?
> 
> > My goal was to get this
> > series:
> > 
> > https://lore.kernel.org/linux-xfs/168506061483.3732954.5178462816967376906.stgit@frogsfrogsfrogs/
> > 
> > merged for 6.5 and then the whole thing would work *completely*
> > correctly, but it might be too late now.
> 
> But actually I'm running test on your repair-fscounters branch[1], which
> seems to be the same thing as the patchsets you just show to me.  And the
> failure of xfs/730 happened.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-fscounters

Ahhh, ok.  #repair-fscounters shouldn't be doing that.  I'll take a
look and see if I can figure it out.  Do you have a dmesg from the
xfs/730 run?

--D

> 
> --
> Thanks,
> Ruan.
> 
> > 
> > --D
> > 
> > > 
> > > --
> > > Thanks,
> > > Ruan.
> > > 
> > > 在 2023/5/26 8:38, Darrick J. Wong 写道:
> > > > Hi all,
> > > > 
> > > > Now that we've landed the new kernel code, it's time to reorganize the
> > > > xfs_scrub code that handles repairs.  Clean up various naming warts and
> > > > misleading error messages.  Move the repair code to scrub/repair.c as
> > > > the first step.  Then, fix various issues in the repair code before we
> > > > start reorganizing things.
> > > > 
> > > > If you're going to start using this mess, you probably ought to just
> > > > pull from my git trees, which are linked below.
> > > > 
> > > > This is an extraordinary way to destroy everything.  Enjoy!
> > > > Comments and questions are, as always, welcome.
> > > > 
> > > > --D
> > > > 
> > > > xfsprogs git tree:
> > > > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-repair-fixes
> > > > ---
> > > >    scrub/phase1.c        |    2
> > > >    scrub/phase2.c        |    3 -
> > > >    scrub/phase3.c        |    2
> > > >    scrub/phase4.c        |   22 ++++-
> > > >    scrub/phase5.c        |    2
> > > >    scrub/phase6.c        |   13 +++
> > > >    scrub/phase7.c        |    2
> > > >    scrub/repair.c        |  177 ++++++++++++++++++++++++++++++++++++++++++-
> > > >    scrub/repair.h        |   16 +++-
> > > >    scrub/scrub.c         |  204 +------------------------------------------------
> > > >    scrub/scrub.h         |   16 ----
> > > >    scrub/scrub_private.h |   55 +++++++++++++
> > > >    scrub/xfs_scrub.c     |    2
> > > >    13 files changed, 283 insertions(+), 233 deletions(-)
> > > >    create mode 100644 scrub/scrub_private.h
> > > > 
