Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35478 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752492AbcJORFH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 Oct 2016 13:05:07 -0400
Date: Sat, 15 Oct 2016 10:03:03 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] misc: fix fallocate commands that need the unshare
 switch
Message-ID: <20161015170303.GB11829@infradead.org>
References: <147646876990.19627.5046740854955682441.stgit@birch.djwong.org>
 <147646878237.19627.11366131824882808123.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147646878237.19627.11366131824882808123.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org

On Fri, Oct 14, 2016 at 11:13:02AM -0700, Darrick J. Wong wrote:
> We re-added the UNSHARE flag to fallocate, so go make sure that all
> the unshare tests actually check that the xfs_io falloc command
> supports that flag.

We'll need to improve _require_xfs_io_command to actually run the
command for this to work, otherwise this will fail if the fs supports
reflink but not unshared once xfs_io supports -u.

The poster child would be btrfs, and I would have added some output
here if btrfs support in xfstests wasn't completely broken at this
point.

Well, added Ccs and some output anyway in this case..

root@testvm:~/xfstests# mkfs.btrfs -f /dev/vdb
Btrfs v3.17
See http://btrfs.wiki.kernel.org for more information.

Turning ON incompat feature 'extref': increased hardlink limit per file
to 65536
[  243.592803] BTRFS: device fsid 364c6d95-eaae-43c9-b6bd-139e86206519
devid 1 transid 3 /dev/vdb
fs created label (null) on /dev/vdb
	nodesize 16384 leafsize 16384 sectorsize 4096 size 10.00GiB
root@testvm:~/xfstests# ./check -g quick
[  246.101606] BTRFS info (device vdb): disk space caching is enabled
[  246.102260] BTRFS info (device vdb): flagging fs with big metadata
feature
[  246.106123] BTRFS info (device vdb): creating UUID tree
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 testvm 4.8.0+
MKFS_OPTIONS  -- /dev/vdb
MOUNT_OPTIONS -- /dev/vdb /mnt/scratch

our local _scratch_mkfs routine ...
Error: /dev/vdb is mounted
check: failed to mkfs $SCRATCH_DEV using specified options
Passed all 0 tests
