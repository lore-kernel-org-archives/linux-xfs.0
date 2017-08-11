Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35990 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752610AbdHKMxN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 08:53:13 -0400
Date: Fri, 11 Aug 2017 05:53:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of an attribute
Message-ID: <20170811125310.GA31001@infradead.org>
References: <1502276772-24293-1-git-send-email-alex@zadarastorage.com>
 <20170809213307.GJ21024@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170809213307.GJ21024@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: alex@zadarastorage.com, linux-xfs@vger.kernel.org, bfoster@redhat.com, darrick.wong@oracle.com, libor.klepac@bcom.cz

On Thu, Aug 10, 2017 at 07:33:07AM +1000, Dave Chinner wrote:
> Hmmmm, looking closer at xfs_defer_finish(), just holding the buffer
> here isn't sufficient. xfs_defer_finish() can roll the transaction a
> number of times and holding the buffer is a one-shot deal. Hence the
> buffer held buffer will have BLI_HOLD removed on the next commit
> and be unlocked by the second commit, whether it be inside
> xfs_defer_finish() or the roll that occurs below.
> 
> ISTR a previous discussion with Darrick that we needed something
> like xfs_defer_join() with buffers instead of inodes to allow them
> to be held across a call to xfs_defer_finish()....

We do.  I actually have patches lying around that remove the
xfs_trans_roll and xfs_defer_finish inode arguments, and instead have a
separate helper for rolling over an inode and adding an inode to the
defer list.

I've not added a magic helper for buffers yet, but that would be a
natural fit into that model.
