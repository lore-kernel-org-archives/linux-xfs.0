Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00FF5C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 16:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355550AbiFVQfY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 12:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiFVQfY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 12:35:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611F021269
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 09:35:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10078B82049
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 16:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76365C34114;
        Wed, 22 Jun 2022 16:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655915720;
        bh=5INwBH1eT3uuUhDUHLcWKU5dC/YhqfvElmYfQRuSFNI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EPZxwNqwPvdzUTGzmV9LyGBiP6uaLgBGRxEWYmFm577sXw0VF8+Z0CP36hafhE0no
         5uhCxU7r4fBv36xMvz8mazuJgpM+gLV2rszP8+ppreYbw8gpw+fqtYSvAil6K42z5p
         uNTeYIX5rxBf64nGxS0as97YnOFiP2nSwyKe1e1EQqhX8Hc+TcgUxFG45Pd4yUrK6S
         qhAFsY1zJBBcSHzmSFZiq/Ri3lPN3hQHTsPArjC9PqpUb1Z6O38Xfsna4BRdhdRKDH
         CxP9RRd1sR0zBT4+6pl163/SxLv/4mOo27As7ff+1HtRAhW5LWdqMCB7p0hNiXUO2w
         /uXgvHXq6ZWVQ==
Date:   Wed, 22 Jun 2022 09:35:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     linux-xfs@vger.kernel.org, mcgrof@kernel.org
Subject: Re: [PATCH 5.15 CANDIDATE v2 0/8] xfs stable candidate patches for
 5.15.y (part 1)
Message-ID: <YrNExw1XTTD1dJET@magnolia>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
 <YrNB65ISwFDgLT4O@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrNB65ISwFDgLT4O@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 22, 2022 at 09:23:07AM -0700, Darrick J. Wong wrote:
> On Thu, Jun 16, 2022 at 11:27:41AM -0700, Leah Rumancik wrote:
> > The patch testing has been increased to 100 runs per test on each 
> > config. A baseline without the patches was established with 100 runs 
> > to help detect hard failures / tests with a high fail rate. Any 
> > failures seen in the backports branch but not in the baseline branch 
> > were then run 1000+ times on both the baseline and backport branches 
> > and the failure rates compared. The failures seen on the 5.15 
> > baseline are listed at 
> > https://gist.github.com/lrumancik/5a9d85d2637f878220224578e173fc23. 
> > No regressions were seen with these patches.
> > 
> > To make the review process easier, I have been coordinating with Amir 
> > who has been testing this same set of patches on 5.10. He will be 
> > sending out the corresponding 5.10 series shortly.
> > 
> > Change log from v1 
> > (https://lore.kernel.org/all/20220603184701.3117780-1-leah.rumancik@gmail.com/):
> > - Increased testing
> > - Reduced patch set to overlap with 5.10 patches
> > 
> > Thanks,
> > Leah
> > 
> > Brian Foster (1):
> >   xfs: punch out data fork delalloc blocks on COW writeback failure
> > 
> > Darrick J. Wong (4):
> >   xfs: remove all COW fork extents when remounting readonly
> >   xfs: prevent UAF in xfs_log_item_in_current_chkpt
> >   xfs: only bother with sync_filesystem during readonly remount
> 
> 5.15 already has the vfs fixes to make sync_fs/sync_filesystem actually
> return error codes, right?
> 
> >   xfs: use setattr_copy to set vfs inode attributes
> > 
> > Dave Chinner (1):
> >   xfs: check sb_meta_uuid for dabuf buffer recovery
> > 
> > Rustam Kovhaev (1):
> >   xfs: use kmem_cache_free() for kmem_cache objects
> > 
> > Yang Xu (1):
> >   xfs: Fix the free logic of state in xfs_attr_node_hasname
> 
> This one trips me up every time I look at it, but this looks correct.
> 
> If the answer to the above question is yes, then:
> Acked-by: Darrick J. Wong <djwong@kernel.org>

I should've mentioned that this is acked-by for patches 1-7, since Amir
posted a question about patch 8 that seems not to have been answered(?)

(Do all the new setgid inheritance tests actually pass with patch 8
applied?  The VFS fixes were thorny enough that I'm not as confident
that they've all been applied to 5.15.y...)

--D

> --D
> 
> > 
> >  fs/xfs/libxfs/xfs_attr.c      | 17 +++++------
> >  fs/xfs/xfs_aops.c             | 15 ++++++++--
> >  fs/xfs/xfs_buf_item_recover.c |  2 +-
> >  fs/xfs/xfs_extfree_item.c     |  6 ++--
> >  fs/xfs/xfs_iops.c             | 56 ++---------------------------------
> >  fs/xfs/xfs_log_cil.c          |  6 ++--
> >  fs/xfs/xfs_pnfs.c             |  3 +-
> >  fs/xfs/xfs_super.c            | 21 +++++++++----
> >  8 files changed, 47 insertions(+), 79 deletions(-)
> > 
> > -- 
> > 2.36.1.476.g0c4daa206d-goog
> > 
