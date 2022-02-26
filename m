Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D1FEC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Feb 2022 21:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiBZViC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 26 Feb 2022 16:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiBZViB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 26 Feb 2022 16:38:01 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D8DB268
        for <linux-xfs@vger.kernel.org>; Sat, 26 Feb 2022 13:37:24 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EBBE5531F9D;
        Sun, 27 Feb 2022 08:37:21 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nO4ki-00GnUh-Fi; Sun, 27 Feb 2022 08:37:20 +1100
Date:   Sun, 27 Feb 2022 08:37:20 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH 19/17] mkfs: increase default log size for new (aka
 bigtime) filesystems
Message-ID: <20220226213720.GQ59715@dread.disaster.area>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <20220226025450.GY8313@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220226025450.GY8313@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=621a9d94
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=ATPPyKICscX_3wY5w6kA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 25, 2022 at 06:54:50PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Recently, the upstream kernel maintainer has been taking a lot of heat on
> account of writer threads encountering high latency when asking for log
> grant space when the log is small.  The reported use case is a heavily
> threaded indexing product logging trace information to a filesystem
> ranging in size between 20 and 250GB.  The meetings that result from the
> complaints about latency and stall warnings in dmesg both from this use
> case and also a large well known cloud product are now consuming 25% of
> the maintainer's weekly time and have been for months.

Is the transaction reservation space exhaustion caused by, as I
pointed out in another thread yesterday, the unbound concurrency in
IO completion? i.e. we have hundreds of active concurrent
transactions that then block on common objects between them (e.g.
inode locks) and serialise? Hence only handful of completions can
actually run concurrently, depsite every completion holding a full
reservation of log space to allow them to run concurrently?

> For small filesystems, the log is small by default because we have
> defaulted to a ratio of 1:2048 (or even less).  For grown filesystems,
> this is even worse, because big filesystems generate big metadata.
> However, the log size is still insufficient even if it is formatted at
> the larger size.
> 
> Therefore, if we're writing a new filesystem format (aka bigtime), bump
> the ratio unconditionally from 1:2048 to 1:256.  On a 220GB filesystem,
> the 99.95% latencies observed with a 200-writer file synchronous append
> workload running on a 44-AG filesystem (with 44 CPUs) spread across 4
> hard disks showed:
> 
> Log Size (MB)	Latency (ms)	Throughput (MB/s)
> 10		520		243
> 20		220		308
> 40		140		360
> 80		92		363
> 160		86		364
> 
> For 4 NVME, the results were:
> 
> 10		201		409
> 20		177		488
> 40		122		550
> 80		120		549
> 160		121		545
> 
> Hence we increase the ratio by 16x because there doesn't seem to be much
> improvement beyond that, and we don't want the log to grow /too/ large.

1:2048 -> 1:256 is an 8x bump, yes?  Which means we'll get a 2GB log
on a 512GB filesystem, and the 220GB log you tested is getting a
~1GB log?

I also wonder if the right thing to do here is just set a minimum
log size of 32MB? The worst of the long tail latencies are mitigated
by this point, and so even small filesystems grown out to 200GB will
have a log size that results in decent performance for this sort of
workload.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
