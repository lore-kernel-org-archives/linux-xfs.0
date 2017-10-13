Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:1309 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751339AbdJMWKs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2017 18:10:48 -0400
Date: Sat, 14 Oct 2017 09:08:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: move two more RT specific functions into
 CONFIG_XFS_RT
Message-ID: <20171013220825.GY15067@dastard>
References: <20171013120603.4135344-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171013120603.4135344-1-arnd@arndb.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org

On Fri, Oct 13, 2017 at 02:05:40PM +0200, Arnd Bergmann wrote:
> The last cleanup introduced two harmless warnings:
> 
> fs/xfs/xfs_fsmap.c:480:1: warning: '__xfs_getfsmap_rtdev' defined but not used
> fs/xfs/xfs_fsmap.c:372:1: warning: 'xfs_getfsmap_rtdev_rtbitmap_helper' defined but not used
> 
> This moves those two functions as well.

Curious. I didn't get those warnings on gcc 6.4 or 7.2 on x86-64.

Oh, CONFIG_XFS_DEBUG=y hides them, because it removes the "static"
declaration from them. Ok, that makes sense - I almost never build
a non-debug kernel. Have to make sure when I do config changes next
time to build without debug...

Thanks, Arnd!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
