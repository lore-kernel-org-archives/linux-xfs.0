Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:63993 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388543AbeGXX4N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jul 2018 19:56:13 -0400
Date: Wed, 25 Jul 2018 08:47:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Query about the handling of a bug reported before
Message-ID: <20180724224727.GA2234@dastard>
References: <21AA8603-85D9-429A-A713-8B86F341FFC4@gatech.edu>
 <20180723123239.GA46987@bfoster>
 <0845407C-6013-44BB-95D0-F1CC66B0ECB6@gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0845407C-6013-44BB-95D0-F1CC66B0ECB6@gatech.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Xu, Wen" <wen.xu@gatech.edu>
Cc: Brian Foster <bfoster@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Mon, Jul 23, 2018 at 02:27:02PM +0000, Xu, Wen wrote:
> Hi Brian,
> 
> Yeah I tested it which is fixed in latest kernel. I just wonder if there is a specific patch
> for this.

The code was fixed as a result of committing the huge patch series
that removed bufferheads from the XFS IO path.  i.e. the bug went
away because of other changes that addressed the root cause, not
because we committed a change that specifically fixed the bug. Most
likely it was this commit in the middle of the series to remove
bufferhead dependencies in xfs_aops_discard_page() that solved the
problem.

e2ac836307e3 ("xfs: simplify xfs_bmap_punch_delalloc_range")

-Dave.

-- 
Dave Chinner
david@fromorbit.com
