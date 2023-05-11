Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE613C77B7F
	for <linux-xfs@archiver.kernel.org>; Thu, 11 May 2023 18:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239133AbjEKSJh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 May 2023 14:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239082AbjEKSJf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2023 14:09:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D38A5EB
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2023 11:09:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C533B6508B
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2023 18:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33631C433EF;
        Thu, 11 May 2023 18:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683828492;
        bh=JUt2ZPDGf8SS7NMiHPABE5G79iI6RetEFwvaJsqC1j4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o1IRcGfF7sPtqITBbXR/NNsmkbSsNZuvZ7WzwnJVYs0py/csZ9OvLhm+1Rplt3kOb
         uWE3tSmaOj4KM2C3lt5ozmzhcOyENxkEHha+jqTdFzkbc7mTDQFxbkKKIrjHzOKthP
         h2E3PLBhPrA9TdeBwqrfZB2Wr2UdRDHg4DtnCEE1GsResZ3YG9ENxj+DwF2l9RqNYi
         1mOLSn71p1YjXO2rh4Pclue5uctcmibUAJXjBVU3aIDfsJ72l4sfA+6GDbWVs/WOC9
         Vi/Iz8LVDq1J2wvs8UfVAyrn/i6L9TgM6+2VsHKwN+9F2535FZpOKhVLWZKzJ2Kdvd
         Dume1XLYEZeCg==
Date:   Thu, 11 May 2023 11:08:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: bug fixes for 6.4-rc2
Message-ID: <20230511180811.GF858799@frogsfrogsfrogs>
References: <20230511015846.GH2651828@dread.disaster.area>
 <20230511020107.GI2651828@dread.disaster.area>
 <CAHk-=wjJ1veddRdTUs5BfofupuPxMoVHBUbAOmHw6p4pXPq5FQ@mail.gmail.com>
 <20230511165029.GE858799@frogsfrogsfrogs>
 <CAHk-=wh6ze_y5_Q89VOuruDnenSVmN4fL1J-rh-vovmrDkxaQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wh6ze_y5_Q89VOuruDnenSVmN4fL1J-rh-vovmrDkxaQw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 11, 2023 at 12:47:16PM -0500, Linus Torvalds wrote:
> On Thu, May 11, 2023 at 11:50 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > ...and which version is that?  The build robot report just says ia64
> > without specifying any details about what compiler was running, etc:
> 
> Actually, you should find it if you follow the links to the config.

The link in the 9 May report:

https://lore.kernel.org/oe-kbuild-all/202304140707.CoH337Ux-lkp@intel.com/

goes to an old report from 14 April involving gcc 12.1 on powerpc and
doesn't mention xfs at all.

> We have the compiler version saved in the config file partly exactly
> for reasons like that.
> 
> HOWEVER.
> 
> If it's *this* report:
> 
> > https://lore.kernel.org/linux-xfs/20230510165934.5Zgh4%25lkp@intel.com/T/#u
> 
> then don't even worry about it.
> 
> That's not even a compiler warning - that "ignoring unreachable code"
> is from smatch.
> 
> So if *that* single line of
> 
>    fs/xfs/scrub/fscounters.c:459 xchk_fscounters() warn: ignoring
> unreachable code.
> 
> was all this was about, then there are no worries with that pull request.
> 
> Those extra warnings (some of them compiler warnings enabled with W=2
> for extra warnings, some from smatch) are not a cause for worry. They
> are janitorial.
> 
> I thought you had an actual failed build report due to some warning.
> Those we *do* need to fix, exactly because they will affect other
> peoples ability to do basic sanity testing.

AFAICT there aren't any actual build failures, just the smatch warning.

> So if you can confirm that it was just that one smatch warning line
> and nothing else, then I'll happily do that pull.

Yes, it is the smatch warning.  Sprinkling #if 0's everywhere makes
the smatch warning go away, but the "shut up the warnings" fix isn't
necessarily better:

diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index e382a35e98d8..09101ba0aae3 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -165,6 +165,7 @@ xchk_setup_fscounters(
  * xchk_*_process_error.
  */
 
+#if 0
 /* Count free space btree blocks manually for pre-lazysbcount filesystems. */
 static int
 xchk_fscount_btreeblks(
@@ -349,6 +350,7 @@ xchk_fscount_count_frextents(
 	return 0;
 }
 #endif /* CONFIG_XFS_RT */
+#endif /* 0 */
 
 /*
  * Part 2: Comparing filesystem summary counters.  All we have to do here is
@@ -422,7 +424,6 @@ xchk_fscounters(
 	struct xfs_mount	*mp = sc->mp;
 	struct xchk_fscounters	*fsc = sc->buf;
 	int64_t			icount, ifree, fdblocks, frextents;
-	int			error;
 
 	/* Snapshot the percpu counters. */
 	icount = percpu_counter_sum(&mp->m_icount);
@@ -449,9 +450,11 @@ xchk_fscounters(
 	/*
 	 * XXX: We can't quiesce percpu counter updates, so exit early.
 	 * This can be re-enabled when we gain exclusive freeze functionality.
+	 * Use preprocessor crud to avoid warnings about unreachable code
+	 * since we'd rather leave the git history of the (now unused) code
+	 * intact until we can fix the problem.
 	 */
-	return 0;
-
+#if 0
 	/*
 	 * If ifree exceeds icount by more than the minimum variance then
 	 * something's probably wrong with the counters.
@@ -488,5 +491,6 @@ xchk_fscounters(
 			fsc->frextents))
 		xchk_set_corrupt(sc);
 
+#endif
 	return 0;
 }

--D

>             Linus
