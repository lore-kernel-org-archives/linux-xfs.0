Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:36838 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727455AbfGHACM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Jul 2019 20:02:12 -0400
Date: Mon, 8 Jul 2019 10:01:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: RFC: use the iomap writepage path in gfs2
Message-ID: <20190708000103.GH7689@dread.disaster.area>
References: <20190701215439.19162-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701215439.19162-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com

On Mon, Jul 01, 2019 at 11:54:24PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> in this straight from the jetplane edition I present the series to
> convert gfs2 to full iomap usage for the ordered and writeback mode,
> that is we use iomap_page everywhere and entirely get rid of
> buffer_heads in the data path.  This has only seen basic testing
> which ensured neither 4k or 1k blocksize in ordered mode regressed
> vs the xfstests baseline, although that baseline tends to look
> pretty bleak.
> 
> The series is to be applied on top of my "lift the xfs writepage code
> into iomap v2" series.

Ok, this doesn't look too bad from the iomap perspective, though it
does raise more questions. :)

gfs2 now has two iopaths, right? One that uses bufferheads for
journalled data, and the other that uses iomap? That seems like it's
only a partial conversion - what needs to be done to iomap and gfs2
to support the journalled data path so there's a single data IO
path?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
