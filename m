Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:48790 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754117AbeBLVVJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Feb 2018 16:21:09 -0500
Date: Tue, 13 Feb 2018 08:21:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Cleanup old XFS_BTREE_* traces
Message-ID: <20180212212106.GD6778@dastard>
References: <20180212130005.7199-1-cmaiolino@redhat.com>
 <20180212182948.GB5217@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180212182948.GB5217@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Feb 12, 2018 at 10:29:48AM -0800, Darrick J. Wong wrote:
> On Mon, Feb 12, 2018 at 02:00:05PM +0100, Carlos Maiolino wrote:
> > Remove unused legacy btree traces from IRIX era.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> > 
> > Talking to Dave about it, he mentioned XFS_BTREE_TRACE_CURSOR might be worth to
> > turn into a proper ftrace trace point, so I didn't touch _CURSOR traces in this
> > patchset, and a proper conversion will be sent later, unless it's not worth at
> > all, and I should send a V2 also removing TRACE_CURSOR.
> 
> TBH I wonder the opposite -- why not turn all of these into tracepoints?

TBH, we haven't used them in at least 15 years. What value do they
provide apart from making the traces even noisier (and potentially
more lossy) than they already are?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
