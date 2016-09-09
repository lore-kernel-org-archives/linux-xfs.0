Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:48590 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750792AbcIIC0a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 22:26:30 -0400
Date: Fri, 9 Sep 2016 03:26:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
 detected
Message-ID: <20160909022628.GM2356@ZenIV.linux.org.uk>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
 <1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
 <20160903003919.GI30056@dastard>
 <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
 <20160908175632.GH2356@ZenIV.linux.org.uk>
 <CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
 <20160908213835.GY30056@dastard>
 <20160908235521.GL2356@ZenIV.linux.org.uk>
 <20160909015324.GD30056@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160909015324.GD30056@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Sep 09, 2016 at 11:53:24AM +1000, Dave Chinner wrote:
 
> This isn't specific to splice - it's the same issue for all page
> cache lookup and validation checks. This issue is one of the reasons
> why XFS has a MMAPLOCK similar to the IOLOCK - we can't take the
> IOLOCK in the page fault path, but we still need to protect page
> faults against racing page invalidations within EOF from operations
> like hole punch.

Point taken.  The window is between grabbing the pages and ->readpage()
calls, though, so converting to ->read_iter() ought to deal with the
entire class of problems...
 
[snip]

> Sounds reasonable, but the iter stuff makes my head hurt so I
> haven't thought about it that deeply yet.

O_DIRECT requires a bit of care, but it seems to be doable.
