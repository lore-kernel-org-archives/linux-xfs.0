Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:34120 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751224AbdIKMvw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Sep 2017 08:51:52 -0400
Date: Mon, 11 Sep 2017 13:51:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: iov_iter_pipe warning.
Message-ID: <20170911125141.GJ5426@ZenIV.linux.org.uk>
References: <20170906200337.b5wj3gpfebliindw@codemonkey.org.uk>
 <20170906234617.GW17782@dastard>
 <20170908010441.GZ5426@ZenIV.linux.org.uk>
 <20170910010756.hnmb233ch7pmnrlx@codemonkey.org.uk>
 <20170910025712.GC5426@ZenIV.linux.org.uk>
 <20170910211110.GM17782@dastard>
 <20170910211907.GF5426@ZenIV.linux.org.uk>
 <20170910220814.GN17782@dastard>
 <20170910230723.GG5426@ZenIV.linux.org.uk>
 <20170911120757.GA29476@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170911120757.GA29476@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Dave Jones <davej@codemonkey.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Mon, Sep 11, 2017 at 05:07:57AM -0700, Christoph Hellwig wrote:
> On Mon, Sep 11, 2017 at 12:07:23AM +0100, Al Viro wrote:
> > BTW, another problem I see there is that iomap_dio_actor() should *NOT*
> > assume that do-while loop in there will always manage to shove 'length'
> > bytes out in case of success.  That is simply not true for pipe-backed
> > destination.  And I'm not sure if outright failures halfway through
> > are handled correctly.  What does it need a copy of dio->submit.iter for,
> > anyway?  Why not work with dio->submit.iter directly?
> > --
> 
> So that we only walk the pagetables and pin down the pages that
> we can actually use in this iteration.

Er...  So why not simply do iov_iter_reexpand() in the end of segment with the
right argument?  IDGI...
