Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:36518 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751554AbdHAWXe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2017 18:23:34 -0400
Date: Wed, 2 Aug 2017 08:23:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: metadata I/O error: block 0x575b6d70,("xfs_trans_read_buf_map")
 error 4 numblks 16
Message-ID: <20170801222330.GO17762@dastard>
References: <e4606e43-468e-431c-1663-6b167cc5648b@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4606e43-468e-431c-1663-6b167cc5648b@profihost.ag>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 01, 2017 at 10:12:57AM +0200, Stefan Priebe - Profihost AG wrote:
> Hello,
> 
> under very high load i'm getting the following error on a bcache device
> using XFS:
> XFS (bcache1): metadata I/O error: block 0x575b6d70
> ("xfs_trans_read_buf_map") error 4 numblks 16

#define EINTR            4      /* Interrupted system call */

That's an EINTR error coming from the block layer. This is most
definitely not an error that the block layer should be returning to
the filesystem.

IOWs, you've hit a bcache bug.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
