Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43876 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbdGMFVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2017 01:21:39 -0400
Date: Wed, 12 Jul 2017 22:21:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 0/6] xfs: log recovery wrap and tail overwrite fixes
Message-ID: <20170713052131.GC4220@magnolia>
References: <20170710132800.19506-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170710132800.19506-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 10, 2017 at 09:27:54AM -0400, Brian Foster wrote:
> Hi all,
> 
> This is v2 of the tail overwrite detection series. Patches 1-4 include
> mostly minor changes to fix up some error handling issues and whatnot.
> Patch 5 is new and updates both of the torn write and tail overwrite
> detection mechanisms to handle corruption errors along with crc mismatch
> errors. Patch 6 is also new and a trivial introduction of a tracepoint.
> 
> This has survived a decent amount of testing to this point with various
> block sizes, logbsize values, and feature settings (debug on/off, crc
> on/off, reflink on/off) on a couple different arches (x86-64, ppc64).
> Thoughts, reviews, flames appreciated.

For the whole series,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Brian
> 
> v2:
> - Fix 64-bit division.
> - Fix up error checking in xlog_verify_[head|tail]() to only move tail
>   tail on corruption and otherwise fail mount immediately.
> - Added patch 5 to handle -EFSCORRUPTED on head/tail verification.
> - Added patch 6 to introduce log head/tail tracepoint.
> v1: http://www.spinics.net/lists/linux-xfs/msg07974.html
> - Add patch to fix log recovery header wrapping problem.
> - Replace transaction reservation rfc with log recovery based fix.
> - Replace custom log pinning sysfs knob with error injection tag.
> rfc: http://www.spinics.net/lists/linux-xfs/msg07623.html
> 
> Brian Foster (6):
>   xfs: fix recovery failure when log record header wraps log end
>   xfs: always verify the log tail during recovery
>   xfs: fix log recovery corruption error due to tail overwrite
>   xfs: add log item pinning error injection tag
>   xfs: handle -EFSCORRUPTED during head/tail verification
>   xfs: add log recovery tracepoint for head/tail
> 
>  fs/xfs/xfs_error.c       |   3 +
>  fs/xfs/xfs_error.h       |   4 +-
>  fs/xfs/xfs_log_recover.c | 157 +++++++++++++++++++++++++++++------------------
>  fs/xfs/xfs_trace.h       |  18 ++++++
>  fs/xfs/xfs_trans_ail.c   |  17 ++++-
>  5 files changed, 137 insertions(+), 62 deletions(-)
> 
> -- 
> 2.9.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
