Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57574 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbfFYDZi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 23:25:38 -0400
Date: Mon, 24 Jun 2019 20:25:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs cgroup writeback support
Message-ID: <20190625032527.GF1611011@magnolia>
References: <20190624134315.21307-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624134315.21307-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

On Mon, Jun 24, 2019 at 03:43:13PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this small series adds cgroup writeback support to XFS.  Unlike
> the previous iteration of the support a few years ago it also
> ensures that that trailing bios in an ioend inherit the right
> cgroup.  It has been tested with the shared/011 xfstests test
> that was written to test this functionality in all file systems,
> and manually by Stefan Priebe.
> 
> This work was funded by Profihost AG.
> 
> Note that the first patch was also in my series to move the xfs
> writepage code to iomap.c and the second one will conflict with
> it.  We'll need to sort out which series to merge first, but given
> how simple this one I would suggest to go for this one.

By the way, did all the things Dave complained about in last year's
attempt[1] to add cgroup writeback support get fixed?  IIRC someone
whose name I didn't recognise complained about log starvation due to
REQ_META bios being charged to the wrong cgroup and other misbehavior.

Also, I remember that in the earlier 2017 discussion[2] we talked about
a fstest to test that writeback throttling actually capped bandwidth
usage correctly.  I haven't been following cgroupwb development since
2017 -- does it not ratelimit bandwidth now, or is there some test for
that?  The only test I could find was shared/011 which only tests the
accounting, not bandwidth.

--D

[1] https://patchwork.kernel.org/comment/21658249/
[2] https://patchwork.kernel.org/comment/21042703/
