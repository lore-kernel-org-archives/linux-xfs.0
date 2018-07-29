Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:3852 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725925AbeG2GIE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Jul 2018 02:08:04 -0400
Date: Sun, 29 Jul 2018 14:39:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: verify icount in superblock write
Message-ID: <20180729043900.GE2234@dastard>
References: <153262651940.8934.17525988748289196893.stgit@magnolia>
 <153262652554.8934.816888163232208002.stgit@magnolia>
 <20180726232028.GC2234@dastard>
 <20180727000715.GJ30972@magnolia>
 <20180727104439.GA21835@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180727104439.GA21835@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, billodo@redhat.com

On Fri, Jul 27, 2018 at 06:44:40AM -0400, Brian Foster wrote:
> That aside.. since these values shouldn't change often I'm wondering if
> it's worth calculating the global min/max once at mount time (we'd have

The values are needed during the initial read of the superblock
before any "for the life of the mount" calculations can be made,
and they can change across log recovery, too, if recovery replays a
growfs transaction. Hence they really need to be point in time
calculations based on the current superblock values during
superblock reads....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
