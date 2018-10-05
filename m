Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:51421 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726258AbeJFGiW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 02:38:22 -0400
Date: Sat, 6 Oct 2018 09:37:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] writeback: fix range_cyclic writeback vs writepages
 deadlock
Message-ID: <20181005233721.GI12041@dastard>
References: <20181005054526.21507-1-david@fromorbit.com>
 <20181005124640.3de2ba9dec8c713ee8cf286b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005124640.3de2ba9dec8c713ee8cf286b@linux-foundation.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, Oct 05, 2018 at 12:46:40PM -0700, Andrew Morton wrote:
> On Fri,  5 Oct 2018 15:45:26 +1000 Dave Chinner <david@fromorbit.com> wrote:
> 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We've recently seen a workload on XFS filesystems with a repeatable
> > deadlock between background writeback and a multi-process
> > application doing concurrent writes and fsyncs to a small range of a
> > file.
> > 
> > ...
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Jan Kara <jack@suse.de>
> 
> Not a serious enough problem for a -stable backport?

Don't have enough evidence to say one way or another. The reported
incident was from a RHEL 7 kernel, so the bug has been there for
years in one form or another, but it's only ever been triggered by
this one-off custom workload.

I haven't done any analysis on older kernels, nor have I looked to see
if there's any gotchas that a stable backport might encounter. And I
tend not to change stuff in a path that is critical to data integrity
without at least doing enough due diligence to suggest a stable
backport would be fine.

You can mark it for stable backports if you want, but I'm not
prepared to because I haven't done the work necessary to ensure it's
safe to do so.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
