Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:21670 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752487AbeDEALR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Apr 2018 20:11:17 -0400
Date: Thu, 5 Apr 2018 10:06:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: V4.16+ kernel warning when running xfs/006
Message-ID: <20180405000625.GC23861@dastard>
References: <20180404231246.GA12299@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180404231246.GA12299@ming.t460p>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, dm-devel@redhat.com

On Thu, Apr 05, 2018 at 07:12:52AM +0800, Ming Lei wrote:
> Hi,
> 
> The following warning is triggered when running xfs/006 with
> v4.16+(the latest linus tree):
> 
> 
> [ 4406.277765] run fstests xfs/006 at 2018-04-04 19:18:32
> [ 4408.437679] XFS (dm-0): Mounting V5 Filesystem
> [ 4408.457115] XFS (dm-0): Ending clean mount
> [ 4430.340609] ------------[ cut here ]------------
> [ 4430.341255] DEBUG_LOCKS_WARN_ON(sem->owner != get_current())

Every filesystem is currently throwing these warnings - it's
the filesystem freeze code that is throwing them. The code is
perfectly OK, just the debug code doesn't understand that.

See https://marc.info/?l=linux-fsdevel&m=152285269706656&w=2

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
