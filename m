Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13CD8C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 19:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D19EC22CA1
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 19:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437445AbhARTiI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 14:38:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:47650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437585AbhARTh7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 14:37:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E5C2206BE;
        Mon, 18 Jan 2021 19:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610998639;
        bh=ZPPagwuHY/Ki42R+NTEm/Tv7Ytrx5xOKgX//QIyXw30=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ArgC4gh3/qM6OWzQfXr1tDvbcmmtBWdSBZcK20UAbkeyhR7bcPjqQh/s2+vwBdBR2
         1Ptv0oV/ZuzzjqpnEQ3QHNptIuEALuGlsMOrYNJ3USqn0WcDgwzu1HpnkoyaC2od5/
         tYT04q2vHkNHAfcPRtS/+wspulbAHSREox95ho5M9ssS59coAzjkyYrhWhGf5v2jdd
         JovEiizWuX2eXX27arMojwOjSTOKjSv4SG4RqdHhMR8cFh/7NsiKQ0wPymFBQHQTnP
         DZWH10XU9y/PtQ7hXQXutvmvDSb2biV0CcnvuMtxASFARVIHfyzcEBz+Yjhim8pldr
         TIZMyIAP1eXlw==
Date:   Mon, 18 Jan 2021 11:37:18 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: don't stall cowblocks scan if we can't take
 locks
Message-ID: <20210118193718.GI3134581@magnolia>
References: <161040735389.1582114.15084485390769234805.stgit@magnolia>
 <161040737263.1582114.4973977520111925461.stgit@magnolia>
 <X/8HLQGzXSbC2IIn@infradead.org>
 <20210114215453.GG1164246@magnolia>
 <20210118173412.GA3134885@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118173412.GA3134885@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 05:34:12PM +0000, Christoph Hellwig wrote:
> On Thu, Jan 14, 2021 at 01:54:53PM -0800, Darrick J. Wong wrote:
> > On Wed, Jan 13, 2021 at 03:43:57PM +0100, Christoph Hellwig wrote:
> > > On Mon, Jan 11, 2021 at 03:22:52PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Don't stall the cowblocks scan on a locked inode if we possibly can.
> > > > We'd much rather the background scanner keep moving.
> > > 
> > > Wouldn't it make more sense to move the logic to ignore the -EAGAIN
> > > for not-sync calls into xfs_inode_walk_ag?
> > 
> > I'm not sure what you're asking here?  _free_cowblocks only returns
> > EAGAIN for sync calls.  Locking failure for a not-sync call results in a
> > return 0, which means that _walk_ag just moves on to the next inode.
> 
> What I mean is:
> 
>  - always return -EAGAIN when taking the locks fails
>  - don't exit early on -EAGAIN in xfs_inode_walk at least for sync
>    calls, although thinking loud I see no good reason to exit early
>    even for non-sync invocations

Ah, I see, you're asking why don't I make xfs_inode_walk responsible for
deciding what to do about EAGAIN, instead of open-coding that in the
->execute function.  That would be a nice cleanup since the walk
function already has special casing for EFSCORRUPTED.

If I read you correctly, the relevant part of xfs_inode_walk becomes:

	error = execute(batch[i]...);
	xfs_irele(batch[i]);
	if (error == -EAGAIN) {
		if (args->flags & EOF_SYNC)
			skipped++;
		continue;
	}

and the relevant part of xfs_inode_free_eofblocks becomes:

	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
		return -EAGAIN;

I think that would work, and afaict it won't cause any serious problems
with the deferred inactivation series.

--D
