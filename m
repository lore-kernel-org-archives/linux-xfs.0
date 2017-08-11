Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33003 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753413AbdHKQxT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 12:53:19 -0400
Date: Fri, 11 Aug 2017 09:52:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of an attribute
Message-ID: <20170811165241.GE24087@magnolia>
References: <1502276772-24293-1-git-send-email-alex@zadarastorage.com>
 <20170809213307.GJ21024@dastard>
 <20170811125310.GA31001@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811125310.GA31001@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, alex@zadarastorage.com, linux-xfs@vger.kernel.org, bfoster@redhat.com, libor.klepac@bcom.cz

On Fri, Aug 11, 2017 at 05:53:10AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 10, 2017 at 07:33:07AM +1000, Dave Chinner wrote:
> > Hmmmm, looking closer at xfs_defer_finish(), just holding the buffer
> > here isn't sufficient. xfs_defer_finish() can roll the transaction a
> > number of times and holding the buffer is a one-shot deal. Hence the
> > buffer held buffer will have BLI_HOLD removed on the next commit
> > and be unlocked by the second commit, whether it be inside
> > xfs_defer_finish() or the roll that occurs below.
> > 
> > ISTR a previous discussion with Darrick that we needed something
> > like xfs_defer_join() with buffers instead of inodes to allow them
> > to be held across a call to xfs_defer_finish()....
> 
> We do.  I actually have patches lying around that remove the
> xfs_trans_roll and xfs_defer_finish inode arguments, and instead have a
> separate helper for rolling over an inode and adding an inode to the
> defer list.
> 
> I've not added a magic helper for buffers yet, but that would be a
> natural fit into that model.

Could you send them to the list, please? :)

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
