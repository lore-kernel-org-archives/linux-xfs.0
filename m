Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECD6C4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Aug 2021 08:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7121C610CC
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Aug 2021 08:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239749AbhHMIPh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Aug 2021 04:15:37 -0400
Received: from verein.lst.de ([213.95.11.211]:46854 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234844AbhHMIPg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Aug 2021 04:15:36 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id AB26A6736F; Fri, 13 Aug 2021 10:15:07 +0200 (CEST)
Date:   Fri, 13 Aug 2021 10:15:07 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [bug report] xfs: pass the goal of the incore inode walk to
 xfs_inode_walk()
Message-ID: <20210813081507.GA28382@lst.de>
References: <20210812064222.GA20009@kili> <20210812214048.GE3657114@dread.disaster.area> <20210813073812.GX22532@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813073812.GX22532@kadam>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 13, 2021 at 10:38:12AM +0300, Dan Carpenter wrote:
> > 
> > i.e. the enum is defined to clearly contain negative values and so
> > GCC should be defining it as a signed integer regardless of the
> > version of C being used...
> 
> You're analysis is correct, but I'm looking at a newer version of the
> code and I blamed the wrong commit.  It should be commit 777eb1fa857e
> ("xfs: remove xfs_dqrele_all_inodes")
> https://lore.kernel.org/linux-xfs/20210809065938.1199181-3-hch@lst.de/
> That commit removes the "XFS_ICWALK_DQRELE       = -1," line which
> changes the enum type from int to unsigned int.
> 
> So this suggests that we should just remove the check for negative
> values.

Remove the check as in removing the XFS code: yes.  I just prepared a
patch for that.  As in remove the check in smach:  As usual these
kind of checks tend to find something fishy.  Be that real bugs,
dead code or just the need to document weirdness better.
