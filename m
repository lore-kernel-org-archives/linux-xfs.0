Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:11327 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751362AbeDEVOk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Apr 2018 17:14:40 -0400
Date: Fri, 6 Apr 2018 07:14:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: reset xfs_inode struct on reclaim in debug mode
Message-ID: <20180405211437.GD23861@dastard>
References: <20180405121147.60897-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180405121147.60897-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 05, 2018 at 08:11:46AM -0400, Brian Foster wrote:
> A test case to reproduce a filestream/MRU use-after-free of a
> reclaimed inode requires bits (e.g., ip->i_mount) of the inode to be
> reset/reused once the inode memory is freed. This normally only
> occurs when a new page is cycled into the zone, however.
> 
> Perform the "one-time" inode init immediately prior to freeing
> inodes when in DEBUG mode. This will zero the inode, init the low
> level structures (locks, lists, etc.) and otherwise ensure each
> inode is in a purely uninitialized state while sitting in the zone
> as free memory.

Does KASAN catch this use-after-free? i.e. Given that people
regularly run fstests with KASAN enabled, do we need to change the
code for the test to trigger detection?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
