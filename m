Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB853C7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 03:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbjFFD6u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 23:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjFFD6t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 23:58:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF995187
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 20:58:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64436624EE
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 03:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5922C433EF;
        Tue,  6 Jun 2023 03:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686023926;
        bh=K8CZUF4lVHS4LtF1Bdpaw+aA6eAdE1I6wVltcAMFjOE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nlBvTJSTRoOJBZPyGjdPnJFPHVaPkFwkfJFsz5N07KmKZ6lqhElu9FrSZh98GjZ3u
         VVi2Mufszl9Ya4xPDd6Hg5eniYWMMyCmWYhxGQyS6EwEawVfq/X9t6P+ii7Yi0r24I
         l4of9iyPrfT3+/DmiqoSQaWzRS9F65sXw/OSjb+c7umxHnRysbQcwRa5mS40haXnnl
         HPW2o7S6Ga0GXYVFQ7ONERCTx5dz59GsqwdvIJYiKfyRDAhZgdklHUUI2Tqno3NmSN
         5xY+UvW3zZUxuiRhVNGmth/oyd6+tBnlRDwRQ2Hpv9p/G7Q6JqYj5iY+0R+lKFZB29
         MvzwgKm9mbWTw==
Date:   Mon, 5 Jun 2023 20:58:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfs: for-next rebased to d4d12c02bf5f
Message-ID: <20230606035846.GF72267@frogsfrogsfrogs>
References: <ZH1tiD4z4/revqp3@dread.disaster.area>
 <20230606000951.GK1325469@frogsfrogsfrogs>
 <ZH6E9+5uZNbnc4G3@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH6E9+5uZNbnc4G3@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 10:59:35AM +1000, Dave Chinner wrote:
> On Mon, Jun 05, 2023 at 05:09:51PM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 05, 2023 at 03:07:20PM +1000, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > I just rebased the for-next tree to correct a bad fixes tag in
> > > the tree that was flags by a linux-next sanity check. The code is
> > > the same, just a commit message needed rewriting, but that means all
> > > the commit change and you'll need to do forced update if you pulled
> > > the branch I pushed a few hours ago.
> > > 
> > > -Dave.
> > > 
> > > ----------------------------------------------------------------
> > > 
> > >   git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
> > > 
> > >   Head Commit: d4d12c02bf5f768f1b423c7ae2909c5afdfe0d5f
> > > 
> > >   xfs: collect errors from inodegc for unlinked inode recovery (2023-06-05 14:48:15 +1000)
> > > 
> > > ----------------------------------------------------------------
> > > Darrick J. Wong (1):
> > >       xfs: fix broken logic when detecting mergeable bmap records
> > > 
> > > Dave Chinner (9):
> > >       xfs: buffer pins need to hold a buffer reference
> > >       xfs: restore allocation trylock iteration
> > >       xfs: defered work could create precommits
> > >       xfs: fix AGF vs inode cluster buffer deadlock
> > >       xfs: fix double xfs_perag_rele() in xfs_filestream_pick_ag()
> > >       xfs: fix agf/agfl verification on v4 filesystems
> > >       xfs: validity check agbnos on the AGFL
> > >       xfs: validate block number being freed before adding to xefi
> > >       xfs: collect errors from inodegc for unlinked inode recovery
> > > 
> > > Geert Uytterhoeven (1):
> > >       xfs: Fix undefined behavior of shift into sign bit
> > 
> > Hmm, I don't see "xfs: fix ag count overflow during growfs" in here.
> 
> No, I didn't pick it up because it conflicted with other bug fix
> stuff I am currently working on and I needed to look at it in more
> detail before doing anything with it. I hadn't followed the
> development of the patch at all, and it was up to v4 so I was going
> to need to spend a little bit of time on it to see what the history
> of it was first....

Ah, ok.  Most of the history was the author and I going 'round and
'round about how to validate the incoming fsblocks to prevent agcount
overflow without stomping on any other weird uses.

> > Dave, do you want to do another 6.4 bug release, or throw things back
> > over the wall so I can merge all the rest of the pending fixes for 6.5?
> 
> If you want, you can pick it up once I've sent a pull request for
> the current set of fixes in for-next. That will be later this week;
> it needs to spend a couple of days in linux-next before that
> happens, though.

Yeah, sounds good to me.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
