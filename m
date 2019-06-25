Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33470 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbfFYKPq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jun 2019 06:15:46 -0400
Date: Tue, 25 Jun 2019 12:15:15 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/12] iomap: add tracing for the address space
 operations
Message-ID: <20190625101515.GL1462@lst.de>
References: <20190624055253.31183-1-hch@lst.de> <20190624055253.31183-13-hch@lst.de> <20190624234921.GE7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624234921.GE7777@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jun 25, 2019 at 09:49:21AM +1000, Dave Chinner wrote:
> > +#undef TRACE_SYSTEM
> > +#define TRACE_SYSTEM iomap
> 
> Can you add a comment somewhere here that says these tracepoints are
> volatile and we reserve the right to change them at any time so they
> don't form any sort of persistent UAPI that we have to maintain?

Sure.  Note that we don't have any such comment in xfs either..
