Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49106 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbeAVXZH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jan 2018 18:25:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0MNBrt8031488
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2018 23:25:06 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2fnrnag7dg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2018 23:25:06 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0MNP5RB027921
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2018 23:25:05 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0MNP5qV007058
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2018 23:25:05 GMT
Date: Mon, 22 Jan 2018 15:25:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/6] xfs: reflink fixes
Message-ID: <20180122232504.GO25805@magnolia>
References: <151651282961.28390.17944517354130397779.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151651282961.28390.17944517354130397779.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Sat, Jan 20, 2018 at 09:33:49PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Running generic/232 with quotas and reflink demonstrated that there was
> something wrong with the way we did quota accounting -- on an otherwise
> idle system, fs-wide du block count numbers didn't match the quota
> reports.  I started digging into why the quota accounting was wrong, and
> the following are the results of my bug hunt.

Well, I wasn't expecting 4.15 to be delayed again, but I guess it has.
To disambiguate: this series is intended for 4.16, even though I already
sent out the AGFL series tagged for 4.17.

--D

> The first patch teaches the reflink code to break layout leases before
> commencing the block remapping work.  This time we avoid the "looping
> trying to get a lock" that Christoph complained about, in favor of
> dropping both locks and retrying if we can't cleanly break the layouts
> without waiting.
> 
> The second patch changes the source file locking (if src != dest) during
> a reflink operation to take the shared locks when possible.  The only
> thing changing in the source file is the setting of the reflink iflag,
> for which we will still take ILOCK_EXCL.  The net result of this is
> less lock contention during fsstress and a 30% lower runtime, not that
> anyone cares about fsstress benchmarking. :)
> 
> Patch three ensure that we attach dquots to inodes before we start
> reflinking their blocks.  This could lead to quota undercharging; an
> fstest to check this will be sent separately.
> 
> Patch four reorganizes the copy on write quota updating code to reflect
> how the CoW fork works now.  In short, the CoW fork is entirely in
> memory, so we can only use the in-memory quota reservation counters for
> all CoW blocks; the accounting only becomes permanent if we remap an
> extent into the data fork.
> 
> Patch five creates a separate i_cow_blocks counter to track all the CoW
> blocks assigned to a file, which makes changing a file's uid/gid/prjid
> easier, makes reporting cow blocks via stat easy, and enables various
> cleanups.
> 
> Patch six fixes a serious potential corruption problem with the cow
> extent allocation -- when we allocate into the CoW fork with the cow
> extent size hint set, the allocator enlarges the allocation request to
> try to hit alignment goals.  However, if the allocated extent does not
> actually fulfill any of the requested range, we send a garbage
> zero-length extent back to the iomap code (which also doesn't notice),
> and the write lands at the startblock of the garbage extent.  The fix is
> to detect that we didn't fill the entire requested range and fix up the
> returned mapping so that we always fill the first block of the
> requested allocation.
> 
> --D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
