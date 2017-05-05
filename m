Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:16866 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750951AbdEEXKS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 May 2017 19:10:18 -0400
Date: Sat, 6 May 2017 09:09:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: make fatal assert failures conditional in debug
 mode
Message-ID: <20170505230943.GG17542@dastard>
References: <1493991086-18817-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493991086-18817-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, May 05, 2017 at 09:31:26AM -0400, Brian Foster wrote:
> XFS currently supports two debug modes: XFS_WARN enables assert
> failure warnings and XFS_DEBUG converts assert failures to fatal
> errors (via BUG()) and enables additional runtime debug code.
> 
> While the behavior to BUG the kernel on assert failure is useful in
> certain test scenarios, it is also useful for development/debug to
> enable debug mode code without having to crash the kernel on an
> assert failure.
> 
> To provide this additional flexibility, update XFS debug mode to not
> BUG() the kernel by default and create a new XFS kernel
> configuration option to enable fatal assert failures when debug mode
> is enabled. To provide backwards compatibility with current
> behavior, enable the fatal asserts option by default when debug mode
> is enabled.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Just a suggestion, but why make this a compile time option? Why not
a sysfs variable under /sys/fs/xfs/debug? That would be far more
useful to me - a single kernel that can be configure to just warn or
bug() dynamically. That will save us from having to rebuild a kernel
just to enable this functionality, then rebuild again to turn it
off..

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
