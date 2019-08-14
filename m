Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42804 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfHNPgN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Aug 2019 11:36:13 -0400
Date: Wed, 14 Aug 2019 08:18:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] mkfs: use cvtnum from libfrog
Message-ID: <20190814151844.GR7138@magnolia>
References: <20190813051421.21137-1-david@fromorbit.com>
 <20190813051421.21137-2-david@fromorbit.com>
 <20190813142414.GO7138@magnolia>
 <20190813212936.GF6129@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813212936.GF6129@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 14, 2019 at 07:29:36AM +1000, Dave Chinner wrote:
> On Tue, Aug 13, 2019 at 07:24:14AM -0700, Darrick J. Wong wrote:
> > On Tue, Aug 13, 2019 at 03:14:19PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > -	}
> > > -	if (*sp == 's') {
> > > -		if (!sectsize) {
> > > -			fprintf(stderr,
> > > -_("Sectorsize must be specified prior to using 's' suffix.\n"));
> > 
> > Hmm, so this message is replaced with "Not a valid value or illegal suffix"?
> 
> Actually, the error message is this:
> 
> # mkfs.xfs -f -b size=1b /dev/vdc
> Invalid value 1b for -b size option. Not a valid value or illegal suffix
> 
> It does actually tell you what the value is, what option is wrong,
> and the message shold be fairly clear that specifying the block size
> in using a "blocks" suffix is illegal.
> 
> > That's not anywhere near as helpful as the old message... maybe we
> > should have this set errno or something so that callers can distinguish
> > between "you sent garbled input" vs. "you need to set up
> > blocksize /sectsize"... ?
> 
> Actually, the error will only occur when you use -s size= or -b
> size= options, as if they are not specified we use the default
> values in mkfs and cvtnum is always called with a valid
> blocksize/sectorsize pair. i.e. This error only triggers when validating
> the base sector size/block size options because that occurs before
> we set the global varibles mkfs will use for cvtnum....
> 
> It's a chicken-egg thing, and I figured the error message prefix
> would be sufficient to point out the problem with the value suffic
> used for these kinda unusual corner cases.

Heh, ok, carry on then. :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
