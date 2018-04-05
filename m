Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:21080 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750726AbeDEWkg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Apr 2018 18:40:36 -0400
Date: Fri, 6 Apr 2018 08:40:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] xfs: pass xfs_dqblk to
 xfs_dquot_verify/xfs_dquot_repair
Message-ID: <20180405224033.GG23861@dastard>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
 <c92cfdb8-88c2-0f5b-7383-e5208fef6f5e@redhat.com>
 <20180405035241.GB7500@magnolia>
 <5c02fc77-28b6-4665-82f3-699fda82688c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c02fc77-28b6-4665-82f3-699fda82688c@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Apr 04, 2018 at 11:13:03PM -0500, Eric Sandeen wrote:
> On 4/4/18 10:52 PM, Darrick J. Wong wrote:
> > On Wed, Apr 04, 2018 at 01:54:26PM -0500, Eric Sandeen wrote:
> >> In order to validate the UUID in xfs_dquot_verify, we need
> >> the full xfs_qblk, not just the xfs_disk_dquot_t (which is
> > 
> >           ^^^^^^^^^ xfs_dqblk, right?
> 
> yup
> 
> ...
> 
> >> @@ -192,14 +191,10 @@
> > 
> > Any way you can get your diff generator to add -p to spit out the
> > alleged function this chunk is supposed to land in?  It makes reviewing
> > patches somewhat easier for me. :)
> 
> No doubt ... I don't know why it doesn't do so, sorry.  :/  Will try
> to figure that out.  Sorry about that.

diff -up

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
