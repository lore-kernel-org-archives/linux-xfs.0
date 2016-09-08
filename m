Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:45612 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbcIHVXp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 17:23:45 -0400
Date: Thu, 8 Sep 2016 22:23:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
 detected
Message-ID: <20160908212342.GA3791@ZenIV.linux.org.uk>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
 <1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
 <20160903003919.GI30056@dastard>
 <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
 <20160908175632.GH2356@ZenIV.linux.org.uk>
 <CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
 <20160908204450.GJ2356@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160908204450.GJ2356@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CAI Qian <caiqian@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Sep 08, 2016 at 09:44:50PM +0100, Al Viro wrote:

> Moreover, I don't see why we need to hold pipe lock the actual call of
> ->read_iter().  Right now we only grab it for "feed into pipe buffers"
> part.  Objections?

Actually, screw the "array of bvec"; we'd need to mark the ones that are
pagecache-backed somehow to tell which methods should be used.  Let's
add a variant of iov_iter that would be backed by pipe_buffer array;
copy_page_to_iter() fills the next slot with an extra reference to the
page we'd been given and using page_cache_pipe_buf_ops for ->ops.
copy_to_iter() adds to the last slot if it has default_pipe_buf_ops for
->ops and still has space in it or allocates a new page, sticks into the
next slot, copies data into it and sets default_pipe_ops for ->ops.

Then all we need is a variant of splice_to_pipe()/splice_{grow,shrink}_spd()
that would work with an array of pipe_buffer instead of page/partial_page
array pair.
