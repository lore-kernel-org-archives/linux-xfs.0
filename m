Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58179 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750965AbdIKMID (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Sep 2017 08:08:03 -0400
Date: Mon, 11 Sep 2017 05:07:57 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: iov_iter_pipe warning.
Message-ID: <20170911120757.GA29476@infradead.org>
References: <20170829042542.GO4757@magnolia>
 <20170906200337.b5wj3gpfebliindw@codemonkey.org.uk>
 <20170906234617.GW17782@dastard>
 <20170908010441.GZ5426@ZenIV.linux.org.uk>
 <20170910010756.hnmb233ch7pmnrlx@codemonkey.org.uk>
 <20170910025712.GC5426@ZenIV.linux.org.uk>
 <20170910211110.GM17782@dastard>
 <20170910211907.GF5426@ZenIV.linux.org.uk>
 <20170910220814.GN17782@dastard>
 <20170910230723.GG5426@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170910230723.GG5426@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, Dave Jones <davej@codemonkey.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Mon, Sep 11, 2017 at 12:07:23AM +0100, Al Viro wrote:
> BTW, another problem I see there is that iomap_dio_actor() should *NOT*
> assume that do-while loop in there will always manage to shove 'length'
> bytes out in case of success.  That is simply not true for pipe-backed
> destination.  And I'm not sure if outright failures halfway through
> are handled correctly.  What does it need a copy of dio->submit.iter for,
> anyway?  Why not work with dio->submit.iter directly?
> --

So that we only walk the pagetables and pin down the pages that
we can actually use in this iteration.

