Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A02A7C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Dec 2021 21:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235748AbhLJVk2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Dec 2021 16:40:28 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:42453 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344481AbhLJVk1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Dec 2021 16:40:27 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 8CF04E0C790;
        Sat, 11 Dec 2021 08:36:50 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mvnZR-001Xm9-Rn; Sat, 11 Dec 2021 08:36:49 +1100
Date:   Sat, 11 Dec 2021 08:36:49 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chanchal Mathew <chanch13@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS journal log resetting
Message-ID: <20211210213649.GQ449541@dread.disaster.area>
References: <B11759AA-9760-4827-A9C9-BCF931B65D21@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B11759AA-9760-4827-A9C9-BCF931B65D21@gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61b3c872
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=IkcTkHD0fZMA:10 a=IOMw9HtfNCkA:10 a=7-415B0cAAAA:8
        a=05dte7VKzQBWFtwYlcEA:9 a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 10, 2021 at 10:27:11AM -0800, Chanchal Mathew wrote:
> Hi
> 
> A question for the developers -
> 
> Is there a reason why a clean unmount on an XFS filesystem would
> not reset the log numbers to 0? The xfs_logprint output shows the
> head and tail log numbers to have the same number > 0 and as
> CLEAN. But the log number is not reset to 0 without running a
> xfs_repair -L. Is there a reason it’s not done as part of the
> unmount?

Yes.

Log sequence numbers are a persistent record of when a given
metadata object was modified. They are stored in all metadata, not
just the log, and are used to determine if the modification in the
log found at recovery time is already present in the on-disk
metadata or not.

Resetting the number back to zero basically breaks this recovery
ordering verification, and takes us back to the bad old days of the
v4 filesystem format where log recovery could overwrite newer
changes in metadata. That could cause data loss and corruption
problems when recovering newly allocated inodes and subsequent
changes....

> The problem I’m noticing is, the higher the log number, it takes
> longer for it to be mounted. Most time seems spent on the
> xlog_find_tail() call. 

The log sequence number has nothign to do with how long
xlog_find_tail() takes to run. entirely dependent on the size
of the log and time it takes to binary search the journal to find
the head. The head then points at the tail, which then gets
verified. Once the head and tail are found, the journal contents
between the head and tail are CRC checked, and the time this takes
is entirely dependent on the distance between the head and tail of
the log (i.e. up to 2GB of journal space might get CRC'd here).

But at no point do larger LSNs make this take any longer.  The upper
32 bits of the LSN is just a cycle number, and it is always
interpreted as "past, current, next" by the xlog_find_tail()
process no matter what it's magnitude is. i.e. log recvoery only has
3 cycle states it cares about, regardless of how many cycles the log
has actually run.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
