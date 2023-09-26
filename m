Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBAD6E7E63F
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Sep 2023 14:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbjIZOrX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 10:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234692AbjIZOrX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 10:47:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9026BE6;
        Tue, 26 Sep 2023 07:47:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306A3C433C8;
        Tue, 26 Sep 2023 14:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695739636;
        bh=inXi6ZAwWzjMX4yQU8aAAj2I6MiBQgUSliMpdnwMkno=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nGixRUojFaDmfxLxFivFCy5iRNhzf7wA7KPBzqS9cVbiqzqKsi5tDl75S+RkztGn4
         Jnt+GrRdQHIfUzezO72qDLfydbxY3CAqgnX2AcYRld501dZZbqtKrz2S3gQCnKeB8/
         l4pT2OuSPIHnJmeYi3+ZWl/wkPrQMQL/0hYTSm/W91TgS2kquQgxBko4/lZjc3FiC6
         dhIaJLSbGckSvxAHznGU1ayTQcGVBSE4E/rMkSR26DvLLK6Pthvl2MDPdxp+EVcOcn
         emLaW6buQMvfkXBhFjs1KPhEfgx0jUGe1tWBQ2s4m0iNQ8FcxO0tB/Jci6OQPNkvjX
         h9nELBm62sCOw==
Date:   Tue, 26 Sep 2023 07:47:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, willy@infradead.org
Subject: Re: [PATCH 1/1] generic: test FALLOC_FL_UNSHARE when pagecache is
 not loaded
Message-ID: <20230926144715.GD11456@frogsfrogsfrogs>
References: <169567819441.2270025.10851897053852323695.stgit@frogsfrogsfrogs>
 <87h6nh5x2o.fsf@doe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h6nh5x2o.fsf@doe.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 26, 2023 at 10:51:19AM +0530, Ritesh Harjani wrote:
> "Darrick J. Wong" <djwong@kernel.org> writes:
> 
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Add a regression test for funsharing uncached files to ensure that we
> > actually manage the pagecache state correctly.
> >
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/1936     |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/1936.out |    4 ++
> >  2 files changed, 92 insertions(+)
> >  create mode 100755 tests/xfs/1936
> >  create mode 100644 tests/xfs/1936.out
> >
> >
> > diff --git a/tests/xfs/1936 b/tests/xfs/1936
> > new file mode 100755
> > index 0000000000..e07b8f4796
> > --- /dev/null
> > +++ b/tests/xfs/1936
> > @@ -0,0 +1,88 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2023 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 1936
> > +#
> > +# This is a regression test for the kernel commit noted below.  The stale
> > +# memory exposure can be exploited by creating a file with shared blocks,
> > +# evicting the page cache for that file, and then funshareing at least one
> > +# memory page's worth of data.  iomap will mark the page uptodate and dirty
> > +# without ever reading the ondisk contents.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick unshare clone
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -r -f $tmp.* $testdir
> > +}
> > +
> > +# real QA test starts here
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/attr
> 
> We might as well remove above imports if we are not using those in this test.

<nod>

> > +. ./common/reflink
> > +
> > +_fixed_by_git_commit kernel XXXXXXXXXXXXX \
> > +	"iomap: don't skip reading in !uptodate folios when unsharing a range"
> 
> Once I guess it is merged, we will have the commit-id. Ohh wait, we have
> it already right? 
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=35d30c9cf12730a1e37053dfde4007c7cc452d1a

Oops, yeah, I'll update the tag.

> With that the testcode looks good to me. Thanks for finding an easy
> reproducer. Please feel free to add - 
> 
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Thanks!

> -ritesh
