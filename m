Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:64255 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726687AbeLJVzM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Dec 2018 16:55:12 -0500
Date: Tue, 11 Dec 2018 08:55:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: RFD: question/probe regarding adding dump-levels A-Z after 0-9
 for xfs{dump,restore}
Message-ID: <20181210215507.GD6311@dastard>
References: <5C0A70FD.6080806@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C0A70FD.6080806@tlinx.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: L A Walsh <xfs@tlinx.org>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Dec 07, 2018 at 05:09:17AM -0800, L A Walsh wrote:
> How difficult would it be to allow 26 more dump levels
> in xfs dump/restore?  Theoretically anyone using 0-9
> would see no change.  Would there be some "problem" or
> "gotcha" in adding in what would _seem_ to be a simple
> change?

Everything _seems_ simple with xfsdump. e.g. the inventory
session headers supports up to 255 levels in it's on-disk format,
but the xfsdump command is limited to just 10 levels by a separate
"max level" define. 

IOWs, on the surface it _seems_ simple to change it, but I don't
know all the places that the dump level is stored, nor what would
happen if an older xfsdump/xfsrestore binary tripped over an
inventory with a dump level larger than they were compiled to
handle.

I also don't know if there are scalability problems with resolving
the contents of incremental dump levels. Certainly restoring from 30
incremental dumps is more onerous than 6-7, but that's just time.
What I don't know is how the invenetory scales to more than 10
incremental and whether there's some exponential algorithm in there
that falls apart. So there's a lot of testing that would be needed
to validate what looks like a 1 line change to the code.

So, yes, technically we could increase the dump level, but there's a
*lot* of verification work after doing so and it's not a risk-free
modification. 

FWIW, the idea behind 10 dump levels is that it is enough for a
full dump every week w/ an incremental every night of the week until
the next full dump is done on the weekend. What's the backup plan
you want to use/need that requires a larger number of incrementals?
Knowing what you want more dump levels for helps us understand how
it would be used and what really needs to be testedi first....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
