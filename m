Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:42726 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726124AbfHMVar (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Aug 2019 17:30:47 -0400
Date: Wed, 14 Aug 2019 07:29:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] mkfs: use cvtnum from libfrog
Message-ID: <20190813212936.GF6129@dread.disaster.area>
References: <20190813051421.21137-1-david@fromorbit.com>
 <20190813051421.21137-2-david@fromorbit.com>
 <20190813142414.GO7138@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813142414.GO7138@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 13, 2019 at 07:24:14AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 13, 2019 at 03:14:19PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > -	}
> > -	if (*sp == 's') {
> > -		if (!sectsize) {
> > -			fprintf(stderr,
> > -_("Sectorsize must be specified prior to using 's' suffix.\n"));
> 
> Hmm, so this message is replaced with "Not a valid value or illegal suffix"?

Actually, the error message is this:

# mkfs.xfs -f -b size=1b /dev/vdc
Invalid value 1b for -b size option. Not a valid value or illegal suffix

It does actually tell you what the value is, what option is wrong,
and the message shold be fairly clear that specifying the block size
in using a "blocks" suffix is illegal.

> That's not anywhere near as helpful as the old message... maybe we
> should have this set errno or something so that callers can distinguish
> between "you sent garbled input" vs. "you need to set up
> blocksize /sectsize"... ?

Actually, the error will only occur when you use -s size= or -b
size= options, as if they are not specified we use the default
values in mkfs and cvtnum is always called with a valid
blocksize/sectorsize pair. i.e. This error only triggers when validating
the base sector size/block size options because that occurs before
we set the global varibles mkfs will use for cvtnum....

It's a chicken-egg thing, and I figured the error message prefix
would be sufficient to point out the problem with the value suffic
used for these kinda unusual corner cases.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
