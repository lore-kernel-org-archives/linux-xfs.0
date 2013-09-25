Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 977C37F3F
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 19:31:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 33F28AC009
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 17:31:16 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	pw1M1sHTB2ltobdA for <xfs@oss.sgi.com>;
	Tue, 24 Sep 2013 17:31:13 -0700 (PDT)
Date: Wed, 25 Sep 2013 10:31:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: don't try to mark uncached buffers stale on
	error.
Message-ID: <20130925003108.GF26872@dastard>
References: <1380002476-18839-1-git-send-email-david@fromorbit.com>
	<1380002476-18839-2-git-send-email-david@fromorbit.com>
	<20130924153324.GF1935@sgi.com> <20130924203232.GA26872@dastard>
	<20130924205949.GK1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130924205949.GK1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 24, 2013 at 03:59:49PM -0500, Ben Myers wrote:
> Hi Dave,
> 
> On Wed, Sep 25, 2013 at 06:32:32AM +1000, Dave Chinner wrote:
> > On Tue, Sep 24, 2013 at 10:33:24AM -0500, Ben Myers wrote:
> > > ...but it looks like your fix is in xfs_bdstrat_cb, which wouldn't have been
> > > involved in the stack you posted above.  What am I missing?
> > 
> > That the first hunk that changes xfs_bioerror_relse() fixes the bug
> > that caused the assert failure through xfsbdstrat().
> 
> *blink*
> 
> All I see in that first hunk are changes to comments.  The second hunk seems to
> contain the only functional change, highlighted above.

You are right - it should not be reliably fixing the failure I'm
seeing. I'm sure there was something else in this patch originally -
I'll go back and check.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
