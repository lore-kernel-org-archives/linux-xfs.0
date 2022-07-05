Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D32A1C43334
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jul 2022 22:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiGEWES (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 18:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGEWER (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 18:04:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B948B13FBA;
        Tue,  5 Jul 2022 15:04:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EC666189F;
        Tue,  5 Jul 2022 22:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5313C341C7;
        Tue,  5 Jul 2022 22:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657058655;
        bh=T7i588ZsyHJD4g+O/eQ4nO+FLpQgn4LP5zOw1vFogT8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hysc5fU/ubTjc5ifaCe7l53XKUAV9rVYDzsc/oKfAtERocHBRIZm94zILNL4r3zYh
         V9kdx2eDTaTaIZvKdkZZzMT1GS3NkE32/OoH6uPqbFHABPAkJ+/CmHX9QBIROHGq0h
         3AjrH+y3n03QtqBD+LCGdt1DvE4i6CmCgH9Aybo4DZ3X9whWMngBW+DZhBC4cF9ldf
         PY6Md8+HXOyPDb6/KZ/tJOLEGYyIrHac0rCRy8qQcaA5Uy5sr8hWnweCA0bckRWl9n
         aQiyjWdA6R9dxqax9xHvmo1lcLk3z3YRKigz5STBpkH3uN1TyCqlh318L5AjYZQOvH
         B+HQVXVnKMCIg==
Date:   Tue, 5 Jul 2022 15:04:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCHSET 0/9] fstests: random fixes
Message-ID: <YsS1X5Q4kDmIexhY@magnolia>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
 <20220705142840.gycwt264xrda3bkr@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705142840.gycwt264xrda3bkr@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 05, 2022 at 10:28:40PM +0800, Zorro Lang wrote:
> On Tue, Jun 28, 2022 at 01:21:17PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Here's the usual batch of odd fixes for fstests.
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees, which are linked below.
> > 
> > This is an extraordinary way to destroy everything.  Enjoy!
> > Comments and questions are, as always, welcome.
> > 
> > --D
> 
> Hi Darrick,
> 
> JFYI, to push the proceeding of your patch merging, I've merged/pushed this
> patchset, except patch 7/9 and 9/9 due to they haven't gotten any review.
> I can review them, but patch 7/9 changes the case which Dave might care about,
> so I'd like to wait more response.
> 
> Feel free to send these 2 patches with more your new patches, if you'd like to
> do that :)

Done.  Thanks for taking last week's bundle, btw.

--D

> Thanks,
> Zorro
> 
> > 
> > kernel git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes
> > 
> > xfsprogs git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes
> > 
> > fstests git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
> > ---
> >  check                  |    3 +++
> >  common/repair          |    1 +
> >  src/seek_sanity_test.c |   12 ++++++++++-
> >  tests/xfs/018          |   52 +++++++++++++++++++++++++++++++++++++++++++-----
> >  tests/xfs/018.out      |   16 ++++-----------
> >  tests/xfs/109          |    2 +-
> >  tests/xfs/166          |   19 ++++++++++++++----
> >  tests/xfs/547          |   14 +++++++++----
> >  tests/xfs/843          |   51 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/843.out      |    2 ++
> >  tests/xfs/844          |   33 ++++++++++++++++++++++++++++++
> >  tests/xfs/844.out      |    3 +++
> >  12 files changed, 181 insertions(+), 27 deletions(-)
> >  create mode 100755 tests/xfs/843
> >  create mode 100644 tests/xfs/843.out
> >  create mode 100755 tests/xfs/844
> >  create mode 100644 tests/xfs/844.out
> > 
> 
