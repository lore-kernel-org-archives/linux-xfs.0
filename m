Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36530 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933334AbdCaQHq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Mar 2017 12:07:46 -0400
Date: Fri, 31 Mar 2017 09:07:43 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: move the inline directory verifiers
Message-ID: <20170331160743.GB3255@infradead.org>
References: <20170327230315.GB4864@birch.djwong.org>
 <20170328125104.GA4100@bfoster.bfoster>
 <20170328150047.GB4874@birch.djwong.org>
 <20170328151105.GC4100@bfoster.bfoster>
 <20170328172444.GE4100@bfoster.bfoster>
 <20170329182156.GC4864@birch.djwong.org>
 <20170329224110.GL17542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170329224110.GL17542@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Thu, Mar 30, 2017 at 09:41:10AM +1100, Dave Chinner wrote:
> > > I lost track of the fact that the first patch went into -rc and thus
> > > confused myself over where this should apply. This applies to 4.11.0-rc4
> > > and looks fine to me:
> > 
> > Does anyone have a problem if I send this to Linus for 4.11-rc5?
> > I'd rather atone for my sins sooner than later. :)
> 
> There's no urgency required here - it's just a cleanup patch. The
> code in the tree works fine, so why risk adding regressions
> at a late stage? Just add it to the for-next queue and let it soak
> until the merge window.

Is current Linus tree ok?  I'm pretty sure a recent Linus tree fell
over when running the dir fuzzers for me.  Which commit would the
latest actual fix be?
