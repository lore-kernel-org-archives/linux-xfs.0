Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9451BC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 00:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53930619AC
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 00:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhCWAYq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 20:24:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230166AbhCWAYR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Mar 2021 20:24:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0630C619AD;
        Tue, 23 Mar 2021 00:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616459057;
        bh=if9n/AL2aKDfR+a+lygaAFyfV0FeEVKeH1FfsMNrdUg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MYofhGL1cFnEjAP9voy0qe4gjpdLTOFbRQWRSNnNweY5hwXh+MV0jJVya8hBLmYkv
         FgFkqJFXGRbZ9e4h9dt4k3plyz56+24njYlF95gmbWmrc2qPkm94wk9cpdCvu6Q+ww
         SBrVGB0Ynvu8IN6Vk/Z+wiY1e96vWWN+pqFfmrA34xcv3PFNzOPatQ+isZCaDEy00Z
         ebkhcmdFt7wLyAMdtIPcp666HTMD/Wl9SKrPUoKTESfLe6NToLz9sWdk0w7MV2Nz95
         mMC/7cv1bvQNAgkFb3rmUITFMr5aSIb4139Y02KnBNuItcbR69kV5g7nvH6WsuqX2l
         ydmNFszzDDncQ==
Date:   Mon, 22 Mar 2021 17:24:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: deferred inode inactivation
Message-ID: <20210323002414.GH22100@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543197372.1947934.1230576164438094965.stgit@magnolia>
 <20210316072710.GA375263@infradead.org>
 <20210316154729.GI22100@magnolia>
 <20210322233721.GA63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322233721.GA63242@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 23, 2021 at 10:37:21AM +1100, Dave Chinner wrote:
> On Tue, Mar 16, 2021 at 08:47:29AM -0700, Darrick J. Wong wrote:
> > On Tue, Mar 16, 2021 at 07:27:10AM +0000, Christoph Hellwig wrote:
> > > Still digesting this.  What trips me off a bit is the huge amount of
> > > duplication vs the inode reclaim mechanism.  Did you look into sharing
> > > more code there and if yes what speaks against that?
> > 
> > TBH I didn't look /too/ hard because once upon a time[1] Dave was aiming
> > to replace the inode reclaim tagging and iteration with an lru list walk
> > so I decided not to entangle the two.
> > 
> > [1] https://lore.kernel.org/linux-xfs/20191009032124.10541-23-david@fromorbit.com/
> 
> I prototyped that and discarded it - it made inode reclaim much,
> much slower because it introduced delays (lock contention) adding
> new inodes to the reclaim list while a reclaim isolation walk was in
> progress.
> 
> The radix tree based mechanism we have right now is very efficient
> as only the inodes being marked for reclaim take the radix tree
> lock and hence there is minimal contention for it...

Ahah, that's what happened to that patchset.  Well in that case, since
xfs_reclaim_inodes* is going to stick around, I think it makes more
sense to refactor xfs_inodes_walk_ag to handle XFS_ICI_RECLAIM_TAG, and
then xfs_reclaim_inodes_ag can go away entirely.

That said, xfs_reclaim_inodes_ag does have some warts (like updating the
per-ag reclaim cursor and decrementing nr_to_scan) that would add
clutter.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
