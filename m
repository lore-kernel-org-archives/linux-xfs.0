Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D3B997F8E
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 16:28:37 -0500 (CDT)
Date: Tue, 13 Aug 2013 16:28:34 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: ***** SUSPECTED SPAM *****  [PATCH 00/50] xfs: patches for 3.12
Message-ID: <20130813212834.GD12719@sgi.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<20130812225513.GA12719@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130812225513.GA12719@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 12, 2013 at 05:55:13PM -0500, Ben Myers wrote:
> On Mon, Aug 12, 2013 at 08:49:21PM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > This is a rebase of the reviewed series of kernel patches I recently
> > posted here:
> > 
> > http://oss.sgi.com/pipermail/xfs/2013-July/028207.html
> > 
> > It addresses all the review comments except for one from Christoph
> > about the IOP_SIZE removal - I'll send a followup patch in a couple
> > of days to remove all the rest of IOP_ macros...
> > 
> > The log space problems from the optimisations have been fixed - the
> > fix went into patch 44 of this series, and cascaded through 45 and
> > 46 as well. Those patches will need reviewing. The problematic
> > workload has been running for 16 hours here without failure on a
> > small (10MB) log, so AFAICT the problem is fixed.
> > 
> > There is one new patch - the fix to the use-after-free of clean
> > buffer items when a transaction is cancelled - and that is at the
> > end of the series.
> 
> Pulled in patches 1 through 42.

Pulled in 43 through 47.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
