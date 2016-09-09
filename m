Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:48650 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbcIICb4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 22:31:56 -0400
Date: Fri, 9 Sep 2016 03:31:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
 detected
Message-ID: <20160909023153.GN2356@ZenIV.linux.org.uk>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
 <1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
 <20160903003919.GI30056@dastard>
 <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
 <20160908175632.GH2356@ZenIV.linux.org.uk>
 <CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
 <20160908213835.GY30056@dastard>
 <20160908235521.GL2356@ZenIV.linux.org.uk>
 <20160909015324.GD30056@dastard>
 <CA+55aFzohsUXj_3BeFNr2t50Wm=G+7toRDEz=Tk7VJqP3n1hXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzohsUXj_3BeFNr2t50Wm=G+7toRDEz=Tk7VJqP3n1hXQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com


> So I'm not sure why we'd need to care?
> 
> The thing is, if the splicer and the hole puncher aren't synchronized,
> then there is by definition no "before/after" point.
> 
> The splice data may be "stale" in the sense that we look at the page
> after the hole punch has happened and the page no longer has a
> ->mapping associated with it, but it is equally valid to treat that as
> just a case of "the read happened before the hole punch".
> 
> Put another way: it's not wrong to use the ostensibly "stale" data, it
> just means that the splice acts as if the IO had happened before the
> data became stale.

We care because __generic_file_splice_read() is playing fast and loose with
pagecache.  It gathers pointers to pages and *then* issues ->readpage() on
them.  Without any protection against hole-punching.  That's actually one
more example of the reasons why we really ought to just call ->read_iter()
and let the regular fs logics take care of exclusion.  pipe lock is needed
only to pass the pages we'd grabbed (from page cache) or allocated (for
copy_to_iter() callers, like e.g. DAX) into the pipe itself.
