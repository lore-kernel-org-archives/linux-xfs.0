Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50414 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751257AbeCGNR0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Mar 2018 08:17:26 -0500
Date: Wed, 7 Mar 2018 05:17:25 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: fix double ijoin in xfs_reflink_cancel_cow_range
Message-ID: <20180307131725.GA32572@infradead.org>
References: <20180307091020.6186-1-david@fromorbit.com>
 <20180307091020.6186-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180307091020.6186-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 07, 2018 at 08:10:20PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> AN inode is joined to teh same transaction twice in
> xfs_reflink_cancel_cow_range() resulting in the following assert
> failure:

Needs some major spelling love :)

> 
> [   30.180485] XFS: Assertion failed: !(lip->li_flags & XFS_LI_TRANS), file: fs/xfs/xfs_trans.c, line: 740

That assertations seems like something that only exists locally in your
tree.  Any chance to send it out with this series?

The other option would be to make xfs_trans_ijoin a no-op if the inode
is already joined, except that this wouldn't work with the magic unlock
on commit.  Which is a feature I find horribly confusing, so we should
get rid of it, for which we'd need to get rid of the concept of
synchronous transactions in favour of leaving the log force to the
caller, which again would be more logical.

Guess I need to look into doing these cleanups as I don't want to force
them on anyone else.  Just need to finish all the other more important
bits on the todo list first :)
