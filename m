Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59546 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751728AbdJNLL5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 14 Oct 2017 07:11:57 -0400
Date: Sat, 14 Oct 2017 07:11:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: move two more RT specific functions into
 CONFIG_XFS_RT
Message-ID: <20171014111153.GA50635@bfoster.bfoster>
References: <20171013120603.4135344-1-arnd@arndb.de>
 <20171013220825.GY15067@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171013220825.GY15067@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>, Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org

On Sat, Oct 14, 2017 at 09:08:25AM +1100, Dave Chinner wrote:
> On Fri, Oct 13, 2017 at 02:05:40PM +0200, Arnd Bergmann wrote:
> > The last cleanup introduced two harmless warnings:
> > 
> > fs/xfs/xfs_fsmap.c:480:1: warning: '__xfs_getfsmap_rtdev' defined but not used
> > fs/xfs/xfs_fsmap.c:372:1: warning: 'xfs_getfsmap_rtdev_rtbitmap_helper' defined but not used
> > 
> > This moves those two functions as well.
> 
> Curious. I didn't get those warnings on gcc 6.4 or 7.2 on x86-64.
> 
> Oh, CONFIG_XFS_DEBUG=y hides them, because it removes the "static"
> declaration from them. Ok, that makes sense - I almost never build
> a non-debug kernel. Have to make sure when I do config changes next
> time to build without debug...
> 

Ah, that explains why I didn't reproduce them either, thanks!

Brian

> Thanks, Arnd!
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
