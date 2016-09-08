Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:43228 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754073AbcIHR4g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 13:56:36 -0400
Date: Thu, 8 Sep 2016 18:56:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
 detected
Message-ID: <20160908175632.GH2356@ZenIV.linux.org.uk>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
 <1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
 <20160903003919.GI30056@dastard>
 <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: CAI Qian <caiqian@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com

On Thu, Sep 08, 2016 at 11:29:11AM -0400, CAI Qian wrote:

> > Nope, this goes back to the splice rework back around ~3.16, IIRC.
> Right. FYI, revert the commit below fixes the regression,
> 
> 8d02076 : ->splice_write() via ->write_iter()

... and brings back a lot of other crap.  The thing is, pipe lock should
be on the outside of everything fs might be taking, so that splice IO
is the same as normal IO as far as filesystem locking is concerned.  For
the write side it had been done in that commit, for the read side it's yet
to be done.
