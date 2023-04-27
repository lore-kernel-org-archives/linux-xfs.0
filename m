Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE766C77B73
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Apr 2023 15:07:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243412AbjD0PHG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 11:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243404AbjD0PHG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 11:07:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF4E1992
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 08:07:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 772C06177E
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 15:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAA9C433EF;
        Thu, 27 Apr 2023 15:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682608023;
        bh=aAif6VsaTleQkj9Y6xmlPA+keujvH3/W4QnlESFDyF4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gzBjrtcURVvcnVNeIRqa6CxZug4Zuirzs0eeIskOjoGvEZHA69eycu2A/V+Uzo+1E
         0zTUtSQccusWfXh+z+L1kwD+GpLwoqr6EvdZbXZ4UUKcEo30ASe4cX8mZN4byuchyo
         +CNs50XLCFwfVIDV30flLRUaarZl4rAwujeTJhBu/i4fOzJk7pgt/dH/SMt6HSOwov
         RJqu35c7EV5kMRX/FIsagIaI2ahcB9k1kAXcqI+ekvgwfz1n2IBK2avkvBg139ZOB2
         M9NYVU/6BiWg8xWfiqd7Nmq2ZxAWZNEoNoCwTqzs93UOkNIXboVh85RPNvexTAN2M+
         ElBGqdoHTYZqQ==
Date:   Thu, 27 Apr 2023 08:07:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH] xfs: fix livelock in delayed allocation at ENOSPC
Message-ID: <20230427150703.GD59245@frogsfrogsfrogs>
References: <20230421222440.2722482-1-david@fromorbit.com>
 <20230425152052.GT360889@frogsfrogsfrogs>
 <20230426230135.GJ3223426@dread.disaster.area>
 <20230426233831.GB59245@frogsfrogsfrogs>
 <20230427001124.GL3223426@dread.disaster.area>
 <20230427005333.GC59245@frogsfrogsfrogs>
 <20230427052600.GM3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427052600.GM3223426@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 27, 2023 at 03:26:00PM +1000, Dave Chinner wrote:
> On Wed, Apr 26, 2023 at 05:53:33PM -0700, Darrick J. Wong wrote:
> > On Thu, Apr 27, 2023 at 10:11:24AM +1000, Dave Chinner wrote:
> > > On Wed, Apr 26, 2023 at 04:38:31PM -0700, Darrick J. Wong wrote:
> > > > I also added a su=128k,sw=4 config to the fstests fleet and am now
> > > > trying to fix all the fstests bugs that produce incorrect test failures.
> > > 
> > > The other thing I noticed is a couple of the FIEMAP tests fail
> > > because they find data blocks where they expect holes such as:
> > > 
> > > generic/225 21s ... - output mismatch (see /home/dave/src/xfstests-dev/results//xfs_align/generic/225.out.bad)
> > >     --- tests/generic/225.out   2022-12-21 15:53:25.479044361 +1100
> > >     +++ /home/dave/src/xfstests-dev/results//xfs_align/generic/225.out.bad      2023-04-26 04:24:31.426016818 +1000
> > >     @@ -1,3 +1,79 @@
> > >      QA output created by 225
> > >      fiemap run without preallocation, with sync
> > >     +ERROR: FIEMAP claimed there was data at a block which should be a hole, and FIBMAP confirmend that it is in fact a hole, so FIEMAP is wrong: 35
> > >     +ERROR: found an allocated extent where a hole should be: 35
> > >     +map is 'DHDDHHDDHDDHHHHDDDDDHHHHHHHDHDDDHHDHDHHHHHDDHDDHHDDHDHHDDDHHHHDDDDHDHHDDHHHDDDDHHDHDDDHHDHDDDHDHHHHHDHDHDHDHHDDHDHHHHDHHDDDDDDDH'
> > >     +logical: [      27..      27] phys:       67..      67 flags: 0x000 tot: 1
> > >     +logical: [      29..      31] phys:       69..      71 flags: 0x000 tot: 3
> > >     ...
> > >     (Run 'diff -u /home/dave/src/xfstests-dev/tests/generic/225.out /home/dave/src/xfstests-dev/results//xfs_align/generic/225.out.bad'  to see the entire diff)
> > > 
> > > I haven't looked into this yet, but nothing is reporting data
> > > corruptions so I suspect it's just the stripe aligned allocation
> > > leaving unwritten extents in places the test is expecting holes to
> > > exist...
> > 
> > That's the FIEMAP tester program not expecting that areas of the file
> > that it didn't write to can have unwritten extents mapped.  I'm testing
> > patches to fix all that tonight too.  If I can ever get these %#@%)#%!!!
> > orchestration scripts to work correctly.
> 
> OK.
> 
> FWIW, I've just found another bug in the stripe aligned allocation
> at EOF that is triggered by the filestreams code hitting ENOSPC
> conditions. xfs/170 seems to hit it fairly reliably - it's marking
> args->pag as NULL and not resetting the caller pag correctly and the
> high level filestreams failure code is expecting args->pag to be set
> because it owns the reference...
> 
> I hope to have a fix for that one on the list this afternoon....

Oh, yeah, I hit that one too.  I'll send out my fixes after the ext4
concall and we can sync up on that.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
