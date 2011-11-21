Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pALCAnja257859 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 06:10:49 -0600
Received: from dmz-mailsec-scanner-7.mit.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 659A21D22F29
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 04:10:48 -0800 (PST)
Received: from dmz-mailsec-scanner-7.mit.edu (DMZ-MAILSEC-SCANNER-7.MIT.EDU
	[18.7.68.36]) by cuda.sgi.com with ESMTP id LEhYxdDhGSoCJzpz
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 04:10:48 -0800 (PST)
Subject: Re: [RFC][PATCH 0/8] xfstests: rework large filesystem testing
Mime-Version: 1.0 (Apple Message framework v1251.1)
From: Theodore Tso <tytso@mit.edu>
In-Reply-To: <1321875088-30801-1-git-send-email-david@fromorbit.com>
Date: Mon, 21 Nov 2011 07:10:45 -0500
Message-Id: <CF9FF112-852A-473B-99E4-3A5B790AE147@mit.edu>
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>, xfs@oss.sgi.com


On Nov 21, 2011, at 6:31 AM, Dave Chinner wrote:

> ext4, however, still has serious issues with this - either we take
> the mkfs.ext4 time hit to initialise all the block groups, or we
> take it during the preallocation.  IOWs, the "don't do work at mkfs
> but do it after mount" hack^Wtradeoff simply does not work for
> testing large filesystems in this manner.  While it is possible to
> run large filesystem tests on ext4 using this mechanism, it is
> extremely painful to do so.

For testing, we can disable the "do it after the mount " aspect
of  ext4 by using the mount option "noinit_itable".   We basically
only need to zero the inode table to make sure e2fsck doesn't
confuse old inode tables as new ones in the event that the block
group descriptors get compromised and we can't trust them to
determine the high watermark of inodes used per block group,
something which is only a concern in the case of kernel bugs
or hardware failures (or power failures in no journal mode).
(We could also compare the inode crime with the fs mkfs time
in the superblock, but ext4 gets used on desktops and
on things like android tablets where I've learned through
bitter experience that we can't trust the system clock to be
correct.) 

In any case it's safe to turn of the inode table initialization for
testing purposes.   In the long term, once we get checksums
into  the inode table block, we won't need to zero out the inode
tables at all.

As far as xfstests are concerned, if there's a convenient way
to add mount options automatically (on a per file system 
basis) when --large-fs is specified, we should be able to 
make this work for ext4 file systems.

Regards,

-- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
