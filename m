Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24ECFC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jan 2022 02:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344636AbiAFCNx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 21:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344590AbiAFCNv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 21:13:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052D2C061245
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 18:13:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97F3D61A33
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jan 2022 02:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6069C36AF3;
        Thu,  6 Jan 2022 02:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641435230;
        bh=uc+i9YWVhyN72pzPl5fBXTLhfg1r2IN9z9MMR0wwSnQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VVnPKdyFbGILJ8MnWaljpEQtgKpHW8yUxZuWCnOpKThOY3lMoJmHbF8HYSRKO99qE
         nQOc2e2ESEk5KpMqTxNUfFJQwleBZFvBbYujG7OSooRqjg7SaiSJ1R9btSOGhd653d
         KgnkHO7Q/pGWtgrweZQzebIXoX4WG5fygfNcq8dtcXbnUQj31qLZo8T9Ve1yMyZaLg
         b7qK5/l3LaL5N2GpM50z5PHGMInCuV0GM8SYnWVA/iJhYzm3XWqIdtjykhhIO2Iect
         BjBAHtdV1OlApZPfQ8dd8zJSx6Vrf7Ju1xKSyDK28C3hOn27xZlkwitfWoldwtIkCI
         2fG9LB3ctmDdA==
Date:   Wed, 5 Jan 2022 18:13:49 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: take the ILOCK when accessing the inode core
Message-ID: <20220106021349.GK31606@magnolia>
References: <20220105195226.GL656707@magnolia>
 <20220106014712.GS945095@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106014712.GS945095@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 06, 2022 at 12:47:12PM +1100, Dave Chinner wrote:
> On Wed, Jan 05, 2022 at 11:52:26AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > I was poking around in the directory code while diagnosing online fsck
> > bugs, and noticed that xfs_readdir doesn't actually take the directory
> > ILOCK when it calls xfs_dir2_isblock.  xfs_dir_open most probably loaded
> > the data fork mappings and the VFS took i_rwsem (aka IOLOCK_SHARED) so
> > we're protected against writer threads, but we really need to follow the
> > locking model like we do in other places.
> > 
> > To avoid unnecessarily cycling the ILOCK for fairly small directories,
> > change the block/leaf _getdents functions to consume the ILOCK hold that
> > the parent readdir function took to decide on a _getdents implementation.
> > 
> > It is ok to cycle the ILOCK in readdir because the VFS takes the IOLOCK
> > in the appropriate mode during lookups and writes, and we don't want to
> > be holding the ILOCK when we copy directory entries to userspace in case
> > there's a page fault.  We really only need it to protect against data
> > fork lookups, like we do for other files.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> > v2: reduce the scope of the locked region, and reduce lock cycling
> 
> Looks good, one minor thing: can you add a comment to xfs_readdir()
> that callers/VFS needs to hold the i_rwsem to ensure that the
> directory is not being concurrently modified? Maybe even add a
> ASSERT(rwsem_is_locked(VFS_I(ip)->i_rwsem)) to catch cases where
> this gets broken?

The documentation already says the caller has to hold the inode lock,
but I will change it to say the IOLOCK specifically.  And add the
ASSERT.

--D

> 
> Other than than it looks good.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
