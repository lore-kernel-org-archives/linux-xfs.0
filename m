Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q94FSwYQ162978 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 10:28:58 -0500
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id zYP9oqGxMRve9LP9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Oct 2012 08:30:23 -0700 (PDT)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.sc.tlinx.org (8.14.5/8.14.4/SuSE Linux 0.8) with ESMTP id
	q94FUKqF017579 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 08:30:22 -0700
Message-ID: <506DAB8C.9000601@tlinx.org>
Date: Thu, 04 Oct 2012 08:30:20 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: get filename->inode mappings in bulk for a live fs?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

I notice that attempts to use utils to get name->inode mappings
(xfs_ncheck) seem to have no option to operate on a mounted filesystem.

Is it practical to xfs_freeze such a file system and then ncheck it? or would
freezing it simply freeze the fact that it is open and provide no benefit?

So how can I get an inode->block mapping on a live fs.

I'm not worried about some smallish number of cases that might be inaccurate.

Out of ~5M files on my most populous volume, having even 1000 files w/wrong
info would be less than .02% -- which would be bad if I wanted an exact backup,
but for purposes a quick-fuzzy look at files that have changed and are finished
being changed (vs. the ones being changed right now),

The man page for xfs_freeze mentions using it to make snapshots -- how long
does such a snapshot usually take?  I.e. how long would a file system be frozen?
Is it something that would take a few ms, few seconds, or multiple minutes?

This may be a weird idea, but I seem to remember when lvm takes a snapshot
it moves the live volume aside and begins to use COW segments to hold changes.

Is it possible to xfs-freeze a COW copy so access to the original FS isn't
suspended thus making the time period of an xfs_freeze/dump_names less
critical?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
