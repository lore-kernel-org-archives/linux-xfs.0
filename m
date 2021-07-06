Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57751C07E96
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jul 2021 21:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3356361CB3
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jul 2021 21:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhGFVwJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 17:52:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229781AbhGFVwI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jul 2021 17:52:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9242761C83;
        Tue,  6 Jul 2021 21:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625608169;
        bh=AnqZr0Nq8JmwxoBQhRuBVyPMJgDHzjHdR8qJHofX6YE=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=hAmSmiT9RqJHaBafi81MfbP67+LnavB99vm+csKHY3HvPoW3AZLXjAMsdWJwzkDzy
         SWbtvy498wpL2QhvJpd00n+FETXu9MjJZXtp7IVcsVqCGbHbChhWcysQq2pxOFhqTP
         mMWDJWHlOZyud7nSnzlr/AP0J0swj9cysmTmZuWq++OYYpDlmozN5SP9ZypIsrWOqG
         sqFdZIhwFRsbC0Jmw2AU9Qp3C+iN7O6pDL5qiynNHXhWDQoWuXaX3zHzfvYuBevCKp
         Wsg8hGJva8/eIFNJGFn994Oum/73qLY053kVpXi101zC+rN/14M5D1z+kOciWQl6n4
         t2xWTDSBOhRkA==
Date:   Tue, 6 Jul 2021 14:49:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: reset child dir '..' entry when unlinking child
Message-ID: <20210706214929.GF11588@locust>
References: <20210703030233.GD24788@locust>
 <20210705220925.GN664593@dread.disaster.area>
 <YOOTtQoRfAay1Hhs@B-P7TQMD6M-0146.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOOTtQoRfAay1Hhs@B-P7TQMD6M-0146.local>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 06, 2021 at 07:20:21AM +0800, Gao Xiang wrote:
> Hi Dave and Christoph,
> 
> On Tue, Jul 06, 2021 at 08:09:25AM +1000, Dave Chinner wrote:
> > On Fri, Jul 02, 2021 at 08:02:33PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > While running xfs/168, I noticed a second source of post-shrink
> > > corruption errors causing shutdowns.
> > > 
> > > Let's say that directory B has a low inode number and is a child of
> > > directory A, which has a high number.  If B is empty but open, and
> > > unlinked from A, B's dotdot link continues to point to A.  If A is then
> > > unlinked and the filesystem shrunk so that A is no longer a valid inode,
> > > a subsequent AIL push of B will trip the inode verifiers because the
> > > dotdot entry points outside of the filesystem.
> > 
> > So we have a directory inode that is empty and unlinked but held
> > open, with a back pointer to an invalid inode number? Which can
> > never be followed, because the directory has been unlinked.
> > 
> > Can't this be handled in the inode verifier? This seems to me to
> > be a pretty clear cut case where the ".." back pointer should
> > always be considered invalid (because the parent dir has no
> > existence guarantee once the child has been removed from it), not
> > just in the situation where the filesystem has been shrunk...
> 
> Yes, I agree all of this, this field can be handled by the inode
> verifier. The only concern I can think out might be fs freeze
> with a directory inode that is empty and unlinked but held open,
> and then recovery on a unpatched old kernels, not sure if such
> case can be handled properly by old kernel verifier.

I decided against changing the shortform directory verifier to ignore
the dotdot pointer on nlink==0 directories because older kernels will
still have the current behavior and that will cause recovery failure for
the following sequence:

1. create A and B and delete A as per above, leave B open
2. shrink fs so that A is no longer a valid inode number
3. flush the shrink transaction to disk
4. futimens(B) (or anything to dirty the inode)
5. crash
6. boot old kernel
7. try to recover fs with old kernel, which will crash since B hadn't
   been inactivated

But I guess I'll have to go write an fstest to prove that I'm not
making this up...

--D

> 
> Otherwise, it's also ok I think.
> 
> Thanks,
> Gao Xiang
> 
> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
