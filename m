Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:3385 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753561AbdESAeh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2017 20:34:37 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dBVas-0004or-4O
        for linux-xfs@vger.kernel.org; Fri, 19 May 2017 10:16:34 +1000
Date: Fri, 19 May 2017 10:16:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Do we need a way to force xfsaild to run?
Message-ID: <20170519001634.GR17542@dastard>
References: <20170518142159.gkr6be4dralc6xiq@eorzea.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170518142159.gkr6be4dralc6xiq@eorzea.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Thu, May 18, 2017 at 04:21:59PM +0200, Carlos Maiolino wrote:
> Hi,
> 
> This is something I was thinking while working on that buffer retry stuff.
> 
> Currently, we have no way to force xfsaild to run, and I was wondering if
> somebody has any opinion if it would be useful to create a new xfsctl, to start
> xfsaild for debugging purposes, using xfs_io to trigger it.

THere's lots of ways to trigger it to run. You can do it on demand
via a freeze or remount-ro or by filling up the log, or get it to
run every second automatically iso there's no wait time at all by
turning /proc/sys/fs/xfs/xfssyncd_centiseconds down to the minimum.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
