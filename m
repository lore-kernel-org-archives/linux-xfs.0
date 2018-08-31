Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:58639 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725772AbeHaEiN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Aug 2018 00:38:13 -0400
Date: Fri, 31 Aug 2018 10:33:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs log write design
Message-ID: <20180831003325.GH5631@dastard>
References: <CA+1E3rJCdcLJVYrj89H1HQDr7ETpZzQzueb6oqg3eJnNZ_q+UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rJCdcLJVYrj89H1HQDr7ETpZzQzueb6oqg3eJnNZ_q+UQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Joshi <joshiiitr@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Aug 30, 2018 at 09:57:50PM +0530, Joshi wrote:
> This must be novice topic for the list, please excuse the ignorance.
> 
> When it comes to log write scheme in XFS, I wonder if I can draw
> parallel with any journaling mode of Ext4 (ordered or writeback)?

Neither, really.

The journal records metadata operations in the order they occur but
not data operations (like ext4 does in writeback mode), but XFS uses an
"update on IO completion" model for data-related metadata operations
such that the observable filesystem behaviour of ext4's ordered
mode behaviour ended up being very similar to XFS's behaviour.

[ Keep in mind that ext4 ordered mode is not the same as ext3 ordered
mode - ext4's behaviour is a hybrid writeback model because of
delayed allocation and not wanting the ext3 sync-the-world fsync()
problem. Another thing to keep in mind is that ext4 copied a fair
number of XFS behaviours to avoid data loss in delayed allocation
crash situations after ext4 "rediscovered" all the issues fixed
in XFS over 10+ years of using delayed allocation. ]

> I checked xlog_sync() code, and found that each log IO is marked with
> PREFLUSH and FUA (for internal log case).
> This perhaps makes it similar to "ordered" journal mode of Ext4.

No, the flushes have nothing to do with the this. They are about
ensuring completion-to-submission IO ordering constraints are
enforced at the storage level.

> But I am not sure about exact intent of choosing PREFLUSH for log
> write

If we don't flush the cache prior to the log write and we crash, the
log write might be on stable storage, but metadata we've written
back and told has been complete may not be. i.e. the log write
can overwrite metadta in the log may not be on stable storage if we
don't do a pre-flush to ensure completion-to-submission ordering is
enforced right down to the stable media.

> i.e.whether it is for all previous non-log IO (meta and data) or
> only for meta-IO. Nor I am sure whether xfs makes a conscious choice
> to issue data writes before meta or journal I/Os.

XFS does not control the order of data writes except for a few
corner cases where expeditious writing of data masks common
application-level data integrity bugs (typically unsafe overwrite
operations).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
