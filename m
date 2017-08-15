Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:25809
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752946AbdHODcT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Aug 2017 23:32:19 -0400
Date: Tue, 15 Aug 2017 13:32:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 08/13] xfs: parent pointer attribute creation
Message-ID: <20170815033216.GI21024@dastard>
References: <1502329293-4091-1-git-send-email-allison.henderson@oracle.com>
 <1502329293-4091-9-git-send-email-allison.henderson@oracle.com>
 <20170815000606.GS4796@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170815000606.GS4796@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs@vger.kernel.org

On Mon, Aug 14, 2017 at 05:06:06PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 09, 2017 at 06:41:28PM -0700, Allison Henderson wrote:
> > +	/* Try to add the attr to the attribute list in the inode. */
> > +	xfs_attr_shortform_create(&args);
> > +	error = xfs_attr_shortform_addname(&args);
> > +	if (error != -ENOSPC)
> > +		return error;
> 
> I wonder, what happens if we exceed the maximum number of attr fork
> extents by linking a file too many times?

We'll hit free space indexing scalability problems with the dir1
format used by the attr tree before we get there. And to solve that
we simply convert the attr code to use the dir3 format tree....

> Would be nice if we could
> bail out early (instead of shutting down the fs) if we were reasonably
> sure it was going to blow up anyway.
> 
> Though, I'm wondering how we handle that in general since I don't see
> any obvious checking...
> 
> Also seems a little fishy that we keep going even if ENOSPC, even though
> the comment below says we're allowed to dip into the reserved space to
> avoid this condition?

When I wrote this, we had a small, fixed reserve pool that could be
depleted by excessive operation at ENOSPC conditions, and hence
ENOSPC could still occur (however unlikely it might be).

Once again, the reserve pool is very different now, so the
assumptions this code makes about ENOSPC behaviour might not be
valid anymore...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
