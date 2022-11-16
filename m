Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06894C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Nov 2022 02:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbiKPCtX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Nov 2022 21:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiKPCtT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2022 21:49:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06C71E72F
        for <linux-xfs@vger.kernel.org>; Tue, 15 Nov 2022 18:49:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DA50B81BAE
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 02:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E764C433C1;
        Wed, 16 Nov 2022 02:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668566955;
        bh=+SAb/4zkikv2mQ+2h+T71xFsCsyvUsee8qGJiArzI2s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BIapHd2mF4VkeEBhU/nAqrnMz8a/ns9j6BFX4V/aXHhM+LlzlwmB2aUv6zofyaKjK
         p3nEnHl42vf2x+rE/ncLPZ9qOFFY+ZpDUNYnjqun/UrZZ/jKDzg3wp88rwq8EI3YhQ
         v6BWupNeb+5YWr7QjnUOIvEb8+C9R2VVgjdqLKziU7dnIF/ExH0MpAd+7OVwxUfrPA
         UqtCZv0vr+BBs8Fb0DeL9IEY2yctafAuapkNSDK7vhkJXl/FXSAhL5veQsE29/hv47
         XUtK5LAz58JYRfXZeTTAQc/anoQfnK1fIO0uempC/rkh+2UUQpoO165ZRB9yTPs/Al
         t4U65CWXXwZlg==
Date:   Tue, 15 Nov 2022 18:49:14 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: retain the AGI when we can't iget an inode to
 scrub the core
Message-ID: <Y3RPqgRr2AOBFbyc@magnolia>
References: <166473482923.1084685.3060991494529121939.stgit@magnolia>
 <166473482971.1084685.9939611867095895186.stgit@magnolia>
 <20221115040816.GY3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115040816.GY3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 15, 2022 at 03:08:16PM +1100, Dave Chinner wrote:
> On Sun, Oct 02, 2022 at 11:20:29AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > xchk_get_inode is not quite the right function to be calling from the
> > inode scrubber setup function.  The common get_inode function either
> > gets an inode and installs it in the scrub context, or it returns an
> > error code explaining what happened.  This is acceptable for most file
> > scrubbers because it is not in their scope to fix corruptions in the
> > inode core and fork areas that cause iget to fail.
> > 
> > Dealing with these problems is within the scope of the inode scrubber,
> > however.  If iget fails with EFSCORRUPTED, we need to xchk_inode to flag
> > that as corruption.  Since we can't get our hands on an incore inode, we
> > need to hold the AGI to prevent inode allocation activity so that
> > nothing changes in the inode metadata.
> > 
> > Looking ahead to the inode core repair patches, we will also need to
> > hold the AGI buffer into xrep_inode so that we can make modifications to
> > the xfs_dinode structure without any other thread swooping in to
> > allocate or free the inode.
> > 
> > Adapt the xchk_get_inode into xchk_setup_inode since this is a one-off
> > use case where the error codes we check for are a little different, and
> > the return state is much different from the common function.
> 
> The code look fine, but...
> 
> ... doesn't this mean that xchk_setup_inode() and xchk_get_inode()
> now are almost identical apart from the xchk_prepare_iscrub() bits?

Yes, they're /nearly/ identical in the helper functions they call, but
they're not so similar in intent and how they handle @error values:

xchk_setup_inode prepares to check or repair an inode record, so it must
continue the scrub operation even if the inode/inobt verifiers cause
xfs_iget to return EFSCORRUPTED.  This is done by attaching the locked
AGI buffer to the scrub transaction and returning 0 to move on to the
actual scrub.  (Later, the online inode repair code will also want the
xfs_imap structure so that it can reset the ondisk xfs_dinode
structure.)

xchk_get_inode retrieves an inode on behalf of a scrubber that operates
on an incore inode -- data/attr/cow forks, directories, xattrs,
symlinks, parent pointers, etc.  If the inode/inobt verifiers fail and
xfs_iget returns EFSCORRUPTED, we want to exit to userspace (because the
caller should be fix the inode first) and drop everything we acquired
along the way.

A behavior common to both functions is that it's possible that xfs_scrub
asked for a scrub-by-handle concurrent with the inode being freed or the
passed-in inumber is invalid.  In this case, we call xfs_imap to see if
the inobt index thinks the inode is allocated, and return ENOENT
("nothing to check here") to userspace if this is not the case.  The
imap lookup is why both functions call xchk_iget_agi.

> This kinda looks like a lot of duplicated but subtly different code
> - does xchk_get_inode() still need all that complexity if we are now
> doing it in xchk_setup_inode()?  If it does, why does
> xchk_setup_inode() need to duplicate the code?

So yes, we do need the complexity of both functions because the
postconditions of the two functions are rather different.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
