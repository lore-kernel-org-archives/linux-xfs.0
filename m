Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 874B7C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 20:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbiKQUUT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Nov 2022 15:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbiKQUUS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2022 15:20:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D842E20189
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 12:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D9FD6221A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 20:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DB8C433D6;
        Thu, 17 Nov 2022 20:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668716416;
        bh=WeeTfN0KCGSKkDNKTe0/NxMkbZihxSuErBoTRDPt744=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dk21p2GeVxAm9ty1IUlPC/Xa+lQWPHQHr1ILwSH7UKc1QBEMG42OLg9rgeMcWCXwX
         L0xarCH8CiX5OoMb3JHDk4GZdSYb0n9NZcAJNrLSwmqbS64icNk4rrmFJzVfo03MpX
         j7kWulNOgXcPBhn78GUeKgY/MUIn5oESJ9NavB+KVgBhp9bxU5btQHq5iQ7nxAd+D9
         q3Z0nXknOFBl71V2dqMmC97eC1LMpLUtAVEsZTqO62+ZVrYeTgD2Zo60frbq28coj+
         1YOE7mpyUVDsyOsOLFKxwPqy6+DtKaZ+Fb86fWj/3A6ephsSKYKsAxnD+EB+bjJwAK
         ZiHtfy2Q2zbug==
Date:   Thu, 17 Nov 2022 12:20:16 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: retain the AGI when we can't iget an inode to
 scrub the core
Message-ID: <Y3aXgI2DBn3vTi8F@magnolia>
References: <166473482923.1084685.3060991494529121939.stgit@magnolia>
 <166473482971.1084685.9939611867095895186.stgit@magnolia>
 <20221115040816.GY3600936@dread.disaster.area>
 <Y3RPqgRr2AOBFbyc@magnolia>
 <20221117011548.GF3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117011548.GF3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 17, 2022 at 12:15:48PM +1100, Dave Chinner wrote:
> On Tue, Nov 15, 2022 at 06:49:14PM -0800, Darrick J. Wong wrote:
> > On Tue, Nov 15, 2022 at 03:08:16PM +1100, Dave Chinner wrote:
> > > On Sun, Oct 02, 2022 at 11:20:29AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > xchk_get_inode is not quite the right function to be calling from the
> > > > inode scrubber setup function.  The common get_inode function either
> > > > gets an inode and installs it in the scrub context, or it returns an
> > > > error code explaining what happened.  This is acceptable for most file
> > > > scrubbers because it is not in their scope to fix corruptions in the
> > > > inode core and fork areas that cause iget to fail.
> > > > 
> > > > Dealing with these problems is within the scope of the inode scrubber,
> > > > however.  If iget fails with EFSCORRUPTED, we need to xchk_inode to flag
> > > > that as corruption.  Since we can't get our hands on an incore inode, we
> > > > need to hold the AGI to prevent inode allocation activity so that
> > > > nothing changes in the inode metadata.
> > > > 
> > > > Looking ahead to the inode core repair patches, we will also need to
> > > > hold the AGI buffer into xrep_inode so that we can make modifications to
> > > > the xfs_dinode structure without any other thread swooping in to
> > > > allocate or free the inode.
> > > > 
> > > > Adapt the xchk_get_inode into xchk_setup_inode since this is a one-off
> > > > use case where the error codes we check for are a little different, and
> > > > the return state is much different from the common function.
> > > 
> > > The code look fine, but...
> > > 
> > > ... doesn't this mean that xchk_setup_inode() and xchk_get_inode()
> > > now are almost identical apart from the xchk_prepare_iscrub() bits?
> > 
> > Yes, they're /nearly/ identical in the helper functions they call, but
> > they're not so similar in intent and how they handle @error values:
> > 
> > xchk_setup_inode prepares to check or repair an inode record, so it must
> > continue the scrub operation even if the inode/inobt verifiers cause
> > xfs_iget to return EFSCORRUPTED.  This is done by attaching the locked
> > AGI buffer to the scrub transaction and returning 0 to move on to the
> > actual scrub.  (Later, the online inode repair code will also want the
> > xfs_imap structure so that it can reset the ondisk xfs_dinode
> > structure.)
> > 
> > xchk_get_inode retrieves an inode on behalf of a scrubber that operates
> > on an incore inode -- data/attr/cow forks, directories, xattrs,
> > symlinks, parent pointers, etc.  If the inode/inobt verifiers fail and
> > xfs_iget returns EFSCORRUPTED, we want to exit to userspace (because the
> > caller should be fix the inode first) and drop everything we acquired
> > along the way.
> > 
> > A behavior common to both functions is that it's possible that xfs_scrub
> > asked for a scrub-by-handle concurrent with the inode being freed or the
> > passed-in inumber is invalid.  In this case, we call xfs_imap to see if
> > the inobt index thinks the inode is allocated, and return ENOENT
> > ("nothing to check here") to userspace if this is not the case.  The
> > imap lookup is why both functions call xchk_iget_agi.
> 
> Ok, so given all this, all I really want then is better names for
> the functions, as "setup" and "get" don't convey any of this. :)
> 
> Perhaps xchk_setup_inode() -> xchk_iget_for_record_check() and

I'd rather make this function static to inode.c and export a const
global struct xchk_meta_ops pointing to this function.  There's really
no need for the external declaration aside from populating the
meta_scrub_ops table in scrub.c.  The reason why I haven't done that
already is that doing that cleanup will likely cause ~23 merge conflicts
all the way down the branch as I add online repair functions.  Perhaps
the next time I make a branchwide change.

Second, xchk_setup_inode doesn't necessarily return a cached inode,
which is what most iget functions do -- if the read fails, it'll lock
the AGI buffer to the scrub transaction.

I haven't any strong objections to renaming this
xchk_setup_inode_record, if that's what's needed to get this patchset
through review.

> xchk_get_inode() -> xchk_iget_for_scrubbing(). This gives an
> indication taht they are being used for different purposes, and the
> implementation is tailored to the requirements of those specific
> operations....

I'll make this change, however.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
