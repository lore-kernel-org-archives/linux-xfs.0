Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:43187 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753254AbcK3WSk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Nov 2016 17:18:40 -0500
Date: Thu, 1 Dec 2016 09:18:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: default mount options
Message-ID: <20161130221837.GH31101@dastard>
References: <583E1488.7090502@tlinx.org>
 <6ecda11c-a993-3dd7-5b87-1947506953ff@sandeen.net>
 <583F2806.7080102@tlinx.org>
 <e727dd60-777a-60d4-121e-2dd68981e176@sandeen.net>
 <583F30C8.1000206@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <583F30C8.1000206@tlinx.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: L A Walsh <xfs@tlinx.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Wed, Nov 30, 2016 at 12:04:24PM -0800, L A Walsh wrote:
> 
> 
> Eric Sandeen wrote:
> >
> >> But those systems also, sometimes, change runtime
> >>behavior based on the UPS or battery state -- using write-back on
> >>a full-healthy battery, or write-through when it wouldn't be safe.
> >>
> >>    In that case, it seems nobarrier would be a better choice
> >>for those volumes -- letting the controller decide.
> >
> >No.  Because then xfs will /never/ send barriers requests, even
> >if the battery dies.  So I think you have that backwards.

Let's just get somethign straight first - there is no "barrier"
operation that is sent to the storage, and Linux does not have
"barriers" anymore. What we now do is strictly order our IO at the
filesystem level and issue cache flush requests to ensure all IO
prior to the cache flush request is on stable storage. We also make
use of FUA writes, which guarantee that a specific write hits stable
storage before the filesystem is told that it is complete (FUA is
emulated with post-IO cache flush requests on devices that don't
support FUA).

This is why "barriers" no longer have a performance cost - we don't
need to empty the IO pipeline to guarantee integrity anymore. And it
should be clear why hardware that has non-volatile caches don't care
whether "barriers" are enabled or not because all writes are FUA and
cache flushes are no-ops.

IOWs, "barriers" are an outdated concept and we only still have it
hanging around because we were stupid enough to name a mount option
after an implementation, rather than the feature it provided.

> ---
> 	If the battery dies, then the controller shifts
> to write-through and no longer uses its write cache.  This is
> documented and observed behavior.

For /some/ RAID controllers in /some/ modes. For example, the
megaraid driver that has been ignoring cache flushes for over 9
years because in RAID mode it doesn't need it. However, in JBOD
mode, that same controller requires cache flushes to be sent because
it turns off sane cache management behaviour in JBOD mode:

ommit 1e793f6fc0db920400574211c48f9157a37e3945
Author: Kashyap Desai <kashyap.desai@broadcom.com>
Date:   Fri Oct 21 06:33:32 2016 -0700

    scsi: megaraid_sas: Fix data integrity failure for JBOD (passthrough) devices
    
    Commit 02b01e010afe ("megaraid_sas: return sync cache call with
    success") modified the driver to successfully complete SYNCHRONIZE_CACHE
    commands without passing them to the controller. Disk drive caches are
    only explicitly managed by controller firmware when operating in RAID
    mode. So this commit effectively disabled writeback cache flushing for
    any drives used in JBOD mode, leading to data integrity failures.


This is a clear example of why "barriers" should always be on and
cache flushes always passed through to the storage - because we just
don't know WTF the storage is actually doing with it's caches.

Quite frankly, I think it's time we marked the "barrier/nobarrier"
mount options as deprecated and simply always issue the required
cache flushes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
