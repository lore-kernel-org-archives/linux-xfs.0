Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB9FC77B61
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 01:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjDKBFe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 21:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjDKBFd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 21:05:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB592683
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 18:05:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEA0F61857
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 01:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E406C433EF;
        Tue, 11 Apr 2023 01:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681175132;
        bh=giqPYhubcp0LJC2JXeBfi1D7bc74A4AQC7WzJzdf9+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i9KB0G7riYC4/zK0ePqyqo3Kpu50CrIGV+KsIX7SFyHdQr2pwExDPhUYSV+UPfCim
         iqd2YaLTEyNVPCT8cXJF298vfD2+2kT9uxx8TVBdv21gYIQmda8Zt8i6QdGKWJebgr
         VTrf9SM0eu+Uwwu68Htg7Yb0X2LKon+gqfNN+d0ihKAMj2adP99WbDJ/mMvXJOUtD7
         Q2dILDbM/jfzGjwfAdSjiyUJh0PHGkqmOyyvbANbkSuJSA39AVvfakS3qZMBVvXv9B
         ezxL+AJTZggkIcUVwwagEEQNc97OnenpL6oN6Pz3grs4/L5FmKYzp/TNZJHMTC+ewJ
         GT74gwJKNvhRg==
Date:   Mon, 10 Apr 2023 18:05:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: recheck appropriateness of map_shared lock
Message-ID: <20230411010531.GE360889@frogsfrogsfrogs>
References: <Y8ib6ls32e/pJezE@magnolia>
 <Y8mMailEevUSZkG+@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8mMailEevUSZkG+@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 19, 2023 at 10:31:06AM -0800, Christoph Hellwig wrote:
> On Wed, Jan 18, 2023 at 05:24:58PM -0800, Darrick J. Wong wrote:
> >  	xfs_ilock(ip, lock_mode);
> > +
> > +	/*
> > +	 * It's possible that the unlocked access of the data fork to determine
> > +	 * the lock mode could have raced with another thread that was failing
> > +	 * to load the bmbt but hadn't yet torn down the iext tree.  Recheck
> > +	 * the lock mode and upgrade to an exclusive lock if we need to.
> > +	 */
> > +	if (lock_mode == XFS_ILOCK_SHARED &&
> > +	    xfs_need_iread_extents(&ip->i_df)) {
> 
> Eww.  I think the proper fix here is to make sure
> xfs_need_iread_extents does not return false until we're actually
> read the extents.  So I think we'll need a new inode flag
> XFS_INEED_READ - gets set when reading inode in btree format,
> and gets cleared at the very end of xfs_iread_extents once we know
> the read succeeded.

So I finally cleared enough off my plate to get back to this, and
reworking the patch this way *looks* promising.  It definitely fixes the
xfs/375 problems, and over the weekend I didn't see any obvious splats.

--D
