Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:65464 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728453AbeKIIAR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Nov 2018 03:00:17 -0500
Date: Fri, 9 Nov 2018 09:22:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 00/16] xfs: Block size > PAGE_SIZE support
Message-ID: <20181108222204.GD19305@dastard>
References: <20181107063127.3902-1-david@fromorbit.com>
 <20181107171405.GB4135@magnolia>
 <20181107220441.GX19305@dastard>
 <20181108013843.GB4127@magnolia>
 <20181108090432.GC19305@dastard>
 <20181108221756.GA15721@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181108221756.GA15721@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Nov 08, 2018 at 02:17:56PM -0800, Darrick J. Wong wrote:
> On Thu, Nov 08, 2018 at 08:04:32PM +1100, Dave Chinner wrote:
> > On Wed, Nov 07, 2018 at 05:38:43PM -0800, Darrick J. Wong wrote:
> > @@ -1416,6 +1420,11 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
> >  	loff_t o1, o2;
> >  	ssize_t nr;
> >  
> > +	offset -= offset % readbdy;
> > +	dest -= dest % writebdy;
> > +	if (o_direct)
> > +		length -= length % readbdy;
> 
> Don't we want byte-granularity copies if we're doing buffered copies?

Yes, just don't set -r/-w values when doing buffered IO. O_DIRECT
requires the length to be aligned, too, but buffered IO doesn't,
which is why the "if (o_direct)" case is there.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
