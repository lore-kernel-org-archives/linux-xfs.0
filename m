Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:42664 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726179AbfFDWBt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 18:01:49 -0400
Date: Wed, 5 Jun 2019 08:01:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: understanding xfs vs. ext4 log performance
Message-ID: <20190604220142.GY29573@dread.disaster.area>
References: <7a642f570980609ccff126a78f1546265ba913e2.camel@lynxeye.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a642f570980609ccff126a78f1546265ba913e2.camel@lynxeye.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lucas Stach <dev@lynxeye.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Jun 04, 2019 at 11:21:15AM +0200, Lucas Stach wrote:
> Hi all,
> 
> this question is more out of curiosity and because I want to take the
> chance to learn something.
> 
> At work we've stumbled over a workload that seems to hit pathological
> performance on XFS. Basically the critical part of the workload is a
> "rm -rf" of a pretty large directory tree, filled with files of mixed
> size ranging from a few KB to a few MB. The filesystem resides on quite
> slow spinning rust disks, directly attached to the host, so no
> controller with a BBU or something like that involved.
> 
> We've tested the workload with both xfs and ext4, and while the numbers
> aren't completely accurate due to other factors playing into the
> runtime, performance difference between XFS and ext4 seems to be an
> order of magnitude. (Ballpark runtime XFS is 30 mins, while ext4
> handles the remove in ~3 mins).

Without knowing exactly what filesystem configurations you are
testing on, the performance numbers are meaningless:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> The XFS performance seems to be completly dominated by log buffer
> writes, which happen with both REQ_PREFLUSH and REQ_FUA set. It's
> pretty obvious why this kills performance on slow spinning rust.

In general, you should see almost no log traffic on a rm -rf
workload as the eventual result is that all the inodes and metadata
are marked stale and they don't even get written to the log.

If you are seeing lots of log writes, it indicates to me that you
are testing on very small filesystems and/or filesystems with tiny
logs, resulting in frequent tail pushing to make space in the log
for transaction reservations....

> Now the thing I wonder about is why ext4 seems to get a away without
> those costly flags for its log writes. At least blktrace shows almost
> zero PREFLUSH or FUA requests. Is there some fundamental difference in
> how ext4 handles its logging to avoid the need for this ordering and
> forced access, or is it ext just living more dangerously with regard to
> reordered writes?

If ext4 is not doing cache flushes and/or FUA for it's log writes
then it's broken w.r.t. data integrity. I'm pretty sure that's not
the case. Fundamentally, ext4 has the same journal write ordering
requirements as XFS, it's probably just that for the filesystem
sizes you are testing the ext4 log is larger and fitting the working
set of operations in it without running out of space and having to
flush frequently....

> Does XFS really require such a strong ordering on the log buffer
> writes? I don't understand enough of the XFS transaction code and
> wonder if it would be possible to do the strongly ordered writes only
> on transaction commit.

We don't write anything on transaction commit. We aggregate
committed transactions in memory and then checkpoint the journal
when a flush is required. It's all spelled out in detail in
Documentation/filesystems/xfs-delayed-logging-design.txt in the
kernel tree. It's a similar checkpointing architecture to what ext4
uses, with similar performance in most cases.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
