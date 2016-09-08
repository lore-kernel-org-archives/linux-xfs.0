Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:45684 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758092AbcIHVaL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 17:30:11 -0400
Date: Thu, 8 Sep 2016 22:30:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
 detected
Message-ID: <20160908213007.GK2356@ZenIV.linux.org.uk>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
 <1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
 <20160903003919.GI30056@dastard>
 <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
 <CA+55aFyfDNR9vkQ3sZMhLcoizE5VCLJDVukyPk=gbhDz9aNLgA@mail.gmail.com>
 <268523885.1013251.1473367174650.JavaMail.zimbra@redhat.com>
 <20160908211931.GX30056@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160908211931.GX30056@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: CAI Qian <caiqian@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Sep 09, 2016 at 07:19:31AM +1000, Dave Chinner wrote:

> Don't bother. You'll just hit a different lockdep issue - a locking
> order problem on the write side. I tried to get that fixed years
> ago:
> 
> https://lkml.org/lkml/2011/7/18/4
> http://oss.sgi.com/archives/xfs/2011-08/msg00122.html
> http://oss.sgi.com/archives/xfs/2012-11/msg00671.html
> 
> That specific problem was fixed by the above write_iter
> infrastructure fixes, but introduced the read side problem.  i.e.
> splice has /always/ had locking order issues that XFS exposed.

Yep.  I'll try to slap together something testable for the variant I'd
outlined; I really think that the root of problems here is that we have
parallel logics in ->read_iter and ->splice_read.  That just might
get rid of special-casing DAX in there, while we are at it...

Looking at the DAX side of things, we need iov_iter_zero() to grok those
as well (in addition to copy_page_to_iter() and copy_to_iter()).
