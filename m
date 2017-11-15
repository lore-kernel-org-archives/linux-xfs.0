Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47330 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752629AbdKOTrD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 14:47:03 -0500
Date: Wed, 15 Nov 2017 11:47:00 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Disabling barriers on NVC-backed HDD
Message-ID: <20171115194700.GA6228@infradead.org>
References: <8b91c685e344bdc5d084b11fab1d50af@assyoma.it>
 <20171115173100.GD5119@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171115173100.GD5119@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Gionatan Danti <g.danti@assyoma.it>, linux-xfs@vger.kernel.org

On Wed, Nov 15, 2017 at 09:31:00AM -0800, Darrick J. Wong wrote:
> I would evaluate these drives to find out if you really /can/ yank the
> power without losing anything.
> 
> That said, if the manufacturers aren't willing to tell you how that
> feature works, I'd just as soon pretend the feature didn't exist and
> continue sending flushes to the drive.
> 
> FWIW if the drive really /does/ have a non-volatile WC then a flush
> should have nearly zero overhead.  (Or so you'd think...)

And in that case it will report WCE=0 and Linux won't even flush.
As is the case for typical enterprise disks.
