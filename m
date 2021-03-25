Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B028C433C1
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 04:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50BEB61A1A
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 04:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhCYEbJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 00:31:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229448AbhCYEaq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 00:30:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2510460238;
        Thu, 25 Mar 2021 04:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616646646;
        bh=A2mbUqfh15zlM5Chdm5jLjjmHolsrxnk47JiYjk6x8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XMZC1N0p9Dsas1223mLQ56N79kpJXKTBIaGDM5jP3MPn+SVGhShmN0GXn5/KQCAKE
         FW6rDm0YAWMTgqkChcELfpxylh9pRxkGALgxlQJ/RBL6oxcIfFEUaQeHN41dMcuXoK
         G4AZ5aEqvl95g2lxQU83sM8eGSiqF7FPu4p1jMTy6O1KUXax1E6zR36U8gZySGuY5K
         hNZ1BQgW6Gq7/VUhTl1HiIGjJpzVTgrmnaERpEo7WLXSXbQhFvdcsSEbr4c8eJzPX+
         LEwwBWwNuCc78uq4xc9BIYdRz7oalYzid+GxI3gntR5bzoE+BkYSzR9HfKKNZuq+xc
         p3IYl1O5G5THg==
Date:   Wed, 24 Mar 2021 21:30:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: simplify the perage inode walk infrastructure
Message-ID: <20210325043045.GD4090233@magnolia>
References: <20210324070307.908462-1-hch@lst.de>
 <20210324070307.908462-3-hch@lst.de>
 <20210324175735.GX22100@magnolia>
 <20210324175937.GA14862@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324175937.GA14862@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 06:59:37PM +0100, Christoph Hellwig wrote:
> On Wed, Mar 24, 2021 at 10:57:35AM -0700, Darrick J. Wong wrote:
> > On Wed, Mar 24, 2021 at 08:03:06AM +0100, Christoph Hellwig wrote:
> > > Remove the generic xfs_inode_walk and just open code the only caller.
> > 
> > This is going in the wrong direction for me.  Maybe.
> > 
> > I was planning to combine the reclaim inode walk into this function, and
> > later on share it with inactivation.  This made for one switch-happy
> > iteration function, but it meant there was only one loop.
> 
> Ok, we can skip this for now if this gets in your way.  Or I can resend
> a different patch 2 that just removes the no tag case for now.
> 
> > OFC maybe the point that you and/or Dave were trying to make is that I
> > should be doing the opposite, and combining the inactivation loop into
> > what is now the (badly misnamed) xfs_reclaim_inodes_ag?  And leave this
> > blockgc loop alone?
> 
> That is my gut feeling.  No guarantee it actually works out, and given
> that I've lead you down the wrong road a few times I already feel guily
> ahead of time..

Actually, collapsing all of the tag walkers into xfs_inode_walk was
pretty straightforward, and in the end I just borrowed bits and pieces
from patches 2 and 3 to make it happen and clean up the arguments.  The
net change is 55 lines deleted and ~1k less code (granted with all the
debugging and ubsan crud turned on).

--D
