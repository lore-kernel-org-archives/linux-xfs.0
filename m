Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD7DC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 20:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 487A06135A
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 20:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbhESUsO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 16:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229379AbhESUsO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 May 2021 16:48:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AAA360FE6;
        Wed, 19 May 2021 20:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621457214;
        bh=bnGuqs3ZY6S9vaC6i0HkcRvJzuSf/c7KKfH2pqisZkU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OjdZ7YJCIDEjdxir9mCw9Q+wCkjtCwHwonq5Msp+SJ+8GvQjXsEP5kNLYba1j4sDz
         1ny7FWVJTnFH36vrYNOyHS+F7VYFEN9WZr5fevhRsP5kH7AFYgEOTSjPy2zaLSMR1b
         hLi+HD6stPD2KsyWCcJ6HEqOh+T7o4TvqOWRMg2uuR8icu8FrfSpKrXhxluJ3LO0Cf
         Q01JzZ4pT+3bZWECJDWtj4NKJVbetj06+ewaTRNl/3cJkFv0M8x90Ibs8L7wpFb2T/
         zq7eUQF9Z6jMEYHaieTIeGcI2IFAk9N+tn0ZgSfpnnYGqDUDtfrQFhyOaDXlaA35GC
         GzjoDpbwLoILg==
Date:   Wed, 19 May 2021 13:46:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <eguan@linux.alibaba.com>
Cc:     Eryu Guan <guan@eryu.me>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/8] common/xfs: refactor commands to select a particular
 xfs backing device
Message-ID: <20210519204653.GC9648@magnolia>
References: <162078489963.3302755.9219127595550889655.stgit@magnolia>
 <162078491108.3302755.3627499639796540923.stgit@magnolia>
 <YKE/I0HE+2MNSCCG@desktop>
 <20210516203437.GS9675@magnolia>
 <20210519030324.GB60846@e18g06458.et15sqa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519030324.GB60846@e18g06458.et15sqa>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 11:03:24AM +0800, Eryu Guan wrote:
> On Sun, May 16, 2021 at 01:34:37PM -0700, Darrick J. Wong wrote:
> > On Sun, May 16, 2021 at 11:49:55PM +0800, Eryu Guan wrote:
> > > On Tue, May 11, 2021 at 07:01:51PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Refactor all the places where we try to force new file data allocations
> > > > to a specific xfs backing device so that we don't end up open-coding the
> > > > same xfs_io command lines over and over.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  common/populate   |    2 +-
> > > >  common/xfs        |   25 +++++++++++++++++++++++++
> > > >  tests/generic/223 |    3 ++-
> > > >  tests/generic/449 |    2 +-
> > > >  tests/xfs/004     |    2 +-
> > > 
> > > >  tests/xfs/088     |    1 +
> > > >  tests/xfs/089     |    1 +
> > > >  tests/xfs/091     |    1 +
> > > >  tests/xfs/120     |    1 +
> > > >  tests/xfs/130     |    1 +
> > > 
> > > I think above updates should be in a separate patch.
> > 
> > Why?
> 
> This patch is refactoring open-coded command into a helper, which should
> not change the logic. But above changes are adding new users of this
> helper and change test behavior. So I think they should be in a separate
> patch for review.

Oh, ok.  Will do then.

--D

> Thanks,
> Eryu
