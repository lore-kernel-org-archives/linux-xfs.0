Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1343C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 19:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6473A20848
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 19:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437500AbhARTp2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 14:45:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437465AbhARTpD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 14:45:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2C5A22C9D;
        Mon, 18 Jan 2021 19:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610999062;
        bh=54v7JgUJQ/GigbXDV787YQ3aLOv+x51remyNEXbnY44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h8gQ0h6IzTX0nCae3F+D9qbtw9wNmHXkuphBiPnY6ghO5D/SUWKcORCC/IQrLl1AV
         v2IUIz9toxbO2sAc8+5fA0s5AfjT9Df/mQ/Kf7fm/hQQcB3jKwAoxLNF0aymYYwDPw
         HIK98FjQcL8V/836NuQjUdbGpWvwn+k2BVoyewRe54b2B8BCDlfPVPpOzep7dA56gA
         cTuWylRRhWFD3B4qzYLb73p+jGL3njZGnPST8JjTv2B0CMpou0ndlIXpEaKD6meBBA
         WMV/bVWjk3SJuDN7HjYV+eRKuaaPty8JkLKAZsEoYW8TBVO31bBkMWphAtsAYVNI4P
         RTM1xNyRWxefA==
Date:   Mon, 18 Jan 2021 11:44:22 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: don't stall cowblocks scan if we can't take
 locks
Message-ID: <20210118194422.GJ3134581@magnolia>
References: <161040735389.1582114.15084485390769234805.stgit@magnolia>
 <161040737263.1582114.4973977520111925461.stgit@magnolia>
 <X/8HLQGzXSbC2IIn@infradead.org>
 <20210114215453.GG1164246@magnolia>
 <20210118173412.GA3134885@infradead.org>
 <20210118193718.GI3134581@magnolia>
 <20210118193958.GA3171275@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118193958.GA3171275@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 07:39:58PM +0000, Christoph Hellwig wrote:
> On Mon, Jan 18, 2021 at 11:37:18AM -0800, Darrick J. Wong wrote:
> > Ah, I see, you're asking why don't I make xfs_inode_walk responsible for
> > deciding what to do about EAGAIN, instead of open-coding that in the
> > ->execute function.  That would be a nice cleanup since the walk
> > function already has special casing for EFSCORRUPTED.
> > 
> > If I read you correctly, the relevant part of xfs_inode_walk becomes:
> > 
> > 	error = execute(batch[i]...);
> > 	xfs_irele(batch[i]);
> > 	if (error == -EAGAIN) {
> > 		if (args->flags & EOF_SYNC)
> > 			skipped++;
> > 		continue;
> > 	}
> > 
> > and the relevant part of xfs_inode_free_eofblocks becomes:
> > 
> > 	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
> > 		return -EAGAIN;
> > 
> > I think that would work, and afaict it won't cause any serious problems
> > with the deferred inactivation series.
> 
> Exactly!

D'oh.  I tried making that change, but ran into the problem that *args
isn't necessarily an eofb structure, and xfs_qm_dqrele_all_inodes passes
a uint pointer.  I could define a new XFS_INODE_WALK_SYNC flag and
update the blockgc callers to set that if EOF_FLAGS_SYNC is set...

--D
