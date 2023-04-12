Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C6F2C7619A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 22:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjDLWEu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 18:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjDLWEq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 18:04:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB8383F7
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 15:04:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5172263992
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 22:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9ECC433D2;
        Wed, 12 Apr 2023 22:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681337074;
        bh=0lx67Z08J3aeaVS3BgiU46n/bEcuUlSMbrnWB+SVmTI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=khPIQoPnjXIucnPJaG80Qsqj5M/geVJ6WgbsLPorMevX0QgFkjfDvbzMaENwENLfF
         rLIBDMSXgB7pY95vRd0uef4ewoneJab/SbYnriqiqAcC8BXcd4fsrZqRzu2ztQBbGq
         Y9jcMikgH0vpgt6Rp76nTrjQUEalzAkp/wEOyEETBNJOW4wov947LZED2cbktyrTAi
         +FIGR+F6nJFN6xtP6V4iuE6Hn9a06792ysB27/ON/ELukpM/Arr7xdgtokzwEdrShW
         oWiv+Pcmqtd1ANuOyL8BmptvYrFSAJ5JQ0h6lCLwvHM8eK4wsg6dPth0up252g57L0
         cr4OibGqJFImA==
Date:   Wed, 12 Apr 2023 15:04:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 4/6] xfs_db: fix metadump name obfuscation for ascii-ci
 filesystems
Message-ID: <20230412220434.GK360895@frogsfrogsfrogs>
References: <168073977341.1656666.5994535770114245232.stgit@frogsfrogsfrogs>
 <168073979582.1656666.4211101901014947969.stgit@frogsfrogsfrogs>
 <ZDTpBtMlSsxRJjRh@infradead.org>
 <20230411153546.GH360889@frogsfrogsfrogs>
 <ZDaflBeCxSMx/kJd@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDaflBeCxSMx/kJd@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 12, 2023 at 05:09:56AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 11, 2023 at 08:35:46AM -0700, Darrick J. Wong wrote:
> > > obsfucate some names this really seems horribly ugly.  I could
> > > come up with ideas to fix some of that, but they'd be fairly invasive.
> > 
> > Given that it's rol7 and xoring, I'd love it if someone came up with a
> > gentler obfuscate_name() that at least tried to generate obfuscated
> > names that weren't full of control characters and other junk that make
> > ls output horrible.
> > 
> > Buuuut doing that requires a deep understanding of how the math works.
> > I think I've almost grokked it, but applied math has never been my
> > specialty.  Mark Adler's crc spoof looked promising if we ever follow
> > through on Dave's suggestion to change the dahash to crc32c, but that's
> > a whole different discussion.
> 
> Agreed on all counts.
> 
> > > Is there any reason we need to support obsfucatation for ascii-ci,
> > > or could we just say we require "-o" to metadump ascii-ci file systems
> > > and not deal with this at all given that it never actually worked?
> > 
> > That would be simpler for metadump, yes.
> > 
> > I'm going to introduce a followup series that adds a new xfs_db command
> > to generate obfuscated filenames/attrs to exercise the dabtree hash
> > collision resolution code.  I should probably do that now, since I
> > already sent xfs/861 that uses it.
> > 
> > It wouldn't be the end of the world if hashcoll didn't work on asciici
> > filesystems, but that /would/ be a testing gap.
> 
> Do we really care about that testing gap for a feature you just
> deprecated and which has been pretty broken all this time?

I don't, and am perfectly happy to send an alternate patch that errors
out if you try to obfuscate an asciici filesystem.  Or maybe doesn't
even error out, since names less than 5 letters aren't obfuscated, so
it's not like we're hiding things effectively anyway.

That said, Carlos is the maintainer, so let's let him decide. :D

1) Gross loopy code; or
2) Less test coverage of broken code; or
3) Control gross loopy code with a flag so that debugger commands can
   still do gross things, but metadump won't.

--D
