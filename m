Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A3B0CCA47C
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 22:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiF2Wqb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 18:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiF2Wqb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 18:46:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B45524BC4;
        Wed, 29 Jun 2022 15:46:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D8C1B8273A;
        Wed, 29 Jun 2022 22:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5700C34114;
        Wed, 29 Jun 2022 22:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656542788;
        bh=jlWEBxTA+78qIcBBIfVPqBhxMl94CBba9i9NTXXFHWc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nDqpMRTYy78K8WHc9lbLsqQM6Ub1if9oUv6JgwEWHa0Yh28aGoGobroiTVkdyIiXk
         xCzbrLttn+DSeGs8UO/17F0lEJFR88e0tcLz8rMTJZdRaxIuu8C8mFkcDucl/ymaJs
         rJxj2YJOhoPMnwuJRcNS0AX4JSw5ih9gyFZBE67v7EuSEaXX+oiusDq32yoAcgBLEE
         lOlzMzJ5iY9nHiW+smhLfsW94E46Q1TWgejkHrx6CFlALveKqxtKRluGbXTkODG9td
         3lYhRkdr+e2kuySvYfujhOhzJVNkK2thfH40Evq3i4SNsrOFOLwtGoknVqR+frQ6Mn
         BxhOP7wxVb4Pg==
Date:   Wed, 29 Jun 2022 15:46:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 4/9] xfs: test xfs_copy doesn't do cached read before
 libxfs_mount
Message-ID: <YrzWQz0Y5pWppa0Z@magnolia>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
 <165644770013.1045534.5572366430392518217.stgit@magnolia>
 <20220629042045.GQ1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629042045.GQ1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 29, 2022 at 02:20:45PM +1000, Dave Chinner wrote:
> On Tue, Jun 28, 2022 at 01:21:40PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This is a regression test for an xfs_copy fix that ensures that it
> > doesn't perform a cached read of an XFS filesystem prior to initializing
> > libxfs, since the xfs_mount (and hence the buffer cache) isn't set up
> > yet.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/844     |   33 +++++++++++++++++++++++++++++++++
> >  tests/xfs/844.out |    3 +++
> >  2 files changed, 36 insertions(+)
> >  create mode 100755 tests/xfs/844
> >  create mode 100644 tests/xfs/844.out
> > 
> > 
> > diff --git a/tests/xfs/844 b/tests/xfs/844
> > new file mode 100755
> > index 00000000..688abe33
> > --- /dev/null
> > +++ b/tests/xfs/844
> > @@ -0,0 +1,33 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 844
> > +#
> > +# Regression test for xfsprogs commit:
> > +#
> > +# XXXXXXXX ("xfs_copy: don't use cached buffer reads until after libxfs_mount")
> > +#
> 
> This needs more of an explanation of why empty files are being
> copied here, because it's not obvious why we'd run xfs_copy on
> them...

Oops, I forgot to explain what this thing is actually testing.

> > +. ./common/preamble
> > +_begin_fstest auto copy
> 
> Wouldn't this also be quick?

Yeah.  Will fix both and resubmit.

--D

> Otherwise looks fine.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
