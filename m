Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38258 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751409AbdHaNJR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 09:09:17 -0400
Date: Thu, 31 Aug 2017 06:09:12 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS reflinks
Message-ID: <20170831130912.GA19544@infradead.org>
References: <04eacb90-aac9-7c47-f074-fa91eb253822@bytemark.co.uk>
 <20170829130046.GA28896@infradead.org>
 <20170829160308.GR4757@magnolia>
 <20170829162310.GA22552@infradead.org>
 <20170829220316.GD10621@dastard>
 <3b025b43-3ca5-567f-d9e0-c45245d37ecb@bytemark.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b025b43-3ca5-567f-d9e0-c45245d37ecb@bytemark.co.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Cottam <chris.cottam@bytemark.co.uk>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Aug 31, 2017 at 11:33:44AM +0100, Chris Cottam wrote:
> > Yup, that's a problem, and it's going to be even more of a problem
> > once people start using reflink to snapshot sparse VM images. I
> > think that the extent rework is probably the most important thing we
> > need to solve for COW to be generally usable.
> 
> Assuming I was feeling brave, what should I be doing to limit the
> chances of hitting this issue? Would smaller filesystems or lots of
> memory on the host help etc?
> Also what should I be monitoring to warn me before anything actually breaks?

Make sure you have memory compaction enabled is the best bet,
don't run under crazy memory pressure.  I've not actually seen an
actual deadlock due to it, just the possible memory allocation
deadlock warnings from kmem_alloc (and lots of those).
