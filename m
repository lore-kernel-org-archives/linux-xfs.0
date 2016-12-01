Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:8287 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756587AbcLAKuX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Dec 2016 05:50:23 -0500
Date: Thu, 1 Dec 2016 21:50:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: default mount options
Message-ID: <20161201105015.GC11750@dastard>
References: <583E1488.7090502@tlinx.org>
 <6ecda11c-a993-3dd7-5b87-1947506953ff@sandeen.net>
 <583F2806.7080102@tlinx.org>
 <e727dd60-777a-60d4-121e-2dd68981e176@sandeen.net>
 <583F30C8.1000206@tlinx.org>
 <20161130221837.GH31101@dastard>
 <583FA154.9050905@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <583FA154.9050905@tlinx.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: L A Walsh <xfs@tlinx.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Wed, Nov 30, 2016 at 08:04:36PM -0800, L A Walsh wrote:
> 	Related -- wondering about how external journals would affect need
> for barriers.

XFS correctly orders the cache flushes for it's different
devices to ensure integrity. e.g. it flushes the caches of the data
device which contains the filesytsem metadata before it issues the
the FUA write to the external log device.

And it does all the right cache flushes for both data and real-time
devices on fsync to ensure data updates are stable, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
