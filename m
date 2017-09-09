Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:19122 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757173AbdIIA4M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Sep 2017 20:56:12 -0400
Date: Sat, 9 Sep 2017 10:56:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] define __ prefixed version of intXY_t types
Message-ID: <20170909005609.GH17782@dastard>
References: <20170908233616.26051-1-raj.khem@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170908233616.26051-1-raj.khem@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Khem Raj <raj.khem@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Sep 08, 2017 at 04:36:16PM -0700, Khem Raj wrote:
> This is required since musl does not define them
> unlike glibc

[u]int*_t types are defined by the C99 standard and are supposed to
be provided by stdint.h.  If musl is not providing stdint.h, then
the C99 compliant compiler should be.

What's the compilation error you're trying to fix?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
