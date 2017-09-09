Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:56712 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757173AbdIIBCO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Sep 2017 21:02:14 -0400
Date: Sat, 9 Sep 2017 11:02:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] define __ prefixed version of intXY_t types
Message-ID: <20170909010211.GI17782@dastard>
References: <20170908233616.26051-1-raj.khem@gmail.com>
 <20170909005609.GH17782@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170909005609.GH17782@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Khem Raj <raj.khem@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Sep 09, 2017 at 10:56:09AM +1000, Dave Chinner wrote:
> On Fri, Sep 08, 2017 at 04:36:16PM -0700, Khem Raj wrote:
> > This is required since musl does not define them
> > unlike glibc
> 
> [u]int*_t types are defined by the C99 standard and are supposed to
> be provided by stdint.h.  If musl is not providing stdint.h, then
> the C99 compliant compiler should be.

Sorry, ignore this, I read the defines the wrong way around. (more
coffee!)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
