Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:62225 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725872AbfBDVxg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 16:53:36 -0500
Date: Tue, 5 Feb 2019 08:53:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: allow disabling xfs tracepoints via Kconfig
Message-ID: <20190204215332.GB14116@dastard>
References: <20190204212035.9919-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204212035.9919-1-linux@rasmusvillemoes.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Feb 04, 2019 at 10:20:35PM +0100, Rasmus Villemoes wrote:
> linux/tracepoints.h allows individual subsystems to disable their
> tracepoints. Add such a knob for xfs. Disabling XFS_TRACEPOINTS
> reduces the resident size of xfs.ko by about a third, or ~350 KiB.

Ok, now we can't debug typical problems on live production systems
if tracepoints are turned off on the user/distro kernels.  So under
what circumstances would we ever want to turn off tracepoints on
XFS?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
