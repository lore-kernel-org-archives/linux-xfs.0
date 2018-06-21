Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:43961 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754206AbeFUD5x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jun 2018 23:57:53 -0400
Date: Thu, 21 Jun 2018 13:57:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs: fix divide-by-zero in align_ag_geometry
Message-ID: <20180621035749.GR19934@dastard>
References: <20180621025520.9115-1-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180621025520.9115-1-jeffm@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: jeffm@suse.com
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

On Wed, Jun 20, 2018 at 10:55:20PM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> Commit 051b4e37f5e (mkfs: factor AG alignment) factored out the
> AG alignment code into a separate function.  It got rid of
> redundant checks for dswidth != 0 but did too good a job since now
> it doesn't check at all.

Of course they got removed - we've already validated the CLI input
and guaranteed that cfg->dswidth can only be zero iff cfg->dsunit is
zero in calc_stripe_factors().

i.e. We do input validation of CLI paramters before anything else so
that later users (like align_ag_geometry()) can assume the
parameters they are using are valid. In this case, the assumption is
that either both dsunit and dswidth are zero or that both are
non-zero and dswidth an integer multple of dsunit.

> When we hit the check to see if agsize
> is a multiple of stripe width: (cfg->agsize % cfg->dswidth), we crash
> on a divide by zero.

What CLI config did you use to hit this? I'd like to reproduce it so
I can see where calc_stripe_factors() is going wrong....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
