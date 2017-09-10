Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from scorn.kernelslacker.org ([45.56.101.199]:53390 "EHLO
        scorn.kernelslacker.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751614AbdIJUH0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Sep 2017 16:07:26 -0400
Date: Sun, 10 Sep 2017 16:07:24 -0400
From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: iov_iter_pipe warning.
Message-ID: <20170910200724.let6gkxhkvlg6nkr@codemonkey.org.uk>
References: <20170807201818.kykqzexce6ap6aik@codemonkey.org.uk>
 <20170828203130.y6dq5fqovev6wmrv@codemonkey.org.uk>
 <20170829042542.GO4757@magnolia>
 <20170906200337.b5wj3gpfebliindw@codemonkey.org.uk>
 <20170906234617.GW17782@dastard>
 <20170908010441.GZ5426@ZenIV.linux.org.uk>
 <20170910010756.hnmb233ch7pmnrlx@codemonkey.org.uk>
 <20170910025712.GC5426@ZenIV.linux.org.uk>
 <20170910160710.7myz4iel2mnvya3b@codemonkey.org.uk>
 <20170910200547.GD5426@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170910200547.GD5426@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Sun, Sep 10, 2017 at 09:05:48PM +0100, Al Viro wrote:
 > On Sun, Sep 10, 2017 at 12:07:10PM -0400, Dave Jones wrote:
 > > On Sun, Sep 10, 2017 at 03:57:21AM +0100, Al Viro wrote:
 > >  > On Sat, Sep 09, 2017 at 09:07:56PM -0400, Dave Jones wrote:
 > >  > 
 > >  > > With this in place, I'm still seeing -EBUSY from invalidate_inode_pages2_range
 > >  > > which doesn't end well...
 > >  > 
 > >  > Different issue, and I'm not sure why that WARN_ON() is there in the
 > >  > first place.  Note that in a similar situation generic_file_direct_write()
 > >  > simply buggers off and lets the caller do buffered write...
 > >  > 
 > >  > iov_iter_pipe() warning is a sign of ->read_iter() on pipe-backed iov_iter
 > >  > putting into the pipe more than it claims to have done.
 > > 
 > > (from a rerun after hitting that EBUSY warn; hence the taint)
 > > 
 > > WARNING: CPU: 0 PID: 14154 at fs/iomap.c:1055 iomap_dio_rw+0x78e/0x840
 > 
 > ... and that's another invalidate_inode_pages2_range() in the same
 > sucker.  Again, compare with generic_file_direct_write()...
 > 
 > I don't believe that this one has anything splice-specific to do with it.
 > And its only relation to iov_iter_pipe() splat is that it's in the same
 > fs/iomap.c...

The interesting part is that I'm hitting these two over and over now
rather than the iov_iter_pipe warning.  Could just be unlucky
randomness though..

	Dave

