Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:23204 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751007AbeACUi6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jan 2018 15:38:58 -0500
Date: Thu, 4 Jan 2018 07:38:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: speed up directory bestfree block scanning
Message-ID: <20180103203854.GM5858@dastard>
References: <20180103062748.16400-1-david@fromorbit.com>
 <20180103132802.GA17932@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180103132802.GA17932@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 03, 2018 at 08:28:03AM -0500, Brian Foster wrote:
> On Wed, Jan 03, 2018 at 05:27:48PM +1100, Dave Chinner wrote:
> > +			if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
> > +			    be16_to_cpu(bests[findex]) >= length) {
> > +				dbno = freehdr.firstdb + findex;
> > +				break;
> >  			}
> > +		} while (++findex < freehdr.nvalid);
> > +
> > +		/* Drop the block if we done with the freeblock */
> 
> "... if we're done ..."
> 
> Also FWIW, according to the comment it looks like the only reason the
> freehdr conversion is elevated to this scope is to accommodate gcc
> foolishness. If so, I'm wondering if a simple NULL init of bests at the
> top of the function would avoid that problem and allow us to move the
> code to where it was apparently intended to be in the first place. Hm?

Yeah, looking at the follow-on patch, there's a gigantic amount of
cleanup needed in this function. There's a bunch of "gcc is so
stupid" hacks amongst the code because the function is too long
for gcc correctly determine variable usage.

I might sit down and factor it properly because that will make it a
whole lot simpler and easier to understand...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
