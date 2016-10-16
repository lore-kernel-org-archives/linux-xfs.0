Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41902 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbcJPGSk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 Oct 2016 02:18:40 -0400
Date: Sat, 15 Oct 2016 23:18:37 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] misc: fix fallocate commands that need the unshare
 switch
Message-ID: <20161016061837.GA12614@infradead.org>
References: <147646876990.19627.5046740854955682441.stgit@birch.djwong.org>
 <147646878237.19627.11366131824882808123.stgit@birch.djwong.org>
 <20161015170303.GB11829@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161015170303.GB11829@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org

On Sat, Oct 15, 2016 at 10:03:03AM -0700, Christoph Hellwig wrote:
> The poster child would be btrfs, and I would have added some output
> here if btrfs support in xfstests wasn't completely broken at this
> point.
> 
> Well, added Ccs and some output anyway in this case..

Turns out the btrfs failure was my stupidity, sorry.

I can reproduce the issue I was going to originally show (which was
actually pointed out by Eric for a different fallocate flag check
I wanted to add), here is the diff of the output files when running
generic/156 on btrfs with your patch:

--- tests/generic/156.out	2016-03-29 13:59:30.411720622 +0000
+++ /root/xfstests/results//generic/156.out.bad	2016-10-16 06:15:27.118776421 +0000
@@ -2,8 +2,13 @@
 Create the original file blocks
 Create the reflink copies
 funshare part of a file
+fallocate: Operation not supported
 funshare some of the copies
+fallocate: Operation not supported
+fallocate: Operation not supported
 funshare the rest of the files
+fallocate: Operation not supported
+fallocate: Operation not supported
 Rewrite the original file
 free blocks after reflinking is in range
 free blocks after nocow'ing some copies is in range

So what we really need an enhanced falloc tester that checks that
the tested subcommand is actually implemented on the given file system.
(And we already need something like that for -k on NFS)
