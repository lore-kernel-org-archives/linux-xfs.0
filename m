Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from outbound-smtp12.blacknight.com ([46.22.139.17]:52899 "EHLO
        outbound-smtp12.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755974AbdJJJHg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2017 05:07:36 -0400
Received: from mail.blacknight.com (pemlinmail04.blacknight.ie [81.17.254.17])
        by outbound-smtp12.blacknight.com (Postfix) with ESMTPS id 068C11C2914
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2017 10:00:54 +0100 (IST)
Date: Tue, 10 Oct 2017 10:00:53 +0100
From: Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [ANNOUNCE] fsperf: a simple fs/block performance testing
 framework
Message-ID: <20171010090053.nygtcdda2soiw3mq@techsingularity.net>
References: <20171006210956.vf326sydjiphsefo@destiny>
 <20171009005137.GA3666@dastard>
 <20171009022509.rz6goq3sec5ppxrr@destiny>
 <20171009051731.GK3666@dastard>
 <20171009130050.ufnmdhslc53bwpgc@destiny>
 <20171009210920.GO3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20171009210920.GO3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 10, 2017 at 08:09:20AM +1100, Dave Chinner wrote:
> > I'd _like_ to expand fio for cases we come up with that aren't possible, as
> > there's already a ton of measurements that are taken, especially around
> > latencies.
> 
> To be properly useful it needs to support more than just fio to run
> tests. Indeed, it's largely useless to me if that's all it can do or
> it's a major pain to add support for different tools like fsmark.
> 
> e.g.  my typical perf regression test that you see the concurrnet
> fsmark create workload is actually a lot more. It does:
> 
> 	fsmark to create 50m zero length files
> 	umount,
> 	run parallel xfs_repair (excellent mmap_sem/page fault punisher)
> 	mount
> 	run parallel find -ctime (readdir + lookup traversal)
> 	unmount, mount
> 	run parallel ls -R (readdir + dtype traversal)
> 	unmount, mount
> 	parallel rm -rf of 50m files
> 
> I have variants that use small 4k files or large files rather than
> empty files, taht use different fsync patterns to stress the
> log, use grep -R to traverse the data as well as
> the directory/inode structure instead of find, etc.
> 

FWIW, this is partially implemented in mmtests as
configs/config-global-dhp__io-xfsrepair. It covers the fsmark and
xfs_repair part and an example report is

http://beta.suse.com/private/mgorman/results/home/marvin/openSUSE-LEAP-42.2/global-dhp__io-xfsrepair-xfs/delboy/#xfsrepair

(ignore 4.12.603, it's 4.12.3-stable with some additional patches that were
pending for -stable at the time the test was executed). That config was
added after a discussion with you a few years ago and I've kept it since as
it has been useful in a number of contexts. Adding additional tests to cover
parallel find, parallel ls and parallel rm would be relatively trivial but
it's not there. This is a test that doesn't have proper graphing support
but it could be added in 10-15 minutes as xfsrepair is the primary metric
and it's simply reported as elapsed time.

fsmark is also covered albeit not necessarily with parameters everyone wants
as configs/config-global-dhp__io-metadata in mmtests.  Example report is

http://beta.suse.com/private/mgorman/results/home/marvin/openSUSE-LEAP-42.2/global-dhp__io-metadata-xfs/delboy/#fsmark-threaded

mmtests has been modified multiple times as according as methodologies
were improved and it's far from perfect but it seems to me that fsperf
is going to end up reimplementing a lot of it.

It's not perfect as there are multiple quality-of-implementation issues
as it often takes the shortest path to being able to collect data but
it improves over time. When a test is found to be flawed, it's fixed and
historical data is discarded. It doesn't store data in sqlite or anything
fancy, just the raw logs are preserved and reports generated as required. In
terms of tools required, the core is just bash scripts. Some of the tests
require a number of packages to be installed but not all of them. It uses a
tool to install packages if they are missing but the naming is all based on
opensuse. It *can* map opensuse package names to fedora and debian but the
mappings are not up-to-date as I do not personally run those distributions.

Even with the quality-of-implementation issues, it seems to me that it
covers a lot of the requirements that fsperf aims for.

-- 
Mel Gorman
SUSE Labs
