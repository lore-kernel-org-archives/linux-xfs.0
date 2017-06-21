Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52526 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751434AbdFUKKz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Jun 2017 06:10:55 -0400
Date: Wed, 21 Jun 2017 06:10:52 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170621101049.GB28914@bfoster.bfoster>
References: <20170616105445.3314-1-cmaiolino@redhat.com>
 <20170616105445.3314-3-cmaiolino@redhat.com>
 <20170616183510.GC21846@wotan.suse.de>
 <20170616192445.GG5421@birch.djwong.org>
 <20170616193755.GD21846@wotan.suse.de>
 <3ff0e0c8-ef9c-b7f8-d37e-ed02e5766c40@sandeen.net>
 <20170619105904.GA25255@bfoster.bfoster>
 <20170620165204.GP21846@wotan.suse.de>
 <20170620172041.GD3348@bfoster.bfoster>
 <20170620180505.GT21846@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170620180505.GT21846@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Jun 20, 2017 at 08:05:05PM +0200, Luis R. Rodriguez wrote:
> On Tue, Jun 20, 2017 at 01:20:41PM -0400, Brian Foster wrote:
> > On Tue, Jun 20, 2017 at 06:52:04PM +0200, Luis R. Rodriguez wrote:
> > > On Mon, Jun 19, 2017 at 06:59:05AM -0400, Brian Foster wrote:
> > > > It hasn't seemed necessary to me to take that approach given the lower
> > > > prevalence of the issue 
> > > 
> > > Of this issue? I suppose its why I asked about examples of issues, I seem
> > > to have found it likely much more possible out in the wild than expected.
> > > It would seem folks might be working around it somehow.
> > > 
> > 
> > If we're talking about the thin provisioning case, I suspect most people
> > work around it by properly configuring their storage. ;)
> 
> The fact that we *hang* makes it more serious, so even if folks misconfigured
> storage with less space it should be no reason to consider hangs any less
> severe. Specially if it seems to be a common issue, and I'm alluding to the
> fact that this might be more common than the patch describes.
> 

My point is simply that a hang was a likely outcome before the patch
that introduced the regression as well, so the benefit of doing a proper
revert doesn't clearly outweigh the cost. Despite what the side effect
is, the fact that this tends to primarily affect users who have thin
volumes going inactive also suggests that this can be worked around
reasonably well enough via storage configuration. This all suggests to
me that Carlos' current approach is the most reasonable one. 

I'm not following what the line of argument is here. Are you suggesting
a different approach? If so, based on what use case/reasoning?

Brian

>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
