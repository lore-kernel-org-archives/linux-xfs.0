Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:48053 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751892AbcLAUUX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Dec 2016 15:20:23 -0500
Date: Fri, 2 Dec 2016 07:15:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS bug?
Message-ID: <20161201201552.GF11750@dastard>
References: <0F1FE7A8-D5C6-4FFD-9B9C-E03FB1962F3E@flyingcircus.io>
 <20161201110347.GD11750@dastard>
 <7D83E56E-5922-4B0D-A963-3C9F22491F94@flyingcircus.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7D83E56E-5922-4B0D-A963-3C9F22491F94@flyingcircus.io>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christian Theune <ct@flyingcircus.io>
Cc: linux-xfs@vger.kernel.org

On Thu, Dec 01, 2016 at 12:56:08PM +0100, Christian Theune wrote:
> Hi Dave,
> 
> (I hope I pick up the right quoting style.)
> 
> > On 1 Dec 2016, at 12:03, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > Hi Christian - thanks for perservering and getting this report to
> > the list. :P
> 
> Thanks for nudging me. :)
> 
> Not sure whether its possible or makes sense to answer this questions at the moment: should we feel safe running 4.4 right now?

Yes, I think this is a result of the kernel upgrade, not a problem
with the individual kernels. I strongly suggest that you run
xfsprogs 4.5.0 or more recent with the 4.4 kernel because it has
the matching AGFL packing fix in it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
