Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6621A7F4E
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 16:50:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 02A59AC004
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 14:50:42 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	KEzIfZon9GThdRLY for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 14:50:40 -0700 (PDT)
Date: Tue, 30 Jun 2015 07:50:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: "Internal error xfs_attr3_leaf_write_verify at line 216",
	"directory flags set on non-directory inode" and other errors
Message-ID: <20150629215039.GF7943@dastard>
References: <FD7C5F18-48F3-461B-9604-0E3BDBB7AD69@intomics.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <FD7C5F18-48F3-461B-9604-0E3BDBB7AD69@intomics.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Rasmus Borup Hansen <rbh@intomics.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 24, 2015 at 09:39:45AM +0200, Rasmus Borup Hansen wrote:
> Hi! Yesterday I got the following error messages from the kernel (Ubuntu trusty, 3.13.0-55):
> 
> [601201.817664] ffff88016e03e000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
> [601201.818224] ffff88016e03e010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
> [601201.818827] ffff88016e03e020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [601201.819429] ffff88016e03e030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [601201.820013] XFS (dm-0): Internal error xfs_attr3_leaf_write_verify at line 216 of file /build/buildd/linux-3.13.0/fs/xfs/xfs_attr_leaf.c.  Caller 0xffffffffa00996f0

Probably fixed by commit c88547a ("xfs: fix directory hash ordering
bug"), which also affected attributes in leaf format.

> I'm currently running xfs_repair -n and so far I've seen the following output:
> 
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
> doubling cache size to 591200
> directory flags set on non-directory inode 206624
> directory flags set on non-directory inode 206625
> directory flags set on non-directory inode 206626
> directory flags set on non-directory inode 206627
> directory flags set on non-directory inode 206628
> directory flags set on non-directory inode 206629
> directory flags set on non-directory inode 206630
> directory flags set on non-directory inode 206631
> directory flags set on non-directory inode 206632
> directory flags set on non-directory inode 206633
> directory flags set on non-directory inode 206634
> 
> Only the first 20 lines are included. There are currently 250000+
> more lines with "directory flags set on non-directory inode" and
> the check is still running (the mostly small files take up around
> 30 TB, so it'll probably take a while).

Harmless, but repair will fix it anyway.

Kernel is fixed by commit 9336e3a ("xfs: project id inheritance is a
directory only flag").

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
