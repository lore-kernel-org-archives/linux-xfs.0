Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1DF9C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EC8022475
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgLaWjd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:39:33 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52464 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgLaWjc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:39:32 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMV5lZ131265
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:38:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=YlSCRLnONyZoOHG/MLU+eURVpPE5CCVjOt0YB6mDL/s=;
 b=tAQlr5oPF1nSIOvNYW+P4mR0brd1qW7N83LY1GlFSTtT+pochNZBCkyMjMQJFm5Nd8Kp
 NlYD+O/3ystbfGj6w7tGytzdCMkHG/07CwGegjsqw8JZyPhz5yRj3zBIrTaApLSk8lk4
 Kvxw4OGrN+38lR7oGcBeup9dReX1bc+1PMsbsu2gd3F3guDTmHaCHXxmcBn0KncXm0y1
 A4BX6BkW9k75+7GQfOA++y7ooaTVMXKUSxgFMZ2H1SENgyM427yLwnheYnTycSb73eXR
 pQTPZHHcO/gtjW7rJeFNygSmGc10mKgUH+1sza4+GZODa+UEZJqMvopz+FQkcChZBUuY Bw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35rk3bv3hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:38:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMU6bJ130866
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:38:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 35pexukrxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:38:49 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BVMcmE3032656
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:38:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:38:48 -0800
Date:   Thu, 31 Dec 2020 14:38:47 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: 2020 NYE Patchbomb Guide!
Message-ID: <20201231223847.GI6918@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012310133
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

It's still the last day of 2020 in the US/Pacific timezone, which means
it's time for me to patchbomb every new feature that's been sitting
around in my development trees!

Once a year I like to dump everything into the public archives to
increase XFS' bus factor.  However, there are 660 patches and 46 cover
letters across my three development trees, so this year I'm only sending
the guide and the cover letters.

Just like last year, this guide lists each feature branch that's merged
into the development tree, along with some notes to help readers figure
out the real dependencies between branches.

If you want to try out this code, you /really/ should pull from
kernel.org:

https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git

==============

The kernel tree contains the following branches:

 pwork-parallelism	("xfs: increase pwork parallelism")

Single patch to increase parallelism of background threads to handle
high-iops storage.  At this point in the branch the only piece to need
this is quotacheck, and I haven't been able to show that parallel
quotacheck is any faster due to the bottlenecks shifting to memory
reclaim, but deferred inode inactivation will want this.

 scrub-fixes		("xfs: more scrub fixes")

The usual pile of bug fixes and verification strengthening for scrub.

 reflink-speedups	("xfs: fix reflink inefficiencies")

This independent series cleans up some warts with bunmapi when reflink
is enabled, since we've now restructured various shortcomings in the
defer ops code and the log that made some dirty hacks unnecessary.

 repair-reap-fixes	("xfs: fix online repair block reaping")
 repair-bitmap-rework	("xfs: rework online repair incore bitmap")
 repair-prep-for-bulk-loading ("xfs: prepare repair for bulk loading")
 scrub-rtsummary	("xfs: online scrubbing of realtime summary files")
 repair-ag-btrees	("xfs: online repair of AG btrees")
 repair-inodes		("xfs: online repair of inodes and extent maps")
 repair-quota		("xfs: online repair of quota and counters")
 corruption-health-reports ("xfs: report corruption to the health trackers")

Here's the first part of online filesystem repair.  Since last year,
we've landed the btree bulk loading code, which shortened this story
arc by one.  However, I've also added the ability to check the realtime
summary metadata, and strengthened the rebuilder code to check the
sanity of the records it collects during a rebuild process.

 reclaim-space-harder	("xfs: try harder to reclaim space when we run out")
 eofblocks-consolidation ("xfs: consolidate posteof and cowblocks cleanup")
 deferred-inactivation	("xfs: deferred inode inactivation")

I think I'll send these three branches for the next kernel.  The third
branch implements deferred inode inactivation, which is to say that we
move all file deletion activities to background threads.  This makes
unlink calls return to userspace faster and should speed up mass
deletions since we now process inodes in disk order instead of deletion
order.  The first series makes ENOSPC space reclamation push the
filesystem harder so that it will behave the same after we push inode
inactivation to a background workqueue.  The second series combines
garbage collection of speculative post-EOF blocks and COW extents into a
single piece of code so that we can free up one radix tree tag bit.

(None of this code require online repair...)

 indirect-health-reporting ("xfs: indirect health reporting")

This series improves the metadata health reporting system so that it can
remember health problems for principal filesystem objects whose incore
representations had to be reclaimed.  In other words, the per-AG state
can remember the fact that an inode in that AG had problems, even if we
have to reclaim the xfs_inode for that broken file.

 repair-hard-problems	("xfs: online repair hard problems")

This branch contains harder repair problems, namely the ones that
require full filesystem scans.  These scans depend upon being able to
shut down background operations temporarily, which is we need deferred
inode inactivation (and part 1 of online repair) to solve these
problems.

 realtime-bmap-intents	("xfs: widen BUI formats to support rt")
 expand-bmap-intent-usage ("xfs: support attrfork and unwritten BUIs")
 atomic-file-updates	("xfs: atomic file updates")

A key part of the third installment of online filesystem repair will be
the ability to switch the contents of xattrs, directories, rt metadata,
and symbolic links atomically.  For this, I developed a new high-level
log operation to swap the extents of any two file forks and to resume
the swap even if the system goes down during the operation.  I also
wired this up to a userspace ioctl so that user programs can commit file
content updates atomically.

 repair-rtsummary	("xfs: online repair of realtime summaries")
 repair-xattrs		("xfs: online repair of extended attributes")
 repair-dirs		("xfs: online repair of directories")

This third piece of online filesystem repair builds upon the atomic
extent swap in the previous batch.  It enables us to rebuild file-based
metadata.

 inode-refactor		("xfs: hoist inode operations to libxfs")
 metadir		("xfs: metadata inode directories")

The first branch in this series hoists all the inode allocation and
freeing code to libxfs so that the second series can create arbitrary
directory trees for metadata.  This will also allow us to refactor all
of the similar but not identical code in userspace so that file
attributes can be inherited in a consistent manner when constructing a
filesystem from a protofile.

 btree-ifork-records	("xfs: refactor btrees to support records in inode root")
 btree-dynamic-depth	("xfs: support dynamic btree cursor height")

These three branches refactor the generic btree code to support using
inode root areas for btree records, which will be needed for realtime
rmap and reflink.

 refactor-rt-locking	("xfs: refactor realtime meta inode locking")
 reserve-rt-metadata-space ("xfs: enable in-core block reservation for rt metadata")

Once I started running fstests on rmap/reflink-enabled rt filesystems, I
noticed that I was running into weird deadlocks and space allocation
failure issues that happened with the original rmap and reflink
implementations.  The first series refactors locking of rt metadata so
that we can do it in a systematic way, and the second series extends the
per-AG allocation code to work on realtime devices too.

 realtime-extfree-intents ("xfs: widen EFI format to support rt")
 realtime-rmap		("xfs: realtime reverse-mapping support")

This series uses the metadata directory tree to add reverse mapping
abilities to the realtime device, and using that rmap data to
reconstruct realtime free space metadata.  It depends on the six
branches above.

 noalloc-ags		("xfs: noalloc allocation groups")

A quick branch I whipped up while exploring online filesystem shrink,
which gives us the ability to prevent allocations in an AG.  It doesn't
depend on any of the branches above it; this is just where it landed in
my development tree.

 realtime-reflink	("xfs: reflink on the realtime device")
 realtime-reflink-extsize ("xfs: reflink with large realtime extents")

This last series uses the metadata directory tree to create a new
refcount btree for the realtime device.  With that, we can support
reflink on realtime devices.  This requires every branch from
inode-refactor to reserve-rt-metadata-space.

==============

On the xfsprogs side of things, here are some significant branches that
I would like to highlight.  The branch groups do not depend on each other.

 xfs_db-directory-navigation ("xfs_db: add minimal directory navigation")

This branch adds directory navigation and directory listing abilities to
xfs_db.

 needsrepair		("xfs: add the ability to flag a fs for repair")
 fs-upgrades		("xfs_admin: support upgrading v5 filesystems")

These two branches enable sysadmins to add (some) new features to
existing V5 filesystems.

 repair-rebuild-forks	("xfs_repair: rebuild inode fork mappings")

This branch teaches xfs_repair to rebuild inode fork mappings from rmap
data.

 packaging-cleanups	("xfsprogs: packaging cleanups")
 bmap-utils		("xfsprogs: file write utility refactoring")

A couple of cleanups for userspace.

 scrub-iscan-rebalance	("xfs_scrub: improve balancing of threads for inode scan")

This is a major rework of inode scans in xfs_scrub.  The first branch
parallelises inode scans at a finer granularity -- now each worker
thread deals with an inobt record, and not an entire AG.  This reduces
the amount of pending scrub work that can stall behind a single large
fragmented file.

 xfs-scrub-fixes	("xfs_scrub: second fixes series")
 scrub-repair-data-deps	("xfs_scrub: track data dependencies for repairs")

These last two restructure how we track metadata repair activities so
that it is done on a per-fs principal (AGs, inodes) basis instead of
tracking each repair individually.  What this means is that we now
preserve ordering dependencies between repair types.  That makes us
smart enough not to try to repair a directory if the data bmbt is still
broken.

==============

Finally, here some significant branches awaiting review for fstests:

 fuzz-baseline		("xfstests: establish baseline for fuzz tests")
 fuzzer-improvements	("xfstests: improve xfs fuzzing")
 more-fuzz-testing	("xfstests: strengthen fuzz testing")

In these three branches, I rework the XFS metadata fuzz testing
infrastructure to provide /some/ sort of a baseline golden output, and
to be a bit more systematic about how it reports where it is in a fuzz
process.  I also rework the fuzz repair strategies so that they more
closely follow the known reaction cases (no repair at all; online repair
only; offline repair only; and online repair followed by offline repair
if needed).

 dmerror-on-rt-devices	("common/dm*: support external log and rt devices")

This makes it so that we can use dmerror and dmflakey for external log
and realtime devices.

With that, I hope you all have a happy new year!  See you in 2021!

--D
