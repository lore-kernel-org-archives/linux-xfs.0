Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:31494 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730734AbeLNVU0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Dec 2018 16:20:26 -0500
Date: Sat, 15 Dec 2018 08:20:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS and RAID10 with o2 layout
Message-ID: <20181214212022.GL6311@dastard>
References: <d9fc0327-eef3-63bd-82a3-98545251bfe5@4net.rs>
 <20181213220533.GH6311@dastard>
 <3e0e8def-2bb4-5e8a-56c1-d010ede059d4@4net.rs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e0e8def-2bb4-5e8a-56c1-d010ede059d4@4net.rs>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sinisa <sinisa@4net.rs>
Cc: linux-raid@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, Dec 14, 2018 at 08:03:36AM +0100, Sinisa wrote:
> On 12/13/18 11:05 PM, Dave Chinner wrote:
> >On Wed, Dec 12, 2018 at 01:29:49PM +0100, Sinisa wrote:
> >Basically, this looks and smells like a MD sync barrier race
> >condition, not an XFs problem.
> 
> But why don't we see the same issue with other filesystems?

XFS has a lot more parallelism at the storage layer than other
filesystems and has a different integrity synchronisation model (via
IO completion processing rather than submission serialisation), so
it stresses the underlying storage very differently to other
filesystems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
