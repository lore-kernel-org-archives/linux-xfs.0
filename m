Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:1606 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932227AbeCOW0H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Mar 2018 18:26:07 -0400
Date: Fri, 16 Mar 2018 09:26:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: detect agfl count corruption and reset agfl
Message-ID: <20180315222605.GK18129@dastard>
References: <20180314171724.41951-1-bfoster@redhat.com>
 <20180314181218.GR4865@magnolia>
 <CAC=E7cUme5-0z9GjVOynD==nK5aG2athrHmm=WKA8HBFWX-hRQ@mail.gmail.com>
 <20180315103839.GA44732@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180315103839.GA44732@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chiluk <chiluk+linuxxfs@indeed.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Mar 15, 2018 at 06:38:39AM -0400, Brian Foster wrote:
> On Wed, Mar 14, 2018 at 03:42:50PM -0500, Dave Chiluk wrote:
> > On Wed, Mar 14, 2018 at 1:12 PM, Darrick J. Wong
> > <darrick.wong@oracle.com> wrote:
> > > On Wed, Mar 14, 2018 at 01:17:24PM -0400, Brian Foster wrote:
> ...
> > 
> > Reviewed-by Dave Chiluk <chiluk+linuxxfs@indeed.com>
> > 
> > I'm also assuming this will get submitted back to the linux-stable
> > trees as the agfl packing change is already causing issues in the
> > stable trees.  If you do not intend to push it into the linux-stable
> > trees let me know and I'll take care of at least the major ones.
> > 
> 
> Yeah, I can cc stable in the next post along with the other minor fixes.
> My question is how far back should this fix go? Was the plan to only go
> back to v4.5 because that is where the packing fix first went in? Or
> should this go back further because it looks like the packing fix was
> backported to v3.10:
> 
> $ git show 96f859d52bcb1
> commit 96f859d52bcb1c6ea6f3388d39862bf7143e2f30
> Author: Darrick J. Wong <darrick.wong@oracle.com>
> Date:   Mon Jan 4 16:13:21 2016 +1100
> 
>     libxfs: pack the agfl header structure so XFS_AGFL_SIZE is correct
>     
>     ...
>     
>     cc: <stable@vger.kernel.org> # 3.10 - 4.4
>     Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>     Reviewed-by: Dave Chinner <dchinner@redhat.com>
>     Signed-off-by: Dave Chinner <david@fromorbit.com>

3.10 was when the problem was first introduced. I have no idea
whether it got backported that far but the stable kernel
maintainers, so you'll have to manually audit all current long-term
stable kernels to determine what kernels need backports.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
